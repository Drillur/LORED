class_name LORED
extends Resource



var saved_vars := [
	"level",
	"purchased",
	"unlocked",
	"unlocked_jobs",
	"cost",
	#asleep - based on an option, append or erase this from this array
]

func load_started() -> void:
	lv.lored_became_inactive(type)
	stop_job()
	unlocked.set_to(false)
	purchased.set_to(false)


func load_finished() -> void:
	if unlocked.is_true():
		lv.lored_unlocked(type)
	else:
		lv.lored_locked(type)
	set_level_to(level.get_value())
	if stage == 1 and level.greater_equal(5):
		became_an_adult.emit()
	if purchased.is_true():
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
	ARCANE,
	BLOOD, # leave BLOOD at the bottom.
	
	# put s4 loreds here
	S4PLACEHOLDER,
	
	NO_LORED,
}
enum Attribute {
	OUTPUT,
	INPUT,
	HASTE,
	CRIT,
	FUEL,
	FUEL_COST,
}
enum ReasonCannotWork {
	CAN_WORK,
	UNKNOWN,
	INSUFFICIENT_FUEL,
	INSUFFICIENT_CURRENCIES,
}

signal became_unable_to_work
signal completed_job
signal job_started
signal spent_one_second_asleep
signal currency_produced(amount)
signal became_an_adult
signal received_buff


var type: Type
var stage: int
var last_job: Job
var primary_currency: Currency.Type
var fuel_currency: Currency.Type
var reason_cannot_work := LoudInt.new(0)
var active_currency: LoudInt

var produced_currencies := []
var required_currencies := []
var upgrades := []
var unpurchased_upgrades := []
var emote_queue := []

@export var fuel: ValuePair
@export var unlocked_jobs := []
@export var unlocked := LoudBool.new(false)
@export var purchased := LoudBool.new(false)
@export var asleep := LoudBool.new(false)
@export var time_spent_asleep := 0.0
@export var level := LoudInt.new(0)


var key_lored := false
var autobuy := LoudBool.new(false)
var persist := Persist.new()

var autobuy_on_cooldown := false


var working := LoudBool.new(false)

var time_went_to_bed := 0.0
var fuel_rate_added := false
var emoting := LoudBool.new(false)

var last_purchase_automatic := false
var last_purchase_forced := false

var key: String
var details := Details.new()
var pronoun_he := "he"
var pronoun_him := "him"
var pronoun_his := "his"
var pronoun_man := "man"
var pronoun_boy := "boy"
var status := LoudString.new("Idle")

var default_frames: SpriteFrames

var cost: Cost

var vico: LOREDVico

var jobs := {}
var sorted_jobs := []

var output_increase := LoudFloat.new(2)
var input_increase := LoudFloat.new(2)

var fuel_cost: Value
var output := Value.new(1)
var input := Value.new(1)
var haste := Value.new(1)
var crit := Value.new(0)



func _init(_type: Type) -> void:
	type = _type
	key = Type.keys()[type]
	
	df.active_difficulty.changed.connect(difficulty_changed)
	
	purchased.changed.connect(purchased_updated)
	purchased.reset_value_changed.connect(purchased_reset_value_updated)
	unlocked.changed.connect(unlocked_updated)
	unlocked.reset_value_changed.connect(unlocked_reset_value_updated)
	emoting.became_false.connect(emote_next_in_line)
	autobuy.changed.connect(autobuy_changed)
	asleep.changed.connect(asleep_updated)
	
	call("init_" + key)
	
	cost.repeatable = true
	
	active_currency = LoudInt.new(primary_currency)
	cost.cache_costs()
	
	details.set_title(key.replace("_", " ").capitalize() + " LORED")
	
	key_lored = type in lv.key_loreds
	
	add_job(Job.Type.REFUEL, true)
	
	asleep.became_false.connect(work)
	completed_job.connect(work)
	purchased.became_true.connect(work)
	gv.one_second.connect(work)
	disconnect_second_work_thing()
	
	
	gv.prestige.connect(prestige)
	gv.prestiged.connect(force_purchase)
	gv.prestiged.connect(autobuy_check)
	cost.became_safe.connect(autobuy_check)
	gv.hard_reset.connect(hard_reset)
	
	# stage and fuel
	if type <= Type.OIL:
		stage = 1
	elif type <= Type.TUMORS:
		stage = 2
	elif type <= Type.BLOOD:
		stage = 3
	else:
		stage = 4
	
	cost.stage = stage
	
	# fuel cost
	if stage in [1, 2]:
		var job = jobs.values()[0] as Job
		var base_fuel_cost = 0.1
		if job.has_required_currencies:
			base_fuel_cost += (0.05 * job.required_currencies.cost.size())
		var modifier = 1 if fuel_currency == Currency.Type.COAL else 2
		fuel_cost = Value.new(base_fuel_cost * modifier * stage)
	else:
		fuel_cost = Value.new(0.5)
	
	if type in [Type.MALIGNANCY, Type.TUMORS]:
		fuel_cost = Value.new(0.5 * stage)
	fuel = ValuePair.new(Big.new(fuel_cost.get_value()).m(100).m(stage))
	if type == Type.STONE:
		fuel.change_base(1.0)
		fuel.reset()
	
	fuel.current.increased.connect(work)
	
	sort_jobs()


#region _init

