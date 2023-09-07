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
		BONUS_ACTION_ON_CURRENCY_GAIN,
		BONUS_ACTION_ON_CURRENCY_USE,
		BONUS_JOB_PRODUCTION,
		AUTOBUYER,
		UPGRADE_AUTOBUYER,
		FREE_LORED,
		UPGRADE_NAME,
	}
	
	enum BONUS_ACTION {
		ADD_CURRENCY,
		INCREASE_EFFECT,
		INCREASE_EFFECT1_OR_2,
	}
	
	var type: int
	var key: String
	var text: String
	
	var upgrade_type: int
	
	var applied := false
	var dynamic := false
	
	var effect: Value
	var in_hand: Big
	
	var effect2: Value
	var in_hand2: Big
	
	var apply_methods: Array
	var remove_methods: Array
	
	var effected_input: int
	var currency: int
	
	var bonus_action_type: int
	var modifier := 1.0
	var added_currency: int
	var upgrade_menu: int
	var job: int
	
	
	
	func _init(_type: int, details: Dictionary) -> void:
		type = _type
		key = Type.keys()[type]
		upgrade_type = details["upgrade_type"]
		if "effect value" in details.keys():
			effect = Value.new(details["effect value"])
		if "effect value2" in details.keys():
			effect2 = Value.new(details["effect value2"])
		if "effected_input" in details.keys():
			effected_input = details["effected_input"]
		if "currency" in details.keys():
			currency = details["currency"]
		if "bonus_action_type" in details.keys():
			bonus_action_type = details["bonus_action_type"]
		if "modifier" in details.keys():
			modifier = details["modifier"]
		if "added_currency" in details.keys():
			added_currency = details["added_currency"]
		if "upgrade_menu" in details.keys():
			upgrade_menu = details["upgrade_menu"]
		if "job" in details.keys():
			job = details["job"]
		
		set_base_text()
		
		SaveManager.connect("load_started", load_started)
		SaveManager.connect("load_finished", load_finished)
		
		if type in [
			Type.UPGRADE_AUTOBUYER,
			#Type.UPGRADE_NAME,
		]:
			up.all_upgrades_initialized.connect(finish_init)
	
	
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
	
	
	func set_dynamic(val: bool) -> void:
		dynamic = val
		if val:
			saved_vars.append("effect")
			if effect2 != null:
				saved_vars.append("effect2")
	
	
	func finish_init() -> void:
		match type:
			Type.UPGRADE_AUTOBUYER:
				for type in up.get_upgrades_in_menu(upgrade_menu):
					var upgrade = up.get_upgrade(type)
					apply_methods.append(upgrade.enable_autobuy)
					remove_methods.append(upgrade.disable_autobuy)
		
	
	
	# - Signal
	
	func currency_collected(amount: Big) -> void:
		var modded_amount = Big.new(amount).m(modifier).m(wa.get_currency(currency).last_crit_modifier)
		match bonus_action_type:
			BONUS_ACTION.ADD_CURRENCY:
				wa.add(added_currency, modded_amount)
			BONUS_ACTION.INCREASE_EFFECT:
				effect.add(modded_amount)
				effect.sync()
			BONUS_ACTION.INCREASE_EFFECT1_OR_2:
				if randi() % 2 == 0:
					effect.add(modded_amount)
					effect.sync()
				else:
					effect2.add(modded_amount)
					effect2.sync()
	
	
	func currency_used(amount: Big) -> void:
		var modded_amount = Big.new(amount).m(modifier)
		match bonus_action_type:
			BONUS_ACTION.ADD_CURRENCY:
				wa.add(added_currency, modded_amount)
			BONUS_ACTION.INCREASE_EFFECT:
				effect.add(modded_amount)
			BONUS_ACTION.INCREASE_EFFECT1_OR_2:
				if randi() % 2 == 0:
					effect.add(modded_amount)
				else:
					effect2.add(modded_amount)
	
	
	func reset_effects() -> void:
		var was_applied = applied
		if was_applied:
			remove()
		effect.reset()
		if effect2 != null:
			effect2.reset()
		if was_applied:
			apply()
	
	
	
	# - Actions
	
	func add_effected_lored(lored_type: int) -> void:
		var lored = lv.get_lored(lored_type) as LORED
		match type:
			Type.BONUS_JOB_PRODUCTION:
				var _job = lored.get_job(job) as Job
				apply_methods.append(_job.add_bonus_production)
				remove_methods.append(_job.remove_bonus_production)
			Type.COST:
				for cur in lored.cost.cost:
					apply_methods.append(
						lored.cost.cost[cur].increase_multiplied
					)
					remove_methods.append(
						lored.cost.cost[cur].decrease_multiplied
					)
			Type.FREE_LORED:
				apply_methods.append(lored.enable_purchased_on_reset)
				remove_methods.append(lored.disable_purchased_on_reset)
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
				effect.increased.connect(refresh)
			if effect2 != null:
				effect2.increased.connect(refresh)
			
			match type:
				Type.BONUS_ACTION_ON_CURRENCY_GAIN:
					var cur = wa.get_currency(currency)
					cur.increased_by_lored.connect(currency_collected)
				Type.BONUS_ACTION_ON_CURRENCY_USE:
					var cur = wa.get_currency(currency)
					cur.decreased_by_lored.connect(currency_used)
				Type.UPGRADE_NAME:
					for x in gv.get_loreds_in_stage(1):
						var lored = lv.get_lored(x)
						lored.cost_increase.increase_multiplied(0.9)
						lored.fuel_cost.increase_multiplied(10)
						lored.fuel.increase_multiplied(10)
						lored.fuel.fill_up()
			refresh()
	
	
	func remove() -> void:
		if applied:
			if effect != null:
				effect.increased.disconnect(refresh)
			if effect2 != null:
				effect2.increased.disconnect(refresh)
			
			match type:
				Type.BONUS_ACTION_ON_CURRENCY_GAIN:
					var cur = wa.get_currency(currency)
					cur.increased_by_lored.disconnect(currency_collected)
				Type.BONUS_ACTION_ON_CURRENCY_USE:
					var cur = wa.get_currency(currency)
					cur.decreased_by_lored.disconnect(currency_used)
				Type.UPGRADE_NAME:
					for x in gv.get_loreds_in_stage(1):
						var lored = lv.get_lored(x)
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
			if effect2 != null:
				in_hand2 = Big.new(effect2.get_value())
			match type:
				Type.BONUS_ACTION_ON_CURRENCY_GAIN:
					match upgrade_type:
						Upgrade.Type.ITS_GROWIN_ON_ME:
							var iron := lv.get_lored(LORED.Type.IRON)
							var copper := lv.get_lored(LORED.Type.COPPER)
							iron.output.increase_multiplied(in_hand)
							iron.input.increase_multiplied(in_hand)
							copper.output.increase_multiplied(in_hand2)
							copper.input.increase_multiplied(in_hand2)
				Type.BONUS_ACTION_ON_CURRENCY_USE:
					match upgrade_type:
						Upgrade.Type.I_DRINK_YOUR_MILKSHAKE:
							var coal := lv.get_lored(LORED.Type.COAL)
							coal.output.increase_multiplied(in_hand)
				Type.BONUS_JOB_PRODUCTION:
					for method in apply_methods:
						method.call(currency, modifier)
				Type.AUTOBUYER, Type.UPGRADE_AUTOBUYER, Type.FREE_LORED:
					for method in apply_methods:
						method.call()
				_:
					for method in apply_methods:
						method.call(in_hand)
	
	
	func remove_effects() -> void:
		if applied:
			applied = false
			match type:
				Type.BONUS_ACTION_ON_CURRENCY_GAIN:
					match upgrade_type:
						Upgrade.Type.ITS_GROWIN_ON_ME:
							var iron := lv.get_lored(LORED.Type.IRON)
							var copper := lv.get_lored(LORED.Type.COPPER)
							iron.output.decrease_multiplied(in_hand)
							iron.input.decrease_multiplied(in_hand)
							copper.output.decrease_multiplied(in_hand2)
							copper.input.decrease_multiplied(in_hand2)
				Type.BONUS_ACTION_ON_CURRENCY_USE:
					match upgrade_type:
						Upgrade.Type.I_DRINK_YOUR_MILKSHAKE:
							var coal := lv.get_lored(LORED.Type.COAL)
							coal.output.decrease_multiplied(in_hand)
				Type.BONUS_JOB_PRODUCTION:
					for method in remove_methods:
						method.call(currency)
				Type.AUTOBUYER, Type.FREE_LORED:
					for method in remove_methods:
						method.call()
				_:
					for method in remove_methods:
						method.call(in_hand)
	
	
	# - Get
	
	func get_text() -> String:
		if effect == null:
			return text
		if type == Type.CRIT:
			return text + effect.get_text() + "%"
		return text + effect.get_text()
	
	
	func get_effect_text() -> String:
		return effect.get_text()
	
	
	func get_effect2_text() -> String:
		return effect2.get_text()



