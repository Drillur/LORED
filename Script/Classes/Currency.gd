class_name Currency
extends RefCounted


var saved_vars := [
	"unlocked",
]

enum Type {
	STONE,
	COAL,
	IRON_ORE,
	COPPER_ORE,
	IRON,
	COPPER, # 5
	GROWTH,
	JOULES,
	CONCRETE,
	MALIGNANCY,
	TARBALLS, # 10
	OIL, # 11
	
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
	EMBRYO,
	TUMORS, # 36
	
	# -------
	# Stage 3 
	
	FLOWER_SEED, # 37
	MANA,
	MANA_CRYSTAL,
	BLOOD,
	RANDOM_FLOWER, # 40
	
	# Flowers
	
	NEBULA_NECTAR,
	MOONLIGHT_BLOSSOM,
	BLOODROOT,
	MALIGNANT_MAGNOLIA,
	STARDUST_ORCHID,
	CELESTIA_ROSE,
	TWILIGHT_DAISY,
	EMBER_TULIP,
	PHOENIX_PETAL,
	QUEEN_OF_THE_NIGHT,
	RADIANT_DAHLIA,
	STARLILY,
	BLACK_ROSE,
	STARFIRE_SUNFLOWER,
	SLIPPER_GINGER,
	CHOCOLATE_COSMOS,
	CORPSE_LILY,
	ENCHANTED_IRIS,
	SHIMMERING_ROSE,
	ENIGMA_DAFFODIL,
	FROSTFIRE_SNAP,
	JADE_VINE,
	TITAN_ARUM,
	PETALWING_LILY,
	GHOST_ORCHID, # - - - 4
	CELESTIAL_ZINNIA,
	SPARKLEFERN,
	LUMINARA_STARLILY,
	MOONFLOWER,
	BLACK_ORCHID,
	RAINBOW_EUCALYPTUS,
	SERAPHINA_SPARKLEFERN,
	EVERBLOOM,
	FLAMINGO_FLOWER,
	AMETHYST_LILY,
	SAPPHIRE_POPPY,
	EBONY_DAISY,
	CRYSTAL_TWILIGHT_BLOSSOM,
	EMBERGLADE,
	VELVET_PANSY,
	TRANQUIL_LILY,
	WHISPERING_WISTERIA,
	ASTRAL_PETUNIA,
	IMPERIAL_IRIS,
	DREAMLEAF_FERN,
	MOONLIGHT_ORCHID, # - - - 3
	RADIANT_ROSE,
	DREAMSHADE,
	AURORA_LILY,
	SILVERBELL_BELLFLOWER,
	CRYSTAL_LOTUS,
	BLUE_PUYA,
	MARBLE_TULIP,
	JACARANDA,
	ANGELIC_DAFFODIL,
	ETERNAL_BLOSSOM,
	PETALWISP,
	FROSTBLOOM_JASMINE,
	CELESTIAL_GLADIOLUS,
	CHERRY_BLOSSOM,
	WISPFLOWER,
	PRISMATIC_IRIS,
	VELVET_VIOLET,
	OPALINE_PETUNIA,
	ENCHANTED_CARNATION,
	ROSE, # - - - 2
	ORCHID,
	LILY,
	DAISY,
	IRIS,
	CARNATION,
	PANSY,
	CHRYSANTHEMUM,
	GERBERA,
	PEONY,
	SNAPDRAGON,
	LAVENDER,
	LOTUS,
	POPPY,
	HIBISCUS,
	DAFFODIL,
	ZINNIA,
	JASMINE,
	LAVATERA,
	STATICE,
	PROTEA,
	LISIANTHUS,
	CAMELLIA,
	RANUNCULUS,
	FOXGLOVE,
	WISTERIA, # - - - 1
	YARROW,
	GAILLARDIA,
	SWEETPEA,
	MORNING_GLORY,
	PETUNIA,
	GAZANIA,
	MILKWEED,
	PITCHER_PLANT,
	COCKSCOMB,
	PINCUSHION,
	JACOBS_LADDER,
	BABYS_BREATH,
	BEE_BALM,
	ROSEMARY,
	SUNFLOWER,
	DANDELION,
	GERANIUM,
	MARIGOLD,
	TULIP,
	VIOLET,
	HYDRANGEA,
	GINGER_ROOT,
	RAGWORT, # - - - 0
	GOOGRASS,
	STINKWEED,
	SNEEZEWEED,
	BITTERWEED,
	GOUTWEED,
	SKUNK_CABBAGE,
	DEADNETTLE,
	KNAPWEED,
	KNOTWEED,
	SNOTWEED,
	SCHLONKWEED,
	POOPGRASS,
	ASSGRASS,
	PEEWEED,
	BOOGERBLOSSOM,
	HEMHORROID_HERB,
	DONKY_DAISY,
	SCHLONKY_DAISY,
	BLEACHBLOOM,
	SLIMEWEED,
	PUS_POSY,
	OOZEWORT,
	SCABLEAF,
	GURGLEGRASS,
	BLISTERBRANCH,
	PIMPLEGRASS,
	SPLATROOT,
	RETCHLEAF,
	SLOPDRAGON,
	EVERSTAIN,
	# Flowers
	# -------
	
