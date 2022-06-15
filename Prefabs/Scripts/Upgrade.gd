extends MarginContainer



onready var rt = get_node("/root/Root")


var key: String
var tab: int

const gn := {
	inactive = "n/tags/inactive",
	pending = "n/tags/pending",
}
onready var icon = get_node("upgrade icon")
onready var button = get_node("Button")
onready var afford = get_node("afford")
onready var shadow = get_node("unowned shadow")
onready var color_blind = get_node("color blind")

var src := {
	cannot_deactivate_prefab = preload("res://Prefabs/lored_buy.tscn"),
}
var cont := {}

var routine := []

var already_displayed_alert_guy := false

func setup(_key):
	
	key = _key
	tab = gv.up[key].tab
	
	gv.up[key].manager = self
	
	name = key
	
	color_blind.self_modulate = gv.up[key].color
	afford.self_modulate = gv.up[key].color
	button.self_modulate = gv.up[key].color
	#shadow.self_modulate = gv.up[key].color
	get_node("icon shadow").self_modulate = gv.up[key].color
	
	if gv.up[key].have:
		shadow.hide()
	
	icon.init(key)
	
	afford()
	
	loop_1s()
	loop_025s()


func _on_Button_mouse_entered() -> void:
	
	rt.get_node("global_tip")._call("buy upgrade " + key)
	
	set_mouse_cursor_shape()

func _on_Button_mouse_exited() -> void:
	
	gv.up[key].active_tooltip_exists = false
	rt.get_node("global_tip")._call("no")


func _on_Button_pressed() -> void:
	buy_upgrade()


func requirements() -> bool:
	
	if gv.up[key].requires == "":
		return true
	
	if not gv.up[gv.up[key].requires].have and not gv.up[gv.up[key].requires].refundable:
		
		return false
	
	return true


func availableToBuy() -> bool:
	return not gv.up[key].have and not gv.up[key].refundable and not icon.lock.visible and gv.up[key].tab in gv.unlocked_tabs

func r_update():
	
	# called in up_container.gd
	
	tags()
	icon.update()
	afford()
	
	color_blind.visible = gv.option["color blind"] and not gv.up[key].have and not gv.up[key].refundable and not icon.lock.visible
	
	if gv.up[key].refundable:
		shadow.hide()
		return
	
	if icon.lock.visible or gv.up[key].have:
		shadow.hide()
	else:
		shadow.show()
	
	if icon.lock.visible:
		button.self_modulate = Color(button.self_modulate.r, button.self_modulate.g, button.self_modulate.b, 0.25)
	else:
		button.self_modulate = Color(button.self_modulate.r, button.self_modulate.g, button.self_modulate.b, 1.0)

func flash():
	
	cont["flash"] = gv.SRC["flash"].instance()
	add_child(cont["flash"])
	cont["flash"].flash(Color(1,1,1))

func set_mouse_cursor_shape():
	
	if gv.up[key].have:
		if key == "ROUTINE":
			return
		button.mouse_default_cursor_shape = Control.CURSOR_ARROW
		return
	
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func tags():
	
	if not gv.up[key].have:
		get_node(gn.inactive).hide()
	else:
		get_node(gn.inactive).visible = not gv.up[key].active
	
	get_node(gn.pending).visible = gv.up[key].refundable


func afford():
	
	if icon.lock.visible:
		afford.hide()
		button.modulate = Color(0.6,0.6,0.6)
		return
	
	if gv.up[key].have:
		afford.hide()
	else:
		afford.hide()
	
	if gv.up[key].have or gv.up[key].refundable:
		afford.modulate = Color(0.2, 0.2, 0.2)
		button.modulate = Color(0.2, 0.2, 0.2)
		return
	
	if gv.open_tab != tab:
		return
	
	if can_purchase():
		afford.show()
		afford.modulate = Color(1,1,1)
		button.modulate = Color(1,1,1)
		color_blind.pressed = true
	else:
		afford.hide()
		button.modulate = Color(1,1,1)
		color_blind.pressed = false


func can_purchase() -> bool:
	
	# returns false if BAD
	# returns true if GOOD
	
	if key == "Carcinogenesis":
		if gv.list.upgrade["owned " + str(gv.Tab.MALIGNANT)].size() == 80:
			return true
		return false
	
	if "reset" in gv.up[key].type:
		return true
	
	return gv.up[key].cost_check()

func loop_025s():
	
	while true:
		
		var t = Timer.new()
		add_child(t)
		t.start(0.25)
		yield(t, "timeout")
		t.queue_free()
		
		afford()
	

func loop_1s():
	
	while true:
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()
		
		autobuy()

