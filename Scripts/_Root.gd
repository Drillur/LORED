class_name _root
extends Node2D


const prefab := {
	"dtext": preload("res://Prefabs/dtext.tscn"),
}

var healing_event: HealingEventVico
onready var wallet = get_node("%Wallet")
onready var menu = get_node("%Menu Hub")

var saved_vars := ["tabsExpanded", "WishLogButtonVisible"]

var content := {}
var instances := {}
var upgrade_dtexts := {}

var WishLogButtonVisible := false


const gnLOREDs = "LORED Manager"
const gntaq = "m/v/bot/h/taq"
const gnLB = "misc/Limit Break"
const gnupcon = "m/up_container"

onready var earningsReport = get_node("%Earnings Report")

var task_awaiting := "no"

var ready := false




func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		if get(x) is Big:
			data[x] = get(x).save()
		else:
			data[x] = var2str(get(x))
	
	data["options"] = get_node("%OptionsMenu").save()
	data["EmoteManager"] = EmoteManager.save()
	data["loreds"] = lv.save()
	data["flowers"] = SaveManager.save_vars(Flower)
	
	data["upgrades"] = {}
	for x in gv.up:
		
		data["upgrades"][x] = gv.up[x].save()
	
	
	data["wish"] = taq.save()
	
	return var2str(data)

func _load(data: Dictionary):
	
	#*
	var saved_vars_dict := {}
	
	for x in saved_vars:
		saved_vars_dict[x] = get(x)
	
	var loadedVars = SaveManager.loadSavedVars(saved_vars_dict, data)
	
	for x in saved_vars:
		if not x in loadedVars:
			continue
		set(x, loadedVars[x])
	#*
	
	get_node("%OptionsMenu").load(str2var(data["options"]))
	EmoteManager.load(str2var(data["EmoteManager"]))
	lv.load(str2var(data["loreds"]))
	Flower.load(str2var(data["flowers"]))
	
	for x in gv.up:
		if not x in data["upgrades"].keys():
			continue
		gv.up[x].load(str2var(data["upgrades"][x]))
		
		if gv.up[x].refundable:
			gv.up[x].refund()
		else:
			if gv.up[x].active():
				gv.up[x].apply()
				gv.up[x].manager.r_update()
		
		if not gv.up[x].have:
			continue
		
		if x == "ROUTINE":
			continue
		
		if not x in gv.list.upgrade["owned " + str(gv.up[x].tab)]:
			gv.list.upgrade["owned " + str(gv.up[x].tab)].append(x)
		
		gv.up[x].sync()
	
	
	taq.load(str2var(data["wish"]))
	
	
	activate_lb_effects()




func _ready():
	SaveManager.setRT()
	
	gv.setupStats()
	get_node("%StatsMenu").setup()
	OS.set_low_processor_usage_mode(true)
	set_physics_process(false)
	
	gv.connect("wishReward", self, "wishReward")
	
	get_node(gnLOREDs).setup()
	
#	for x in gv.g:
#		get_node(gnLOREDs).cont[x].start_some()
	
	get_tree().get_root().connect("size_changed", self, "r_window_size_changed")
	
	# ref
	if true:
		taq.setupGNNodes() #001
		textTimer = Timer.new()
		textTimer.one_shot = true
		add_child(textTimer)
		$"%s1tab/m/h/production".self_modulate = gv.COLORS[str(gv.Tab.S1)]
		$"%s1tab/Button".self_modulate = gv.COLORS[str(gv.Tab.S1)]
		$"%s2tab/m/h/production".self_modulate = gv.COLORS[str(gv.Tab.S2)]
		$"%s2tab/Button".self_modulate = gv.COLORS[str(gv.Tab.S2)]
		$"%s3tab/m/h/production".self_modulate = gv.COLORS[str(gv.Tab.S3)]
		$"%s3tab/Button".self_modulate = gv.COLORS[str(gv.Tab.S3)]
		$"%s4tab/m/h/production".self_modulate = gv.COLORS[str(gv.Tab.S4)]
		$"%s4tab/Button".self_modulate = gv.COLORS[str(gv.Tab.S4)]
	
	game_start(SaveManager.load())
	
	taq.turn_in_all_wishes_automatically() #superstinkyitchy
	
	ready = true