	SPIRIT,
	
	# stage 3 goes above here
	
	
	# stage 4 goes above here
	
	JOY,
	GRIEF,
}

enum SafetyType { SAFE, LORED_PURCHASED, }

signal increased_by_lored(amount)
signal increased_by_buff(amount)
#signal increased_by_player(amount)
signal increased(amount)
signal decreased_by_lored(amount)

var type: Type
var stage: Stage.Type
var safety_type := SafetyType.SAFE
var safety_subject: int

var details := Details.new()

var key: String

var count: Big

var subtracted_by_loreds := Big.new(0, true)
var subtracted_by_player := Big.new(0, true)
var added_by_loreds := Big.new(0, true)
var added_by_player := Big.new(0, true)
var added_by_buffs := Big.new(0, true)

var safe := LoudBool.new(true)
var unlocked := LoudBool.new(false)
func unlocked_changed() -> void:
	if unlocked.is_true():
		saved_vars.append("count")
		saved_vars.append("subtracted_by_loreds")
		saved_vars.append("subtracted_by_player")
		saved_vars.append("added_by_loreds")
		saved_vars.append("added_by_buffs")
	else:
		saved_vars.erase("count")
		saved_vars.erase("subtracted_by_loreds")
		saved_vars.erase("subtracted_by_player")
		saved_vars.erase("added_by_loreds")
		saved_vars.erase("added_by_buffs")

var persist := Persist.new()
var use_allowed := LoudBool.new(true)
var used_for_fuel := false

var net_rate := Big.new(0, true)
var gain_rate := Value.new(0)
var loss_rate := Value.new(0)

var is_flower := false

var weight := 1
var last_crit_modifier := 1.0

var produced_by := []
var used_by := []




func _init(_type := Type.STONE) -> void:
	type = _type
	key = Type.keys()[type]
	details.name = key.replace("_", " ").capitalize()
	
	unlocked.changed.connect(unlocked_changed)
	
	if type <= Type.OIL:
		stage = Stage.Type.STAGE1
	elif type <= Type.TUMORS:
		stage = Stage.Type.STAGE2
	elif type <= Type.SPIRIT:
		stage = Stage.Type.STAGE3
	elif type < Type.JOY:
		stage = Stage.Type.STAGE4
	else:
		stage = Stage.Type.NO_STAGE
	
	is_flower = type >= Type.NEBULA_NECTAR and type <= Type.EVERSTAIN
	
	if has_method("init_" + key):
		call("init_" + key)
	
	if safety_type == SafetyType.SAFE:
		safe.set_to(true)
	
	if stage == 0:
		persist.s4.set_to(true)
	
	if count == null:
		count = Big.new(0, true)
	if details.icon == null:
		wa.curs_without_icons.append(key)
		if is_flower:
			details.icon = res.get_resource("001")
		else:
			details.icon = res.get_resource("Delete")
	if details.color == Color.BLACK:
		details.color = Color.WHITE
	
	gv.prestige.connect(prestige)
	gv.hard_reset.connect(reset)



func init_STONE() -> void:
	count = Big.new(5, true)
	details.color = Color(0.79, 0.79, 0.79)
	details.icon = res.get_resource("stone")
	weight = 3


func init_COAL() -> void:
	details.color = Color(0.7, 0, 1)
	details.icon = res.get_resource("coal")
	details.description = "Used primarily as fuel for LOREDs!"
	weight = 2
	used_for_fuel = true