func autobuy():
	
	if not gv.up[key].autobuy:
		return
	
	if not gv.s2_upgrades_may_be_autobought:
		if key in gv.list.upgrade[str(gv.Tab.EXTRA_NORMAL)]:
			return
	
	buy_upgrade(false, true)



func ______________():
	pass

func upgrade_bought(manual: bool, red_necro := false):
	
	if gv.up[key].normal or red_necro:
		
		taq.increaseProgress(gv.Objective.UPGRADE_PURCHASED, key)
		#taq.increaseProgress(gv.Objective.UPGRADES_PURCHASED, gv.up[key].tab) #note
		
		gv.up[key].purchased()
		
		if gv.up[key].have:
			shadow.hide()
		
		set_mouse_cursor_shape()
		
		upgrade_effects(true)
		
		if manual:
			
			if key == "Carcinogenesis":
				rt.reset(gv.Tab.S3)
				gv.r["embryo"].a(1)
				rt.unlock_tab("3")
			
			# tooltip
			rt.get_node("global_tip")._call("no")
			if not key in ["Carcinogenesis"]:
				rt.get_node("global_tip")._call("buy upgrade " + key)
			
			if gv.up[key].normal:
				pass
		
		# task
		if key in rt.task_awaiting and not rt.on_task:
			rt.get_node("misc/task")._clear_board()
			rt.get_node("misc/task")._call_board()
		
		if not key == "ROUTINE":
			gv.list.upgrade["owned " + str(tab)].append(key)
		rt.get_node(rt.gnupcon).sync()
		
		w_update_other_upgrades_or_something()
		
		gv.emit_signal("upgrade_purchased", key, routine)
		
		r_update()
	
	else:
		
		gv.up[key].refundable = true
		gv.up[key].takeaway_price()
		
		r_update()
		
		w_update_other_upgrades_or_something()
		
		gv.up[key].active_tooltip.display()
	
	afford()

func buy_upgrade(manual := true, red_necro := false) -> void:
	
	if gv.up[key].have:
		return
	
	if not red_necro and button.mouse_default_cursor_shape == Control.CURSOR_FORBIDDEN:
		rt.get_node(rt.gnupcon).flash_reset_button()
		return
	
	if unowned_catches(manual, red_necro):
		return
	
	upgrade_bought(manual, red_necro)

func unowned_catches(manual: bool, red_necro: bool) -> bool:
	
	# the catches in this function are only allowed to catch if 
	# the upgrade is not owned
	
	# returns true if something incorrect is caught
	
	if refundable(red_necro):
		return true
	
	if required_upgrades_not_owned(manual):
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
	
	for c in gv.up[key].cost:
		gv.r[c].a(gv.up[key].cost[c].t)
	
	rt.get_node("global_tip")._call("no")
	rt.get_node("global_tip")._call("buy upgrade " + key)
	
	r_update()
	
	_kill_all_children(key)
	
	#rt.get_node(rt.gnupcon).update_folder()
	
	return true

func required_upgrades_not_owned(manual: bool) -> bool:
	
	var _return_true := false
	
	for x in gv.up[key].requires:
		if not gv.up[x].have and not gv.up[x].refundable:
			_return_true = true
			if manual and gv.open_tab == tab:
				rt.get_node(rt.gnupcon).cont[x].flash()
			break
	
	if _return_true:
		return true
	
	return false

func cannot_afford(manual: bool) -> bool:
	
	# returns the opposite or whatever
	
	if key == "Carcinogenesis":
		if gv.list.upgrade["owned " + str(gv.Tab.MALIGNANT)].size() == 80:
			return false
		return true
	
	if not gv.up[key].cost_check():
		if manual:
			if gv.up[key].active_tooltip_exists:
				rt.get_node("global_tip").tip.price_flash()
		return true
	
	
	return false


#func owned_correct_menu_and_type() -> bool:
#
#	if "cremover" in gv.up[key].type:
#		return false
#
#	if "no" in gv.menuf:
#		if gv.up[key].normal:
#			return false
#
#	elif "ye" in gv.menuf:
#
#		if key in ["upgrade_name", "upgrade_description", "RED NECROMANCY"]:
#
#			cont["nah"] = src.cannot_deactivate_prefab.instance()
#			cont["nah"].text = get_no_message()
#			cont["nah"].rect_position = Vector2(cont["nah"].rect_position.x, cont["nah"].rect_position.y - 20)
#			add_child(cont["nah"])
#
#			return false
#
#	return true

