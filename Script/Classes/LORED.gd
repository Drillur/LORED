class_name LORED
extends RefCounted



var saved_vars := [
	"unlocked",
	"purchased",
	"level",
	#asleep - based on an option, append or erase this from this array
]

func load_started() -> void:
	stop_job()


func load_finished() -> void:
	if unlocked:
		emit_signal("just_unlocked")
	set_level_to(level)
	if purchased:
		#emit_signal("leveled_up", level)
		for currency in produced_currencies:
			wa.unlock_currency(currency)
		work()



enum Type {
	STONE, # 0
	COAL,
	IRON_ORE,
	COPPER_ORE,
	IRON,
	COPPER,
	GROWTH,
	JOULES,
	CONCRETE,
	MALIGNANCY,
	TARBALLS,
	OIL,
	
	WATER, # 12
	HUMUS,
	SEEDS,
	TREES,
	SOIL,
	AXES,
	WOOD,
	HARDWOOD,
	LIQUID_IRON, # 20
	STEEL,
	SAND,
	GLASS,
	DRAW_PLATE,
	WIRE,
	GALENA,
	LEAD,
	PETROLEUM,
	WOOD_PULP,
	PAPER, # 30
	PLASTIC,
	TOBACCO,
	CIGARETTES,
	CARCINOGENS,
	TUMORS,
	
	WITCH, # 36
	# put s3 loreds here
	BLOOD, # leave BLOOD at the bottom. see: init_stage()
	
	# put s4 loreds here
}
enum ReasonCannotWork {
	CAN_WORK,
	UNKNOWN,
	INSUFFICIENT_FUEL,
	INSUFFICIENT_CURRENCIES,
}

signal became_unable_to_work
signal completed_job
signal stopped_working
signal began_working
signal leveled_up(level)
signal went_to_sleep
signal woke_up
signal asleep_changed(asleep)
signal sleep_just_enqueued
signal sleep_just_dequeued
signal just_unlocked
signal just_locked
signal purchased_changed(purchased)
signal just_purchased
signal job_started(job)
signal finished_emoting
signal spent_one_second_asleep


var killed := false

var type: int
var stage: int
var last_job: Job
var times_purchased := 0:
	set(val):
		times_purchased = val
		if val == 1:
			first_purchase()
var primary_currency: int
var fuel_currency: int
var time_spent_asleep := 0.0
var reason_cannot_work := 0

var produced_currencies := []
var required_currencies := []
var upgrades := []
var unpurchased_upgrades := []
var emote_queue := []

var unlocked := false:
	set(val):
		if unlocked != val:
			unlocked = val
			if val:
				lv.lored_unlocked(type)
				emit_signal("just_unlocked")
				saved_vars.append("fuel")
				saved_vars.append("asleep")
				saved_vars.append("times_purchased")
				saved_vars.append("time_spent_asleep")
			else:
				lv.lored_locked(type)
				emit_signal("just_locked")
				saved_vars.erase("fuel")
				saved_vars.erase("asleep")
				saved_vars.erase("times_purchased")
				saved_vars.erase("time_spent_asleep")

var purchased := false:
	set(val):
		if purchased != val:
			purchased = val
			if val:
				lv.lored_became_active(type)
				emit_signal("just_purchased")
			else:
				lv.lored_became_inactive(type)
			emit_signal("purchased_changed", val)
var working := false
var asleep := false:
	set(val):
		if asleep != val:
			asleep = val
			if val:
				time_went_to_bed = Time.get_unix_time_from_system()
				lv.lored_went_to_sleep(type)
				emit_signal("went_to_sleep")
			else:
				if time_went_to_bed != 0:
					calculate_time_in_bed()
				lv.lored_woke_up(type)
				emit_signal("woke_up")
			emit_signal("asleep_changed", asleep)
var time_went_to_bed := 0.0
var current_fuel_rate_added := false
var total_fuel_rate_added := false
var emoting := false:
	set(val):
		if emoting != val:
			emoting = val
			if val:
				pass
			else:
				emit_signal("finished_emoting")
var last_purchase_automatic := false
var last_purchase_forced := false

var key: String
var name := ""
var colored_name := ""
var description := ""
var pronoun_he := "he"
var pronoun_him := "him"
var pronoun_his := "his"
var pronoun_man := "man"
var pronoun_boy := "boy"

