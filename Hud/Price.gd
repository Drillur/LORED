class_name PriceVico
extends MarginContainer



@onready var icon = %Icon
@onready var eta = %Eta
@onready var content_parent = %"Content Parent"
@onready var price_and_currency = preload("res://Hud/price_and_currency.tscn")
var content := {}

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
	set_eta_text()


func reconnect() -> void:
	for node in content.values():
		node.connect("currency_changed", set_eta_text)



func set_icon_color(color: Color) -> void:
	icon.self_modulate = color



func set_eta_text() -> void:
	var _eta = cost.get_eta()
	if _eta.equal(0):
		eta.hide()
		return
	eta.show()
	eta.text = "[right]" + gv.parse_time(_eta)


func flash():
	if cost.affordable:
		flash_became_affordable()
	else:
		# content[cur] is price_and_currency
		for cur in cost.get_insufficient_currencies():
			content[cur].flash()


func flash_became_affordable() -> void:
	for cur in content.values():
		gv.flash(cur, Color(0, 1, 0))
		#cur.flash_became_affordable()
