class_name LORED
extends Resource



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

var TYPE_KEYS := Type.keys()

signal became_unable_to_work
signal a_job_opened_up
signal completed_job
signal stopped_working
signal began_working
signal leveled_up(level)
signal went_to_sleep
signal woke_up
signal plan_to_sleep
signal just_unlocked
signal second_passed_while_asleep
signal finished_emoting
signal purchased_changed(purchased)
signal job_started(job)

var type: int
var stage: int
var next_job_type := -1
var last_job_type := -1
var last_job: Job
var times_purchased := 0
var primary_currency: int
var fuel_currency_type: int
var fuel_currency: Currency
var time_spent_asleep := 0.0
var reason_cannot_work := 0
var pending_attribute_changes := 0

var produced_currencies := []
var required_currencies := []
var upgrades := []
var unpurchased_upgrades := []

var unlocked := false
var purchased := false:
	set(val):
		if purchased == val:
			return
		purchased = val
		if val:
			lv.active.append(self)
			if not asleep:
				lv.active_and_awake.append(self)
		else:
			lv.active.erase(self)
			if self in lv.active_and_awake:
				lv.active_and_awake.erase(self)
		emit_signal("purchased_changed", val)
var working := false
var looking_for_jobs := false
var asleep := false
var will_go_to_sleep := false
var time_went_to_bed: float
var fuel_rate_added := false
var emoting := false

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
var faded_color: Color

var icon: Texture
var default_frames: SpriteFrames
var icon_text: String
var icon_and_name_text: String

var cost: Cost
var cost_increase := Attribute.new(3, false)

var has_vico := false
var vico: LOREDVico

var jobs := {}
var sorted_jobs := []

var level: Attribute
var fuel: Attribute
var fuel_cost: Attribute
var output := Attribute.new(1, false)
var input := Attribute.new(1, false)
var haste := Attribute.new(1, false)
var crit := Attribute.new(0, false)



func _init(_type: int) -> void:
	type = _type
	key = TYPE_KEYS[type]
	
	call("init_" + key)
	
	fuel_currency = wa.get_currency(fuel_currency_type)
	required_currencies.append(fuel_currency)
	add_job(Job.Type.REFUEL)
	
	if name == "":
		name = key.replace("_", " ").capitalize()
	colored_name = "[color=#" + color.to_html() + "]" + name + "[/color]"
	if faded_color == Color(0,0,0,1):
		faded_color = color
	
	connect("completed_job", start_working)
	connect("began_working", add_fuel_rate)
	connect("stopped_working", subtract_fuel_rate)
	
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
		var modifier = 1 if fuel_currency_type == Currency.Type.COAL else 2
		fuel_cost = Attribute.new(base_fuel_cost * modifier, false)
	else:
		fuel_cost = Attribute.new(0.5, false)
	
	if type in [Type.MALIGNANCY, Type.TUMORS]:
		fuel_cost = Attribute.new(0.5 * stage, false)
	fuel = Attribute.new(Big.new(fuel_cost.get_value()).m(100))
	if type == Type.STONE:
		fuel.change_base(1.0)
		fuel.reset()
	
	level = Attribute.new(0, false)
	
	icon_text = "[img=<15>]" + icon.get_path() + "[/img]"
	icon_and_name_text = icon_text + " " + colored_name
	
	sort_jobs()



func init_STONE() -> void:
	add_job(Job.Type.STONE)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(25.0 / 3, false),
		Currency.Type.COPPER: Attribute.new(15.0 / 3, false),
	})
	color = Color(0.79, 0.79, 0.79)
	faded_color = Color(0.788235, 0.788235, 0.788235)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/stone.png")
	description = "Likes rocks. Has a bottomless bag."
	primary_currency = Currency.Type.STONE


func init_COAL() -> void:
	add_job(Job.Type.COAL)
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(5, false),
	})
	color = Color(0.7, 0, 1)
	faded_color = Color(0.9, 0.3, 1)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/coal.png")
	description = "Plays support in every game."
	primary_currency = Currency.Type.COAL