var color: Color
var color_text: String
var faded_color: Color

var icon: Texture
var default_frames: SpriteFrames
var icon_text: String
var icon_and_name_text: String

var cost: Cost
var cost_increase := Value.new(3)

var has_vico := false
var vico: LOREDVico:
	set(val):
		vico = val
		has_vico = true

var jobs := {}
var sorted_jobs := []

var level := 0:
	set(val):
		if level == val:
			return
		level = val
		emit_signal("leveled_up", level)
var fuel: Attribute
var fuel_cost: Value
var output := Value.new(1)
var input := Value.new(1)
var haste := Value.new(1)
var crit := Value.new(0)



func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	
	call("init_" + key)
	
	required_currencies.append(fuel_currency)
	add_job(Job.Type.REFUEL)
	
	if name == "":
		name = key.replace("_", " ").capitalize()
	colored_name = "[color=#" + color.to_html() + "]" + name + "[/color]"
	if faded_color == Color(0,0,0,1):
		faded_color = color
	color_text = "[color=#" + color.to_html() + "]%s[/color]"
	
	connect("began_working", add_current_fuel_rate)
	connect("stopped_working", subtract_current_fuel_rate)
	connect("woke_up", work)
	connect("completed_job", work)
	
	SaveManager.connect("load_finished", load_finished)
	SaveManager.connect("load_started", load_started)
	SaveManager.connect("load_started", clear_emote_queue)
	
	# stage and fuel
	if type <= Type.OIL:
		stage = 1
	elif type <= Type.TUMORS:
		stage = 2
	elif type <= Type.BLOOD:
		stage = 3
	else:
		stage = 4
	
	# fuel cost
	if stage in [1, 2]:
		var job = jobs.values()[0] as Job
		var base_fuel_cost = 0.1
		if job.has_required_currencies:
			base_fuel_cost += (0.05 * job.required_currencies.cost.size())
		var modifier = 1 if fuel_currency == Currency.Type.COAL else 2
		fuel_cost = Value.new(base_fuel_cost * modifier)
	else:
		fuel_cost = Value.new(0.5)
	
	if type in [Type.MALIGNANCY, Type.TUMORS]:
		fuel_cost = Value.new(0.5 * stage)
	fuel = Attribute.new(Big.new(fuel_cost.get_value()).m(100))
	if type == Type.STONE:
		fuel.change_base(1.0)
		fuel.reset()
	
	level = 0
	
	icon_text = "[img=<15>]" + icon.get_path() + "[/img]"
	icon_and_name_text = icon_text + " " + colored_name
	
	sort_jobs()



func init_STONE() -> void:
	add_job(Job.Type.STONE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(25.0 / 3),
		Currency.Type.COPPER: Value.new(15.0 / 3),
	})
	color = Color(0.79, 0.79, 0.79)
	faded_color = Color(0.788235, 0.788235, 0.788235)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/stone.png")
	description = "Likes rocks. Has a bottomless bag."
	primary_currency = Currency.Type.STONE


func init_COAL() -> void:
	add_job(Job.Type.COAL)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(5),
	})
	color = Color(0.7, 0, 1)
	faded_color = Color(0.9, 0.3, 1)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/coal.png")
	description = "Plays support in every game."
	primary_currency = Currency.Type.COAL


func init_IRON_ORE() -> void:
	add_job(Job.Type.IRON_ORE)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(8),
	})
	color = Color(0, 0.517647, 0.905882)
	faded_color = Color(0.5, 0.788732, 1)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/irono.png")
	description = "Is actually evil."
	primary_currency = Currency.Type.IRON_ORE


func init_COPPER_ORE() -> void:
	add_job(Job.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(8),
	})
	color = Color(0.7, 0.33, 0)
	faded_color = Color(0.695313, 0.502379, 0.334076)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/copo.png")
	description = "Trapped in a dead-end job. Literally."
	primary_currency = Currency.Type.COPPER_ORE


func init_IRON() -> void:
	add_job(Job.Type.IRON)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(9),
		Currency.Type.COPPER: Value.new(8),
	})
	color = Color(0.07, 0.89, 1)
	faded_color = Color(0.496094, 0.940717, 1)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/iron.png")
	description = "Wants everyone to succeed."
	primary_currency = Currency.Type.IRON