#func get_no_message() -> String:
#
#	var roll : int = randi() % 30
#
#	match roll:
#		0:
#			return "Nah."
#		1:
#			return "No."
#		2:
#			return "Nope."
#		3:
#			return "Don't think so."
#		4:
#			return "Stop."
#		5:
#			return "Yeah, right."
#		6:
#			return "Get out of here."
#		7:
#			return "Nice try."
#		8:
#			return "You think I wouldn't have thought of that?"
#		9:
#			return "I see right through your tricks, punk."
#		10:
#			return "What are you trying to pull?"
#		11:
#			return "Oh, trying to be CLEVER, I see."
#		12:
#			return "Yeah, real smart. Look at the brain on this guy."
#		13:
#			return "Frick outta here."
#		14:
#			return "You little whippersnapper, I oughta beat your mother for this."
#		15:
#			return "I thought I raised you better."
#		16:
#			return "You frickin fricks!!!"
#		17:
#			return "When will you learn that your actions have consequences?"
#		18:
#			return "Shiver me freakin timbers, get out of here."
#		19:
#			return "Talk to the ALT-F4."
#		20:
#			return "You want I should smack ye right in the gob?"
#		21:
#			return "Profane, let alone abhorrent."
#		22:
#			return "*Chuckles.* I knew you'd try this. *Smirks.* So predictable."
#		23:
#			return "Turn around."
#		24:
#			return "You fucking piece of shit."
#		25:
#			return "Nah, bro, scedaddle on out of here."
#		26:
#			return "Why don't you just stop right there?"
#		27:
#			return "STOP. YOU'VE VIOLATED THE LAW."
#		28:
#			return "I will turn this car around."
#		29:
#			return "I thought your mother raised you better than this."
#		_:
#			return "You better not."

func upgrade_effects(active: bool):
	
	match key:
		
		"Limit Break":
			
			if active:
				
				rt.get_node(rt.gnLB).r_limit_break()
				rt.get_node(rt.gnLB).r_set_colors()
				rt.get_node(rt.gnLB).show()
			
			else:
				
				rt.get_node(rt.gnLB).hide()
		
		"ROUTINE":
			
			shadow.show()
			afford()
			
			#r_set_shadow("not owned")
			gv.up[key].have = false
			gv.list.upgrade["owned " + str(tab)].erase(key)
			
			routine.clear()
			routine_shit()
			
			rt.reset(gv.Tab.S1, false)

func routine_shit() -> void:
	
	routine = get_routine_info()
	
	gv.r["tum"].a(routine[0]) # d
	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, "tum", routine[0])
	gv.r["malig"].s(routine[1]) # c
	

func get_routine_info() -> Array:
	
	var base = Big.new(gv.g["tum"].d.t).m(1000)
	if gv.up["CAPITAL PUNISHMENT"].active():
		base.m(gv.run1)
	var routine_d: Big = Big.new(base)
	var routine_c: Big = Big.new(gv.up["ROUTINE"].cost["malig"].t)
	
	if gv.r["malig"].greater(Big.new(routine_c).m(2)):
		
		var _c: Big = Big.new(gv.r["malig"]).d(gv.up["ROUTINE"].cost["malig"].t).roundDown().s(1)
		_c.m(routine_c)
		routine_c.a(_c)
		
		var relative: Big = Big.new(routine_c).d(gv.up["ROUTINE"].cost["malig"].t).roundDown().s(1)
		relative.m(base)
		routine_d.a(relative)
	
	return [routine_d, routine_c]



func w_update_other_upgrades_or_something():
	
	for x in gv.up[key].required_by:
		
		var will_unlock := true
		for v in gv.up[x].requires:
			if not (gv.up[v].have or gv.up[v].refundable):
				will_unlock = false
				break
		if will_unlock:
			gv.up[x].unlocked = true
		
		rt.get_node(rt.gnupcon).cont[x].r_update()
		for v in gv.up[x].required_by:
			rt.get_node(rt.gnupcon).cont[v].r_update()

func _kill_all_children(up : String) -> void:
	
	# follows the entire chain of upgrades that require up at some point in their tree and refunds them all
	# recursive, that's how
	
	for x in gv.up[up].required_by:
		rt.get_node(rt.gnupcon).cont[x].r_update()
		if gv.up[x].refundable:
			
			gv.up[x].refundable = false
			rt.get_node(rt.gnupcon).r_update()
			
			
			for c in gv.up[x].cost:
				gv.r[c].a(gv.up[x].cost[c].t)
			
			#var poop = gv.up[key].type.split(" ")[0] + gv.up[key].type.split(" ")[1].split(" ")[0]
			
			for v in gv.up[x].required_by:
				if gv.up[v].refundable:
					_kill_all_children(x)








func _on_button2_mouse_exited() -> void:
	pass # Replace with function body.


func _on_button2_pressed() -> void:
	pass # Replace with function body.