func game_start(successful_load: bool) -> void:
	
	lv.lored[lv.Type.STONE].unlock()
	lv.lored[lv.Type.COAL].unlock()
	
	if diff.active_difficulty == diff.Difficulty.SONIC:
		gv.up["Limit Break"].alter_Limit_Break()
	
	if not successful_load:
		newGame()
	
	else:
		for type in lv.Type.values():
			if not lv.lored[type].purchased:
				continue
			if lv.lored[type].purchased:
				lv.lored[type].unlock()
				lv.lored[type].unlockJobResources()
				lv.lored[type].enterActive()
				lv.lored[type].updateMaxDrain()
		
		BuffManager.apply_queued_buffs()
		
		getOfflineEarnings(gv.cur_clock - gv.save_slot_clock - 30)
		
		if gv.version_older_than(SaveManager.game_version, ProjectSettings.get_setting("application/config/Version")):
			get_node("%Menu Hub").get_node("%notice_patchNotes").show()
		
		if WishLogButtonVisible:
			get_node("%WishLogButton").show()
		
		EmoteManager.startEmoting()
	
	taq.seekNewWish()
	
	#print_debug("highest run: ", gv.highest_run)
	#print_debug("most_resources_gained: ", gv.most_resources_gained.toString())
	
	# work
	if true:
		
		# upgrades
		if true:
			
			for x in gv.up:
				if gv.up[x].requires.size() == 0:
					gv.up[x].unlocked = true
			
			gv.check_for_the_s2_shit()
			
			gv.up["ROUTINE"].have = false
		
		#routineLOREDsync()
		
		#watch_stage1and2resourcesAreUnlocked()
	
	# ref
	if true:
		
		healing_event = lv.lored[lv.Type.BLOOD].vico.healing_event
		gv.updateResources()
		get_node("%StatsMenu").updateAll()
		
		# b_upgrade_tab
		if true:
			
			get_node(gnupcon).init()
			
			if not successful_load:
				for x in diff.unlockedUpgrades:
					
					gv.list.upgrade["owned " + str(gv.up[x].tab)].append(gv.up[x].key)
					
					gv.up[x].refundable = false
					gv.up[x].have = true
					gv.up[x].active = true
					
					gv.up[x].apply()
					
					gv.up[x].manager.upgrade_effects(true)
					gv.up[x].manager.r_update()
	
	gv.emit_signal("startGame")
	
	if true:
		
		if gv.dev_mode:
			$"%devButton".show()
			unlock_tab(gv.Tab.NORMAL)
			unlock_tab(gv.Tab.MALIGNANT)
			unlock_tab(gv.Tab.EXTRA_NORMAL)
			unlock_tab(gv.Tab.RADIATIVE)
			unlock_tab(gv.Tab.S2)
			unlock_tab(gv.Tab.S3)
			lv.lored[lv.Type.BLOOD].unlock()
			lv.lored[lv.Type.WITCH].unlock()
			lv.lored[lv.Type.WITCH].addJob(lv.Job.SIFT_SEEDS)
			lv.lored[lv.Type.WITCH].addJob(lv.Job.PLANT_SEED)
			
	
	var t = Timer.new()
	add_child(t)
	t.start(0.1)
	yield(t, "timeout")
	t.queue_free()
	
	r_window_size_changed()

func newGame():
	
	for x in gv.up:
		if gv.up[x].requires.size() == 0:
			gv.up[x].unlocked = true
		gv.up[x].sync()
	
	lv.lored[lv.Type.STONE].forcePurchase()
	lv.lored[lv.Type.STONE].currentFuel = Big.new(lv.lored[lv.Type.STONE].fuelStorage).m(0.2)
	
	gv.setResource(gv.Resource.STONE, 5)
	
	BuffManager.apply_queued_buffs()





