class_name AttributeTextVico
extends MarginContainer



@onready var current = %Current
@onready var slash = $HBoxContainer/Slash
@onready var total = %Total

var attribute: Attribute
var prepended_text: String



func setup(_att: Attribute, _prepended_text := "") -> void:
	attribute = _att
	prepended_text = _prepended_text
	if not attribute.uses_current:
		if not is_node_ready():
			await ready
		current.queue_free()
		slash.queue_free()
	attribute.add_notify_change_method(update, true)


func update() -> void:
	if attribute.uses_current:
		current.text = attribute.get_current_text()
	total.text = prepended_text + attribute.get_total_text()
