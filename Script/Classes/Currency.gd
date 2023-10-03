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
	COPPER,
	GROWTH,
	JOULES,
	CONCRETE,
	MALIGNANCY,
	TARBALLS,
	OIL,
	
	WATER,
	HUMUS,
	SEEDS,
	TREES,
	SOIL,
	AXES,
	WOOD,
	HARDWOOD,
	LIQUID_IRON,
	STEEL,
	SAND,
	GLASS,
	DRAW_PLATE,
	WIRE,
	GALENA,
	LEAD,
	PETROLEUM,
	WOOD_PULP,
	PAPER,
	PLASTIC,
	TOBACCO,
	CIGARETTES,
	CARCINOGENS,
	EMBRYO,
	TUMORS,
	
	FLOWER_SEED,
	MANA,
	BLOOD,
	SPIRIT,
	
	# stage 3 goes above here
	
	
	# stage 4 goes above here
	
	JOY,
	GRIEF,
}

enum SafetyType { SAFE, LORED_PURCHASED, }

signal increased_by_lored(amount)
signal increased(amount)
signal decreased_by_lored(amount)
signal unlocked_changed(unlocked)
signal use_allowed_changed(allowed)
signal current_net_changed
signal total_net_became_negative
signal total_net_became_positive

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

var safe := Bool.new(true)
var unlocked := false:
	set(val):
		if unlocked != val:
			unlocked = val
			unlocked_changed.emit(val)
			if val:
				saved_vars.append("count")
				saved_vars.append("subtracted_by_loreds")
				saved_vars.append("subtracted_by_player")
				saved_vars.append("added_by_loreds")
			else:
				saved_vars.erase("count")
				saved_vars.erase("subtracted_by_loreds")
				saved_vars.erase("subtracted_by_player")
				saved_vars.erase("added_by_loreds")
var persist := Bool.new(false)
var use_allowed := true:
	set(val):
		if use_allowed != val:
			use_allowed = val
			use_allowed_changed.emit(val)
var used_for_fuel := false

var positive_rate := true:
	set(val):
		if positive_rate != val:
			positive_rate = val
			if val:
				total_net_became_positive.emit()
			else:
				total_net_became_negative.emit()
var net_rate := Value.new(0)
var gain_rate := Value.new(0)
var loss_rate := Value.new(0)

var weight := 1
var last_crit_modifier := 1.0

var produced_by := []
var used_by := []




func _init(_type := Type.STONE) -> void:
	type = _type
	key = Type.keys()[type]
	details.name = key.replace("_", " ").capitalize()
	
	if type <= Type.OIL:
		stage = 1
	elif type <= Type.TUMORS:
		stage = 2
	elif type <= Type.SPIRIT:
		stage = 3
	elif type < Type.JOY:
		stage = 4
	else:
		stage = 0
	
	call("init_" + key)
	
	if safety_type == SafetyType.SAFE:
		safe.set_to(true)
	
	if persist.is_false_by_default() and stage == 0:
		persist.set_default_value(true)
	
	if count == null:
		count = Big.new(0, true)
	if details.icon == null:
		details.icon = preload("res://Sprites/Hud/Delete.png")
	
	gv.prestige.connect(prestige)
	gv.hard_reset.connect(reset)



func init_STONE() -> void:
	count = Big.new(5, true)
	details.color = Color(0.79, 0.79, 0.79)
	details.icon = preload("res://Sprites/Currency/stone.png")
	weight = 3


func init_COAL() -> void:
	details.color = Color(0.7, 0, 1)
	details.icon = preload("res://Sprites/Currency/coal.png")
	details.description = "Used primarily as fuel for LOREDs!"
	weight = 2
	used_for_fuel = true


func init_IRON_ORE() -> void:
	details.color = Color(0, 0.517647, 0.905882)
	details.icon = preload("res://Sprites/Currency/irono.png")


func init_COPPER_ORE() -> void:
	details.color = Color(0.7, 0.33, 0)
	details.icon = preload("res://Sprites/Currency/copo.png")


func init_IRON() -> void:
	count = Big.new(8, true)
	details.color = Color(0.07, 0.89, 1)
	details.icon = preload("res://Sprites/Currency/iron.png")
	details.description = "It's possible that this is toast."
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.IRON)


func init_COPPER() -> void:
	count = Big.new(8, true)
	details.color = Color(1, 0.74, 0.05)
	details.icon = preload("res://Sprites/Currency/cop.png")
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.COPPER)


