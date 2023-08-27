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
		emit_signal("just_unlocked")



enum Type {
	MECHANICAL, # S2 M
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
	
	CANOPY, # S2 N
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


class Effect:
	
	var saved_vars := [
		"applied",
	]
	
	
	func load_started() -> void:
		remove()
	
	
	func load_finished() -> void:
		if applied:
			applied = false
			apply()
	
	
	enum Type {
		HASTE,
		OUTPUT_AND_INPUT,
		SPECIFIC_INPUT,
		SPECIFIC_COST,
		COST,
		INPUT,
		CRIT,
		FUEL,
		FUEL_COST,
		ITS_GROWIN_ON_ME,
		I_DRINK_YOUR_MILKSHAKE,
		THE_THIRD,
		I_RUN,
		WAIT_THATS_NOT_FAIR,
		AUTOBUYER,
		UPGRADE_AUTOBUYER,
		FREE_LORED,
		UPGRADE_NAME,
	}
	
	var type: int
	var key: String
	var text: String
	
	var applied := false
	var dynamic := false
	
	var effect: Value
	var in_hand: Big
	
	var effect2: Value
	var in_hand2: Big
	
	var apply_methods: Array
	var remove_methods: Array
	
	var effected_input: int
	
	
	
	func _init(_type: int, details: Dictionary) -> void:
		type = _type
		key = Type.keys()[type]
		
		if "effect value" in details.keys():
			effect = Value.new(details["effect value"])
		if "effected_input" in details.keys():
			effected_input = details["effected_input"]
		
		if type == Type.ITS_GROWIN_ON_ME:
			effect2 = Value.new(details["effect value"])
		
		dynamic = type in [
			Type.ITS_GROWIN_ON_ME,
			Type.I_DRINK_YOUR_MILKSHAKE,
		]
		if dynamic:
			saved_vars.append("effect")
			if effect2 != null:
				saved_vars.append("effect2")
		
		set_base_text()
		
		SaveManager.connect("load_started", load_started)
		SaveManager.connect("load_finished", load_finished)
	
	
	
	func set_base_text() -> void:
		match type:
			Type.COST:
				text = "Cost [b]x"
			Type.SPECIFIC_INPUT:
				text = wa.get_currency_name(effected_input) + " Input [b]x"
			Type.SPECIFIC_COST:
				text = wa.get_currency_name(effected_input) + " Cost [b]x"
			Type.FUEL:
				text = "Max Fuel [b]x"
			Type.OUTPUT_AND_INPUT:
				text = "Output and Input [b]x"
			Type.AUTOBUYER, Type.UPGRADE_AUTOBUYER:
				text = "Autobuyer"
			Type.CRIT:
				text = "Crit chance [b]+"
			_:
				text = key.replace("_", " ").capitalize() + " [b]x"
	
	
	
	# - Signal
	
	func growth_spawned(amount: Big) -> void:
		if applied:
			var increase = Big.new(amount).m(0.05)
			if randi() % 2 == 0:
				effect.add(increase)
			else:
				effect2.add(increase)
	
	
	func coal_taken(amount: Big) -> void:
		if applied:
			var increase = Big.new(amount).m(0.01)
			effect.add(increase)
	
	
	func copo_mined(amount: Big) -> void:
		wa.add(Currency.Type.COPPER, amount)
	
	
	func irono_mined(amount: Big) -> void:
		wa.add(Currency.Type.IRON, amount)
	
	
	func coal_dug(amount: Big) -> void:
		wa.add(Currency.Type.STONE, amount)
	
	
	
	# - Actions
	