func init_IRON_ORE() -> void:
	add_job(Job.Type.IRON_ORE)
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(8, false),
	})
	color = Color(0, 0.517647, 0.905882)
	faded_color = Color(0.5, 0.788732, 1)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/irono.png")
	description = "Is actually evil."
	primary_currency = Currency.Type.IRON_ORE


func init_COPPER_ORE() -> void:
	add_job(Job.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(8, false),
	})
	color = Color(0.7, 0.33, 0)
	faded_color = Color(0.695313, 0.502379, 0.334076)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/copo.png")
	description = "Trapped in a dead-end job. Literally."
	primary_currency = Currency.Type.COPPER_ORE


func init_IRON() -> void:
	add_job(Job.Type.IRON)
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(9, false),
		Currency.Type.COPPER: Attribute.new(8, false),
	})
	color = Color(0.07, 0.89, 1)
	faded_color = Color(0.496094, 0.940717, 1)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/iron.png")
	description = "Wants everyone to succeed."
	primary_currency = Currency.Type.IRON


func init_COPPER() -> void:
	add_job(Job.Type.COPPER)
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(9, false),
		Currency.Type.IRON: Attribute.new(8, false),
	})
	color = Color(1, 0.74, 0.05)
	faded_color = Color(1, 0.862001, 0.496094)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/cop.png")
	description = "Loves s'mores."
	primary_currency = Currency.Type.COPPER


func init_GROWTH() -> void:
	add_job(Job.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(900, false),
	})
	color = Color(0.79, 1, 0.05)
	faded_color = Color(0.890041, 1, 0.5)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/growth.png")
	description = "Is in an unfortunate situation."
	primary_currency = Currency.Type.GROWTH


func init_JOULES() -> void:
	add_job(Job.Type.JOULES)
	cost = Cost.new({
		Currency.Type.CONCRETE: Attribute.new(25, false),
	})
	color = Color(1, 0.98, 0)
	faded_color = Color(1, 0.9572, 0.503906)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/jo.png")
	description = "Follows Tesla on [s]Twitter[/s] X."
	primary_currency = Currency.Type.JOULES


func init_CONCRETE() -> void:
	add_job(Job.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(90, false),
		Currency.Type.COPPER: Attribute.new(150, false),
	})
	color = Color(0.35, 0.35, 0.35)
	faded_color = Color(0.6, 0.6, 0.6)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/conc.png")
	description = "Laughs about everything."
	primary_currency = Currency.Type.CONCRETE


func init_OIL() -> void:
	add_job(Job.Type.OIL)
	cost = Cost.new({
		Currency.Type.COPPER: Attribute.new(160, false),
		Currency.Type.CONCRETE: Attribute.new(250, false),
	})
	color = Color(0.65, 0.3, 0.66)
	faded_color = Color(0.647059, 0.298039, 0.658824)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/oil.png")
	description = "Is a big baby."
	primary_currency = Currency.Type.OIL


func init_TARBALLS() -> void:
	add_job(Job.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(350, false),
		Currency.Type.MALIGNANCY: Attribute.new(10, false),
	})
	color = Color(0.56, 0.44, 1)
	faded_color = Color(0.560784, 0.439216, 1)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/tar.png")
	description = "Quiet science guy."
	primary_currency = Currency.Type.TARBALLS


func init_MALIGNANCY() -> void:
	add_job(Job.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(900, false),
		Currency.Type.COPPER: Attribute.new(900, false),
		Currency.Type.CONCRETE: Attribute.new(50, false),
	})
	color = Color(0.88, 0.12, 0.35)
	faded_color = Color(0.882353, 0.121569, 0.352941)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/malig.png")
	description = "Infinite clones."
	primary_currency = Currency.Type.MALIGNANCY


func init_WATER() -> void:
	add_job(Job.Type.WATER)
	name = "Gatorade"
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(2500, false),
		Currency.Type.WOOD: Attribute.new(80, false),
	})
	color = Color(0, 0.647059, 1)
	faded_color = Color(0.570313, 0.859009, 1)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/water.png")
	description = "Likes his pool."
	primary_currency = Currency.Type.WATER