func init_STONE() -> void:
	details.name = "Scoot"
	details.color = Color(0.79, 0.79, 0.79)
	details.alt_color = Color(0.788235, 0.788235, 0.788235)
	details.icon = bag.get_resource("stone")
	details.description = "Likes rocks. Has a bottomless bag."
	add_job(Job.Type.STONE, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(25.0 / 3),
		Currency.Type.COPPER: Value.new(15.0 / 3),
	})
	purchased.set_default_value(true)
	unlocked.set_default_value(true)
	fuel_currency = Currency.Type.COAL
	primary_currency = Currency.Type.STONE


func init_COAL() -> void:
	details.name = "Carl"
	add_job(Job.Type.COAL, true)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(5),
	})
	unlocked.set_default_value(true)
	details.color = Color(0.7, 0, 1)
	details.alt_color = Color(0.9, 0.3, 1)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("coal")
	details.description = "Plays support in every game."
	primary_currency = Currency.Type.COAL


func init_IRON_ORE() -> void:
	details.name = "Ted"
	add_job(Job.Type.IRON_ORE, true)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(8),
	})
	details.color = Color(0, 0.517647, 0.905882)
	details.alt_color = Color(0.5, 0.788732, 1)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("irono")
	details.description = "Is actually evil."
	primary_currency = Currency.Type.IRON_ORE


func init_COPPER_ORE() -> void:
	details.name = "Eugene"
	add_job(Job.Type.COPPER_ORE, true)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(8),
	})
	details.color = Color(0.7, 0.33, 0)
	details.alt_color = Color(0.695313, 0.502379, 0.334076)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("copo")
	details.description = "Trapped in a dead-end job. Literally."
	primary_currency = Currency.Type.COPPER_ORE


func init_IRON() -> void:
	details.name = "Will"
	add_job(Job.Type.IRON, true)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(9),
		Currency.Type.COPPER: Value.new(8),
	})
	details.color = Color(0.07, 0.89, 1)
	details.alt_color = Color(0.496094, 0.940717, 1)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("iron")
	details.description = "Wants everyone to succeed."
	primary_currency = Currency.Type.IRON


func init_COPPER() -> void:
	details.name = "Ben"
	add_job(Job.Type.COPPER, true)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(9),
		Currency.Type.IRON: Value.new(8),
	})
	details.color = Color(1, 0.74, 0.05)
	details.alt_color = Color(1, 0.862001, 0.496094)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("cop")
	details.description = "Loves s'mores."
	primary_currency = Currency.Type.COPPER


func init_GROWTH() -> void:
	details.name = "Percy"
	add_job(Job.Type.GROWTH, true)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(900),
	})
	details.color = Color(0.79, 1, 0.05)
	details.alt_color = Color(0.890041, 1, 0.5)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("growth")
	details.description = "Is in an unfortunate situation."
	primary_currency = Currency.Type.GROWTH


func init_JOULES() -> void:
	details.name = "Notzuko"
	add_job(Job.Type.JOULES, true)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(25),
	})
	details.color = Color(1, 0.98, 0)
	details.alt_color = Color(1, 0.9572, 0.503906)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("jo")
	details.description = "Follows Tesla on [s]Twitter[/s] X."
	primary_currency = Currency.Type.JOULES


func init_CONCRETE() -> void:
	details.name = "Santos"
	add_job(Job.Type.CONCRETE, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(90),
		Currency.Type.COPPER: Value.new(150),
	})
	details.color = Color(0.35, 0.35, 0.35)
	details.alt_color = Color(0.6, 0.6, 0.6)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("conc")
	details.description = "Laughs about everything."
	primary_currency = Currency.Type.CONCRETE


func init_OIL() -> void:
	details.name = "Odd Lee"
	add_job(Job.Type.OIL, true)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(160),
		Currency.Type.CONCRETE: Value.new(250),
	})
	details.color = Color(0.65, 0.3, 0.66)
	details.alt_color = Color(0.647059, 0.298039, 0.658824)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("oil")
	details.description = "Is a big baby."
	primary_currency = Currency.Type.OIL


func init_TARBALLS() -> void:
	details.name = "Jon"
	add_job(Job.Type.TARBALLS, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(350),
		Currency.Type.MALIGNANCY: Value.new(10),
	})
	details.color = Color(0.56, 0.44, 1)
	details.alt_color = Color(0.560784, 0.439216, 1)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("tar")
	details.description = "Quiet science guy."
	primary_currency = Currency.Type.TARBALLS


func init_MALIGNANCY() -> void:
	details.name = "Tenant"
	add_job(Job.Type.MALIGNANCY, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(900),
		Currency.Type.COPPER: Value.new(900),
		Currency.Type.CONCRETE: Value.new(50),
	})
	details.color = Color(0.88, 0.12, 0.35)
	details.alt_color = Color(0.882353, 0.121569, 0.352941)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("malig")
	details.description = "Infinite clones."
	primary_currency = Currency.Type.MALIGNANCY


func init_WATER() -> void:
	add_job(Job.Type.WATER, true)
	details.name = "Gatorade"
	cost = Cost.new({
		Currency.Type.STONE: Value.new(2500),
		Currency.Type.WOOD: Value.new(80),
	})
	details.color = Color(0, 0.647059, 1)
	details.alt_color = Color(0.570313, 0.859009, 1)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("water")
	details.description = "Likes his pool."
	primary_currency = Currency.Type.WATER


func init_HUMUS() -> void:
	details.name = "Chip"
	add_job(Job.Type.HUMUS, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(600),
		Currency.Type.COPPER: Value.new(600),
		Currency.Type.GLASS: Value.new(30),
	})
	details.color = Color(0.458824, 0.25098, 0)
	details.alt_color = Color(0.6, 0.3, 0)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("humus")
	details.description = "The shittest character in the game."
	primary_currency = Currency.Type.HUMUS