func init_COPPER() -> void:
	add_job(Job.Type.COPPER)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(9),
		Currency.Type.IRON: Value.new(8),
	})
	color = Color(1, 0.74, 0.05)
	faded_color = Color(1, 0.862001, 0.496094)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/cop.png")
	description = "Loves s'mores."
	primary_currency = Currency.Type.COPPER


func init_GROWTH() -> void:
	add_job(Job.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(900),
	})
	color = Color(0.79, 1, 0.05)
	faded_color = Color(0.890041, 1, 0.5)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/growth.png")
	description = "Is in an unfortunate situation."
	primary_currency = Currency.Type.GROWTH


func init_JOULES() -> void:
	add_job(Job.Type.JOULES)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(25),
	})
	color = Color(1, 0.98, 0)
	faded_color = Color(1, 0.9572, 0.503906)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/jo.png")
	description = "Follows Tesla on [s]Twitter[/s] X."
	primary_currency = Currency.Type.JOULES


func init_CONCRETE() -> void:
	add_job(Job.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(90),
		Currency.Type.COPPER: Value.new(150),
	})
	color = Color(0.35, 0.35, 0.35)
	faded_color = Color(0.6, 0.6, 0.6)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/conc.png")
	description = "Laughs about everything."
	primary_currency = Currency.Type.CONCRETE


func init_OIL() -> void:
	add_job(Job.Type.OIL)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(160),
		Currency.Type.CONCRETE: Value.new(250),
	})
	color = Color(0.65, 0.3, 0.66)
	faded_color = Color(0.647059, 0.298039, 0.658824)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/oil.png")
	description = "Is a big baby."
	primary_currency = Currency.Type.OIL


func init_TARBALLS() -> void:
	add_job(Job.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(350),
		Currency.Type.MALIGNANCY: Value.new(10),
	})
	color = Color(0.56, 0.44, 1)
	faded_color = Color(0.560784, 0.439216, 1)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/tar.png")
	description = "Quiet science guy."
	primary_currency = Currency.Type.TARBALLS


func init_MALIGNANCY() -> void:
	add_job(Job.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(900),
		Currency.Type.COPPER: Value.new(900),
		Currency.Type.CONCRETE: Value.new(50),
	})
	color = Color(0.88, 0.12, 0.35)
	faded_color = Color(0.882353, 0.121569, 0.352941)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/malig.png")
	description = "Infinite clones."
	primary_currency = Currency.Type.MALIGNANCY


func init_WATER() -> void:
	add_job(Job.Type.WATER)
	name = "Gatorade"
	cost = Cost.new({
		Currency.Type.STONE: Value.new(2500),
		Currency.Type.WOOD: Value.new(80),
	})
	color = Color(0, 0.647059, 1)
	faded_color = Color(0.570313, 0.859009, 1)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/water.png")
	description = "Likes his pool."
	primary_currency = Currency.Type.WATER


func init_HUMUS() -> void:
	add_job(Job.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(600),
		Currency.Type.COPPER: Value.new(600),
		Currency.Type.GLASS: Value.new(30),
	})
	color = Color(0.458824, 0.25098, 0)
	faded_color = Color(0.6, 0.3, 0)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/humus.png")
	description = "The shittest character in the game."
	primary_currency = Currency.Type.HUMUS


func init_SOIL() -> void:
	add_job(Job.Type.SOIL)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(1000),
		Currency.Type.HARDWOOD: Value.new(40),
	})
	color = Color(0.737255, 0.447059, 0)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/soil.png")
	description = "#note."
	primary_currency = Currency.Type.SOIL
	set_female_pronouns()


func init_TREES() -> void:
	add_job(Job.Type.TREES)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(150),
		Currency.Type.SOIL: Value.new(25),
	})
	color = Color(0.772549, 1, 0.247059)
	faded_color = Color(0.864746, 0.988281, 0.679443)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/tree.png")
	description = "God-mode."
	primary_currency = Currency.Type.TREES


func init_SEEDS() -> void:
	add_job(Job.Type.SEEDS)
	name = "Maybe"
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(800),
		Currency.Type.TREES: Value.new(2),
	})
	color = Color(1, 0.878431, 0.431373)
	faded_color = Color(.8,.8,.8)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/seed.png")
	description = "Keeps beesy."
	primary_currency = Currency.Type.SEEDS