func init_HUMUS() -> void:
	add_job(Job.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(600, false),
		Currency.Type.COPPER: Attribute.new(600, false),
		Currency.Type.GLASS: Attribute.new(30, false),
	})
	color = Color(0.458824, 0.25098, 0)
	faded_color = Color(0.6, 0.3, 0)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/humus.png")
	description = "The shittest character in the game."
	primary_currency = Currency.Type.HUMUS


func init_SOIL() -> void:
	add_job(Job.Type.SOIL)
	cost = Cost.new({
		Currency.Type.CONCRETE: Attribute.new(1000, false),
		Currency.Type.HARDWOOD: Attribute.new(40, false),
	})
	color = Color(0.737255, 0.447059, 0)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/soil.png")
	description = "#note."
	primary_currency = Currency.Type.SOIL
	set_female_pronouns()


func init_TREES() -> void:
	add_job(Job.Type.TREES)
	cost = Cost.new({
		Currency.Type.GROWTH: Attribute.new(150, false),
		Currency.Type.SOIL: Attribute.new(25, false),
	})
	color = Color(0.772549, 1, 0.247059)
	faded_color = Color(0.864746, 0.988281, 0.679443)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/tree.png")
	description = "God-mode."
	primary_currency = Currency.Type.TREES


func init_SEEDS() -> void:
	add_job(Job.Type.SEEDS)
	name = "Maybe"
	cost = Cost.new({
		Currency.Type.COPPER: Attribute.new(800, false),
		Currency.Type.TREES: Attribute.new(2, false),
	})
	color = Color(1, 0.878431, 0.431373)
	faded_color = Color(.8,.8,.8)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/seed.png")
	description = "Keeps beesy."
	primary_currency = Currency.Type.SEEDS


func init_GALENA() -> void:
	add_job(Job.Type.GALENA)
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(1100, false),
		Currency.Type.WIRE: Attribute.new(200, false),
	})
	color = Color(0.701961, 0.792157, 0.929412)
	faded_color = Color(0.701961, 0.792157, 0.929412)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/gale.png")
	description = "#note."
	primary_currency = Currency.Type.GALENA


func init_LEAD() -> void:
	add_job(Job.Type.LEAD)
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(400, false),
		Currency.Type.GROWTH: Attribute.new(800, false),
	})
	color = Color(0.53833, 0.714293, 0.984375)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/lead.png")
	description = "#note."
	primary_currency = Currency.Type.LEAD


func init_WOOD_PULP() -> void:
	add_job(Job.Type.WOOD_PULP)
	cost = Cost.new({
		Currency.Type.WIRE: Attribute.new(15, false),
		Currency.Type.GLASS: Attribute.new(30, false),
	})
	color = Color(0.94902, 0.823529, 0.54902)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/pulp.png")
	description = "#note."
	primary_currency = Currency.Type.WOOD_PULP


func init_PAPER() -> void:
	add_job(Job.Type.PAPER)
	cost = Cost.new({
		Currency.Type.CONCRETE: Attribute.new(1200, false),
		Currency.Type.STEEL: Attribute.new(15, false),
	})
	color = Color(0.792157, 0.792157, 0.792157)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/paper.png")
	description = "Was in the boy scouts for 25 years."
	primary_currency = Currency.Type.PAPER


func init_TOBACCO() -> void:
	add_job(Job.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.SOIL: Attribute.new(3, false),
		Currency.Type.HARDWOOD: Attribute.new(15, false),
	})
	color = Color(0.639216, 0.454902, 0.235294)
	faded_color = Color(0.85, 0.75, 0.63)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/toba.png")
	description = "Thinks vapes are dangerous."
	primary_currency = Currency.Type.TOBACCO


func init_CIGARETTES() -> void:
	add_job(Job.Type.CIGARETTES)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Attribute.new(50, false),
		Currency.Type.WIRE: Attribute.new(120, false),
	})
	color = Color(0.929412, 0.584314, 0.298039)
	faded_color = Color(0.97, 0.8, 0.6)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/ciga.png")
	description = "On his 45th smoke break this shift."
	primary_currency = Currency.Type.CIGARETTES


