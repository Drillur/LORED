class_name Upgrade
extends Resource



var saved_vars := [
	"unlocked",
	"purchased",
	"pending_prestige",
	"cost",
#	"effect",
]


func load_finished() -> void:
	if purchased.is_true():
		if pending_prestige.is_true():
			refund()
		else:
			apply()



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
	LIL_SAUCY_BOSSY,
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

var type: int
var key: String
var stage: int
var upgrade_menu: int

var details := Details.new()

var has_description: bool
var effect_text: String

var effected_loreds_text: String
var loreds: Array

var unlocked := LoudBool.new(true)
func unlocked_changed() -> void:
	affordable_changed()
	if unlocked.is_false() and purchased.is_true():
		if pending_prestige.is_true():
			refund()
		else:
			remove()
	if vico != null:
		vico.cost_update()
var purchased := LoudBool.new(false)
func purchase_changed() -> void:
	affordable_changed()
	upgrade_purchased_changed.emit(self)
	up.emit_signal("upgrade_purchased", type)


var autobuy := LoudBool.new(false)
func autobuy_changed() -> void:
	if autobuy.is_true():
		became_affordable_and_unpurchased.emit(type, false)
	affordable_changed()
var pending_prestige := LoudBool.new(false)
var purchase_finalized := LoudBool.new(false)
var special: bool
var has_required_upgrade := false
var required_upgrade: int:
	set(val):
		has_required_upgrade = true
		required_upgrade = val
		var upgrade = up.get_upgrade(required_upgrade)
		upgrade.purchased.became_true.connect(required_upgrade_purchased)
		upgrade.purchased.became_false.connect(required_upgrade_unpurchased)
		unlocked.set_to(up.is_upgrade_purchased(required_upgrade))

var vico: UpgradeVico:
	set(val):
		vico = val
var persist := Persist.new()
var effect
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
	purchased.changed.connect(purchase_changed)
	unlocked.changed.connect(unlocked_changed)
	autobuy.changed.connect(autobuy_changed)
	
	match stage:
		1:
			if special:
				upgrade_menu = UpgradeMenu.Type.MALIGNANT
				persist.s1.set_to(true)
			else:
				upgrade_menu = UpgradeMenu.Type.NORMAL
		2:
			if special:
				upgrade_menu = UpgradeMenu.Type.RADIATIVE
				persist.s2.set_to(true)
			else:
				upgrade_menu = UpgradeMenu.Type.EXTRA_NORMAL
		3:
			if special:
				persist.s3.set_to(true)
				upgrade_menu = UpgradeMenu.Type.SPIRIT
			else:
				upgrade_menu = UpgradeMenu.Type.RUNED_DIAL
		4:
			if special:
				persist.s4.set_to(true)
				upgrade_menu = UpgradeMenu.Type.S4N
			else:
				upgrade_menu = UpgradeMenu.Type.S4M
	
	if type == Type.ROUTINE:
		special = false
	
	up.add_upgrade_to_menu(upgrade_menu, type)
	
	if not has_method("init_" + key):
		return
	call("init_" + key)
	cost.stage = stage
	cost.affordable.changed.connect(affordable_changed)
	cost.became_safe.connect(affordable_changed)
	
	update_effected_loreds_text()
	
	if details.icon == null:
		if loreds.size() < 10:
			var highest = 0
			var i = 0
			var ok = 0
			for x in loreds:
				if x > highest:
					highest = x
					ok = i
				i += 1
			details.color = lv.get_color(loreds[ok])
			details.icon = lv.get_icon(loreds[ok])
	
	has_description = details.description != ""
	
	SaveManager.load_finished.connect(load_finished)



func init_GRINDER() -> void:
	details.name = "GRINDER"
#	effect = UpgradeEffect.new(
#		UpgradeEffect.Type.LORED_HASTE,
#		{
#			"value": 1.25,
#			"affected_loreds": [LORED.Type.STONE]
#		}
#	)
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_affected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(90),
	})


func init_LIGHTER_SHOVEL() -> void:
	details.name = "Lighter Shovel"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.2)
	add_affected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(155),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_TEXAS() -> void:
	details.name = "TEXAS"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_affected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(30),
		Currency.Type.COPPER: Value.new(400),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_RYE() -> void:
	details.name = "RYE"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_affected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(3),
		Currency.Type.IRON: Value.new(100),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_GRANDER() -> void:
	details.name = "GRANDER"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.3)
	add_affected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.COAL: Value.new(400),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_SAALNDT() -> void:
	details.name = "SAALNDT"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.IRON_ORE)
	add_affected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.IRON_ORE: Value.new(1500),
		Currency.Type.COPPER_ORE: Value.new(1500),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_SALT() -> void:
	details.name = "SALT"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(150),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TEXAS


func init_SAND() -> void:
	details.name = "SAND"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_affected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(200),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_GRANDMA() -> void:
	details.name = "Grandma"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.3)
	add_affected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(400),
		Currency.Type.COPPER: Value.new(400),
		Currency.Type.CONCRETE: Value.new(20),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRANDER


func init_MIXER() -> void:
	details.name = "MIXER"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(11),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_FLANK() -> void:
	details.name = "FLANK"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.4)
	add_affected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(125),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SALT


func init_RIB() -> void:
	details.name = "RIB"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.4)
	add_affected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(125),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SALT


func init_GRANDPA() -> void:
	details.name = "Grandpa"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.35)
	add_affected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(2500),
		Currency.Type.COPPER: Value.new(2500),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRANDMA


func init_WATT() -> void:
	details.name = "Watt?"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.45)
	add_affected_lored(LORED.Type.JOULES)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(3500),
		Currency.Type.COPPER: Value.new(3500),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MIXER


func init_SWIRLER() -> void:
	details.name = "SWIRLER"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.COAL: Value.new(9500),
		Currency.Type.STONE: Value.new(6000),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MIXER


func init_GEARED_OILS() -> void:
	details.name = "Geared Oils"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2.0)
	add_affected_lored(LORED.Type.OIL)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("6e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CHEEKS


func init_CHEEKS() -> void:
	details.name = "Cheeks"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.5)
	add_affected_lored(LORED.Type.OIL)
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
	details.name = "GROUNDER"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.35)
	add_affected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(100),
		Currency.Type.JOULES: Value.new(100),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRANDPA


func init_MAXER() -> void:
	details.name = "MAXER"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.4)
	add_affected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(400),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SWIRLER


func init_THYME() -> void:
	details.name = "THYME"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.75)
	add_affected_lored(LORED.Type.COPPER_ORE)
	add_affected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("2e6"),
		Currency.Type.MALIGNANCY: Value.new(35000),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FLANK


func init_PEPPER() -> void:
	details.name = "PEPPER"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 10)
	add_affected_lored(LORED.Type.IRON_ORE)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new("25e9"),
		Currency.Type.MALIGNANCY: Value.new("15e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ANCHOVE_COVE


func init_ANCHOVE_COVE() -> void:
	details.name = "Anchove Cove"
	set_effect(OldUpgradeEffect.Type.HASTE, 2)
	add_affected_lored(LORED.Type.IRON_ORE)
	add_affected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.IRON_ORE: Value.new(450000),
		Currency.Type.COPPER_ORE: Value.new(450000),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAALNDT


func init_GARLIC() -> void:
	details.name = "GARLIC"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 10)
	add_affected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("25e9"),
		Currency.Type.MALIGNANCY: Value.new("15e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ANCHOVE_COVE


func init_MUD() -> void:
	details.name = "MUD"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.75)
	add_affected_lored(LORED.Type.IRON_ORE)
	add_affected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new("2e6"),
		Currency.Type.MALIGNANCY: Value.new(35000),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RIB


