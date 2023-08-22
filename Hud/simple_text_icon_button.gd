class_name SimpleTextIconButton
extends MarginContainer



@onready var texture_rect = %Icon
@onready var icon_shadow = %"Icon Shadow"
@onready var text_label = %"Text Label"
@onready var button = %Button

signal pressed


var icon: Texture:
	set(val):
		texture_rect.texture = val
		icon_shadow.texture = texture_rect
		show_icon()


var text: String:
	set(val):
		text_label.text = val



func _ready() -> void:
	button.pressed.connect(button_pressed)


func button_pressed():
	pressed.emit()



func hide_icon() -> void:
	texture_rect.hide()


func show_icon() -> void:
	texture_rect.show()