func _input(ev):
	
	if healing_event.mode == healing_event.Mode.ACTIVE:
		return
	
	if ev.is_class("InputEventMouseMotion"):
		return
	
	if ev.is_action_pressed("ui_cancel"):
		b_tabkey(KEY_ESCAPE)
		return
	
	if ev.is_action_pressed("CTRLS"):
		hideAllMenus()
		get_node("%SaveMenu").show()
		return
	
	if Input.is_key_pressed(KEY_1):
		b_tabkey(KEY_1)
		return
	
	if Input.is_key_pressed(KEY_2):
		b_tabkey(KEY_2)
		return
	
	if Input.is_key_pressed(KEY_3):
		b_tabkey(KEY_3)
		return
	
	if Input.is_key_pressed(KEY_4):
		b_tabkey(KEY_4)
		return
	
	
	if ev.is_action_pressed("ui_upgrade_menu"):
		
		if get_node(gnupcon).visible:
			get_node(gnupcon).hide()
		
		else:
			menu.hide()
			get_node(gnupcon).show()
		
		return
	
	if ev.is_action_pressed("T"):
		if wallet.visible:
			wallet.hide()
		else:
			hideAllMenus()
			wallet.show()
		return
	
	if Input.is_key_pressed(KEY_Q):
		b_tabkey(KEY_Q)
		return

	if Input.is_key_pressed(KEY_W):
		b_tabkey(KEY_W)
		return

	if Input.is_key_pressed(KEY_E):
		b_tabkey(KEY_E)
		return

	if Input.is_key_pressed(KEY_R):
		b_tabkey(KEY_R)
		return

	if Input.is_key_pressed(KEY_A):
		b_tabkey(KEY_A)
		return
	
	if Input.is_key_pressed(KEY_EQUAL):
		b_tabkey(KEY_ESCAPE)
		return


func _notification(ev):
	
	if ev == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		
		get_node("global_tip")._call("no")
		
		if OS.get_unix_time() - gv.cur_clock <= 1: return
		var clock_dif = OS.get_unix_time() - gv.last_clock
		if clock_dif <= 1: return
		
		getOfflineEarnings(clock_dif)
	
	elif ev == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		gv.last_clock = OS.get_unix_time()


func hideAllMenus():
	wallet.hide()
	get_node("%SaveMenu").hide()
	get_node("%OptionsMenu").hide()
	get_node("%Earnings Report").hide()
	get_node("%StatsMenu").hide()
	get_node("%WishLog").hide()
	get_node("%PatchNotesMenu").hide()
	get_node(gnupcon).clear_tip_n_stuff()
	get_node(gnupcon).hide()
	menu.hide()



func exitToMainMenu():
	close()
	get_tree().change_scene("res://Scenes/Main Menu.tscn")
	gv.active_scene = gv.Scene.MAIN_MENU


func close():
	taq.close() #002
	Flower.close()
	gv.close()
	EmoteManager.close()
	healer.close()

func _on_Upgrades_pressed() -> void:
	
	if get_node(gnupcon).visible:
		
		get_node(gnupcon).hide()
		
		return
	
	get_node(gnupcon).show()

func _on_mouse_exited() -> void:
	get_node("global_tip")._call("no")



func _on_s1tab_pressed() -> void:
	b_tabkey(KEY_1)
func _on_s2tab_pressed() -> void:
	b_tabkey(KEY_2)
func _on_s3tab_pressed() -> void:
	b_tabkey(KEY_3)
func _on_s4tab_pressed() -> void:
	b_tabkey(KEY_4)



#func watch_stage1and2resourcesAreUnlocked():
#	return #note
#	var t = Timer.new()
#	add_child(t)
#
#	var properSize = gv.list.lored[gv.Tab.S1].size() + gv.list.lored[gv.Tab.S2].size()
#
#	t.start(1)
#	yield(t, "timeout")
#
#	while not gv.list["unlocked resources"].size() == properSize:
#
#		for x in gv.g:
#			gv.g[x].unlockResource()
#
#		t.start(10)
#		yield(t, "timeout")
#
#	t.queue_free()

#func routineLOREDsync():
#	return
#	var t = Timer.new()
#	add_child(t)
#
#	while true:
#
#		t.start(10)
#		yield(t, "timeout")
#
#		lv.syncLOREDs()
#
#	t.queue_free()

func getOfflineEarnings(timeOffline: int):
	
	if timeOffline <= 0:
		return
	
	lv.getOfflineEarnings(timeOffline)
	
#	only display fuel resource ratios if the ratio is < 1. delete the Fuel Dependency Column in resource production. add Gain and Drain columns. why not
#	when earnings are reported, and Coal refuels, his net is negative like he isnt working.
#	but he is!!!
#	so when he resumes work, he isnt updating his gain. why?
#	also, if timeOffline < 0, hide Earnings Report.
#		log timeOffline, and say something like "No offline earnings gained."
#	add a button in Earnings Report to make it go away
#	and make it so it automatically goes away in 10 seconds. but log all of the yield amounts
#	if scrollContainer is scrolled, then stop the timer.
#	the button to hide it should say "Log Report and Close"
#	escape should hide the report
	
	if timeOffline > 60:
		earningsReport.setup(timeOffline)