func init_SOIL() -> void:
	details.name = "Mike"
	add_job(Job.Type.SOIL, true)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(1000),
		Currency.Type.HARDWOOD: Value.new(40),
	})
	details.color = Color(0.737255, 0.447059, 0)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("soil")
	details.description = "#note."
	primary_currency = Currency.Type.SOIL
	set_female_pronouns()


func init_TREES() -> void:
	details.name = "Biby"
	add_job(Job.Type.TREES, true)
	add_job(Job.Type.TREES2, true)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(150),
		Currency.Type.SOIL: Value.new(25),
	})
	details.color = Color(0.772549, 1, 0.247059)
	details.alt_color = Color(0.864746, 0.988281, 0.679443)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("tree")
	details.description = "God-mode."
	primary_currency = Currency.Type.TREES


func init_SEEDS() -> void:
	details.name = "Maybe"
	add_job(Job.Type.SEEDS, true)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(800),
		Currency.Type.TREES: Value.new(2),
	})
	details.color = Color(1, 0.878431, 0.431373)
	details.alt_color = Color(.8,.8,.8)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("seed")
	details.description = "Keeps beesy."
	primary_currency = Currency.Type.SEEDS


func init_GALENA() -> void:
	details.name = "Jack"
	add_job(Job.Type.GALENA, true)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(1100),
		Currency.Type.WIRE: Value.new(200),
	})
	details.color = Color(0.701961, 0.792157, 0.929412)
	details.alt_color = Color(0.701961, 0.792157, 0.929412)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("gale")
	details.description = "#note."
	primary_currency = Currency.Type.GALENA


func init_LEAD() -> void:
	details.name = "Martin"
	add_job(Job.Type.LEAD, true)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(400),
		Currency.Type.GROWTH: Value.new(800),
	})
	details.color = Color(0.53833, 0.714293, 0.984375)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("lead")
	details.description = "#note."
	primary_currency = Currency.Type.LEAD


func init_WOOD_PULP() -> void:
	details.name = "Marsellus"
	add_job(Job.Type.WOOD_PULP, true)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new(15),
		Currency.Type.GLASS: Value.new(30),
	})
	details.color = Color(0.94902, 0.823529, 0.54902)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("pulp")
	details.description = "#note."
	primary_currency = Currency.Type.WOOD_PULP


func init_PAPER() -> void:
	details.name = "Sawyer"
	add_job(Job.Type.PAPER, true)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(1200),
		Currency.Type.STEEL: Value.new(15),
	})
	details.color = Color(0.792157, 0.792157, 0.792157)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("paper")
	details.description = "Was in the boy scouts for 25 years."
	primary_currency = Currency.Type.PAPER


func init_TOBACCO() -> void:
	details.name = "Gondalf"
	add_job(Job.Type.TOBACCO, true)
	cost = Cost.new({
		Currency.Type.SOIL: Value.new(3),
		Currency.Type.HARDWOOD: Value.new(15),
	})
	details.color = Color(0.639216, 0.454902, 0.235294)
	details.alt_color = Color(0.85, 0.75, 0.63)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("toba")
	details.description = "Thinks vapes are dangerous."
	primary_currency = Currency.Type.TOBACCO


func init_CIGARETTES() -> void:
	details.name = "George"
	add_job(Job.Type.CIGARETTES, true)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new(50),
		Currency.Type.WIRE: Value.new(120),
	})
	details.color = Color(0.929412, 0.584314, 0.298039)
	details.alt_color = Color(0.97, 0.8, 0.6)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("ciga")
	details.description = "On his 45th smoke break this shift."
	primary_currency = Currency.Type.CIGARETTES


func init_PETROLEUM() -> void:
	details.name = "Daniel"
	add_job(Job.Type.PETROLEUM, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(3000),
		Currency.Type.COPPER: Value.new(4000),
		Currency.Type.GLASS: Value.new(130),
	})
	details.color = Color(0.76, 0.53, 0.14)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("pet")
	details.description = "#note."
	primary_currency = Currency.Type.PETROLEUM


func init_PLASTIC() -> void:
	details.name = "Dolly"
	add_job(Job.Type.PLASTIC, true)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(10000),
		Currency.Type.TARBALLS: Value.new(700),
	})
	details.color = Color(0.85, 0.85, 0.85)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("plast")
	details.description = "#note."
	primary_currency = Currency.Type.PLASTIC


func init_CARCINOGENS() -> void:
	details.name = "Lamash"
	add_job(Job.Type.CARCINOGENS, true)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(8500),
		Currency.Type.CONCRETE: Value.new(2000),
		Currency.Type.STEEL: Value.new(150),
		Currency.Type.LEAD: Value.new(800),
	})
	details.color = Color(0.772549, 0.223529, 0.192157)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("carc")
	details.description = "#note."
	primary_currency = Currency.Type.CARCINOGENS


func init_LIQUID_IRON() -> void:
	details.name = "Boy"
	add_job(Job.Type.LIQUID_IRON, true)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(30),
		Currency.Type.STEEL: Value.new(25),
	})
	details.color = Color(0.27, 0.888, .9)
	details.alt_color = Color(0.7, 0.94, .985)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("liq")
	details.description = "Likes soup."
	primary_currency = Currency.Type.LIQUID_IRON


