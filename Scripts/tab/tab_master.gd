extends Node2D

onready var rt = get_owner()
onready var b_upgrade_tab = preload("res://Prefabs/tab/b_upgrade_tab.tscn")
onready var b_lored_tab = preload("res://Prefabs/tab/b_lored_tab.tscn")

var up := {}
var lored := {}

func init():
	
	# init
	for x in 2:
		
		# lored
		huge_poopy_butt(str(x + 1))
		
		# up
		giant_peepee(str(x + 1))
	
	# lored
	if true:
		
		if not rt.tasks["Welcome to LORED"].complete:
			lored["1"].hide()

func huge_poopy_butt(path: String) -> void:
	
	lored[path] = b_lored_tab.instance()
	lored[path].name = path
	add_child(lored[path])
	lored[path].init(path, gv.sprite["s" + path], gonna_send_unlock(path))
	
	if path == "1":
		lored[path].r_update(true)
		return
	
	lored[path].r_update(false)

func giant_peepee(tab: String) -> void:
	
	lil_helper_bitch("s" + tab + "nup")
	lil_helper_bitch("s" + tab + "mup")

func lil_helper_bitch(path : String) -> void:
	
	up[path] = b_upgrade_tab.instance()
	up[path].name = path
	add_child(up[path])
	
	var color := Color(0.5, 0.5, 0.5)
	
	match path:
		"s1nup":
			up[path].init(KEY_Q, gv.sprite[path], gonna_send_unlock(path), color, path[1])
		"s1mup":
			up[path].init(KEY_W, gv.sprite[path], gonna_send_unlock(path), rt.r_lored_color("malig"), path[1])
		"s2nup":
			up[path].init(KEY_E, gv.sprite[path], gonna_send_unlock(path), color, path[1])
		"s2mup":
			up[path].init(KEY_R, gv.sprite[path], gonna_send_unlock(path), rt.r_lored_color("tum"), path[1])

func gonna_send_unlock(f : String) -> bool:
	
	if gv.menu.tabs_unlocked[f]: return true
	return false

func unlock(type := ["all"]) -> void:
	
	if type[0] == "all":
		type.clear()
		for x in gv.menu.tabs_unlocked:
			type.append(x)
	
	for x in type:
		
		if gv.menu.tabs_unlocked[x]: continue
		
		gv.menu.tabs_unlocked[x] = true
		
		# upgrade
		if x[0] == "s": lil_helper_bitch(x)
		if x in up.keys():
			up[x].show()
		
		# lored
		if x in lored.keys():
			lored[x].show()
func reset(type := ["all"]) -> void:
	
	if type[0] == "all":
		for x in gv.menu.tabs_unlocked:
			gv.menu.tabs_unlocked[x] = false
		for x in up:
			up[x].hide()
		for x in lored:
			lored[x].hide()
		
		return
	
	for x in type:
		gv.menu.tabs_unlocked[x] = false
		if x in up.keys():
			up[x].hide()
		if x in lored.keys():
			lored[x].hide()
