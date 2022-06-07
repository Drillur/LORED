class_name _root
extends Node2D



const prefab := {
	"dtext": preload("res://Prefabs/dtext.tscn"),
	"confirmation popup": preload("res://Prefabs/lored_buy.tscn"),
}

onready var menu = get_node("m/Menu")

onready var main_menu_container = get_node("m/v/top/h/main menu")

var saved_vars := ["emote_events"]

var content := {}
var instances := {}
var upgrade_dtexts := {}


const gnLOREDs = "m/v/LORED Manager"
const gntaq = "m/v/bot/h/taq"
const gnLB = "m/v/top/h/r/Limit Break"
const gnupcon = "m/up_container"

var task_awaiting := "no"

var patched := false # true if in save.data the version is < current version




var hax = 1 # 1 for normal

func _ready():
	
	gv.active_scene = gv.Scene.ROOT
	SaveManager.setRT()
	
	OS.set_low_processor_usage_mode(true)
	set_physics_process(false)
	
	gv.connect("wishReward", self, "wishReward")
	
	# menu and stats
	if true:
		
		if "pc" in gv.PLATFORM:
			gv.option["FPS"] = 2
		else:
			gv.option["FPS"] = 1
	
	get_node(gnLOREDs).setup()
	get_node("m/v/top/h/resources").setup()
	
	for x in gv.g:
		
		get_node(gnLOREDs).cont[x].start_some()
	
	get_tree().get_root().connect("size_changed", self, "r_window_size_changed")
	
	# ref
	if true:
		taq.setupGNNodes() #001
		main_menu_container.hide()
	
	game_start(SaveManager.load())

func game_start(successful_load: bool) -> void:
	
	if not successful_load:
		newGame()
	
	else:
		for x in gv.g:
			if gv.g[x].unlocked:
				continue
			if gv.g[x].active:
				gv.g[x].unlocked = true
	
	taq.seekNewWish()
	
	print_debug("highest run: ", gv.highest_run)
	print_debug("most_resources_gained: ", gv.most_resources_gained.toString())
	
	# work
	if true:
		
		# upgrades
		if true:
			
			for x in gv.up:
				if gv.up[x].requires.size() == 0:
					gv.up[x].unlocked = true
			
			gv.check_for_the_s2_shit()
			
			gv.up["ROUTINE"].have = false
		
		gv.syncLOREDs(true)
		
		fix_shit()
		
		updateCurSession()
		
		routineLOREDsync()
	
	# ref
	if true:
		
		# lored
		emote_ville()
		
		# menu and tab shit
		if true:
			
			menu.setup()

			if patched:
				get_node("m/v/top/h/menu_button/patched_alert").show()
				menu.patched_alert.show()
				patched = false
		
		# b_upgrade_tab
		if true:
			
			get_node(gnupcon).init()
		
		# map
		$map.init()
	
	# hax
	if true:
		
		if gv.hax_pow < 1:
			for q in gv.quest:
				if q.key == gv.Quest.HORSE_DOODIE:
					break
				for x in gv.list.lored[gv.Tab.S1] + gv.list.lored[gv.Tab.S2]:
					gv.r[x].a("1e10")
					gv.g[x].manager.buy()
				q.turn_in(false)
		
		if gv.dev_mode:
			$Button.show()
	
	# tasks
	if true:
		
		#task
#		if not get_node(gnLOREDs).cont["water"].visible and gv.Quest.A_NEW_LEAF in taq.completed_quests:
#			get_node(gnLOREDs).cont["water"].show()
#			get_node(gnLOREDs).cont["seed"].show()
#			get_node(gnLOREDs).cont["tree"].show()
		
		#task
#		if gv.Quest.SPREAD in taq.completed_quests and not gv.Quest.CONSUME in taq.completed_quests:
#			if gv.r["malig"].less(10) and not gv.g["tar"].active:
#				gv.r["malig"] = Big.new(10)
		pass
	
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
	
	for x in gv.g:
		gv.g[x].manager.start_all()
	
	gv.r["stone"] = Big.new(5)




func updateCurSession():
	
	var t = Timer.new()
	add_child(t)
	
	while true:
		
		t.start(1)
		yield(t, "timeout")
		
		menu.update_cur_session(gv.cur_session)
	
	t.queue_free()

