extends MarginContainer


onready var rt = get_node("/root/Root")


var crit := false
var critcrit := false
var anim_complete := true
var proper_started := false
var some_started := false

var net: Array

var lored: LORED
var key = "copo"


var gn_frames = 0
var gn_progress_bar = 0
var gn_fuel = 0
var gn_status = 0
var gn_net = 0
var gn_amount = 0
var gn_d = 0
var gn_buy = 0
var gn_afford_check = 0
var gn_task_text = 0
var gn_item_name = 0
var gn_autobuywheel = 0
var gn_quest = 0

var gnhold = "h/interactables/lored/h/hold"
var gnhalt = "h/interactables/lored/h/halt"
var gnbuy = "h/interactables/lored/buy"


var frame_set := {}
var max_frames : int = 25
var halfway_frame : int = 13

var cont := {}
var output := {} # dict holding every output text prefab

var src := {
	output = preload("res://Prefabs/dtext.tscn"),
	buy = preload("res://Prefabs/lored_buy.tscn"),
}


func setup(_key: String) -> void:
	
	key = _key
	
	lored = gv.g[key]
	lored.manager = self
	
	hide()
	
	r_setup()

func allocate_gn():
	
	gn_progress_bar = get_node("h/h/lored/task")
	gn_frames = get_node("h/h/animation/AnimatedSprite")
	gn_fuel = get_node("h/h/lored/fuel")
	gn_status = get_node("bg/status")
	gn_net = get_node("h/h/lored/h/v/net")
	gn_amount = get_node("h/h/lored/h/v/amount")
	gn_d = get_node("h/h/lored/task/d")
	gn_buy = get_node("h/interactables/lored/buy")
	gn_afford_check = get_node("h/interactables/lored/buy/check")
	gn_task_text = get_node("h/h/lored/task/task text")
	gn_item_name = get_node("h/h/lored/h/v/item name")
	gn_autobuywheel = get_node("h/interactables/lored/buy/autobuywheel")
	gn_quest = get_node("h/interactables/lored/quest")

func start_some():
	
	if some_started:
		return
	
	some_started = true
	
	while not lored.smart or key in ["blood", "necro"]:
		match key:
			"blood":
				gn_item_name.text = "Blood"
			"necro":
				gn_item_name.text = "Bone"
				r_amount_necro()
				break
		
		r_amount()
		break
	
	if not lored.smart:
		r_d()
	r_buy_modulate()
	gn_frames.init(key)
	autobuy()
	r_autobuywheel()
	gn_status.init(key, Color(lored.color.r, lored.color.g, lored.color.b, 1))

func start_all():
	
	if proper_started:
		return
	
	start_some()
	
	if not (lored.unlocked and lored.active):
		return
	
	proper_started = true
	
	start()
	if not lored.smart:
		update_net() # not first
	gn_fuel.init(key)
	witch()
	softlock_check()

func r_setup():
	
	allocate_gn()
	
	# text
	get_node("h/h/lored/h/v/name").text = lored.name
	r_update_halt(lored.halt)
	gn_net.text = "0/s"
	gn_d.text = "+" + lored.d.t.toString()
	gn_amount.text = ""
	gn_item_name.text = ""
	
	# icons
	r_update_hold(lored.hold)
	get_node("h/h/lored/h/icon/Sprite").texture = gv.sprite[key]
	get_node("h/h/lored/fuel/fuel_icon/Sprite").texture = gv.sprite[lored.fuel_source]
	
	# color
	get_node("bg2").self_modulate = lored.color
	if key == "witch":
		gn_amount.self_modulate = gv.COLORS["witch"]
	
	gn_frames.self_modulate = get_faded_color()
	get_node("h/h/lored/fuel/fuel/f").self_modulate = gv.COLORS[lored.fuel_source]
	get_node("h/h/lored/fuel/fuel/f/flair").self_modulate = gv.COLORS[lored.fuel_source]
	
	get_node(gnhold + "/icon").self_modulate = lored.color
	get_node(gnhalt + "/text").self_modulate = lored.color
	gn_autobuywheel.self_modulate = lored.color
	get_node("h/h/animation").self_modulate = lored.color
	gn_amount.self_modulate = lored.color
	gn_afford_check.self_modulate = gv.COLORS[key]
	get_node("h/h/lored/task/d").self_modulate = lored.color
	get_node("h/h/lored/task/f").modulate = lored.color
	gn_quest.self_modulate = lored.color
	gn_quest.get_node("f").modulate = lored.color
	
	get_node(gnhalt + "/text").text = "=="
	
	if lored.smart:
		gn_progress_bar.rect_min_size.x = 180
		gn_progress_bar.rect_min_size.y = 40
		gn_task_text.text = ""
		gn_task_text.show()
		gn_item_name.show()
		gn_quest.show()
		get_node(gnhold).hide()
		gn_net.hide()
		gn_d.hide()
		match key:
			"witch":
				gn_amount.hide()
			"necro":
				gn_fuel.hide()
				cont["ubm"] = gv.SRC["unholy body manager"].instance()
				get_node("h/h/lored").add_child(cont["ubm"])
	else:
		gn_task_text.hide()
		gn_item_name.hide()
		gn_net.show()
		gn_progress_bar.rect_min_size.x = 108
		gn_progress_bar.rect_min_size.y = 20
	
	
	# frames
	if true:
		
		gn_autobuywheel.frame = int(rand_range(0, 16))
		
		frame_set[key] = false
		frame_set[key + " last"] = 0
		
		# flip horizontal
		if key in ["irono", "copo", "iron", "jo", "liq"]:
			gn_frames.flip_h = true
	
	if lored.used_by.size() == 0:
		get_node(gnhold).hide()