func init_SLOP() -> void:
	details.name = "SLOP"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.95)
	add_affected_lored(LORED.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.STONE: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SLIMER


func init_SLIMER() -> void:
	details.name = "SLIMER"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(150),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_STICKYTAR() -> void:
	details.name = "Sticktar"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.5, Currency.Type.TARBALLS)
	add_affected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(1400),
		Currency.Type.OIL: Value.new(75),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SLIMER


func init_INJECT() -> void:
	details.name = "INJECT"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_affected_lored(LORED.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new(100),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STICKYTAR


func init_RED_GOOPY_BOY() -> void:
	details.name = "Red Goopy Boy"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.4)
	add_affected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(30000),
		Currency.Type.COPPER: Value.new(30000),
		Currency.Type.MALIGNANCY: Value.new(50),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STICKYTAR


func init_AUTOSHOVELER() -> void:
	details.name = "Auto-Shoveler"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(1500),
	})


func init_SOCCER_DUDE() -> void:
	details.name = "Soccer Dude"
	set_effect(OldUpgradeEffect.Type.HASTE, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(1600),
	})


func init_AW() -> void:
	details.name = "aw <3"
	var loredy = lv.get_colored_name(LORED.Type.COAL)
	details.description = "Start the run with " + loredy + " already purchased!"
	set_effect(OldUpgradeEffect.Type.FREE_LORED)
	add_affected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(2),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ENTHUSIASM


func init_ENTHUSIASM() -> void:
	details.name = "Enthusiasm"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("3000"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSHOVELER


func init_CON_FRICKIN_CRETE() -> void:
	details.name = "CON-FRICKIN-CRETE"
	set_effect(OldUpgradeEffect.Type.OUTPUT_ONLY, 2)
	add_affected_lored(LORED.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("12e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSHOVELER


func init_HOW_IS_THIS_AN_RPG() -> void:
	details.name = "how is this an RPG anyway?"
	set_effect(OldUpgradeEffect.Type.CRIT, 5)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SOCCER_DUDE


func init_ITS_GROWIN_ON_ME() -> void:
	details.name = "IT'S GROWIN ON ME"
	var iron = lv.get_colored_name(LORED.Type.IRON)
	var cop = lv.get_colored_name(LORED.Type.COPPER)
	var growth = lv.get_colored_name(LORED.Type.GROWTH)
	details.description = "Whenever %s pops, either %s or %s will receive an [b]output and input boost[/b]." % [growth, iron, cop]
	details.icon = wa.get_icon(Currency.Type.GROWTH)
	details.color = lv.get_color(LORED.Type.GROWTH)
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.BONUS_ACTION_ON_CURRENCY_GAIN,
		{
			"upgrade_type": type,
			"currency": Currency.Type.GROWTH,
			"effect value": 1,
			"effect value2": 1,
			"bonus_action_type": OldUpgradeEffect.BONUS_ACTION.INCREASE_EFFECT1_OR_2,
			"modifier": 0.0001,
		}
	)
	effect.save_effect(true)
	add_affected_lored(LORED.Type.IRON)
	add_affected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("2e3"),
	})


func init_AUTOSTONER() -> void:
	details.name = "Auto-Stoner"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("35e3"),
	})


func init_OREOREUHBOREALICE() -> void:
	details.name = "OREOREUHBor [i]E[/i] ALICE"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.IRON_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("12e3"),
	})


func init_YOU_LITTLE_HARD_WORKER_YOU() -> void:
	details.name = "you little hard worker, you"
	set_effect(OldUpgradeEffect.Type.HASTE, 2)
	add_affected_lored(LORED.Type.STONE)
	add_affected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("40e3"),
	})


func init_COMPULSORY_JUICE() -> void:
	details.name = "Compulsory Juice"
	set_effect(OldUpgradeEffect.Type.OUTPUT_ONLY, 2.5)
	add_affected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("50e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSTONER


func init_BIG_TOUGH_BOY() -> void:
	details.name = "[b]Big Tough Boy[/b]"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("175e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOW_IS_THIS_AN_RPG


func init_STAY_QUENCHED() -> void:
	details.name = "Stay Quenched!"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.8)
	add_affected_lored(LORED.Type.COAL)
	add_affected_lored(LORED.Type.JOULES)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("60e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.YOU_LITTLE_HARD_WORKER_YOU


func init_OH_BABY_A_TRIPLE() -> void:
	details.name = "OH, BABY, A TRIPLE"
	set_effect(OldUpgradeEffect.Type.HASTE, 3)
	add_affected_lored(LORED.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("55e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.YOU_LITTLE_HARD_WORKER_YOU


func init_AUTOPOLICE() -> void:
	details.name = "Auto-Police"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("140e3"),
	})


func init_PIPPENPADDLE_OPPSOCOPOLIS() -> void:
	details.name = "pippenpaddle-oppso[b]COP[/b]olis"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("600e3"),
	})


func init_I_DRINK_YOUR_MILKSHAKE() -> void:
	details.name = "I DRINK YOUR MILKSHAKE"
	var coal = wa.get_icon_and_name_text(Currency.Type.COAL)
	var coal2 = lv.get_colored_name(LORED.Type.COAL)
	details.description = "Whenever a LORED takes %s, %s gets an output boost." % [coal, coal2]
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.BONUS_ACTION_ON_CURRENCY_USE,
		{
			"upgrade_type": type,
			"currency": Currency.Type.COAL,
			"effect value": 1,
			"bonus_action_type": OldUpgradeEffect.BONUS_ACTION.INCREASE_EFFECT,
			"modifier": 0.00001,
		}
	)
	effect.save_effect(true)
	add_affected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("800e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STAY_QUENCHED


func init_ORE_LORD() -> void:
	details.name = "Ore Lord"
	set_effect(OldUpgradeEffect.Type.HASTE, 2)
	add_affected_lored(LORED.Type.IRON_ORE)
	add_affected_lored(LORED.Type.COPPER_ORE)
	add_affected_lored(LORED.Type.IRON)
	add_affected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BIG_TOUGH_BOY


func init_MOIST() -> void:
	details.name = "[i]Moist[/i]"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("12e6"),
	})


func init_THE_THIRD() -> void:
	details.name = "The Third"
	var cop = wa.get_icon_and_name_text(Currency.Type.COPPER)
	var copo = lv.get_colored_name(LORED.Type.COPPER_ORE)
	details.description = "Whenever %s mines, he will produce an equal amount of %s." % [copo, cop]
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.BONUS_JOB_PRODUCTION,
		{
			"upgrade_type": type,
			"job": Job.Type.COPPER_ORE,
			"currency": Currency.Type.COPPER,
			"modifier": 1.0,
		}
	)
	add_affected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("2e8"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PIPPENPADDLE_OPPSOCOPOLIS


func init_WE_WERE_SO_CLOSE() -> void:
	details.name = "we were so close, now you don't even think about me"
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.UPGRADE_AUTOBUYER,
		{
			"upgrade_type": type,
			"upgrade_menu": UpgradeMenu.Type.NORMAL,
		}
	)
	details.icon = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL).details.icon
	details.color = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL).details.color
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOW_IS_THIS_AN_RPG


func init_UPGRADE_NAME() -> void:
	details.name = "upgrade_name"
	var test = gv.get_stage(1)
	var text = test.details.colored_name
	details.description = "Increases the output and input [b]increase[/b] of " + text + " LOREDs by 10%, but also increases their [b]maximum fuel[/b] and [b]fuel cost[/b] by 1,000%."
	set_effect(OldUpgradeEffect.Type.UPGRADE_NAME)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ORE_LORD


func init_WTF_IS_THAT_MUSK() -> void:
	details.name = "wtf is that musk"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.JOULES)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("43e7"),
	})