func _input(ev):
	
	if ev.is_class("InputEventMouseMotion"):
		return
	
	if ev.is_action_pressed("ui_cancel"):
		b_tabkey(KEY_ESCAPE)
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
			
			if get_node(gnupcon).get_node("v").visible:
				get_node("global_tip")._call("no")
				get_node(gnupcon).go_back()
			else:
				get_node(gnupcon).hide()
				
			
			return
		
		else:
			menu.hide()
			get_node(gnupcon).show()
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
	
	#task
#	if Input.is_key_pressed(KEY_KP_ENTER) or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_ENTER):
#
#		if gn_tasks.ready_task_count > 0:
#			var _content = []
#			for x in taq.task:
#				_content.append(x)
#			if $global_tip.tip_filled:
#				if "taq" in $global_tip.tip.type:
#					$global_tip._call("no")
#			for x in _content:
#				x.attempt_turn_in(false)
#			return
#
#		if taq.cur_quest != -1:
#			taq.turnInMainQuest(true)
#
#		return
	
	if Input.is_key_pressed(KEY_EQUAL):
		b_tabkey(KEY_ESCAPE)
		return
func _notification(ev):
	
	if ev == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		
		get_node("global_tip")._call("no")
		
		if OS.get_unix_time() - gv.cur_clock <= 1: return
		var clock_dif = OS.get_unix_time() - gv.last_clock
		if clock_dif <= 1: return
		
		w_total_per_sec(clock_dif)
	
	elif ev == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		gv.last_clock = OS.get_unix_time()




func _on_menu_pressed() -> void:
	b_tabkey(KEY_ESCAPE)
func _on_main_menu_pressed() -> void:
	close()
	get_tree().change_scene("res://Scenes/Main Menu.tscn")

func close():
	taq.close() #002
	gv.close()

func _on_upgrades_pressed() -> void:
	
	# duplicate code, also found under _input -> ui_upgrades or whatever
	
	if get_node(gnupcon).visible:
		
		get_node(gnupcon).go_back()
		get_node(gnupcon).hide()
		
		return
	
	get_node(gnupcon).show()

func _on_mouse_exited() -> void:
	get_node("global_tip")._call("no")


func _on_s1_pressed() -> void:
	b_tabkey(KEY_1)

func _on_s2_pressed() -> void:
	b_tabkey(KEY_2)

func _on_s3_pressed() -> void:
	b_tabkey(KEY_3)



func fix_shit():
	
	if gv.run1 == 1 and gv.r["growth"].less(10) and gv.g["growth"].f.f.less(3):
		gv.g["growth"].f.f = Big.new(3)

func routineLOREDsync():
	
	var t = Timer.new()
	add_child(t)
	
	while true:
		
		t.start(10)
		yield(t, "timeout")
		
		gv.syncLOREDs()
	
	t.queue_free()

func offline_earnings(time_offline: float) -> void:
	
	if time_offline <= 0:
		return
	
	print_debug("time offline: ", gv.parse_time(time_offline))
	
	# 1 identify which LORED is the quickest.
	# 2 multiply every lored's speed so that the quickest lored's speed is at 0.01.
	# 3 reduce autobuyer check time to 0.1
	# 4 let it run for 10? cycles.
	# 4 cycle: defined as the SLOWEST lored completing 1 job
	# 5 every lored gets the amount of resources it generated for that duration * time_offline
	# 6 reset everything to normal
	# 7 force autobuyers to purchase faster
	
	# 1
	var unlocked_loreds := []
	var quickest: String
	var slowest: String
	if true:
		var quick = 10.0
		var slow = 0.0
		for L in gv.g:
			if not gv.g[L].unlocked:
				continue
			unlocked_loreds.append(L)
			if gv.g[L].speed.t < quick:
				quick = gv.g[L].speed.t
				quickest = L
			if gv.g[L].speed.t > slow:
				slow = gv.g[L].speed.t
				slowest = L
	
	# resources before
	var before := {}
	for r in gv.r:
		before[r] = Big.new(gv.r[r])
	
	# 2
	var ratio = gv.g[quickest].speed.t / 0.03
	for x in unlocked_loreds:
		gv.g[x].off_go(ratio)
	
	for x in gv.g:
		gv.g[x].manager.start_all()
	
	# 4
	var sim_time = max(gv.g[slowest].speed.t * 10.5, 3)
	print_debug("time required for offline sim: ", sim_time)
	var tt = Timer.new()
	add_child(tt)
	tt.start(sim_time)
	yield(tt, "timeout")
	tt.queue_free()
	# ---------------------------------
	
	print_debug("Earnings during simulation period will be multiplied by ", fval.f(time_offline / ratio))
	# resources after
	if true:
		
		for r in gv.r:
			
			var dif: Big
			var boost = time_offline / ratio
			var gained := true
			
			if gv.r[r].less(before[r]):
				gained = false
				dif = Big.new(before[r].s(gv.r[r])).m(boost)
			else:
				dif = Big.new(gv.r[r].s(before[r])).m(boost)
			
			if gained:
				if dif.equal(0):
					continue
				print_debug(r, ": +", dif.toString())
				gv.r[r].a(dif)
			else:
				print_debug(r, ": -", dif.toString())
				if gv.r[r].greater_equal(dif):
					gv.r[r].s(dif)
				else:
					gv.r[r] = Big.new(0)
	
	# 6
	for x in gv.g:
		gv.g[x].off_stop(ratio)
	pass