signal just_unlocked
signal just_locked
signal unlocked_changed
signal just_purchased
signal just_unpurchased
signal purchased_changed(upgrade)
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

var unlocked := true:
	set(val):
		unlocked = val
		emit_signal("unlocked_changed")
		if val:
			emit_signal("just_unlocked")
			affordable_changed(cost.affordable)
		else:
			emit_signal("just_locked")


var autobuy := false:
	set(val):
		if autobuy != val:
			autobuy = val
			if val:
				became_affordable_and_unpurchased.emit(type, false)
			affordable_changed(cost.affordable)
			autobuy_changed.emit()


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
			affordable_changed(cost.affordable)

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
	cost.affordable_changed.connect(affordable_changed)
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
	icon = wa.get_icon(Currency.Type.GROWTH)
	color = lv.get_color(LORED.Type.GROWTH)
	effect = Effect.new(
		Effect.Type.BONUS_ACTION_ON_CURRENCY_GAIN,
		{
			"upgrade_type": type,
			"currency": Currency.Type.GROWTH,
			"effect value": 1,
			"effect value2": 1,
			"bonus_action_type": Effect.BONUS_ACTION.INCREASE_EFFECT1_OR_2,
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
	effect = Effect.new(
		Effect.Type.BONUS_ACTION_ON_CURRENCY_USE,
		{
			"upgrade_type": type,
			"currency": Currency.Type.COAL,
			"effect value": 1,
			"bonus_action_type": Effect.BONUS_ACTION.INCREASE_EFFECT,
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
	effect = Effect.new(
		Effect.Type.BONUS_JOB_PRODUCTION,
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
	effect = Effect.new(
		Effect.Type.UPGRADE_AUTOBUYER,
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
	effect = Effect.new(
		Effect.Type.BONUS_JOB_PRODUCTION,
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
	effect = Effect.new(
		Effect.Type.BONUS_JOB_PRODUCTION,
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
	set_effect(Effect.Type.HASTE, 1)
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
	set_effect(Effect.Type.HASTE, 1)
	icon = preload("res://Sprites/Hud/Tab/s1m.png")
	color = gv.get_stage_color(1)
	cost = Cost.new({
		Currency.Type.MALIGNANCY: Value.new("1e20"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RED_NECROMANCY


func init_CANOPY() -> void:
	name = "Canopy"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.TREES: Value.new("10"),
	})


func init_APPRENTICE_IRON_WORKER() -> void:
	name = "Apprentice Iron Worker"
	set_effect(Effect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("25"),
	})


func init_DOUBLE_BARRELS() -> void:
	name = "Double Barrels"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("50"),
		Currency.Type.HARDWOOD: Value.new("100"),
	})


func init_RAIN_DANCE() -> void:
	name = "Rain Dance"
	set_effect(Effect.Type.HASTE, 1.2)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.SAND: Value.new("40"),
	})


func init_LIGHTHOUSE() -> void:
	name = "Lighthouse"
	set_effect(Effect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("130"),
	})


func init_ROGUE_BLACKSMITH() -> void:
	name = "Rogue Blacksmith"
	set_effect(Effect.Type.CRIT, 6)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 2)
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
	set_effect(Effect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.LIQUID_IRON: Value.new("30"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.RAIN_DANCE


func init_THIS_MIGHT_PAY_OFF_SOMEDAY() -> void:
	name = "This might pay off someday!"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.IRON)
	add_effected_lored(LORED.Type.LIQUID_IRON)
	cost = Cost.new({
		Currency.Type.IRON: Value.new("1e6"),
	})


func init_DIRT_COLLECTION_REWARDS_PROGRAM() -> void:
	name = "*Dirt Collection Rewards Program!*"
	set_effect(Effect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.SOIL: Value.new("25e3"),
		Currency.Type.LEAD: Value.new("25e3"),
		Currency.Type.CARCINOGENS: Value.new("350"),
	})


func init_EQUINE() -> void:
	name = "[b]Equine[/b]"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("90"),
	})


