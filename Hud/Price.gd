class_name PriceVico
extends MarginContainer



@onready var price_and_currency = preload("res://Hud/price_and_currency.tscn")
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
		content[cur] = price_and_currency.instantiate()
		content[cur].setup(cur, cost.cost[cur])
		content_parent.add_child(content[cur])
	
	bar.hide_background().remove_markers()
	bar.set_initial_progress(cost.get_progress_percent())
	
	content.values()[content.size() - 1].get_node("MarginContainer").add_theme_constant_override("margin_bottom", 0)
	cost.connect("became_affordable", flash_became_affordable)
	cost.connect("affordable_changed", affordable_changed)
	affordable_changed(cost.affordable)
	set_eta_text()
	
	if cost.affordable:
		bar.hide_edge()
		bar.set_deferred("progress", 1.0)
	else:
		connect_calls()
	
	cost.connect("became_affordable", became_affordable)
	cost.connect("became_unaffordable", became_unaffordable)
	
	bar.set_deferred("animating_changes", true)



func update_progress_bar() -> void:
	bar.progress = cost.get_progress_percent()


func became_affordable() -> void:
	bar.hide_edge()
	disconnect_calls()


func became_unaffordable() -> void:
	bar.show_edge()
	connect_calls()
	set_eta_text()
	update_progress_bar()


func connect_calls() -> void:
	for cur in cost.cost:
		content[cur].connect("currency_changed", set_eta_text)
		content[cur].connect("currency_changed", update_progress_bar)


func disconnect_calls() -> void:
	for cur in cost.cost:
		content[cur].disconnect("currency_changed", set_eta_text)
		content[cur].disconnect("currency_changed", update_progress_bar)



func set_eta_text() -> void:
	var _eta = cost.get_eta()
	if _eta.equal(0):
		check.text = ""
		return
	check.text = gv.parse_time(_eta)


func flash():
	if cost.affordable:
		flash_became_affordable()
	else:
		# content[cur] is price_and_currency
		for cur in cost.get_insufficient_currency_types():
			content[cur].flash()


func flash_became_affordable() -> void:
	gv.flash(check, Color(0, 1, 0))


func affordable_changed(affordable: bool) -> void:
	check.button_pressed = affordable