func w_total_per_sec(clock_dif : float) -> void:
	
	for x in gv.g:
		gv.g[x].manager.start_all()
	
	if clock_dif <= 0:
		return
	
	var rate := 1.0 # offline earnings modifier
	var gained := {}
	var consumed := {}
	var num_of_consumers := {}
	var gain_reduction := {}
	var consumed_reduction := {}
	
	for x in gv.g:
		gain_reduction[x] = Big.new()
		consumed_reduction[x] = Big.new()
		consumed[x] = Big.new(0)
		gained[x] = Big.new(0)
		num_of_consumers[x] = 0
	
	# set gained and consumed for each lored
	for x in gv.g:
		
		if not gv.g[x].active:
			continue
		
		var fuel_gained := true
		if "bur " in gv.g[x].type and not gv.g["coal"].active():
			fuel_gained = false
		if "ele " in gv.g[x].type and not gv.g["jo"].active():
			fuel_gained = false
		
		# coal storage / battery gain
		if fuel_gained:
			
			var fuel_gain = Big.new(gv.g[x].fc.t).m(clock_dif)
			
			gv.g[x].f.f = Big.new(Big.min(Big.new(gv.g[x].f.f).a(fuel_gain), gv.g[x].f.t))
			gv.g[x].sync()
		
		if gv.g[x].halt:
			continue
		
		var inactive_input := false
		for v in gv.g[x].b:
			if not gv.g[v].active() or gv.g[v].hold:
				inactive_input = true
				break
		if inactive_input: continue
		
		# fuel consumption
		if true:
			
			if "bur " in gv.g[x].type:
				consumed["coal"].a(Big.new(gv.g[x].fc.t).m(clock_dif))
			if "ele " in gv.g[x].type:
				consumed["jo"].a(Big.new(gv.g[x].fc.t).m(clock_dif))
		
		var net = gv.g[x].net(true)
		
		# gained
		var _gained = Big.new(net[0]).m(clock_dif).m(rate)
		gained[x] = Big.new(_gained)
		var per_sec = Big.new(gv.g[x].d.t).d(gv.g[x].speed.t).m(clock_dif).d(gv.g[x].jobs[0].base_duration)
		
		# consumed
		for v in gv.g[x].b:
			# by this point, every lored here will be active. see 2 sections up
			consumed[v] = Big.new(per_sec).m(gv.g[x].b[v].t).m(rate)
			num_of_consumers[v] += 1
	
	# unique gained reductions
	if true:
		
		# routine
		while true:
			
			if gained["malig"].less(gv.up["ROUTINE"].cost["malig"].t):
				break
			var excess = Big.new(gained["malig"]).s(gv.up["ROUTINE"].cost["malig"].t).m(rate).m(0.1)
			
			gained["malig"] = Big.new(gv.up["ROUTINE"].cost["malig"].t).a(excess)
			
			break
	
	# reduce gained if either fuel or input is insufficient. if gained is reduced, reduce consumed of input.
	if true:
		
		var coal_efficiency : Big = Big.new(gained["coal"])
		if consumed["coal"].equal(0):
			coal_efficiency = Big.new()
		else:
			coal_efficiency.d(consumed["coal"])
		if coal_efficiency.greater(1) or Big.new(gv.r["coal"]).s(consumed["coal"]).greater(gv.g["coal"].d.t):
			coal_efficiency = Big.new()
		
		var jo_efficiency : Big = Big.new(gained["jo"])
		if consumed["jo"].equal(0):
			jo_efficiency = Big.new()
		else:
			jo_efficiency.d(consumed["jo"])
		if jo_efficiency.greater(1) or Big.new(gv.r["jo"]).s(consumed["jo"]).greater(gv.g["jo"].d.t):
			jo_efficiency = Big.new()
		
		print("Time offline: ", gv.parse_time(clock_dif))
		print("coal/joule efficiency: ", coal_efficiency.toString(), "/", jo_efficiency.toString(), "\n")
		
		for x in gv.g:
			
			if not gv.g[x].active: continue
			
			if "bur " in gv.g[x].type: gain_reduction[x].m(coal_efficiency)
			if "ele " in gv.g[x].type: gain_reduction[x].m(jo_efficiency)
			
			if consumed[x].less(gained[x]): continue
			if Big.new(gv.r[x]).s(consumed[x]).greater(0): continue
			
			if "bur " in gv.g[x].type: consumed_reduction[x].m(coal_efficiency)
			if "ele " in gv.g[x].type: consumed_reduction[x].m(jo_efficiency)
			
			if num_of_consumers[x] == 0: num_of_consumers[x] = 1
			
			if consumed[x].equal(0): consumed[x] = Big.new()
			
			
			var uh = Big.new(gained[x].percent(consumed[x])).d(num_of_consumers[x])
			
			for v in gv.g[x].used_by:
				
				if not gv.g[v].active: continue
				gain_reduction[v].m(uh)
			
			consumed_reduction[x].m(uh)
		
		for x in gain_reduction:
			
			if gain_reduction[x].equal(1): continue
			
			gained[x].m(gain_reduction[x])
		
		for x in consumed_reduction:
			
			if consumed_reduction[x].equal(1): continue
			
			print_debug(x, " consumed x", consumed_reduction[x].toString(), " :: ", consumed[x].toString(), " -> ", Big.new(consumed[x]).m(consumed_reduction[x]).toString())
			consumed[x].m(consumed_reduction[x])
			gained[x] = Big.new(0)
	
	for x in gv.g:
		taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, x, gained[x])
	
	# subtract consumed from gained
	for x in gv.g:
		
		if not gv.g[x].active:
			continue
		
		
		if consumed[x].greater(gained[x]):
			var net = Big.new(consumed[x]).s(gained[x])
			print(x, ": -", net.toString(), " (", gained[x].toString(), " gained, ", consumed[x].toString(), " drained)")
			consumed[x].s(gained[x])
			if consumed[x].greater(gv.r[x]):
				gv.r[x] = Big.new(0)
			else:
				gv.r[x].s(consumed[x])
		else:
			var net = Big.new(gained[x]).s(consumed[x])
			print(x, ": +", net.toString(), " (", gained[x].toString(), " gained, ", consumed[x].toString(), " drained)")
			gained[x].s(consumed[x])
			gv.r[x].a(gained[x])
		
		if x != "coal": continue
		if gv.r[x].less(gv.g[x].d.t):
			gv.r[x] = Big.new(gv.g[x].d.t)
	
	for x in gv.g:
		if gv.r[x].less(0):#isNegative():
			gv.r[x] = Big.new(0)
	
	# upgrade-only stuff
	if true:
		
		if gv.up["I DRINK YOUR MILKSHAKE"].active():
			var num_of_burner_loreds := 0
			for x in gv.g:
				if not gv.g[x].active: continue
				if not "bur " in gv.g[x].type: continue
				num_of_burner_loreds += 1
			var gay = Big.new(num_of_burner_loreds).m(clock_dif).m(0.0001)
			gv.up["I DRINK YOUR MILKSHAKE"].effects[0].effect.a.a(gay)