func wishReward(type: int, key: String) -> void:
	
	match type:
		gv.WishReward.TAB:
			unlock_tab(int(key), true)




func remove_surplus_tasks():
	
	if taq.cur_tasks <= taq.max_tasks:
		return
	
	print_debug(taq.cur_tasks, " tasks; the maximum is ", taq.max_tasks, ". Deleting some.")
	
	for x in taq.task:
		if taq.cur_tasks == taq.max_tasks:
			break
		x.die(false)


func activate_lb_effects():
	
	if gv.up["Limit Break"].active():
		get_node(gnLB).show()
		get_node(gnLB).setColors()
		get_node(gnLB).update()
	
	else:
		
		get_node(gnLB).hide()



func r_window_size_changed() -> void:
	
	var win :Vector2= get_viewport_rect().size
	
	if win.y == -INF:
		return
	
	get_node("m").rect_size = Vector2(win.x / scale.x, win.y / scale.y)
	get_node(gnLOREDs).rect_size = get_node("m").rect_size



func reset(reset_type: int, manual := true) -> void:
	
	gv.emit_signal("Reset", reset_type)
	
	if reset_type != -1:
		# reset_type, unless -1, is the value of gv.Tab.S1, gv.Tab.S2, gv.Tab.S3, or gv.Tab.S4
		# this reduces reset_type to be 1, 2, 3, or 4.
		reset_type = 1 + reset_type - gv.Tab.S1
	
	gv.durationSinceLastReset = 0
	
	reset_stats(reset_type)
	
	activate_refundable_upgrades(reset_type) # used to be after the next 3 reset_ lines
	reset_upgrades(reset_type, manual)
	reset_resources(reset_type)
	reset_loreds(reset_type)
	taq.reset(reset_type)
	reset_limit_break(reset_type)
	
	BuffManager.apply_queued_buffs()
	
	# ref
	if true:
		
		if reset_type == -1:
			for t in gv.Tab:
				unlock_tab(gv.Tab[t], false)
		
		if reset_type >= 2:
			unlock_tab(gv.Tab.EXTRA_NORMAL, false)
	
	if manual:
		b_tabkey(KEY_1)
	
	if reset_type == -1:
		get_tree().reload_current_scene()
	else:
		var t = Timer.new()
		add_child(t)
		t.start(0.25)
		yield(t,"timeout")
		
		lv.syncLOREDs()
		
		if (gv.up["dust"].active() and reset_type > 1) or not gv.up["dust"].active():
			
			lv.lored[lv.Type.STONE].forcePurchase()
			
			if gv.up["aw <3"].active():
				lv.lored[lv.Type.COAL].forcePurchase()
	

func reset_stats(reset_type: int):
	
	if reset_type > gv.highest_run:
		gv.highest_run = reset_type
		gv.most_resources_gained = Big.new(0)
		
	
	if reset_type == gv.highest_run:
		
		var reset_key: int = gv.highestResetKey()
		
		if gv.most_resources_gained.less(gv.resource[reset_key]):
			gv.most_resources_gained = Big.new(gv.resource[reset_key])
	
	gv.run1 = gv.run1 + 1
	if reset_type >= 2:
		gv.run2 = gv.run2 + 1
	if reset_type >= 3:
		gv.run3 = gv.run3 + 1
	if reset_type >= 4:
		gv.run4 = gv.run4 + 1
	
	for x in reset_type:
		gv.list.lored["active " + str(x + gv.Tab.S1)].clear()
	
	gv.list.lored["active " + str(gv.Tab.S1)].append("coal")
	gv.list.lored["active " + str(gv.Tab.S1)].append("stone")
	gv.list.lored["active " + str(gv.Tab.S1)].append("irono")
	gv.list.lored["active " + str(gv.Tab.S1)].append("copo")
	gv.list.lored["active " + str(gv.Tab.S1)].append("cop")
	gv.list.lored["active " + str(gv.Tab.S1)].append("iron")

