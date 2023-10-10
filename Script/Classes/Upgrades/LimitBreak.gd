class_name LimitBreak
extends Resource



const saved_vars := [
#	"enabled",
#	"xp",
#	"level",
]


var enabled := Bool.new(false)
var xp := ValuePair.new(get_required_xp(1))
var level := Int.new(1)



func _init() -> void:
	xp.set_to(0)
	xp.do_not_cap_current()
	xp.current_increased.connect(level_up_check)
	
	enabled.became_true.connect(connect_calls)
	enabled.became_false.connect(disconnect_calls)



# - Action


func enable() -> void:
	enabled.set_to(true)


func disable() -> void:
	enabled.set_to(false)


func connect_calls() -> void:
	for currency in wa.currency.values():
		if currency.increased_by_lored.is_connected(add_xp):
			printerr("Limit Break was already connected!")
			return
		currency.increased_by_lored.connect(add_xp)


func disconnect_calls() -> void:
	for currency in wa.currency.values():
		if not currency.increased_by_lored.is_connected(add_xp):
			printerr("Limit Break wasn't connected!")
			return
		currency.increased_by_lored.disconnect(add_xp)



func add_xp(amount: Big) -> void:
	xp.add(amount)


func level_up_check() -> void:
	var gained_levels := 0
	while xp.is_full():
		gained_levels += 1
		xp.subtract(xp.get_total())
		xp.total.set_from_level(
			get_required_xp(level.get_value() + gained_levels)
		)
	
	if gained_levels > 0:
		level.add(gained_levels)
		#print("Limit Break just increased %s levels!" % str(gained_levels), level.get_value())


func get_required_xp(_level: int) -> Big:
	var x = Big.new(2).power(_level - 1).round_up_tens().m(100)
	if x.exponent < 3:
		x.set_to(1000)
	#print("Limit Break level: ", _level, ". xp required: ", x.text)
	return x
