extends MarginContainer



@onready var game_version = %"Game Version"
@onready var hamburger = %Hamburger
@onready var discord = %Discord as TextButton
@onready var godot = %Godot

var game_color := Color(1, 0, 0.235)



func _ready():
	game_version.text = ProjectSettings.get("application/config/Version")
	godot.text = "GODOT"
	
	hamburger.set_icon(preload("res://Sprites/Hud/Menu.png"))
	hamburger.remove_check().remove_icon_shadow()
	
	
	hamburger.modulate = Color(0, 0, 0)
	discord.color = game_color
	godot.color = Color(0.376, 0.741, 0.992)
	
	discord.button.connect("pressed", open_discord)
	godot.button.connect("pressed", open_godotengineorg)



func open_discord() -> void:
	if not gv.dev_mode:
		OS.shell_open("https://discord.com/invite/xJeBZxt")


func open_godotengineorg() -> void:
	if not gv.dev_mode:
		OS.shell_open("https://godotengine.org")