func reset_upgrades(reset_type: int, manual: bool):
	
	# full reset
	if reset_type == -1:
		
		unlock_tab(gv.Tab.EXTRA_NORMAL, false)
		gv.s2_upgrades_may_be_autobought = false
		
		for x in gv.up:
			
			gv.up[x].refundable = false
			
			if not gv.up[x].have:
				continue
			
			gv.up[x].reset()
			
			get_node(gnupcon).cont[x].r_update()
		
		# upgrade tabs are locked in the reset func
		
		return
	
	# for s2 upgrade autobuyers; won't buy if loreds in own_list aren't owned
	
	# routine reset; don't reset every upgrade
	for r in range(reset_type, 0, -1):
		if r == 2:
			unlock_tab(gv.Tab.EXTRA_NORMAL, false)
			gv.s2_upgrades_may_be_autobought = false
		for x in gv.list.upgrade[ str(r + gv.Tab.S1 - 1)]:
			reset_upgrade(x, reset_type, manual)
	
	for x in gv.up:
		if not x in get_node(gnupcon).cont.keys():
			continue
		get_node(gnupcon).cont[x].r_update()

func reset_upgrade(x: String, reset_type: int, manual: bool):
	
	var up = gv.up[x]
	
	if not up.have:
		if up.refundable and int(up.type[1]) < reset_type:
			up.refund()
			get_node(gnupcon).cont[up.key].r_update()
		return
	
	if x in ["Limit Break"]:
		gv.reset_lb()
	
	if int(up.type[1]) == reset_type and not up.normal:
		
		# ex: if Chemoing, and up[x] is type s2m, partial_reset() it
		
		if x in ["IT'S GROWIN ON ME", "I DRINK YOUR MILKSHAKE"]:
			if not manual:
				return
		
		up.partial_reset()
		
		if manual and x == "PROCEDURE":
			get_node(gnupcon).cont["ROUTINE"].routine_shit()
		
		return
	
	# send reset_type, which means
	# if another upgrade has caused the upgrade in question (x) to perist through reset, it will return here immediately
	if up.reset(reset_type):
		
		get_node(gnupcon).cont[x].upgrade_effects(false)
		
		# ref
		get_node(gnupcon).cont[x].r_update()
		gv.list.upgrade["owned " + str(up.tab)].erase(up.key)

func reset_resources(reset_type: int):
	
	if reset_type == -1:
		
		gv.resource[gv.Resource.STONE].a(5)
		
		return
	
	var lb = Big.new(gv.up["Limit Break"].effects[0].effect.t)
	
	var resetApproved := true
	
	if reset_type == 1 and gv.up["CONDUCT"].active():
		resetApproved = false
	
	
	if resetApproved:
		for reset in reset_type:
			
			reset += 1
			
			for resource in gv.list["stage " + str(reset) + " resources"]:
				if reset_type == 1 and resource == gv.Resource.MALIGNANCY:
					continue
				elif reset_type == 2 and resource == gv.Resource.TUMORS:
					continue
				gv.setResource(resource, Big.new(0))
			
			if reset == 1:
				gv.addToResource(gv.Resource.STONE, Big.new(lb).m(5.0))
				gv.addToResource(gv.Resource.IRON, Big.new(lb).m(10.0))
				gv.addToResource(gv.Resource.COPPER, Big.new(lb).m(10.0))
				gv.addToResource(gv.Resource.MALIGNANCY, Big.new(Big.max(gv.resource[gv.Resource.MALIGNANCY], 10)))
				if gv.up["FOOD TRUCKS"].active(true):
					gv.addToResource(gv.Resource.COPPER, Big.new(lb).m(100.0))
					gv.addToResource(gv.Resource.IRON, Big.new(lb).m(100.0))
			
			if reset == 2:
				gv.setResource(gv.Resource.WOOD, Big.new(lb).m(200))
				gv.setResource(gv.Resource.SOIL, Big.new(lb).m(50))
				gv.setResource(gv.Resource.TREES, Big.new(lb).m(5))
				gv.setResource(gv.Resource.STEEL, Big.new(lb).m(200))
				gv.setResource(gv.Resource.HARDWOOD, Big.new(lb).m(200))
				gv.setResource(gv.Resource.WIRE, Big.new(lb).m(200))
				gv.setResource(gv.Resource.GLASS, Big.new(lb).m(500))
				gv.setResource(gv.Resource.AXES, Big.new(lb).m(50))

