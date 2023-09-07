class_name AttributeTextVico
extends MarginContainer



@onready var current = %Current
@onready var slash = $HBoxContainer/Slash
@onready var total = %Total

var attribute: ValuePair
var prepended_text: String



func setup(_att: ValuePair, _prepended_text := "") -> void:
	attribute = _att
	prepended_text = _prepended_text
	
	attribute.connect("current_changed", update_current)
	attribute.connect("total_changed", update_total)
	
	update_current()
	update_total()


func update_total() -> void:
	total.text = prepended_text + attribute.get_total_text()


func update_current() -> void:
	current.text = attribute.get_current_text()