func init_UNPREDICTABLE_WEATHER() -> void:
	name = "Unpredictable Weather"
	set_effect(Effect.Type.CRIT, 8)
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
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.AXES)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("350"),
		Currency.Type.GLASS: Value.new("425"),
		Currency.Type.SOIL: Value.new("500"),
	})


func init_SOFT_AND_SMOOTH() -> void:
	name = "Decisive Strikes"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("4500"),
		Currency.Type.CARCINOGENS: Value.new("900"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UNPREDICTABLE_WEATHER


func init_FLIPPY_FLOPPIES() -> void:
	name = "Flippy Floppies"
	set_effect(Effect.Type.SPECIFIC_COST, 0.9, Currency.Type.HUMUS)
	add_effected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("850"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.UNPREDICTABLE_WEATHER


func init_WOODTHIRSTY() -> void:
	name = "Woodthirsty"
	set_effect(Effect.Type.HASTE, 1.3)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.WOOD: Value.new("800"),
		Currency.Type.HARDWOOD: Value.new("100"),
	})


func init_SEEING_BROWN() -> void:
	name = "Seeing [color=#7b3f00]Brown[/color]"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("300"),
		Currency.Type.WIRE: Value.new("300"),
		Currency.Type.TREES: Value.new("100"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WOODTHIRSTY


func init_CARLIN() -> void:
	name = "Carlin"
	set_effect(Effect.Type.HASTE, 1.1)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.LEAD: Value.new("600"),
	})


