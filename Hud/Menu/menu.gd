extends MarginContainer



@onready var right = %Right

@onready var hamburger = %Hamburger as IconButton
@onready var title_bg = %"title bg"
@onready var bg_shadow = %"bg shadow"
@onready var content = %Content
@onready var title = %Title
@onready var save_content = %"save Content"

# nav
@onready var option_title_bg = %"option title bg"
@onready var option_bg_shadow = %"option bg shadow"
@onready var navigation = %Navigation
@onready var hamburger2 = %Hamburger2 as IconButton
@onready var save_button = %SaveButton
@onready var options_button = %OptionsButton
@onready var stats_button = %StatsButton
@onready var patch_button = %PatchButton
@onready var help_button = %HelpButton
@onready var nav_save_icon = %"Nav Save Icon"

# default content
@onready var game_version = %"Game Version"
@onready var discord = %Discord as TextButton
@onready var godot = %Godot as TextButton

# save
@onready var save_name_label = %"Save Name Label"
@onready var save_now_button = %"Save Now Button" as IconButton
@onready var load_now_button = %"Load Now Button" as IconButton
@onready var rename_button = %"Rename Button" as IconButton
@onready var color_button = %"Color Button" as IconButton
@onready var duplicate_button = %"Duplicate Button" as IconButton
@onready var delete_button = %"Delete Button" as IconButton
@onready var hard_reset_button = %"Hard Reset Button" as IconButton
@onready var export_button = %"Export Button" as IconButton
@onready var new_game_button = %"New Game Button" as IconButton
@onready var last_save_clock = %"Last Save Clock"

var colors := {
	"game": gv.game_color,
	"save": Color(0.384, 0.604, 0.271),
	"options": Color(0.137, 0.698, 0.553),
	"stats": Color(0.749, 0.639, 0.035),
	"patch": Color(0.996, 0.443, 0.173),
	"help": Color(0.965, 0.522, 1),
}

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val
		bg_shadow.modulate = val
		option_title_bg.modulate = val
		option_bg_shadow.modulate = val



func _ready():
	
	resized.connect(_on_resized)
	_on_resized()
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
	
	
	SaveManager.save_color_changed.connect(save_color_changed)
	save_now_button.color = SaveManager.save_file_color
	hard_reset_button.color = Color(1,0,0)
	delete_button.color = Color(1,0,0)
	
	save_now_button.set_icon(gv.icon_save)
	load_now_button.set_icon(gv.icon_save)
	rename_button.set_icon(gv.icon_rename)
	color_button.set_icon(gv.icon_color)
	duplicate_button.set_icon(gv.icon_duplicate)
	delete_button.set_icon(gv.icon_delete)
	hard_reset_button.set_icon(gv.icon_hard_reset)
	export_button.set_icon(gv.icon_clipboard)
	new_game_button.set_icon(gv.icon_new_game)
	
	save_now_button.mouse_exited.connect(gv.clear_tooltip)
	save_now_button.mouse_entered.connect(save_now_tooltip)
	load_now_button.mouse_exited.connect(gv.clear_tooltip)
	load_now_button.mouse_entered.connect(load_now_tooltip)
	color_button.mouse_exited.connect(gv.clear_tooltip)
	color_button.mouse_entered.connect(color_tooltip)
	rename_button.mouse_exited.connect(gv.clear_tooltip)
	rename_button.mouse_entered.connect(rename_tooltip)
	duplicate_button.mouse_exited.connect(gv.clear_tooltip)
	duplicate_button.mouse_entered.connect(duplicate_tooltip)
	delete_button.mouse_exited.connect(gv.clear_tooltip)
	delete_button.mouse_entered.connect(delete_tooltip)
	hard_reset_button.mouse_exited.connect(gv.clear_tooltip)
	hard_reset_button.mouse_entered.connect(hard_reset_tooltip)
	new_game_button.mouse_entered.connect(new_game_tooltip)
	new_game_button.mouse_exited.connect(gv.clear_tooltip)
	export_button.mouse_exited.connect(gv.clear_tooltip)
	export_button.mouse_entered.connect(export_tooltip)
	
	SaveManager.save_finished.connect(update_last_save_clock)
	gv.one_second.connect(update_last_save_clock)
	visibility_changed.connect(update_last_save_clock)
	save_now_button.pressed.connect(save_game)
	
	hard_reset_button.pressed.connect(hard_reset)
	
	
	select_content("game")
	




