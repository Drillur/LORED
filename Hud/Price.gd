class_name PriceVico
extends MarginContainer



@onready var icon = %Icon
@onready var content_parent = %"Content Parent"
@onready var price_and_currency = preload("res://Hud/price_and_currency.tscn")
@onready var check = %Check
@onready var title_bg = %"title bg"


var content := {}

var color: Color:
	set(val):
		if color == val:
			return
		color = val
		check.self_modulate = color
		title_bg.self_modulate = color

var cost: Cost



func setup(_cost: Cost) -> void:
	cost = _cost
	if not is_node_ready():
		await ready
	for cur in cost.cost:
		content[cur] = price_and_currency.instantiate()
		content[cur].setup(cur, cost.cost[cur])
		content_parent.add_child(content[cur])
		content[cur].connect("currency_changed", set_eta_text)
	content.values()[content.size() - 1].get_node("MarginContainer").add_theme_constant_override("margin_bottom", 0)
	cost.connect("became_affordable", flash_became_affordable)
	cost.connect("affordable_changed", affordable_changed)
	affordable_changed(cost.affordable)
	set_eta_text()


func reconnect() -> void:
	for node in content.values():
		node.connect("currency_changed", set_eta_text)



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