func reset_loreds(reset_type: int):
	
	if reset_type == -1:
		# must be kept for BROWSER version. Ugh!!!!
		for x in lv.lored:
			lv.lored[x].reset()
		return
	
	if gv.up["dust"].active():
		if reset_type == 1:
			return
	
	for x in lv.lored:
		if lv.lored[x].stage > reset_type:
			continue
		
		lv.lored[x].reset()

func activate_refundable_upgrades(reset_type: int):
	
	for x in gv.up:
		if not gv.up[x].refundable:
			continue
		if not str(reset_type) == gv.up[x].type[1]:
			continue
		
		
		if not gv.up[x].normal:
			gv.list.upgrade["owned " + str(gv.up[x].tab)].append(gv.up[x].key)
		
		gv.up[x].refundable = false
		gv.up[x].have = true
		gv.up[x].active = true
		
		gv.stats["UpgradesPurchased"][gv.up[x].tab] += 1
		gv.emit_signal("UpgradesPurchased", gv.up[x].tab)
		
		gv.up[x].apply()
		
		get_node(gnupcon).cont[x].upgrade_effects(true)
		
		# quest stuff
		taq.increaseProgress(gv.Objective.UPGRADE_PURCHASED, x)
		
		get_node(gnupcon).cont[x].r_update()


func reset_limit_break(reset_type: int):
	
	if reset_type == -1:
		
		gv.reset_lb()
		
		activate_lb_effects()
		
		return
	
	gv.up["Limit Break"].sync()




# buttons
func _clear_content():
	for x in content:
		if not is_instance_valid(content[x]): continue
		content[x].queue_free()
	content.clear()

func _on_menuButton_pressed() -> void:
	b_tabkey(KEY_ESCAPE)
func _on_openSaveMenu() -> void:
	get_node("%Menu Hub").hide()
	get_node("%SaveMenu").show()
func _on_openOptionsMenu() -> void:
	get_node("%Menu Hub").hide()
	get_node("%OptionsMenu").show()
func _on_openStatsMenu() -> void:
	get_node("%Menu Hub").hide()
	get_node("%StatsMenu").show()
func _on_openPatchNotesMenu() -> void:
	get_node("%Menu Hub").hide()
	get_node("%PatchNotesMenu").show()
	get_node("%Menu Hub").get_node("%notice_patchNotes").hide()
func _on_openLogContainer() -> void:
	get_node("%Menu Hub").hide()
	get_node("%WishLog").show()
func openWishLog():
	get_node("%WishLog").visible = not get_node("%WishLog").visible


func _on_exitToMainMenu_pressed() -> void:
	exitToMainMenu()




func b_tabkey(key):
	
	$global_tip._call("no")
	
	if earningsReport.visible:
		earningsReport.close()
		if key == KEY_ESCAPE:
			return
	
	match key:
		
		KEY_ESCAPE:
			
			if get_node(gnupcon).visible:
				
				get_node(gnupcon).hide()
				
				return
			
			if get_node("%SaveMenu").visible:
				get_node("%SaveMenu").hide()
				return
			
			if get_node("%OptionsMenu").visible:
				get_node("%OptionsMenu").hide()
				return
			
			if get_node("%StatsMenu").visible:
				get_node("%StatsMenu").hide()
				return
			
			if get_node("%PatchNotesMenu").visible:
				get_node("%PatchNotesMenu").hide()
				return
			
			if get_node("%WishLog").visible:
				get_node("%WishLog").hide()
				return
			
			if wallet.visible:
				wallet.hide()
				return
			
			# open the menu
			if not menu.visible:
				menu.show()
				return
			
			# close the menu (should probably stay at the bottom. if must move above something, make this func return a bool. if return g.visible = true, then RETURN below the func)
			menu.hide()
		
		KEY_1:
			switch_tabs(gv.Tab.S1)
		
		KEY_2:
			switch_tabs(gv.Tab.S2)
		
		KEY_3:
			switch_tabs(gv.Tab.S3)
		
		KEY_4:
			switch_tabs(gv.Tab.S4)
		
		KEY_Q:
			open_up_tab(gv.Tab.NORMAL)
		
		KEY_W:
			open_up_tab(gv.Tab.MALIGNANT)
		
		KEY_E:
			open_up_tab(gv.Tab.EXTRA_NORMAL)
		
		KEY_R:
			open_up_tab(gv.Tab.RADIATIVE)
		
		KEY_A:
			open_up_tab(gv.Tab.RUNED_DIAL)

