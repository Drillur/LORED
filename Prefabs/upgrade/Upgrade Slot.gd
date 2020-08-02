extends MarginContainer



onready var rt = get_node("/root/Root")


var key: String
var folder: String

var gntypesprite := "m/v/h/type/Sprite"
var gntypeauto := "m/v/h/type/auto"


var src := {
	cannot_deactivate_prefab = preload("res://Prefabs/lored_buy.tscn"),
}

var cont := {}

var fps := {
	"afford": FPS.new(0.25)
}


var routine := []

var already_displayed_alert_guy := false



func setup(_key, _folder):
	
	key = _key
	folder = _folder
	
	name = key
	
	if gv.up[key].have:
		get_node("m/unowned").hide()
	
	# icons
	get_node("m/v/h/icon/Sprite").texture = gv.sprite[gv.up[key].main_lored_target]
	set_type_icon()
	
	# texts
	get_node("m/v/h/name").text = gv.up[key].name

func set_type_icon():
	
	if "haste" in gv.up[key].type:
		get_node(gntypesprite).texture = gv.sprite["haste"]
		return
	
	if "out" in gv.up[key].type or "add" in gv.up[key].type:
		get_node(gntypesprite).texture = gv.sprite["output"]
		return
	
	if "auto" in gv.up[key].type:
		get_node(gntypesprite).hide()
		get_node(gntypeauto).show()
		get_node(gntypeauto).frame = int(rand_range(0, 15))
		get_node(gntypeauto).speed_scale = rand_range(0.9,1.1)
		if "autob" in gv.up[key].type:
			get_node(gntypeauto).self_modulate = gv.g[gv.up[key].main_lored_target].color
		return
	
	get_node(gntypesprite).hide()



func _physics_process(delta: float) -> void:
	
	for x in fps:
		
		if fps[x].f > 0:
			fps[x].f -= delta
	
	
	if fps["afford"].f <= 0:
		afford()
		fps["afford"].f += 0.25
		#if fps[x].f <= 0 and fps[x].set:
			


func _on_Select_mouse_entered() -> void:
	
	alert(false)
	
	rt.get_node("global_tip")._call("buy upgrade " + key)
	
	if not requirements():
		get_node("Locked").show()
		get_node("Select").mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
		get_node("Select").disabled = true
		return
	
	if "ye" in gv.menu.f and "m" in gv.open_upgrade_folder and not gv.up[key].have:
		
		match gv.open_upgrade_folder[1]:
			"1":
				get_node("Reset/Label").text = "You must Metastasize before purchasing Malignant upgrades!"
			"2":
				get_node("Reset/Label").text = "You must receive Chemotherapy before purchasing Radiative upgrades!"
		
		get_node("Reset").show()
		get_node("Select").mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
		get_node("Select").disabled = true
		
		return
	
	if not "ye" in gv.menu.f:
		
		var display_reset = false
		
		if "n" in gv.open_upgrade_folder:
			display_reset = true
			get_node("Reset/Label").text = "You cannot interact with this upgrade while resetting."
		
		elif int(gv.open_upgrade_folder[1]) != int(gv.menu.f[4]):
			get_node("Reset/Label").text = "You cannot interact with this upgrade while resetting another Stage."
			display_reset = true
		
		
		
		if display_reset:
			get_node("Reset").show()
			get_node("Select").mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
			get_node("Select").disabled = true
		
		return

func _on_Select_mouse_exited() -> void:
	
	if get_node("Locked").visible or get_node("Reset").visible:
		get_node("Reset").hide()
		get_node("Locked").hide()
		get_node("Select").mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		get_node("Select").disabled = false
	
	rt.get_node("global_tip")._call("no")


func _on_Select_pressed() -> void:
	buy_upgrade()


func requirements() -> bool:
	
	if gv.up[key].requires == "":
		return true
	
	if not gv.up[gv.up[key].requires].have and not gv.up[gv.up[key].requires].refundable:
		
		return false
	
	return true



