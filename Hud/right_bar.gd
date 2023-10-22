class_name RightBar
extends MarginContainer



enum Tabs { LORED_DETAILS, }

@onready var background = %Background
@onready var title_button = %"Title Button"
@onready var title_background = %"Title Background"
@onready var scroll = %Scroll
@onready var tabs = %Tabs

var lored: LORED

var color: Color:
	set(val):
		color = val
		background.modulate = val
		title_background.modulate = val



func _ready():
	hide()
	visibility_changed.connect(_on_visibility_changed)
	title_button.pressed.connect(clear)



func setup_lored_details(_lored: LORED):
	if _lored == lored:
		clear()
		return
	tabs.current_tab = Tabs.LORED_DETAILS
	lored = _lored
	
	color = lored.details.color
	title_button.text = "%s\n[i]%s" % [lored.details.name, lored.details.alt_name]
	
	show()


# - Action


func clear() -> void:
	call("clear_" + Tabs.keys()[tabs.current_tab].to_lower())
	hide()


# - LORED


func clear_lored_details() -> void:
	lored = null



# - Signals


func _on_visibility_changed():
	if visible:
		scroll.scroll_vertical = 0