func init_STEEL() -> void:
	details.name = "Ryan"
	add_job(Job.Type.STEEL, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(15000),
		Currency.Type.COPPER: Value.new(3000),
		Currency.Type.HARDWOOD: Value.new(35),
	})
	details.color = Color(0.607843, 0.802328, 0.878431)
	details.alt_color = Color(0.823529, 0.898039, 0.92549)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("steel")
	details.description = "Is as strong as Guts."
	primary_currency = Currency.Type.STEEL


func init_SAND() -> void:
	details.name = "Herakin"
	add_job(Job.Type.SAND, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(700),
		Currency.Type.COPPER: Value.new(2850),
	})
	details.color = Color(.87, .70, .45)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("sand")
	details.description = "Didn't get DisneyPlus-ed."
	primary_currency = Currency.Type.SAND
	set_female_pronouns()


func init_GLASS() -> void:
	details.name = "Shyuum"
	add_job(Job.Type.GLASS, true)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(6000),
		Currency.Type.STEEL: Value.new(40),
	})
	details.color = Color(0.81, 0.93, 1.0)
	details.alt_color = Color(0.81, 0.93, 1.0)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("glass")
	details.description = "Vaporizes people for fun."
	primary_currency = Currency.Type.GLASS


func init_WIRE() -> void:
	details.name = "Joyce"
	add_job(Job.Type.WIRE, true)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(13000),
		Currency.Type.GLASS: Value.new(30),
	})
	details.color = Color(0.9, 0.6, 0.14)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("wire")
	details.description = "Loves her grandchildren."
	primary_currency = Currency.Type.WIRE
	set_female_pronouns()


func init_DRAW_PLATE() -> void:
	details.name = "Billy"
	add_job(Job.Type.DRAW_PLATE, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(900),
		Currency.Type.CONCRETE: Value.new(300),
		Currency.Type.WIRE: Value.new(20),
	})
	details.color = Color(0.333333, 0.639216, 0.811765)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("draw")
	details.description = "Can run really fast."
	primary_currency = Currency.Type.DRAW_PLATE


func init_AXES() -> void:
	details.name = "Alaxea"
	add_job(Job.Type.AXES, true)
	add_job(Job.Type.AXES2, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(1000),
		Currency.Type.HARDWOOD: Value.new(55),
	})
	details.color = Color(0.691406, 0.646158, 0.586075)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("axe")
	details.description = "IN THE YEAR 202070707020. I AM WAKAKO."
	primary_currency = Currency.Type.AXES


func init_WOOD() -> void:
	details.name = "Goketa"
	add_job(Job.Type.WOOD, true)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(4500),
		Currency.Type.WIRE: Value.new(15),
	})
	details.color = Color(0.545098, 0.372549, 0.015686)
	details.alt_color = Color(0.77, 0.68, 0.6)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("wood")
	details.description = "Is just Goku."
	primary_currency = Currency.Type.WOOD


func init_HARDWOOD() -> void:
	details.name = "Rabbit"
	add_job(Job.Type.HARDWOOD, true)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(3500),
		Currency.Type.CONCRETE: Value.new(350),
		Currency.Type.WIRE: Value.new(35),
	})
	details.color = Color(0.92549, 0.690196, 0.184314)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("hard")
	details.description = "Potentially problematic."
	primary_currency = Currency.Type.HARDWOOD


func init_TUMORS() -> void:
	details.name = "Jesse"
	add_job(Job.Type.TUMORS, true)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new(50),
		Currency.Type.WIRE: Value.new(150),
		Currency.Type.GLASS: Value.new(150),
		Currency.Type.STEEL: Value.new(100),
	})
	details.color = Color(1, .54, .54)
	fuel_currency = Currency.Type.JOULES
	details.icon = bag.get_resource("tum")
	details.description = "#note."
	primary_currency = Currency.Type.TUMORS


func init_WITCH() -> void:
	details.name = "Circe"
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new(50),
	})
	details.color = Color(0.937255, 0.501961, 0.776471)
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("thewitchofloredelith")
	details.description = "Loves her garden. In good favor with Aurus."
	primary_currency = Currency.Type.FLOWER_SEED
	set_female_pronouns()
	add_job(Job.Type.PICK_FROM_GARDEN)


func init_ARCANE() -> void:
	details.name = "Arvandus"
	details.set_title("the Magister")
	cost = Cost.new({
		Currency.Type.STEEL: Value.new(100),
	})
	details.color = wa.get_currency(Currency.Type.MANA).details.alt_color
	fuel_currency = Currency.Type.COAL
	details.icon = bag.get_resource("water")
	details.description = "Clever and uptight."
	primary_currency = Currency.Type.MANA


func init_BLOOD() -> void:
	details.name = "Charity"
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new(50),
		Currency.Type.WIRE: Value.new(150),
		Currency.Type.GLASS: Value.new(150),
		Currency.Type.STEEL: Value.new(100),
	})
	details.color = Color(1, 0, 0)
	details.alt_color = Color(1, 0.4, 0.4)
	details.icon = bag.get_resource("axe")
	details.description = "A stoic, hard-working healer."
	primary_currency = Currency.Type.BLOOD
	set_female_pronouns()


func init_S4PLACEHOLDER() -> void:
	details.name = "you wouldn't think this would be necessary, but you'd be freakin wrong"
	cost = Cost.new({Currency.Type.STONE: Value.new(1)})
	details.color = Color(1, 0, 0)
	details.alt_color = Color(1, 0.4, 0.4)
	details.icon = bag.get_resource("axe")
	details.description = "A real piece of work."
	primary_currency = Currency.Type.STONE