var emote_events := {
	"whoa!": false,
	"i'm so glad Coal is back": false,
}
func emote_ville():
	
	while true:
		
		var t = Timer.new()
		add_child(t)
		t.start(2)
		yield(t, "timeout")
		t.queue_free()
		
		for x in emote_events:
			if emote_events[x] == true:
				for v in emote_events:
					if v == x:
						break
					emote_events[v] = true
				break
			
			match x:
				"i'm so glad Coal is back":
					if gv.g["stone"].f.f.greater(2) and taq.checkpoint < 2:
						gv.g["stone"].manager.speak("i'm so glad to have Coal back again")
						gv.g["coal"].manager.reply("thank you :)")
						emote_events[x] = true



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
		get_node(gnLB).r_limit_break()
		get_node(gnLB).r_set_colors()
		get_node(gnLB).show()
	
	else:
		
		get_node(gnLB).hide()



func r_window_size_changed() -> void:
	
	var win :Vector2= get_viewport_rect().size
	var node = 0
	
	
	#print(-INF)
	if win.y == -INF:
		#print("Vector2().y == ", win.y, "; what in tarnation?")
		return
	
	get_node("m").rect_size = Vector2(win.x / scale.x, win.y / scale.y)
	
	get_node(gnupcon).get_node("v/upgrades").scroll_vertical = 0



