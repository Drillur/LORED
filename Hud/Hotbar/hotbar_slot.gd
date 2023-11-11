class_name HotbarSlot
extends MarginContainer



@onready var background = %Background
@onready var icon = %Icon
@onready var cooldown = %Cooldown
@onready var cooldown_progress = %"Cooldown Progress"
@onready var cooldown_text = %"Cooldown Text"
@onready var button = %Button
@onready var hotkey = %Hotkey

var ability: Job:
	set(val):
		if ability != val:
			ability = val
			pass



func _ready():
	pass