#endregion


func add_job(_job: int, _unlocked_by_default := false) -> void:
	jobs[_job] = Job.new(_job) as Job
	jobs[_job].unlocked_by_default = _unlocked_by_default
	jobs[_job].currency_produced.connect(emit_currency_produced)
	if jobs.size() == 1:
		default_frames = jobs[_job].animation
	
	if unlocked.is_true_by_default():
		add_job_produced_and_required_currencies(_job)


func add_job_produced_and_required_currencies(job_type: int) -> void:
	if job_type == Job.Type.REFUEL:
		return
	var job = jobs[job_type]
	for cur in job.get_produced_currencies():
		if not cur in produced_currencies:
			produced_currencies.append(cur)
	for cur in job.get_required_currency_types():
		if not cur in required_currencies:
			required_currencies.append(cur)


func remove_job_produced_and_required_currencies(job_type: int) -> void:
	var job = jobs[job_type]
	for cur in job.get_produced_currencies():
		produced_currencies.erase(cur)
	for cur in job.get_required_currency_types():
		required_currencies.erase(cur)


func loreds_initialized() -> void:
	gv.add_lored_to_stage(stage, type)
	for job in jobs.values():
		job = job as Job
		job.assign_lored(type)
		
		fuel_cost.connect("changed", job.lored_fuel_cost_changed)
		haste.connect("changed", job.lored_haste_changed)
		output.connect("changed", job.lored_output_changed)
		if job.has_required_currencies:
			input.connect("changed", job.lored_input_changed)
			job.lored_input_changed()
		
		job.lored_output_changed()
		job.lored_haste_changed()
		job.lored_fuel_cost_changed()
		
		job.became_workable.connect(work)
		job.completed.connect(job_completed)
		job.cut_short.connect(job_cut_short)
		
		if job.unlocked_by_default:
			unlock_job(job.type)


func unlock_job(job_type: int) -> void:
	if not job_type in unlocked_jobs:
		unlocked_jobs.append(job_type)
		jobs[job_type].unlocked.set_to(true)
		add_job_produced_and_required_currencies(job_type)


func lock_job(job_type: int) -> void:
	if job_type in unlocked_jobs:
		unlocked_jobs.erase(job_type)
		jobs[job_type].unlocked.set_to(false)
		remove_job_produced_and_required_currencies(job_type)


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


func purchased_updated() -> void:
	if purchased.is_true():
		lv.erase_lored_from_never_purchased(type)
		for cur in produced_currencies:
			wa.unlock_currency(cur)
			wa.set_wish_eligible_currency(cur, true)
		for job in jobs:
			jobs[job].add_rate()
	else:
		lv.lored_became_inactive(type)
		for cur in produced_currencies:
			wa.set_wish_eligible_currency(cur, false)


func purchased_reset_value_updated() -> void:
	if purchased.is_true_on_reset():
		if not lv.started.is_connected(force_purchase):
			lv.started.connect(force_purchase)
	else:
		if lv.started.is_connected(force_purchase):
			lv.started.disconnect(force_purchase)


func asleep_updated() -> void:
	if asleep.is_true():
		time_went_to_bed = Time.get_unix_time_from_system()
		lv.lored_went_to_sleep(type)
		active_currency.reset()
	else:
		lv.lored_became_inactive(type)
		if time_went_to_bed != 0:
			calculate_time_in_bed()
		lv.lored_woke_up(type)


func unlocked_updated() -> void:
	if unlocked.is_true():
		lv.lored_unlocked(type)
		autobuy_check()
		saved_vars.append("fuel")
		saved_vars.append("time_spent_asleep")
	else:
		lv.lored_locked(type)
		saved_vars.erase("fuel")
		saved_vars.erase("time_spent_asleep")


func unlocked_reset_value_updated() -> void:
	if unlocked.is_true_on_reset():
		if not lv.started.is_connected(unlock):
			lv.started.connect(unlock)
	else:
		if lv.started.is_connected(unlock):
			lv.started.disconnect(unlock)


func autobuy_changed() -> void:
	if autobuy.is_true():
		autobuy_check()
		if not cost.affordable.became_true.is_connected(autobuy_check):
			cost.affordable.became_true.connect(autobuy_check)
			for cur in produced_currencies:
				wa.get_currency(cur).net_rate.positive.became_false.connect(autobuy_check)
			for cur in required_currencies:
				wa.get_currency(cur).net_rate.positive.became_false.connect(autobuy_check)
	else:
		if cost.affordable.became_true.is_connected(autobuy_check):
			cost.affordable.became_true.disconnect(autobuy_check)
			for cur in produced_currencies:
				wa.get_currency(cur).net_rate.positive.became_false.disconnect(autobuy_check)
			for cur in required_currencies:
				wa.get_currency(cur).net_rate.positive.became_false.disconnect(autobuy_check)



func lored_vicos_ready() -> void:
	if purchased.is_true():
		work()



func add_fuel_rate() -> void:
	if not fuel_rate_added:
		fuel_rate_added = true
		wa.add_loss_rate(fuel_currency, fuel_cost.get_value())


func subtract_fuel_rate() -> void:
	if fuel_rate_added:
		fuel_rate_added = false
		wa.subtract_loss_rate(fuel_currency, fuel_cost.get_value())



func emit_currency_produced(amount: Big) -> void:
	currency_produced.emit(amount)



func clear_emote_queue() -> void:
	emote_queue.clear()


