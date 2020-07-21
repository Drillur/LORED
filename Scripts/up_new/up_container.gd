extends MarginContainer

onready var rt = get_node("/root/Root")

#var fps := 0.0

var src := {
	upgrade_slot = preload("res://Prefabs/upgrade/Upgrade Slot.tscn"),
}
var color := {
	"s1nup": Color(0.733333, 0.458824, 0.031373),
	"s1mup": Color(0.878431, 0.121569, 0.34902),
	"s2nup": Color(0.47451, 0.870588, 0.694118),
	"s2mup": Color(1, 0.541176, 0.541176),
}

var cont := {}

#func _ready() -> void:
#	rect_position = Vector2(
#		get_viewport_rect().size.x / 2 - rect_size.x / 2,
#		get_viewport_rect().size.y / 2 - rect_size.y / 2
#	)


func init() -> void:
	
#	for x in rt.upc:
#		for v in rt.upc[x]:
#
#			cont[v] = src.up_slot.instance()
#			cont[v].init(v, gv.up[v].path, rt.r_lored_color(gv.up[v].main_lored_target))
	
	var i := 0
	for x in gv.up:
		
		if "reset" in gv.up[x].type:
			continue
		
		cont[x] = src.upgrade_slot.instance()
		
		cont[x].setup(x)
		
		if i % 2 != 0:
			cont[x].get_node("m/bg").hide()
		
		if "s1 n" in gv.up[x].type:
			get_node("v/upgrades/v/s1nup/v").add_child(cont[x])
		elif "s1 m" in gv.up[x].type:
			get_node("v/upgrades/v/s1mup/v").add_child(cont[x])
		elif "s2 n" in gv.up[x].type:
			get_node("v/upgrades/v/s2nup/v").add_child(cont[x])
		elif "s2 m" in gv.up[x].type:
			get_node("v/upgrades/v/s2mup/v").add_child(cont[x])
		
		cont[x].name = x
		
		i += 1
	
	sort_ups()
	
	sync()

func sort_ups() -> void:
	
	return



func sync() -> void:
	
	get_node("top/s1nup/h/count").text = sync_count("s1nup")
	get_node("top/s1mup/h/count").text = sync_count("s1nup")
	get_node("top/s2nup/h/count").text = sync_count("s1nup")
	get_node("top/s2mup/h/count").text = sync_count("s1nup")


func sync_count(_path: String) -> String:
	
	var owned :int= gv.menu.upgrades_owned[_path]
	var total :int= get_node("v/upgrades/v/" + _path + "/v").get_child_count()
	var final_text = String(total)
	
	if owned < total * 0.9:
		final_text = "??"
		if total >= 100: final_text = "???"
	
	if get_node("v").visible:
		if get_node("v/upgrades/v/" + _path).visible:
			get_node("v/header/h/count").text = String(owned) + "/" + final_text
	
	return String(owned) + "/" + final_text


func _on_button_down() -> void:
	rt.get_node("map").status = "no"


func col_time(node: String) -> void:
	
	get_node("top").hide()
	get_node("v").show()
	get_node("v/upgrades/v/" + node).show()
	
	get_node("v/header/bg").self_modulate = color[node]
	get_node("v/header/h/icon/Sprite").self_modulate = color[node]
	
	get_node("v/header/h/text").text = get_proper_name(node)
	get_node("v/header/h/count").text = get_node("top/" + node + "/h/count").text

func get_proper_name(path: String) -> String:
	
	match path:
		"s2mup":
			return "Radiative"
		"s2nup":
			return "Extra-normal"
		"s1mup":
			return "Malignant"
		_:
			return "Normal"


func go_back():
	
	get_node("v").hide()
	for x in get_node("v/upgrades/v").get_children():
		x.hide()
	get_node("top").show()
	
	get_node("v/upgrades").scroll_vertical = 0
	
	rect_size.x = 0
	rect_position.x = get_viewport_rect().size.x / 2 - rect_size.x / 2