func init_GROWTH() -> void:
	details.color = Color(0.79, 1, 0.05)
	details.icon = preload("res://Sprites/Currency/growth.png")
	details.description = "What? This game is weird!"
	weight = 2


func init_JOULES() -> void:
	details.color = Color(1, 0.98, 0)
	details.icon = preload("res://Sprites/Currency/jo.png")
	details.description = "Used primarily as fuel for LOREDs!"
	weight = 2
	used_for_fuel = true
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.JOULES)


func init_CONCRETE() -> void:
	details.color = Color(0.35, 0.35, 0.35)
	details.icon = preload("res://Sprites/Currency/conc.png")
	weight = 3


func init_MALIGNANCY() -> void:
	count = Big.new(10, true)
	details.color = Color(0.88, .12, .35)
	details.icon = preload("res://Sprites/Currency/malig.png")
	persist.set_default_value(true)
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.TARBALLS)


func init_TARBALLS() -> void:
	details.color = Color(.56, .44, 1)
	details.icon = preload("res://Sprites/Currency/tar.png")
	weight = 2


func init_OIL() -> void:
	details.color = Color(.65, .3, .66)
	details.icon = preload("res://Sprites/Currency/oil.png")


func init_WATER() -> void:
	details.color = Color(0, 0.647059, 1)
	details.icon = preload("res://Sprites/Currency/water.png")
	details.description = "The 4x2 Lego piece of life."
	weight = 2


func init_HUMUS() -> void:
	details.color = Color(0.458824, 0.25098, 0)
	details.icon = preload("res://Sprites/Currency/humus.png")
	details.description = "Actual shit."


func init_SEEDS() -> void:
	count = Big.new(2, true)
	details.color = Color(1, 0.878431, 0.431373)
	details.icon = preload("res://Sprites/Currency/seed.png")
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.SEEDS)


func init_TREES() -> void:
	details.color = Color(0.772549, 1, 0.247059)
	details.icon = preload("res://Sprites/Currency/tree.png")


func init_SOIL() -> void:
	count = Big.new(25, true)
	details.color = Color(0.737255, 0.447059, 0)
	details.icon = preload("res://Sprites/Currency/soil.png")
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.SOIL)


func init_AXES() -> void:
	count = Big.new(5, true)
	details.color = Color(0.691406, 0.646158, 0.586075)
	details.icon = preload("res://Sprites/Currency/axe.png")
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.AXES)


func init_WOOD() -> void:
	count = Big.new(80, true)
	details.color = Color(0.545098, 0.372549, 0.015686)
	details.icon = preload("res://Sprites/Currency/wood.png")
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.WOOD)


func init_HARDWOOD() -> void:
	count = Big.new(95, true)
	details.color = Color(0.92549, 0.690196, 0.184314)
	details.icon = preload("res://Sprites/Currency/hard.png")
	details.description = "( ͡⚆ ͜ʖ ͡⚆)"
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.HARDWOOD)


func init_LIQUID_IRON() -> void:
	details.color = Color(0.27, 0.888, .9)
	details.icon = preload("res://Sprites/Currency/liq.png")


func init_STEEL() -> void:
	count = Big.new(25, true)
	details.color = Color(0.607843, 0.802328, 0.878431)
	details.icon = preload("res://Sprites/Currency/steel.png")
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.STEEL)


func init_SAND() -> void:
	count = Big.new(250, true)
	details.color = Color(.87, .70, .45)
	details.icon = preload("res://Sprites/Currency/sand.png")
	details.description = "It's roarse, and cough, and it gets eherweyeve!"
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.SAND)


func init_GLASS() -> void:
	count = Big.new(30, true)
	details.color = Color(0.81, 0.93, 1.0)
	details.icon = preload("res://Sprites/Currency/glass.png")
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.GLASS)


func init_DRAW_PLATE() -> void:
	details.color = Color(0.333333, 0.639216, 0.811765)
	details.icon = preload("res://Sprites/Currency/draw.png")


func init_WIRE() -> void:
	count = Big.new(20, true)
	details.color = Color(0.9, 0.6, 0.14)
	details.icon = preload("res://Sprites/Currency/wire.png")
	weight = 3
	set_safety_condition(SafetyType.LORED_PURCHASED, LORED.Type.WIRE)


func init_GALENA() -> void:
	details.color = Color(0.701961, 0.792157, 0.929412)
	details.icon = preload("res://Sprites/Currency/gale.png")