	func add_effected_lored(lored_type: int) -> void:
		var lored = lv.get_lored(lored_type) as LORED
		match type:
			Type.COST:
				for cur in lored.cost.cost:
					apply_methods.append(
						lored.cost.cost[cur].increase_multiplied
					)
					remove_methods.append(
						lored.cost.cost[cur].decrease_multiplied
					)
			Type.FREE_LORED:
				apply_methods.append(lored.enable_default_purchase)
				remove_methods.append(lored.disable_default_purchase)
			Type.AUTOBUYER:
				apply_methods.append(lored.enable_autobuy)
				remove_methods.append(lored.disable_autobuy)
			Type.SPECIFIC_INPUT:
				for att in lored.get_attributes_by_currency(effected_input):
					apply_methods.append(att.increase_multiplied)
					remove_methods.append(att.decrease_multiplied)
			Type.SPECIFIC_COST:
				apply_methods.append(
					lored.cost.cost[effected_input].increase_multiplied
				)
				remove_methods.append(
					lored.cost.cost[effected_input].decrease_multiplied
				)
			Type.HASTE:
				apply_methods.append(lored.haste.increase_multiplied)
				remove_methods.append(lored.haste.decrease_multiplied)
			Type.OUTPUT_AND_INPUT:
				apply_methods.append(lored.output.increase_multiplied)
				apply_methods.append(lored.input.increase_multiplied)
				remove_methods.append(lored.output.decrease_multiplied)
				remove_methods.append(lored.input.decrease_multiplied)
			Type.INPUT:
				apply_methods.append(lored.input.increase_multiplied)
				remove_methods.append(lored.input.decrease_multiplied)
			Type.CRIT:
				apply_methods.append(lored.crit.increase_added)
				remove_methods.append(lored.crit.decrease_added)
			Type.FUEL:
				apply_methods.append(lored.fuel.increase_multiplied)
				remove_methods.append(lored.fuel.decrease_multiplied)
			Type.FUEL_COST:
				apply_methods.append(lored.fuel_cost.increase_multiplied)
				remove_methods.append(lored.fuel_cost.decrease_multiplied)
	
	
	func apply() -> void:
		if not applied:
			
			if effect != null:
				effect.changed.connect(refresh)
			
			match type:
				Type.WAIT_THATS_NOT_FAIR:
					var cur = wa.get_currency(Currency.Type.COAL)
					cur.increased_by_lored.connect(coal_dug)
				Type.I_RUN:
					var irono = wa.get_currency(Currency.Type.IRON_ORE)
					irono.increased_by_lored.connect(irono_mined)
				Type.THE_THIRD:
					var copo = wa.get_currency(Currency.Type.COPPER_ORE)
					copo.increased_by_lored.connect(copo_mined)
				Type.I_DRINK_YOUR_MILKSHAKE:
					var coal = wa.get_currency(Currency.Type.COAL)
					coal.decreased_by_lored.connect(coal_taken)
				Type.ITS_GROWIN_ON_ME:
					effect2.changed.connect(refresh)
					var growth = wa.get_currency(Currency.Type.GROWTH)
					growth.increased_by_lored.connect(growth_spawned)
				Type.UPGRADE_NAME:
					for lored in gv.get_loreds_in_stage(1):
						lored = lored as LORED
						lored.cost_increase.increase_multiplied(0.9)
						lored.fuel_cost.increase_multiplied(10)
						lored.fuel.increase_multiplied(10)
			refresh()
	
	
	func remove() -> void:
		if applied:
			effect.changed.disconnect(refresh)
			