func reset(reset_type: int, manual := true) -> void:
	
	if reset_type != -1:
		# reset_type, unless -1, is the value of gv.Tab.S1, gv.Tab.S2, gv.Tab.S3, or gv.Tab.S4
		# this reduces reset_type to be 1, 2, 3, or 4.
		reset_type = 1 + reset_type - gv.Tab.S1
	
	reset_stats(reset_type)
	
	reset_upgrades(reset_type, manual)
	reset_resources(reset_type)
	reset_loreds(reset_type)
	activate_refundable_upgrades(reset_type)
	taq.reset(reset_type)
	reset_limit_break(reset_type)
	
	# ref
	if true:
		
		if reset_type == -1:
			for t in gv.Tab:
				unlock_tab(gv.Tab[t], false)
		
		if reset_type >= 2:
			unlock_tab(gv.Tab.EXTRA_NORMAL, false)
		
		for x in gv.g:
			get_node(gnLOREDs).cont[x].r_autobuy()
	
	if manual:
		b_tabkey(KEY_1)
	
	get_node(gnupcon).sync()
	
	if reset_type == -1:
		get_tree().reload_current_scene()
	

func reset_stats(reset_type: int):
	
	if reset_type > gv.highest_run:
		gv.highest_run = reset_type
		gv.most_resources_gained = Big.new(0)
		
	
	if reset_type == gv.highest_run:
		
		var reset_key = gv.highestResetKey()
		
		if gv.most_resources_gained.less(gv.r[reset_key]):
			gv.most_resources_gained = Big.new(gv.r[reset_key])
	
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
			gv.s2_upgrades_may_be_autobought = false
		for x in gv.list.upgrade[ str(r + gv.Tab.S1 - 1)]:
			reset_upgrade(x, reset_type, manual)
	
	for x in gv.up:
		if not x in get_node(gnupcon).cont.keys():
			continue
		gv.up[x].manager.icon.update()

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
		
		get_node(gnupcon).cont[x].r_update()
		get_node(gnupcon).cont[x].upgrade_effects(false)
		
		# ref
		get_node(gnupcon).cont[x].r_update()
		gv.list.upgrade["owned " + str(up.tab)].erase(up.key)

func reset_resources(reset_type: int):
	
	if reset_type == -1:
		
		for x in gv.g:
			
			gv.r[x] = Big.new(0)
		
		gv.r["stone"].a(5)
		
		return
	
	var lb = Big.new(gv.up["Limit Break"].effects[0].effect.t)
	
	# s1
	if reset_type >= 1:
		
		if (reset_type == 1 and not gv.up["CONDUCT"].active()) or reset_type != 1:
			
			for x in gv.list.lored[gv.Tab.S1]:
				
				if x == "malig" and reset_type == 1:
					continue
				
				gv.r[x] = Big.new(0)
		
		gv.r["stone"].a(Big.new(lb).m(5.0))
		gv.r["iron"].a(Big.new(lb).m(10.0))
		gv.r["cop"].a(Big.new(lb).m(10.0))
		gv.r["malig"] = Big.new(Big.max(gv.r["malig"], 10))
		if gv.up["FOOD TRUCKS"].active(true):
			gv.r["cop"].a(Big.new(lb).m(100.0))
			gv.r["iron"].a(Big.new(lb).m(100.0))
	
	# s2
	if reset_type >= 2:
		
		for x in gv.list.lored[gv.Tab.S2]:
			
			if x == "tum" and reset_type == 2:
				continue
			
			gv.r[x] = Big.new(0)
		
		gv.r["wood"] = Big.new(lb).m(200)
		gv.r["soil"] = Big.new(lb).m(50)
		gv.r["tree"] = Big.new(lb).m(5)
		gv.r["steel"] = Big.new(lb).m(200)
		gv.r["hard"] = Big.new(lb).m(200)
		gv.r["wire"] = Big.new(lb).m(200)
		gv.r["glass"] = Big.new(lb).m(500)
		gv.r["axe"] = Big.new(lb).m(50)

