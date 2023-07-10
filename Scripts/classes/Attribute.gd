class_name Attribute
extends Reference



var uses_current: bool
var current: Value
var total: Value

var has_vico := false
var vico: Node



func _init(base_value: float, will_use_current := true) -> void:
	uses_current = will_use_current
	if uses_current:
		current = Value.new(base_value)
	total = Value.new(base_value)



func assign_vico(_vico: Node) -> void:
	vico = _vico
	has_vico = true
	update_vico()
func unassign_vico() -> void:
	has_vico = false


func update_vico() -> void:
	if has_vico:
		vico.update()



func change_base(new_base_value: float) -> void:
	if uses_current:
		current.base = Big.new(new_base_value)
	total.base = Big.new(new_base_value)



func reset():
	if uses_current:
		current.reset()
	total.reset()
	update_vico()



func add(amount) -> void:
	current.add(amount)
	if current.current.greater(total.current):
		set_to(total.current)
		return
	update_vico()


func subtract(amount) -> void:
	current.subtract(Big.new(amount))
	update_vico()


func set_to(amount) -> void:
	current.set_to(amount)
	update_vico()



# - Get

func get_current_percent() -> float:
	return current.current.percent(total.current)

func get_randomized_total(min_range := 0.8, max_range := 1.2) -> Big:
	var total = Big.new(get_total())
	return total.m(rand_range(min_range, max_range))

func get_total() -> Big:
	return total.current

func get_total_text() -> String:
	return total.get_text()

func get_as_float() -> float:
	return total.current.toFloat()

func get_current() -> Big:
	return current.current

func get_current_text() -> String:
	return current.get_text()

func get_deficit() -> Big:
	return Big.new(total.current).s(current.current)

func get_deficit_text() -> String:
	return get_deficit().toString()

func get_deficit_text_plus_one() -> String:
	return get_deficit().a(1).toString()

func is_full() -> bool:
	return current.current.greater_equal(total.current)
