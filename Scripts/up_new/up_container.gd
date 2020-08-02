extends MarginContainer

onready var rt = get_node("/root/Root")



#var fps := 0.0



var src := {
	upgrade_slot = preload("res://Prefabs/upgrade/Upgrade Slot.tscn"),
}

var color := {
	"s1n": Color(0.733333, 0.458824, 0.031373),
	"s1m": Color(0.878431, 0.121569, 0.34902),
	"s2n": Color(0.47451, 0.870588, 0.694118),
	"s2m": Color(1, 0.541176, 0.541176),
}

var cont := {}
var cont_flying_texts := {}


const gnBack_arrow := "v/header/h/v/m/h/icon/Sprite"
const gnTitle_text := "v/header/h/v/m/h/text"
const gncount := "v/header/h/v/m/h/count"
const gnowned := "v/header/h/v/options/owned"
const gnunowned := "v/header/h/v/options/unowned"
const gnlocked := "v/header/h/v/options/locked"
const gnIcon := "v/header/h/icon/Sprite"

const gnreset := "v/reset/b_reset"
const gnfinalize := "v/reset/cancel/h/finalize"

#var current_folder := "" # s1n, s2m, etc. which one is visible?



func _ready():
	
	$v.hide()
	$top.show()
	
	get_node("top/s1m").hide()
	get_node("top/s2n").hide()
	get_node("top/s2m").hide()
	
	gv.connect("upgrade_purchased", self, "upgrade_purchased")


func init() -> void:
	
	var i := 0
	for x in gv.up:
		
		if "reset" in gv.up[x].type:
			continue
		
		cont[x] = src.upgrade_slot.instance()
		
		var folder: String = gv.up[x].type.split(" ", true, 1)[0]
		cont[x].setup(x, folder)
		get_node("v/upgrades/v/" + folder + "/v").add_child(cont[x])
		
		cont[x].name = x
		
		i += 1
	
	sort_ups()
	
	sync()
	
	r_update()
	
	_on_display_pressed()

func sort_ups() -> void:
	
	var qualities := []
	
	# first, assign a value to each upgrade
	for z in get_node("v/upgrades/v").get_child_count():
		
		qualities.append([])
		
		for x in get_node("v/upgrades/v").get_child(z).get_node("v").get_child_count():
			qualities[z].append(get_upgrade_quality(get_node("v/upgrades/v").get_child(z).get_node("v").get_child(x).name))
	
	# example: quality[0][14] = quality (big)
	
	for folder in qualities.size():
		
		# this is basically referring to the children of get_node("v/upgrades/v")
		
		for z in qualities[folder].size() - 1:
			for x in qualities[folder].size() - 1:
				
				if qualities[folder][x].isLessThanOrEqualTo(qualities[folder][x + 1]):
					continue
				
				var temp = Big.new(qualities[folder][x + 1])
				
				# swap x+1 to x
				qualities[folder][x + 1] = qualities[folder][x]
				var node = get_node("v/upgrades/v").get_child(folder).get_node("v").get_child(x + 1)
				get_node("v/upgrades/v").get_child(folder).get_node("v").move_child(node, x)
				
				qualities[folder][x] = temp

const LOW_QUALITY = ["coal", "irono", "copo", "jo", "oil", "tar", "draw", "sand", "seed", "soil", "humus", "pet", "plast", "ciga", "toba", "paper", "pulp", "gale", "soil"]
const MED_QUALITY = ["conc", "growth", "iron", "cop", "stone", "liq", "steel", "glass", "wire", "hard", "wood", "axe", "tree", "lead", "water"]
#const HI_QUALITY = ["malig", "tum", "carc"] # not necessary to define

func get_upgrade_quality(_key) -> Big:
	
	var quality = Big.new(0)
	
	for x in gv.up[_key].cost:
		
		if x in LOW_QUALITY:
			quality.a(gv.up[_key].cost[x].t)
		elif x in MED_QUALITY:
			quality.a(Big.new(gv.up[_key].cost[x].t).m(10))
		else:
			quality.a(Big.new(gv.up[_key].cost[x].t).m(100))
	
	return quality


func sync() -> void:
	
	get_node("top/s1n/h/count").text = sync_count("s1n")
	get_node("top/s1m/h/count").text = sync_count("s1m")
	get_node("top/s2n/h/count").text = sync_count("s2n")
	get_node("top/s2m/h/count").text = sync_count("s2m")


func sync_count(_path: String) -> String:
	
	var owned :int= gv.menu.upgrades_owned[_path]
	var total :int= get_node("v/upgrades/v/" + _path + "/v").get_child_count()
	var final_text := str(total)
	
	if owned < total * 0.9:
		final_text = "??"
		if total >= 100: final_text = "???"
	
	if get_node("v").visible:
		if get_node("v/upgrades/v/" + _path).visible:
			get_node(gncount).text = str(owned) + "/" + final_text
	
	return str(owned) + "/" + final_text