			match type:
				Type.WAIT_THATS_NOT_FAIR:
					var cur = wa.get_currency(Currency.Type.COAL)
					cur.increased_by_lored.disconnect(coal_dug)
				Type.I_RUN:
					var irono = wa.get_currency(Currency.Type.IRON_ORE)
					irono.increased_by_lored.disconnect(irono_mined)
				Type.THE_THIRD:
					var copo = wa.get_currency(Currency.Type.COPPER_ORE)
					copo.increased_by_lored.disconnect(copo_mined)
				Type.I_DRINK_YOUR_MILKSHAKE:
					var coal = wa.get_currency(Currency.Type.COAL)
					coal.decreased_by_lored.disconnect(coal_taken)
				Type.ITS_GROWIN_ON_ME:
					effect2.changed.disconnect(refresh)
					var growth = wa.get_currency(Currency.Type.GROWTH)
					growth.increased_by_lored.disconnect(growth_spawned)
				Type.UPGRADE_NAME:
					for lored in gv.get_loreds_in_stage(1):
						lored = lored as LORED
						lored.cost_increase.decrease_multiplied(0.9)
						lored.fuel_cost.decrease_multiplied(10)
						lored.fuel.decrease_multiplied(10)
			remove_effects()
	
	
	func refresh() -> void:
		remove_effects()
		apply_effects()
	
	
	func apply_effects() -> void:
		if not applied:
			applied = true
			if effect != null:
				in_hand = Big.new(effect.get_value())
			match type:
				Type.I_DRINK_YOUR_MILKSHAKE:
					var coal := lv.get_lored(LORED.Type.COAL)
					coal.output.increase_multiplied(in_hand)
				Type.ITS_GROWIN_ON_ME:
					in_hand2 = Big.new(effect2.get_value())
					var iron := lv.get_lored(LORED.Type.IRON)
					var copper := lv.get_lored(LORED.Type.COPPER)
					iron.output.increase_multiplied(in_hand)
					iron.input.increase_multiplied(in_hand)
					copper.output.increase_multiplied(in_hand2)
					copper.input.increase_multiplied(in_hand2)
				Type.AUTOBUYER, Type.FREE_LORED:
					for method in apply_methods:
						method.call()
				_:
					for method in apply_methods:
						method.call(in_hand)
	
	
	func remove_effects() -> void:
		if applied:
			applied = false
			match type:
				Type.I_DRINK_YOUR_MILKSHAKE:
					var coal := lv.get_lored(LORED.Type.COAL)
					coal.output.decrease_multiplied(in_hand)
				Type.ITS_GROWIN_ON_ME:
					var iron := lv.get_lored(LORED.Type.IRON)
					var copper := lv.get_lored(LORED.Type.COPPER)
					iron.output.decrease_multiplied(in_hand)
					iron.input.decrease_multiplied(in_hand)
					copper.output.decrease_multiplied(in_hand2)
					copper.input.decrease_multiplied(in_hand2)
				Type.AUTOBUYER, Type.FREE_LORED:
					for method in remove_methods:
						method.call()
				_:
					for method in remove_methods:
						method.call(in_hand)
			
			if effect != null:
				effect.reset()
			if effect2 != null:
				effect2.reset()
	
	
	# - Get
	
	func get_text() -> String:
		if effect == null:
			return text
		if type == Type.CRIT:
			return text + effect.get_text() + "%"
		return text + effect.get_text()



signal just_unlocked
signal just_locked
signal unlocked_changed
signal just_purchased
signal just_unpurchased
signal purchased_changed(upgrade)
signal just_reset

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
var color: Color
var loreds: Array
var effected_loreds_text: String

var unlocked := true:
	set(val):
		unlocked = val
		emit_signal("unlocked_changed")
		if val:
			emit_signal("just_unlocked")
		else:
			emit_signal("just_locked")

var special: bool

var purchased := false:
	set(val):
		if purchased != val:
			purchased = val
			if val:
				emit_signal("just_purchased")
			else:
				just_unpurchased.emit()
			emit_signal("purchased_changed", self)

var will_apply_effect := false

var has_vico := false
var vico: UpgradeVico:
	set(val):
		vico = val
		has_vico = true

var effect: Effect

var has_required_upgrade := false
var required_upgrade: int:
	set(val):
		has_required_upgrade = true
		required_upgrade = val
		var upgrade = up.get_upgrade(required_upgrade)
		upgrade.just_purchased.connect(required_upgrade_purchased)
		upgrade.just_unpurchased.connect(required_upgrade_unpurchased)
		unlocked = up.is_upgrade_purchased(required_upgrade)

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
	set_effect(Effect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.STONE: Value.new(90),
	})


