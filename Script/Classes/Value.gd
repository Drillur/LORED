class_name Value
extends Resource



signal save_finished
signal load_finished


func save() -> String:
	var data := {}
	data["current"] = current.save()
	emit_signal("save_finished")
	return var_to_str(data)


func load_data(data_str: String) -> void:
	var data: Dictionary = str_to_var(data_str)
	current.load_data(data["current"])
	text_requires_update = true
	emit_signal("load_finished")



var base: Big

var requires_sync := false
var current: Big:
	get:
		sync()
		return current

var added := Big.new(0)
var subtracted := Big.new(0)
var multiplied := Big.new(1)
var divided := Big.new(1)
var from_level := Big.new(1)
var m_from_lored := Big.new(1)
var d_from_lored := Big.new(1)

var text_requires_update := true
var text: String: get = get_text




func _init(base_value = 0) -> void:
	base = Big.new(base_value)
	current = Big.new(base_value)




func set_to(amount) -> void:
	current = Big.new(amount)
	text_requires_update = true


func add(amount) -> void:
	current.a(amount)
	text_requires_update = true


func subtract(amount: Big) -> void:
	if amount.greater_equal(current):
		current = Big.new(0)
	else:
		current.s(amount)
		if current.equal(0):
			current = Big.new(0)
	text_requires_update = true



func sync() -> void:
	if requires_sync:
		requires_sync = false
		text_requires_update = true
		current = Big.new(base)
		current.a(added)
		current.s(subtracted)
		current.m(multiplied)
		current.m(from_level)
		current.m(m_from_lored)
		current.d(divided)
		current.d(d_from_lored)


func get_text() -> String:
	if text_requires_update:
		text = current.toString()
		text_requires_update = false
	return text



func increase_added(amount) -> void:
	added.a(amount)
	requires_sync = true
	text_requires_update = true


func decrease_added(amount) -> void:
	added.s(amount)
	requires_sync = true
	text_requires_update = true


func increase_subtracted(amount) -> void:
	subtracted.a(amount)
	requires_sync = true
	text_requires_update = true


func decrease_subtracted(amount) -> void:
	subtracted.s(amount)
	requires_sync = true
	text_requires_update = true


func increase_multiplied(amount) -> void:
	multiplied.m(amount)
	requires_sync = true
	text_requires_update = true


func decrease_multiplied(amount) -> void:
	multiplied.d(amount)
	requires_sync = true
	text_requires_update = true


func increase_divided(amount) -> void:
	divided.m(amount)
	requires_sync = true
	text_requires_update = true


func decrease_divided(amount) -> void:
	divided.d(amount)
	requires_sync = true
	text_requires_update = true


func set_from_level(amount) -> void:
	from_level = Big.new(amount)
	requires_sync = true
	text_requires_update = true


func set_d_from_lored(amount) -> void:
	d_from_lored = Big.new(amount)
	requires_sync = true
	text_requires_update = true


func set_m_from_lored(amount) -> void:
	m_from_lored = Big.new(amount)
	requires_sync = true
	text_requires_update = true



func reset():
	added = Big.new(0)
	subtracted = Big.new(0)
	multiplied = Big.new(1)
	divided = Big.new(1)
	from_level = Big.new(1)
	d_from_lored = Big.new(1)
	m_from_lored = Big.new(1)
	current = Big.new(base)