func init_IRON_ORE() -> void:
	details.color = Color(0, 0.517647, 0.905882)
	details.icon = res.get_resource("irono")


func init_COPPER_ORE() -> void:
	details.color = Color(0.7, 0.33, 0)
	details.icon = res.get_resource("copo")


func init_IRON() -> void:
	count = Big.new(8, true)
	details.color = Color(0.07, 0.89, 1)
	details.icon = res.get_resource("iron")
	details.description = "It's possible that this is toast."
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.IRON)


func init_COPPER() -> void:
	count = Big.new(8, true)
	details.color = Color(1, 0.74, 0.05)
	details.icon = res.get_resource("cop")
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.COPPER)


func init_GROWTH() -> void:
	details.color = Color(0.79, 1, 0.05)
	details.icon = res.get_resource("growth")
	details.description = "What? This game is weird!"
	weight = 2


func init_JOULES() -> void:
	details.color = Color(1, 0.98, 0)
	details.icon = res.get_resource("jo")
	details.description = "Used primarily as fuel for LOREDs!"
	weight = 2
	used_for_fuel = true
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.JOULES)


func init_CONCRETE() -> void:
	details.color = Color(0.35, 0.35, 0.35)
	details.icon = res.get_resource("conc")
	weight = 3


func init_MALIGNANCY() -> void:
	count = Big.new(10, true)
	details.color = Color(0.88, .12, .35)
	details.icon = res.get_resource("malig")
	persist.s1.set_to(true)
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.TARBALLS)


func init_TARBALLS() -> void:
	details.color = Color(.56, .44, 1)
	details.icon = res.get_resource("tar")
	weight = 2


func init_OIL() -> void:
	details.color = Color(.65, .3, .66)
	details.icon = res.get_resource("oil")


func init_WATER() -> void:
	details.color = Color(0, 0.647059, 1)
	details.icon = res.get_resource("water")
	details.description = "The 4x2 Lego piece of life."
	weight = 2


func init_HUMUS() -> void:
	details.color = Color(0.458824, 0.25098, 0)
	details.icon = res.get_resource("humus")
	details.description = "Actual shit."


func init_SEEDS() -> void:
	count = Big.new(2, true)
	details.color = Color(1, 0.878431, 0.431373)
	details.icon = res.get_resource("seed")
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.SEEDS)


func init_TREES() -> void:
	details.color = Color(0.772549, 1, 0.247059)
	details.icon = res.get_resource("tree")


func init_SOIL() -> void:
	count = Big.new(25, true)
	details.color = Color(0.737255, 0.447059, 0)
	details.icon = res.get_resource("soil")
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.SOIL)


func init_AXES() -> void:
	count = Big.new(5, true)
	details.color = Color(0.691406, 0.646158, 0.586075)
	details.icon = res.get_resource("axe")
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.AXES)


func init_WOOD() -> void:
	count = Big.new(80, true)
	details.color = Color(0.545098, 0.372549, 0.015686)
	details.icon = res.get_resource("wood")
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.WOOD)


func init_HARDWOOD() -> void:
	count = Big.new(95, true)
	details.color = Color(0.92549, 0.690196, 0.184314)
	details.icon = res.get_resource("hard")
	details.description = "( ͡⚆ ͜ʖ ͡⚆)"
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.HARDWOOD)


func init_LIQUID_IRON() -> void:
	details.color = Color(0.27, 0.888, .9)
	details.icon = res.get_resource("liq")


func init_STEEL() -> void:
	count = Big.new(25, true)
	details.color = Color(0.607843, 0.802328, 0.878431)
	details.icon = res.get_resource("steel")
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.STEEL)


func init_SAND() -> void:
	count = Big.new(250, true)
	details.color = Color(.87, .70, .45)
	details.icon = res.get_resource("sand")
	details.description = "It's roarse, and cough, and it gets eherweyeve!"
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.SAND)


func init_GLASS() -> void:
	count = Big.new(30, true)
	details.color = Color(0.81, 0.93, 1.0)
	details.icon = res.get_resource("glass")
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.GLASS)


func init_DRAW_PLATE() -> void:
	details.color = Color(0.333333, 0.639216, 0.811765)
	details.icon = res.get_resource("draw")


func init_WIRE() -> void:
	count = Big.new(20, true)
	details.color = Color(0.9, 0.6, 0.14)
	details.icon = res.get_resource("wire")
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.WIRE)


