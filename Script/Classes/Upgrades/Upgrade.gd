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
	if purchased:
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
var affected_loreds_text: String
var color_text: String
var colored_name: String
var color: Color
var loreds: Array

var unlocked := Bool.new(true)
var purchased := Bool.new(false)

func unlocked_updated(val: bool) -> void:
	if val:
		affordable_changed(cost.affordable)

func purchased_updated(_val: bool) -> void:
	affordable_changed(cost.affordable)
	upgrade_purchased_changed.emit(self)


var autobuy := false:
	set(val):
		if autobuy != val:
			autobuy = val
			if val:
				became_affordable_and_unpurchased.emit(type, false)
			affordable_changed(cost.affordable)
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
		upgrade.just_purchased.connect(required_upgrade_purchased)
		upgrade.just_unpurchased.connect(required_upgrade_unpurchased)
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
	
	
	var data = db.upgrade[key]
	
	name = data.name
	effect = data.effect
	set_cost(data.cost_key, data.cost_value)
	if "description" in data.keys():
		description = data.description
	if "affected_loreds" in data.keys():
		set_affected_loreds(data.affected_loreds)
	
	
	cost.stage = stage
	cost.affordable_changed.connect(affordable_changed)
	icon_and_name_text = icon_text + " " + name
	
	affected_loreds_text = get_affected_loreds_text()
	
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

	color_text = "[color=#" + color.to_html() + "]%s[/color]"
	colored_name = color_text % name
	
	has_description = description != ""
	
	SaveManager.load_finished.connect(load_finished)





func set_cost(keys, values) -> void:
	var data := {}
	
	if keys is Array:
		for i in keys.size():
			data[LORED.Type[keys[i]]] = Value.new(str(values[i]))
	else:
		data[LORED.Type[keys]] = Value.new(str(values))
	
	cost = Cost.new(data)


func set_affected_loreds(val) -> void:
	if val is Array:
		add_affected_loreds(val)
	elif val is String:
		add_affected_lored(LORED.Type[val])


func add_affected_lored(lored: int) -> void:
	loreds.append(lored)
	effect.add_effected_lored(lored)
	await up.all_upgrades_initialized
	lv.get_lored(lored).add_influencing_upgrade(type)


func add_affected_loreds(group: Array) -> void:
	for lored in group:
		if lored is String:
			lored = LORED.Type[lored]
		add_affected_lored(lored)


func add_affected_stage(_stage: int) -> void:
	add_affected_loreds(lv.get_loreds_in_stage(_stage))
	icon = gv.get_stage(_stage).icon
	color = gv.get_stage(_stage).color




# - Signal

func required_upgrade_purchased() -> void:
	unlocked.set_true()


func required_upgrade_unpurchased() -> void:
	unlocked.set_false()


func affordable_changed(affordable: bool) -> void:
	if autobuy:
		if unlocked and affordable:
			purchase()
	else:
		if (
			unlocked
			and not purchased
			and affordable
		):
			became_affordable_and_unpurchased.emit(type, true)
		else:
			became_affordable_and_unpurchased.emit(type, false)



# - Actions

func purchase() -> void:
	if purchased or will_apply_effect:
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
	if not purchased:
		return
	cost.refund()
	remove()


func remove() -> void:
	if purchased:
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


func get_affected_loreds_text() -> String:
	if affected_loreds_text != "":
		return affected_loreds_text
	
	if loreds == lv.get_loreds_in_stage(1):
		var _stage = gv.stage1.get_colored_name()
		return "[i]for [/i]" + _stage
	elif loreds == lv.get_loreds_in_stage(2):
		var _stage = gv.stage2.get_colored_name()
		return "[i]for [/i]" + _stage
	elif loreds == lv.get_loreds_in_stage(3):
		var _stage = gv.stage3.get_colored_name()
		return "[i]for [/i]" + _stage
	elif loreds == lv.get_loreds_in_stage(4):
		var _stage = gv.stage4.get_colored_name()
		return "[i]for [/i]" + _stage
	
	if effect.type == UpgradeEffect.Type.UPGRADE_AUTOBUYER:
		var upmen = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL) as UpgradeMenu
		var text = upmen.color_text % (upmen.name)
		return "[i]for [/i]" + text
	# if loreds.size() > 8: probably a stage.
	var arr := []
	for lored in loreds:
		arr.append(lv.get_lored(lored).colored_name)
	return "[i]for [/i]" + gv.get_list_text_from_array(arr).replace("and", "[i]and[/i]")
