class_name LOREDContainer
extends MarginContainer



@onready var tab_container = $TabContainer
@onready var scroll_container_1 = %ScrollContainer1
@onready var scroll_container_2 = %ScrollContainer2
@onready var scroll_container_3 = %ScrollContainer3
@onready var scroll_container_4 = %ScrollContainer4

signal lored_vicos_ready
signal lored_details_requested(lored)



func _ready():
	_on_tab_container_tab_changed(0)
	for lored in lv.get_all_loreds():
		var node = get_node("%" + lored.key)
		lored.attach_vico(node)
		connect("lored_vicos_ready", lored.lored_vicos_ready)
		node.lored_details_requested.connect(emit_details)
	emit_signal("lored_vicos_ready")
	
	for i in range(1, 5):
		var color = gv.get_stage_color(i)
		get("scroll_container_" + str(i)).get_v_scroll_bar().modulate = color
		if get("scroll_container_" + str(i)).has_node("SubViewportContainer"):
			get("scroll_container_" + str(i)).get_node("SubViewportContainer").size.y = get("scroll_container_" + str(i)).get_node("SubViewportContainer/SubViewport/MarginContainer").size.y
	
	hide_all_vbox_and_hbox_containers()



func _on_tab_container_tab_changed(tab):
	gv.selected_stage = tab + 1
	var color = gv.get_stage_color(gv.selected_stage)
	tab_container.add_theme_color_override("font_selected_color", color)
	gv.clear_tooltip()



func select_stage(stage: int) -> void:
	tab_container.current_tab = stage - 1


func hide_all_vbox_and_hbox_containers(node: Node = self) -> void:
	if node is LOREDVico:
		return
	if node is HBoxContainer or node is VBoxContainer:
		node.hide()
	for child in node.get_children():
		hide_all_vbox_and_hbox_containers(child)


func emit_details(lored: LORED) -> void:
	lored_details_requested.emit(lored)
