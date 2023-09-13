class_name Upgrade
extends RefCounted



var saved_vars := [
	"unlocked",
	"times_purchased",
	"purchased",
	"effect",
	"will_apply_effect",
]


func load_finished() -> void:
	if purchased.is_true():
		if will_apply_effect:
			refund()
		unlocked.became_true.emit()
		unlocked.changed.emit(unlocked.get_value())



enum Type {
	MECHANICAL, # S2 Radiative
	LIMIT_BREAK,
	DONT_TAKE_CANDY_FROM_BABIES,
	SPLISHY_SPLASHY,
	MILK,
	FALCON_PAWNCH,
	SPEED_SHOPPER,
	AUTOSMITHY,
	GATORADE,
	KAIO_KEN,
	AUTOSENSU,
	APPLE_JUICE,
	DANCE_OF_THE_FIRE_GOD,
	SUDDEN_COMMISSION,
	PEPPERMINT_MOCHA,
	RASENGAN,
	MUDSLIDE,
	THE_GREAT_JOURNEY,
	BEAVER,
	MODS_ENABLED,
	COVENANT_DANCE,
	OVERTIME,
	BONE_MEAL,
	SILLY,
	SPEED_DOODS,
	EREBOR,
	CHILD_ENERGY,
	PLATE,
	MASTER,
	STRAWBERRY_BANANA_SMOOTHIE,
	AVATAR_STATE,
	AXELOT,
	GREEN_TEA,
	HAMON,
	AUTOSHIT,
	FRENCH_VANILLA,
	METAL_CAP,
	SMASHY_CRASHY,
	WATER,
	STAR_ROD,
	A_BABY_ROLEUM,
	POOFY_WIZARD_BOY,
	BENEFIT,
	AUTOAQUATICIDE,
	GO_ON_THEN_LEAD_US,
	THE_WITCH_OF_LOREDELITH,
	TOLKIEN,
	BEEKEEPING,
	ELBOW_STRAPS,
	AUTO_PERSIST,
	KETO,
	NOW_THATS_WHAT_IM_TALKIN_ABOUT,
	SCOOPY_DOOPY,
	THE_ATHORE_COMENTS_AL_TOTOL_LIES,
	ITS_SPREADIN_ON_ME,
	WHAT_IN_COUSIN_FUCKIN_TARNATION,
	MASTER_IRON_WORKER,
	JOINTSHACK,
	DUST,
	CAPITAL_PUNISHMENT,
	AROUSAL,
	AUTOFLOOF,
	ELECTRONIC_CIRCUITS,
	AUTOBADDECISIONMAKER,
	CONDUCT,
	PILLAR_OF_AUTUMN,
	WHAT_KIND_OF_RESOURCE_IS_TUMORS,
	DEVOUR,
	IS_IT_SUPPOSED_TO_BE_STICK_DUDES,
	I_DISAGREE,
	HOME_RUN_BAT,
	BLAM_THIS_PIECE_OF_CRAP,
	DOT_DOT_DOT,
	ONE_PUNCH,
	SICK_OF_THE_SUN,
	AXMAN13,
	CTHAEH,
	RED_NECROMANCY,
	UPGRADE_DESCRIPTION,
	GRIMOIRE,
	
	CANOPY, # S2 Extra Normal
	APPRENTICE_IRON_WORKER,
	DOUBLE_BARRELS,
	RAIN_DANCE,
	LIGHTHOUSE,
	ROGUE_BLACKSMITH,
	TRIPLE_BARRELS,
	BREAK_THE_DAM,
	THIS_MIGHT_PAY_OFF_SOMEDAY,
	DIRT_COLLECTION_REWARDS_PROGRAM,
	EQUINE,
	UNPREDICTABLE_WEATHER,
	DECISIVE_STRIKES,
	SOFT_AND_SMOOTH,
	FLIPPY_FLOPPIES,
	WOODTHIRSTY,
	SEEING_BROWN,
	WOODIAC_CHOPPER,
	CARLIN,
	HARDWOOD_YOURSELF,
	STEEL_YOURSELF,
	PLASMA_BOMBARDMENT,
	PATREON_ARTIST,
	MILLERY,
	QUAMPS,
	TWO_FIVE_FIVE_TWO,
	GIMP,
	SAGAN,
	HENRY_CAVILL,
	LEMBAS_WATER,
	BIGGER_TREES_I_GUESS,
	JOURNEYMAN_IRON_WORKER,
	CUTTING_CORNERS,
	QUORMPS,
	KILTY_SBARK,
	HOLE_GEOMETRY,
	CIORAN,
	WOOD_LORD,
	EXPERT_IRON_WORKER,
	THEYVE_ALWAYS_BEEN_FASTER,
	WHERES_THE_BOY_STRING,
	UTTER_MOLESTER_CHAMP,
	CANCERS_REAL_COOL,
	SPOOKY,
	SQUEEORMP,
	SANDAL_FLANDALS,
	GLITTERDELVE,
	VIRILE,
	FACTORY_SQUIRTS,
	LONGBOTTOM_LEAF,
	INDEPENDENCE,
	NIKEY_WIKEYS,
	ERECTWOOD,
	STEELY_DAN,
	MGALEKGOLO,
	PULLEY,
	LE_GUIN,
	FLEEORMP,
	POTENT,
	LIGHT_AS_A_FEATHER,
	BUSY_BEE,
	DINDER_MUFFLIN,
	ULTRA_SHITSTINCT,
	AND_THIS_IS_TO_GO_EVEN_FURTHER_BEYOND,
	POWER_BARRELS,
	A_BEE_WITH_TINY_DAGGERS,
	HARDWOOD_YO_MAMA,
	STEEL_YO_MAMA,
	MAGNETIC_ACCELERATOR,
	SPOOLY,
	TORIYAMA,
	BURDENED,
	SQUEEOMP,
	BARELY_WOOD_BY_NOW,
	FINGERS_OF_ONDEN,
	O_SALVATORI,
	LOW_RISES,
	ILL_SHOW_YOU_HARDWOOD,
	STEEL_LORD,
	FINISH_THE_FIGHT,
	MICROSOFT_PAINT,
	JOHN_PETER_BAIN_TOTALBISCUIT,
	
	
	
	AUTOSHOVELER, # S1 M
	SOCCER_DUDE,
	AW,
	ENTHUSIASM,
	CON_FRICKIN_CRETE,
	HOW_IS_THIS_AN_RPG,
	ITS_GROWIN_ON_ME,
	AUTOSTONER,
	OREOREUHBOREALICE,
	YOU_LITTLE_HARD_WORKER_YOU,
	COMPULSORY_JUICE,
	BIG_TOUGH_BOY,
	STAY_QUENCHED,
	OH_BABY_A_TRIPLE,
	AUTOPOLICE,
	PIPPENPADDLE_OPPSOCOPOLIS,
	I_DRINK_YOUR_MILKSHAKE,
	ORE_LORD,
	MOIST,
	THE_THIRD,
	WE_WERE_SO_CLOSE,
	UPGRADE_NAME,
	WTF_IS_THAT_MUSK,
	CANCERS_COOL,
	I_RUN,
	COAL_DUDE,
	CANKERITE,
	SENTIENT_DERRICK,
	SLAPAPOW,
	SIDIUS_IRON,
	MOUND,
	FOOD_TRUCKS,
	OPPAI_GUY,
	MALEVOLENT,
	SLUGGER,
	THIS_GAME_IS_SO_ESEY,
	WAIT_THATS_NOT_FAIR,
	PROCEDURE,
	ROUTINE,
	
	
	GRINDER, # S1 N
	LIGHTER_SHOVEL,
	TEXAS,
	RYE,
	GRANDER,
	SAALNDT,
	SALT,
	SAND,
	GRANDMA,
	MIXER,
	FLANK,
	RIB,
	GRANDPA,
	WATT,
	SWIRLER,
	GEARED_OILS,
	CHEEKS,
	GROUNDER,
	MAXER,
	THYME,
	PEPPER,
	ANCHOVE_COVE,
	GARLIC,
	MUD,
	SLOP,
	SLIMER,
	STICKYTAR,
	INJECT,
	RED_GOOPY_BOY,
}



signal upgrade_purchased_changed(upgrade)
signal just_reset
signal became_affordable_and_unpurchased(type, val)
signal autobuy_changed

var type: int
var key: String
var stage: int
var upgrade_menu: int

var times_purchased := 0
var name: String
var description: String
var has_description: bool
var effect_text: String

var icon: Texture:
	set(val):
		icon = val
		icon_text = "[img=<15>]" + icon.get_path() + "[/img]"