func init_GALENA() -> void:
	add_job(Job.Type.GALENA)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(1100),
		Currency.Type.WIRE: Value.new(200),
	})
	color = Color(0.701961, 0.792157, 0.929412)
	faded_color = Color(0.701961, 0.792157, 0.929412)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/gale.png")
	description = "#note."
	primary_currency = Currency.Type.GALENA


func init_LEAD() -> void:
	add_job(Job.Type.LEAD)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(400),
		Currency.Type.GROWTH: Value.new(800),
	})
	color = Color(0.53833, 0.714293, 0.984375)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/lead.png")
	description = "#note."
	primary_currency = Currency.Type.LEAD


func init_WOOD_PULP() -> void:
	add_job(Job.Type.WOOD_PULP)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new(15),
		Currency.Type.GLASS: Value.new(30),
	})
	color = Color(0.94902, 0.823529, 0.54902)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/pulp.png")
	description = "#note."
	primary_currency = Currency.Type.WOOD_PULP


func init_PAPER() -> void:
	add_job(Job.Type.PAPER)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(1200),
		Currency.Type.STEEL: Value.new(15),
	})
	color = Color(0.792157, 0.792157, 0.792157)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/paper.png")
	description = "Was in the boy scouts for 25 years."
	primary_currency = Currency.Type.PAPER


func init_TOBACCO() -> void:
	add_job(Job.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.SOIL: Value.new(3),
		Currency.Type.HARDWOOD: Value.new(15),
	})
	color = Color(0.639216, 0.454902, 0.235294)
	faded_color = Color(0.85, 0.75, 0.63)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/toba.png")
	description = "Thinks vapes are dangerous."
	primary_currency = Currency.Type.TOBACCO


func init_CIGARETTES() -> void:
	add_job(Job.Type.CIGARETTES)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new(50),
		Currency.Type.WIRE: Value.new(120),
	})
	color = Color(0.929412, 0.584314, 0.298039)
	faded_color = Color(0.97, 0.8, 0.6)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/ciga.png")
	description = "On his 45th smoke break this shift."
	primary_currency = Currency.Type.CIGARETTES


func init_PETROLEUM() -> void:
	add_job(Job.Type.PETROLEUM)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(3000),
		Currency.Type.COPPER: Value.new(4000),
		Currency.Type.GLASS: Value.new(130),
	})
	color = Color(0.76, 0.53, 0.14)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/pet.png")
	description = "#note."
	primary_currency = Currency.Type.PETROLEUM


func init_PLASTIC() -> void:
	add_job(Job.Type.PLASTIC)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(10000),
		Currency.Type.TARBALLS: Value.new(700),
	})
	color = Color(0.85, 0.85, 0.85)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/plast.png")
	description = "#note."
	primary_currency = Currency.Type.PLASTIC


func init_CARCINOGENS() -> void:
	add_job(Job.Type.CARCINOGENS)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(8500),
		Currency.Type.CONCRETE: Value.new(2000),
		Currency.Type.STEEL: Value.new(150),
		Currency.Type.LEAD: Value.new(800),
	})
	color = Color(0.772549, 0.223529, 0.192157)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/carc.png")
	description = "#note."
	primary_currency = Currency.Type.CARCINOGENS


func init_LIQUID_IRON() -> void:
	add_job(Job.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(30),
		Currency.Type.STEEL: Value.new(25),
	})
	color = Color(0.27, 0.888, .9)
	faded_color = Color(0.7, 0.94, .985)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/liq.png")
	description = "Likes soup."
	primary_currency = Currency.Type.LIQUID_IRON


func init_STEEL() -> void:
	add_job(Job.Type.STEEL)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(15000),
		Currency.Type.COPPER: Value.new(3000),
		Currency.Type.HARDWOOD: Value.new(35),
	})
	color = Color(0.607843, 0.802328, 0.878431)
	faded_color = Color(0.823529, 0.898039, 0.92549)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/steel.png")
	description = "Is as strong as Guts."
	primary_currency = Currency.Type.STEEL


func init_SAND() -> void:
	add_job(Job.Type.SAND)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(700),
		Currency.Type.COPPER: Value.new(2850),
	})
	color = Color(.87, .70, .45)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/sand.png")
	description = "Didn't get DisneyPlus-ed."
	primary_currency = Currency.Type.SAND
	set_female_pronouns()