func _on_button_down() -> void:
	#note remove upon implementation of new lored ui, then delete onready var rt at top
	rt.get_node("map").status = "no"


func _on_display_pressed() -> void:
	for z in get_node("v/upgrades/v").get_children():
		for x in z.get_node("v").get_children():
			x.visible = display(x)


func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")

func _on_b_reset_mouse_entered() -> void:
	
	if gv.open_upgrade_folder == "no":
		return
	
	var reset_name: String = get_node(gnreset + "/Label").text.to_upper()
	
	rt.get_node("global_tip")._call("buy upgrade " + reset_name)

func _on_finalize_mouse_entered() -> void:
	
	if gv.open_upgrade_folder == "no":
		return
	
	var finalize_name: String = get_node(gnfinalize + "/Label").text.split(" ")[0].to_upper()
	
	rt.get_node("global_tip")._call("buy upgrade " + finalize_name)


func _on_b_reset_pressed() -> void:
	
	r_reset("resetting")
	rt.get_node("global_tip")._call("no")
	
	gv.menu.f = "no s" + gv.open_upgrade_folder[1]

func _on_finalize_pressed() -> void:
	
	r_reset("finalize")
	
	rt.reset(int(gv.menu.f[4]))

func _on_b_cancel_pressed() -> void:
	
	for x in gv.stats.up_list[gv.menu.f.split("no ")[1] + "m"]:
		
		if not gv.up[x].refundable:
			continue
		
		gv.up[x].refundable = false
		cont[x].tags()
		cont[x]._kill_all_children(x)
	
	update_folder()
	
	r_reset("cancel reset")



func r_reset(type: String):
	
	match type:
		
		"finalize":
			
			get_node("v/reset/cancel").hide()
			get_node(gnreset).show()
			go_back()
			hide()
		
		"cancel reset":
			
			get_node("v/reset/cancel").hide()
			get_node(gnreset).show()
			
			gv.menu.f = "ye"
			
			r_setup_setup()
		
		"resetting":
			
			get_node(gnreset).hide()
			get_node("v/reset/cancel").show()
		
		"setup":
			
			if ("ye" in gv.menu.f) or ("no" in gv.menu.f and gv.open_upgrade_folder[1] == gv.menu.f[4]):
				
				r_setup_setup()
			
			else:
				
				get_node("v/reset/cancel/h/finalize").hide()
				return

func r_setup_setup():
	
	if gv.open_upgrade_folder in ["s1n", "s2n"] or gv.open_upgrade_folder == "s1m" and gv.up["RED NECROMANCY"].active():
		
		get_node("v/reset").hide()
		
		return
	
	var mod_color: Color
	var reset_name: String
	var finalize_name: String
	
	if gv.open_upgrade_folder == "s1m":
		mod_color = gv.g["malig"].color
		reset_name = "Metastasize"
		finalize_name = "Spread (Reset Stage 1)"
	elif gv.open_upgrade_folder == "s2m":
		mod_color = gv.g["tum"].color
		reset_name = "Chemotherapy"
		finalize_name = "Recover (Reset Stage 1 & 2)"
	
	get_node("v/reset").show()
	get_node("v/reset/cancel/h/finalize").show()
	
	get_node("v/reset/bg").self_modulate = mod_color
	get_node(gnreset + "/Label").self_modulate = mod_color
	get_node(gnfinalize + "/Label").self_modulate = mod_color
	
	get_node(gnreset + "/Label").text = reset_name
	get_node(gnfinalize + "/Label").text = finalize_name
	
	if not "ye" in gv.menu.f:
		r_reset("resetting")
	


func display(node) -> bool:
	
	match get_node(gnowned).pressed:
		true:
			match get_node(gnunowned).pressed:
				true:
					match get_node(gnlocked).pressed:
						true:
							return true
						false:
							return node.requirements() # hiding 1
				false:
					match get_node(gnlocked).pressed:
						true:
							return gv.up[node.name].have # hiding 1
						false:
							return gv.up[node.name].have and node.requirements() # hiding 2
		false:
			match get_node(gnunowned).pressed:
				true:
					match get_node(gnlocked).pressed:
						true:
							if gv.up[node.name].have:
								return false
							else:
								return true
						false:
							if not node.requirements():
								return false
							if gv.up[node.name].have:
								return false
							else:
								return true
	return false


