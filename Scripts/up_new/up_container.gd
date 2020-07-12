extends MarginContainer

onready var rt = get_node("/root/Root")

onready var gn_vbc2 = get_node("sc/v")
onready var gn_s1n_count = get_node("sc/v/s1n col/HBoxContainer/count")
onready var gn_s1m_count = get_node("sc/v/s1m col/HBoxContainer/count")
onready var gn_s2n_count = get_node("sc/v/s2n col/HBoxContainer/count")
onready var gn_s2m_count = get_node("sc/v/s2m col/HBoxContainer/count")

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
	
	sync()

func sort_ups() -> void:
	
	var f = "0"
	
	# s1M
	if true:
		
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["AUTOSHOVELER"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["SOCCER DUDE"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["IT'S GROWIN ON ME"])
		
		f = "1"
		
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["OREOREUHBor E ALICE"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["ENTHUSIASM"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["how is this an RPG anyway?"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["aw <3"])
		
		f = "2"
		
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["AUTOSTONER"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["CHUNKUS"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["you little hard worker, you"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["CON-FRICKIN-CRETE"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["OH, BABY, A TRIPLE"])
		
		f = "3"
		
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["AUTOPOLICE"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["COMPULSORY JUICE"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["BIG TOUGH BOY"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["STAY QUENCHED"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["I DRINK YOUR MILKSHAKE"])
		
		f = "4"
		
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["pippenpaddle- oppsoCOPolis"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["THE THIRD"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["ORE LORD"])
		
		f = "5"
		
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["MOIST"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["CANCER'S COOL"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["upgrade_name"])
		
		f = "6"
		
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["wtf is that musk"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["DUNKUS"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["I RUN"])
		
		f = "7"
		
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["CANKERITE"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["coal DUDE"])
		#note duplicate!get_node("sc/v/s1mup/v/t" + f).add_child(cont["I RUN"])
		
		f = "8"
		
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["SENTIENT DERRICK"])
		get_node("sc/v/s1mup/v/t" + f).add_child(cont["FOOD TRUCKS"])
	
	# s1n
	if true:
		
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["GRINDER"])
		
		f = "1"
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["GRANDER"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["LIGHTER SHOVEL"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["RYE"])
		
		f = "2"
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["GRANDMA"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["SAALNDT"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["TEXAS"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["MIXER"])
		
		f = "3"
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["GRANDPA"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["SALT"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["SAND"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["SWIRLER"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["WATT?"])
		
		f = "4"
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["GROUNDER"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["SLIMER"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["MAXER"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["CHEEKS"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["STICKYTAR"])
		
		f = "5"
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["ANCHOVE COVE"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["FLANK"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["RIB"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["GEARED OILS"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["RED GOOPY BOY"])
		
		f = "6"
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["MUD"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["THYME"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["SLOP"])
		
		f = "7"
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["PEPPER"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["GARLIC"])
		get_node("sc/v/s1nup/v/t" + f).add_child(cont["INJECT"])



func sync() -> void:
	
	gn_s1n_count.text = sync_count("s1nup")
	gn_s1m_count.text = sync_count("s1mup")
	gn_s2n_count.text = sync_count("s2nup")
	gn_s2m_count.text = sync_count("s2mup")


func sync_count(_path: String) -> String:
	
	var owned :int= gv.menu.upgrades_owned[_path]
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
