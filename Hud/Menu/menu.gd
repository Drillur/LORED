extends MarginContainer



@onready var hamburger = %Hamburger as IconButton

# side bar
@onready var navigation = %Navigation
@onready var hamburger2 = %Hamburger2 as IconButton
@onready var save_button = %SaveButton
@onready var options_button = %OptionsButton
@onready var stats_button = %StatsButton
@onready var patch_button = %PatchButton
@onready var help_button = %HelpButton

# default content
@onready var game_version = %"Game Version"
@onready var discord = %Discord as TextButton
@onready var godot = %Godot as TextButton

var colors := {
	"save": Color(0.384, 0.604, 0.271),
	"options": Color(0.137, 0.698, 0.553),
	"stats": Color(0.749, 0.639, 0.035),
	"patch": Color(0.996, 0.443, 0.173),
	"help": Color(0.965, 0.522, 1),
}


func _ready():
	visibility_changed.connect(_on_visibility_changed)
	navigation.hide()
	
	game_version.text = ProjectSettings.get("application/config/Version")
	godot.text = "GODOT"
	
	hamburger.set_icon(preload("res://Sprites/Hud/Menu.png"))
	hamburger.remove_optionals()
	hamburger.modulate = Color(0, 0, 0)
	hamburger.pressed.connect(display_navigation)
	
	hamburger2.set_icon(preload("res://Sprites/Hud/Menu.png"))
	hamburger2.remove_optionals()
	hamburger2.modulate = Color(0, 0, 0)
	hamburger2.pressed.connect(display_navigation)
	save_button.modulate = colors["save"]
	options_button.modulate = colors["options"]
	stats_button.modulate = colors["stats"]
	patch_button.modulate = colors["patch"]
	help_button.modulate = colors["help"]
	
	discord.color = gv.game_color
	godot.color = Color(0.376, 0.741, 0.992)
	discord.button.connect("pressed", open_discord)
	godot.button.connect("pressed", open_godotengineorg)




func _on_fade_gui_input(event):
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		navigation.hide()


func _on_visibility_changed():
	if not visible:
		navigation.hide()



# - Actions

func open_discord() -> void:
	if not gv.dev_mode:
		OS.shell_open("https://discord.com/invite/xJeBZxt")


func open_godotengineorg() -> void:
	if not gv.dev_mode:
		OS.shell_open("https://godotengine.org")


func display_navigation() -> void:
	navigation.visible = not navigation.visible