func get_faded_color() -> Color:
	
	match key:
		"steel":
			return Color(0.823529, 0.898039, 0.92549)
		"humus":
			return Color(0.6, 0.3, 0)
		"gale":
			return Color(0.701961, 0.792157, 0.929412)
		"ciga":
			return Color(0.97, 0.8, 0.6)
		"liq":
			return Color(0.7, 0.94, .985) # Color(0.27, 0.888, .97)
		"wood":
			return Color(0.77, 0.68, 0.6)
		"toba":
			return Color(0.85, 0.75, 0.63)
		"glass":
			return Color(0.81, 0.93, 1.0)
		"seed": return Color(.8,.8,.8)
		"tree":
			return Color(0.864746, 0.988281, 0.679443)
		"water":
			return Color(0.570313, 0.859009, 1)
		"coal":
			return Color(0.9, 0.3, 1)
		"stone":
			return Color(0.788235, 0.788235, 0.788235)
		"irono":
			return Color(0.5, 0.788732, 1)
		"copo":
			return Color(0.695313, 0.502379, 0.334076)
		"iron":
			return Color(0.496094, 0.940717, 1)
		"cop":
			return Color(1, 0.862001, 0.496094)
		"growth":
			return Color(0.890041, 1, 0.5)
		"conc":
			return Color(0.6, 0.6, 0.6)
		"jo":
			return Color(1, 0.9572, 0.503906)
		"malig":
			return Color(0.882353, 0.121569, 0.352941)
		"tar":
			return Color(0.560784, 0.439216, 1)
		"oil":
			return Color(0.647059, 0.298039, 0.658824)
		_:
			return Color((1 - lored.color.r) / 2 + lored.color.r, (1 - lored.color.g) / 2 + lored.color.g, (1 - lored.color.b) / 2 + lored.color.b)

func _ready() -> void:
	set_physics_process(false)

func _on_buy_pressed() -> void:
	if lored.smart:
		if gn_buy.mouse_default_cursor_shape == Control.CURSOR_POINTING_HAND:
			buy(true)
	else:
		buy(true)


func _on_halt_pressed():
	
	if "no" in gv.menu.f:
		if int(lored.type[1]) <= int(gv.menu.f.split("no s")[1]): return
	
	match lored.halt:
		true:
			lored.halt = false
		false:
			lored.halt = true
	
	update_net(true) # not it
	for b in lored.b:
		rt.get_node(rt.gnLOREDs).cont[b].update_net(true)
	
	if is_instance_valid(rt.get_node("global_tip").tip):
		rt.get_node("global_tip").tip.cont["halt"].r_update()
	
	r_update_halt(lored.halt)

func _on_hold_pressed():
	
	if "no" in gv.menu.f:
		if int(lored.type[1]) <= int(gv.menu.f.split("no s")[1]): return
	
	match lored.hold:
		true: lored.hold = false
		false: lored.hold = true
	
	update_net(true) #not it
	for u in lored.used_by:
		rt.get_node(rt.gnLOREDs).cont[u].update_net(true)
	
	if is_instance_valid(rt.get_node("global_tip").tip):
		rt.get_node("global_tip").tip.cont["hold"].r_update()
	
	r_update_hold(lored.hold)


func autobuy():
	
	while lored.unlocked and lored.active:
		
		# if resetting same stage as lored, it cannot act
		if "no" in gv.menu.f:
			if int(lored.type[1]) <= int(gv.menu.f.split(" s")[1]):
				break
		
		if not lored.autobuy:
			break
		
		if lored.autobuy():
			buy()
		
		var t = Timer.new()
		add_child(t)
		t.start(0.25)
		yield(t, "timeout")
		t.queue_free()
	
	# after 1 second, will restart the func
	
	if not lored.active and lored.autobuy:
		buy()
	
	var t = Timer.new()
	add_child(t)
	t.start(3)
	yield(t, "timeout")
	t.queue_free()
	
	autobuy()