func init_PETROLEUM() -> void:
	add_job(Job.Type.PETROLEUM)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(3000, false),
		Currency.Type.COPPER: Attribute.new(4000, false),
		Currency.Type.GLASS: Attribute.new(130, false),
	})
	color = Color(0.76, 0.53, 0.14)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/pet.png")
	description = "#note."
	primary_currency = Currency.Type.PETROLEUM


func init_PLASTIC() -> void:
	add_job(Job.Type.PLASTIC)
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(10000, false),
		Currency.Type.TARBALLS: Attribute.new(700, false),
	})
	color = Color(0.85, 0.85, 0.85)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/plast.png")
	description = "#note."
	primary_currency = Currency.Type.PLASTIC


func init_CARCINOGENS() -> void:
	add_job(Job.Type.CARCINOGENS)
	cost = Cost.new({
		Currency.Type.GROWTH: Attribute.new(8500, false),
		Currency.Type.CONCRETE: Attribute.new(2000, false),
		Currency.Type.STEEL: Attribute.new(150, false),
		Currency.Type.LEAD: Attribute.new(800, false),
	})
	color = Color(0.772549, 0.223529, 0.192157)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/carc.png")
	description = "#note."
	primary_currency = Currency.Type.CARCINOGENS


func init_LIQUID_IRON() -> void:
	add_job(Job.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.CONCRETE: Attribute.new(30, false),
		Currency.Type.STEEL: Attribute.new(25, false),
	})
	color = Color(0.27, 0.888, .9)
	faded_color = Color(0.7, 0.94, .985)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/liq.png")
	description = "Likes soup."
	primary_currency = Currency.Type.LIQUID_IRON


func init_STEEL() -> void:
	add_job(Job.Type.STEEL)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(15000, false),
		Currency.Type.COPPER: Attribute.new(3000, false),
		Currency.Type.HARDWOOD: Attribute.new(35, false),
	})
	color = Color(0.607843, 0.802328, 0.878431)
	faded_color = Color(0.823529, 0.898039, 0.92549)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/steel.png")
	description = "Is as strong as Guts."
	primary_currency = Currency.Type.STEEL


func init_SAND() -> void:
	add_job(Job.Type.SAND)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(700, false),
		Currency.Type.COPPER: Attribute.new(2850, false),
	})
	color = Color(.87, .70, .45)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/sand.png")
	description = "Didn't get DisneyPlus-ed."
	primary_currency = Currency.Type.SAND
	set_female_pronouns()


func init_GLASS() -> void:
	add_job(Job.Type.GLASS)
	cost = Cost.new({
		Currency.Type.COPPER: Attribute.new(6000, false),
		Currency.Type.STEEL: Attribute.new(40, false),
	})
	color = Color(0.81, 0.93, 1.0)
	faded_color = Color(0.81, 0.93, 1.0)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/glass.png")
	description = "Vaporizes people for fun."
	primary_currency = Currency.Type.GLASS


func init_WIRE() -> void:
	add_job(Job.Type.WIRE)
	cost = Cost.new({
		Currency.Type.STONE: Attribute.new(13000, false),
		Currency.Type.GLASS: Attribute.new(30, false),
	})
	color = Color(0.9, 0.6, 0.14)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/wire.png")
	description = "Loves her grandchildren."
	primary_currency = Currency.Type.WIRE
	set_female_pronouns()


func init_DRAW_PLATE() -> void:
	add_job(Job.Type.DRAW_PLATE)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(900, false),
		Currency.Type.CONCRETE: Attribute.new(300, false),
		Currency.Type.WIRE: Attribute.new(20, false),
	})
	color = Color(0.333333, 0.639216, 0.811765)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/Currency/draw.png")
	description = "Can run really fast."
	primary_currency = Currency.Type.DRAW_PLATE


func init_AXES() -> void:
	add_job(Job.Type.AXES)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(1000, false),
		Currency.Type.HARDWOOD: Attribute.new(55, false),
	})
	color = Color(0.691406, 0.646158, 0.586075)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/axe.png")
	description = "IN THE YEAR 202070707020. I AM WAKAKO."
	primary_currency = Currency.Type.AXES