func init_GLASS() -> void:
	add_job(Job.Type.GLASS)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(6000),
		Currency.Type.STEEL: Value.new(40),
	})
	color = Color(0.81, 0.93, 1.0)
	faded_color = Color(0.81, 0.93, 1.0)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/glass.png")
	description = "Vaporizes people for fun."
	primary_currency = Currency.Type.GLASS


func init_WIRE() -> void:
	add_job(Job.Type.WIRE)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(13000),
		Currency.Type.GLASS: Value.new(30),
	})
	color = Color(0.9, 0.6, 0.14)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/wire.png")
	description = "Loves her grandchildren."
	primary_currency = Currency.Type.WIRE
	set_female_pronouns()


func init_DRAW_PLATE() -> void:
	add_job(Job.Type.DRAW_PLATE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(900),
		Currency.Type.CONCRETE: Value.new(300),
		Currency.Type.WIRE: Value.new(20),
	})
	color = Color(0.333333, 0.639216, 0.811765)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/draw.png")
	description = "Can run really fast."
	primary_currency = Currency.Type.DRAW_PLATE


func init_AXES() -> void:
	add_job(Job.Type.AXES)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(1000),
		Currency.Type.HARDWOOD: Value.new(55),
	})
	color = Color(0.691406, 0.646158, 0.586075)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/axe.png")
	description = "IN THE YEAR 202070707020. I AM WAKAKO."
	primary_currency = Currency.Type.AXES


func init_WOOD() -> void:
	add_job(Job.Type.WOOD)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(4500),
		Currency.Type.WIRE: Value.new(15),
	})
	color = Color(0.545098, 0.372549, 0.015686)
	faded_color = Color(0.77, 0.68, 0.6)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/wood.png")
	description = "Is just Goku."
	primary_currency = Currency.Type.WOOD


func init_HARDWOOD() -> void:
	add_job(Job.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(3500),
		Currency.Type.CONCRETE: Value.new(350),
		Currency.Type.WIRE: Value.new(35),
	})
	color = Color(0.92549, 0.690196, 0.184314)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/hard.png")
	description = "Potentially problematic."
	primary_currency = Currency.Type.HARDWOOD


func init_TUMORS() -> void:
	add_job(Job.Type.TUMORS)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new(50),
		Currency.Type.WIRE: Value.new(150),
		Currency.Type.GLASS: Value.new(150),
		Currency.Type.STEEL: Value.new(100),
	})
	color = Color(1, .54, .54)
	fuel_currency = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/tum.png")
	description = "#note."
	primary_currency = Currency.Type.TUMORS


func init_WITCH() -> void:
	name = "Circe"
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new(50),
		Currency.Type.WIRE: Value.new(150),
		Currency.Type.GLASS: Value.new(150),
		Currency.Type.STEEL: Value.new(100),
	})
	color = Color(0.937255, 0.501961, 0.776471)
	fuel_currency = Currency.Type.COAL
	icon = preload("res://Sprites/upgrades/thewitchofloredelith.png")
	description = "Loves her garden. In good favor with Aurus."
	primary_currency = Currency.Type.FLOWER_SEED
	set_female_pronouns()


func init_BLOOD() -> void:
	name = "Charity"
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new(50),
		Currency.Type.WIRE: Value.new(150),
		Currency.Type.GLASS: Value.new(150),
		Currency.Type.STEEL: Value.new(100),
	})
	color = Color(1, 0, 0)
	faded_color = Color(1, 0.4, 0.4)
	icon = preload("res://Sprites/Currency/axe.png")
	description = "A stoic, hard-working healer."
	primary_currency = Currency.Type.BLOOD
	set_female_pronouns()



func add_job(_job: int) -> void:
	jobs[_job] = Job.new(_job) as Job
	if jobs.size() == 1:
		default_frames = jobs[_job].animation
	
	for cur in jobs[_job].get_produced_currencies():
		if not cur in produced_currencies:
			produced_currencies.append(cur)
	for cur in jobs[_job].get_required_currency_types():
		if not cur in required_currencies:
			required_currencies.append(cur)


