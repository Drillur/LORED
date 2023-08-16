class_name Attribute
extends Resource



signal save_finished
signal load_finished


func save() -> String:
	var data := {}
	data["total"] = total.save()
	data["pending"] = pending.save()
	if uses_current:
		data["current"] = current.save()
	emit_signal("save_finished")
	return var_to_str(data)


func save_as_big() -> String:
	var data := {}
	data["total"] = total.current.save()
	emit_signal("save_finished")
	return var_to_str(data)


func save_current() -> String:
	if not uses_current:
		printerr("You done did mcfucked up")
		return ""
	var data := {}
	data["current"] = current.save()
	data["pending"] = pending.save()
	emit_signal("save_finished")
	return var_to_str(data)


func load_data(data_str: String) -> void:
	var data: Dictionary = str_to_var(data_str)
	total.load_data(data["total"])
	pending.load_data(data["pending"])
	if uses_current:
		current.load_data(data["current"])
	emit_signal("load_finished")
	notify_all()


func load_current(data_str: String) -> void:
	var data: Dictionary = str_to_var(data_str)
	current.load_data(data["current"])
	pending.load_data(data["pending"])
	emit_signal("load_finished")
	notify_all()


func load_finished_pending() -> void: # called automatically
	if pending.greater(0):
		if uses_current:
			current.add(pending)
		else:
			total.add(pending)
		notify_changed_and_increased()
		pending = Big.new(0)


signal filled
signal emptied

var uses_current: bool
var cap_current := true
var current: Value
var total: Value
var pending := Big.new(0)

var notify_if_changed: Array
var notify_if_increased: Array
var notify_if_decreased: Array
var notify_if_total_changed: Array
var notify_if_changed_immediately: Array



func _init(base_value = 0, will_use_current := true) -> void:
	connect("load_finished", load_finished_pending)
	uses_current = will_use_current
	if uses_current:
		current = Value.new(base_value)
	total = Value.new(base_value)



# - Notify and Update

func add_notify_change_method(method: Callable, remove_automatically := false) -> void:
	if not method in notify_if_changed:
		notify_if_changed.append(method)
		gv.update(method)
		if remove_automatically:
			remove_notify_method_if_obj_freed(method)


func add_immediate_notify_method(method: Callable, remove_automatically := false) -> void:
	if not method in notify_if_changed_immediately:
		notify_if_changed_immediately.append(method)
		method.call()
		if remove_automatically:
			remove_notify_method_if_obj_freed(method)


func add_notify_increased_method(method: Callable, remove_automatically := false) -> void:
	if not method in notify_if_increased:
		notify_if_increased.append(method)
		gv.update(method)
		if remove_automatically:
			remove_notify_method_if_obj_freed(method)


func add_notify_decreased_method(method: Callable, remove_automatically := false) -> void:
	if not method in notify_if_decreased:
		notify_if_decreased.append(method)
		gv.update(method)
		if remove_automatically:
			remove_notify_method_if_obj_freed(method)


func add_notify_total_change_method(method: Callable, remove_automatically := false) -> void:
	if not method in notify_if_total_changed:
		notify_if_total_changed.append(method)
		gv.update(method)
		if remove_automatically:
			remove_notify_method_if_obj_freed(method)


func remove_notify_method_if_obj_freed(method: Callable) -> void:
	await method.get_object().tree_exiting
	##printt(method, " removed automatically")
	remove_notify_method(method)


func remove_notify_method(method: Callable) -> void:
	notify_if_changed.erase(method)
	notify_if_increased.erase(method)
	notify_if_decreased.erase(method)
	notify_if_total_changed.erase(method)
	notify_if_changed_immediately.erase(method)


func notify_change() -> void:
	for method in notify_if_changed_immediately:
		method.call()
	for method in notify_if_changed:
		gv.update(method)


func notify_increase() -> void:
	for method in notify_if_increased:
		gv.update(method)


func notify_decrease() -> void:
	for method in notify_if_decreased:
		gv.update(method)


func notify_total_change() -> void:
	for method in notify_if_total_changed:
		gv.update(method)


func notify_changed_and_increased() -> void:
	for method in notify_if_changed_immediately:
		method.call()
	for method in notify_if_changed + notify_if_increased:
		gv.update(method)


func notify_changed_and_decreased() -> void:
	for method in notify_if_changed_immediately:
		method.call()
	for method in notify_if_changed + notify_if_decreased:
		gv.update(method)


func notify_increased_and_decreased() -> void:
	for method in notify_if_increased + notify_if_decreased:
		gv.update(method)


func notify_all() -> void:
	for method in get_all_notify_lists():
		gv.update(method)



# - Actions

func reset():
	if uses_current:
		current.reset()
	total.reset()
	pending = Big.new(0)
	notify_changed_and_decreased()
	notify_total_change()