func start():
	
	while lored.unlocked and lored.active:
		
		# if resetting same stage as lored, it cannot act
		if "no" in gv.menu.f:
			if int(lored.type[1]) <= int(gv.menu.f.split(" s")[1]):
				break
		
		# ready to begin a new task
		if lored.progress.b == 1:
			
			lored.inhand = Big.new(lored.d.t)
			lored.task = lored.logic()
			
			# if idle, restart loop
			if (lored.task == "idle") or ("na " in lored.task):
				if lored.smart:
					task_master()
					gn_task_text.text = lored.task_text
				break
			
			task_master()
			display_relevant_count()
			lored.progress.sync()
			
			if lored.smart:
				gn_task_text.text = lored.task_text
		
		tell_children_the_news()
		
		var t = Timer.new()
		add_child(t)
		t.start(lored.progress.t)
		yield(t, "timeout")
		t.queue_free()
		
		task_master(false)
	
	# after 1 second, will restart the func
	
	gn_frames.animation = "ww"
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	start()

func stop():
	gn_progress_bar.stop()

func task_master(beginning := true):
	
	if not lored.smart:
		
		if beginning:
			lored.progress.b = lored.speed.t
			
			if lored.sync_queued:
				lored.sync()
			else:
				lored.progress.sync()
			
			if "cook " in lored.task:
				
				for x in lored.b:
					var less = Big.new(lored.d.t).m(lored.b[x].t)
					gv.r[x].s(less)
			
			return
		
		lored.progress.b = 1
		w_output_master(lored)
		
		crit = false
		critcrit = false
	
	else:
		
		if "na " in lored.task:
			lored.task_text = "Insufficient " + lored.task.split("na ")[1] + "."
			return
		
		if lored.task == "idle":
			lored.task_text = "Idle."
			return
		
		if beginning:
			lored.inhand = Big.new(lored.d.t)
		
		match key:
			
			"witch":
				
				if "find " in lored.task:
					var item = int(lored.task.split("find ")[1])
					if beginning:
						match item:
							gv.Item.BITS:
								lored.progress.b = rand_range(5,10)
								lored.task_text = "Collecting bits for pieces, parts, or portions."
								lored.inhand.m(rand_range(0.5, 5))
							gv.Item.CRUMBS:
								lored.progress.b = rand_range(8,13)
								lored.task_text = "Collecting crumbs for slices, samples, or shards."
								lored.inhand.m(rand_range(1, 10))
					else:
						lored.inventory[item].a(lored.inhand)
				
				elif "craft " in lored.task:
					var item = int(lored.task.split("craft ")[1])
					if beginning:
						match item:
							gv.Item.SLICES:
								lored.inventory[gv.Item.CRUMBS].s(Big.new(lored.d.t).m(10))
								item = " spell shards"
								lored.progress.b = 10.0
							gv.Item.SAMPLES:
								lored.inventory[gv.Item.CRUMBS].s(Big.new(lored.d.t).m(12))
								item = " spell samples"
								lored.progress.b = 12.0
							gv.Item.SHARDS:
								lored.inventory[gv.Item.CRUMBS].s(Big.new(lored.d.t).m(14))
								item = " spell slices"
								lored.progress.b = 14.0
							gv.Item.PIECES:
								lored.inventory[gv.Item.BITS].s(Big.new(lored.d.t).m(8))
								item = " spell pieces"
								lored.progress.b = 8.0
							gv.Item.PARTS:
								lored.inventory[gv.Item.BITS].s(Big.new(lored.d.t).m(10))
								item = " spell parts"
								lored.progress.b = 10.0
							gv.Item.PORTIONS:
								lored.inventory[gv.Item.BITS].s(Big.new(lored.d.t).m(12))
								item = " spell portions"
								lored.progress.b = 12.0
						var verb = ["Crafting ", "Concocting ", "Assembling ", "Convening ", ]
						lored.task_text = verb[randi() % (verb.size() - 1)] + lored.inhand.toString() + item + "."
					
					else:
						lored.inventory[item].a(lored.inhand)
				
				elif "cast " in lored.task:
					
					var spell = gv.spells[int(lored.task.split("cast ")[1])]
					
					if beginning:
						lored.progress.b = 15
						
						for x in spell.cost:
							if x == gv.Item.MANA:
								continue
							if x in gv.g.keys():
								gv.r[x].s(spell.cost[x].t)
								continue
							lored.inventory[x].s(spell.cost[x].t)
						
						if spell.has_target:
							lored.task_text = "Casting " + spell.name + " on the " + gv.g[lored.spell_target].name + " LORED!"
						else:
							lored.task_text = "Casting " + spell.name + "!"
					
					else:
						lored.f.f.s(spell.cost[gv.Item.MANA].t)
						taq.progress(gv.TaskRequirement.SPELL_CAST, str(spell.key))
						for b in spell.applies_buffs:
							gv.active_buffs.append(Buff.new(b, gv.g[lored.spell_target]))
						
			
			"necro":
				match lored.task:
					"resurrect corpse":
						if beginning:
							gv.r["corpse"].s(lored.d.t)
							gv.emit_signal("item_produced", "corpse")
							lored.progress.b = 15.0
							if lored.d.t.equal(1):
								lored.task_text = "Resurrecting a corpse as an unholy body."
							else:
								lored.task_text = "Resurrecting corpses as unholy bodies."
						else:
							gv.emit_signal("new_unholy_body", lored.inhand)
					"resurrect flayed corpse":
						if beginning:
							gv.r["flayed corpse"].s(lored.d.t)
							gv.emit_signal("item_produced", "flayed corpse")
							lored.progress.b = 15.0
							if lored.d.t.equal(1):
								lored.task_text = "Resurrecting a flayed corpse as an unholy body."
							else:
								lored.task_text = "Resurrecting flayed corpses as unholy bodies."
						else:
							gv.emit_signal("new_unholy_body", lored.inhand)
					"craft knife":
						if beginning:
							lored.inhand = Big.new(1)
							gv.r["stone"].s(3)
							lored.progress.b = 8.0
							lored.task_text = "Crafting flaying knife."
						else:
							lored.inventory["knife"] += 1
					"flay corpse":
						if beginning:
							gv.r["corpse"].s(lored.inhand)
							gv.emit_signal("item_produced", "corpse")
							lored.inventory["knife"] -= rand_range(0, 0.1)
							lored.progress.b = 10.0
							if lored.d.t.equal(1):
								lored.task_text = "Flaying corpse for flesh."
							else:
								lored.task_text = "Flaying corpses for flesh."
						else:
							gv.r["flesh"].a(Big.new(lored.inhand).m(2))
							gv.r["flayed corpse"].a(lored.inhand)
							gv.emit_signal("item_produced", "flayed corpse")
							gv.emit_signal("item_produced", "flesh")
					"debone defiled dead":
						if beginning:
							lored.inhand.m(rand_range(10, 15))
							gv.r["defiled dead"].s(lored.d.t)
							gv.emit_signal("item_produced", "defiled dead")
							lored.progress.b = 10.0
							if lored.d.t.equal(1):
								lored.task_text = "Deboning a defiled dead."
							else:
								lored.task_text = "Deboning defiled dead."
						else:
							gv.r["bone"].a(lored.inhand)
							taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, "bone", lored.inhand)
							gv.emit_signal("item_produced", "bone")
					"debone exsanguinated beast":
						if beginning:
							lored.inhand.m(rand_range(3, 5))
							gv.r["exsanguinated beast"].s(lored.d.t)
							gv.emit_signal("item_produced", "exsanguinated beast")
							lored.progress.b = 10.0
							if lored.d.t.equal(1):
								lored.task_text = "Deboning an exsanguinated beast."
							else:
								lored.task_text = "Deboning exsanguinated beast bodies."
						else:
							gv.r["bone"].a(lored.inhand)
							gv.emit_signal("item_produced", "bone")
			
			"blood":
				match lored.task:
					"process tumors":
						if beginning:
							lored.inhand.m(rand_range(5, 15))
							gv.r["tum"].s(Big.new(lored.d.t).m(100))
							lored.progress.b = 10
							lored.task_text = "Processing Tumors for minimal blood amounts."
					"process growth":
						if beginning:
							lored.inhand.m(rand_range(2.5, 7.5))
							gv.r["growth"].s(Big.new(lored.d.t).m(1000))
							lored.progress.b = 8
							lored.task_text = "Processing Growth for miniscule blood amounts."
					"exsanguinate nearly dead":
						if beginning:
							lored.inhand.m(rand_range(50, 100))
							gv.r["nearly dead"].s(lored.d.t)
							lored.progress.b = 30
							if lored.d.t.equal(1):
								lored.task_text = "Exsanguinating a nearly-dead."
							else:
								lored.task_text = "Exsanguinating nearly-dead."
							gv.emit_signal("item_produced", "nearly dead")
						else:
							gv.r["corpse"].a(lored.d.t)
							gv.emit_signal("item_produced", "corpse")
					"exsanguinate beast body":
						if beginning:
							lored.inhand.m(rand_range(25, 50))
							gv.r["beast body"].s(lored.d.t)
							lored.progress.b = 15
							lored.task_text = "Exsanguinating beast body."
							gv.emit_signal("item_produced", "processed beast")
						else:
							gv.r["exsanguinated beast"].a(lored.d.t)
							gv.emit_signal("item_produced", "exsanguinated beast")
					"sacrifice own blood":
						if beginning:
							lored.inhand.m(50)
							lored.progress.b = 10
							lored.task_text = "Sacrificing own blood."
						else:
							lored.f.f.s(lored.inhand)
				
				if not beginning:
					gv.r["blood"].a(lored.inhand)
			
			"hunt":
				match lored.task:
					"debone beast":
						if beginning:
							lored.inhand.m(rand_range(3, 5))
							gv.r["processed beast"].s(lored.d.t)
							lored.progress.b = 10.0
							if lored.d.t.equal(1):
								lored.task_text = "Deboning a beast body."
							else:
								lored.task_text = "Deboning beast bodies."
							gv.emit_signal("item_produced", "processed beast")
						else:
							gv.r["bone"].a(lored.inhand)
							taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, "bone", lored.inhand)
							gv.emit_signal("item_produced", "bone")
					"process beast":
						if beginning:
							lored.inventory["knife"] -= rand_range(0, 0.1)
							gv.r["bagged beast"].s(lored.inhand)
							lored.progress.b = 12.0
							lored.task_text = "Processing bagged beast."
							gv.emit_signal("item_produced", "bagged beast")
						else:
							gv.r["processed beast"].a(lored.inhand)
							
							var bla = Big.new(lored.inhand).m(randi() % 5 + 1)
							gv.r["meat"].a(bla)
							taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, "meat", bla)
							
							bla = Big.new(lored.inhand).m(randi() % 11)
							gv.r["fur"].a(bla)
							taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, "fur", bla)
							
							gv.emit_signal("item_produced", "meat")
							gv.emit_signal("item_produced", "fur")
							gv.emit_signal("item_produced", "processed beast")
					
					"hunt beast":
						if beginning:
							lored.inventory["bow"] -= rand_range(0, 0.1)
							lored.inventory["arrow"] -= randi() % 6 + 3
							lored.progress.b = 25.0
							lored.task_text = "Hunting beast."
						else:
							gv.r["bagged beast"].a(lored.inhand)
							gv.emit_signal("item_produced", "bagged beast")
					"craft bow":
						if beginning:
							gv.r["wood"].s(15)
							lored.inventory["bowstring"] -= 1
							lored.progress.b = 8.0
							lored.task_text = "Crafting bow."
						else:
							lored.inventory["bow"] += 1.0
					"craft knife":
						if beginning:
							gv.r["stone"].s(3)
							lored.progress.b = 8.0
							lored.task_text = "Crafting hunting knife."
						else:
							lored.inventory["knife"] += 1
					"craft arrows":
						if beginning:
							gv.r["stone"].s(50)
							gv.r["wood"].s(50)
							lored.progress.b = 14.0
							lored.task_text = "Crafting 50 arrows."
						else:
							lored.inventory["arrow"] += 50
					"craft bowstring":
						if beginning:
							lored.inventory["hemp"] -= 1
							lored.progress.b = 5.0
							lored.task_text = "Crafting bowstring."
						else:
							lored.inventory["bowstring"] += 1
					"collect hemp":
						if beginning:
							lored.progress.b = 6.0
							lored.task_text = "Collecting hemp."
						else:
							lored.inventory["hemp"] += randi() % 3 + 1
					"drink water from flask":
						if beginning:
							lored.inventory["water flask"] -= 1
							lored.progress.b = 4.0
							gv.r["water"].s(10)
							lored.task_text = "Drinking water from flask."
						else:
							lored.f.f.a(10)
							if lored.f.f.greater(lored.f.t):
								lored.f.f = Big.new(lored.f.t)
					"drink water":
						if beginning:
							lored.progress.b = 12.0
							lored.task_text = "Yoking a sip from the poor Water LORED's pool."
						else:
							lored.f.f.a(20)
							if lored.f.f.greater(lored.f.t):
								lored.f.f = Big.new(lored.f.t)
					"scrounge water":
						if beginning:
							lored.progress.b = rand_range(22, 28)
							lored.task_text = "Scrounging the void for a mouthful of water."
						else:
							lored.f.f.a(15)
							if lored.f.f.greater(lored.f.t):
								lored.f.f = Big.new(lored.f.t)
					"fill up water flasks":
						if beginning:
							gv.r["water"].s(150)
							lored.progress.b = 12.0
							lored.task_text = "Refilling 3 water flasks."
						else:
							lored.f.f.a(15)
							if lored.f.f.greater(lored.f.t):
								lored.f.f = Big.new(lored.f.t)
							lored.inventory["water flask"] += 3
		
		if beginning:
			if key == "witch":
				match lored.task_text:
					"Gathering lemon.":
						lored.task_text = "Plucking lemons."
					"Crafting lemon juice.":
						lored.task_text = "Squeezing a lemon for juice!"
			lored.progress.b *= rand_range(0.85, 1.15)
			if key == "witch" and not "cast " in lored.task:
				lored.progress.b *= rand_range(0.85, 1.15)
			return
		
		lored.progress.b = 1.0

