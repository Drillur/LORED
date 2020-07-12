extends Button

onready var cannot_deactivate_prefab = preload("res://Prefabs/lored_buy.tscn")

var content := {}

onready var rt = get_node("/root/Root")
var fps := 0.0

var my_upgrade : String
var my_path : String

var afford_alert_displayed := false
var modulated_one_last_time := false

var routine := []



func _ready():
	
	focus_mode = 0



func init(name : String, path : String, border_color : Color) -> void:
	
	my_upgrade = name
	my_path = path
	$border.self_modulate = border_color
	
	r_set_shadow("not owned")
	r_update()


func _physics_process(delta):
	
	if modulated_one_last_time:
		return
	
	if gv.up[my_upgrade].have:
		self_modulate = Color(1,1,1)
		modulated_one_last_time = true
		return
	
	# the code below highlights the button in red if the player cannot afford it
	
	if not "s" in gv.menu.tab:
		return
	
	fps += delta
	if fps < rt.FPS: return
	fps -= rt.FPS
	
	self_modulate = rt.r_buy_color(1, my_upgrade, gv.up[my_upgrade].type)

func r_update() -> void:
#
#	show()
#	$icon.set_texture(gv.sprite[gv.up[my_upgrade].main_lored_target])
#	return
	
	# display
	if not "mup" in gv.up[my_upgrade].type:
		
		var going_to_hide : bool = false
		var going_to_show : bool = false
		
		if gv.up[my_upgrade].requires == "":
			going_to_show = true
		else:
			if not gv.up[gv.up[my_upgrade].requires].have or gv.up[gv.up[my_upgrade].requires].refundable:
				going_to_hide = true
			else:
				going_to_show = true
		if going_to_hide:
			if gv.up[gv.up[my_upgrade].requires].requires == "" or gv.up[gv.up[gv.up[my_upgrade].requires].requires].have or gv.up[gv.up[gv.up[my_upgrade].requires].requires].refundable:
				going_to_hide = false
				going_to_show = true
		
		if going_to_hide:
			hide()
		
		if going_to_show:
			show()
		
		if going_to_hide and going_to_show:
			print("for fuck's sake, you idiot")
	
	# set icon
	if true:
		
		if not gv.up[my_upgrade].have and not gv.up[my_upgrade].requires == "":
			if not gv.up[my_upgrade].icon_set and not gv.up[gv.up[my_upgrade].requires].have and not gv.up[gv.up[my_upgrade].requires].refundable:
				$icon.set_texture(gv.sprite["unknown"])
				$icon.self_modulate = Color(0.5,0.5,0.5)
				return
		
		gv.up[my_upgrade].unlocked = true
		$icon.set_texture(gv.sprite[gv.up[my_upgrade].main_lored_target])
		$icon.self_modulate = Color(1, 1, 1)
		gv.up[my_upgrade].icon_set = true
func r_set_shadow(color) -> void:
	
	match color:
		"active": $shadow.self_modulate = Color(0, 0, 0, 0)
		"not owned": $shadow.self_modulate = Color(0, 0, 0, 0.94902)
		"inactive": $shadow.self_modulate = Color(1,0,0,0.5)
		"refundable": $shadow.self_modulate = Color(1, 0.65625, 0, 0.95)
	
	if not color == "inactive": modulate = Color(1,1,1)
	else: modulate = Color(1, 0, 0)

func _on_buy_mouse_entered():
	w_afford_shit()
	if $afford_alert.visible:
		$afford_alert.hide()
	rt.get_node("map/tip")._call("buy upgrade " + my_upgrade)

func _on_mouse_exited():
	rt.get_node("map/tip")._call("no")

func _on_buy_pressed():
	buy_upgrade(my_upgrade)

func w_afford_shit():
	
	if afford_alert_displayed:
		return
	
	if "nup" in gv.up[my_upgrade] and $icon.texture == gv.sprite["unknown"]:
		return
	
	for v in gv.up[my_upgrade].cost:
		if gv.g[v].r.isLessThan(gv.up[my_upgrade].cost[v].t):
			return
	
	afford_alert_displayed = true
	$afford_alert.hide()


func ___________________():
	pass


func buy_upgrade(b: String, manual := true, red_necro := false) -> void:
	
	if owned(b, red_necro):
		return
	
	if unowned_catches(b, manual, red_necro):
		return
	
	upgrade_bought(b, manual)