func first_second_of_run_autobuy_check() -> void:
	if gv.run_duration.greater_equal(1):
		autobuy_check()
		if gv.run_duration.changed.is_connected(first_second_of_run_autobuy_check):
			gv.run_duration.changed.disconnect(first_second_of_run_autobuy_check)



func apply_limit_break(modifier: Big) -> void:
	output.increase_multiplied(modifier)
	input.increase_multiplied(modifier)


func update_limit_break(prev_mod: Big, modifier: Big) -> void:
	output.alter_value(output.multiplied, prev_mod, modifier)
	input.alter_value(input.multiplied, prev_mod, modifier)


func remove_limit_break(modifier: Big) -> void:
	output.decrease_multiplied(modifier)
	input.decrease_multiplied(modifier)


func difficulty_changed() -> void:
	output.decrease_multiplied(df.prev_output)
	output.increase_multiplied(df.output.get_value())
	input.decrease_multiplied(df.prev_input)
	input.increase_multiplied(df.input.get_value())
	fuel.decrease_multiplied(df.prev_fuel)
	fuel.increase_multiplied(df.fuel.get_value())
	fuel_cost.decrease_multiplied(df.prev_fuel_cost)
	fuel_cost.increase_multiplied(df.fuel_cost.get_value())
	haste.decrease_multiplied(df.prev_haste)
	haste.increase_multiplied(df.haste.get_value())
	crit.decrease_multiplied(df.prev_crit)
	crit.increase_multiplied(df.crit.get_value())


# - Actions


func prestige(_stage: int) -> void:
	if persist.through_stage(_stage):
		return
	if _stage >= stage:
		reset(false)
		if not gv.run_duration.changed.is_connected(first_second_of_run_autobuy_check):
			gv.run_duration.changed.connect(first_second_of_run_autobuy_check)


func hard_reset() -> void:
	reset(true)


func reset(hard: bool):
	emoting.set_to(false)
	status.reset()
	active_currency.reset()
	purchased.set_to(false)
	if hard:
		output.reset()
		input.reset()
		haste.reset()
		fuel.reset()
		fuel_cost.reset()
		cost.reset()
		level.reset()
		autobuy.set_to(false)
		time_spent_asleep = 0.0
		purchased.reset()
		unlocked.reset()
		for job in jobs:
			if not jobs[job].unlocked_by_default:
				lock_job(job)
	else:
		set_level_to(0)
		fuel.fill_up()
		cost.recheck()
		if type == Type.STONE:
			fuel.add(9)
	wake_up()
	if working.is_true():
		stop_job()
		working.set_to(false)
	
	if hard:
		if purchased.is_true_by_default():
			force_purchase()



func force_purchase() -> void:
	if purchased.is_false() and purchased.is_true_on_reset():
		if unlocked.is_false():
			unlocked.set_to(true)
		last_purchase_automatic = true
		last_purchase_forced = true
		purchase()
		cost.recheck()


func manual_purchase() -> void:
	last_purchase_automatic = false
	last_purchase_forced = false
	cost.purchase(true)
	purchase()
	first_purchase_ever()

var last_reason_autobuy: String
var amount_to_autobuy := -1

func autobuy_check() -> void:
	var val = should_autobuy()
#	if type == Type.COAL:
#		printt(key, last_reason_autobuy)
	if val:
		#printt(key, last_reason_autobuy)
		automatic_purchase(amount_to_autobuy)
#		autobuy_on_cooldown = true
#		await gv.get_tree().physics_frame
#		autobuy_on_cooldown = false
	else:
		last_reason_autobuy = ""


func should_autobuy() -> bool:
	amount_to_autobuy = -1
	if (
		autobuy.is_true()
		and not autobuy_on_cooldown
		and unlocked.is_true()
		and gv.run_duration.greater_equal(1)
		and can_afford()
		and asleep.is_false()
	):
		if (
			type == Type.GALENA and not lv.is_lored_purchased(Type.DRAW_PLATE)
			or type == Type.WOOD and not lv.is_lored_purchased(Type.SEEDS)
		):
			last_reason_autobuy = "NO: is galena, and wood not yet bought"
			return false
		
		if (
			stage == 2
			and not lv.extra_normal_menu_unlocked
			and not type in lv.loreds_required_for_extra_normal_menu
		):
			last_reason_autobuy = "NO: s2 loreds not purchased"
			return false
		
		if purchased.is_false():
			last_reason_autobuy = "wasn't purchased"
			amount_to_autobuy = 1
			return true
		
		if not cost.is_safe_to_purchase():
			last_reason_autobuy = "Cost was not safe to purchase!"
			return false
		
		if ( # upgrade conditions
			(
				stage == 1
				and level.less(5)
				and up.is_upgrade_purchased(Upgrade.Type.DONT_TAKE_CANDY_FROM_BABIES)
			) or (
				type in [Type.MALIGNANCY, Type.IRON, Type.COPPER]
				and up.is_upgrade_purchased(Upgrade.Type.THE_WITCH_OF_LOREDELITH)
			)
			or (
				type == Type.IRON_ORE
				and up.is_upgrade_purchased(Upgrade.Type.I_RUN)
			)
			or (
				type == Type.COPPER_ORE
				and up.is_upgrade_purchased(Upgrade.Type.THE_THIRD)
			)
			or (
				type == Type.COAL
				and up.is_upgrade_purchased(Upgrade.Type.WAIT_THATS_NOT_FAIR)
			)
		):
			last_reason_autobuy = "upgrade reason"
			return true
		
		if required_currencies.size() > 0:
			if wa.currencies_have_negative_net(required_currencies):
				last_reason_autobuy = "NO: required curs are negative net"
				return false
		