func tell_children_the_news():
	
	gn_progress_bar.start(lored.progress.t, OS.get_ticks_msec())
	
	if not lored.smart:
		gn_frames.start(lored.progress.t, OS.get_ticks_msec())

func display_relevant_count():
	
	match key:
		"witch":
			if "cast " in lored.task:
				gn_d.text = ""
			continue
		"necro":
			match lored.task:
				"flay corpse":
					gn_d.text = "+" + Big.new(lored.inhand).m(2).toString()
				_:
					gn_d.text = "+" + lored.inhand.toString()
		"blood", "witch":
			gn_d.text = "+" + lored.inhand.toString()
		"hunt":
			match lored.task:
				"hunt beast", "craft arrows":
					gn_item_name.text = "Arrows"
					gn_amount.text = fval.f(lored.inventory["arrow"])
					gn_amount.self_modulate = gv.COLORS["stone"]
				"craft bow":
					gn_item_name.text = "Bow Life"
					gn_amount.text = fval.f(lored.inventory["bow"] * 100) + "%"
					gn_amount.self_modulate = gv.COLORS["grey"]
				"craft knife", "process beast":
					gn_item_name.text = "Knife Life"
					gn_amount.text = fval.f(lored.inventory["knife"] * 100) + "%"
					gn_amount.self_modulate = gv.COLORS["stone"]
				"collect hemp", "craft bowstring":
					gn_item_name.text = "Hemp"
					gn_amount.text = fval.f(lored.inventory["hemp"])
					gn_amount.self_modulate = gv.COLORS["grey"]
				"fill up the water flasks", "drink water from flask":
					gn_item_name.text = "Water Flasks"
					gn_amount.text = fval.f(lored.inventory["water flask"])
					gn_amount.self_modulate = gv.COLORS["water"]
	
	if "idle" == lored.task or "na " in lored.task:
		gn_d.text = ""
	#gn_amount.text = ""