func loreds_initialized() -> void:
	for job in jobs.values():
		job.assign_lored(type)
		
		output.connect("changed", job.lored_output_changed)
		haste.connect("changed", job.lored_haste_changed)
		fuel_cost.connect("changed", job.lored_fuel_cost_changed)
		if job.has_required_currencies:
			input.connect("changed", job.lored_input_changed)
			job.lored_input_changed()
		
		job.lored_output_changed()
		job.lored_haste_changed()
		job.lored_fuel_cost_changed()
		
		job.connect("became_workable", work)
		job.connect("completed", job_completed)
		job.connect("cut_short", job_cut_short)


func sort_jobs():
	sorted_jobs = []
	sorted_jobs = jobs.keys()
	sorted_jobs.sort()


func set_female_pronouns() -> void:
	pronoun_he = "her"
	pronoun_him = "she"
	pronoun_his = "hers"
	pronoun_man = "woman"
	pronoun_boy = "girl"


func attach_vico(_vico: LOREDVico) -> void:
	vico = _vico
	vico.attach_lored(self)



# - Signal Shit

func lored_vicos_ready() -> void:
	if purchased:
		work()


func add_current_fuel_rate() -> void:
	if not current_fuel_rate_added:
		current_fuel_rate_added = true
		wa.add_current_loss_rate(fuel_currency, fuel_cost.get_value())


func subtract_current_fuel_rate() -> void:
	if current_fuel_rate_added:
		current_fuel_rate_added = false
		wa.subtract_current_loss_rate(fuel_currency, fuel_cost.get_value())


func add_total_fuel_rate() -> void:
	if not total_fuel_rate_added:
		total_fuel_rate_added = true
		wa.add_total_loss_rate(fuel_currency, fuel_cost.get_value())


func subtract_total_fuel_rate() -> void:
	if total_fuel_rate_added:
		total_fuel_rate_added = false
		wa.subtract_total_loss_rate(fuel_currency, fuel_cost.get_value())



# - Signals

func clear_emote_queue() -> void:
	emote_queue.clear()




# - Actions

func reset():
	level = 0
	output.reset()
	input.reset()
	haste.reset()
	fuel.reset()
	fuel_cost.reset()
	cost.reset()
	set_level_to(0)
	#purchased = true if type == Type.STONE else false



func kill() -> void:
	killed = true
	for job in jobs.values():
		job.disconnect("became_workable", work)
		job.disconnect("completed", job_completed)
		job.disconnect("cut_short", job_cut_short)
		job.kill()
	jobs.clear()
	cost.kill()
	disconnect("began_working", add_current_fuel_rate)
	disconnect("stopped_working", subtract_current_fuel_rate)
	disconnect("woke_up", work)
	disconnect("completed_job", work)



func force_purchase() -> void:
	last_purchase_automatic = true
	last_purchase_forced = true
	purchase()


func manual_purchase() -> void:
	last_purchase_automatic = false
	last_purchase_forced = false
	cost.spend(true)
	purchase()


func automatic_purchase() -> void:
	last_purchase_automatic = true
	last_purchase_forced = false
	cost.spend(true)
	purchase()


func purchase() -> void:
	if unlocked:
		times_purchased += 1
		level_up()
		first_purchase()


func first_purchase() -> void:
	if not purchased:
		purchased = true
		wa.unlock_currencies(produced_currencies)
		work()


func level_up() -> void:
	set_level_to(level + 1)


func set_level_to(_level: int) -> void:
	cost.increase(_level, cost_increase.get_as_float())
	output.set_from_level(Big.new(2).power(_level - 1))
	input.set_from_level(Big.new(2).power(_level - 1))
	var fuel_percent = fuel.get_current_percent()
	fuel.set_from_level(Big.new(2).power(_level - 1))
	fuel.set_to_percent(fuel_percent)
	
	if working:
		subtract_current_fuel_rate()
	subtract_total_fuel_rate()
	fuel_cost.set_from_level(Big.new(2).power(_level - 1))
	if working:
		add_current_fuel_rate()
	if purchased:
		add_total_fuel_rate()
	
	level = _level



func unlock() -> void:
	unlocked = true



func enqueue_sleep() -> void:
	if asleep or is_connected("completed_job", go_to_sleep):
		return
	emit_signal("sleep_just_enqueued")
	if working:
		connect("completed_job", go_to_sleep)
	else:
		go_to_sleep()