func unowned_catches(b: String, manual: bool, red_necro: bool) -> bool:
	
	# the catches in this function are only allowed to catch if 
	# the upgrade is not owned
	
	# returns true if something incorrect is caught
	
	if refundable(b, red_necro):
		return true
	
	if required_upgrades_not_owned(b):
		return true
	
	if not unowned_correct_menu_and_type(b, red_necro):
		if "m" in gv.menu.tab:
			rt.content["up back"].flash = true
			rt.content["up back"].flash_i = 0
		return true
	
	if cannot_afford(b, manual):
		return true
	
	
	return false

func refundable(b: String, red_necro: bool) -> bool:
	
	if red_necro:
		return false
	
	if not gv.up[b].refundable:
		return false
	
	
	
	gv.up[b].refundable = false
	gv.up[b].sync()
	
	for c in gv.up[b].cost:
		gv.g[c].r.plus(gv.up[b].cost[c].t)
	
	rt.w_aa()
	rt.get_node("map/tip")._call("no")
	rt.get_node("map/tip")._call("buy upgrade " + my_upgrade)
	r_set_shadow("not owned")
	
	_kill_all_children(my_upgrade)
	
	return true

func required_upgrades_not_owned(b: String) -> bool:
	
	if gv.up[b].requires == "":
		return false
	
	
	if not gv.up[gv.up[b].requires].have and not gv.up[gv.up[b].requires].refundable:
		return true
	
	
	return false

func unowned_correct_menu_and_type(b: String, red_necro: bool) -> bool:
	
	if red_necro:
		return true
	
	
	if "no" in gv.menu.f:
		
		if "nup" in gv.up[b].type:
			return false
		
		if gv.menu.f[4] != gv.up[b].type[1]:
			return false
	
	else:
		
		if "mup" in gv.up[b].type:
			if not "reset" in gv.up[b].type:
				return false
	
	
	return true

func cannot_afford(b: String, manual: bool) -> bool:
	
	if not gv.up[b].cost_check():
		if manual:
			rt.get_node("map/tip").tip.price_flash = true
		return true
	
	
	return false


func owned(b: String, red_necro: bool):
	
	# in this section, the upgrade is owned,
	# so it will just try to set it to active or inactive
	
	if not gv.up[b].have:
		return false
	
	# it's owned, now we are just doing some extra stuff
	
	if not owned_correct_menu_and_type(b):
		return true
	
	w_set_active(b, not gv.up[b].active) # sends the opposite of active
	
	if "autob" in gv.up[b].type:
		rt.get_node("map/loreds").r_update_autobuy([gv.up[b].main_lored_target])
	
	upgrade_effects(b, gv.up[b].active, false)
	
	rt.w_aa()
	
	if not red_necro:
		rt.get_node("map/tip")._call("no")
		rt.get_node("map/tip")._call("buy upgrade " + my_upgrade)
	
	return true

func owned_correct_menu_and_type(b: String) -> bool:
	
	if "cremover" in gv.up[b].type:
		return false
	
	if "no" in gv.menu.f:
		if "nup" in gv.up[b].type:
			return false
	
	elif "ye" in gv.menu.f:
		
		if b in ["upgrade_name", "upgrade_description", "RED NECROMANCY"]:
			
			content["nah"] = cannot_deactivate_prefab.instance()
			content["nah"].text = get_no_message()
			content["nah"].rect_position = Vector2(content["nah"].rect_position.x, content["nah"].rect_position.y - 20)
			add_child(content["nah"])
			
			return false
	
	return true

func get_no_message() -> String:
	
	var roll : int = rand_range(0, 29)
	
	match roll:
		0:
			return "Nah."
		1:
			return "No."
		2:
			return "Nope."
		3:
			return "Don't think so."
		4:
			return "Stop."
		5:
			return "Yeah, right."
		6:
			return "Get out of here."
		7:
			return "Nice try."
		8:
			return "You think I wouldn't have thought of that?"
		9:
			return "I see right through your tricks, punk."
		10:
			return "What are you trying to pull?"
		11:
			return "Oh, trying to be CLEVER, I see."
		12:
			return "Yeah, real smart. Look at the brain on this guy."
		13:
			return "Frick outta here."
		14:
			return "You little whippersnapper, I oughta beat your mother for this."
		15:
			return "I thought I raised you better."
		16:
			return "You frickin fricks!!!"
		17:
			return "When will you learn that your actions have consequences?"
		18:
			return "Shiver me freakin timbers, get out of here."
		19:
			return "Talk to the ALT-F4."
		20:
			return "You want I should smack ye right in the gob?"
		21:
			return "Profane, let alone abhorrent."
		22:
			return "*Chuckles.* I knew you'd try this. *Smirks.* So predictable."
		23:
			return "Turn around."
		24:
			return "You fucking piece of shit."
		25:
			return "Nah, bro, scedaddle on out of here."
		26:
			return "Why don't you just stop right there?"
		27:
			return "STOP. YOU'VE VIOLATED THE LAW."
		28:
			return "I will turn this car around."
		_:
			return "You better not."

