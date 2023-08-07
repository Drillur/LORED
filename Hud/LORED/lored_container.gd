class_name LOREDContainer
extends MarginContainer



@onready var tab_container = $TabContainer
signal lored_vicos_ready



func _ready():
	_on_tab_container_tab_changed(0)
	for lored in lv.loreds.values():
		lored.attach_vico(get_node("%" + lored.key))
		connect("lored_vicos_ready", lored.lored_vicos_ready)
	emit_signal("lored_vicos_ready")



func _input(_event) -> void:
	if Input.is_action_just_pressed("1"):
		tab_container.current_tab = 0
		return
	if Input.is_action_just_pressed("2"):
		tab_container.current_tab = 1
		return
	if Input.is_action_just_pressed("3"):
		tab_container.current_tab = 2
		return
	if Input.is_action_just_pressed("4"):
		tab_container.current_tab = 3
		return



func _on_tab_container_tab_changed(tab):
	gv.selected_stage = tab + 1
	var color = gv.STAGE_COLORS[gv.selected_stage]
	tab_container.add_theme_color_override("font_selected_color", color)
	gv.clear_tooltip()