func init_GALENA() -> void:
	details.color = Color(0.701961, 0.792157, 0.929412)
	details.icon = res.get_resource("gale")


func init_LEAD() -> void:
	details.color = Color(0.53833, 0.714293, 0.984375)
	details.icon = res.get_resource("lead")


func init_PETROLEUM() -> void:
	details.color = Color(0.76, 0.53, 0.14)
	details.icon = res.get_resource("pet")


func init_WOOD_PULP() -> void:
	details.color = Color(0.94902, 0.823529, 0.54902)
	details.icon = res.get_resource("pulp")


func init_PAPER() -> void:
	details.color = Color(0.792157, 0.792157, 0.792157)
	details.icon = res.get_resource("paper")


func init_PLASTIC() -> void:
	details.color = Color(0.85, 0.85, 0.85)
	details.icon = res.get_resource("plast")
	weight = 2


func init_TOBACCO() -> void:
	details.color = Color(0.639216, 0.454902, 0.235294)
	details.icon = res.get_resource("toba")


func init_CIGARETTES() -> void:
	details.color = Color(0.929412, 0.584314, 0.298039)
	details.icon = res.get_resource("ciga")
	weight = 2


func init_CARCINOGENS() -> void:
	details.color = Color(0.772549, 0.223529, 0.192157)
	details.icon = res.get_resource("carc")
	weight = 2


func init_EMBRYO() -> void:
	details.color = Color(1, .54, .54)


func init_TUMORS() -> void:
	details.color = Color(1, .54, .54)
	details.icon = res.get_resource("tum")
	persist.s2.set_to(true)


func init_FLOWER_SEED() -> void:
	details.color = Color(1, 0.878431, 0.431373)
	details.icon = res.get_resource("seed")


func init_MANA() -> void:
	details.color = Color(0.721569, 0.34902, 0.901961) # violet
	details.alt_color = Color(0, 0.709804, 1) # blue
	details.icon = res.get_resource("water")


func init_MANA_CRYSTAL() -> void:
	details.color = Color(0.721569, 0.34902, 0.901961) # violet
	details.alt_color = Color(0, 0.709804, 1) # blue
	details.icon = res.get_resource("water")


func init_BLOOD() -> void:
	details.color = Color(1, 0, 0)


func init_SPIRIT() -> void:
	details.color = Color(0.88, .12, .35)
	persist.s3.set_to(true)


func init_JOY() -> void:
	details.color = Color(1, 0.909804, 0)
	details.icon = res.get_resource("Joy")
	persist.s4.set_to(true)


func init_GRIEF() -> void:
	details.color = Color(0.74902, 0.203922, 0.533333)
	details.icon = res.get_resource("Grief")
	persist.s4.set_to(true)


func init_RANDOM_FLOWER() -> void:
	details.icon = res.get_resource("001")
func init_BABYS_BREATH() -> void:
	details.icon = res.get_resource("004")
	details.name = "Baby's Breath"
func init_MILKWEED() -> void:
	details.icon = res.get_resource("007")
func init_BEE_BALM() -> void:
	details.icon = res.get_resource("012")
func init_VIOLET() -> void:
	details.icon = res.get_resource("018")
func init_PINCUSHION() -> void:
	details.icon = res.get_resource("020")
func init_LAVENDER() -> void:
	details.icon = res.get_resource("021")
func init_RAGWORT() -> void:
	details.icon = res.get_resource("027")
func init_SCHLONKWEED() -> void:
	details.icon = res.get_resource("027")
func init_PUS_POSY() -> void:
	details.icon = res.get_resource("027")
func init_GOOGRASS() -> void:
	details.icon = res.get_resource("028")
func init_POOPGRASS() -> void:
	details.icon = res.get_resource("028")
func init_OOZEWORT() -> void:
	details.icon = res.get_resource("028")
func init_STINKWEED() -> void:
	details.icon = res.get_resource("029")
func init_ASSGRASS() -> void:
	details.icon = res.get_resource("029")
func init_SCABLEAF() -> void:
	details.icon = res.get_resource("029")
func init_SNEEZEWEED() -> void:
	details.icon = res.get_resource("030")
func init_PEEWEED() -> void:
	details.icon = res.get_resource("030")
func init_GURGLEGRASS() -> void:
	details.icon = res.get_resource("030")