func go_to_sleep() -> void:
	asleep = true
	emit_signal("stopped_working")
	if is_connected("completed_job", go_to_sleep):
		disconnect("completed_job", go_to_sleep)


func dequeue_sleep() -> void:
	if asleep:
		wake_up()
	else:
		emit_signal("sleep_just_dequeued")
		if is_connected("completed_job", go_to_sleep):
			disconnect("completed_job", go_to_sleep)


func wake_up() -> void:
	asleep = false
	emit_signal("woke_up")
	if is_connected("completed_job", go_to_sleep):
		disconnect("completed_job", go_to_sleep)


func calculate_time_in_bed() -> void:
	var time_in_bed = Time.get_unix_time_from_system() - time_went_to_bed
	time_spent_asleep += time_in_bed
	time_went_to_bed = 0.0




func emote_now(emote: Emote) -> void:
	emoting = true
	vico.emote(emote)
	emote.connect("finished", emote_finished)


func emote_finished(_emote: Emote) -> void:
	emoting = false



func add_influencing_upgrade(upgrade: int) -> void:
	if not upgrade in upgrades:
		upgrades.append(upgrade)
		up.get_upgrade(upgrade).connect("purchased_changed", influencing_upgrade_purchased_changed)
		influencing_upgrade_purchased_changed(up.get_upgrade(upgrade))


func influencing_upgrade_purchased_changed(upgrade: Upgrade) -> void:
	if upgrade.purchased:
		unpurchased_upgrades.erase(upgrade.type)
	else:
		if not upgrade.type in unpurchased_upgrades:
			unpurchased_upgrades.append(upgrade.type)



func enqueue_emote(emote: Emote) -> void:
	emote_queue.append(emote)
	if not is_connected("finished_emoting", emote_next_in_line):
		connect("finished_emoting", emote_next_in_line)


func emote_next_in_line() -> void:
	if emoting:
		return
	
	if emote_queue.size() > 0:
		var emote: Emote = emote_queue[emote_queue.size() - 1]
		em.emote_now(emote)
		emote_queue.erase(emote)
		if emote_queue.size() > 0:
			return
	
	if is_connected("finished_emoting", emote_next_in_line):
		disconnect("finished_emoting", emote_next_in_line)



# - Job

func work(job_type: int = get_next_job_automatically()) -> void:
	if not purchased or not unlocked:
		return
	if working or will_go_to_sleep():
		return
	if job_type > -1:
		start_job(job_type)
	else:
		if type == Type.COAL:
			var cur_fuel = fuel.get_current()
			if cur_fuel.greater_equal(jobs[Job.Type.COAL].get_fuel_cost()):
				start_job(Job.Type.COAL)
			else:
				start_job(Job.Type.REFUEL)
		else:
			determine_why_cannot_work()


func get_next_job_automatically() -> int:
	for _type in sorted_jobs:
		var job: Job = jobs[_type]
		if job.can_start():
			return _type
	return -1


func start_job(_type: int) -> void:
	reason_cannot_work = ReasonCannotWork.CAN_WORK
	working = true
	last_job = jobs[_type]
	last_job.start()
	if vico == null:
		return
	vico.start_job(last_job)
	emit_signal("began_working")
	emit_signal("job_started", last_job)


func stop_job() -> void:
	if working:
		last_job.stop()
	working = false


func job_completed() -> void:
	working = false
	vico.job_completed()
	emit_signal("completed_job")


func job_cut_short() -> void:
	working = false



func determine_why_cannot_work() -> void:
	if fuel.get_current_percent() <= lv.FUEL_DANGER:
		cannot_work(ReasonCannotWork.INSUFFICIENT_FUEL)
	elif jobs[sorted_jobs[1]].has_required_currencies:
		cannot_work(ReasonCannotWork.INSUFFICIENT_CURRENCIES)
	else:
		cannot_work(ReasonCannotWork.UNKNOWN)
	emit_signal("stopped_working")