func update_net(one_shot := false):
	
	while lored.active or one_shot:
		
		# if resetting same stage as lored, it cannot act
		if "no" in gv.menu.f:
			if int(lored.type[1]) <= int(gv.menu.f.split(" s")[1]):
				break
		
		if gv.up["THE WITCH OF LOREDELITH"].active():
			lored.witch()
		
		if one_shot:
			return
		
		break
	
	net = lored.net()
	r_net()
	gv.emit_signal("net_updated", key, net)
	
	# restart after 1 sec
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	update_net()

func witch():
	
	while lored.active() and (not lored.halt) and (gv.up["THE WITCH OF LOREDELITH"].active() or gv.Buff.HEX in lored.buff_keys.keys()):
		# if resetting same stage as lored, it cannot act
		if "no" in gv.menu.f:
			if int(lored.type[1]) <= int(gv.menu.f.split(" s")[1]):
				break
		
		var witch_mod_fps: Big = Big.new(lored.witch).m(gv.fps)
		
		gv.r[key].a(witch_mod_fps)
		gv.increase_lb_xp(witch_mod_fps)
		taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, lored.key, witch_mod_fps)
		
		var t = Timer.new()
		add_child(t)
		t.start(gv.fps)
		yield(t, "timeout")
		t.queue_free()
	
	# after 1 second, will restart the func
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	witch()