#		if up.is_upgrade_purchased(Upgrade.Type.LIMIT_BREAK):
#			last_reason_autobuy = "Limit Break is purchased"
#			return true
		
		if key_lored:
			last_reason_autobuy = "is a key lored"
			if required_currencies.size() > 0:
				amount_to_autobuy = 1
			return true
		
		if wa.currencies_have_negative_net(produced_currencies):
			last_reason_autobuy = "produced curs are negative net"
			if required_currencies.size() > 0:
				amount_to_autobuy = 1
			return true
	
	last_reason_autobuy = "NO: bottom"
	return false


func automatic_purchase(levels_to_buy := -1) -> void:
	last_purchase_automatic = true
	last_purchase_forced = false
	if purchased.is_false():
		purchased.set_to(true)
	set_level_to(level.get_value() + 1)
	if stage == 1 and level.equal(5):
		became_an_adult.emit()


func purchase() -> void:
	level_up()


func first_purchase_ever() -> void:
	if get_times_purchased() == 1:
		wa.unlock_currencies(produced_currencies)


func level_up() -> void:
	if purchased.is_false():
		purchased.set_to(true)
	set_level_to(level.get_value() + 1)
	if stage == 1 and level.equal(5):
		became_an_adult.emit()


func set_level_to(_level: int) -> void:
	cost.increase(_level)
	output.set_from_level(Big.new(output_increase.get_value()).power(_level - 1))
	input.set_from_level(Big.new(input_increase.get_value()).power(_level - 1))
	var fuel_percent = fuel.get_current_percent()
	fuel.set_from_level(Big.new(2).power(_level - 1))
	fuel.set_to_percent(fuel_percent)
	
	subtract_fuel_rate()
	fuel_cost.set_from_level(Big.new(2).power(_level - 1))
	if purchased.is_true():
		add_fuel_rate()
	
	level.set_to(_level)



func unlock() -> void:
	unlocked.set_to(true)


func go_to_sleep() -> void:
	if working.is_true():
		last_job.stop_and_refund()
	asleep.set_to(true)


func wake_up() -> void:
	asleep.set_to(false)


func calculate_time_in_bed() -> void:
	var time_in_bed = Time.get_unix_time_from_system() - time_went_to_bed
	time_spent_asleep += time_in_bed
	time_went_to_bed = 0.0




func emote_now(emote: Emote) -> void:
	emoting.set_to(true)
	vico.emote(emote)
	emote.connect("finished", emote_finished)


func emote_finished(_emote: Emote) -> void:
	emoting.set_to(false)



func add_influencing_upgrade(upgrade: int) -> void:
	if not upgrade in upgrades:
		upgrades.append(upgrade)
		up.get_upgrade(upgrade).upgrade_purchased_changed.connect(influencing_upgrade_purchased_changed)
		influencing_upgrade_purchased_changed(up.get_upgrade(upgrade))


func influencing_upgrade_purchased_changed(upgrade: Upgrade) -> void:
	if upgrade.purchased.is_true():
		unpurchased_upgrades.erase(upgrade.type)
	else:
		if not upgrade.type in unpurchased_upgrades:
			unpurchased_upgrades.append(upgrade.type)



func enqueue_emote(emote: Emote) -> void:
	emote_queue.append(emote)


func emote_next_in_line() -> void:
	if (
		emoting.is_false()
		and emote_queue.size() > 0
	):
		var emote: Emote = emote_queue[emote_queue.size() - 1]
		em.emote_now(emote)
		emote_queue.erase(emote)
		if emote_queue.size() > 0:
			return



func connect_limit_break(sig: Signal) -> void:
	sig.connect(update_limit_break)


func disconnect_limit_break(sig: Signal) -> void:
	sig.disconnect(update_limit_break)



# - Buffs


func receive_buff() -> void:
	if purchased.is_false():
		if not purchased.became_true.is_connected(start_all_buffs):
			purchased.became_true.connect(start_all_buffs)
	received_buff.emit()


func start_all_buffs() -> void:
	if purchased.became_true.is_connected(start_all_buffs):
		purchased.became_true.disconnect(start_all_buffs)
	for buff in Buffs.get_buffs(self):
		buff.start()



# - Job

func work(job_type: int = get_next_job_automatically()) -> void:
	if (
		purchased.is_false()
		or unlocked.is_false()
		or working.is_true()
		or asleep.is_true()
		or SaveManager.loading.is_true()
	):
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
	if purchased.is_false():
		return -1
	for _type in sorted_jobs:
		var job: Job = jobs[_type]
		if job.can_start():
			return _type
	return -1


func start_job(_type: int) -> void:
	lv.lored_became_active(type)
	reason_cannot_work.set_to(ReasonCannotWork.CAN_WORK)
	last_job = jobs[_type]
	last_job.start()
	working.set_to(true)
	if vico == null:
		return
	status.set_to(last_job.status_text)
	active_currency.set_to(last_job.get_primary_currency())
	vico.start_job(last_job)
	job_started.emit()


func stop_job() -> void:
	if working.is_true():
		last_job.stop()
	working.set_to(false)


func job_completed() -> void:
	working.set_to(false)
	vico.job_completed()
	emit_signal("completed_job")


func job_cut_short() -> void:
	working.set_to(false)



