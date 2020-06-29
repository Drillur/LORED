extends Button

onready var cannot_deactivate_prefab = preload("res://Prefabs/lored_buy.tscn")

var content := {}

onready var rt = get_node("/root/Root")
var fps := 0.0

var my_upgrade : String
var my_path : String

var afford_alert_displayed := false
var modulated_one_last_time := false

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
	
	if not "s" in rt.menu.tab: return
	
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
		
		if gv.up[my_upgrade].requires == "": going_to_show = true
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
	b_buy_up(my_upgrade)

func w_afford_shit():
	
	if afford_alert_displayed:
		return
	
	if "nup" in gv.up[my_upgrade] and $icon.texture == gv.sprite["unknown"]:
		return
	
	for v in gv.up[my_upgrade].cost:
		if gv.g[v].r < gv.up[my_upgrade].cost[v].t:
			return
	
	afford_alert_displayed = true
	$afford_alert.hide()

func b_buy_up(b, manually_purhcased := true, red_necromancy := false) -> void:
	
	# catches
	if not gv.up[b].have:
		
		if not red_necromancy and gv.up[b].refundable:
			
			gv.up[b].refundable = false
			gv.up[b].sync_self()
			gv.up[b].set_d(true)
			
			for c in gv.up[b].cost:
				gv.g[c].r += gv.up[b].cost[c].t
			
			rt.w_aa()
			rt.get_node("map/tip")._call("no")
			rt.get_node("map/tip")._call("buy upgrade " + my_upgrade)
			r_set_shadow("not owned")
			
			_kill_all_children(my_upgrade)
			
			return
		
		if not gv.up[b].requires == "":
			if not gv.up[gv.up[b].requires].have and not gv.up[gv.up[b].requires].refundable:
				return
		
		var ret := false
		
		if "no" in rt.menu.f and not "mup" in gv.up[b].type: ret = true
		if "ye" in rt.menu.f and not "nup" in gv.up[b].type and not "reset" in gv.up[b].type: ret = true
		if "no" in rt.menu.f and not rt.menu.f.split("no s")[1] == gv.up[b].type[1]: ret = true
		
		if red_necromancy: ret = false
		
		if ret:
			if "m" in rt.menu.tab:
				rt.content["up back"].flash = true
				rt.content["up back"].flash_i = 0
			return
		
		for v in gv.up[b].cost:
			if gv.g[v].r < gv.up[b].cost[v].t:
				if manually_purhcased:
					rt.get_node("map/tip").tip.price_flash = true
				return
	
	# already owned ; setting to active or inactive
	else:
		
		# note
		if "cremover" in gv.up[b].type:
			return
		
		if "no" in rt.menu.f:
			if ("s1" in rt.menu.f and "s1" in gv.up[b].type and not "mup" in gv.up[b].type):
				return
		
		# cannot change active status
		if "ye" in rt.menu.f:
			
			match b:
				"upgrade_name", "upgrade_description", "RED NECROMANCY":
					
					content["nah"] = cannot_deactivate_prefab.instance()
					var roll : int = rand_range(0, 10)
					match roll:
						0:
							content["nah"].text = "Nah."
						1:
							content["nah"].text = "No."
						2:
							content["nah"].text = "Nope."
						3:
							content["nah"].text = "Don't think so."
						4:
							content["nah"].text = "Stop."
						5:
							content["nah"].text = "Yeah, right."
						6:
							content["nah"].text = "Get out of here."
						7:
							content["nah"].text = "Nice try."
						8:
							content["nah"].text = "You think I wouldn't have thought of that?"
						9:
							content["nah"].text = "I see right through your tricks, punk."
					content["nah"].rect_position = Vector2(content["nah"].rect_position.x, content["nah"].rect_position.y - 20)
					add_child(content["nah"])
					
					return
		
		# set active or inactive
		if gv.up[b].active:
			w_set_active(b, false)
		else:
			w_set_active(b, true)
		
		if "autob" in gv.up[b].type:
			rt.get_node("map/loreds").r_update_autobuy([gv.up[b].main_lored_target])
		
		match b:
			
			"Share the Hit":
				if gv.up[b].active:
					if not "2" in gv.overcharge_list:
						gv.overcharge_list.append("2")
				else:
					if "2" in gv.overcharge_list:
						gv.overcharge_list.erase("2")
					rt.get_node("map/loreds").r_update_lb()
			"Limit Break":
				if gv.up[b].active:
					if not "1" in gv.overcharge_list:
						gv.overcharge_list.append("1")
					if not "2" in gv.overcharge_list:
						if gv.up["Share the Hit"].active():
							gv.overcharge_list.append("2")
				else:
					if "1" in gv.overcharge_list:
						gv.overcharge_list.erase("1")
					if "2" in gv.overcharge_list:
						gv.overcharge_list.erase("2")
					rt.get_node("map/loreds").r_update_lb()
			
			"Hey, that's pretty good!", "Power Schlonks", "Mega Wonks", "CAPITAL PUNISHMENT":
				if b == "CAPITAL PUNISHMENT":
					gv.up[b].sync_self()
				if gv.up["PROCEDURE"].active():
					gv.up["PROCEDURE"].sync_self()
					gv.up["PROCEDURE"].d = rt.w_set_d("PROCEDURE")
		
		rt.w_distribute_upgrade_buff(b)
		rt.w_aa()
		
		if not red_necromancy:
			rt.get_node("map/tip")._call("no")
			rt.get_node("map/tip")._call("buy upgrade " + my_upgrade)
		
		return
	
	# takeaway price
	if b != "ROUTINE":
		for v in gv.up[b].cost:
			gv.g[v].r -= gv.up[b].cost[v].t
	
	# upgrade bought !
	if true:
		
		gv.up[b].times_purchased += 1
		
		# task stuff
		if taq.cur_quest != "":
			for x in taq.quest.step:
				if b in x:
					taq.quest.step[x].f = 1.0
		
		if not "reset" in gv.up[b].type:
			if "nup" in gv.up[b].type:
				rt.afford_check_fps -= 3
		
		gv.up[b].sync_self()
		
		gv.up[b].set_d()
		
		if "ye" in rt.menu.f:
			r_set_shadow("active")
			$border.show()
		else:
			if gv.up[b].type[1] == rt.menu.f.split("no s")[1] and not gv.up[b].have:
				r_set_shadow("refundable")
				gv.up[b].refundable = true
				
				w_update_other_upgrades_or_something()
				
				if my_path.split("up")[0] == rt.menu.tab: rt.get_node("map/tip")._call("no")
				if my_path.split("up")[0] == rt.menu.tab: rt.get_node("map/tip")._call("buy upgrade " + my_upgrade)
				return
	
	# cannot/should not be done in # upgrade bought :
	if true:
		
		gv.up[b].have = true
		rt.w_distribute_upgrade_buff(b)
		
		var routine_d : float = gv.up["PROCEDURE"].d
		var routine_c : float = gv.up["ROUTINE"].cost["malig"].t
		
		match b:
			"Share the Hit":
				gv.overcharge_list.append("2")
			"Limit Break":
				gv.overcharge_list.append("1")
				rt.get_node("misc/menu/ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/limit_break_text").show()
				rt.get_node("ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/lb_flash").show()
			"CAPITAL PUNISHMENT":
				gv.up[b].sync_self()
				continue
			"Hey, that's pretty good!", "Power Schlonks", "Mega Wonks", "CAPITAL PUNISHMENT":
				gv.up["PROCEDURE"].sync_self()
				if gv.up["PROCEDURE"].active():
					gv.up["PROCEDURE"].set_d()
			"ROUTINE":
				if "ye" in rt.menu.f:
					$border.hide()
					r_set_shadow("not owned")
					gv.up[b].have = false
					rt.menu.upgrades_owned[my_path] -= 1
					if gv.g["malig"].r > routine_c * 2:
						routine_c += (floor(min(gv.g["malig"].r, routine_c * 100) / gv.up[b].cost["malig"].t) - 1) * routine_c
						var relative: float = floor(routine_c / gv.up["ROUTINE"].cost["malig"].t) - 1
						routine_d += gv.up["PROCEDURE"].d * relative
					gv.g["malig"].r -= routine_c
					gv.g["tum"].r += routine_d
					rt.b_reset(1, false)
		
		if "cremover" in gv.up[b].type:
			gv.g[gv.up[b].benefactor_of[0].split(" ")[0]].cost.erase(gv.up[b].benefactor_of[0].split(" ")[1])
		
		if "autob" in gv.up[b].type:
			rt.get_node("map/loreds").r_update_autobuy([gv.up[b].main_lored_target])
		
		rt.w_aa()
		
		if manually_purhcased:
			
			# tooltip
			rt.get_node("map/tip")._call("no")
			rt.get_node("map/tip")._call("buy upgrade " + my_upgrade)
			
			if "nup" in gv.up[b].type:
				rt.get_node("misc/tabs").up[gv.up[b].path].get_node("alert").b_flash(false)
		
		# task
		if b in rt.task_awaiting and not rt.on_task:
			rt.get_node("misc/task")._clear_board()
			rt.get_node("misc/task")._call_board()
		
		w_update_other_upgrades_or_something()
		
		rt.menu.upgrades_owned[my_path] += 1
		if manually_purhcased and "up back" in rt.content.keys():
			rt.content["up back"].w_update_owned_count()
		
		rt.w_afford_alert()
		
		# flying texts
		if true:
			
			if not my_path.split("up")[0] == rt.menu.tab: return
			
			var rollx :int= rand_range(-30,30) + get_global_position().x + 20 - rt.get_node("map/upgrades").position.x
			var rolly :int= get_global_position().y - 20# + rt.get_node("map/upgrades").position.y
			
			var i := 0
			
			if b == "ROUTINE" and gv.up["PROCEDURE"].have and gv.up["PROCEDURE"].active:
				
				rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)] = rt.prefab["dtext"].instance()
				rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].text = "+ " + fval.f(routine_d)
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
					rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].text = "- " + fval.f(routine_c)
				else:
					rt.upgrade_dtexts["(upgrade purchased flying text)" + str(i)].text = "- " + fval.f(gv.up[b].cost[x].t)
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
		gv.up[b].sync_self()
		gv.up[b].set_d(true)
		r_set_shadow("inactive")
		return
	
	gv.up[b].set_d()
	r_set_shadow("active")

func _kill_all_children(up : String) -> void:
	
	# follows the entire chain of upgrades that require up at some point in their tree and refunds them all
	# recursive, that's how
	
	for x in gv.up[up].required_by:
		if gv.up[x].refundable:
			
			gv.up[x].refundable = false
			gv.up[x].set_d()
			
			for c in gv.up[x].cost:
				gv.g[c].r += gv.up[x].cost[c].t
			
			#var poop = gv.up[my_upgrade].type.split(" ")[0] + gv.up[my_upgrade].type.split(" ")[1].split(" ")[0]
			
			rt.upc[gv.up[x].path][x].r_set_shadow("not owned")
			
			for v in gv.up[x].required_by:
				if gv.up[v].refundable:
					_kill_all_children(x)

func _on_buy_button_down():
	rt.get_node("map").status = "no"