var icon_text: String
var icon_and_name_text: String
var effected_loreds_text: String
var color: Color
var loreds: Array

var unlocked := Bool.new(true)
var purchased := Bool.new(false)

func unlocked_updated(val: bool) -> void:
	if val:
		affordable_changed(cost.affordable.get_value())

func purchased_updated(_val: bool) -> void:
	affordable_changed(cost.affordable.get_value())
	upgrade_purchased_changed.emit(self)


var autobuy := false:
	set(val):
		if autobuy != val:
			autobuy = val
			if val:
				became_affordable_and_unpurchased.emit(type, false)
			affordable_changed(cost.affordable.get_value())
			autobuy_changed.emit()


var special: bool

var will_apply_effect := false

var vico: UpgradeVico:
	set(val):
		vico = val

var persist := Bool.new(false)

var effect: UpgradeEffect

var has_required_upgrade := false
var required_upgrade: int:
	set(val):
		has_required_upgrade = true
		required_upgrade = val
		var upgrade = up.get_upgrade(required_upgrade)
		upgrade.purchased.became_true.connect(required_upgrade_purchased)
		upgrade.purchased.became_false.connect(required_upgrade_unpurchased)
		unlocked.set_to(up.is_upgrade_purchased(required_upgrade))

var cost: Cost



func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	if type >= Type.AUTOSHOVELER:
		stage = 1
		special = type <= Type.ROUTINE
	elif type >= Type.MECHANICAL:
		stage = 2
		special = type <= Type.GRIMOIRE
	else: #s4
		stage = 3
		special = false #s3
	gv.hard_reset.connect(reset)
	gv.prestige.connect(prestige)
	
	match stage:
		1:
			if special:
				upgrade_menu = UpgradeMenu.Type.MALIGNANT
			else:
				upgrade_menu = UpgradeMenu.Type.NORMAL
		2:
			if special:
				upgrade_menu = UpgradeMenu.Type.RADIATIVE
			else:
				upgrade_menu = UpgradeMenu.Type.EXTRA_NORMAL
		3:
			if special:
				upgrade_menu = UpgradeMenu.Type.SPIRIT
			else:
				upgrade_menu = UpgradeMenu.Type.RUNED_DIAL
		4:
			if special:
				upgrade_menu = UpgradeMenu.Type.S4N
			else:
				upgrade_menu = UpgradeMenu.Type.S4M
	
	if special:
		gv.get("stage" + str(stage)).just_reset.connect(finalize_purchase)
	
	if type != Type.ROUTINE:
		up.add_upgrade_to_menu(upgrade_menu, type)
	
	if not has_method("init_" + key):
		return
	call("init_" + key)
	cost.stage = stage
	cost.affordable.changed.connect(affordable_changed)
	icon_and_name_text = icon_text + " " + name
	
	effected_loreds_text = get_effected_loreds_text()
	
	if icon == null:
		if loreds.size() < 10:
			var highest = 0
			var i = 0
			var ok = 0
			for x in loreds:
				if x > highest:
					highest = x
					ok = i
				i += 1
			icon = lv.get_icon(loreds[ok])
			color = lv.get_color(loreds[ok])
	
	has_description = description != ""
	
	SaveManager.connect("load_finished", load_finished)



func init_GRINDER() -> void:
	name = "GRINDER"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(90),
	})


func init_LIGHTER_SHOVEL() -> void:
	name = "Lighter Shovel"
	set_effect(UpgradeEffect.Type.HASTE, 1.2)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(155),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_TEXAS() -> void:
	name = "TEXAS"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(30),
		Currency.Type.COPPER: Value.new(400),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_RYE() -> void:
	name = "RYE"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(3),
		Currency.Type.IRON: Value.new(100),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_GRANDER() -> void:
	name = "GRANDER"
	set_effect(UpgradeEffect.Type.HASTE, 1.3)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.COAL: Value.new(400),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_SAALNDT() -> void:
	name = "SAALNDT"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.IRON_ORE)
	add_effected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.IRON_ORE: Value.new(1500),
		Currency.Type.COPPER_ORE: Value.new(1500),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_SALT() -> void:
	name = "SALT"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(150),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TEXAS


func init_SAND() -> void:
	name = "SAND"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(200),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_GRANDMA() -> void:
	name = "Grandma"
	set_effect(UpgradeEffect.Type.HASTE, 1.3)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(400),
		Currency.Type.COPPER: Value.new(400),
		Currency.Type.CONCRETE: Value.new(20),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRANDER


func init_MIXER() -> void:
	name = "MIXER"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(11),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_FLANK() -> void:
	name = "FLANK"
	set_effect(UpgradeEffect.Type.HASTE, 1.4)
	add_effected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(125),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SALT


func init_RIB() -> void:
	name = "RIB"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.4)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(125),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SALT


func init_GRANDPA() -> void:
	name = "Grandpa"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.35)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(2500),
		Currency.Type.COPPER: Value.new(2500),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRANDMA


func init_WATT() -> void:
	name = "Watt?"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.45)
	add_effected_lored(LORED.Type.JOULES)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(3500),
		Currency.Type.COPPER: Value.new(3500),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MIXER


func init_SWIRLER() -> void:
	name = "SWIRLER"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.COAL: Value.new(9500),
		Currency.Type.STONE: Value.new(6000),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MIXER


func init_GEARED_OILS() -> void:
	name = "Geared Oils"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2.0)
	add_effected_lored(LORED.Type.OIL)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("6e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CHEEKS


func init_CHEEKS() -> void:
	name = "Cheeks"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.5)
	add_effected_lored(LORED.Type.OIL)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(200000),
		Currency.Type.IRON: Value.new(120000),
		Currency.Type.COPPER: Value.new(40000),
		Currency.Type.COAL: Value.new(30000),
		Currency.Type.GROWTH: Value.new(5000),
		Currency.Type.CONCRETE: Value.new(1500),
		Currency.Type.MALIGNANCY: Value.new(15),
		Currency.Type.OIL: Value.new(1),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SALT


func init_GROUNDER() -> void:
	name = "GROUNDER"
	set_effect(UpgradeEffect.Type.HASTE, 1.35)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(100),
		Currency.Type.JOULES: Value.new(100),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRANDPA


func init_MAXER() -> void:
	name = "MAXER"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.4)
	add_effected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(400),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SWIRLER


func init_THYME() -> void:
	name = "THYME"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.75)
	add_effected_lored(LORED.Type.COPPER_ORE)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("2e6"),
		Currency.Type.MALIGNANCY: Value.new(35000),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FLANK


func init_PEPPER() -> void:
	name = "PEPPER"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 10)
	add_effected_lored(LORED.Type.IRON_ORE)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new("25e9"),
		Currency.Type.MALIGNANCY: Value.new("15e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ANCHOVE_COVE


func init_ANCHOVE_COVE() -> void:
	name = "Anchove Cove"
	set_effect(UpgradeEffect.Type.HASTE, 2)
	add_effected_lored(LORED.Type.IRON_ORE)
	add_effected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.IRON_ORE: Value.new(450000),
		Currency.Type.COPPER_ORE: Value.new(450000),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAALNDT


func init_GARLIC() -> void:
	name = "GARLIC"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 10)
	add_effected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("25e9"),
		Currency.Type.MALIGNANCY: Value.new("15e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ANCHOVE_COVE


func init_MUD() -> void:
	name = "MUD"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.75)
	add_effected_lored(LORED.Type.IRON_ORE)
	add_effected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new("2e6"),
		Currency.Type.MALIGNANCY: Value.new(35000),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RIB


func init_SLOP() -> void:
	name = "SLOP"
	set_effect(UpgradeEffect.Type.HASTE, 1.95)
	add_effected_lored(LORED.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.STONE: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SLIMER


func init_SLIMER() -> void:
	name = "SLIMER"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(150),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_STICKYTAR() -> void:
	name = "Sticktar"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.5, Currency.Type.TARBALLS)
	add_effected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(1400),
		Currency.Type.OIL: Value.new(75),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SLIMER


func init_INJECT() -> void:
	name = "INJECT"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_lored(LORED.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new(100),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STICKYTAR


func init_RED_GOOPY_BOY() -> void:
	name = "Red Goopy Boy"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.4)
	add_effected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(30000),
		Currency.Type.COPPER: Value.new(30000),
		Currency.Type.MALIGNANCY: Value.new(50),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STICKYTAR


func init_AUTOSHOVELER() -> void:
	name = "Auto-Shoveler"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(1500),
	})


func init_SOCCER_DUDE() -> void:
	name = "Soccer Dude"
	set_effect(UpgradeEffect.Type.HASTE, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(1600),
	})