func init_LIGHTER_SHOVEL() -> void:
	name = "Lighter Shovel"
	set_effect(Effect.Type.HASTE, 1.2)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new(155),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_TEXAS() -> void:
	name = "TEXAS"
	set_effect(Effect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(30),
		Currency.Type.COPPER: Value.new(400),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_RYE() -> void:
	name = "RYE"
	set_effect(Effect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(3),
		Currency.Type.IRON: Value.new(100),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_GRANDER() -> void:
	name = "GRANDER"
	set_effect(Effect.Type.HASTE, 1.3)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.COAL: Value.new(400),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRINDER


func init_SAALNDT() -> void:
	name = "SAALNDT"
	set_effect(Effect.Type.HASTE, 1.5)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(150),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TEXAS


func init_SAND() -> void:
	name = "SAND"
	set_effect(Effect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(200),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_GRANDMA() -> void:
	name = "Grandma"
	set_effect(Effect.Type.HASTE, 1.3)
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
	set_effect(Effect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.CONCRETE: Value.new(11),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_FLANK() -> void:
	name = "FLANK"
	set_effect(Effect.Type.HASTE, 1.4)
	add_effected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(125),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SALT


func init_RIB() -> void:
	name = "RIB"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.4)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(125),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SALT


func init_GRANDPA() -> void:
	name = "Grandpa"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.35)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(2500),
		Currency.Type.COPPER: Value.new(2500),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRANDMA


func init_WATT() -> void:
	name = "Watt?"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.45)
	add_effected_lored(LORED.Type.JOULES)
	cost = Cost.new({
		Currency.Type.IRON: Value.new(3500),
		Currency.Type.COPPER: Value.new(3500),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MIXER


func init_SWIRLER() -> void:
	name = "SWIRLER"
	set_effect(Effect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.COAL: Value.new(9500),
		Currency.Type.STONE: Value.new(6000),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MIXER


func init_GEARED_OILS() -> void:
	name = "Geared Oils"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 2.0)
	add_effected_lored(LORED.Type.OIL)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("6e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CHEEKS


func init_CHEEKS() -> void:
	name = "Cheeks"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.5)
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
	set_effect(Effect.Type.HASTE, 1.35)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(100),
		Currency.Type.JOULES: Value.new(100),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.GRANDPA


func init_MAXER() -> void:
	name = "MAXER"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.4)
	add_effected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(400),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SWIRLER


func init_THYME() -> void:
	name = "THYME"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.75)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 10)
	add_effected_lored(LORED.Type.IRON_ORE)
	cost = Cost.new({
		Currency.Type.COPPER: Value.new("25e9"),
		Currency.Type.MALIGNANCY: Value.new("15e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ANCHOVE_COVE


func init_ANCHOVE_COVE() -> void:
	name = "Anchove Cove"
	set_effect(Effect.Type.HASTE, 2)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 10)
	add_effected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("25e9"),
		Currency.Type.MALIGNANCY: Value.new("15e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ANCHOVE_COVE


func init_MUD() -> void:
	name = "MUD"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.75)
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
	set_effect(Effect.Type.HASTE, 1.95)
	add_effected_lored(LORED.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.STONE: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SLIMER


func init_SLIMER() -> void:
	name = "SLIMER"
	set_effect(Effect.Type.HASTE, 1.5)
	add_effected_lored(LORED.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(150),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RYE


func init_STICKYTAR() -> void:
	name = "Sticktar"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.5, Currency.Type.TARBALLS)
	add_effected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.GROWTH: Value.new(1400),
		Currency.Type.OIL: Value.new(75),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SLIMER


func init_INJECT() -> void:
	name = "INJECT"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_lored(LORED.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.TUMORS: Value.new(100),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STICKYTAR


func init_RED_GOOPY_BOY() -> void:
	name = "Red Goopy Boy"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.4)
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
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(1500),
	})


func init_SOCCER_DUDE() -> void:
	name = "Soccer Dude"
	set_effect(Effect.Type.HASTE, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(1600),
	})


func init_AW() -> void:
	name = "aw <3"
	var loredy = lv.get_colored_name(LORED.Type.COAL)
	description = "Start the run with " + loredy + " already purchased!"
	set_effect(Effect.Type.FREE_LORED)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(2),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ENTHUSIASM


func init_ENTHUSIASM() -> void:
	name = "Enthusiasm"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("3000"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSHOVELER


func init_CON_FRICKIN_CRETE() -> void:
	name = "CON-FRICKIN-CRETE"
	set_effect(Effect.Type.SPECIFIC_COST, 0.5, Currency.Type.CONCRETE)
	add_effected_lored(LORED.Type.OIL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("12e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSHOVELER


func init_HOW_IS_THIS_AN_RPG() -> void:
	name = "how is this an RPG anyway?"
	set_effect(Effect.Type.CRIT, 5)
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
	set_effect(Effect.Type.ITS_GROWIN_ON_ME, 1)
	add_effected_lored(LORED.Type.IRON)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("2e3"),
	})


func init_AUTOSTONER() -> void:
	name = "Auto-Stoner"
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.STONE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("35e3"),
	})


