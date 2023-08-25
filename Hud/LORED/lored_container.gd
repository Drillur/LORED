class_name LOREDContainer
extends MarginContainer



@onready var tab_container = $TabContainer
@onready var scroll_container_1 = %ScrollContainer1
@onready var scroll_container_2 = %ScrollContainer2
@onready var scroll_container_3 = %ScrollContainer3
@onready var scroll_container_4 = %ScrollContainer4

signal lored_vicos_ready



func _ready():
	_on_tab_container_tab_changed(0)
	for lored in lv.loreds.values():
		lored.attach_vico(get_node("%" + lored.key))
		connect("lored_vicos_ready", lored.lored_vicos_ready)
	emit_signal("lored_vicos_ready")
	
	for i in range(1, 5):
		var color = gv.get_stage_color(i)
		get("scroll_container_" + str(i)).get_v_scroll_bar().modulate = color



func _on_tab_container_tab_changed(tab):
	gv.selected_stage = tab + 1
	var color = gv.get_stage_color(gv.selected_stage)
	tab_container.add_theme_color_override("font_selected_color", color)
	gv.clear_tooltip()



func select_stage(stage: int) -> void:
	tab_container.current_tab = stage - 1