func flying_texts():
	
	if not rt.get_node(rt.gnLOREDs + "/sc/v/s" + lored.type[1]).visible:
		return
	
	if not gv.menu.option["flying_numbers"]:
		return
	
	if gv.menu.option["crits_only"]:
		if not crit:
			return
	
	if get_node("h/h/lored/h/v/amount").rect_global_position.y < rt.get_node("m/v/top").rect_global_position.y + rt.get_node("m/v/top").rect_size.y:
		return
	elif get_node("h/h/lored/h/v/amount").rect_global_position.y > rt.get_node("m/v/bot").rect_global_position.y:
		return
	
	output["hi"] = src.output.instance()
	output["hi"].init(true, 0, "+ " + lored.inhand.toString(), gv.sprite[key], lored.color)
	if crit:
		if critcrit:
			output["hi"].text += " (Power crit!)"
		else:
			output["hi"].text += " (Crit!)"
	
	var pos = Vector2(30,15)
	output["hi"].rect_position = pos
	get_node("texts").add_child(output["hi"])

func w_output_master(f) -> void:
	
	f.inhand.m(w_crit_roll(true))
	w_bonus_output(f.key, f.inhand)
	
	gv.r[f.key].a(f.inhand)
	gv.increase_lb_xp(f.inhand)
	taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, f.key, f.inhand)
	gv.stats.r_gained[f.key].a(f.inhand)
	flying_texts()

func w_bonus_output(key : String, inhand : Big) -> void:
	
	match key:
		"coal":
			if gv.up["wait that's not fair"].active():
				var bla = Big.new(inhand).m(10)
				gv.r["stone"].a(bla)
				gv.increase_lb_xp(bla)
				taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, "stone", bla)
		"irono":
			if gv.up["I RUN"].active():
				gv.r["iron"].a(inhand)
				gv.increase_lb_xp(inhand)
				taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, "iron", inhand)
		"copo":
			if gv.up["THE THIRD"].active():
				gv.r["cop"].a(inhand)
				gv.increase_lb_xp(inhand)
				taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, "cop", inhand)
		"growth":
			if gv.up["IT'S GROWIN ON ME"].active():
				var buff = 0.1 * gv.g["growth"].level
				if not gv.up["IT'S SPREADIN ON ME"].active():
					var roll = randi()%2
					match roll:
						0:
							gv.up["IT'S GROWIN ON ME"].effects[0].effect.a.a(buff)
						1:
							gv.up["IT'S GROWIN ON ME"].effects[1].effect.a.a(buff)
				else:
					gv.up["IT'S GROWIN ON ME"].effects[0].effect.a.a(buff)
					gv.up["IT'S GROWIN ON ME"].effects[1].effect.a.a(buff)
					gv.up["IT'S SPREADIN ON ME"].effects[0].effect.a.a(buff)
					gv.up["IT'S SPREADIN ON ME"].effects[1].effect.a.a(buff)

