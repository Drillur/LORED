class_name ValuePair
extends Resource



var saved_vars := [
	"current",
	"total",
]


signal increased
signal decreased

signal current_changed
signal current_increased
signal current_decreased
signal total_changed
signal total_increased
signal total_decreased

signal filled
signal emptied

var cap_current := true
var current: Value
var total: Value

var full := false:
	set(val):
		if full != val:
			full = val
			if val:
				filled.emit()

var empty := false:
	set(val):
		if empty != val:
			empty = val
			if val:
				emptied.emit()



func _init(base_value = 1.0) -> void:
	current = Value.new(base_value)
	current.connect("increased", emit_increase)
	current.connect("increased", emit_current_increase)
	current.connect("decreased", emit_decrease)
	current.connect("decreased", emit_current_decrease)
	current.connect("changed", emit_changed)
	current.connect("changed", emit_current_changed)
	total = Value.new(base_value)
	total.connect("increased", emit_increase)
	total.connect("increased", emit_total_increase)
	total.connect("decreased", emit_decrease)
	total.connect("decreased", emit_total_decrease)
	total.connect("changed", emit_changed)
	total.connect("changed", emit_total_changed)
	
	current.connect("changed", check_if_full)
	current.connect("changed", check_if_empty)



# - Signals

func emit_increase() -> void:
	emit_signal("increased")


func emit_decrease() -> void:
	emit_signal("decreased")


func emit_current_changed() -> void:
	emit_signal("current_changed")


func emit_current_increase() -> void:
	emit_signal("current_increased")


func emit_current_decrease() -> void:
	emit_signal("current_decreased")


func emit_total_changed() -> void:
	emit_signal("total_changed")


func emit_total_increase() -> void:
	emit_signal("total_increased")


func emit_total_decrease() -> void:
	emit_signal("total_decreased")



func check_if_full() -> void:
	if current.current.greater_equal(total.current):
		full = true
	else:
		full = false


func check_if_empty() -> void:
	if current.current.equal(0):
		empty = true
	else:
		empty = false



# - Actions

func reset():
	current.reset()
	total.reset()


func change_base(new_base_value: float) -> void:
	current.change_base(new_base_value)


func do_not_cap_current() -> void:
	cap_current = false



func add(amount) -> void:
	amount = set_amount_to_deficit_if_necessary(amount)
	current.add(amount)


func subtract(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	current.subtract(amount)
	full = false


func add_percent(percent: float) -> void:
	var amount = Big.new(percent).m(get_total())
	add(amount)



func add_pending(amount: Big) -> void:
	current.add_pending(amount)


func subtract_pending(amount: Big) -> void:
	current.subtract_pending(amount)



func set_amount_to_deficit_if_necessary(amount) -> Big:
	if not cap_current:
		return
	var deficit = get_deficit()
	if deficit.less(amount):
		return deficit
	if not amount is Big:
		amount = Big.new(amount)
	return amount



func increase_added(amount) -> void:
	total.increase_added(amount)


func decrease_added(amount) -> void:
	total.decrease_added(amount)


func increase_subtracted(amount) -> void:
	total.increase_subtracted(amount)


func decrease_subtracted(amount) -> void:
	total.decrease_subtracted(amount)


func increase_multiplied(amount) -> void:
	total.increase_multiplied(amount)


func decrease_multiplied(amount) -> void:
	total.decrease_multiplied(amount)


func increase_divided(amount) -> void:
	total.increase_divided(amount)


func decrease_divided(amount) -> void:
	total.decrease_divided(amount)


func set_from_level(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	total.set_from_level(amount)


func set_d_from_lored(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	total.set_d_from_lored(amount)


func set_m_from_lored(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	total.set_m_from_lored(amount)


func set_to(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	current.set_to(amount)
	if full and cap_current:
		current.set_to(get_total())


func set_to_percent(percent: float, with_random_range := false) -> void:
	var multiplier := randf_range(0.8, 1.2) if with_random_range else 1.0
	multiplier *= percent
	set_to(Big.new(get_total()).m(multiplier))


func fill_up() -> void:
	if not full:
		set_to(get_total())



# - Get

func get_value() -> Big:
	return get_current()


func get_current_percent() -> float:
	return current.current.percent(total.current)


func get_x_percent(percent: float) -> Big:
	return Big.new(get_total()).m(percent)


func get_x_percent_text(percent: float) -> String:
	return get_x_percent(percent).text


func get_randomized_total(min_range := 0.8, max_range := 1.2) -> Big:
	return Big.new(get_total()).m(randf_range(min_range, max_range))


func get_total() -> Big:
	return total.current


func get_total_text() -> String:
	return total.get_text()


func get_as_float() -> float:
	return total.get_as_float()


func get_as_int() -> int:
	return total.get_as_int()


func get_current() -> Big:
	return current.current


func get_current_text() -> String:
	return current.get_text()


func get_deficit() -> Big:
	return Big.new(total.current).s(current.current)


func get_surplus() -> Big:
	if current.current.greater_equal(total.current):
		return Big.new(current.current).s(total.current)
	return Big.new(0)


func get_base() -> Big:
	return total.base


func get_deficit_text() -> String:
	return get_deficit().text


func get_deficit_text_plus_one() -> String:
	return get_deficit().a(1).text


func get_text() -> String:
	return get_current_text() + "/" + get_total_text()


func is_empty() -> bool:
	return get_current().equal(0)


func is_full() -> bool:
	return get_current().greater_equal(get_total())