func determine_why_cannot_work() -> void:
	lv.lored_became_inactive(type)
	if fuel.get_current_percent() <= lv.FUEL_DANGER:
		cannot_work(ReasonCannotWork.INSUFFICIENT_FUEL)
	elif jobs[sorted_jobs[1]].has_required_currencies:
		cannot_work(ReasonCannotWork.INSUFFICIENT_CURRENCIES)
	else:
		cannot_work(ReasonCannotWork.UNKNOWN)


func cannot_work(reason: int) -> void:
	if reason == ReasonCannotWork.CAN_WORK:
		return
	reason_cannot_work.set_to(reason)
	match reason:
		ReasonCannotWork.INSUFFICIENT_FUEL:
			var _fuel = Big.new(fuel.get_total()).d(2).text
			var cur = wa.get_icon_and_name_text(fuel_currency)
			status.set_to("Awaiting %s %s." % [_fuel, cur])
			active_currency.set_to(fuel_currency)
		ReasonCannotWork.INSUFFICIENT_CURRENCIES:
			if stage in [1, 2]:
				var job_name = jobs[sorted_jobs[1]].name
				status.set_to("Will %s ASAP" % job_name)
			else:
				status.set_to("Unable to work")
			active_currency.reset()
	became_unable_to_work.emit()



# - Handy

func disconnect_second_work_thing() -> void:
	await gv.one_second
	gv.one_second.disconnect(work)


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
	
	if (
		fuel.get_current_percent() < lv.FUEL_DANGER
		and wa.is_currency_unlocked(fuel_currency)
		and df.fuel.less_equal(2)
	):
		if randi() % 100 < 30:
			possible_types["ACCEPTABLE_FUEL"] = 50
		else:
			wished_currency = fuel_currency
			possible_types["COLLECT_CURRENCY"] = 50
		total_weight += 50
	elif reason_cannot_work.not_equal(ReasonCannotWork.CAN_WORK) and required_currencies.size() > 1:
		wished_currency = required_currencies[randi() % (required_currencies.size() - 1) + 1]
		possible_types["COLLECT_CURRENCY"] = 50
		total_weight += 50
	else:
		if wi.random_wish_limit >= 2 and randi() % 100 < 10:
			wished_currency = Currency.Type.JOY
			possible_types["COLLECT_CURRENCY"] = 10
			total_weight += 10
		else:
			wished_currency = wa.get_random_wish_eligible_currency()
			possible_types["COLLECT_CURRENCY"] = 30
			total_weight += 30
	
	for upgrade in unpurchased_upgrades:
		var upgrade_eta = up.get_eta(upgrade)
		if upgrade_eta.equal(0):
			continue
		if (
			up.is_upgrade_unlocked(upgrade)
			and upgrade_eta.less_equal(60)
			and up.is_upgrade_menu_unlocked(up.get_upgrade(upgrade).upgrade_menu)
		):
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

func is_visible() -> bool:
	if lv.lored_container.current_tab + 1 != stage:
		return false
	return vico.visible


func can_afford() -> bool:
	return cost.affordable.get_value()


func get_level_text() -> String:
	return level.text


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


func get_attributes_by_currency(currency_type: Currency.Type) -> Array:
	var arr := []
	for job in jobs.values():
		arr += job.get_attributes_by_currency(currency_type)
	return arr


func get_job(job: int) -> Job:
	return jobs[job]


func get_used_currency_rate(cur: int) -> Big:
	var rate = Big.new(0)
	
	if wa.get_currency(cur).used_for_fuel and cur == fuel_currency:
		rate.a(fuel_cost.get_value())
	
	for job in jobs.values():
		if job.type == Job.Type.REFUEL or job.do_not_alter_rates:
			continue
		if job.uses_currency(cur):
			rate.a(
				Big.new(job.required_currencies.cost[cur].get_value()).d(
					job.duration.get_as_float(),
				)
			)
	return rate


func get_produced_currency_rate(cur: int) -> Big:
	var rate = Big.new(0)
	for job in jobs.values():
		if job.produces_currency(cur) and not job.do_not_alter_rates:
			if cur in job.produced_currencies.keys():
				rate.a(
					Big.new(job.produced_currencies[cur].get_value()).d(
						job.duration.get_as_float()
					)
				)
			else:
				rate.a(
					Big.new(job.bonus_production[cur]).m(output.get_value()).d(
						job.duration.get_as_float()
					)
				)
	
	return rate


func cap_gain_loss_if_uses_currency(cur: int) -> void:
	for job in jobs.values():
		if job.uses_currency(cur):
			for cur2 in job.produced_currencies:
				var cur_gain_loss = wa.get_currency(cur).gain_over_loss
				var cur2_gain_loss = wa.get_currency(cur2).gain_over_loss
				if cur2_gain_loss > cur_gain_loss or cur2_gain_loss == -1:
					wa.get_currency(cur2).gain_over_loss = wa.get_currency(cur).gain_over_loss



func get_primary_rate() -> Big:
	var rate := Big.new(0)
	for job in jobs.values():
		if job.type == Job.Type.REFUEL or job.do_not_alter_rates:
			continue
		if not job.produces_currency(primary_currency):
			continue
		if primary_currency in job.produced_currencies.keys():
			rate.a(
				Big.new(
					job.produced_currencies[primary_currency].get_value()
				).d(
					job.duration.get_as_float()
				)
			)
		if primary_currency in job.bonus_production.keys():
			rate.a(
				Big.new(
					job.bonus_production[primary_currency]
				).m(
					output.get_value()
				).d(
					job.duration.get_as_float()
				)
			)
	return rate


func get_times_purchased() -> int:
	return cost.times_purchased.get_value()