func init_AW() -> void:
	name = "aw <3"
	var loredy = lv.get_colored_name(LORED.Type.COAL)
	description = "Start the run with " + loredy + " already purchased!"
	set_effect(UpgradeEffect.Type.FREE_LORED)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(2),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ENTHUSIASM


func init_ENTHUSIASM() -> void:
	name = "Enthusiasm"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("3000"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSHOVELER


func init_CON_FRICKIN_CRETE() -> void:
	name = "CON-FRICKIN-CRETE"
	set_effect(UpgradeEffect.Type.SPECIFIC_COST, 0.5, Currency.Type.CONCRETE)
	add_effected_lored(LORED.Type.OIL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("12e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSHOVELER


func init_HOW_IS_THIS_AN_RPG() -> void:
	name = "how is this an RPG anyway?"
	set_effect(UpgradeEffect.Type.CRIT, 5)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SOCCER_DUDE


func init_ITS_GROWIN_ON_ME() -> void:
	name = "IT'S GROWIN ON ME"
	var iron = lv.get_colored_name(LORED.Type.IRON)
	var cop = lv.get_colored_name(LORED.Type.COPPER)
	var growth = lv.get_colored_name(LORED.Type.GROWTH)
	description = "Whenever %s pops, either %s or %s will receive an [b]output and input boost[/b]." % [growth, iron, cop]
	icon = wa.get_icon(Currency.Type.GROWTH)
	color = lv.get_color(LORED.Type.GROWTH)
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.BONUS_ACTION_ON_CURRENCY_GAIN,
		{
			"upgrade_type": type,
			"currency": Currency.Type.GROWTH,
			"effect value": 1,
			"effect value2": 1,
			"bonus_action_type": UpgradeEffect.BONUS_ACTION.INCREASE_EFFECT1_OR_2,
			"modifier": 0.05,
		}
	)
	effect.set_dynamic(true)
	add_effected_lored(LORED.Type.IRON)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("2e3"),
	})


func init_AUTOSTONER() -> void:
	name = "Auto-Stoner"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("35e3"),
	})


func init_OREOREUHBOREALICE() -> void:
	name = "OREOREUHBor [i]E[/i] ALICE"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.IRON_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("12e3"),
	})


func init_YOU_LITTLE_HARD_WORKER_YOU() -> void:
	name = "you little hard worker, you"
	set_effect(UpgradeEffect.Type.HASTE, 2)
	add_effected_lored(LORED.Type.STONE)
	add_effected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("40e3"),
	})


func init_COMPULSORY_JUICE() -> void:
	name = "Compulsory Juice"
	set_effect(UpgradeEffect.Type.COST, 0.5)
	add_effected_lored(LORED.Type.IRON_ORE)
	add_effected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("50e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSTONER


func init_BIG_TOUGH_BOY() -> void:
	name = "[b]Big Tough Boy[/b]"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("175e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOW_IS_THIS_AN_RPG


func init_STAY_QUENCHED() -> void:
	name = "Stay Quenched!"
	set_effect(UpgradeEffect.Type.HASTE, 1.8)
	add_effected_lored(LORED.Type.COAL)
	add_effected_lored(LORED.Type.JOULES)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("60e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.YOU_LITTLE_HARD_WORKER_YOU


func init_OH_BABY_A_TRIPLE() -> void:
	name = "OH, BABY, A TRIPLE"
	set_effect(UpgradeEffect.Type.HASTE, 3)
	add_effected_lored(LORED.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("55e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.YOU_LITTLE_HARD_WORKER_YOU


func init_AUTOPOLICE() -> void:
	name = "Auto-Police"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("140e3"),
	})


func init_PIPPENPADDLE_OPPSOCOPOLIS() -> void:
	name = "pippenpaddle-oppso[b]COP[/b]olis"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("600e3"),
	})


func init_I_DRINK_YOUR_MILKSHAKE() -> void:
	name = "I DRINK YOUR MILKSHAKE"
	var coal = wa.get_icon_and_name_text(Currency.Type.COAL)
	var coal2 = lv.get_colored_name(LORED.Type.COAL)
	description = "Whenever a LORED takes %s, %s gets an output boost." % [coal, coal2]
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.BONUS_ACTION_ON_CURRENCY_USE,
		{
			"upgrade_type": type,
			"currency": Currency.Type.COAL,
			"effect value": 1,
			"bonus_action_type": UpgradeEffect.BONUS_ACTION.INCREASE_EFFECT,
			"modifier": 0.001,
		}
	)
	effect.set_dynamic(true)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("800e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STAY_QUENCHED


func init_ORE_LORD() -> void:
	name = "Ore Lord"
	set_effect(UpgradeEffect.Type.HASTE, 2)
	add_effected_lored(LORED.Type.IRON_ORE)
	add_effected_lored(LORED.Type.COPPER_ORE)
	add_effected_lored(LORED.Type.IRON)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BIG_TOUGH_BOY


func init_MOIST() -> void:
	name = "[i]Moist[/i]"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("12e6"),
	})


func init_THE_THIRD() -> void:
	name = "The Third"
	var cop = wa.get_icon_and_name_text(Currency.Type.COPPER)
	var copo = lv.get_colored_name(LORED.Type.COPPER_ORE)
	description = "Whenever %s mines, he will produce an equal amount of %s." % [copo, cop]
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.BONUS_JOB_PRODUCTION,
		{
			"upgrade_type": type,
			"job": Job.Type.COPPER_ORE,
			"currency": Currency.Type.COPPER,
			"modifier": 1.0,
		}
	)
	add_effected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("2e8"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PIPPENPADDLE_OPPSOCOPOLIS


func init_WE_WERE_SO_CLOSE() -> void:
	name = "we were so close, now you don't even think about me"
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.UPGRADE_AUTOBUYER,
		{
			"upgrade_type": type,
			"upgrade_menu": UpgradeMenu.Type.NORMAL,
		}
	)
	icon = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL).icon
	color = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL).color
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOW_IS_THIS_AN_RPG


func init_UPGRADE_NAME() -> void:
	name = "upgrade_name"
	var test = gv.get_stage(1)
	var text = test.colored_name
	description = "Reduces the cost increase of " + text + " LOREDs by 10%, but increases their [b]maximum fuel[/b] and [b]fuel cost[/b] by 1,000%."
	set_effect(UpgradeEffect.Type.UPGRADE_NAME)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ORE_LORD


func init_WTF_IS_THAT_MUSK() -> void:
	name = "wtf is that musk"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.JOULES)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("43e7"),
	})


func init_CANCERS_COOL() -> void:
	name = "CANCER'S COOL"
	set_effect(UpgradeEffect.Type.HASTE, 2)
	add_effected_lored(LORED.Type.GROWTH)
	add_effected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("3e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MOIST


func init_I_RUN() -> void:
	name = "I RUN"
	var iron = wa.get_icon_and_name_text(Currency.Type.IRON)
	var irono = lv.get_colored_name(LORED.Type.IRON_ORE)
	description = "Whenever %s murders, he will produce an equal amount of %s." % [irono, iron]
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.BONUS_JOB_PRODUCTION,
		{
			"upgrade_type": type,
			"job": Job.Type.IRON_ORE,
			"currency": Currency.Type.IRON,
			"modifier": 1.0,
		}
	)
	add_effected_lored(LORED.Type.IRON_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("25e9"),
	})


func init_COAL_DUDE() -> void:
	name = "[img=<15>]res://Sprites/Currency/coal.png[/img] Coal Dude"
	set_effect(UpgradeEffect.Type.HASTE, 2)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e11"),
	})


func init_CANKERITE() -> void:
	name = "CANKERITE"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("15e9"),
	})


func init_SENTIENT_DERRICK() -> void:
	name = "Sentient Derrick"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.OIL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("85e10"),
	})


func init_SLAPAPOW() -> void:
	name = "SLAPAPOW!"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("17e11"),
	})


func init_SIDIUS_IRON() -> void:
	name = "Sidius Iron"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("8e12"),
	})


func init_MOUND() -> void:
	name = "Mound"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("35e12"),
	})


func init_FOOD_TRUCKS() -> void:
	name = "Food Trucks"
	set_effect(UpgradeEffect.Type.COST, 0.5)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UPGRADE_NAME