func r_update():
	
	tags()
	afford()
	
	if not gv.up[key].have:
		get_node("m/unowned").show()
	else:
		get_node("m/unowned").hide()


func tags():
	
	if requirements():
		get_node("m/v/h/locked").hide()
	else:
		get_node("m/v/h/locked").show()
	
	if gv.up[key].active:
		get_node("m/v/h/inactive").hide()
	else:
		get_node("m/v/h/inactive").show()
	
	if key in ["upgrade_name", "upgrade_description", "RED NECROMANCY"]:
		get_node("m/v/h/permanent").show()
	else:
		get_node("m/v/h/permanent").hide()
	
	get_node("m/v/h/refundable").visible = gv.up[key].refundable


func afford():
	
	if gv.open_upgrade_folder != folder:
		return
	
	if gv.up[key].have:
		return
	
	get_node("m/unowned").self_modulate = get_purchase_modulate()


func get_purchase_modulate():
	
	var BAD := Color(1.3, 0, 0)
	var GOOD := Color(1, 1, 1)
	
	if "reset" in gv.up[key].type:
		return GOOD
	
	return GOOD if gv.up[key].cost_check() else BAD
	
	var tier := int(gv.up[key].type[1])
	var menu_tier := int(gv.menu.f.split("no s")[1])
	
	if gv.up[key].normal:
		if menu_tier >= tier: return BAD
	else:
		if not menu_tier == tier: return BAD
	
	return GOOD if gv.up[key].cost_check() else BAD




func ______________():
	pass



func buy_upgrade(manual := true, red_necro := false) -> void:
	
	if owned(red_necro):
		return
	if unowned_catches(manual, red_necro):
		return
	
	upgrade_bought(manual)

func unowned_catches(manual: bool, red_necro: bool) -> bool:
	
	# the catches in this function are only allowed to catch if 
	# the upgrade is not owned
	
	# returns true if something incorrect is caught
	
	if refundable(red_necro):
		return true
	
	if required_upgrades_not_owned():
		return true
	
	if cannot_afford(manual):
		return true
	
	
	return false

func refundable(red_necro: bool) -> bool:
	
	if red_necro:
		return false
	
	if not gv.up[key].refundable:
		return false
	
	
	gv.up[key].refundable = false
	gv.up[key].sync()
	
	for c in gv.up[key].cost:
		gv.g[c].r.a(gv.up[key].cost[c].t)
		gv.emit_signal("lored_updated", c, "amount")
	
	rt.w_aa()
	rt.get_node("global_tip")._call("no")
	rt.get_node("global_tip")._call("buy upgrade " + key)
	#r_set_shadow("not owned")
	
	_kill_all_children(key)
	
	tags()
	rt.get_node(rt.gnupcon).update_folder()
	
	return true

func required_upgrades_not_owned() -> bool:
	
	if gv.up[key].requires == "":
		return false
	
	if not gv.up[gv.up[key].requires].have and not gv.up[gv.up[key].requires].refundable:
		return true
	
	
	return false

func cannot_afford(manual: bool) -> bool:
	
	if not gv.up[key].cost_check():
		if manual:
			if is_instance_valid(rt.get_node("global_tip").tip):
				rt.get_node("global_tip").tip.price_flash = true
		return true
	
	
	return false


func owned(red_necro: bool):
	
	# in this section, the upgrade is owned,
	# so it will just try to set it to active or inactive
	
	if not gv.up[key].have:
		return false
	
	# it's owned, now we are just doing some extra stuff
	
	if not owned_correct_menu_and_type():
		return true
	
	w_set_active(not gv.up[key].active) # sends the opposite of active
	
	if "autob" in gv.up[key].type:
		rt.get_node(rt.gnLOREDs).r_autobuy(gv.up[key].main_lored_target)
	
	upgrade_effects(gv.up[key].active, false)
	
	rt.w_aa()
	
	if not red_necro:
		rt.get_node("global_tip")._call("no")
		rt.get_node("global_tip")._call("buy upgrade " + key)
	
	return true