func upgrade_effects(b: String, active: bool, first_purchase: bool):
	
	#gv.up[b].sync()
	
	match b:
		
		"Share the Hit":
			
			if active:
				if not "2" in gv.overcharge_list:
					gv.overcharge_list.append("2")
			else:
				if "2" in gv.overcharge_list:
					gv.overcharge_list.erase("2")
				rt.get_node("map/loreds").r_update_lb()
		
		"Limit Break":
			
			if active:
				
				if not "1" in gv.overcharge_list:
					gv.overcharge_list.append("1")
				if not "2" in gv.overcharge_list:
					if gv.up["Share the Hit"].active():
						gv.overcharge_list.append("2")
				
				if first_purchase:
					rt.get_node("misc/menu/ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/limit_break_text").show()
					rt.get_node("misc/menu/ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/lb_flash").show()
			
			else:
				
				if "1" in gv.overcharge_list:
					gv.overcharge_list.erase("1")
				if "2" in gv.overcharge_list:
					gv.overcharge_list.erase("2")
				
				rt.get_node("map/loreds").r_update_lb()
		
		"Hey, that's pretty good!", "Power Schlonks", "Mega Wonks", "CAPITAL PUNISHMENT":
			gv.up["PROCEDURE"].sync()
		
		"ROUTINE":
			
			if active:
				
				if "ye" in gv.menu.f:
					$border.hide()
					r_set_shadow("not owned")
					gv.up[b].have = false
					gv.menu.upgrades_owned[my_path] -= 1
					
					routine.clear()
					routine = get_routine_info()
					
					gv.g["tum"].r.plus(routine[0]) # d
					gv.g["malig"].r.minus(routine[1]) # c
					rt.b_reset(1, false)
					
					gv.g["malig"].sync()
	
	gv.up[b].sync()
	
	# will sync every other upgrade that benefits from b, a benefactor type upgr
	if "benefactor" in gv.up[b].type:
		var list_key = gv.up[b].type.split("benefactor ")[1]
		for x in gv.stats.up_list[list_key + " buff"]:
			if not gv.up[x].active():
				continue
			gv.up[x].sync()
	
	rt.w_distribute_upgrade_buff(b)

func get_routine_info() -> Array:
	
	var routine_d: Big = Big.new(gv.up["PROCEDURE"].d.t)
	var routine_c: Big = Big.new(gv.up["ROUTINE"].cost["malig"].t)
	
	if gv.g["malig"].r.isLargerThan(Big.new(routine_c).multiply(2)):
		
		var _c: Big = Big.new(gv.g["malig"].r).divide(gv.up["ROUTINE"].cost["malig"].t).roundDown().minus(1)
		_c.multiply(routine_c)
		routine_c.plus(_c)
		
		var relative: Big = Big.new(routine_c).divide(gv.up["ROUTINE"].cost["malig"].t).roundDown().minus(1)
		relative.multiply(gv.up["PROCEDURE"].d.t)
		routine_d.plus(relative)
	
	return [routine_d, routine_c]

func takeaway_price(b: String):
	
	if b in ["ROUTINE"]:
		return
	
	for c in gv.up[b].cost:
		gv.g[c].r.minus(gv.up[b].cost[c].t)