func cannot_work(reason: int) -> void:
	if reason == ReasonCannotWork.CAN_WORK:
		return
	reason_cannot_work = reason
	match reason:
		ReasonCannotWork.INSUFFICIENT_FUEL:
			vico.set_status_and_currency(
				"Awaiting " + wa.get_icon_and_name_text(fuel_currency) + ".",
				 fuel_currency
			)
		ReasonCannotWork.INSUFFICIENT_CURRENCIES:
			if stage in [1, 2]:
				var job_name = jobs[sorted_jobs[1]].name
				vico.set_status_and_currency("Will %s ASAP!" % job_name, primary_currency)
			else:
				vico.set_status_and_currency("Cannot work!", primary_currency)
	emit_signal("became_unable_to_work")



# - Wish

var wished_upgrade: int
var wished_currency: int

func get_wish() -> String:
	randomize()
	
	var possible_types := {
		"LORED_LEVELED_UP": 5,
		"SLEEP": 5,
	}
	
	var total_weight := 10
	
	if fuel.get_current_percent() < lv.FUEL_DANGER and df.fuel.less_equal(2):
		if randi() % 100 < 30:
			possible_types["ACCEPTABLE_FUEL"] = 50
		else:
			wished_currency = fuel_currency
			possible_types["COLLECT_CURRENCY"] = 50
		total_weight += 50
	elif reason_cannot_work != ReasonCannotWork.CAN_WORK and required_currencies.size() > 1:
		wished_currency = required_currencies[randi() % (required_currencies.size() - 1) + 1]
		possible_types["COLLECT_CURRENCY"] = 50
		total_weight += 50
	else:
		if wi.random_wish_limit >= 2 and randi() % 100 < 10:
			wished_currency = Currency.Type.JOY
			possible_types["COLLECT_CURRENCY"] = 10
			total_weight += 10
		else:
			wished_currency = wa.get_random_unlocked_currency()
			possible_types["COLLECT_CURRENCY"] = 30
			total_weight += 30
	
	for upgrade in unpurchased_upgrades:
		var upgrade_eta = up.get_eta(upgrade)
		if upgrade_eta.equal(0):
			continue
		if up.is_upgrade_unlocked(upgrade) and upgrade_eta.less_equal(60):
			wished_upgrade = upgrade
			possible_types["UPGRADE_PURCHASED"] = 30
			total_weight += 30
			break
	
	
	var roll := randi() % total_weight
	
	var shuffled_possible_types := possible_types.keys()
	shuffled_possible_types.shuffle()
	
	for i in possible_types.size():
		if roll < possible_types[shuffled_possible_types[i]]:
			return shuffled_possible_types[i]
		roll -= possible_types[shuffled_possible_types[i]]
	
	print_debug("This rly shouldn't have happened")
	return "Stinky"



# - Get

func will_go_to_sleep() -> bool:
	if asleep:
		return true
	return is_connected("completed_job", go_to_sleep)


func is_visible() -> bool:
	if lv.lored_container.current_tab + 1 != stage:
		return false
	return vico.visible


func can_afford() -> bool:
	return cost.affordable


func get_level_text() -> String:
	return str(level)


func get_next_level_text() -> String:
	return str(level + 1)


func get_output() -> Big:
	return output.get_value()


func get_output_text() -> String:
	return output.get_text()


func get_next_output_text() -> String:
	return Big.new(output.get_value()).m(2).text


func get_input() -> Big:
	return input.get_value()


func get_input_text() -> String:
	return input.get_text()


func get_next_input_text() -> String:
	return Big.new(input.get_value()).m(2).text


func get_haste() -> Big:
	return haste.get_value()


func get_haste_text() -> String:
	return haste.get_text()


func get_fuel_cost() -> Big:
	return fuel_cost.get_value()


func get_fuel_cost_text() -> String:
	return fuel_cost.get_text()


func get_next_fuel_cost_text() -> String:
	return Big.new(fuel_cost.get_value()).m(2).text


func get_max_fuel_text() -> String:
	return fuel.get_total_text()


func get_next_max_fuel_text() -> String:
	return Big.new(fuel.get_total()).m(2).text


func get_crit() -> Big:
	return crit.get_value()


func get_crit_text() -> String:
	return crit.get_text()


func get_attributes_by_currency(currency_type: int) -> Array:
	var arr := []
	for job in jobs.values():
		arr += job.get_attributes_by_currency(currency_type)
	return arr


func get_job_that_produces_currency(cur: int) -> Job:
	for job in jobs.values():
		if job.produces_currency(cur):
			return job
	print_debug("why and how")
	return Job.new(0)
