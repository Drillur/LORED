class_name Currency
extends RefCounted


var saved_vars := [
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

signal increased_by_lored(amount)
signal increased(amount)
signal decreased_by_lored(amount)
signal unlocked_changed(unlocked)
signal use_allowed_changed(allowed)
signal current_net_changed
signal total_net_became_negative
signal total_net_became_positive

var type: int
var stage: int

var name: String
var colored_name: String
var icon_text: String
var icon_and_name_text: String
var key: String

var color: Color
var color_text: String

var icon: Texture

var count: Big

var subtracted_by_loreds := Big.new(0, true)
var subtracted_by_player := Big.new(0, true)
var added_by_loreds := Big.new(0, true)

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



func _init(_type: int = 0) -> void:
	type = _type
	key = Type.keys()[type]
	name = key.replace("_", " ").capitalize()
	
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
	
	if persist.is_false_by_default() and stage == 0:
		persist.set_default_value(true)
	
	if count == null:
		count = Big.new(0, true)
	color_text = "[color=#" + color.to_html() + "]%s[/color]"
	colored_name = "[color=#" + color.to_html() + "]" + name + "[/color]"
	if icon == null:
		icon = preload("res://Sprites/Hud/Delete.png")
	icon_text = "[img=<15>]" + icon.get_path() + "[/img]"
	icon_and_name_text = icon_text + " " + name
	
	gv.prestige.connect(prestige)
	gv.hard_reset.connect(reset)



func init_STONE() -> void:
	count = Big.new(5, true)
	color = Color(0.79, 0.79, 0.79)
	icon = preload("res://Sprites/Currency/stone.png")
	weight = 3


func init_COAL() -> void:
	color = Color(0.7, 0, 1)
	icon = preload("res://Sprites/Currency/coal.png")
	weight = 2


func init_IRON_ORE() -> void:
	color = Color(0, 0.517647, 0.905882)
	icon = preload("res://Sprites/Currency/irono.png")


func init_COPPER_ORE() -> void:
	color = Color(0.7, 0.33, 0)
	icon = preload("res://Sprites/Currency/copo.png")


func init_IRON() -> void:
	count = Big.new(8, true)
	color = Color(0.07, 0.89, 1)
	icon = preload("res://Sprites/Currency/iron.png")
	weight = 3


func init_COPPER() -> void:
	count = Big.new(8, true)
	color = Color(1, 0.74, 0.05)
	icon = preload("res://Sprites/Currency/cop.png")
	weight = 3


func init_GROWTH() -> void:
	color = Color(0.79, 1, 0.05)
	icon = preload("res://Sprites/Currency/growth.png")
	weight = 2


func init_JOULES() -> void:
	color = Color(1, 0.98, 0)
	icon = preload("res://Sprites/Currency/jo.png")
	weight = 2


func init_CONCRETE() -> void:
	color = Color(0.35, 0.35, 0.35)
	icon = preload("res://Sprites/Currency/conc.png")
	weight = 3


func init_MALIGNANCY() -> void:
	count = Big.new(10, true)
	color = Color(0.88, .12, .35)
	icon = preload("res://Sprites/Currency/malig.png")
	persist.set_default_value(true)


func init_TARBALLS() -> void:
	color = Color(.56, .44, 1)
	icon = preload("res://Sprites/Currency/tar.png")
	weight = 2


func init_OIL() -> void:
	color = Color(.65, .3, .66)
	icon = preload("res://Sprites/Currency/oil.png")


func init_WATER() -> void:
	color = Color(0, 0.647059, 1)
	icon = preload("res://Sprites/Currency/water.png")
	weight = 2


func init_HUMUS() -> void:
	color = Color(0.458824, 0.25098, 0)
	icon = preload("res://Sprites/Currency/humus.png")


func init_SEEDS() -> void:
	count = Big.new(2, true)
	color = Color(1, 0.878431, 0.431373)
	icon = preload("res://Sprites/Currency/seed.png")


func init_TREES() -> void:
	color = Color(0.772549, 1, 0.247059)
	icon = preload("res://Sprites/Currency/tree.png")


func init_SOIL() -> void:
	count = Big.new(25, true)
	color = Color(0.737255, 0.447059, 0)
	icon = preload("res://Sprites/Currency/soil.png")


func init_AXES() -> void:
	count = Big.new(5, true)
	color = Color(0.691406, 0.646158, 0.586075)
	icon = preload("res://Sprites/Currency/axe.png")


func init_WOOD() -> void:
	count = Big.new(80, true)
	color = Color(0.545098, 0.372549, 0.015686)
	icon = preload("res://Sprites/Currency/wood.png")


func init_HARDWOOD() -> void:
	count = Big.new(95, true)
	color = Color(0.92549, 0.690196, 0.184314)
	icon = preload("res://Sprites/Currency/hard.png")
	weight = 3


func init_LIQUID_IRON() -> void:
	color = Color(0.27, 0.888, .9)
	icon = preload("res://Sprites/Currency/liq.png")


func init_STEEL() -> void:
	count = Big.new(25, true)
	color = Color(0.607843, 0.802328, 0.878431)
	icon = preload("res://Sprites/Currency/steel.png")
	weight = 3


func init_SAND() -> void:
	count = Big.new(250, true)
	color = Color(.87, .70, .45)
	icon = preload("res://Sprites/Currency/sand.png")


func init_GLASS() -> void:
	count = Big.new(30, true)
	color = Color(0.81, 0.93, 1.0)
	icon = preload("res://Sprites/Currency/glass.png")
	weight = 3


func init_DRAW_PLATE() -> void:
	color = Color(0.333333, 0.639216, 0.811765)
	icon = preload("res://Sprites/Currency/draw.png")


func init_WIRE() -> void:
	count = Big.new(20, true)
	color = Color(0.9, 0.6, 0.14)
	icon = preload("res://Sprites/Currency/wire.png")
	weight = 3


func init_GALENA() -> void:
	color = Color(0.701961, 0.792157, 0.929412)
	icon = preload("res://Sprites/Currency/gale.png")


func init_LEAD() -> void:
	color = Color(0.53833, 0.714293, 0.984375)
	icon = preload("res://Sprites/Currency/lead.png")


func init_PETROLEUM() -> void:
	color = Color(0.76, 0.53, 0.14)
	icon = preload("res://Sprites/Currency/pet.png")


func init_WOOD_PULP() -> void:
	color = Color(0.94902, 0.823529, 0.54902)
	icon = preload("res://Sprites/Currency/pulp.png")


func init_PAPER() -> void:
	color = Color(0.792157, 0.792157, 0.792157)
	icon = preload("res://Sprites/Currency/paper.png")


func init_PLASTIC() -> void:
	color = Color(0.85, 0.85, 0.85)
	icon = preload("res://Sprites/Currency/plast.png")
	weight = 2


func init_TOBACCO() -> void:
	color = Color(0.639216, 0.454902, 0.235294)
	icon = preload("res://Sprites/Currency/toba.png")


func init_CIGARETTES() -> void:
	color = Color(0.929412, 0.584314, 0.298039)
	icon = preload("res://Sprites/Currency/ciga.png")
	weight = 2


func init_CARCINOGENS() -> void:
	color = Color(0.772549, 0.223529, 0.192157)
	icon = preload("res://Sprites/Currency/carc.png")
	weight = 2


func init_EMBRYO() -> void:
	color = Color(1, .54, .54)


func init_TUMORS() -> void:
	color = Color(1, .54, .54)
	icon = preload("res://Sprites/Currency/tum.png")
	persist.set_default_value(true)


func init_FLOWER_SEED() -> void:
	color = Color(1, 0.878431, 0.431373)
	icon = preload("res://Sprites/Currency/seed.png")


func init_MANA() -> void:
	# alt: Color(0.721569, 0.34902, 0.901961)
	color = Color(0, 0.709804, 1)


func init_BLOOD() -> void:
	color = Color(1, 0, 0)


func init_SPIRIT() -> void:
	color = Color(0.88, .12, .35)
	persist.set_default_value(true)


func init_JOY() -> void:
	color = Color(1, 0.909804, 0)
	icon = preload("res://Sprites/Currency/Joy.png")
	persist.set_default_value(true)


func init_GRIEF() -> void:
	color = Color(0.74902, 0.203922, 0.533333)
	icon = preload("res://Sprites/Currency/Grief.png")
	persist.set_default_value(true)



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




# - Get


func get_count_text() -> String:
	return count.text


func is_unlocked() -> bool:
	return unlocked


func is_locked() -> bool:
	return not is_unlocked()


func get_icon_path() -> String:
	return icon.get_path()


func get_eta(threshold: Big) -> Big:
	if (
		count.greater_equal(threshold)
		or net_rate.get_value().equal(0)
		or not lv.any_loreds_in_list_are_active(produced_by)
	):
		return Big.new(0)
	
	var deficit = Big.new(threshold).s(count)
	return deficit.d(net_rate.get_value())


func get_eta_text(threshold: Big) -> String:
	var eta = get_eta(threshold)
	return gv.parse_time(eta)


func get_random_producer() -> LORED:
	return produced_by[randi() % produced_by.size()]