# - Signal

func save_color_changed(_color: Color) -> void:
	while _color.r + _color.g + _color.b < 1:
		_color.r = min(1, _color.r * 1.15)
		_color.g = min(1, _color.g * 1.15)
		_color.b = min(1, _color.b * 1.15)
	save_now_button.color = _color
	nav_save_icon.modulate = _color
	save_name_label.modulate = _color
	colors["save"] = _color
	if save_content.visible:
		color = _color


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


func _on_resized() -> void:
	right.position.x = size.x + 10


func _on_save_button_pressed():
	select_content("save")


func delete_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.JUST_TEXT, right, {"text": "[b]Delete your save file from your system.[/b] This does [i]not[/i] perform a hard reset.", "color": Color(1,0,0)})


func save_now_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.JUST_TEXT, right, {"text": "Save now!", "color": SaveManager.save_file_color})


func color_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.JUST_TEXT, right, {"text": "Change the save color.", "color": SaveManager.save_file_color})


func duplicate_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.JUST_TEXT, right, {"text": "Duplicate your save file as it is currently.", "color": SaveManager.save_file_color})


func load_now_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.JUST_TEXT, right, {"text": "Go to the Load menu!", "color": Color(1,1,1)})


func rename_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.JUST_TEXT, right, {"text": "Rename your save file.", "color": SaveManager.save_file_color})


func new_game_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.JUST_TEXT, right, {"text": "Go to the New Game menu!", "color": Color(1,1,1)})


func export_tooltip() -> void:
	if gv.PLATFORM == gv.Platform.HTML:
		gv.new_tooltip(gv.Tooltip.JUST_TEXT, right, {"text": "Export your save to the browser's console. To view the console, press Ctrl-Shift-J.", "color": SaveManager.save_file_color})
	elif gv.PLATFORM == gv.Platform.PC:
		gv.new_tooltip(gv.Tooltip.JUST_TEXT, right, {"text": "Export your save to your operating system's clipboard.", "color": SaveManager.save_file_color})


func hard_reset_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.JUST_TEXT, right, {"text": "Perform a hard reset, resetting the everything as if it were a new game. (To be thorough and avoid possible bugs: After you perform a hard reset, refresh the page.)", "color": Color(1,0,0)})



func update_last_save_clock() -> void:
	if visible:
		var parsed_delta = gv.parse_time(
			Big.new(SaveManager.get_time_since_last_save())
		)
		if parsed_delta in ["", "!"]:
			last_save_clock.text = "Just saved!"
		else:
			last_save_clock.text = "[b]" + parsed_delta + "[/b] since last save!"



# - Actions

func select_content(cont: String) -> void:
	navigation.hide()
	color = colors[cont]
	for node in content.get_children():
		if not cont in node.name:
			node.hide()
		else:
			node.show()
	
	match cont:
		"game":
			title.text = "LORED"
		"stats":
			title.text = "Statistics"
		"save":
			title.text = "Save"
		"options":
			title.text = "Options"
		"patch":
			title.text = "Patch Notes"
		"help":
			title.text = "Help"
	
	if cont == "game":
		game_version.show()
	else:
		game_version.hide()


func open_discord() -> void:
	if not gv.dev_mode:
		OS.shell_open("https://discord.com/invite/xJeBZxt")


func open_godotengineorg() -> void:
	if not gv.dev_mode:
		OS.shell_open("https://godotengine.org")


func display_navigation() -> void:
	navigation.visible = not navigation.visible



func hard_reset() -> void:
	gv.hard_reset_now()



func save_game() -> void:
	SaveManager.save_game()