func init_WOOD() -> void:
	add_job(Job.Type.WOOD)
	cost = Cost.new({
		Currency.Type.COPPER: Attribute.new(4500, false),
		Currency.Type.WIRE: Attribute.new(15, false),
	})
	color = Color(0.545098, 0.372549, 0.015686)
	faded_color = Color(0.77, 0.68, 0.6)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/wood.png")
	description = "Is just Goku."
	primary_currency = Currency.Type.WOOD


func init_HARDWOOD() -> void:
	add_job(Job.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.IRON: Attribute.new(3500, false),
		Currency.Type.CONCRETE: Attribute.new(350, false),
		Currency.Type.WIRE: Attribute.new(35, false),
	})
	color = Color(0.92549, 0.690196, 0.184314)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/hard.png")
	description = "Potentially problematic."
	primary_currency = Currency.Type.HARDWOOD


func init_TUMORS() -> void:
	add_job(Job.Type.TUMORS)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Attribute.new(50, false),
		Currency.Type.WIRE: Attribute.new(150, false),
		Currency.Type.GLASS: Attribute.new(150, false),
		Currency.Type.STEEL: Attribute.new(100, false),
	})
	color = Color(1, .54, .54)
	fuel_currency_type = Currency.Type.JOULES
	icon = preload("res://Sprites/Currency/tum.png")
	description = "#note."
	primary_currency = Currency.Type.TUMORS


func init_WITCH() -> void:
	name = "Circe"
	cost = Cost.new({
		Currency.Type.HARDWOOD: Attribute.new(50, false),
		Currency.Type.WIRE: Attribute.new(150, false),
		Currency.Type.GLASS: Attribute.new(150, false),
		Currency.Type.STEEL: Attribute.new(100, false),
	})
	color = Color(0.937255, 0.501961, 0.776471)
	fuel_currency_type = Currency.Type.COAL
	icon = preload("res://Sprites/upgrades/thewitchofloredelith.png")
	description = "Loves her garden. In good favor with Aurus."
	primary_currency = Currency.Type.FLOWER_SEED
	set_female_pronouns()