func owned_correct_menu_and_type() -> bool:
	
	if "cremover" in gv.up[key].type:
		return false
	
	if "no" in gv.menu.f:
		if gv.up[key].normal:
			return false
	
	elif "ye" in gv.menu.f:
		
		if key in ["upgrade_name", "upgrade_description", "RED NECROMANCY"]:
			
			cont["nah"] = src.cannot_deactivate_prefab.instance()
			cont["nah"].text = get_no_message()
			cont["nah"].rect_position = Vector2(cont["nah"].rect_position.x, cont["nah"].rect_position.y - 20)
			add_child(cont["nah"])
			
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

func upgrade_effects(active: bool, first_purchase: bool):
	
	#gv.up[key].sync()
	
	match key:
		
		"Limit Break":
			
			if active:
				
				if not "1" in gv.overcharge_list:
					gv.overcharge_list.append("1")
					gv.overcharge_list.append("2")
					rt.get_node(rt.gnLB).r_limit_break()
					rt.get_node(rt.gnLB).r_set_colors()
					rt.get_node(rt.gnLB).show()
			
			else:
				
				if "1" in gv.overcharge_list:
					gv.overcharge_list.erase("1")
					gv.overcharge_list.erase("2")
					rt.get_node(rt.gnLB).hide()
		
		"Hey, that's pretty good!", "Power Schlonks", "Mega Wonks", "CAPITAL PUNISHMENT":
			gv.up["PROCEDURE"].sync()
		
		"ROUTINE":
			
			if active:
				
				if "ye" in gv.menu.f:
					
					get_node("m/unowned").show()
					afford()
					
					#r_set_shadow("not owned")
					gv.up[key].have = false
					gv.menu.upgrades_owned[folder] -= 1
					
					routine.clear()
					routine = get_routine_info()
					
					gv.g["tum"].r.a(routine[0]) # d
					gv.emit_signal("lored_updated", "tum", "amount")
					gv.g["malig"].r.s(routine[1]) # c
					gv.emit_signal("lored_updated", "malig", "amount")
					rt.reset(1, false)
					
					gv.g["malig"].sync()
	
	gv.up[key].sync()
	
	# will sync every other upgrade that benefits from b, a benefactor type upgr
	if "benefactor" in gv.up[key].type:
		var list_key = gv.up[key].type.split("benefactor ")[1]
		for x in gv.stats.up_list[list_key + " buff"]:
			if not gv.up[x].active():
				continue
			gv.up[x].sync()
	
	# signals
	if true:
		
		if " out" in gv.up[key].type or "add buff" in gv.up[key].type:
			if gv.up[key].main_lored_target in gv.g.keys():
				gv.emit_signal("lored_updated", gv.up[key].main_lored_target, "d")
			elif gv.up[key].main_lored_target in ["s1", "s2"]:
				for x in gv.g:
					if not gv.g[x].type[1] == gv.up[key].main_lored_target[1]:
						continue
					gv.emit_signal("lored_updated", x, "d")
		
		if " haste" in gv.up[key].type or "haste buff" in gv.up[key].type:
			if gv.up[key].main_lored_target in gv.g.keys():
				gv.emit_signal("lored_updated", gv.up[key].main_lored_target, "autobuywheel")
			elif gv.up[key].main_lored_target in ["s1", "s2"]:
				for x in gv.g:
					if not gv.g[x].type[1] == gv.up[key].main_lored_target[1]:
						continue
					gv.emit_signal("lored_updated", x, "autobuywheel")
	
	rt.w_distribute_upgrade_buff(key)

func get_routine_info() -> Array:
	
	var routine_d: Big = Big.new(gv.up["PROCEDURE"].d.t)
	var routine_c: Big = Big.new(gv.up["ROUTINE"].cost["malig"].t)
	
	if gv.g["malig"].r.isLargerThan(Big.new(routine_c).m(2)):
		
		var _c: Big = Big.new(gv.g["malig"].r.percent(gv.up["ROUTINE"].cost["malig"].t)).roundDown().s(1)
		_c.m(routine_c)
		routine_c.a(_c)
		
		var relative: Big = Big.new(routine_c.percent(gv.up["ROUTINE"].cost["malig"].t)).roundDown().s(1)
		relative.m(gv.up["PROCEDURE"].d.t)
		routine_d.a(relative)
	
	return [routine_d, routine_c]