func init_BITTERWEED() -> void:
	details.icon = res.get_resource("031")
func init_BOOGERBLOSSOM() -> void:
	details.icon = res.get_resource("031")
func init_BLISTERBRANCH() -> void:
	details.icon = res.get_resource("031")
func init_GOUTWEED() -> void:
	details.icon = res.get_resource("032")
func init_HEMHORROID_HERB() -> void:
	details.icon = res.get_resource("032")
func init_PIMPLEGRASS() -> void:
	details.icon = res.get_resource("032")
func init_DEADKNETTLE() -> void:
	details.icon = res.get_resource("033")
func init_DONKY_DAISY() -> void:
	details.icon = res.get_resource("033")
func init_SPLATROOT() -> void:
	details.icon = res.get_resource("033")
func init_KNAPWEED() -> void:
	details.icon = res.get_resource("034")
func init_SCHLONKY_DAISY() -> void:
	details.icon = res.get_resource("034")
func init_RETCHLEAF() -> void:
	details.icon = res.get_resource("034")
func init_KNOTWEED() -> void:
	details.icon = res.get_resource("035")
func init_BLEACHBLOOM() -> void:
	details.icon = res.get_resource("035")
func init_SLOPDRAGON() -> void:
	details.icon = res.get_resource("035")
func init_SNOTWEED() -> void:
	details.icon = res.get_resource("036")
func init_SLIMEWEED() -> void:
	details.icon = res.get_resource("036")
func init_EVERSTAIN() -> void:
	details.icon = res.get_resource("036")
func init_DAISY() -> void:
	details.icon = res.get_resource("043")
func init_ROSEMARY() -> void:
	details.icon = res.get_resource("051")
func init_JACOBS_LADDER() -> void:
	details.name = "Jacob's Ladder"
	details.icon = res.get_resource("053")
func init_HYDRANGEA() -> void:
	details.icon = res.get_resource("056")
func init_DANDELION() -> void:
	details.icon = res.get_resource("062")
func init_YARROW() -> void:
	details.icon = res.get_resource("062")
func init_SUNFLOWER() -> void:
	details.icon = res.get_resource("063")
func init_GINGER_ROOT() -> void:
	details.icon = res.get_resource("ginger_01")
func init_TULIP() -> void:
	details.icon = res.get_resource("079")
func init_MORNING_GLORY() -> void:
	details.icon = res.get_resource("084")
func init_CARNATION() -> void:
	details.icon = res.get_resource("090")
func init_ROSE() -> void:
	details.icon = res.get_resource("091")
func init_GERANIUM() -> void:
	details.icon = res.get_resource("093")
func init_COCKSCOMB() -> void:
	details.icon = res.get_resource("096")
func init_PITCHER_PLANT() -> void:
	details.icon = res.get_resource("096")
func init_MARIGOLD() -> void:
	details.icon = res.get_resource("099")
func init_SWEETPEA() -> void:
	details.icon = res.get_resource("peas_01")



# - Setup

func set_safety_condition(_type: SafetyType, _subject: int) -> void:
	safety_type = _type
	safety_subject = _subject
	await lv.loreds_initialized.became_true
	match safety_type:
		SafetyType.LORED_PURCHASED:
			lv.get_lored(safety_subject).purchased.changed.connect(safety_check)
			safety_check()



# - Signals


func prestige(_stage: int) -> void:
	if persist.through_stage(_stage):
		return
	if _stage >= stage:
		count.reset()
		if count.less(count.base):
			printerr("I didn't think this shit would ever print")
			count.set_to(count.base)



# - Actions


func reset():
	count.reset()


func safety_check() -> void:
	match safety_type:
		SafetyType.LORED_PURCHASED:
			safe.set_to(lv.is_lored_purchased(safety_subject))


func unlock() -> void:
	unlocked.set_to(true)