func init_HARDWOOD_YOURSELF() -> void:
	name = "[img=<15>]res://Sprites/Currency/hard.png[/img] Hardwood Yourself"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.HARDWOOD)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("185"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_STEEL_YOURSELF() -> void:
	name = "[img=<15>]res://Sprites/Currency/steel.png[/img] Steel Yourself"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.LIQUID_IRON)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_PLASMA_BOMBARDMENT() -> void:
	name = "Plasma Bombardment"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("310"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_PATREON_ARTIST() -> void:
	name = "Patreon Artist"
	set_effect(Effect.Type.HASTE, 1.2)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_MILLERY() -> void:
	name = "Millery"
	set_effect(Effect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("385"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HARDWOOD_YOURSELF


func init_QUAMPS() -> void:
	name = "Quamps"
	set_effect(Effect.Type.HASTE, 1.35)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("600"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STEEL_YOURSELF


func init_TWO_FIVE_FIVE_TWO() -> void:
	name = "[i]2552[/i]"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.SAND)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("750"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PLASMA_BOMBARDMENT


func init_GIMP() -> void:
	name = "GIMP"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("900"),
		Currency.Type.CARCINOGENS: Value.new("25"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PATREON_ARTIST


func init_SAGAN() -> void:
	name = "Sagan"
	set_effect(Effect.Type.HASTE, 1.1)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("5"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CARLIN


func init_HENRY_CAVILL() -> void:
	name = "Henry Cavill"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.WATER)
	cost = Cost.new({
		Currency.Type.CIGARETTES: Value.new("23.23"),
		Currency.Type.WOOD_PULP: Value.new("70"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_LEMBAS_WATER() -> void:
	name = "Lembas Water"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.WATER)
	add_effected_lored(LORED.Type.TREES)
	cost = Cost.new({
		Currency.Type.TOBACCO: Value.new("45"),
		Currency.Type.WATER: Value.new("300"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_BIGGER_TREES_I_GUESS() -> void:
	name = "bigger trees i guess"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.TREES)
	add_effected_lored(LORED.Type.WOOD)
	cost = Cost.new({
		Currency.Type.PLASTIC: Value.new("10e3"),
		Currency.Type.WOOD_PULP: Value.new("1e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_JOURNEYMAN_IRON_WORKER() -> void:
	name = "Journeyman Iron Worker"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.3)
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
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.WOOD)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("5.5e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MILLERY


func init_QUORMPS() -> void:
	name = "Cutting Corners!"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.LIQUID_IRON)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("4.5e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.QUAMPS


func init_KILTY_SBARK() -> void:
	name = "Kilty Sbark"
	set_effect(Effect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("6.5e3"),
		Currency.Type.CARCINOGENS: Value.new("200"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TWO_FIVE_FIVE_TWO


func init_HOLE_GEOMETRY() -> void:
	name = "Kilty Sbark"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.DRAW_PLATE)
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
	set_effect(Effect.Type.CRIT, 4)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e3"),
		Currency.Type.TUMORS: Value.new("100"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SAGAN


func init_WOOD_LORD() -> void:
	name = "Wood Lord"
	set_effect(Effect.Type.HASTE, 1.15)
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
	set_effect(Effect.Type.HASTE, 1.15)
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
	set_effect(Effect.Type.HASTE, 1.15)
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
	set_effect(Effect.Type.HASTE, 1.15)
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
	set_effect(Effect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.PETROLEUM)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("100e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_CANCERS_REAL_COOL() -> void:
	name = "CANCER'S REAL COOL"
	set_effect(Effect.Type.HASTE, 1.25)
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
	set_effect(Effect.Type.HASTE, 1.15)
	add_effected_lored(LORED.Type.CARCINOGENS)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e3"),
		Currency.Type.TUMORS: Value.new("2.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_SQUEEORMP() -> void:
	name = "Squeeormp"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.PETROLEUM)
	add_effected_lored(LORED.Type.PLASTIC)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("100e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_SANDAL_FLANDALS() -> void:
	name = "Sandal Flandals"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.HUMUS)
	add_effected_lored(LORED.Type.SAND)
	cost = Cost.new({
		Currency.Type.SAND: Value.new("100e3"),
		Currency.Type.CARCINOGENS: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_GLITTERDELVE() -> void:
	name = "Glitterdelve"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.GALENA)
	cost = Cost.new({
		Currency.Type.LEAD: Value.new("100e3"),
		Currency.Type.CARCINOGENS: Value.new("8e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_VIRILE() -> void:
	name = "VIRILE"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.SEEDS)
	add_effected_lored(LORED.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.CIGARETTES: Value.new("50e3"),
		Currency.Type.CARCINOGENS: Value.new("1.5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_FACTORY_SQUIRTS() -> void:
	name = "Factory Squirts"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.TOBACCO)
	cost = Cost.new({
		Currency.Type.WOOD: Value.new("500e3"),
		Currency.Type.CARCINOGENS: Value.new("5e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_INDEPENDENCE() -> void:
	name = "INDEPENDENCE"
	set_effect(Effect.Type.CRIT, 10)
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
	set_effect(Effect.Type.CRIT, 7)
	add_effected_lored(LORED.Type.HUMUS)
	cost = Cost.new({
		Currency.Type.SOIL: Value.new("1e6"),
		Currency.Type.CARCINOGENS: Value.new("10e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_ERECTWOOD() -> void:
	name = "ERECTWOOD"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("2e7"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WOOD_LORD


func init_STEELY_DAN() -> void:
	name = "Steely Dan"
	set_effect(Effect.Type.CRIT, 7)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("3e7"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.EXPERT_IRON_WORKER


func init_MGALEKGOLO() -> void:
	name = "Mgalekgolo"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.3)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("80e6"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.THEYVE_ALWAYS_BEEN_FASTER


func init_PULLEY() -> void:
	name = "Pulley"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.DRAW_PLATE)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("95e6"),
		Currency.Type.CARCINOGENS: Value.new("1e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.WHERES_THE_BOY_STRING


func init_LE_GUIN() -> void:
	name = "Le Guin"
	set_effect(Effect.Type.HASTE, 1.25)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e6"),
		Currency.Type.TUMORS: Value.new("100e3"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.CIORAN


func init_FLEEORMP() -> void:
	name = "Fleeormp"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.GALENA)
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
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.WATER)
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
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.9, Currency.Type.STEEL)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.DRAW_PLATE: Value.new("10e6"),
		Currency.Type.CARCINOGENS: Value.new("10e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LE_GUIN


func init_BUSY_BEE() -> void:
	name = "Busy Bee"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.3)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.35)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.2)
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
	set_effect(Effect.Type.CRIT, 6)
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
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.HARDWOOD)
	add_effected_lored(LORED.Type.AXES)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.ERECTWOOD


func init_STEEL_YO_MAMA() -> void:
	name = "[img=<15>]res://Sprites/Currency/steel.png[/img] Steel Yo Mama"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.LIQUID_IRON)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STEELY_DAN


func init_MAGNETIC_ACCELERATOR() -> void:
	name = "Magnetic Accelerator"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.SAND)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MGALEKGOLO


func init_SPOOLY() -> void:
	name = "Spooly"
	set_effect(Effect.Type.HASTE, 1.25)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("750e6"),
		Currency.Type.CARCINOGENS: Value.new("25e6"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.PULLEY


func init_TORIYAMA() -> void:
	name = "Toriyama"
	set_effect(Effect.Type.CRIT, 4)
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
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 2)
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
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.85, Currency.Type.PETROLEUM)
	add_effected_lored(LORED.Type.PLASTIC)
	cost = Cost.new({
		Currency.Type.TOBACCO: Value.new("12e9"),
		Currency.Type.CARCINOGENS: Value.new("3e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TORIYAMA


func init_BARELY_WOOD_BY_NOW() -> void:
	name = "Barely Wood by Now"
	set_effect(Effect.Type.SPECIFIC_INPUT, 0.8, Currency.Type.WOOD)
	add_effected_lored(LORED.Type.HARDWOOD)
	cost = Cost.new({
		Currency.Type.STEEL: Value.new("15e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.HARDWOOD_YO_MAMA


func init_FINGERS_OF_ONDEN() -> void:
	name = "Fingers of Onden"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.25)
	add_effected_lored(LORED.Type.STEEL)
	cost = Cost.new({
		Currency.Type.GLASS: Value.new("15e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.STEEL_YO_MAMA


func init_O_SALVATORI() -> void:
	name = "O'Salvatori"
	set_effect(Effect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.GLASS)
	cost = Cost.new({
		Currency.Type.WIRE: Value.new("15e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.MAGNETIC_ACCELERATOR


func init_LOW_RISES() -> void:
	name = "low rises"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 1.35)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("10e9"),
		Currency.Type.CARCINOGENS: Value.new("1e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.SPOOLY


func init_ILL_SHOW_YOU_HARDWOOD() -> void:
	name = "i'll show you hardwood"
	set_effect(Effect.Type.CRIT, 6)
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
	set_effect(Effect.Type.CRIT, 6)
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
	set_effect(Effect.Type.CRIT, 6)
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
	set_effect(Effect.Type.CRIT, 6)
	add_effected_lored(LORED.Type.DRAW_PLATE)
	add_effected_lored(LORED.Type.WIRE)
	cost = Cost.new({
		Currency.Type.HARDWOOD: Value.new("1e12"),
		Currency.Type.CARCINOGENS: Value.new("250e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.LOW_RISES


func init_JOHN_PETER_BAIN_TOTALBISCUIT() -> void:
	name = "[img=<15>]res://Sprites/Currency/Totalbiscuit.png[/img] John Peter Bain, TotalBiscuit"
	set_effect(Effect.Type.OUTPUT_AND_INPUT, 2)
	add_effected_stage(2)
	cost = Cost.new({
		Currency.Type.CARCINOGENS: Value.new("1e12"),
		Currency.Type.TUMORS: Value.new("10e9"),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.TORIYAMA


func init_() -> void:
	name = ""
	set_effect(Effect.Type.CRIT, )
	set_effect(Effect.Type.HASTE, )
	set_effect(Effect.Type.OUTPUT_AND_INPUT, )
	set_effect(Effect.Type.SPECIFIC_INPUT, 0., Currency.Type.)
	add_effected_lored(LORED.Type.)
	add_effected_stage()
	cost = Cost.new({
		Currency.Type.: Value.new(""),
	})
	await up.all_upgrades_initialized
	required_upgrade = Type.





func set_effect(_type: int, base_value := -1.0, effected_input = -1) -> void:
	var data := {}
	if base_value != -1:
		data["effect value"] = base_value
	if effected_input != -1:
		data["effected_input"] = effected_input
	data["upgrade_type"] = type
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
		effect.reset_effects()
		cost.purchased = false
		purchased = false



func enable_autobuy() -> void:
	autobuy = true


func disable_autobuy() -> void:
	autobuy = false



func prestige(_stage: int) -> void:
	if _stage == stage:
		if will_apply_effect:
			apply()
		elif not special:
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