func w_crit_roll(by_thine_own_hand : bool) -> Big:
	
	var f := Big.new(1)
	
	var roll := rand_range(0,100)
	if lored.crit.t.greater_equal(roll):
		f.m(rand_range(7.5, 12.5))
		if by_thine_own_hand: crit = true
	
	if lored.type[1] == "1":
		
		if not gv.up["the athore coments al totol lies!"].active():
			return f
		
		roll = rand_range(0,100)
		if roll <= 1:
			f.m(rand_range(7.5, 12.5))
			if by_thine_own_hand: critcrit = true
	
	return f


func softlock_check():
	
	while true:
		
		# softlock checks done out of "ye" can be done above here
		
		if not "ye" in gv.menu.f:
			
			var t = Timer.new()
			add_child(t)
			t.start(3)
			yield(t, "timeout")
			t.queue_free()
			
			continue
		
		softlock_wood_cycle()
		softlock_no_seeds()
		softlock_no_steel_for_liq()
		softlock_not_enough_wire()
		
		var t = Timer.new()
		add_child(t)
		t.start(3)
		yield(t, "timeout")
		t.queue_free()

func softlock_not_enough_wire():
	
	if key != "wire":
		return
	
	if gv.g["draw"].active:
		return
	
	if gv.r["wire"].less(20):
		print("You couldn't afford to purchase the Draw Plate LORED, so you've been given 20 Wire.")
		gv.r["wire"].a(20)

func softlock_wood_cycle():
	
	if key != "axe":
		return
	
	var axe_wood_hard = ["axe", "wood", "hard"]
	
	for x in axe_wood_hard:
		
		if not gv.g[x].progress.f == 0:
			return
		if gv.g[x].halt:
			return
		
		if gv.r["axe"].greater(Big.new(gv.g["wood"].d.t).m(gv.g["wood"].b["axe"].t)):
			return
		if gv.r["wood"].greater(Big.new(gv.g["hard"].d.t).m(gv.g["hard"].b["wood"].t)):
			return
		if gv.r["hard"].greater(Big.new(gv.g["axe"].d.t).m(gv.g["axe"].b["hard"].t)):
			return
	
	print("Axes, Wood, and Hardwood dropped low enough that none of them could take from each other, so you've been given free resources.")
	
	for x in axe_wood_hard:
		gv.r[x].a(gv.g[x].d.t)

func softlock_no_seeds():
	
	if key != "tree":
		return
	
	if gv.g["seed"].active:
		return
	if gv.r["tree"].greater_equal(2):
		return
	if gv.r["seed"].greater_equal(Big.new(gv.g["tree"].d.t).m(gv.g["tree"].b["seed"].t)):
		return
	
	print("You didn't have enough Seeds to produce any Trees to be able to afford the Seed LORED, so you've been given free Trees.")
	
	gv.r["tree"].a(2)

func softlock_no_steel_for_liq():
	
	if key != "steel":
		return
	
	if gv.g["liq"].active:
		return
	
	if gv.r["liq"].greater(Big.new(lored.d.t).m(lored.b["liq"].t)):
		return
	
	if gv.r[key].greater(gv.g["liq"].cost["steel"].t):
		return
	
	print("You didn't have enough Steel to purchase a Liquid Iron LORED, so you've been given free Steel.")
	
	gv.r[key] = Big.new(gv.g["liq"].cost["steel"].t)


func r_amount():
	
	while true:
		
		gn_amount.text = gv.r[key].toString()
		gv.emit_signal("amount_updated", key)
		
		var t = Timer.new()
		add_child(t)
		t.start(gv.fps)
		yield(t, "timeout")
		t.queue_free()

func r_amount_necro():
	
	while true:
		
		gn_amount.text = gv.r["bone"].toString()
		
		var t = Timer.new()
		add_child(t)
		t.start(gv.fps)
		yield(t, "timeout")
		t.queue_free()


func r_net():
	
	var net_text = ""
	
	gn_status._update(net)
	
	var _net = [Big.new(net[0]), Big.new(net[1])]
	
	if _net[0].greater_equal(_net[1]):
		_net[0].s(_net[1])
		net_text = _net[0].toString()
	else:
		_net[1].s(_net[0])
		net_text = "-" + _net[1].toString()
	
	gn_net.text = net_text + "/s"

func r_d():
	
	while true:
		
		gn_d.text = "+" + lored.d.print()
		
		var t = Timer.new()
		add_child(t)
		t.start(0.5)
		yield(t, "timeout")
		t.queue_free()

func r_buy_modulate():
	
	var BAD := Color(1.5, 0, 0, 1)
	var GOOD := Color(1, 1, 1, 1.25)
	
	while true:
		
		var bla = lored.cost_check()
		
		gn_buy.self_modulate = GOOD if bla else BAD
		if gv.menu.option["afford check"]:
			gn_afford_check.pressed = true if bla else false
		
		var t = Timer.new()
		add_child(t)
		t.start(0.1)
		yield(t, "timeout")
		t.queue_free()