func init_CANCERS_COOL() -> void:
	details.name = "CANCER'S COOL"
	set_effect(OldUpgradeEffect.Type.HASTE, 2)
	add_affected_lored(LORED.Type.GROWTH)
	add_affected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("3e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MOIST


func init_I_RUN() -> void:
	details.name = "I RUN"
	var iron = wa.get_icon_and_name_text(Currency.Type.IRON)
	var irono = lv.get_colored_name(LORED.Type.IRON_ORE)
	details.description = "Whenever %s murders, he will produce an equal amount of %s." % [irono, iron]
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.BONUS_JOB_PRODUCTION,
		{
			"upgrade_type": type,
			"job": Job.Type.IRON_ORE,
			"currency": Currency.Type.IRON,
			"modifier": 1.0,
		}
	)
	add_affected_lored(LORED.Type.IRON_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("25e9"),
	})


func init_COAL_DUDE() -> void:
	details.name = "[img=<15>]res://Sprites/Currency/coal.png[/img] Coal Dude"
	set_effect(OldUpgradeEffect.Type.HASTE, 2)
	add_affected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e11"),
	})


func init_CANKERITE() -> void:
	details.name = "CANKERITE"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("15e9"),
	})


func init_SENTIENT_DERRICK() -> void:
	details.name = "Sentient Derrick"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.OIL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("85e10"),
	})


func init_SLAPAPOW() -> void:
	details.name = "SLAPAPOW!"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("17e11"),
	})


func init_SIDIUS_IRON() -> void:
	details.name = "Sidius Iron"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("8e12"),
	})


func init_MOUND() -> void:
	details.name = "Mound"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("35e12"),
	})


func init_FOOD_TRUCKS() -> void:
	details.name = "Food Trucks"
	set_effect(OldUpgradeEffect.Type.OUTPUT_ONLY, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UPGRADE_NAME


func init_OPPAI_GUY() -> void:
	details.name = "Oppai Guy"
	set_effect(OldUpgradeEffect.Type.HASTE, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e15"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FOOD_TRUCKS


func init_MALEVOLENT() -> void:
	details.name = "Malevolent"
	set_effect(OldUpgradeEffect.Type.HASTE, 2)
	add_affected_lored(LORED.Type.TARBALLS)
	add_affected_lored(LORED.Type.CONCRETE)
	add_affected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e24"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MOUND


func init_SLUGGER() -> void:
	details.name = "Slugger"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e16"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.OPPAI_GUY


func init_THIS_GAME_IS_SO_ESEY() -> void:
	details.name = "This game is SO ESEY"
	set_effect(OldUpgradeEffect.Type.CRIT, 5)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("50e15"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SLUGGER


func init_WAIT_THATS_NOT_FAIR() -> void:
	details.name = "wait that's not fair"
	var coal = lv.get_colored_name(LORED.Type.COAL)
	var stone = wa.get_icon_and_name_text(Currency.Type.STONE)
	details.description = "Whenever %s digs, he will produce ten times as much %s." % [coal, stone]
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.BONUS_JOB_PRODUCTION,
		{
			"upgrade_type": type,
			"job": Job.Type.COAL,
			"currency": Currency.Type.STONE,
			"modifier": 10.0,
		}
	)
	add_affected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e18"),
	})


func init_PROCEDURE() -> void:
	details.name = "[i]Procedure[/i]"
	var metas = gv.get_stage(1).details.color_text % "Metastasizing"
	var amount = Big.new("1e20").text
	var malig = wa.get_icon_and_name_text(Currency.Type.MALIGNANCY)
	var tum = wa.get_icon_and_name_text(Currency.Type.TUMORS)
	var tum2 = lv.get_colored_name(LORED.Type.TUMORS)
	details.description = "When %s, every %s %s will be spent to reward you with %s based on %s's output." % [metas, amount, malig, tum, tum2]
	set_effect(OldUpgradeEffect.Type.HASTE, 1)
	details.icon = wa.get_icon(Currency.Type.TUMORS)
	details.color = wa.get_color(Currency.Type.TUMORS)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e19"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UPGRADE_NAME


func init_LIL_SAUCY_BOSSY() -> void:
	details.name = "Lil' [i]Saucy Bossy[/i]"
	var x = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL).details.colored_name
	var y = gv.get_stage(1).details.color_text % "Metastasis"
	details.description = "%s upgrades will persist through %s." % [x, y]
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.UPGRADE_PERSIST, {
			"upgrade_type": type,
			"stage": 1,
			"affected_upgrades": [
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
	var upmenu = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL) as UpgradeMenu
	details.icon = upmenu.details.icon
	details.color = upmenu.details.color
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e20"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RED_NECROMANCY


func init_ROUTINE() -> void:
	details.name = "[i]Routine[/i]"
	var metas = gv.get_stage(1).details.color_text % "Metastasizes"
	details.description = "%s immediately. After one second, becomes purchasable again." % metas
	details.icon = res.get_resource("s1m")
	details.color = gv.get_stage_color(1)
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.PRESTIGE_IMMEDIATELY, {
			"upgrade_type": type,
			"stage": 1,
		}
	)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e20"),
	})
	persist.s1.set_to(true)
	await up.all_upgrades_initialized
	required_upgrade = Type.LIL_SAUCY_BOSSY


func init_CANOPY() -> void:
	details.name = "Canopy"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.TREES: Value.new("10"),
	})


func init_APPRENTICE_IRON_WORKER() -> void:
	details.name = "Apprentice Iron Worker"
	set_effect(OldUpgradeEffect.Type.CRIT, 6)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("25"),
	})


func init_DOUBLE_BARRELS() -> void:
	details.name = "Double Barrels"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("50"),
		Currency.Type.HARDWOOD: Value.new("100"),
	})


func init_RAIN_DANCE() -> void:
	details.name = "Rain Dance"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.2)
	add_affected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.SAND: Value.new("40"),
	})


func init_LIGHTHOUSE() -> void:
	details.name = "Lighthouse"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.15)
	add_affected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("130"),
	})


func init_ROGUE_BLACKSMITH() -> void:
	details.name = "Rogue Blacksmith"
	set_effect(OldUpgradeEffect.Type.CRIT, 6)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("1e3"),
		Currency.Type.GLASS: Value.new("1e3"),
		Currency.Type.CARCINOGENS: Value.new("35"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.APPRENTICE_IRON_WORKER


func init_TRIPLE_BARRELS() -> void:
	details.name = "Triple Barrels"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("350"),
		Currency.Type.STEEL: Value.new("100"),
		Currency.Type.SOIL: Value.new("250"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.DOUBLE_BARRELS


func init_BREAK_THE_DAM() -> void:
	details.name = "BREAK THE DAM"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_affected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.LIQUID_IRON: Value.new("30"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RAIN_DANCE


func init_THIS_MIGHT_PAY_OFF_SOMEDAY() -> void:
	details.name = "This might pay off someday!"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.IRON)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("1e6"),
	})


func init_DIRT_COLLECTION_REWARDS_PROGRAM() -> void:
	details.name = "*Dirt Collection Rewards Program!*"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_affected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.SOIL: Value.new("25e3"),
		Currency.Type.LEAD: Value.new("25e3"),
		Currency.Type.CARCINOGENS: Value.new("350"),
	})


func init_EQUINE() -> void:
	details.name = "[b]Equine[/b]"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_affected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("90"),
	})


func init_UNPREDICTABLE_WEATHER() -> void:
	details.name = "Unpredictable Weather"
	set_effect(OldUpgradeEffect.Type.CRIT, 8)
	add_affected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("1e3"),
		Currency.Type.GLASS: Value.new("1e3"),
		Currency.Type.TREES: Value.new("2.5e3"),
		Currency.Type.CARCINOGENS: Value.new("35"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BREAK_THE_DAM


func init_DECISIVE_STRIKES() -> void:
	details.name = "Decisive Strikes"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.AXES)
	add_affected_lored(LORED.Type.WOOD)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("350"),
		Currency.Type.GLASS: Value.new("425"),
		Currency.Type.SOIL: Value.new("500"),
	})