func col_time(node: String) -> void:
	
	show()
	
	get_node("top").hide()
	get_node("v").show()
	
	gv.open_upgrade_folder = node
	
	for x in get_node("v/upgrades/v").get_children():
		if x.name == node:
			x.show()
		else:
			x.hide()
	
	get_node(gnIcon).texture = gv.sprite[gv.open_upgrade_folder]
	
	get_node("v/header/bg").self_modulate = color[node]
	get_node(gnBack_arrow).self_modulate = color[node]
	
	get_node(gnTitle_text).text = get_proper_name(node)
	get_node(gncount).text = get_node("top/" + node + "/h/count").text
	
	clear_tip_n_stuff()
	
	update_folder()
	
	r_reset("setup")

func get_proper_name(path: String) -> String:
	
	match path:
		"s2m":
			return "Radiative"
		"s2n":
			return "Extra-normal"
		"s1m":
			return "Malignant"
		_:
			return "Normal"


func go_back():
	
	if gv.open_upgrade_folder == "no":
		return
	
	clear_tip_n_stuff()
	
	get_node("v").hide()
	
	for x in get_node("v/upgrades/v").get_children():
		x.hide()
	get_node("top").show()
	
	get_node("v/upgrades").scroll_vertical = 0
	
	gv.open_upgrade_folder = "no"
	
	rect_size.x = 0


func clear_tip_n_stuff():
	
	if not is_instance_valid(rt.get_node("global_tip").tip):
		return
	
	if "upgrade" in rt.get_node("global_tip").tip.type:
		var key = rt.get_node("global_tip").tip.type.split("upgrade ")[1]
		if key in cont.keys():
			cont[key]._on_Select_mouse_exited()
	
	rt.get_node("global_tip")._call("no")



func r_update(which := []):
	
	if which == []:
		for x in get_node("v/upgrades/v").get_children():
			which.append(x.name)
	
	
	for x in which:
		
		for u in get_node("v/upgrades/v/" + x + "/v").get_children():
			
			u.r_update()


func upgrade_purchased(key: String, routine := []):
	
	# catches
	if cont[key].folder != gv.open_upgrade_folder:
		return
	if not visible:
		return
	
	update_folder()
	
	
	
	# flying texts below
	
	var rollx :int= rand_range(-10, 10) + get_global_mouse_position().x - rect_position.x
	var rolly :int= rand_range(-10, 10) + get_global_mouse_position().y - rect_position.y
	
	var i := 0
	
	if key == "ROUTINE" and gv.up["PROCEDURE"].active():
		
		cont_flying_texts["(upgrade purchased flying text)" + str(i)] = rt.prefab["dtext"].instance()
		cont_flying_texts["(upgrade purchased flying text)" + str(i)].init(false, -50, "+ " + routine[0].toString(), gv.sprite["tum"], gv.g["tum"].color)
		cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(
			rollx, 
			rolly
		)
		$flying_texts.add_child(cont_flying_texts["(upgrade purchased flying text)" + str(i)])
		
		i += 1
	
	for x in gv.up[key].cost:
		
		var t = Timer.new()
		t.set_wait_time(0.02)
		t.set_one_shot(true)
		add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		# dtext
		cont_flying_texts["(upgrade purchased flying text)" + str(i)] = rt.prefab["dtext"].instance()
		
		var _text = "- " + gv.up[key].cost[x].t.toString()
		if key == "ROUTINE":
			_text = "- " + routine[1].toString()
		
		cont_flying_texts["(upgrade purchased flying text)" + str(i)].init(false, -50, _text, gv.sprite[x], gv.g[x].color)
		
		if i == 0:
			cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(
				rollx,
				rolly
			)
		else:
			
			for v in i:
				if not "(upgrade purchased flying text)" + str(v) in cont_flying_texts.keys():
					return
				cont_flying_texts["(upgrade purchased flying text)" + str(v)].rect_position.y -= 7
			
			cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(
				cont_flying_texts["(upgrade purchased flying text)" + str(i-1)].rect_position.x,
				cont_flying_texts["(upgrade purchased flying text)" + str(i-1)].rect_position.y + cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_size.y
			)
		
		$flying_texts.add_child(cont_flying_texts["(upgrade purchased flying text)" + str(i)])
		
		i += 1


func update_folder():
	
	for x in get_node("v/upgrades/v/" + gv.open_upgrade_folder + "/v").get_children():
		x.visible = display(x)
		x.r_update()

func clear_alerts():
	
	for x in gv.up:
		
		if not x in cont.keys():
			continue
		
		cont[x].alert(false)
		cont[x].already_displayed_alert_guy = false

func alert(show: bool, key := ""):
	
	
	if show and key != "":
		cont[key].alert(show)
	
	var folder = gv.up[key].type.split(" ")[0]
	get_node("top/" + folder + "/h/alert").visible = show