func add(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	count.a(amount)
	increased.emit(amount)


func add_from_lored(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	add(amount)
	added_by_loreds.a(amount)
	increased_by_lored.emit(amount)


func add_from_player(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	add(amount)
	added_by_player.a(amount)
	#increased_by_player.emit(amount)


func add_from_buff(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	add(amount)
	added_by_buffs.a(amount)
	increased_by_buff.emit(amount)


func subtract(amount) -> void:
	count.s(amount)


func subtract_from_lored(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	subtract(amount)
	subtracted_by_loreds.a(amount)
	decreased_by_lored.emit(amount)


func subtract_from_player(amount) -> void:
	subtract(amount)
	subtracted_by_player.a(amount)


func append_producer(lored: int) -> void:
	if not lored in produced_by:
		produced_by.append(lored)


func append_user(lored: int) -> void:
	if not lored in used_by:
		used_by.append(lored)


func erase_producer(lored: int) -> void:
	produced_by.erase(lored)


func erase_user(lored: int) -> void:
	used_by.erase(lored)



func add_gain_rate(amount) -> void:
	gain_rate.increase_added(amount)
	sync_rate()


func subtract_gain_rate(amount) -> void:
	gain_rate.decrease_added(amount)
	sync_rate()


func add_loss_rate(amount) -> void:
	loss_rate.increase_added(amount)
	sync_rate()


func subtract_loss_rate(amount) -> void:
	loss_rate.decrease_added(amount)
	sync_rate()


func sync_rate() -> void:
	var gain = gain_rate.get_value()
	var loss = loss_rate.get_value()
	if gain.greater_equal(loss):
		net_rate.positive.set_to(true)
		net_rate.set_to(Big.new(gain).s(loss))
	else:
		net_rate.positive.set_to(false)
		net_rate.set_to(Big.new(loss).s(gain))



func add_pending(amount: Big) -> void:
	count.add_pending(amount)


func subtract_pending(amount: Big) -> void:
	count.subtract_pending(amount)



# - Offline Earnings Shit

var gain_over_loss := -1.0:
	set(val):
		if gain_over_loss != val:
			gain_over_loss = val
			if gain_over_loss != 1:
				for lored_type in used_by:
					lv.get_lored(lored_type).cap_gain_loss_if_uses_currency(type)
var fuel_cur_gain_loss: float
var offline_production: Big
var positive_offline_rate: bool


func get_offline_production(time_offline: float) -> Big:
	var gain = Big.new(gain_rate.get_value()).m(gain_over_loss)
	
	var loss = Big.new(0)
	for x in used_by:
		var lored = lv.get_lored(x) as LORED
		if (
			lored.unlocked.is_true()
			and wa.is_currency_unlocked(lored.fuel_currency)
		):
			loss.a(lored.get_used_currency_rate(type))
	
	positive_offline_rate = gain.greater_equal(loss)
	
	var net: Big
	if positive_offline_rate:
		net = Big.new(gain).s(loss)
	else:
		net = Big.new(loss).s(gain)
	
	if net.equal(0):
		offline_production = Big.new(0)
	else:
		offline_production = Big.new(net).m(str(time_offline))
	
	return offline_production


func eligible_for_offline_earnings() -> bool:
	var cont = false
	for x in produced_by: # only need one lored producing this cur
		var lored = lv.get_lored(x)
		if (
			lored.unlocked.is_true()
			and lored.purchased.is_true()
			and wa.is_currency_unlocked(lored.fuel_currency)
		):
			cont = true
			break
	if not cont:
		return false
	cont = false
	for x in used_by:
		var lored = lv.get_lored(x)
		if (
			lored.unlocked.is_true()
			and lored.purchased.is_true()
		):
			cont = true
			break
	if not cont:
		return false
	return unlocked.get_value()


func set_gain_over_loss() -> void:
	if gain_over_loss == -1:
		if loss_rate.get_value().equal(0):
			gain_over_loss = 1.0
		else:
			gain_over_loss = min(1, gain_rate.get_value().percent(loss_rate.get_value()))



# - Get

func get_count_text() -> String:
	return count.text


func is_unlocked() -> bool:
	return unlocked.get_value()


func is_locked() -> bool:
	return not is_unlocked()


func get_eta(threshold: Big) -> Big:
	if (
		count.greater_equal(threshold)
		or net_rate.equal(0)
		or not lv.any_loreds_in_list_are_purchased(produced_by)
		or net_rate.positive.is_false()
	):
		return Big.new(0)
	
	var deficit = Big.new(threshold).s(count)
	return deficit.d(net_rate)


func get_eta_text(threshold: Big) -> String:
	var eta = get_eta(threshold)
	return gv.parse_time(eta)


func get_random_producer() -> LORED:
	return produced_by[randi() % produced_by.size()]


func get_fuel_currency() -> int:
	return lv.get_lored(produced_by[0]).fuel_currency