func init_OREOREUHBOREALICE() -> void:
	name = "OREOREUHBor [i]E[/i] ALICE"
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.IRON_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("12e3"),
	})


func init_YOU_LITTLE_HARD_WORKER_YOU() -> void:
	name = "you little hard worker, you"
	set_effect(Effect.Type.HASTE, 2)
	add_effected_lored(LORED.Type.STONE)
	add_effected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("40e3"),
	})


func init_COMPULSORY_JUICE() -> void:
	name = "Compulsory Juice"
	set_effect(Effect.Type.COST, 0.5)
	add_effected_lored(LORED.Type.IRON_ORE)
	add_effected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("50e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.AUTOSTONER


func init_BIG_TOUGH_BOY() -> void:
	name = "[b]Big Tough Boy[/b]"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("175e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HOW_IS_THIS_AN_RPG


func init_STAY_QUENCHED() -> void:
	name = "Stay Quenched!"
	set_effect(Effect.Type.HASTE, 1.8)
	add_effected_lored(LORED.Type.COAL)
	add_effected_lored(LORED.Type.JOULES)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("60e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.YOU_LITTLE_HARD_WORKER_YOU


func init_OH_BABY_A_TRIPLE() -> void:
	name = "OH, BABY, A TRIPLE"
	set_effect(Effect.Type.HASTE, 3)
	add_effected_lored(LORED.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("55e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.YOU_LITTLE_HARD_WORKER_YOU


func init_AUTOPOLICE() -> void:
	name = "Auto-Police"
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("140e3"),
	})


func init_PIPPENPADDLE_OPPSOCOPOLIS() -> void:
	name = "pippenpaddle-oppso[b]COP[/b]olis"
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.COPPER_ORE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("600e3"),
	})


func init_I_DRINK_YOUR_MILKSHAKE() -> void:
	name = "I DRINK YOUR MILKSHAKE"
	var coal = wa.get_icon_and_name_text(Currency.Type.COAL)
	var coal2 = lv.get_colored_name(LORED.Type.COAL)
	description = "Whenever a LORED takes %s, %s gets an output boost." % [coal, coal2]
	set_effect(Effect.Type.I_DRINK_YOUR_MILKSHAKE, 1)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("800e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STAY_QUENCHED


func init_ORE_LORD() -> void:
	name = "Ore Lord"
	set_effect(Effect.Type.HASTE, 2)
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
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.GROWTH)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("12e6"),
	})


func init_THE_THIRD() -> void:
	name = "The Third"
	var cop = wa.get_icon_and_name_text(Currency.Type.COPPER)
	var copo = lv.get_colored_name(LORED.Type.COPPER_ORE)
	description = "Whenever %s mines, he will produce an equal amount of %s." % [copo, cop]
	set_effect(Effect.Type.THE_THIRD)
	add_effected_lored(LORED.Type.COPPER_ORE)
	add_effected_lored(LORED.Type.COPPER)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("2e8"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PIPPENPADDLE_OPPSOCOPOLIS


func init_WE_WERE_SO_CLOSE() -> void:
	name = "we were so close, now you don't even think about me"
	set_effect(Effect.Type.UPGRADE_AUTOBUYER, 1, UpgradeMenu.Type.NORMAL)
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
	var text = test.get_colored_name()
	description = "Reduces the cost increase of " + text + " LOREDs by 10%, but increases [b]maximum fuel[/b] and [b]fuel cost[/b] by 1,000%."
	set_effect(Effect.Type.UPGRADE_NAME)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ORE_LORD


func init_WTF_IS_THAT_MUSK() -> void:
	name = "wtf is that musk"
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.JOULES)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("43e7"),
	})


func init_CANCERS_COOL() -> void:
	name = "CANCER'S COOL"
	set_effect(Effect.Type.HASTE, 2)
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
	set_effect(Effect.Type.I_RUN)
	add_effected_lored(LORED.Type.IRON_ORE)
	add_effected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("25e9"),
	})


