class_name UpgradeBlock
extends MarginContainer



var rt: Node2D


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
onready var checkbox = get_node("%CheckBox")

var cont := {}

var routine := []

func _ready() -> void:
	if name in gv.up.keys():
		setup(name)
	
	if gv.active_scene == gv.Scene.MAIN_MENU:
		icon.lock.hide()
		button.hint_tooltip = name
		checkbox.uncheck()
	elif gv.active_scene == gv.Scene.ROOT:
		rt = get_node("/root/Root")

func setup(_key):
	
	key = _key
	tab = gv.up[key].tab
	
	gv.up[key].manager = self
	
	name = key
	
	afford.self_modulate = gv.up[key].color
	button.self_modulate = gv.up[key].color
	get_node("icon shadow").self_modulate = gv.up[key].color
	
	if gv.up[key].have:
		shadow.hide()
	
	icon.init(key)
	
	afford()
	
	yield(get_tree().create_timer(0.5), "timeout")
	r_update()


func _on_Button_mouse_entered() -> void:
	
	if gv.active_scene == gv.Scene.ROOT:
		rt.get_node("global_tip")._call("buy upgrade " + key)
	elif gv.active_scene == gv.Scene.MAIN_MENU:
		return
	
	set_mouse_cursor_shape()

func _on_Button_mouse_exited() -> void:
	
	if gv.active_scene == gv.Scene.ROOT:
		gv.up[key].active_tooltip_exists = false
		rt.get_node("global_tip")._call("no")


func _on_Button_pressed() -> void:
	if gv.active_scene == gv.Scene.MAIN_MENU:
		if name in diff.unlockedUpgrades:
			diff.lock_upgrade(name)
		else:
			diff.unlock_upgrade(name)
	elif gv.active_scene == gv.Scene.ROOT:
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
	
	checkbox.visible = not gv.up[key].have and not gv.up[key].refundable and not icon.lock.visible
	
	if gv.up[key].refundable:
		shadow.hide()
		return
	
	if icon.lock.visible or gv.up[key].have:
		shadow.hide()
	else:
		shadow.show()

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
	
	afford.hide()
	
	if gv.up[key].have or gv.up[key].refundable:
		afford.modulate = Color(0.2, 0.2, 0.2)
		button.modulate = Color(0.2, 0.2, 0.2)
		return
	
	if gv.open_tab != tab:
		return
	
	if can_purchase():
		afford.show()
		afford.modulate = Color(1, 1, 1)
		button.modulate = Color(1, 1, 1)
		checkbox.check()
	else:
		afford.hide()
		button.modulate = Color(1, 1, 1)
		checkbox.uncheck()


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


func autobuy() -> bool:
	
	# returns true if was bought.
	
	if not gv.up[key].autobuy:
		return false
	
	if not gv.s2_upgrades_may_be_autobought:
		if key in gv.list.upgrade[str(gv.Tab.EXTRA_NORMAL)]:
			return false
	
	return buy_upgrade(false, true)




func upgrade_bought(manual: bool, red_necro := false):
	
	if gv.up[key].normal or red_necro:
		
		taq.increaseProgress(gv.Objective.UPGRADE_PURCHASED, key)
		
		gv.up[key].purchased()
		
		if gv.up[key].have:
			shadow.hide()
		
		set_mouse_cursor_shape()
		
		upgrade_effects(true)
		
		if manual:
			
			if key == "Carcinogenesis":
				rt.reset(gv.Tab.S3)
				gv.resource[gv.Resource.EMBRYO].a(1)
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
		
		w_update_other_upgrades_or_something()
		
		gv.emit_signal("upgrade_purchased", key, routine)
		
		r_update()
	
	else:
		
		gv.up[key].refundable = true
		gv.up[key].takeaway_price()
		
		r_update()
		
		w_update_other_upgrades_or_something()
		
		gv.up[key].active_tooltip.display()
	
	disconnect_resource_signal()
	
	afford()

func buy_upgrade(manual := true, red_necro := false) -> bool:
	
	if gv.up[key].have:
		return false
	
	if unowned_catches(manual, red_necro):
		return false
	
	upgrade_bought(manual, red_necro)
	return true

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
		gv.addToResource(c, gv.up[key].cost[c].t)
	
	connect_resource_signal()
	
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
			if rt.get_node("global_tip").tip_filled:
				if "buy upgrade" in rt.get_node("global_tip").type:
					rt.get_node("global_tip").tip.price_flash()
		return true
	
	
	return false


func upgrade_effects(active: bool):
	
	match key:
		
		"Limit Break":
			
			if active:
				
				rt.get_node(rt.gnLB).setColors()
				rt.get_node(rt.gnLB).update()
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
	
	gv.resource[gv.Resource.TUMORS].a(routine[0]) # d
	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.TUMORS), routine[0])
	gv.resource[gv.Resource.MALIGNANCY].s(routine[1]) # c
	

func get_routine_info() -> Array:
	
	var base = Big.new(lv.lored[lv.Type.TUMORS].output).m(1000)
	if gv.up["CAPITAL PUNISHMENT"].active():
		base.m(gv.run1)
	var routine_d: Big = Big.new(base)
	var routine_c: Big = Big.new(gv.up["ROUTINE"].cost[gv.Resource.MALIGNANCY].t)
	
	if gv.resource[gv.Resource.MALIGNANCY].greater(Big.new(routine_c).m(2)):
		
		var _c: Big = Big.new(gv.resource[gv.Resource.MALIGNANCY]).d(gv.up["ROUTINE"].cost[gv.Resource.MALIGNANCY].t).roundDown().s(1)
		_c.m(routine_c)
		routine_c.a(_c)
		
		var relative: Big = Big.new(routine_c).d(gv.up["ROUTINE"].cost[gv.Resource.MALIGNANCY].t).roundDown().s(1)
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
		
		if not gv.up[x].manager.autobuy():
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
			rt.get_node(rt.gnupcon).r_update([gv.up[x].tab])
			
			
			for c in gv.up[x].cost:
				gv.resource[c].a(gv.up[x].cost[c].t)
			
			#var poop = gv.up[key].type.split(" ")[0] + gv.up[key].type.split(" ")[1].split(" ")[0]
			
			for v in gv.up[x].required_by:
				if gv.up[v].refundable:
					_kill_all_children(x)



func _on_visibility_changed() -> void:
	if visible and gv.active_scene == gv.Scene.ROOT:
		afford()


func connect_resource_signal():
	gv.connect("resourceChanged", self, "check_if_can_afford_upgrade")

func disconnect_resource_signal():
	gv.disconnect("resourceChanged", self, "check_if_can_afford_upgrade")


func check_if_can_afford_upgrade(resource: int):
	
	if gv.up[key].active_or_refundable():
		return
	if not resource in gv.up[key].cost.keys():
		return
	
	if not autobuy():
		afford()


func check_the_checkbox_from_the_main_menu():
	checkbox.check()
func uncheck_the_checkbox_from_the_main_menu():
	checkbox.uncheck()
