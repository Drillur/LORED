class_name Currency
extends Resource


var saved_vars := [
	"count",
	"pending",
	"subtracted_by_loreds",
	"subtracted_by_player",
	"added_by_loreds",
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

signal increased(amount)
signal just_unlocked

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

var count: Attribute
var pending := Attribute.new(0, false)

var subtracted_by_loreds := Attribute.new(0, false)
var subtracted_by_player := Attribute.new(0, false)
var added_by_loreds := Attribute.new(0, false)

var unlocked := false:
	set(val):
		unlocked = val
		emit_signal("just_unlocked")

var positive_current_rate := true
var positive_total_rate := true
var net_rate := Attribute.new(0)
var gain_rate := Attribute.new(0)
var loss_rate := Attribute.new(0)

var weight := 1

var produced_by := []


#func _load(data: Dictionary) -> void:
#	SaveManager.load_vars(self, data)
#	count.add(pending.get_value())
#	pending.reset()



func _init(_type: int = 0) -> void:
	type = _type
	key = Type.keys()[type]
	name = key.replace("_", " ").capitalize()
	net_rate.do_not_cap_current()
	gain_rate.do_not_cap_current()
	loss_rate.do_not_cap_current()
	init_stage()
	call("init_" + key)
	if count == null:
		count = Attribute.new(0, false)
	color_text = "[color=#" + color.to_html() + "]%s[/color]"
	colored_name = "[color=#" + color.to_html() + "]" + name + "[/color]"
	if icon == null:
		icon = preload("res://Sprites/Hud/Delete.png")
	icon_text = "[img=<15>]" + icon.get_path() + "[/img]"
	icon_and_name_text = icon_text + " " + name


func init_stage() -> void:
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


func init_STONE() -> void:
	count = Attribute.new(5, false)
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
	count = Attribute.new(8, false)
	color = Color(0.07, 0.89, 1)
	icon = preload("res://Sprites/Currency/iron.png")
	weight = 3


func init_COPPER() -> void:
	count = Attribute.new(8, false)
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
	count = Attribute.new(10, false)
	color = Color(0.88, .12, .35)
	icon = preload("res://Sprites/Currency/malig.png")


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
	count = Attribute.new(2, false)
	color = Color(1, 0.878431, 0.431373)
	icon = preload("res://Sprites/Currency/seed.png")


func init_TREES() -> void:
	color = Color(0.772549, 1, 0.247059)
	icon = preload("res://Sprites/Currency/tree.png")


func init_SOIL() -> void:
	count = Attribute.new(25, false)
	color = Color(0.737255, 0.447059, 0)
	icon = preload("res://Sprites/Currency/soil.png")


func init_AXES() -> void:
	count = Attribute.new(5, false)
	color = Color(0.691406, 0.646158, 0.586075)
	icon = preload("res://Sprites/Currency/axe.png")


func init_WOOD() -> void:
	count = Attribute.new(80, false)
	color = Color(0.545098, 0.372549, 0.015686)
	icon = preload("res://Sprites/Currency/wood.png")


func init_HARDWOOD() -> void:
	count = Attribute.new(95, false)
	color = Color(0.92549, 0.690196, 0.184314)
	icon = preload("res://Sprites/Currency/hard.png")
	weight = 3


func init_LIQUID_IRON() -> void:
	color = Color(0.27, 0.888, .9)
	icon = preload("res://Sprites/Currency/liq.png")


func init_STEEL() -> void:
	count = Attribute.new(25, false)
	color = Color(0.607843, 0.802328, 0.878431)
	icon = preload("res://Sprites/Currency/steel.png")
	weight = 3


func init_SAND() -> void:
	count = Attribute.new(250, false)
	color = Color(.87, .70, .45)
	icon = preload("res://Sprites/Currency/sand.png")


func init_GLASS() -> void:
	count = Attribute.new(30, false)
	color = Color(0.81, 0.93, 1.0)
	icon = preload("res://Sprites/Currency/glass.png")
	weight = 3


func init_DRAW_PLATE() -> void:
	color = Color(0.333333, 0.639216, 0.811765)
	icon = preload("res://Sprites/Currency/draw.png")


func init_WIRE() -> void:
	count = Attribute.new(20, false)
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


func init_JOY() -> void:
	color = Color(1, 0.909804, 0)
	icon = preload("res://Sprites/Currency/Joy.png")


func init_GRIEF() -> void:
	color = Color(0.74902, 0.203922, 0.533333)
	icon = preload("res://Sprites/Currency/Grief.png")





# - Actions

func reset():
	count.reset()
	pending.reset()


func unlock() -> void:
	unlocked = true


func add(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	count.add(amount)
	emit_signal("increased", amount)


func add_from_lored(amount) -> void:
	add(amount)
	added_by_loreds.add(amount)


func subtract(amount) -> void:
	count.subtract(amount)


func subtract_from_lored(amount) -> void:
	subtract(amount)
	subtracted_by_loreds.add(amount)


func subtract_from_player(amount) -> void:
	subtract(amount)
	subtracted_by_player.add(amount)


func add_producer(lored: LORED) -> void:
	if not lored in produced_by:
		produced_by.append(lored)


func add_pending(amount) -> void:
	pending.add(amount)


func subtract_pending(amount) -> void:
	pending.subtract(amount)



func add_current_gain_rate(amount) -> void:
	gain_rate.current.increase_added(amount)
	gain_rate.notify_changed_and_increased()
	sync_current_net_rate()


func subtract_current_gain_rate(amount) -> void:
	gain_rate.current.decrease_added(amount)
	gain_rate.notify_changed_and_decreased()
	sync_current_net_rate()


func add_total_gain_rate(amount) -> void:
	gain_rate.increase_added(amount)
	sync_total_net_rate()


func subtract_total_gain_rate(amount) -> void:
	gain_rate.decrease_added(amount)
	sync_total_net_rate()


func add_current_loss_rate(amount) -> void:
	loss_rate.current.increase_added(amount)
	loss_rate.notify_changed_and_increased()
	sync_current_net_rate()


func subtract_current_loss_rate(amount) -> void:
	loss_rate.current.decrease_added(amount)
	loss_rate.notify_changed_and_decreased()
	sync_current_net_rate()


func add_total_loss_rate(amount) -> void:
	loss_rate.increase_added(amount)
	sync_total_net_rate()


func subtract_total_loss_rate(amount) -> void:
	loss_rate.decrease_added(amount)
	sync_total_net_rate()


func sync_current_net_rate() -> void:
	var gain = gain_rate.get_current()
	var loss = loss_rate.get_current()
	if gain.greater_equal(loss):
		net_rate.current.set_to(Big.new(gain).s(loss))
		positive_current_rate = true
	else:
		net_rate.current.set_to(Big.new(loss).s(gain))
		positive_current_rate = false
	if net_rate.get_current().equal(0):
		positive_current_rate = true
	net_rate.notify_change()


func sync_total_net_rate() -> void:
	var gain = gain_rate.get_total()
	var loss = loss_rate.get_total()
	if gain.greater_equal(loss):
		net_rate.total.set_to(Big.new(gain).s(loss))
		positive_total_rate = true
	else:
		net_rate.total.set_to(Big.new(loss).s(gain))
		positive_total_rate = false
	net_rate.notify_change()




# - Get

func get_count() -> Big:
	return count.get_value()


func get_pending() -> Big:
	return pending.get_value()


func get_count_text() -> String:
	return count.get_text()


func get_pending_text() -> String:
	return pending.get_text()


func is_unlocked() -> bool:
	return unlocked


func is_locked() -> bool:
	return not is_unlocked()


func has_pending_resources() -> bool:
	return pending.get_value().greater(0)


func get_icon_path() -> String:
	return icon.get_path()


func get_eta(threshold: Big) -> Big:
	if count.get_value().greater_equal(threshold):
		return Big.new(0)
	if net_rate.get_current().equal(0):
		return Big.new(0)
	var deficit = Big.new(threshold).s(count.get_value())
	return deficit.d(net_rate.get_current())


func get_eta_text(threshold: Big) -> String:
	var eta = get_eta(threshold)
	return gv.parse_time(eta)


func get_random_producer() -> LORED:
	return produced_by[randi() % produced_by.size()]
