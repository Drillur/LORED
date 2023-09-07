extends MarginContainer



@onready var bg_shadow = %"bg shadow"
@onready var title_bg = %"title bg"

@onready var date = %Date
@onready var time_played = %"Time Played"
@onready var difficulty = %Difficulty
@onready var date_icon = %"Date Icon"
@onready var time_played_icon = %"Time Played Icon"
@onready var difficulty_icon = %"Difficulty Icon"

@onready var play_button = %Play as IconButton
@onready var rename_button = %Rename as IconButton
@onready var color_button = %Color as IconButton
@onready var duplicate_button = %Duplicate as IconButton
@onready var delete_button = %Delete as IconButton



var color: Color:
	set(val):
		color = val
		title_bg.modulate = val
		date_icon.modulate = val
		difficulty_icon.modulate = val
		time_played_icon.modulate = val
		play_button.color = val



func _ready() -> void:
	play_button.remove_check().remove_autobuyer()
	rename_button.remove_check().remove_autobuyer()
	color_button.remove_check().remove_autobuyer()
	duplicate_button.remove_check().remove_autobuyer()
	delete_button.remove_check().remove_autobuyer()
	
	play_button.set_icon(gv.icon_play)
	rename_button.set_icon(gv.icon_rename)
	color_button.set_icon(gv.icon_color)
	duplicate_button.set_icon(gv.icon_duplicate)
	delete_button.set_icon(gv.icon_delete)
	
	#play_button.color = Color(0, 1, 0)
	delete_button.color = Color(1, 0, 0)
	
	SaveManager.save_color_changed.connect(save_color_changed)
	color = SaveManager.save_file_color



func save_color_changed(_color: Color) -> void:
	color = _color
