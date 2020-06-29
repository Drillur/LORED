extends MarginContainer

onready var rt = get_node("/root/Root")

onready var gn_vbc2 = get_node("ScrollContainer/VBoxContainer2")
onready var gn_s1n_count = get_node("ScrollContainer/VBoxContainer2/s1n col/HBoxContainer/count")
onready var gn_s1m_count = get_node("ScrollContainer/VBoxContainer2/s1m col/HBoxContainer/count")
onready var gn_s2n_count = get_node("ScrollContainer/VBoxContainer2/s2n col/HBoxContainer/count")
onready var gn_s2m_count = get_node("ScrollContainer/VBoxContainer2/s2m col/HBoxContainer/count")

#var fps := 0.0

var src := {
	up_slot = preload("res://Prefabs/upgrade/upgrade.tscn"),
}

var cont := {}

#func _ready() -> void:
#	rect_position = Vector2(
#		get_viewport_rect().size.x / 2 - rect_size.x / 2,
#		get_viewport_rect().size.y / 2 - rect_size.y / 2
#	)


func init() -> void:
	
	for x in rt.upc:
		for v in rt.upc[x]:
			
			cont[v] = src.up_slot.instance()
			cont[v].init(v, gv.up[v].path, rt.r_lored_color(gv.up[v].main_lored_target))
	
	sort_ups()
	
	sync_self()

func sort_ups() -> void:
	
	$ScrollContainer/VBoxContainer2/s1nup/v/t0.add_child(cont["GRINDER"])
	
	
	$ScrollContainer/VBoxContainer2/s1nup/v/t1.add_child(cont["LIGHTER SHOVEL"])
	$ScrollContainer/VBoxContainer2/s1nup/v/t1.add_child(cont["RYE"])
	$ScrollContainer/VBoxContainer2/s1nup/v/t1.add_child(cont["GRANDER"])



func sync_self() -> void:
	
	gn_s1n_count.text = sync_count("s1nup")
	gn_s1m_count.text = sync_count("s1mup")
	gn_s2n_count.text = sync_count("s2nup")
	gn_s2m_count.text = sync_count("s2mup")


func sync_count(_path: String) -> String:
	
	var owned :int= rt.menu.upgrades_owned[_path]
	var total :int= rt.upc[_path].size()
	var final_text = String(total)
	
	if owned < total * 0.9:
		final_text = "??"
		if total >= 100: final_text = "???"
	
	return String(owned) + "/" + final_text


func _on_button_down() -> void:
	rt.get_node("map").status = "no"


func col_time(node: String) -> void:
	if get_node(node).visible:
		get_node(node).hide()
		rect_size.x = 0
		return
	get_node(node).show()