func init_LEAD() -> void:
	details.color = Color(0.53833, 0.714293, 0.984375)
	details.icon = preload("res://Sprites/Currency/lead.png")


func init_PETROLEUM() -> void:
	details.color = Color(0.76, 0.53, 0.14)
	details.icon = preload("res://Sprites/Currency/pet.png")


func init_WOOD_PULP() -> void:
	details.color = Color(0.94902, 0.823529, 0.54902)
	details.icon = preload("res://Sprites/Currency/pulp.png")


func init_PAPER() -> void:
	details.color = Color(0.792157, 0.792157, 0.792157)
	details.icon = preload("res://Sprites/Currency/paper.png")


func init_PLASTIC() -> void:
	details.color = Color(0.85, 0.85, 0.85)
	details.icon = preload("res://Sprites/Currency/plast.png")
	weight = 2


func init_TOBACCO() -> void:
	details.color = Color(0.639216, 0.454902, 0.235294)
	details.icon = preload("res://Sprites/Currency/toba.png")


func init_CIGARETTES() -> void:
	details.color = Color(0.929412, 0.584314, 0.298039)
	details.icon = preload("res://Sprites/Currency/ciga.png")
	weight = 2


func init_CARCINOGENS() -> void:
	details.color = Color(0.772549, 0.223529, 0.192157)
	details.icon = preload("res://Sprites/Currency/carc.png")
	weight = 2


func init_EMBRYO() -> void:
	details.color = Color(1, .54, .54)


func init_TUMORS() -> void:
	details.color = Color(1, .54, .54)
	details.icon = preload("res://Sprites/Currency/tum.png")
	persist.set_default_value(true)


func init_FLOWER_SEED() -> void:
	details.color = Color(1, 0.878431, 0.431373)
	details.icon = preload("res://Sprites/Currency/seed.png")


func init_MANA() -> void:
	# alt: Color(0.721569, 0.34902, 0.901961)
	details.color = Color(0, 0.709804, 1)


func init_BLOOD() -> void:
	details.color = Color(1, 0, 0)


func init_SPIRIT() -> void:
	details.color = Color(0.88, .12, .35)
	persist.set_default_value(true)


func init_JOY() -> void:
	details.color = Color(1, 0.909804, 0)
	details.icon = preload("res://Sprites/Currency/Joy.png")
	persist.set_default_value(true)


func init_GRIEF() -> void:
	details.color = Color(0.74902, 0.203922, 0.533333)
	details.icon = preload("res://Sprites/Currency/Grief.png")
	persist.set_default_value(true)



# - Setup

func set_safety_condition(_type: SafetyType, _subject: int) -> void:
	safety_type = _type
	safety_subject = _subject
	await lv.loreds_initialized
	match safety_type:
		SafetyType.LORED_PURCHASED:
			lv.get_lored(safety_subject).purchased.changed.connect(safety_check)
			safety_check()
		SafetyType.SAFE:
			safe.set_to(true)



# - Signals


func prestige(_stage: int) -> void:
	if (
		_stage >= stage
		and stage > 0
		and (
			persist.is_not_true()
			or _stage > stage
		)
	):
		count.reset()
	if count.less(count.base):
		count.set_to(count.base)




# - Actions

func reset():
	count.reset()


func safety_check() -> void:
	match safety_type:
		SafetyType.LORED_PURCHASED:
			safe.set_to(lv.is_lored_purchased(safety_subject))


func unlock() -> void:
	unlocked = true


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
		positive_rate = true
		net_rate.set_to(Big.new(gain).s(loss))
	else:
		positive_rate = false
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
			and wa.is_currency_unlocked(lored.fuel_currency)
		):
			cont = true
			break
	if not cont:
		return false
	return unlocked


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
	return unlocked


func is_locked() -> bool:
	return not is_unlocked()


func get_eta(threshold: Big) -> Big:
	if (
		count.greater_equal(threshold)
		or net_rate.get_value().equal(0)
		or not lv.any_loreds_in_list_are_active(produced_by)
		or not positive_rate
	):
		return Big.new(0)
	
	var deficit = Big.new(threshold).s(count)
	return deficit.d(net_rate.get_value())


func get_eta_text(threshold: Big) -> String:
	var eta = get_eta(threshold)
	return gv.parse_time(eta)


func get_random_producer() -> LORED:
	return produced_by[randi() % produced_by.size()]


func get_fuel_currency() -> int:
	return lv.get_lored(produced_by[0]).fuel_currency