func init_BLOOD() -> void:
	name = "Charity"
	cost = Cost.new({
		Currency.Type.HARDWOOD: Attribute.new(50, false),
		Currency.Type.WIRE: Attribute.new(150, false),
		Currency.Type.GLASS: Attribute.new(150, false),
		Currency.Type.STEEL: Attribute.new(100, false),
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
			var currency = wa.get_currency(cur)
			produced_currencies.append(currency)
	for cur in jobs[_job].get_required_currency_types():
		if not cur in required_currencies:
			var currency = wa.get_currency(cur)
			required_currencies.append(currency)
	
	if not lv.loreds_are_initialized:
		await lv.loreds_initialized
	jobs[_job].assign_lored(self)
	
	output.add_immediate_notify_method(jobs[_job].lored_output_changed)
	haste.add_immediate_notify_method(jobs[_job].lored_haste_changed)
	fuel_cost.add_immediate_notify_method(jobs[_job].lored_fuel_cost_changed)
	if jobs[_job].has_required_currencies:
		input.add_immediate_notify_method(jobs[_job].lored_input_changed)
	
	jobs[_job].connect("became_workable", job_became_workable)
	jobs[_job].connect("completed", job_completed)
	jobs[_job].connect("cut_short", job_cut_short)


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
	has_vico = true



# - Signal Shit

func loreds_initialized() -> void:
	pass


func lored_vicos_ready() -> void:
	if purchased:
		start_working()


func add_fuel_rate() -> void:
	if not fuel_rate_added:
		fuel_rate_added = true
		fuel_currency.add_current_loss_rate(fuel_cost.get_value())


func subtract_fuel_rate() -> void:
	if fuel_rate_added:
		fuel_rate_added = false
		fuel_currency.subtract_current_loss_rate(fuel_cost.get_value())



# - Actions

func reset():
	level.reset()
	output.reset()
	input.reset()
	haste.reset()
	fuel.reset()
	fuel_cost.reset()
	cost.reset()
	set_level_to(0)
	purchased = true if type == Type.STONE else false


func purchase() -> void:
	times_purchased += 1
	purchased = true
	cost.spend(true)
	level_up()
	if times_purchased == 1:
		start_working()


func force_purchase() -> void:
	times_purchased += 1
	purchased = true
	level_up()
	if times_purchased == 1:
		start_working()


func level_up() -> void:
	set_level_to(level.get_as_int() + 1)


func set_level_to(_level: int) -> void:
	level.set_to(_level)
	cost.increase(_level, cost_increase.get_as_float())
	
	var current_level = level.get_as_int()
	output.set_from_level(Big.new(2).power(current_level - 1))
	input.set_from_level(Big.new(2).power(current_level - 1))
	var fuel_percent = fuel.get_current_percent()
	fuel.set_from_level(Big.new(2).power(current_level - 1))
	fuel.set_to_percent(fuel_percent)
	subtract_fuel_rate()
	fuel_cost.set_from_level(Big.new(2).power(current_level - 1))
	add_fuel_rate()
	emit_signal("leveled_up", current_level)



func unlock() -> void:
	unlocked = true
	for currency in produced_currencies:
		wa.unlock_currency(currency.type)
	emit_signal("just_unlocked")



func go_to_sleep() -> void:
	emit_signal("plan_to_sleep")
	if working:
		will_go_to_sleep = true
		await completed_job
		if not will_go_to_sleep:
			return
	will_go_to_sleep = false
	asleep = true
	time_went_to_bed = Time.get_unix_time_from_system()
	lv.start_sleep_emitter(self)
	lv.active_and_awake.erase(self)
	emit_signal("stopped_working")
	emit_signal("went_to_sleep")


func wake_up() -> void:
	if asleep:
		var time_in_bed = Time.get_unix_time_from_system() - time_went_to_bed
		time_spent_asleep += time_in_bed
	will_go_to_sleep = false
	asleep = false
	if reason_cannot_work != ReasonCannotWork.CAN_WORK:
		cannot_work(reason_cannot_work)
	lv.active_and_awake.append(self)
	emit_signal("woke_up")



func emote(_emote: Emote) -> void:
	if not _emote.ready_to_emote:
		await _emote.became_ready_to_emote
	while emoting:
		await finished_emoting
		await gv.get_tree().create_timer(1).timeout
	emoting = true
	vico.emote(_emote)
	await _emote.finished_emoting
	emoting = false
	emit_signal("finished_emoting")



func add_influencing_upgrade(upgrade: Upgrade) -> void:
	if not upgrade in upgrades:
		upgrades.append(upgrade)
		if not upgrade.purchased:
			if not upgrade in unpurchased_upgrades:
				unpurchased_upgrades.append(upgrade)
				await upgrade.just_purchased
				unpurchased_upgrades.erase(upgrade)



# - Job

func start_working() -> void:
	if asleep or will_go_to_sleep:
		await woke_up
	select_next_job()


func select_next_job(_type := -1) -> void:
	if looking_for_jobs:
		return
	looking_for_jobs = true
	if working:
		await completed_job
	
	if _type == -1:
		next_job_type = get_next_job_automatically()
		if next_job_type == -1:
			
			if type == Type.COAL:
				var cur_fuel = fuel.get_current()
				if cur_fuel.greater_equal(jobs[Job.Type.COAL].get_fuel_cost()):
					start_job(Job.Type.COAL)
				else:
					start_job(Job.Type.REFUEL)
				return
			
			determine_why_cannot_work()
			await a_job_opened_up
			looking_for_jobs = false
			if asleep:
				return
			select_next_job()
			return
		start_job(next_job_type)
		return
	
	if jobs[_type].can_start():
		start_job(next_job_type)
	else:
		looking_for_jobs = false
		select_next_job()


func get_next_job_automatically() -> int:
	for _type in sorted_jobs:
		var job: Job = jobs[_type]
		if job.can_start():
			return _type
	return -1


func job_became_workable() -> void:
	emit_signal("a_job_opened_up")


func start_job(_type: int) -> void:
	reason_cannot_work = ReasonCannotWork.CAN_WORK
	
	looking_for_jobs = false
	working = true
	last_job_type = _type
	last_job = jobs[_type]
	last_job.start()
	vico.start_job(last_job)
	emit_signal("began_working")
	emit_signal("job_started", last_job)


func stop_job() -> void:
	if working:
		last_job.stop()


func job_completed() -> void:
	working = false
	vico.job_completed()
	emit_signal("completed_job")


func job_cut_short() -> void:
	working = false
	emit_signal("completed_job")



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
				"Awaiting " + fuel_currency.name + ".",
				 fuel_currency_type
			)
		ReasonCannotWork.INSUFFICIENT_CURRENCIES:
			vico.set_status_and_currency("Awaiting required resource.")
	emit_signal("became_unable_to_work")



# - Wish

var wished_upgrade: Upgrade
var wished_currency: Currency

func get_wish() -> String:
	randomize()
	
	var possible_types := {
		"LORED_LEVELED_UP": 10,
		"SLEEP": 10,
	}
	
	if fuel.get_current_percent() < lv.FUEL_DANGER and df.fuel.less_equal(2):
		if randi() % 100 < 30:
			possible_types["ACCEPTABLE_FUEL"] = 50
		else:
			wished_currency = fuel_currency
			possible_types["COLLECT_CURRENCY"] = 50
	elif reason_cannot_work != ReasonCannotWork.CAN_WORK and required_currencies.size() > 1:
		wished_currency = required_currencies[randi() % (required_currencies.size() - 1) + 1]
		possible_types["COLLECT_CURRENCY"] = 50
	else:
		if randi() % 100 < 10:
			wished_currency = wa.get_currency(Currency.Type.JOY)
			possible_types["COLLECT_CURRENCY"] = 10
		else:
			wished_currency = wa.get_random_unlocked_currency()
			possible_types["COLLECT_CURRENCY"] = 30
	
	for upgrade in unpurchased_upgrades:
		var upgrade_eta = upgrade.cost.get_eta()
		if upgrade_eta.equal(0):
			continue
		if upgrade.unlocked and upgrade_eta.less_equal(60):
			wished_upgrade = upgrade
			possible_types["UPGRADE_PURCHASED"] = 30
			break
	
	
	
	var total_points := 0
	for x in possible_types.values():
		total_points += x
	
	var roll := randi() % total_points
	
	var shuffled_possible_types := possible_types.keys()
	shuffled_possible_types.shuffle()
	
	for i in possible_types.size():
		if roll < possible_types[shuffled_possible_types[i]]:
			return shuffled_possible_types[i]
		roll -= possible_types[shuffled_possible_types[i]]
	
	print_debug("This rly shouldn't have happened")
	return "Stinky"



# - Get

func is_visible() -> bool:
	if lv.lored_container.current_tab + 1 != stage:
		return false
	return vico.visible


func can_afford() -> bool:
	return cost.affordable


func get_level() -> int:
	return level.get_as_int()


func get_level_text() -> String:
	return level.get_text()


func get_next_level_text() -> String:
	return str(level.get_value().toInt() + 1)


func get_output() -> Big:
	return output.get_value()


func get_output_text() -> String:
	return output.get_text()


func get_next_output_text() -> String:
	return Big.new(output.get_value()).m(2).toString()


func get_input() -> Big:
	return input.get_value()


func get_input_text() -> String:
	return input.get_text()


func get_next_input_text() -> String:
	return Big.new(input.get_value()).m(2).toString()


func get_haste() -> Big:
	return haste.get_value()


func get_haste_text() -> String:
	return haste.get_text()


func get_fuel_cost() -> Big:
	return fuel_cost.get_value()


func get_fuel_cost_text() -> String:
	return fuel_cost.get_text()


func get_next_fuel_cost_text() -> String:
	return Big.new(fuel_cost.get_value()).m(2).toString()


func get_max_fuel_text() -> String:
	return fuel.get_total_text()


func get_next_max_fuel_text() -> String:
	return Big.new(fuel.get_total()).m(2).toString()


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
