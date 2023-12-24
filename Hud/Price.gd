class_name PriceVico
extends MarginContainer



@onready var content_parent = %"Content Parent"
@onready var check = %Check
@onready var title_bg = %"title bg"
@onready var bar = %Bar as Bar


var content := {}

var color: Color:
	set(val):
		if color == val:
			return
		color = val
		check.self_modulate = color
		title_bg.self_modulate = color
		bar.color = color
		bar.color.a = 0.25

var cost: Cost



func setup(_cost: Cost) -> void:
	cost = _cost
	if not is_node_ready():
		await ready
	for cur in cost.cost:
		content[cur] = bag.get_resource("price_and_currency").instantiate()
		content[cur].setup(cur, cost.cost[cur])
		content_parent.add_child(content[cur])
	
	content.values()[content.size() - 1].get_node("MarginContainer").add_theme_constant_override("margin_bottom", 0)
	cost.affordable.connect_and_call("changed", affordable_changed)
	
	if cost.affordable.is_true():
		update_progress_bar()
		bar.hide_edge()
	else:
		connect_calls()



func connect_calls() -> void:
	for cur in cost.cost:
		if content[cur].is_connected("currency_changed", set_eta_text):
			return
		content[cur].connect("currency_changed", set_eta_text)
		content[cur].connect("currency_changed", update_progress_bar)


func disconnect_calls() -> void:
	check.text = ""
	for cur in cost.cost:
		if not content[cur].is_connected("currency_changed", set_eta_text):
			return
		content[cur].disconnect("currency_changed", set_eta_text)
		content[cur].disconnect("currency_changed", update_progress_bar)



func update_progress_bar() -> void:
	bar.set_deferred("progress", cost.get_progress_percent())


func set_eta_text() -> void:
	var _eta = cost.get_eta()
	if _eta.equal(0):
		check.text = ""
		return
	check.text = gv.parse_time(_eta)


func flash():
	if cost.affordable.is_true():
		flash_became_affordable()
	else:
		for cur in cost.get_insufficient_currency_types():
			content[cur].flash()


func flash_became_affordable() -> void:
	gv.flash(check, Color(0, 1, 0))


func affordable_changed() -> void:
	var val = cost.affordable.get_value()
	check.button_pressed = val
	if val:
		bar.hide_edge()
		disconnect_calls()
		flash_became_affordable()
	else:
		bar.show_edge()
		connect_calls()
		set_eta_text()
		update_progress_bar()