func init_OPPAI_GUY() -> void:
	name = "Oppai Guy"
	set_effect(UpgradeEffect.Type.HASTE, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e15"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FOOD_TRUCKS


func init_MALEVOLENT() -> void:
	name = "Malevolent"
	set_effect(UpgradeEffect.Type.HASTE, 4)
	add_effected_lored(LORED.Type.TARBALLS)
	add_effected_lored(LORED.Type.CONCRETE)
	add_effected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e24"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MOUND


func init_SLUGGER() -> void:
	name = "Slugger"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e16"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.OPPAI_GUY


func init_THIS_GAME_IS_SO_ESEY() -> void:
	name = "This game is SO ESEY"
	set_effect(UpgradeEffect.Type.CRIT, 5)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("50e15"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SLUGGER


func init_WAIT_THATS_NOT_FAIR() -> void:
	name = "wait that's not fair"
	var coal = lv.get_colored_name(LORED.Type.COAL)
	var stone = wa.get_icon_and_name_text(Currency.Type.STONE)
	description = "Whenever %s digs, he will produce ten times as much %s." % [coal, stone]
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.BONUS_JOB_PRODUCTION,
		{
			"upgrade_type": type,
			"job": Job.Type.COAL,
			"currency": Currency.Type.STONE,
			"modifier": 10.0,
		}
	)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e18"),
	})


func init_PROCEDURE() -> void:
	name = "[i]Procedure[/i]"
	var metas = gv.get_stage(1).color_text % "Metastasizing"
	var amount = Big.new("1e20").text
	var malig = wa.get_icon_and_name_text(Currency.Type.MALIGNANCY)
	var tum = wa.get_icon_and_name_text(Currency.Type.TUMORS)
	var tum2 = lv.get_colored_name(LORED.Type.TUMORS)
	description = "When %s, every %s %s will be spent to reward you with %s based on %s's output." % [metas, amount, malig, tum, tum2]
	set_effect(UpgradeEffect.Type.HASTE, 1)
	icon = wa.get_icon(Currency.Type.TUMORS)
	color = wa.get_color(Currency.Type.TUMORS)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e19"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UPGRADE_NAME


func init_ROUTINE() -> void:
	name = "[i]Routine[/i]"
	var metas = gv.get_stage(1).color_text % "Metastasizes"
	var norm = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL).colored_name
	var meta2 = gv.get_stage(1).color_text % "Metastasis"
	description = "%s immediately. %s upgrades will persist through %s. After that, this Upgrade will be reset." % [metas, norm, meta2]
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.UPGRADE_PERSIST, {
			"upgrade_type": type,
			"effected_upgrades": [
				Type.GRINDER,
				Type.LIGHTER_SHOVEL,
				Type.TEXAS,
				Type.RYE,
				Type.GRANDER,
				Type.SAALNDT,
				Type.SALT,
				Type.SAND,
				Type.GRANDMA,
				Type.CHEEKS,
				Type.GROUNDER,
				Type.MAXER,
				Type.FLANK,
				Type.MIXER,
				Type.GEARED_OILS,
				Type.THYME,
				Type.PEPPER,
				Type.ANCHOVE_COVE,
				Type.GARLIC,
				Type.MUD,
				Type.RIB,
				Type.WATT,
				Type.SWIRLER,
				Type.GRANDPA,
				Type.SLOP,
				Type.SLIMER,
				Type.STICKYTAR,
				Type.INJECT,
				Type.RED_GOOPY_BOY,
			]
		}
	)
	icon = preload("res://Sprites/Hud/Tab/s1m.png")
	color = gv.get_stage_color(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e20"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RED_NECROMANCY


func init_CANOPY() -> void:
	name = "Canopy"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.TREES: Value.new("10"),
	})


func init_APPRENTICE_IRON_WORKER() -> void:
	name = "Apprentice Iron Worker"
	set_effect(UpgradeEffect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("25"),
	})


func init_DOUBLE_BARRELS() -> void:
	name = "Double Barrels"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("50"),
		Currency.Type.HARDWOOD: Value.new("100"),
	})


func init_RAIN_DANCE() -> void:
	name = "Rain Dance"
	set_effect(UpgradeEffect.Type.HASTE, 1.2)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.SAND: Value.new("40"),
	})


func init_LIGHTHOUSE() -> void:
	name = "Lighthouse"
	set_effect(UpgradeEffect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("130"),
	})


func init_ROGUE_BLACKSMITH() -> void:
	name = "Rogue Blacksmith"
	set_effect(UpgradeEffect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("1e3"),
		Currency.Type.GLASS: Value.new("1e3"),
		Currency.Type.CARCINOGENS: Value.new("35"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.APPRENTICE_IRON_WORKER


func init_TRIPLE_BARRELS() -> void:
	name = "Triple Barrels"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("350"),
		Currency.Type.STEEL: Value.new("100"),
		Currency.Type.SOIL: Value.new("250"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.DOUBLE_BARRELS


func init_BREAK_THE_DAM() -> void:
	name = "BREAK THE DAM"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.LIQUID_IRON: Value.new("30"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RAIN_DANCE


func init_THIS_MIGHT_PAY_OFF_SOMEDAY() -> void:
	name = "This might pay off someday!"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.IRON)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("1e6"),
	})


func init_DIRT_COLLECTION_REWARDS_PROGRAM() -> void:
	name = "*Dirt Collection Rewards Program!*"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.SOIL: Value.new("25e3"),
		Currency.Type.LEAD: Value.new("25e3"),
		Currency.Type.CARCINOGENS: Value.new("350"),
	})


func init_EQUINE() -> void:
	name = "[b]Equine[/b]"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("90"),
	})


func init_UNPREDICTABLE_WEATHER() -> void:
	name = "Unpredictable Weather"
	set_effect(UpgradeEffect.Type.CRIT, 8)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("1e3"),
		Currency.Type.GLASS: Value.new("1e3"),
		Currency.Type.TREES: Value.new("2.5e3"),
		Currency.Type.CARCINOGENS: Value.new("35"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BREAK_THE_DAM


func init_DECISIVE_STRIKES() -> void:
	name = "Decisive Strikes"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.AXES)
	add_effected_lored(LORED.Type.WOOD)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("350"),
		Currency.Type.GLASS: Value.new("425"),
		Currency.Type.SOIL: Value.new("500"),
	})


func init_SOFT_AND_SMOOTH() -> void:
	name = "Decisive Strikes"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("4500"),
		Currency.Type.CARCINOGENS: Value.new("900"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UNPREDICTABLE_WEATHER


func init_FLIPPY_FLOPPIES() -> void:
	name = "Flippy Floppies"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.HUMUS)
	add_effected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("850"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UNPREDICTABLE_WEATHER


func init_WOODTHIRSTY() -> void:
	name = "Woodthirsty"
	set_effect(UpgradeEffect.Type.HASTE, 1.3)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.WOOD: Value.new("800"),
		Currency.Type.HARDWOOD: Value.new("100"),
	})


func init_SEEING_BROWN() -> void:
	name = "Seeing [color=#7b3f00]Brown[/color]"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("300"),
		Currency.Type.WIRE: Value.new("300"),
		Currency.Type.TREES: Value.new("100"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WOODTHIRSTY


func init_WOODIAC_CHOPPER() -> void:
	name = "Woodiac Chopper"
	set_effect(UpgradeEffect.Type.HASTE, 1.4)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("50"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SEEING_BROWN


func init_CARLIN() -> void:
	name = "Carlin"
	set_effect(UpgradeEffect.Type.HASTE, 1.1)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.LEAD: Value.new("600"),
	})