func switch_tabs(target: int):
	
	if not target in gv.unlocked_tabs:
		return
	
	menu.hide()
	wallet.hide()
	get_node("%SaveMenu").hide()
	get_node("%WishLog").hide()
	get_node("%OptionsMenu").hide()
	get_node("%StatsMenu").hide()
	get_node("%PatchNotesMenu").hide()
	
	# stored page vertical
	gv.tab_vertical[gv.page - gv.Tab.S1] = get_node(gnLOREDs + "/%sc").scroll_vertical
	
	gv.page = target
	get_node(gnupcon).hide()
	
	get_node(gnLOREDs).switchTab(str(target - gv.Tab.S1 + 1))
	
	var t = Timer.new()
	t.set_wait_time(0.005)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	get_node(gnLOREDs + "/%sc").scroll_vertical = gv.tab_vertical[gv.page - gv.Tab.S1]

func open_up_tab(tab: int):
	
	if not tab in gv.unlocked_tabs:
		return
	
	hideAllMenus()
	
	if get_node(gnupcon).visible and tab == gv.open_tab:
		b_tabkey(KEY_ESCAPE)
		return
	
	get_node(gnupcon).select_tab(tab)
	get_node(gnupcon).show()
	
	get_node("global_tip")._call("no")

func b_move_map(x, y):

	$map.status = "no"
	$map.set_global_position(Vector2(x, y))


func unlock_tab(tab: int, add := true):
	
	if add:
		if tab in gv.unlocked_tabs:
			return
		gv.unlocked_tabs.append(tab)
	else:
		gv.unlocked_tabs.erase(tab)
	
	match tab:
		gv.Tab.NORMAL:
			get_node("%upgradesTab").visible = add
			continue
		gv.Tab.NORMAL, gv.Tab.MALIGNANT, gv.Tab.EXTRA_NORMAL, gv.Tab.RADIATIVE, gv.Tab.RUNED_DIAL, gv.Tab.SPIRIT, gv.Tab.s4n, gv.Tab.s4m:
			if add:
				gv.emit_signal("stats_unlockTab", tab)
				get_node(gnupcon).unlock_tab(tab)
			else:
				get_node(gnupcon).lock_tab(tab)
		gv.Tab.S2:
			gv.emit_signal("stats_unlockRuns")
			$"%s1tab".visible = add
			if add:
				gv.unlocked_tabs.append(gv.Tab.S1)
			else:
				gv.unlocked_tabs.erase(gv.Tab.S1)
			continue
		gv.Tab.S2, gv.Tab.S3, gv.Tab.S4:
			get_node("%s" + str(tab - gv.Tab.S1 + 1) + "tab").visible = add
			if add:
				gv.emit_signal("tab_unlocked", tab)
			else:
				gv.emit_signal("tab_locked", tab)


# - - - Handy

var textTimer: Timer
func throwTexts(texts: Array):
	
	for textDetails in texts:
		
		throwText(textDetails)
		
		textTimer.start(0.3)
		yield(textTimer, "timeout")

func throwText(details: Dictionary):
	
	var ft = gv.SRC["flying text"].instance()
	
	ft.init(details)
	
	ft.rect_position = Vector2(details["position"].x, details["position"].y - get_node("WishAnchor").position.y)
	
	get_node("WishAnchor").add_child(ft)

func wishNotice():
	if not gv.option["wishVicosOnMainScreen"]:
		if not get_node("%WishLog").visible:
			get_node("%wishNotice").show()
func clearWishNotice():
	if not gv.option["wishVicosOnMainScreen"]:
		get_node("%wishNotice").hide()



#onready var attribute_vico: Panel = $AttributeVico
#var test_hp := Attribute.new(100)
#var i = 0
func _on_Button_pressed() -> void:
#	if i == 0:
#		attribute_vico.setup(AttributeVico.Type.HEALTH, test_hp)
#		i += 1
#		return
#	if test_hp.get_current().less(10):
#		test_hp.set_to(100)
#		return
#	test_hp.subtract(rand_range(1, 25))
	#lv.lored[lv.Type.WITCH].promote()
	lv.lored[lv.Type.BLOOD].queue_healing_event(HealingEvent.Type.BLOOD_LOSS)
	pass