func change_base(new_base_value: float) -> void:
	if uses_current:
		current.base = Big.new(new_base_value)
		notify_change()
	else:
		total.base = Big.new(new_base_value)
		notify_total_change()


func do_not_cap_current() -> void:
	cap_current = false



func add(amount) -> void:
	if uses_current:
		amount = set_amount_to_deficit_if_necessary(amount)
		current.add(amount)
		if get_current().greater_equal(get_total()):
			emit_signal("filled")
	else:
		total.add(amount)
		notify_total_change()
	notify_changed_and_increased()


func subtract(amount) -> void:
	if uses_current:
		if not amount is Big:
			amount = Big.new(amount)
		current.subtract(amount)
		if get_current().equal(0):
			emit_signal("emptied")
	else:
		total.subtract(amount)
		notify_total_change()
	notify_changed_and_decreased()


func add_percent(percent: float) -> void:
	var amount = Big.new(percent).m(get_total())
	add(amount)



func add_pending(amount: Big) -> void:
	pending.a(amount)


func subtract_pending(amount: Big) -> void:
	pending.s(amount)



func set_amount_to_deficit_if_necessary(amount) -> Big:
	if not uses_current:
		return
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
	notify_changed_and_increased()
	notify_total_change()


func decrease_added(amount) -> void:
	total.decrease_added(amount)
	notify_changed_and_decreased()
	notify_total_change()


func increase_subtracted(amount) -> void:
	total.increase_subtracted(amount)
	notify_changed_and_decreased()
	notify_total_change()


func decrease_subtracted(amount) -> void:
	total.decrease_subtracted(amount)
	notify_changed_and_increased()
	notify_total_change()


func increase_multiplied(amount) -> void:
	total.increase_multiplied(amount)
	notify_changed_and_increased()
	notify_total_change()


func decrease_multiplied(amount) -> void:
	total.decrease_multiplied(amount)
	notify_changed_and_decreased()
	notify_total_change()


func increase_divided(amount) -> void:
	total.increase_divided(amount)
	notify_changed_and_decreased()


func decrease_divided(amount) -> void:
	total.decrease_divided(amount)
	notify_changed_and_increased()
	notify_total_change()


func set_from_level(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	var greater_equal = amount.greater_equal(total.from_level)
	
	total.set_from_level(Big.new(amount))
	
	notify_total_change()
	if greater_equal:
		notify_changed_and_increased()
	else:
		notify_changed_and_decreased()


func set_d_from_lored(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	var greater_equal = amount.less(total.d_from_lored)
	
	total.set_d_from_lored(Big.new(amount))
	
	notify_total_change()
	if greater_equal:
		notify_changed_and_increased()
	else:
		notify_changed_and_decreased()


func set_m_from_lored(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	var greater_equal = amount.greater_equal(total.m_from_lored)
	
	total.set_m_from_lored(Big.new(amount))
	
	notify_total_change()
	if greater_equal:
		notify_changed_and_increased()
	else:
		notify_changed_and_decreased()


func set_to(amount) -> void:
	if uses_current:
		if not amount is Big:
			amount = Big.new(amount)
		current.set_to(amount)
		if get_current().greater_equal(get_total()):
			if cap_current:
				current.set_to(get_total())
			emit_signal("filled")
	else:
		total.set_to(amount)
		notify_total_change()
	notify_all()


func set_to_percent(percent: float, with_random_range := false) -> void:
	var multiplier := randf_range(0.8, 1.2) if with_random_range else 1.0
	multiplier *= percent
	set_to(Big.new(get_total()).m(multiplier))
	notify_all()



# - Get

func get_value() -> Big:
	if uses_current:
		return get_current()
	return get_total()


func get_current_percent() -> float:
	return current.current.percent(total.current)


func get_x_percent(percent: float) -> Big:
	return Big.new(get_total()).m(percent)


func get_x_percent_text(percent: float) -> String:
	return get_x_percent(percent).toString()


func get_randomized_total(min_range := 0.8, max_range := 1.2) -> Big:
	var _total = Big.new(get_total())
	return _total.m(randf_range(min_range, max_range))


func get_total() -> Big:
	return total.current


func get_total_text() -> String:
	return total.get_text()


func get_as_float() -> float:
	return total.current.toFloat()


func get_as_int() -> int:
	return total.current.toInt()


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
	return get_deficit().toString()


func get_deficit_text_plus_one() -> String:
	return get_deficit().a(1).toString()


func get_text() -> String:
	if uses_current:
		return get_current_text() + "/" + get_total_text()
	return get_total_text()


func is_full() -> bool:
	return get_current().greater_equal(get_total())


func is_not_full() -> bool:
	return get_current().less(get_total())


func is_empty() -> bool:
	return get_current().equal(0)


func get_all_notify_lists() -> Array:
	return notify_if_changed + notify_if_increased + notify_if_decreased + notify_if_total_changed + notify_if_changed_immediately