func upgrade_bought(b: String, manual: bool):
	
	takeaway_price(b)
	
	if mup_planning(b):
		return
	
	gv.up[b].times_purchased += 1
	r_set_shadow("active")
	$border.show()
	
	task_stuff(b)
	
	gv.up[b].have = true
	
	upgrade_effects(b, true, true)
	
	if "cremover" in gv.up[b].type:
		gv.g[gv.up[b].benefactor_of[0].split(" ")[0]].cost.erase(gv.up[b].benefactor_of[0].split(" ")[1])
	
	if "autob" in gv.up[b].type:
		rt.get_node("map/loreds").r_update_autobuy([gv.up[b].main_lored_target])
	
	if manual:
		
		# tooltip
		rt.get_node("map/tip")._call("no")
		rt.get_node("map/tip")._call("buy upgrade " + my_upgrade)
		
		if "nup" in gv.up[b].type:
			rt.get_node("misc/tabs").up[gv.up[b].path].get_node("alert").b_flash(false)
	
	# task
	if b in rt.task_awaiting and not rt.on_task:
		rt.get_node("misc/task")._clear_board()
		rt.get_node("misc/task")._call_board()
	
	gv.menu.upgrades_owned[my_path] += 1
	if manual and "up back" in rt.content.keys():
		rt.content["up back"].w_update_owned_count()
	
	w_update_other_upgrades_or_something()
	rt.w_afford_alert()
	
	# flying texts
	if true:
		
		if not my_path.split("up")[0] == gv.menu.tab: return
		
		var rollx :int= rand_range(-30,30) + get_global_position().x + 20 - rt.get_node("map/upgrades").position.x
		var rolly :int= get_global_position().y - 20# + rt.get_node("map/upgrades").position.y
		
		var i := 0
		
		if b == "ROUTINE" and gv.up["PROCEDURE"].active():
			
			rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)] = rt.prefab["dtext"].instance()
			rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].text = "+ " + routine[0].toString()
			rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].add_color_override("font_color", rt.r_lored_color("tum"))
			rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].get_node("icon").set_texture(gv.sprite["tum"])
			rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(rollx, rolly - rt.get_node("map/upgrades").get_global_position().y)
			rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].init(false, -50)
			rt.get_node("map/upgrades").add_child(rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)])
			
			i += 1
		
		for x in gv.up[b].cost:
			
			var t = Timer.new()
			t.set_wait_time(0.04)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			
			# dtext
			rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)] = rt.prefab["dtext"].instance()
			if b == "ROUTINE":
				rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].text = "- " + routine[1].toString()
			else:
				rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].text = "- " + gv.up[b].cost[x].t.toString()
			rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].add_color_override("font_color", rt.r_lored_color(x))
			rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].get_node("icon").set_texture(gv.sprite[x])
			if i == 0:
				rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(rollx, rolly - rt.get_node("map/upgrades").get_global_position().y)
			else:
				
				for v in i:
					if not "(upgrade purchased flying text)" + str(v) in rt.upgrade_dtexts.keys(): return
					rt.upgrade_dtexts["(upgrade purchased flying text)" + str(v)].rect_position.y -= 7
				rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i-1)].rect_position.x, rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i-1)].rect_position.y + rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].rect_size.y)
			rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].init(false, -50)
			rt.get_node("map/upgrades").add_child(rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)])
			
			i += 1
	
	rt.w_aa()

func mup_planning(b: String) -> bool:
	
	if "ye" in gv.menu.f:
		return false
	
	if gv.up[b].type[1] != gv.menu.f.split("no s")[1]:
		return false
	
	r_set_shadow("refundable")
	gv.up[b].refundable = true
	
	w_update_other_upgrades_or_something()
	
	if my_path.split("up")[0] == gv.menu.tab:
		rt.get_node("map/tip")._call("no")
		rt.get_node("map/tip")._call("buy upgrade " + my_upgrade)
	
	return true

func task_stuff(b: String):
	
	if taq.cur_quest == "":
		return
	
	for x in taq.quest.step:
		if b in x:
			taq.quest.step[x].f = Big.new()


func w_update_other_upgrades_or_something():
	
	for x in gv.up[my_upgrade].required_by:
		
		var poop = gv.up[my_upgrade].path
		if not x in rt.upc[poop].keys(): continue
		
		gv.up[x].icon_set = true
		
		gv.up[x].unlocked = true
		rt.upc[poop][x].get_node("icon").set_texture(gv.sprite[gv.up[x].main_lored_target])
		rt.upc[poop][x].get_node("icon").self_modulate = Color(1,1,1)
		for v in gv.up[x].required_by:
			if not v in rt.upc[poop].keys(): continue
			rt.upc[poop][v].r_update()
func w_set_active(b: String, set: bool) -> void:
	
	gv.up[b].active = set
	
	if not set:
		r_set_shadow("inactive")
		return
	
	r_set_shadow("active")

func _kill_all_children(up : String) -> void:
	
	# follows the entire chain of upgrades that require up at some point in their tree and refunds them all
	# recursive, that's how
	
	for x in gv.up[up].required_by:
		if gv.up[x].refundable:
			
			gv.up[x].refundable = false
			gv.up[x].sync()
			
			for c in gv.up[x].cost:
				gv.g[c].r.plus(gv.up[x].cost[c].t)
			
			#var poop = gv.up[my_upgrade].type.split(" ")[0] + gv.up[my_upgrade].type.split(" ")[1].split(" ")[0]
			
			rt.upc[gv.up[x].path][x].r_set_shadow("not owned")
			
			for v in gv.up[x].required_by:
				if gv.up[v].refundable:
					_kill_all_children(x)

func _on_buy_button_down():
	rt.get_node("map").status = "no"