func takeaway_price():
	
	if key in ["ROUTINE"]:
		return
	
	for c in gv.up[key].cost:
		gv.g[c].r.s(gv.up[key].cost[c].t)
		gv.emit_signal("lored_updated", c, "amount")

func upgrade_bought(manual: bool):
	
	takeaway_price()
	
	if mup_planning():
		return
	
	gv.up[key].times_purchased += 1
	
	get_node("m/unowned").hide()
	
	task_stuff()
	
	gv.up[key].have = true
	
	upgrade_effects(true, true)
	
	if "cremover" in gv.up[key].type:
		gv.g[gv.up[key].benefactor_of[0].split(" ")[0]].cost.erase(gv.up[key].benefactor_of[0].split(" ")[1])
	
	if "autob" in gv.up[key].type:
		rt.get_node(rt.gnLOREDs).r_autobuy(gv.up[key].main_lored_target)
	
	if manual:
		
		# tooltip
		rt.get_node("global_tip")._call("no")
		rt.get_node("global_tip")._call("buy upgrade " + key)
		
		if gv.up[key].normal:
			pass
	
	# task
	if key in rt.task_awaiting and not rt.on_task:
		rt.get_node("misc/task")._clear_board()
		rt.get_node("misc/task")._call_board()
	
	gv.menu.upgrades_owned[folder] += 1
	rt.get_node(rt.gnupcon).sync_count(folder)
	
	w_update_other_upgrades_or_something()
	rt.afford()
	
	gv.emit_signal("upgrade_purchased", key, routine)

func mup_planning() -> bool:
	
	if "ye" in gv.menu.f:
		return false
	
	if gv.up[key].type[1] != gv.menu.f.split("no s")[1]:
		return false
	
	gv.up[key].refundable = true
	
	w_update_other_upgrades_or_something()
	
	# "s1n" == "1"
#	if folder == gv.menu.tab:
#		rt.get_node("global_tip")._call("no")
#		rt.get_node("global_tip")._call("buy upgrade " + key)
	
	tags()
	rt.get_node(rt.gnupcon).update_folder()
	
	return true

func task_stuff():
	
	if taq.cur_quest == "":
		return
	
	for x in taq.quest.step:
		if key in x:
			taq.quest.step[x].f = Big.new()

func w_update_other_upgrades_or_something():
	
	for x in gv.up[key].required_by:
		
		gv.up[x].icon_set = true
		
		gv.up[x].unlocked = true
		rt.get_node(rt.gnupcon).cont[x].tags()
		for v in gv.up[x].required_by:
			rt.get_node(rt.gnupcon).cont[v].tags()
func w_set_active(set: bool) -> void:
	
	gv.up[key].active = set
	
	tags()
	
	if not set:
		#r_set_shadow("inactive")
		return
	
	#r_set_shadow("active")

func _kill_all_children(up : String) -> void:
	
	# follows the entire chain of upgrades that require up at some point in their tree and refunds them all
	# recursive, that's how
	
	for x in gv.up[up].required_by:
		if gv.up[x].refundable:
			
			gv.up[x].refundable = false
			gv.up[x].sync()
			
			rt.get_node(rt.gnupcon).cont[x].tags()
			
			for c in gv.up[x].cost:
				gv.g[c].r.a(gv.up[x].cost[c].t)
				gv.emit_signal("lored_updated", c, "amount")
			
			#var poop = gv.up[key].type.split(" ")[0] + gv.up[key].type.split(" ")[1].split(" ")[0]
			
			for v in gv.up[x].required_by:
				if gv.up[v].refundable:
					_kill_all_children(x)


func alert(show := true):
	
	get_node("m/v/h/alert").visible = show
	
	if not show:
		rt.get_node(rt.gnupcon).alert(false, key)