func reset_loreds(reset_type: int):
	
	if reset_type == -1:
		for x in gv.g:
			gv.g[x].reset()
			if not gv.g[x].unlocked:
				gv.g[x].manager.hide()
		return
	
	if gv.up["dust"].active():
		if reset_type == 1:
			return
	
	for x in gv.g:
		
		if int(gv.g[x].type[1]) > reset_type:
			continue
		
		get_node(gnLOREDs).cont[x].gn_frames.animation = "ww"
		get_node(gnLOREDs).cont[x].gn_frames.playing = true
		
		if x == "coal" and gv.up["aw <3"].active():
			
			gv.g[x].partial_reset()
			
			gv.g[x].manager.buy()
			
			gv.r["stone"].a(5)
			
			continue
		
		gv.g[x].partial_reset()
		
		get_node(gnLOREDs).cont[x].update_net(true)
	
	gv.list.lored["active"] = ["stone"]
	gv.list.lored["unlocked resources"] = ["stone"]

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
		gv.up[x].times_purchased += 1
		
		gv.up[x].apply()
		
		get_node(gnupcon).cont[x].upgrade_effects(true)
		
		# quest stuff
		taq.increaseProgress(gv.Objective.UPGRADE_PURCHASED, x)
		
		get_node(gnupcon).cont[x].r_update()

#func reset_tasks(reset_type: int):
#
#	if reset_type == -1:
#
#		taq.cur_quest = -1
#
#		for q in gv.quest:
#			q.reset()
#
#		for t in taq.task:
#			t.die(false)
#
#		taq.task.clear()
#		taq.cur_tasks = 0
#		taq.max_tasks = 0
#
#		gn_tasks.ready_task_count = 0
#		gn_tasks.hide()
#
#		return
#
#
#	#task
#	var list = []
#	for x in taq.task:
#		if int(gv.g[x.req[0].req_key].type[1]) > reset_type:
#			continue
#		if x.key == gv.Quest.RANDOM_SPIKE:
#			continue
#		list.append(x)
#
#	for x in list:
#		x.die(false)
#		var bla = gn_tasks.ready_task_count
#		gn_tasks.ready_task_count = max(0, bla - 1)
#
#	#taq.task.clear()
#
#	taq.hit_max_tasks()

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




func b_tabkey(key):
	
	$global_tip._call("no")
	
	match key:
		
		KEY_ESCAPE:
			
			if get_node(gnupcon).visible:
				
				if get_node(gnupcon).get_node("v").visible:
					get_node(gnupcon).go_back()
				
				get_node(gnupcon).hide()
				
				return
			
			# open the menu
			if not menu.visible:
				main_menu_container.show()
				menu.show()
				return
			
			# close the menu (should probably stay at the bottom. if must move above something, make this func return a bool. if return g.visible = true, then RETURN below the func)
			main_menu_container.hide()
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
	
	# stored page vertical
	gv.menu.tab_vertical[gv.page - gv.Tab.S1] = get_node(gnLOREDs + "/sc").scroll_vertical
	
	gv.page = target # gv.Tab.S2
	get_node("m/v/top/h/resources").switch_tabs(target)
	get_node(gnupcon).hide()
	
	for x in get_node(gnLOREDs + "/sc/v").get_children():
		if x.name == str(target - gv.Tab.S1 + 1):
			x.show()
		else:
			x.hide()
	
	var t = Timer.new()
	t.set_wait_time(0.005)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	get_node(gnLOREDs + "/sc").scroll_vertical = gv.menu.tab_vertical[gv.page - gv.Tab.S1]

func open_up_tab(tab: int):
	
	if not tab in gv.unlocked_tabs:
		return
	
	get_node(gnupcon).col_time(str(tab))
	
	menu.hide()
	get_node("global_tip")._call("no")

func b_move_map(x, y):

	$map.status = "no"
	$map.set_global_position(Vector2(x, y))


func unlock_tab(tab: int, add := true):
	
	# which may be gv.Tab.EXTRA_NORMAL, "3"
	
	if add:
		gv.unlocked_tabs.append(tab)
	else:
		gv.unlocked_tabs.erase(tab)
	
	match tab:
		gv.Tab.NORMAL:
			get_node("misc/tabs/v/upgrades").visible = add
			continue
		gv.Tab.S1, gv.Tab.S2, gv.Tab.S3, gv.Tab.S4:
			get_node("misc/tabs/v/" + str(tab - gv.Tab.S1 + 1)).show()
		_:
			get_node(gnupcon + "/top/" + str(tab)).visible = add