func init_SOFT_AND_SMOOTH() -> void:
	details.name = "Decisive Strikes"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("4500"),
		Currency.Type.CARCINOGENS: Value.new("900"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UNPREDICTABLE_WEATHER


func init_FLIPPY_FLOPPIES() -> void:
	details.name = "Flippy Floppies"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.HUMUS)
	add_affected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("850"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UNPREDICTABLE_WEATHER


func init_WOODTHIRSTY() -> void:
	details.name = "Woodthirsty"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.3)
	add_affected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.WOOD: Value.new("800"),
		Currency.Type.HARDWOOD: Value.new("100"),
	})


func init_SEEING_BROWN() -> void:
	details.name = "Seeing [color=#7b3f00]Brown[/color]"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("300"),
		Currency.Type.WIRE: Value.new("300"),
		Currency.Type.TREES: Value.new("100"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WOODTHIRSTY


func init_WOODIAC_CHOPPER() -> void:
	details.name = "Woodiac Chopper"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.4)
	add_affected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("50"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SEEING_BROWN


func init_CARLIN() -> void:
	details.name = "Carlin"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.1)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.LEAD: Value.new("600"),
	})


func init_HARDWOOD_YOURSELF() -> void:
	details.name = "[img=<15>]res://Sprites/Currency/hard.png[/img] Hardwood Yourself"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.HARDWOOD)
	add_affected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("185"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_STEEL_YOURSELF() -> void:
	details.name = "[img=<15>]res://Sprites/Currency/steel.png[/img] Steel Yourself"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.LIQUID_IRON)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_PLASMA_BOMBARDMENT() -> void:
	details.name = "Plasma Bombardment"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("310"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_PATREON_ARTIST() -> void:
	details.name = "Patreon Artist"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.2)
	add_affected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_MILLERY() -> void:
	details.name = "Millery"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_affected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("385"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HARDWOOD_YOURSELF


func init_QUAMPS() -> void:
	details.name = "Quamps"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.35)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("600"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STEEL_YOURSELF


func init_TWO_FIVE_FIVE_TWO() -> void:
	details.name = "[i]2552[/i]"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.SAND)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("750"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PLASMA_BOMBARDMENT


func init_GIMP() -> void:
	details.name = "GIMP"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_affected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("900"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PATREON_ARTIST


func init_SAGAN() -> void:
	details.name = "Sagan"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.1)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("5"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_HENRY_CAVILL() -> void:
	details.name = "Henry Cavill"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_affected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.CIGARETTES: Value.new("23.23"),
		Currency.Type.WOOD_PULP: Value.new("70"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_LEMBAS_WATER() -> void:
	details.name = "Lembas Water"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.WATER)
	add_affected_lored(LORED.Type.TREES)
	cost = Cost.new({
		Currency.Type.TOBACCO: Value.new("45"),
		Currency.Type.WATER: Value.new("300"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_BIGGER_TREES_I_GUESS() -> void:
	details.name = "bigger trees i guess"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.TREES)
	add_affected_lored(LORED.Type.WOOD)
	cost = Cost.new({
		Currency.Type.PLASTIC: Value.new("10e3"),
		Currency.Type.WOOD_PULP: Value.new("1e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_JOURNEYMAN_IRON_WORKER() -> void:
	details.name = "Journeyman Iron Worker"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.AXES: Value.new("250"),
		Currency.Type.CARCINOGENS: Value.new("50"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_CUTTING_CORNERS() -> void:
	details.name = "Cutting Corners!"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.WOOD)
	add_affected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("5.5e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MILLERY


func init_QUORMPS() -> void:
	details.name = "Cutting Corners!"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.LIQUID_IRON)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("4.5e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.QUAMPS


func init_KILTY_SBARK() -> void:
	details.name = "Kilty Sbark"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.15)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("6.5e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TWO_FIVE_FIVE_TWO


func init_HOLE_GEOMETRY() -> void:
	details.name = "Kilty Sbark"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.DRAW_PLATE)
	add_affected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.WOOD_PULP: Value.new("10e3"),
		Currency.Type.HARDWOOD: Value.new("5.2e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GIMP


func init_CIORAN() -> void:
	details.name = "Cioran"
	set_effect(OldUpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e3"),
		Currency.Type.TUMORS: Value.new("100"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_WOOD_LORD() -> void:
	details.name = "Wood Lord"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.15)
	add_affected_lored(LORED.Type.AXES)
	add_affected_lored(LORED.Type.WOOD)
	add_affected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("35e3"),
		Currency.Type.CARCINOGENS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CUTTING_CORNERS


func init_EXPERT_IRON_WORKER() -> void:
	details.name = "Expert Iron Worker"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.15)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("40e3"),
		Currency.Type.CARCINOGENS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.QUORMPS


func init_THEYVE_ALWAYS_BEEN_FASTER() -> void:
	details.name = "They've Always Been Faster"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.15)
	add_affected_lored(LORED.Type.HUMUS)
	add_affected_lored(LORED.Type.SAND)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("75e3"),
		Currency.Type.CARCINOGENS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.KILTY_SBARK


func init_WHERES_THE_BOY_STRING() -> void:
	details.name = "Where's the boy, String?"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.15)
	add_affected_lored(LORED.Type.DRAW_PLATE)
	add_affected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("35e3"),
		Currency.Type.CARCINOGENS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOLE_GEOMETRY


func init_UTTER_MOLESTER_CHAMP() -> void:
	details.name = "Utter Molester Champ"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.15)
	add_affected_lored(LORED.Type.PETROLEUM)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("100e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_CANCERS_REAL_COOL() -> void:
	details.name = "CANCER'S REAL COOL"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_affected_lored(LORED.Type.TUMORS)
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
	details.name = "Sp0oKy"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.15)
	add_affected_lored(LORED.Type.CARCINOGENS)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e3"),
		Currency.Type.TUMORS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_SQUEEORMP() -> void:
	details.name = "Squeeormp"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.PETROLEUM)
	add_affected_lored(LORED.Type.PLASTIC)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("100e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_SANDAL_FLANDALS() -> void:
	details.name = "Sandal Flandals"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.HUMUS)
	add_affected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.SAND: Value.new("100e3"),
		Currency.Type.CARCINOGENS: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_GLITTERDELVE() -> void:
	details.name = "Glitterdelve"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.GALENA)
	cost = Cost.new({
		Currency.Type.LEAD: Value.new("100e3"),
		Currency.Type.CARCINOGENS: Value.new("8e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_VIRILE() -> void:
	details.name = "VIRILE"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.SEEDS)
	add_affected_lored(LORED.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.CIGARETTES: Value.new("50e3"),
		Currency.Type.CARCINOGENS: Value.new("1.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_FACTORY_SQUIRTS() -> void:
	details.name = "Factory Squirts"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.PETROLEUM)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new("2e8"),
		Currency.Type.LEAD: Value.new("3e3"),
		Currency.Type.TUMORS: Value.new("500"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_LONGBOTTOM_LEAF() -> void:
	details.name = "Longbottom Leaf"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.WOOD: Value.new("500e3"),
		Currency.Type.CARCINOGENS: Value.new("5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_INDEPENDENCE() -> void:
	details.name = "INDEPENDENCE"
	set_effect(OldUpgradeEffect.Type.CRIT, 10)
	add_affected_lored(LORED.Type.LEAD)
	cost = Cost.new({
		Currency.Type.GALENA: Value.new("450e3"),
		Currency.Type.LEAD: Value.new("450e3"),
		Currency.Type.CARCINOGENS: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_NIKEY_WIKEYS() -> void:
	details.name = "Nikey Wikeys"
	set_effect(OldUpgradeEffect.Type.CRIT, 7)
	add_affected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.SOIL: Value.new("1e6"),
		Currency.Type.CARCINOGENS: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_ERECTWOOD() -> void:
	details.name = "ERECTWOOD"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_affected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("2e7"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WOOD_LORD


func init_STEELY_DAN() -> void:
	details.name = "Steely Dan"
	set_effect(OldUpgradeEffect.Type.CRIT, 7)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("3e7"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.EXPERT_IRON_WORKER


func init_MGALEKGOLO() -> void:
	details.name = "Mgalekgolo"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("80e6"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THEYVE_ALWAYS_BEEN_FASTER


func init_PULLEY() -> void:
	details.name = "Pulley"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.DRAW_PLATE)
	add_affected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("95e6"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WHERES_THE_BOY_STRING


func init_LE_GUIN() -> void:
	details.name = "Le Guin"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e6"),
		Currency.Type.TUMORS: Value.new("100e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_FLEEORMP() -> void:
	details.name = "Fleeormp"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.GALENA)
	add_affected_lored(LORED.Type.LEAD)
	cost = Cost.new({
		Currency.Type.GALENA: Value.new("100e6"),
		Currency.Type.LEAD: Value.new("80e6"),
		Currency.Type.WIRE: Value.new("50e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_POTENT() -> void:
	details.name = "Potent"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.WATER)
	add_affected_lored(LORED.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.SEEDS: Value.new("30e6"),
		Currency.Type.PAPER: Value.new("45e6"),
		Currency.Type.SOIL: Value.new("60e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_LIGHT_AS_A_FEATHER() -> void:
	details.name = "Light as a Feather"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.STEEL)
	add_affected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.DRAW_PLATE: Value.new("10e6"),
		Currency.Type.CARCINOGENS: Value.new("10e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_BUSY_BEE() -> void:
	details.name = "Busy Bee"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.3)
	add_affected_lored(LORED.Type.SEEDS)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("10e6"),
		Currency.Type.GLASS: Value.new("15e6"),
		Currency.Type.LEAD: Value.new("50e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_DINDER_MUFFLIN() -> void:
	details.name = "Dinder Mufflin"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.PAPER)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("100e6"),
		Currency.Type.GLASS: Value.new("150e6"),
		Currency.Type.LEAD: Value.new("500e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_ULTRA_SHITSTINCT() -> void:
	details.name = "Ultra Shitstinct"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.35)
	add_affected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.WATER: Value.new("1e9"),
		Currency.Type.SEEDS: Value.new("25e6"),
		Currency.Type.CARCINOGENS: Value.new("10e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_AND_THIS_IS_TO_GO_EVEN_FURTHER_BEYOND() -> void:
	details.name = "And this is to go [i]even further beyond![/i]"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.PAPER: Value.new("1e7"),
		Currency.Type.WOOD_PULP: Value.new("3e7"),
		Currency.Type.WATER: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_POWER_BARRELS() -> void:
	details.name = "Power Barrels"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.2)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("100e6"),
		Currency.Type.GLASS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_A_BEE_WITH_TINY_DAGGERS() -> void:
	var shit = "[shake rate=20.0 level=5 connected=1]%s[/shake]"
	details.name = shit % "a bee with tiny daggers!!!"
	details.icon = load("res://Sprites/Upgrades/abeewithdaggers.png")
	details.color = lv.get_color(LORED.Type.SEEDS)
	set_effect(OldUpgradeEffect.Type.CRIT, 6)
	add_affected_lored(LORED.Type.SEEDS)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("1e9"),
		Currency.Type.GLASS: Value.new("25e6"),
		Currency.Type.CARCINOGENS: Value.new("10e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BUSY_BEE


func init_HARDWOOD_YO_MAMA() -> void:
	details.name = "[img=<15>]res://Sprites/Currency/hard.png[/img] Hardwood Yo Mama"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.HARDWOOD)
	add_affected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ERECTWOOD


func init_STEEL_YO_MAMA() -> void:
	details.name = "[img=<15>]res://Sprites/Currency/steel.png[/img] Steel Yo Mama"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.LIQUID_IRON)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STEELY_DAN


func init_MAGNETIC_ACCELERATOR() -> void:
	details.name = "Magnetic Accelerator"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.SAND)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MGALEKGOLO


func init_SPOOLY() -> void:
	details.name = "Spooly"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_affected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PULLEY


func init_TORIYAMA() -> void:
	details.name = "Toriyama"
	set_effect(OldUpgradeEffect.Type.CRIT, 4)
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
	details.name = "Burdened"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_affected_lored(LORED.Type.LEAD)
	cost = Cost.new({
		Currency.Type.HUMUS: Value.new("10e9"),
		Currency.Type.WOOD_PULP: Value.new("4e9"),
		Currency.Type.PAPER: Value.new("1"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TORIYAMA


func init_SQUEEOMP() -> void:
	details.name = "Squeeomp"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.PETROLEUM)
	add_affected_lored(LORED.Type.PLASTIC)
	cost = Cost.new({
		Currency.Type.TOBACCO: Value.new("12e9"),
		Currency.Type.CARCINOGENS: Value.new("3e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TORIYAMA


func init_BARELY_WOOD_BY_NOW() -> void:
	details.name = "Barely Wood by Now"
	set_effect(OldUpgradeEffect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.WOOD)
	add_affected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("15e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HARDWOOD_YO_MAMA


func init_FINGERS_OF_ONDEN() -> void:
	details.name = "Fingers of Onden"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("15e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STEEL_YO_MAMA


func init_O_SALVATORI() -> void:
	details.name = "O'Salvatori"
	set_effect(OldUpgradeEffect.Type.CRIT, 6)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("15e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MAGNETIC_ACCELERATOR


func init_LOW_RISES() -> void:
	details.name = "low rises"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.35)
	add_affected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("10e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SPOOLY


func init_ILL_SHOW_YOU_HARDWOOD() -> void:
	details.name = "i'll show you hardwood"
	set_effect(OldUpgradeEffect.Type.CRIT, 6)
	add_affected_lored(LORED.Type.AXES)
	add_affected_lored(LORED.Type.WOOD)
	add_affected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("1e12"),
		Currency.Type.CARCINOGENS: Value.new("250e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BARELY_WOOD_BY_NOW


func init_STEEL_LORD() -> void:
	details.name = "Steel Lord"
	set_effect(OldUpgradeEffect.Type.CRIT, 6)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("1e12"),
		Currency.Type.CARCINOGENS: Value.new("250e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FINGERS_OF_ONDEN


func init_FINISH_THE_FIGHT() -> void:
	details.name = "Finish the Fight"
	set_effect(OldUpgradeEffect.Type.CRIT, 6)
	add_affected_lored(LORED.Type.HUMUS)
	add_affected_lored(LORED.Type.SAND)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("1e12"),
		Currency.Type.CARCINOGENS: Value.new("250e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.O_SALVATORI


func init_MICROSOFT_PAINT() -> void:
	details.name = "Microsoft Paint"
	set_effect(OldUpgradeEffect.Type.CRIT, 6)
	add_affected_lored(LORED.Type.DRAW_PLATE)
	add_affected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("1e12"),
		Currency.Type.CARCINOGENS: Value.new("250e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LOW_RISES


func init_JOHN_PETER_BAIN_TOTALBISCUIT() -> void:
	details.name = "[img=<15>]res://Sprites/upgrades/Totalbiscuit.png[/img] John Peter Bain, TotalBiscuit"
	details.icon = load("res://Sprites/upgrades/Totalbiscuit.png")
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e12"),
		Currency.Type.TUMORS: Value.new("10e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TORIYAMA


func init_MECHANICAL() -> void:
	details.name = "Mechanical"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("250"),
	})


func init_LIMIT_BREAK() -> void:
	details.name = "[rainbow freq=0.15][wave amp=20 freq=1]Limit Break[/wave][/rainbow]"
	var a = gv.get_stage(1).details.colored_name
	var b = gv.get_stage(2).details.colored_name
	details.description = "%s and %s LOREDs may now charge [b]Limit Break[/b], greatly increasing their [b]output and input[/b]." % [a, b]
	effect = OldUpgradeEffect.new(OldUpgradeEffect.Type.LIMIT_BREAK, {
		"upgrade_type": type,
		"effect value": 1,
		"xp": ValuePair.new(1000),
	})
	details.color = gv.get_stage_color(2)
	details.icon = res.get_resource("axe")
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("250"),
	})


func init_DONT_TAKE_CANDY_FROM_BABIES() -> void:
	details.name = "don't take candy from babies"
	details.description = "Stage 2 and up LOREDs will not take resources from a Stage 1 resource if its producing LORED is below level 5."
	details.icon = gv.get_stage_icon(Stage.Type.STAGE1)
	details.color = gv.get_stage_color(Stage.Type.STAGE1)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MECHANICAL


func init_SPLISHY_SPLASHY() -> void:
	details.name = "Splishy Splashy"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("4e3"),
	})


func init_MILK() -> void:
	details.name = "Milk"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2e3"),
	})


func init_FALCON_PAWNCH() -> void:
	details.name = "FALCON [b]PAWNCH[/b]"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1250"),
	})


func init_SPEED_SHOPPER() -> void:
	details.name = "Speed-Shopper"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("35e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.DONT_TAKE_CANDY_FROM_BABIES


func init_AUTOSMITHY() -> void:
	details.name = "Auto-Smithy"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("8e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SPLISHY_SPLASHY


func init_GATORADE() -> void:
	details.name = "Gatorade?"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MILK


func init_KAIO_KEN() -> void:
	details.name = "KAIO-KEN"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("6250"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FALCON_PAWNCH


func init_AUTOSENSU() -> void:
	details.name = "Auto-Sensu"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.WOOD)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("160e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSMITHY


func init_APPLE_JUICE() -> void:
	details.name = "Apple Juice"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("600e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GATORADE


func init_DANCE_OF_THE_FIRE_GOD() -> void:
	details.name = "Dance of the Fire God"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("450e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.KAIO_KEN


func init_SUDDEN_COMMISSION() -> void:
	details.name = "Sudden Commission"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.DRAW_PLATE)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSENSU


func init_PEPPERMINT_MOCHA() -> void:
	details.name = "Peppermint Mocha Latte"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1800e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.APPLE_JUICE


func init_RASENGAN() -> void:
	details.name = "Rasengan"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.35e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.DANCE_OF_THE_FIRE_GOD


func init_MUDSLIDE() -> void:
	details.name = "Mudslide"
	set_effect(OldUpgradeEffect.Type.OUTPUT_ONLY, 1.25)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e7"),
	})


func init_THE_GREAT_JOURNEY() -> void:
	details.name = "The Great Journey"
	set_effect(OldUpgradeEffect.Type.OUTPUT_ONLY, 1.2)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e7"),
	})


func init_BEAVER() -> void:
	details.name = "The Great Journey"
	set_effect(OldUpgradeEffect.Type.OUTPUT_ONLY, 1.2)
	add_affected_lored(LORED.Type.WOOD)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e7"),
	})


func init_MODS_ENABLED() -> void:
	details.name = "Mods Enabled"
	set_effect(OldUpgradeEffect.Type.OUTPUT_ONLY, 1.25)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e7"),
	})


func init_COVENANT_DANCE() -> void:
	details.name = "Covenant Dance"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PEPPERMINT_MOCHA


func init_OVERTIME() -> void:
	details.name = "Overtime"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.COVENANT_DANCE


func init_BONE_MEAL() -> void:
	details.name = "Bone Meal"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.TREES)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("4e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.OVERTIME


func init_SILLY() -> void:
	details.name = "Silly"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("8e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BONE_MEAL


func init_SPEED_DOODS() -> void:
	details.name = "Speed-Doods"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.DRAW_PLATE)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("128e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.EREBOR


func init_EREBOR() -> void:
	details.name = "Erebor"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.GALENA)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("64e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CHILD_ENERGY


func init_CHILD_ENERGY() -> void:
	details.name = "Child Energy"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.SOIL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("32e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PLATE


func init_PLATE() -> void:
	details.name = "Plate"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.5)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("16e7"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SILLY


func init_MASTER() -> void:
	details.name = "Master"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SUDDEN_COMMISSION


func init_STRAWBERRY_BANANA_SMOOTHIE() -> void:
	details.name = "Strawberry Banana Smoothie"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("540e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PEPPERMINT_MOCHA


func init_AVATAR_STATE() -> void:
	details.name = "Avatar State"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("405e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RASENGAN


func init_AXELOT() -> void:
	details.name = "Axelot"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MASTER


func init_GREEN_TEA() -> void:
	details.name = "Green Tea"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.62e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STRAWBERRY_BANANA_SMOOTHIE


func init_HAMON() -> void:
	details.name = "Hamon"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.215e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AVATAR_STATE


func init_AUTOSHIT() -> void:
	details.name = "Auto-Shit"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AXELOT


func init_FRENCH_VANILLA() -> void:
	details.name = "French Vanilla"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("5e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GREEN_TEA


func init_METAL_CAP() -> void:
	details.name = "Metal Cap"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3.6e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HAMON


func init_SMASHY_CRASHY() -> void:
	details.name = "Smashy Crashy"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.TREES)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("4e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSHIT


func init_WATER() -> void:
	details.name = "Water"
	set_effect(OldUpgradeEffect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.5e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FRENCH_VANILLA


func init_STAR_ROD() -> void:
	details.name = "Star Rod"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.1e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.METAL_CAP


func init_A_BABY_ROLEUM() -> void:
	details.name = "A baby Roleum!! Thanks, pa!"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.PETROLEUM)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("8e10"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SMASHY_CRASHY


func init_POOFY_WIZARD_BOY() -> void:
	details.name = "Poofy Wizard Boy"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.6e11"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.A_BABY_ROLEUM


func init_BENEFIT() -> void:
	details.name = "Benefit"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.GALENA)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3.2e11"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.POOFY_WIZARD_BOY


func init_AUTOAQUATICIDE() -> void:
	details.name = "Auto-Aquaticide"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.PLASTIC)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("6.4e11"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BENEFIT


func init_GO_ON_THEN_LEAD_US() -> void:
	details.name = "Go on, then, LEAD us!"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.LEAD)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.3e12"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOAQUATICIDE


func init_THE_WITCH_OF_LOREDELITH() -> void:
	var shit = lv.get_lored(LORED.Type.WITCH).details.color_text
	details.name = shit % "The Witch of Loredelith"
	details.description = "Stage 1 LOREDs permanently gain Aurus's Bounty, Circe's powerful buff."
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.APPLY_LORED_BUFF,
		{
			"upgrade_type": type,
			"buff": LOREDBuff.Type.WITCH,
		}
	)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e12"),
	})


func init_TOLKIEN() -> void:
	details.name = "Tolkien"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e12"),
	})


func init_BEEKEEPING() -> void:
	details.name = "Tolkien"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.SEEDS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2.5e12"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GO_ON_THEN_LEAD_US


func init_ELBOW_STRAPS() -> void:
	details.name = "Elbow Straps"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.25)
	add_affected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e12"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH


func init_AUTO_PERSIST() -> void:
	details.name = "Auto-Persist"
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.UPGRADE_PERSIST, {
			"upgrade_type": type,
			"stage": 2,
			"affected_upgrades": [
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
	details.icon = load("res://Sprites/Hud/autobuy.png")
	details.color = gv.get_stage_color(Stage.Type.STAGE1)
	details.description = "Stage 1 autobuyer Upgrades [i]persist through[/i] Chemotherapy!"
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH


func init_KETO() -> void:
	details.name = "Keto"
	set_effect(OldUpgradeEffect.Type.INPUT, 0.01)
	add_affected_lored(LORED.Type.IRON)
	add_affected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH


func init_NOW_THATS_WHAT_IM_TALKIN_ABOUT() -> void:
	details.name = "Now That's What I'm Talkin About, Yeeeeeeaaaaaaa[b]AAAAAAGGGGGHHH[/b]"
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.UPGRADE_AUTOBUYER,
		{
			"upgrade_type": type,
			"upgrade_menu": UpgradeMenu.Type.EXTRA_NORMAL,
		}
	)
	details.icon = up.get_upgrade_menu(UpgradeMenu.Type.EXTRA_NORMAL).details.icon
	details.color = up.get_upgrade_menu(UpgradeMenu.Type.EXTRA_NORMAL).details.color
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e12"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH


func init_SCOOPY_DOOPY() -> void:
	details.name = "Scoopy Doopy"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.SOIL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("5e12"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.BEEKEEPING


func init_THE_ATHORE_COMENTS_AL_TOTOL_LIES() -> void:
	details.name = "the athore coments al totol lies!"
	set_effect(OldUpgradeEffect.Type.CRIT, 10)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ELBOW_STRAPS


func init_ITS_SPREADIN_ON_ME() -> void:
	details.name = "IT'S SPREADIN ON ME"
	var iron = lv.get_colored_name(LORED.Type.IRON)
	var cop = lv.get_colored_name(LORED.Type.COPPER)
	var irono = lv.get_colored_name(LORED.Type.IRON_ORE)
	var copo = lv.get_colored_name(LORED.Type.COPPER_ORE)
	var growth = lv.get_colored_name(LORED.Type.GROWTH)
	details.description = "Placeholder"
	details.icon = wa.get_icon(Currency.Type.GROWTH)
	details.color = lv.get_color(LORED.Type.GROWTH)
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.BONUS_ACTION_ON_CURRENCY_GAIN,
		{
			"upgrade_type": type,
			"currency": Currency.Type.GROWTH,
			"replaced_upgrade": Type.ITS_GROWIN_ON_ME,
			"effect value": 1,
			"bonus_action_type": OldUpgradeEffect.BONUS_ACTION.INCREASE_EFFECT,
			"modifier": 0.0001,
		}
	)
	effect.save_effect(true)
	add_affected_lored(LORED.Type.IRON_ORE)
	add_affected_lored(LORED.Type.COPPER_ORE)
	add_affected_lored(LORED.Type.IRON)
	add_affected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("8e13"),
	})
	
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTO_PERSIST
	
	var itsgrowin = up.get_upgrade(Type.ITS_GROWIN_ON_ME).details.icon_and_colored_name
	details.description = "Whenever %s pops, %s, %s, %s, and %s all receive an [b]output and input boost[/b]. This Upgrade replaces %s." % [growth, irono, copo, iron, cop, itsgrowin]


func init_WHAT_IN_COUSIN_FUCKIN_TARNATION() -> void:
	details.name = "Hellfire! I have [i]never![/i]"
	set_effect(OldUpgradeEffect.Type.OUTPUT_ONLY, 10)
	add_affected_lored(LORED.Type.MALIGNANCY)
	details.icon = wa.get_icon(Currency.Type.MALIGNANCY)
	details.color = wa.get_color(Currency.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("5e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.KETO


func init_MASTER_IRON_WORKER() -> void:
	details.name = "Master Iron Worker"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SCOOPY_DOOPY


func init_JOINTSHACK() -> void:
	details.name = "Jointshack"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.PAPER)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("2e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MASTER_IRON_WORKER


func init_DUST() -> void:
	details.name = "Dust"
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.LORED_PERSIST,
		{
			"upgrade_type": type,
			"stage": 1
		}
	)
	add_effected_stage(1)
	var a = up.get_menu_color_text(UpgradeMenu.Type.MALIGNANT) % "Metastasizing"
	var b = gv.get_stage(Stage.Type.STAGE1).details.colored_name
	details.description = "%s no longer resets %s LOREDs." % [a, b]
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e14"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ITS_SPREADIN_ON_ME


func init_CAPITAL_PUNISHMENT() -> void:
	details.name = "[b]Capital Punishment[/b]"
	details.icon = wa.get_icon(Currency.Type.TUMORS)
	details.color = gv.get_stage_color(Stage.Type.STAGE1)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e14"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ITS_SPREADIN_ON_ME
	
	var a = wa.get_icon_and_name_text(Currency.Type.TUMORS)
	var b = up.get_upgrade(Upgrade.Type.PROCEDURE).details.icon_and_colored_name
	var c = gv.get_stage(Stage.Type.STAGE1).details.colored_name
	details.description = "%s gained from %s are multiplied by your %s run count." % [a, b, c]


func init_AROUSAL() -> void:
	details.name = "Arousal"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("4e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.JOINTSHACK


func init_AUTOFLOOF() -> void:
	details.name = "Auto-Floof"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.WOOD_PULP)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("8e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AROUSAL


func init_ELECTRONIC_CIRCUITS() -> void:
	details.name = "Electronic Circuits"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.7e14"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOFLOOF


func init_AUTOBADDECISIONMAKER() -> void:
	details.name = "Auto-Baddecisionmaker"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.CIGARETTES)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3.6e14"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ELECTRONIC_CIRCUITS


func init_CONDUCT() -> void:
	details.name = "[b]Conduct[/b]"
	var stage1 = gv.get_stage(1)
	var a = stage1.details.color_text % "Metastasizing"
	var b = stage1.details.colored_name
	details.description = "%s no longer resets %s resources." % [a, b]
	var _stage = gv.get_stage(1)
	details.icon = _stage.details.icon
	details.color = _stage.details.color
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.CURRENCY_PERSIST,
		{
			"upgrade_type": type,
			"stage": 1
		}
	)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e15"),
	})


func init_PILLAR_OF_AUTUMN() -> void:
	details.name = "Pillar of Autumn"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("7.5e16"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOBADDECISIONMAKER


func init_WHAT_KIND_OF_RESOURCE_IS_TUMORS() -> void:
	details.name = "what kind of resource is '[img=<15>]res://Sprites/Currency/tum.png[/img] tumors', you hack fraud"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.TUMORS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1.5e17"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PILLAR_OF_AUTUMN


func init_DEVOUR() -> void:
	details.name = "DEVOUR"
	set_effect(OldUpgradeEffect.Type.AUTOBUYER)
	add_affected_lored(LORED.Type.CARCINOGENS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e17"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WHAT_KIND_OF_RESOURCE_IS_TUMORS


func init_IS_IT_SUPPOSED_TO_BE_STICK_DUDES() -> void:
	details.name = "is it SUPPOSED to be stick dudes?"
	set_effect(OldUpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e18"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TOLKIEN


func init_I_DISAGREE() -> void:
	details.name = "I Disagree"
	set_effect(OldUpgradeEffect.Type.INPUT, 0.9)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("3e18"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.IS_IT_SUPPOSED_TO_BE_STICK_DUDES


func init_HOME_RUN_BAT() -> void:
	details.name = "Home Run Bat"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("9e18"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.I_DISAGREE


func init_BLAM_THIS_PIECE_OF_CRAP() -> void:
	details.name = "BLAM this piece of crap!"
	set_effect(OldUpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("27e18"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOME_RUN_BAT


func init_DOT_DOT_DOT() -> void:
	details.name = "DOT DOT DOT"
	set_effect(OldUpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("6e19"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOME_RUN_BAT


func init_ONE_PUNCH() -> void:
	details.name = "One Punch"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 1.5)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e20"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.DOT_DOT_DOT


func init_SICK_OF_THE_SUN() -> void:
	details.name = "Sick of the Sun"
	set_effect(OldUpgradeEffect.Type.INPUT, 0.9)
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
	details.name = "axman%s by now" % age
	set_effect(OldUpgradeEffect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("1e21"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SICK_OF_THE_SUN


func init_CTHAEH() -> void:
	details.name = "Cthaeh"
	set_effect(OldUpgradeEffect.Type.OUTPUT_AND_INPUT, 10)
	add_affected_lored(LORED.Type.TREES)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new("5e21"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AXMAN13


func init_RED_NECROMANCY() -> void:
	details.name = "[b][color=#ff0000]Red Necromancy[/color][/b]"
	effect = OldUpgradeEffect.new(
		OldUpgradeEffect.Type.UPGRADE_AUTOBUYER,
		{
			"upgrade_type": type,
			"upgrade_menu": UpgradeMenu.Type.MALIGNANT,
		}
	)
	var menu = up.get_upgrade_menu(UpgradeMenu.Type.MALIGNANT)
	details.icon = menu.details.icon
	details.color = menu.details.color
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e24"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THE_WITCH_OF_LOREDELITH


func init_UPGRADE_DESCRIPTION() -> void:
	details.name = "upgrade_description"
	var test = gv.get_stage(2)
	var text = test.details.colored_name
	details.description = "Increases the output and input [b]increase[/b] of " + text + " LOREDs by 10%, but also increases their [b]maximum fuel[/b] and [b]fuel cost[/b] by 1,000%."
	set_effect(OldUpgradeEffect.Type.UPGRADE_NAME)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e24"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TOLKIEN


func init_GRIMOIRE() -> void:
	details.name = "GRIMOIRE"
	var a = up.get_upgrade_name(Type.THE_WITCH_OF_LOREDELITH)
	var b = gv.get_stage(Stage.Type.STAGE1).details.colored_name
	details.description = "%s's buff is boosted based on your %s run count." % [a, b]
	set_effect(OldUpgradeEffect.Type.HASTE, 1)
	details.icon = load("res://Sprites/upgrades/thewitchofloredelith.png")
	details.color = lv.get_color(LORED.Type.WITCH)
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
	effect = OldUpgradeEffect.new(_type, data)


func add_affected_lored(lored: int) -> void:
	loreds.append(lored)
	effect.add_affected_lored(lored)
	await up.all_upgrades_initialized
	lv.get_lored(lored).add_influencing_upgrade(type)


func add_affected_loreds(group: Array) -> void:
	for lored in group:
		add_affected_lored(lored)


func add_effected_stage(_stage: int) -> void:
	add_affected_loreds(lv.get_loreds_in_stage(_stage))
	if details.icon == null:
		details.icon = gv.get_stage(_stage).details.icon
	if details.color == Color(0,0,0):
		details.color = gv.get_stage(_stage).details.color




# - Signal

func required_upgrade_purchased() -> void:
	unlocked.set_to(true)


func required_upgrade_unpurchased() -> void:
	unlocked.set_to(false)


func affordable_changed() -> void:
	if (
		autobuy.is_true()
		and unlocked.is_true()
		and cost.affordable.get_value()
		and cost.is_safe_to_purchase()
	):
		purchase()
	else:
		if (
			unlocked.is_true()
			and purchased.is_false()
			and cost.affordable.get_value()
			and up.is_upgrade_menu_unlocked(upgrade_menu)
		):
			became_affordable_and_unpurchased.emit(type, true)
		else:
			became_affordable_and_unpurchased.emit(type, false)



# - Actions


func update_effected_loreds_text() -> void:
	effected_loreds_text = get_effected_loreds_text()


func purchase() -> void:
	if purchased.is_true() or pending_prestige.is_true():
		return
	cost.purchase(true)
	purchased.set_to(true)
	if special:
		pending_prestige.set_to(true)
	else:
		finalize_purchase()


func finalize_purchase() -> void: # - THIS SHIT aint being called for special upgrades. that's right!
	apply()


func apply() -> void:
	if effect != null:
		effect.apply()
	pending_prestige.set_to(false)
	purchase_finalized.set_to(true)


func refund() -> void:
	if purchased.is_false():
		return
	remove()
	cost.refund()


func remove() -> void:
	if purchased.is_true():
		purchase_finalized.set_to(false)
		if special:
			pending_prestige.set_to(false)
		if effect != null and effect.applied:
			effect.remove()
			effect.reset_effects()
		cost.purchased = false
		purchased.set_to(false)
		reset_effects()



func enable_autobuy() -> void:
	if gv.session_duration.less(1):
		await gv.one_second
	autobuy.set_to(true)


func disable_autobuy() -> void:
	autobuy.set_to(false)



func prestige(_stage: int) -> void:
	if persist.through_stage(_stage):
		if _stage == stage:
			if pending_prestige.is_true():
				finalize_purchase()
			else:
				reset_effects()
	else:
		if pending_prestige.is_true():
			refund()
		else:
			remove()
	


func reset_effects() -> void:
	match type:
		Type.LIMIT_BREAK:
			up.limit_break.reset()
		_:
			if effect != null and effect.dynamic:
				effect.reset_effects()


func reset() -> void:
	remove()
	if effect != null and effect.dynamic:
		effect.reset_effects()
	cost.reset()
	pending_prestige.set_to(false)



# - Get


func get_dynamic_text() -> String:
	match type:
		Upgrade.Type.LIMIT_BREAK:
			return "[center][b]x%s[/b]" % up.limit_break.level.text + effected_loreds_text
		Upgrade.Type.CAPITAL_PUNISHMENT:
			return "[center][b]x%s[/b]" % Big.get_float_text(max(1, gv.stage1.times_reset))
		_:
			return effect.get_dynamic_text()


func get_effect_text() -> String:
	return effect.get_text()


func get_effected_loreds_text() -> String:
	if effected_loreds_text != "":
		return effected_loreds_text
	
	match type:
		Type.LIMIT_BREAK:
			var s1 = gv.stage1.details.color_text % "1"
			var s2 = gv.stage2.details.color_text % "2"
			if up.limit_break.applies_to_stage_3():
				var s3 = gv.stage3.details.color_text % "3"
				if up.limit_break.applies_to_stage_4():
					return "[i]for[/i] All LOREDs"
				return "[i]for[/i] Stages %s, %s, and %s" % [s1, s2, s3]
			return "[i]for[/i] Stages %s and %s" % [s1, s2]
	
	if loreds == lv.get_loreds_in_stage(1):
		var _stage = gv.stage1.details.colored_name
		return "[i]for [/i]" + _stage
	elif loreds == lv.get_loreds_in_stage(2):
		var _stage = gv.stage2.details.colored_name
		return "[i]for [/i]" + _stage
	elif loreds == lv.get_loreds_in_stage(3):
		var _stage = gv.stage3.details.colored_name
		return "[i]for [/i]" + _stage
	elif loreds == lv.get_loreds_in_stage(4):
		var _stage = gv.stage4.details.colored_name
		return "[i]for [/i]" + _stage
	
	if effect != null and effect.type == OldUpgradeEffect.Type.UPGRADE_AUTOBUYER:
		var upmen = up.get_upgrade_menu(effect.upgrade_menu) as UpgradeMenu
		return "[i]for [/i]" + upmen.details.colored_name
	# if loreds.size() > 8: probably a stage.
	var arr := []
	for lored in loreds:
		arr.append(lv.get_colored_name(lored))
	return "[i]for [/i]" + gv.get_list_text_from_array(arr).replace("and", "[i]and[/i]")