func init_COAL_DUDE() -> void:
	name = "[img=<15>]res://Sprites/Currency/coal.png[/img] Coal Dude"
	set_effect(Effect.Type.HASTE, 2)
	add_effected_lored(LORED.Type.COAL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e11"),
	})


func init_CANKERITE() -> void:
	name = "CANKERITE"
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.CONCRETE)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("15e9"),
	})


func init_SENTIENT_DERRICK() -> void:
	name = "Sentient Derrick"
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.OIL)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("85e10"),
	})


func init_SLAPAPOW() -> void:
	name = "SLAPAPOW!"
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.TARBALLS)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("17e11"),
	})


func init_SIDIUS_IRON() -> void:
	name = "Sidius Iron"
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.IRON)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("8e12"),
	})


func init_MOUND() -> void:
	name = "Mound"
	set_effect(Effect.Type.AUTOBUYER)
	add_effected_lored(LORED.Type.MALIGNANCY)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("35e12"),
	})


func init_FOOD_TRUCKS() -> void:
	name = "Food Trucks"
	set_effect(Effect.Type.COST, 0.5)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e13"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UPGRADE_NAME


func init_OPPAI_GUY() -> void:
	name = "Oppai Guy"
	set_effect(Effect.Type.HASTE, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e15"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.FOOD_TRUCKS


func init_MALEVOLENT() -> void:
	name = "Malevolent"
	set_effect(Effect.Type.HASTE, 4)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e16"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.OPPAI_GUY


func init_THIS_GAME_IS_SO_ESEY() -> void:
	name = "This game is SO ESEY"
	set_effect(Effect.Type.CRIT, 5)
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
	set_effect(Effect.Type.WAIT_THATS_NOT_FAIR)
	add_effected_lored(LORED.Type.COAL)
	add_effected_lored(LORED.Type.STONE)
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
	set_effect(Effect.Type.WAIT_THATS_NOT_FAIR)
	add_effected_lored(LORED.Type.COAL)
	add_effected_lored(LORED.Type.STONE)
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
	description = "%s immediately. %s upgrades will persist through %s. After that, this upgrade will be reset." % [metas, norm, meta2]
	set_effect(Effect.Type.WAIT_THATS_NOT_FAIR)
	icon = preload("res://Sprites/Hud/Tab/s1m.png")
	color = gv.get_stage_color(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e20"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RED_NECROMANCY





func set_effect(_type: int, base_value := -1.0, effected_input = -1) -> void:
	var data := {}
	if base_value != -1 and _type != Effect.Type.UPGRADE_AUTOBUYER:
		data["effect value"] = base_value
	if effected_input != -1:
		data["effected_input"] = effected_input
	effect = Effect.new(_type, data)


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
	icon = gv.get_stage(_stage).icon
	color = gv.get_stage(_stage).color




# - Signal

func required_upgrade_purchased() -> void:
	unlocked = true


func required_upgrade_unpurchased() -> void:
	unlocked = false



# - Actions

func purchase() -> void:
	if purchased or will_apply_effect:
		return
	cost.purchase(true)
	purchased = true
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
		purchased = false



func prestige(_stage: int) -> void:
	if _stage == stage:
		if will_apply_effect:
			apply()
		elif not special:
			remove()
	elif _stage > stage:
		remove()



func reset() -> void:
	remove()
	times_purchased = 0
	will_apply_effect = false



# - Get

func get_effect_text() -> String:
	return effect.get_text()


func get_effected_loreds_text() -> String:
	if effected_loreds_text != "":
		return effected_loreds_text
	
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
	
	if effect.type == Effect.Type.UPGRADE_AUTOBUYER:
		var upmen = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL) as UpgradeMenu
		var text = upmen.color_text % (upmen.name)
		return "[i]for [/i]" + text
	# if loreds.size() > 8: probably a stage.
	var arr := []
	for lored in loreds:
		arr.append(lv.get_lored(lored).colored_name)
	return "[i]for [/i]" + gv.get_list_text_from_array(arr).replace("and", "[i]and[/i]")