func r_autobuy() -> void:
	
	if lored.autobuy:
		gn_autobuywheel.show()
		return
	
	gn_autobuywheel.hide()

func r_autobuywheel():
	
	while true:
		if not gn_autobuywheel.visible:
			break
		gn_autobuywheel.speed_scale = lored.speed.b / lored.speed.t
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()
	
	var t = Timer.new()
	add_child(t)
	t.start(3)
	yield(t, "timeout")
	t.queue_free()
	
	r_autobuywheel()

func r_update_halt(halt:bool) -> void:
	match halt:
		true: get_node(gnhalt + "/text").text = "=/="
		false: get_node(gnhalt + "/text").text = "=="

func r_update_hold(hold:bool) -> void:
	match hold:
		true: get_node(gnhold + "/icon").texture = gv.sprite["hold_true"]
		false: get_node(gnhold + "/icon").texture = gv.sprite["hold_false"]

func r_mouse_cursor():
	
	if gn_quest.get_node("f").rect_size.x >= gn_quest.rect_size.x * 0.995:
		gn_buy.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		return
	
	gn_buy.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN

func r_quest() -> void:
	
	while true:
		
		var points: Big = Big.new(0)
		
		for x in lored.upgrade_quest.step:
			if typeof(lored.upgrade_quest.step[x].f) == TYPE_NIL:
				lored.upgrade_quest.step[x].f = Big.new(0)
			points.a(lored.upgrade_quest.step[x].f)
		points = Big.new(Big.min(points, lored.upgrade_quest.total_points))
		
		gn_quest.get_node("f").rect_size.x = points.percent(lored.upgrade_quest.total_points) * gn_quest.rect_size.x
		
		var t = Timer.new()
		add_child(t)
		t.start(0.25)
		yield(t, "timeout")
		t.queue_free()

func random_shit():
	
	# s2n upgrade menu button
	if not gv.stats.tabs_unlocked["s2n"]:
		if b_ubu_s2n_check():
			rt.unlock_tab("s2n")


func manage_buff(buff: Buff) -> void:
	
	if buff.key in lored.buff_keys.keys():
		lored.buff_keys[buff.key] += 1
	else:
		lored.buff_keys[buff.key] = 1
	
	lored.buffs.append(buff)
	
	while buff.duration_elapsed < buff.duration:
		
		var t = Timer.new()
		add_child(t)
		t.start(gv.fps)
		yield(t, "timeout")
		t.queue_free()
		
		buff.tick()
	
	buff.remove()



func buy(manual := false):
	
	# catches
	if true:
		
		if not lored.cost_check():
			if manual and is_instance_valid(rt.get_node("global_tip").tip):
				rt.get_node("global_tip").tip.price_flash = true
			return
		
		if lored.type[1] in gv.menu.f:
			return
	
	lored.bought()
	update_net(true)
	
	for b in lored.b:
		if gv.g[b].active:
			rt.get_node(rt.gnLOREDs).cont[b].update_net(true)
	
	
	if manual:
		rt.get_node("global_tip")._call("no")
		if lored.smart:
			rt.get_node("global_tip")._call("buy smart lored " + key)
		else:
			rt.get_node("global_tip")._call("buy lored " + key)
	
	cont["lored up"] = src.buy.instance()
	cont["lored up"].init("lv" + fval.f(lored.level), lored.color)
	get_node("lv/n").add_child(cont["lored up"])
	cont["lored up"].rect_rotation = -10
	
	# not owned
	if lored.level == 1:
		
		start_all()
		
		if lored.smart and not key == "hunt":
			gn_d.show()
		
		# task
		if key in rt.task_awaiting and not rt.on_task:
			rt.get_node("misc/task")._clear_board()
			rt.get_node("misc/task")._call_board()

func b_ubu_s2n_check() -> bool:
	
	if not rt.quests["The Heart of Things"].complete:
		return false
	
	for x in ["soil", "seed", "water", "tree", "sand", "draw", "axe", "liq", "steel", "wire", "glass", "hard", "wood", "humus"]:
		if not gv.g[x].active:
			return false
	
	return true


func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")

func _on_animation_mouse_entered() -> void:
	rt.get_node("global_tip")._call("mainstuff lored " + key)

func _on_buy_mouse_entered() -> void:
	if lored.smart:
		r_mouse_cursor()
		rt.get_node("global_tip")._call("buy smart lored " + key)
	else:
		rt.get_node("global_tip")._call("buy lored " + key)

func _on_fuel_mouse_entered() -> void:
	if not gv.menu.option["tooltip_fuel"]: return
	rt.get_node("global_tip")._call("fuel lored " + key)

func _on_halt_mouse_entered():
	if not lored.active: return
	if not gv.menu.option["tooltip_halt"]: return
	rt.get_node("global_tip")._call("tip halt lored " + key)

func _on_hold_mouse_entered():
	if not lored.active: return
	if not gv.menu.option["tooltip_hold"]: return
	rt.get_node("global_tip")._call("tip hold lored " + key)