func init_HARDWOOD_YOURSELF() -> void:
	name = "[img=<15>]res://Sprites/Currency/hard.png[/img] Hardwood Yourself"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.HARDWOOD)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("185"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_STEEL_YOURSELF() -> void:
	name = "[img=<15>]res://Sprites/Currency/steel.png[/img] Steel Yourself"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.LIQUID_IRON)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_PLASMA_BOMBARDMENT() -> void:
	name = "Plasma Bombardment"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("310"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_PATREON_ARTIST() -> void:
	name = "Patreon Artist"
	set_effect(UpgradeEffect.Type.HASTE, 1.2)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_MILLERY() -> void:
	name = "Millery"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("385"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HARDWOOD_YOURSELF


func init_QUAMPS() -> void:
	name = "Quamps"
	set_effect(UpgradeEffect.Type.HASTE, 1.35)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("600"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STEEL_YOURSELF


func init_TWO_FIVE_FIVE_TWO() -> void:
	name = "[i]2552[/i]"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.SAND)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("750"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PLASMA_BOMBARDMENT


func init_GIMP() -> void:
	name = "GIMP"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("900"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PATREON_ARTIST


func init_SAGAN() -> void:
	name = "Sagan"
	set_effect(UpgradeEffect.Type.HASTE, 1.1)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("5"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_HENRY_CAVILL() -> void:
	name = "Henry Cavill"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.CIGARETTES: Value.new("23.23"),
		Currency.Type.WOOD_PULP: Value.new("70"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_LEMBAS_WATER() -> void:
	name = "Lembas Water"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.WATER)
	add_effected_lored(LORED.Type.TREES)
	cost = Cost.new({
		Currency.Type.TOBACCO: Value.new("45"),
		Currency.Type.WATER: Value.new("300"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_BIGGER_TREES_I_GUESS() -> void:
	name = "bigger trees i guess"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.TREES)
	add_effected_lored(LORED.Type.WOOD)
	cost = Cost.new({
		Currency.Type.PLASTIC: Value.new("10e3"),
		Currency.Type.WOOD_PULP: Value.new("1e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_JOURNEYMAN_IRON_WORKER() -> void:
	name = "Journeyman Iron Worker"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.AXES: Value.new("250"),
		Currency.Type.CARCINOGENS: Value.new("50"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_CUTTING_CORNERS() -> void:
	name = "Cutting Corners!"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.WOOD)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("5.5e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MILLERY


func init_QUORMPS() -> void:
	name = "Cutting Corners!"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.LIQUID_IRON)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("4.5e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.QUAMPS


func init_KILTY_SBARK() -> void:
	name = "Kilty Sbark"
	set_effect(UpgradeEffect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("6.5e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TWO_FIVE_FIVE_TWO


func init_HOLE_GEOMETRY() -> void:
	name = "Kilty Sbark"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.DRAW_PLATE)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.WOOD_PULP: Value.new("10e3"),
		Currency.Type.HARDWOOD: Value.new("5.2e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GIMP


func init_CIORAN() -> void:
	name = "Cioran"
	set_effect(UpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e3"),
		Currency.Type.TUMORS: Value.new("100"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_WOOD_LORD() -> void:
	name = "Wood Lord"
	set_effect(UpgradeEffect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.AXES)
	add_effected_lored(LORED.Type.WOOD)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("35e3"),
		Currency.Type.CARCINOGENS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CUTTING_CORNERS


func init_EXPERT_IRON_WORKER() -> void:
	name = "Expert Iron Worker"
	set_effect(UpgradeEffect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("40e3"),
		Currency.Type.CARCINOGENS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.QUORMPS


func init_THEYVE_ALWAYS_BEEN_FASTER() -> void:
	name = "They've Always Been Faster"
	set_effect(UpgradeEffect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.HUMUS)
	add_effected_lored(LORED.Type.SAND)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("75e3"),
		Currency.Type.CARCINOGENS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.KILTY_SBARK


func init_WHERES_THE_BOY_STRING() -> void:
	name = "Where's the boy, String?"
	set_effect(UpgradeEffect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.DRAW_PLATE)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("35e3"),
		Currency.Type.CARCINOGENS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOLE_GEOMETRY


func init_UTTER_MOLESTER_CHAMP() -> void:
	name = "Utter Molester Champ"
	set_effect(UpgradeEffect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.PETROLEUM)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("100e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_CANCERS_REAL_COOL() -> void:
	name = "CANCER'S REAL COOL"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.TUMORS)
	cost = Cost.new({
		Currency.Type.WATER: Value.new("150e3"),
		Currency.Type.TREES: Value.new("150e3"),
		Currency.Type.HUMUS: Value.new("150e3"),
		Currency.Type.AXES: Value.new("150e3"),
		Currency.Type.WIRE: Value.new("150e3"),
		Currency.Type.GLASS: Value.new("150e3"),
		Currency.Type.HARDWOOD: Value.new("150e3"),
		Currency.Type.STEEL: Value.new("150e3"),
		Currency.Type.CARCINOGENS: Value.new("150e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_SPOOKY() -> void:
	name = "Sp0oKy"
	set_effect(UpgradeEffect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.CARCINOGENS)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e3"),
		Currency.Type.TUMORS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_SQUEEORMP() -> void:
	name = "Squeeormp"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.PETROLEUM)
	add_effected_lored(LORED.Type.PLASTIC)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("100e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_SANDAL_FLANDALS() -> void:
	name = "Sandal Flandals"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.HUMUS)
	add_effected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.SAND: Value.new("100e3"),
		Currency.Type.CARCINOGENS: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_GLITTERDELVE() -> void:
	name = "Glitterdelve"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.GALENA)
	cost = Cost.new({
		Currency.Type.LEAD: Value.new("100e3"),
		Currency.Type.CARCINOGENS: Value.new("8e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_VIRILE() -> void:
	name = "VIRILE"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.SEEDS)
	add_effected_lored(LORED.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.CIGARETTES: Value.new("50e3"),
		Currency.Type.CARCINOGENS: Value.new("1.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_FACTORY_SQUIRTS() -> void:
	name = "Factory Squirts"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.PETROLEUM)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new("2e8"),
		Currency.Type.LEAD: Value.new("3e3"),
		Currency.Type.TUMORS: Value.new("500"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_LONGBOTTOM_LEAF() -> void:
	name = "Longbottom Leaf"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.WOOD: Value.new("500e3"),
		Currency.Type.CARCINOGENS: Value.new("5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_INDEPENDENCE() -> void:
	name = "INDEPENDENCE"
	set_effect(UpgradeEffect.Type.CRIT, 10)
	add_effected_lored(LORED.Type.LEAD)
	cost = Cost.new({
		Currency.Type.GALENA: Value.new("450e3"),
		Currency.Type.LEAD: Value.new("450e3"),
		Currency.Type.CARCINOGENS: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_NIKEY_WIKEYS() -> void:
	name = "Nikey Wikeys"
	set_effect(UpgradeEffect.Type.CRIT, 7)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.SOIL: Value.new("1e6"),
		Currency.Type.CARCINOGENS: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_ERECTWOOD() -> void:
	name = "ERECTWOOD"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("2e7"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WOOD_LORD


func init_STEELY_DAN() -> void:
	name = "Steely Dan"
	set_effect(UpgradeEffect.Type.CRIT, 7)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("3e7"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.EXPERT_IRON_WORKER


func init_MGALEKGOLO() -> void:
	name = "Mgalekgolo"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("80e6"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THEYVE_ALWAYS_BEEN_FASTER


func init_PULLEY() -> void:
	name = "Pulley"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.DRAW_PLATE)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("95e6"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WHERES_THE_BOY_STRING


func init_LE_GUIN() -> void:
	name = "Le Guin"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e6"),
		Currency.Type.TUMORS: Value.new("100e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_FLEEORMP() -> void:
	name = "Fleeormp"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.GALENA)
	add_effected_lored(LORED.Type.LEAD)
	cost = Cost.new({
		Currency.Type.GALENA: Value.new("100e6"),
		Currency.Type.LEAD: Value.new("80e6"),
		Currency.Type.WIRE: Value.new("50e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_POTENT() -> void:
	name = "Potent"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.WATER)
	add_effected_lored(LORED.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.SEEDS: Value.new("30e6"),
		Currency.Type.PAPER: Value.new("45e6"),
		Currency.Type.SOIL: Value.new("60e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_LIGHT_AS_A_FEATHER() -> void:
	name = "Light as a Feather"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.STEEL)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.DRAW_PLATE: Value.new("10e6"),
		Currency.Type.CARCINOGENS: Value.new("10e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_BUSY_BEE() -> void:
	name = "Busy Bee"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.SEEDS)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("10e6"),
		Currency.Type.GLASS: Value.new("15e6"),
		Currency.Type.LEAD: Value.new("50e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_DINDER_MUFFLIN() -> void:
	name = "Dinder Mufflin"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.PAPER)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("100e6"),
		Currency.Type.GLASS: Value.new("150e6"),
		Currency.Type.LEAD: Value.new("500e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_ULTRA_SHITSTINCT() -> void:
	name = "Ultra Shitstinct"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.35)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.WATER: Value.new("1e9"),
		Currency.Type.SEEDS: Value.new("25e6"),
		Currency.Type.CARCINOGENS: Value.new("10e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_AND_THIS_IS_TO_GO_EVEN_FURTHER_BEYOND() -> void:
	name = "And this is to go [i]even further beyond![/i]"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.PAPER: Value.new("1e7"),
		Currency.Type.WOOD_PULP: Value.new("3e7"),
		Currency.Type.WATER: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_POWER_BARRELS() -> void:
	name = "Power Barrels"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.2)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("100e6"),
		Currency.Type.GLASS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_A_BEE_WITH_TINY_DAGGERS() -> void:
	name = "a bee with tiny daggers!!!"
	icon = load("res://Sprites/Upgrades/abeewithdaggers.png")
	color = lv.get_color(LORED.Type.SEEDS)
	set_effect(UpgradeEffect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.SEEDS)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("1e9"),
		Currency.Type.GLASS: Value.new("25e6"),
		Currency.Type.CARCINOGENS: Value.new("10e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BUSY_BEE


func init_HARDWOOD_YO_MAMA() -> void:
	name = "[img=<15>]res://Sprites/Currency/hard.png[/img] Hardwood Yo Mama"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.HARDWOOD)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ERECTWOOD


func init_STEEL_YO_MAMA() -> void:
	name = "[img=<15>]res://Sprites/Currency/steel.png[/img] Steel Yo Mama"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.LIQUID_IRON)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STEELY_DAN


func init_MAGNETIC_ACCELERATOR() -> void:
	name = "Magnetic Accelerator"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.SAND)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MGALEKGOLO


func init_SPOOLY() -> void:
	name = "Spooly"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PULLEY


func init_TORIYAMA() -> void:
	name = "Toriyama"
	set_effect(UpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("1e9"),
		Currency.Type.HARDWOOD: Value.new("1e9"),
		Currency.Type.WIRE: Value.new("1e9"),
		Currency.Type.GLASS: Value.new("1e9"),
		Currency.Type.CARCINOGENS: Value.new("50e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_BURDENED() -> void:
	name = "Burdened"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_lored(LORED.Type.LEAD)
	cost = Cost.new({
		Currency.Type.HUMUS: Value.new("10e9"),
		Currency.Type.WOOD_PULP: Value.new("4e9"),
		Currency.Type.PAPER: Value.new("1"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TORIYAMA


func init_SQUEEOMP() -> void:
	name = "Squeeomp"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.PETROLEUM)
	add_effected_lored(LORED.Type.PLASTIC)
	cost = Cost.new({
		Currency.Type.TOBACCO: Value.new("12e9"),
		Currency.Type.CARCINOGENS: Value.new("3e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TORIYAMA


func init_BARELY_WOOD_BY_NOW() -> void:
	name = "Barely Wood by Now"
	set_effect(UpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.WOOD)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("15e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HARDWOOD_YO_MAMA


func init_FINGERS_OF_ONDEN() -> void:
	name = "Fingers of Onden"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("15e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STEEL_YO_MAMA


func init_O_SALVATORI() -> void:
	name = "O'Salvatori"
	set_effect(UpgradeEffect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("15e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MAGNETIC_ACCELERATOR


func init_LOW_RISES() -> void:
	name = "low rises"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.35)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("10e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SPOOLY


func init_ILL_SHOW_YOU_HARDWOOD() -> void:
	name = "i'll show you hardwood"
	set_effect(UpgradeEffect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.AXES)
	add_effected_lored(LORED.Type.WOOD)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("1e12"),
		Currency.Type.CARCINOGENS: Value.new("250e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BARELY_WOOD_BY_NOW


func init_STEEL_LORD() -> void:
	name = "Steel Lord"
	set_effect(UpgradeEffect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("1e12"),
		Currency.Type.CARCINOGENS: Value.new("250e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FINGERS_OF_ONDEN


func init_FINISH_THE_FIGHT() -> void:
	name = "Finish the Fight"
	set_effect(UpgradeEffect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.HUMUS)
	add_effected_lored(LORED.Type.SAND)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("1e12"),
		Currency.Type.CARCINOGENS: Value.new("250e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.O_SALVATORI


func init_MICROSOFT_PAINT() -> void:
	name = "Microsoft Paint"
	set_effect(UpgradeEffect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.DRAW_PLATE)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("1e12"),
		Currency.Type.CARCINOGENS: Value.new("250e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LOW_RISES


func init_JOHN_PETER_BAIN_TOTALBISCUIT() -> void:
	name = "[img=<15>]res://Sprites/upgrades/Totalbiscuit.png[/img] John Peter Bain, TotalBiscuit"
	icon = load("res://Sprites/upgrades/Totalbiscuit.png")
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e12"),
		Currency.Type.TUMORS: Value.new("10e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TORIYAMA


func init_MECHANICAL() -> void:
	name = "Mechanical"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("250"),
	})


func init_LIMIT_BREAK() -> void:
	name = "[rainbow freq=0.15][wave amp=20 freq=1]Limit Break[/wave][/rainbow]"
	var a = gv.get_stage(1).colored_name
	var b = gv.get_stage(2).colored_name
	description = "%s and %s LOREDs may now charge [b]Limit Break[/b], greatly increasing their [b]output and input[/b]." % [a, b]
	effect = UpgradeEffect.new(UpgradeEffect.Type.LIMIT_BREAK, {
		"upgrade_type": type,
		"effect value": 1,
		"xp": ValuePair.new(1000),
	})
	effect.set_dynamic(true)
	add_effected_stage(1)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("250"),
	})


func init_DONT_TAKE_CANDY_FROM_BABIES() -> void:
	name = "don't take candy from babies"
	description = "Stage 2 and up LOREDs will not take resources from a Stage 1 resource if its producing LORED is below level 5."
	icon = gv.get_stage_icon(Stage.Type.STAGE1)
	color = gv.get_stage_color(Stage.Type.STAGE1)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MECHANICAL


func init_SPLISHY_SPLASHY() -> void:
	name = "Splishy Splashy"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("4e3"),
	})


func init_MILK() -> void:
	name = "Milk"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2e3"),
	})


func init_FALCON_PAWNCH() -> void:
	name = "FALCON [b]PAWNCH[/b]"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1250"),
	})


func init_SPEED_SHOPPER() -> void:
	name = "Speed-Shopper"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("35e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.DONT_TAKE_CANDY_FROM_BABIES


func init_AUTOSMITHY() -> void:
	name = "Auto-Smithy"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("8e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SPLISHY_SPLASHY


func init_GATORADE() -> void:
	name = "Gatorade?"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MILK


func init_KAIO_KEN() -> void:
	name = "KAIO-KEN"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("6250"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FALCON_PAWNCH


func init_AUTOSENSU() -> void:
	name = "Auto-Sensu"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.WOOD)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("160e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSMITHY


func init_APPLE_JUICE() -> void:
	name = "Apple Juice"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("600e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GATORADE


func init_DANCE_OF_THE_FIRE_GOD() -> void:
	name = "Dance of the Fire God"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("450e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.KAIO_KEN


func init_SUDDEN_COMMISSION() -> void:
	name = "Sudden Commission"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.DRAW_PLATE)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSENSU


func init_PEPPERMINT_MOCHA() -> void:
	name = "Peppermint Mocha Latte"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1800e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.APPLE_JUICE


func init_RASENGAN() -> void:
	name = "Rasengan"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.35e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.DANCE_OF_THE_FIRE_GOD


func init_MUDSLIDE() -> void:
	name = "Mudslide"
	set_effect(UpgradeEffect.Type.SPECIFIC_COST, 0.75, Currency.Type.GLASS)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e7"),
	})


func init_THE_GREAT_JOURNEY() -> void:
	name = "The Great Journey"
	set_effect(UpgradeEffect.Type.SPECIFIC_COST, 0.8, Currency.Type.STEEL)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e7"),
	})


func init_BEAVER() -> void:
	name = "The Great Journey"
	set_effect(UpgradeEffect.Type.SPECIFIC_COST, 0.8, Currency.Type.WOOD)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e7"),
	})


func init_MODS_ENABLED() -> void:
	name = "Mods Enabled"
	set_effect(UpgradeEffect.Type.SPECIFIC_COST, 0.75, Currency.Type.GLASS)
	add_effected_lored(LORED.Type.PETROLEUM)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e7"),
	})


func init_COVENANT_DANCE() -> void:
	name = "Covenant Dance"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PEPPERMINT_MOCHA


func init_OVERTIME() -> void:
	name = "Overtime"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.COVENANT_DANCE


func init_BONE_MEAL() -> void:
	name = "Bone Meal"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.TREES)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("4e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.OVERTIME


func init_SILLY() -> void:
	name = "Silly"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("8e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BONE_MEAL


func init_SPEED_DOODS() -> void:
	name = "Speed-Doods"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.DRAW_PLATE)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("128e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.EREBOR


func init_EREBOR() -> void:
	name = "Erebor"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.GALENA)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("64e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CHILD_ENERGY


func init_CHILD_ENERGY() -> void:
	name = "Child Energy"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.SOIL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("32e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PLATE


func init_PLATE() -> void:
	name = "Plate"
	set_effect(UpgradeEffect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("16e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SILLY


func init_MASTER() -> void:
	name = "Master"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SUDDEN_COMMISSION


func init_STRAWBERRY_BANANA_SMOOTHIE() -> void:
	name = "Strawberry Banana Smoothie"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("540e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PEPPERMINT_MOCHA


func init_AVATAR_STATE() -> void:
	name = "Avatar State"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("405e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RASENGAN


func init_AXELOT() -> void:
	name = "Axelot"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MASTER


func init_GREEN_TEA() -> void:
	name = "Green Tea"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.62e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STRAWBERRY_BANANA_SMOOTHIE


func init_HAMON() -> void:
	name = "Hamon"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.215e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AVATAR_STATE


func init_AUTOSHIT() -> void:
	name = "Auto-Shit"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AXELOT


func init_FRENCH_VANILLA() -> void:
	name = "French Vanilla"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("5e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GREEN_TEA


func init_METAL_CAP() -> void:
	name = "Metal Cap"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3.6e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HAMON


func init_SMASHY_CRASHY() -> void:
	name = "Smashy Crashy"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.TREES)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("4e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSHIT


func init_WATER() -> void:
	name = "Water"
	set_effect(UpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.5e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FRENCH_VANILLA


func init_STAR_ROD() -> void:
	name = "Star Rod"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.1e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.METAL_CAP


func init_A_BABY_ROLEUM() -> void:
	name = "A baby Roleum!! Thanks, pa!"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.PETROLEUM)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("8e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SMASHY_CRASHY


func init_POOFY_WIZARD_BOY() -> void:
	name = "Poofy Wizard Boy"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.6e11"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.A_BABY_ROLEUM


func init_BENEFIT() -> void:
	name = "Benefit"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.GALENA)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3.2e11"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.POOFY_WIZARD_BOY


func init_AUTOAQUATICIDE() -> void:
	name = "Auto-Aquaticide"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.PLASTIC)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("6.4e11"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BENEFIT


func init_GO_ON_THEN_LEAD_US() -> void:
	name = "Go on, then, LEAD us!"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.LEAD)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.3e12"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOAQUATICIDE


func init_THE_WITCH_OF_LOREDELITH() -> void:
	name = "The Witch of Loredelith"
	description = "Stage 1 LOREDs permanently gain Aurus's Bounty, Circe's powerful buff."
	set_effect(UpgradeEffect.Type.HASTE, 1)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e12"),
	})


func init_TOLKIEN() -> void:
	name = "Tolkien"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e12"),
	})


func init_BEEKEEPING() -> void:
	name = "Tolkien"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.SEEDS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2.5e12"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GO_ON_THEN_LEAD_US


func init_ELBOW_STRAPS() -> void:
	name = "Elbow Straps"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e12"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH


func init_AUTO_PERSIST() -> void:
	name = "Auto-Persist"
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.UPGRADE_PERSIST, {
			"upgrade_type": type,
			"effected_upgrades": [
				Type.MOUND,
				Type.SIDIUS_IRON,
				Type.SLAPAPOW,
				Type.SENTIENT_DERRICK,
				Type.CANKERITE,
				Type.WTF_IS_THAT_MUSK,
				Type.MOIST,
				Type.PIPPENPADDLE_OPPSOCOPOLIS,
				Type.AUTOPOLICE,
				Type.AUTOSTONER,
				Type.OREOREUHBOREALICE,
				Type.AUTOSHOVELER,
			]
		}
	)
	icon = load("res://Sprites/Hud/autobuy.png")
	color = gv.get_stage_color(Stage.Type.STAGE1)
	description = "Stage 1 autobuyer Upgrades [i]persist through[/i] Chemotherapy!"
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH


func init_KETO() -> void:
	name = "Keto"
	set_effect(UpgradeEffect.Type.INPUT, 0.01)
	add_effected_lored(LORED.Type.IRON)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH


func init_NOW_THATS_WHAT_IM_TALKIN_ABOUT() -> void:
	name = "Now That's What I'm Talkin About, Yeeeeeeaaaaaaa[b]AAAAAAGGGGGHHH[/b]"
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.UPGRADE_AUTOBUYER,
		{
			"upgrade_type": type,
			"upgrade_menu": UpgradeMenu.Type.EXTRA_NORMAL,
		}
	)
	icon = up.get_upgrade_menu(UpgradeMenu.Type.EXTRA_NORMAL).icon
	color = up.get_upgrade_menu(UpgradeMenu.Type.EXTRA_NORMAL).color
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e12"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH


func init_SCOOPY_DOOPY() -> void:
	name = "Scoopy Doopy"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.SOIL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("5e12"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BEEKEEPING


func init_THE_ATHORE_COMENTS_AL_TOTOL_LIES() -> void:
	name = "the athore coments al totol lies!"
	set_effect(UpgradeEffect.Type.CRIT, 10)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ELBOW_STRAPS


func init_ITS_SPREADIN_ON_ME() -> void:
	name = "IT'S SPREADIN ON ME"
	var iron = lv.get_colored_name(LORED.Type.IRON)
	var cop = lv.get_colored_name(LORED.Type.COPPER)
	var irono = lv.get_colored_name(LORED.Type.IRON_ORE)
	var copo = lv.get_colored_name(LORED.Type.COPPER_ORE)
	var growth = lv.get_colored_name(LORED.Type.GROWTH)
	description = "Placeholder"
	icon = wa.get_icon(Currency.Type.GROWTH)
	color = lv.get_color(LORED.Type.GROWTH)
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.BONUS_ACTION_ON_CURRENCY_GAIN,
		{
			"upgrade_type": type,
			"currency": Currency.Type.GROWTH,
			"replaced_upgrade": Type.ITS_GROWIN_ON_ME,
			"effect value": 1,
			"bonus_action_type": UpgradeEffect.BONUS_ACTION.INCREASE_EFFECT,
			"modifier": 0.05,
		}
	)
	effect.set_dynamic(true)
	add_effected_lored(LORED.Type.IRON_ORE)
	add_effected_lored(LORED.Type.COPPER_ORE)
	add_effected_lored(LORED.Type.IRON)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("8e13"),
	})
	
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTO_PERSIST
	
	var itsgrowin = up.get_upgrade(Type.ITS_GROWIN_ON_ME).icon_and_name_text
	description = "Whenever %s pops, %s, %s, %s, and %s all receive an [b]output and input boost[/b]. This Upgrade replaces %s." % [growth, irono, copo, iron, cop, itsgrowin]


func init_WHAT_IN_COUSIN_FUCKIN_TARNATION() -> void:
	name = "what in cousin-fuckin tarnation alabama betty crocker miss fuckin betty white shit is this"
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.ERASE_CURRENCY_FROM_COST,
		{
			"upgrade_type": type,
			"currency": Currency.Type.GROWTH,
			"effected_lored": LORED.Type.TARBALLS,
		}
	)
	icon = wa.get_icon(Currency.Type.MALIGNANCY)
	color = wa.get_color(Currency.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("5e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.KETO


func init_MASTER_IRON_WORKER() -> void:
	name = "Master Iron Worker"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SCOOPY_DOOPY


func init_JOINTSHACK() -> void:
	name = "Jointshack"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.PAPER)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MASTER_IRON_WORKER


func init_DUST() -> void:
	name = "Dust"
	set_effect(UpgradeEffect.Type.LORED_PERSIST)
	add_effected_stage(1)
	var a = up.get_menu_color_text(UpgradeMenu.Type.MALIGNANT) % "Metastasizing"
	var b = gv.get_stage(Stage.Type.STAGE1).colored_name
	description = "%s no longer resets %s LOREDs." % [a, b]
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e14"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ITS_SPREADIN_ON_ME


func init_CAPITAL_PUNISHMENT() -> void:
	name = "[b]Capital Punishment[/b]"
	set_effect(UpgradeEffect.Type.HASTE, 1)
	icon = wa.get_icon(Currency.Type.TUMORS)
	color = gv.get_stage_color(Stage.Type.STAGE1)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e14"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ITS_SPREADIN_ON_ME
	
	var a = wa.get_icon_and_name_text(Currency.Type.TUMORS)
	var b = up.get_upgrade_name(Type.PROCEDURE)
	var c = gv.get_stage(Stage.Type.STAGE1).colored_name
	description = "%s gained from %s are multiplied by your %s run count." % [a, b, c]


func init_AROUSAL() -> void:
	name = "Arousal"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("4e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.JOINTSHACK


func init_AUTOFLOOF() -> void:
	name = "Auto-Floof"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.WOOD_PULP)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("8e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AROUSAL


func init_ELECTRONIC_CIRCUITS() -> void:
	name = "Electronic Circuits"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.7e14"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOFLOOF


func init_AUTOBADDECISIONMAKER() -> void:
	name = "Auto-Baddecisionmaker"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.CIGARETTES)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3.6e14"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ELECTRONIC_CIRCUITS


func init_CONDUCT() -> void:
	name = "[b]Conduct[/b]"
	var stage1 = gv.get_stage(1)
	var a = stage1.color_text % "Metastasizing"
	var b = stage1.colored_name
	description = "%s no longer resets %s resources." % [a, b]
	var stage = gv.get_stage(1)
	icon = stage.icon
	color = stage.color
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.CURRENCY_PERSIST,
		{
			"upgrade_type": type,
			"stage": 1
		}
	)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e15"),
	})


func init_PILLAR_OF_AUTUMN() -> void:
	name = "Pillar of Autumn"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("7.5e16"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOBADDECISIONMAKER


func init_WHAT_KIND_OF_RESOURCE_IS_TUMORS() -> void:
	name = "what kind of resource is '[img=<15>]res://Sprites/Currency/tum.png[/img] tumors', you hack fraud"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.TUMORS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.5e17"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PILLAR_OF_AUTUMN


func init_DEVOUR() -> void:
	name = "DEVOUR"
	set_effect(UpgradeEffect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.CARCINOGENS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e17"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WHAT_KIND_OF_RESOURCE_IS_TUMORS


func init_IS_IT_SUPPOSED_TO_BE_STICK_DUDES() -> void:
	name = "is it SUPPOSED to be stick dudes?"
	set_effect(UpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e18"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TOLKIEN


func init_I_DISAGREE() -> void:
	name = "I Disagree"
	set_effect(UpgradeEffect.Type.INPUT, 0.9)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e18"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.IS_IT_SUPPOSED_TO_BE_STICK_DUDES


func init_HOME_RUN_BAT() -> void:
	name = "Home Run Bat"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("9e18"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.I_DISAGREE


func init_BLAM_THIS_PIECE_OF_CRAP() -> void:
	name = "BLAM this piece of crap!"
	set_effect(UpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("27e18"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOME_RUN_BAT


func init_DOT_DOT_DOT() -> void:
	name = "DOT DOT DOT"
	set_effect(UpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("6e19"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOME_RUN_BAT


func init_ONE_PUNCH() -> void:
	name = "One Punch"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 1.5)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e20"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.DOT_DOT_DOT


func init_SICK_OF_THE_SUN() -> void:
	name = "Sick of the Sun"
	set_effect(UpgradeEffect.Type.INPUT, 0.9)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("5e20"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ONE_PUNCH


func init_AXMAN13() -> void:
	var video_year = 2011
	var cur_year = Time.get_date_dict_from_system().year
	var age = str(cur_year - video_year + 13)
	name = "axman%s by now" % age
	set_effect(UpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e21"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SICK_OF_THE_SUN


func init_CTHAEH() -> void:
	name = "Cthaeh"
	set_effect(UpgradeEffect.Type.OUTPUT_AND_INPUT, 10)
	add_effected_lored(LORED.Type.TREES)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("5e21"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AXMAN13


func init_RED_NECROMANCY() -> void:
	name = "[b][color=#ff0000]Red Necromancy[/color][/b]"
	effect = UpgradeEffect.new(
		UpgradeEffect.Type.UPGRADE_AUTOBUYER,
		{
			"upgrade_type": type,
			"upgrade_menu": UpgradeMenu.Type.MALIGNANT,
		}
	)
	var menu = up.get_upgrade_menu(UpgradeMenu.Type.MALIGNANT)
	icon = menu.icon
	color = menu.color
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e24"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH


func init_UPGRADE_DESCRIPTION() -> void:
	name = "upgrade_description"
	var a = gv.get_stage(1).colored_name
	var b = gv.get_stage(2).colored_name
	description = "Reduces the cost increase of %s and %s LOREDs by 10%, but increases their [b]maximum fuel[/b] and [b]fuel cost[/b] by 1,000%." % [a, b]
	set_effect(UpgradeEffect.Type.UPGRADE_NAME)
	icon = gv.get_stage_icon(2)
	color = gv.get_stage_color(2)
	add_effected_stage(1)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e24"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TOLKIEN


func init_GRIMOIRE() -> void:
	name = "GRIMOIRE"
	var a = up.get_upgrade_name(Type.THE_WITCH_OF_LOREDELITH)
	var b = gv.get_stage(Stage.Type.STAGE1).colored_name
	description = "%s's buff is boosted based on your %s run count." % [a, b]
	set_effect(UpgradeEffect.Type.HASTE, 1)
	icon = load("res://Sprites/upgrades/thewitchofloredelith.png")
	color = lv.get_color(LORED.Type.WITCH)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e24"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH








func set_effect(_type: int, base_value := -1.0, effected_input = -1) -> void:
	var data := {}
	if base_value != -1:
		data["effect value"] = base_value
	if effected_input != -1:
		data["effected_input"] = effected_input
	data["upgrade_type"] = type
	effect = UpgradeEffect.new(_type, data)


func add_effected_lored(lored: int) -> void:
	loreds.append(lored)
	effect.add_effected_lored(lored)
	await up.all_upgrades_initialized
	lv.get_lored(lored).add_influencing_upgrade(type)


func add_effected_loreds(group: Array) -> void:
	for lored in group:
		add_effected_lored(lored)


func add_effected_stage(_stage: int) -> void:
	add_effected_loreds(lv.get_loreds_in_stage(_stage))
	if icon == null:
		icon = gv.get_stage(_stage).icon
	if color == Color(0,0,0):
		color = gv.get_stage(_stage).color




# - Signal

func required_upgrade_purchased() -> void:
	unlocked.set_true()


func required_upgrade_unpurchased() -> void:
	unlocked.set_false()


func affordable_changed(affordable: bool) -> void:
	if autobuy:
		if unlocked.is_true() and affordable:
			purchase()
	else:
		if (
			unlocked.is_true()
			and purchased.is_false()
			and affordable
		):
			became_affordable_and_unpurchased.emit(type, true)
		else:
			became_affordable_and_unpurchased.emit(type, false)



# - Actions

func purchase() -> void:
	if purchased.is_true() or will_apply_effect:
		return
	cost.purchase(true)
	purchased.set_true()
	if special:
		will_apply_effect = true
	else:
		finalize_purchase()


func finalize_purchase() -> void:
	apply()
	times_purchased += 1
	up.emit_signal("upgrade_purchased", type)


func apply() -> void:
	effect.apply()


func refund() -> void:
	if purchased.is_false():
		return
	cost.refund()
	remove()


func remove() -> void:
	if purchased.is_true():
		if special:
			will_apply_effect = false
		effect.remove()
		effect.reset_effects()
		cost.purchased = false
		purchased.set_false()



func enable_persist() -> void:
	persist.set_reset_value(true)


func disable_persist() -> void:
	persist.reset()



func enable_autobuy() -> void:
	autobuy = true


func disable_autobuy() -> void:
	autobuy = false



func prestige(_stage: int) -> void:
	if _stage == stage:
		if will_apply_effect:
			apply()
		elif not special:
			if persist.is_false_on_reset():
				remove()
		if effect.dynamic:
			effect.reset_effects()
	elif _stage > stage:
		remove()



func reset() -> void:
	remove()
	if effect != null and effect.dynamic:
		effect.reset_effects()
	times_purchased = 0
	will_apply_effect = false



# - Get

func get_effect_text() -> String:
	return effect.get_text()


func get_effected_loreds_text() -> String:
	if effected_loreds_text != "":
		return effected_loreds_text
	
	if loreds == lv.get_loreds_in_stage(1):
		var _stage = gv.stage1.colored_name
		return "[i]for [/i]" + _stage
	elif loreds == lv.get_loreds_in_stage(2):
		var _stage = gv.stage2.colored_name
		return "[i]for [/i]" + _stage
	elif loreds == lv.get_loreds_in_stage(3):
		var _stage = gv.stage3.colored_name
		return "[i]for [/i]" + _stage
	elif loreds == lv.get_loreds_in_stage(4):
		var _stage = gv.stage4.colored_name
		return "[i]for [/i]" + _stage
	
	if effect != null and effect.type == UpgradeEffect.Type.UPGRADE_AUTOBUYER:
		var upmen = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL) as UpgradeMenu
		var text = upmen.color_text % (upmen.name)
		return "[i]for [/i]" + text
	# if loreds.size() > 8: probably a stage.
	var arr := []
	for lored in loreds:
		arr.append(lv.get_lored(lored).colored_name)
	return "[i]for [/i]" + gv.get_list_text_from_array(arr).replace("and", "[i]and[/i]")