#func e_load(path := gv.save_path) -> bool:
#
#	var save_file = File.new()
#	var save := _save.new()
#
#	# file shit
#	if true:
#
#		if not save_file.file_exists(path):
#			return false
#
#		# load from base64
#		save_file.open(path, File.READ)
#
#		var save_lines := []
#
#		save_lines.append(save_file.get_line())
#		save_lines.append(save_file.get_line())
#
#		if len(save_lines[0]) < 20:
#			save.game_version = save_lines[0]
#			save.data =  Marshalls.base64_to_variant(save_lines[1])
#		else:
#			save.data =  Marshalls.base64_to_variant(save_lines[0])
#			save.game_version = save.data["game version"]
#
#		save_file.close()
#
#	if "1" == save.game_version[0]:
#		print("Save incompatible; from 1.2c or earlier.\nWhat the heck, have you really not played since then? Welcome back, jeez!")
#		return false
#
#	var pre_beta_4 := false
#	if "(" in save.game_version:
#		var beta_version = save.game_version.split("(")[1].split(")")[0]
#		if int(beta_version) <= 3:
#			pre_beta_4 = true
#
#	var keys = save.data.keys()
#
#	load_stats(save.data, keys, pre_beta_4)
#	if "resources" in keys:
#		gv.loadResources(str2var(save.data["resources"]))
#	load_upgrades(save.data, keys)
#	load_loreds(save.data, save.game_version, keys)
#
#	if "wish data" in keys:
#		taq._load(save.data["wish data"])
#
#	# backup saves
#	var backup_saves = [
#		"cavern",
#	]
#	for b in backup_saves:
#		if b in keys:
#			gv.backup_save[b] = save.data[b]
#
#	patched = version_older_than(save.game_version, ProjectSettings.get_setting("application/config/Version")) if gv.option["patch alert"] else false
#	# this, to the computer, could look like this:
#	# patched = false if false else false
#
#	if version_older_than(save.game_version, "2.2.4"):
#		gv.option["FPS"] = 2
#
#	# X.Y.Z
#	# 2.1.0
#	# 1.2c
#
#	# shit that needs to be done before offline earnings
#	if true:
#
#		# limit break
#		if true:
#
#			activate_lb_effects()
#
#	#offline_earnings(min(cur_clock - save.data["cur_clock"] - 30, 604800))
#
#	w_total_per_sec(gv.cur_clock - save.data["cur_clock"] - 30)
#
#	return true
#
#func load_stats(data: Dictionary, keys: Array, pre_beta_4: bool):
#
#	for e in emote_events:
#		if e in keys:
#			emote_events[e] = data[e]
#
#	for x in gv.run.size():
#		if "gv.run" + str(x) + "]" in keys:
#			gv.runx] = data["gv.run" + str(x) + "]"]
#		if "stats.last_run_dur[" + str(x) + "]" in keys:
#			gv.last_run_dur[x] = data["stats.last_run_dur[" + str(x) + "]"]
#		if "stats.last_reset_clock[" + str(x) + "]" in keys:
#			gv.last_reset_clock[x] = data["stats.last_reset_clock[" + str(x) + "]"]
#	gv.times_game_loaded = data["times game loaded"] + 1
#
#	for x in gv.option:
#
#		if not "option " + x in keys: continue
#		if gv.PLATFORM == "browser" and x == "performance": continue
#
#		gv.option[x] = data["option " + x]
#
#
#
#	gv.time_played = data["time_played"]
#	gv.task_completed = data["taskf_completed"]
#
#	if "highest_run" in keys:
#		gv.highest_run = data["highest_run"]
#
#	for x in gv.last_reset_clock.size():
#		if not ("save last reset clock " + str(x)) in keys: continue
#		gv.last_reset_clock[x] = data["save last reset clock " + str(x)]
#
#
#
#	if pre_beta_4:
#
#		if "most_resources_gained" in keys:
#			gv.most_resources_gained = Big.new(fval.f(data["most_resources_gained"]))
#
#		return
#
#	if "most_resources_gained" in keys:
#		gv.most_resources_gained = Big.new(data["most_resources_gained"])
#
#func load_upgrades(data: Dictionary, keys: Array):
#
#	if "Limit Break d" in keys:
#		gv.up["Limit Break"].effects[0].effect.a = Big.new(data["Limit Break d"])
#		gv.up["Limit Break"].sync_effects()
#		gv.lb_xp.t = Big.new(data["Limit Break xpt"])
#		gv.lb_xp.f = Big.new(data["Limit Break xpf"])
#		gv.emit_signal("limit_break_leveled_up", "color")
#
#	if "[I DRINK YOUR MILKSHAKE] e0" in keys:
#		gv.up["I DRINK YOUR MILKSHAKE"].effects[0].effect.a = Big.new(data["[I DRINK YOUR MILKSHAKE] e0"])
#
#	if "[IT'S GROWIN ON ME] e0" in keys:
#		gv.up["IT'S GROWIN ON ME"].effects[0].effect.a = Big.new(data["[IT'S GROWIN ON ME] e0"])
#		gv.up["IT'S GROWIN ON ME"].effects[1].effect.a = Big.new(data["[IT'S GROWIN ON ME] e1"])
#
#	if "[IT'S SPREADIN ON ME] e0" in keys:
#		gv.up["IT'S SPREADIN ON ME"].effects[0].effect.a = Big.new(data["[IT'S SPREADIN ON ME] e0"])
#		gv.up["IT'S SPREADIN ON ME"].effects[1].effect.a = Big.new(data["[IT'S SPREADIN ON ME] e1"])
#
#	for x in gv.up:
#
#		if not "[" + x + "] have" in keys: continue
#
#		gv.up[x].have = data["[" + x + "] have"]
#		if gv.up[x].have and gv.up[x].normal:
#			gv.list.upgrade["unowned " + str(gv.up[x].tab)].erase(x)
#		gv.up[x].refundable = data["[" + x + "] refundable"]
#		if "[" + x + "] times_purchased" in keys:
#			gv.up[x].times_purchased = data["[" + x + "] times_purchased"]
#		if "[" + x + "] unlocked" in keys:
#			gv.up[x].unlocked = data["[" + x + "] unlocked"]
#
#		if not gv.up[x].refundable:
#			if gv.up[x].active():
#				gv.up[x].apply()
#			continue
#
#		gv.up[x].refund()
#
#	for x in gv.up:
#		gv.up[x].sync()
#		if not gv.up[x].have:
#			continue
#		gv.list.upgrade["owned " + str(gv.up[x].tab)].append(gv.up[x].key)
#
#func load_loreds(data: Dictionary, game_version: String, keys: Array):
#
#	if version_older_than(game_version, "3.0.0"):
#
#		print("Save version: ", game_version, "; converting save.")
#
#		var LORED_data := {}
#
#		for x in gv.g:
#
#			if not "g" + x + " active" in keys:
#				continue
#
#			var pack := {}
#
#			if "g" + x + " times_purchased" in keys:
#				pack["times_purchased"] = data["g" + x + " times_purchased"]
#
#			pack["active"] = data["g" + x + " active"]
#
#			if "g" + x + " key" in keys:
#				pack["key_lored"] = data["g" + x + " key"]
#
#			if not pack["active"]:
#				continue
#
#			pack["level"] = data["g" + x + " level"]
#
#			if "g" + x + " halt" in keys:
#				pack["halt"] = data["g" + x + " halt"]
#			if "g" + x + " hold" in keys:
#				pack["hold"] = data["g" + x + " hold"]
#
#			pack["fuel"] = var2str(Big.new(data["g" + x + " fuel"]))
#
#			LORED_data[x] = var2str(pack)
#
#		data["LOREDs"] = var2str(LORED_data)
#
#	get_node(gnLOREDs).loadLOREDs(str2var(data["LOREDs"]))



func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		if get(x) is Big:
			data[x] = get(x).save()
		else:
			data[x] = var2str(get(x))
	
	
	data["loreds"] = get_node(gnLOREDs).save()
	
	
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
		set(x, loadedVars[x])
	#*
	
	get_node(gnLOREDs).load(str2var(data["loreds"]))
	
	for x in gv.up:
		if not x in data["upgrades"].keys():
			continue
		gv.up[x].load(str2var(data["upgrades"][x]))
		
		if gv.up[x].refundable:
			gv.up[x].refund()
		else:
			if gv.up[x].active():
				gv.up[x].apply()
		
		if not x in gv.list.upgrade["owned " + str(gv.up[x].tab)]:
			gv.list.upgrade["owned " + str(gv.up[x].tab)].append(x)
		
		gv.up[x].sync()
	
	
	taq.load(str2var(data["wish"]))
	
	
	activate_lb_effects()
	
	w_total_per_sec(gv.cur_clock - gv.save_slot_clock - 30)

func _on_Button_pressed() -> void:
	
	var name = gv.Lored.keys()[3].replace("_", " ").capitalize()
	
	pass


