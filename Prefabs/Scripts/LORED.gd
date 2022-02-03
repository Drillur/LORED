extends MarginContainer


onready var rt = get_node("/root/Root")


var crit := false
var critcrit := false
var anim_complete := true
var proper_started := false
var some_started := false

var net: Array

var lored: LORED
var key := "copo"

var emotes := {
	"emote cd": false,
	"net - time when last positive": 0,
}
var emote: MarginContainer
var last_emote_index := -1

var gn_frames = 0
var gn_progress_bar = 0
var gn_status = 0
var gn_net = 0
var gn_amount = 0
var gn_d = 0
var gn_buy = 0
var gn_task_text = 0
var gn_item_name = 0
var gn_autobuywheel = 0
onready var autobuywheel = get_node("v/m/v/interactables/lored/h/buy/h/autobuy/as")
onready var fuel = get_node("v/m/v/fuel")
onready var fuel_bar = get_node("v/m/v/fuel/bar")
onready var fuel_bar_f = get_node("v/m/v/fuel/bar/f")
onready var afford = get_node("v/m/v/interactables/lored/h/buy/afford")
onready var color_blind = get_node("v/m/v/interactables/lored/h/buy/h/color blind")

var gnhold = "v/m/v/interactables/lored/h/hold"
var gnhalt = "v/m/v/interactables/lored/h/halt"


var frame_set := {}
var max_frames : int = 25
var halfway_frame : int = 13

var cont := {}
var emoting := false
var output := {} # dict holding every output text prefab

var src := {
	output = preload("res://Prefabs/dtext.tscn"),
	buy = preload("res://Prefabs/lored_buy.tscn"),
}

var consolidated_big := Big.new(0)
var consolidation_timer_begun := false


func setup(_key: String) -> void:
	
	key = _key
	
	lored = gv.g[key]
	lored.manager = self
	
	hide()
	
	r_setup()

func allocate_gn():
	
	gn_progress_bar = get_node("v/m/v/h/lored/task")
	gn_frames = get_node("v/m/v/h/animation/AnimatedSprite")
	gn_status = get_node("v/m/bg/status")
	gn_net = get_node("v/m/v/h/lored/h/v/net")
	gn_amount = get_node("v/m/v/h/lored/h/v/amount")
	gn_d = get_node("v/m/v/h/lored/task/d")
	gn_buy = get_node("v/m/v/interactables/lored/h/buy/button")
	gn_task_text = get_node("v/m/v/h/lored/task/task text")
	gn_item_name = get_node("v/m/v/h/lored/h/v/item name")
	gn_autobuywheel = get_node("v/m/v/interactables/lored/h/buy/h/autobuy")

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
				break
		
		r_amount()
		break
	
	if not lored.smart:
		r_d()
	
	autobuy()
	emote()
	r_buy_modulate()
	gn_frames.init(key)
	fuel.init(key)
	r_buy_button_only()
	
	r_autobuywheel()
	gn_status.init(key, Color(lored.color.r, lored.color.g, lored.color.b, 1))
	
	r_autobuy()

func start_all():
	
	if proper_started:
		return
	
	if not (lored.unlocked and lored.active):
		return
	
	proper_started = true
	
	r_update_halt()
	r_update_hold()
	r_buy_button_only()
	
	start()
	if not lored.smart:
		update_net() # not first
	witch()
	softlock_check()

func r_setup():
	
	yield(self, "ready")
	
	allocate_gn()
	
	# text
	var lored_name = get_node("v/m/v/h/lored/h/v/name")
	lored_name.text = lored.name
	get_node("v/m/v/interactables/lored/h/buy/h/name").text = lored_name.text
	r_update_halt()
	gn_net.text = "0/s"
	gn_d.text = "+" + lored.d.t.toString()
	gn_amount.text = ""
	gn_item_name.text = ""
	
	# icons
	r_update_hold()
	get_node("v/m/v/h/lored/h/icon/Sprite").texture = gv.sprite[key]
	get_node("v/m/v/fuel/fuel_icon/Sprite").texture = gv.sprite[lored.fuel_source]
	
	# color
	color_blind.self_modulate = lored.color
	get_node("v/m/v/interactables/bg").self_modulate = lored.color
	get_node("v/m/v/interactables/lored/h/buy/h/name").self_modulate = lored.color
	gn_buy.self_modulate = lored.color
	afford.self_modulate = lored.color
	get_node(gnhalt).self_modulate = lored.color
	get_node(gnhold).modulate = lored.color
	get_node("v/m/bg2").self_modulate = lored.color
	if key == "witch":
		gn_amount.self_modulate = gv.COLORS["witch"]
	
	gn_frames.self_modulate = get_faded_color()
	
	fuel_bar_f.modulate = gv.COLORS[lored.fuel_source]
	
	#get_node(gnhold + "/icon").self_modulate = lored.color
	get_node(gnhalt).add_color_override("font_color", lored.color)
	gn_autobuywheel.modulate = lored.color
	get_node("v/m/v/h/animation").self_modulate = lored.color
	gn_amount.self_modulate = lored.color
	get_node("v/m/v/h/lored/task/d").self_modulate = lored.color
	get_node("v/m/v/h/lored/task/f").modulate = lored.color
	
	get_node(gnhalt).text = "=="
	
	if lored.smart:
		gn_progress_bar.rect_min_size.x = 180
		gn_progress_bar.rect_min_size.y = 40
		gn_task_text.text = ""
		gn_task_text.show()
		gn_item_name.show()
		get_node(gnhold).hide()
		gn_net.hide()
		gn_d.hide()
	else:
		gn_task_text.hide()
		gn_item_name.hide()
		gn_net.show()
		gn_progress_bar.rect_min_size.x = 108
		gn_progress_bar.rect_min_size.y = 20
	
	
	# frames
	if true:
		
		autobuywheel.frame = int(rand_range(0, 16))
		
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

func halt(enable := not lored.halt):
	
	lored.halt = enable
	
	update_net(true)
	for b in lored.b:
		rt.get_node(rt.gnLOREDs).cont[b].update_net(true)
	
	r_update_halt()

func hold(enable := not lored.hold):
	
	lored.hold = enable
	
	update_net(true)
	for u in lored.used_by:
		rt.get_node(rt.gnLOREDs).cont[u].update_net(true)
	
	r_update_hold()

func _on_halt_pressed():
	
	halt()
	
	if is_instance_valid(rt.get_node("global_tip").tip):
		rt.get_node("global_tip").tip.cont["halt"].r_update()

func _on_hold_pressed():
	
	hold()
	
	if is_instance_valid(rt.get_node("global_tip").tip):
		rt.get_node("global_tip").tip.cont["hold"].r_update()


func autobuy():
	
	while lored.unlocked and lored.active and proper_started:
		
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
	#zbefore start is called, Difficulty should be set.
	while lored.unlocked and lored.active and not lored.halt:
		
		if lored.sync_queued:
			lored.sync()
		
		if not lored.working:
			for j in lored.jobs:
				if j.try():
					break
		
		
		if not lored.working:
			break
		
		tell_children_the_news()
		
		var t = Timer.new()
		add_child(t)
		t.start(lored.current_job.duration)
		yield(t, "timeout")
		t.queue_free()
		
		lored.current_job.complete()
	
	# after 1 second, will restart the func
	
	if lored.working:
		print_debug(key, " is not working")
	
	gn_frames.animation = "ww"
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	start()

func stop():
	kill_emote()
	gn_progress_bar.stop()
	fuel_bar_f.rect_size.x = fuel_bar.rect_size.x

func task_master(beginning := true):
	
	if not lored.smart:
		
		if beginning:
			lored.progress.b = lored.speed.t
			
			if lored.sync_queued:
				lored.sync()
			
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
				
				pass
		
		if beginning:
			lored.progress.b *= rand_range(0.85, 1.15)
			return
		
		lored.progress.b = 1.0

func tell_children_the_news():
	
	gn_progress_bar.start(lored.current_job.duration, OS.get_ticks_msec())
	
	if not lored.smart:
		gn_frames.start(lored.current_job.duration, OS.get_ticks_msec())

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
	
	if "idle" == lored.task or "na " in lored.task:
		gn_d.text = ""
	#gn_amount.text = ""

func update_net(one_shot := false):
	
	while lored.active or one_shot:
		
		if gv.up["THE WITCH OF LOREDELITH"].active():
			lored.witch()
		
		if one_shot:
			net = lored.net()
			r_net()
			gv.emit_signal("net_updated", key, net)
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
		
		var witch_mod_fps: Big = Big.new(lored.witch).m(gv.fps)
		
		gv.r[key].a(witch_mod_fps)
		gv.increase_lb_xp(witch_mod_fps)
		taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, lored.key, witch_mod_fps)
		
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
	
	if not rt.get_node(rt.gnLOREDs + "/sc/v/" + lored.type[1]).visible:
		return
	
	if not gv.menu.option["flying_numbers"]:
		return
	
	if gv.menu.option["crits_only"]:
		if not crit:
			return
	
	if get_node("v/m/v/h/lored/h/v/amount").rect_global_position.y < rt.get_node("m/v/top").rect_global_position.y + rt.get_node("m/v/top").rect_size.y:
		return
	elif get_node("v/m/v/h/lored/h/v/amount").rect_global_position.y > rt.get_node("m/v/bot").rect_global_position.y:
		return

	if not gv.menu.option["consolidate_numbers"]:
		release_flying_text(lored.inhand)
		return

	if consolidation_timer_begun:
		consolidated_big.a(lored.inhand)
		return

	release_flying_text(Big.max(consolidated_big, lored.inhand))
	consolidated_big = Big.new(0)

	consolidation_timer_begun = true

	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()

	consolidation_timer_begun = false

func release_flying_text(val: Big) -> void:

	output["hi"] = src.output.instance()
	var text = val.toString()
	if crit:
		if critcrit:
			text += " (Power crit!)"
			critcrit = false
		else:
			text += " (Crit!)"
		crit = false
	output["hi"].init({"text": "+ " + text, "icon": gv.sprite[key], "color": lored.color, "life": 10})
	
	output["hi"].rect_position = Vector2(rect_size.x / 2,0) 
	get_node("texts").add_child(output["hi"])

func w_output_master(f) -> void:
	
	w_bonus_output(f.key, f.inhand)
	
	gv.r[f.key].a(f.inhand)
	gv.increase_lb_xp(f.inhand)
	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, f.key, f.inhand)
	flying_texts()

func w_bonus_output(_key : String, inhand : Big) -> void:
	
	match _key:
		"coal":
			if gv.up["wait that's not fair"].active():
				var bla = Big.new(inhand).m(10)
				gv.r["stone"].a(bla)
				gv.increase_lb_xp(bla)
				taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, "stone", bla)
		"irono":
			if gv.up["I RUN"].active():
				gv.r["iron"].a(inhand)
				gv.increase_lb_xp(inhand)
				taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, "iron", inhand)
		"copo":
			if gv.up["THE THIRD"].active():
				gv.r["cop"].a(inhand)
				gv.increase_lb_xp(inhand)
				taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, "cop", inhand)
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


func softlock_check():
	
	while true:
		
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
		print_debug("You couldn't afford to purchase the Draw Plate LORED, so you've been given 20 Wire.")
		gv.r["wire"].a(20)

func softlock_wood_cycle():
	
	if key != "axe":
		return
	
	var axe_wood_hard = ["axe", "wood", "hard"]
	
	for x in axe_wood_hard:
		
		if gv.g[x].halt:
			return
		
		if gv.r["axe"].greater(Big.new(gv.g["wood"].d.t).m(gv.g["wood"].b["axe"].t)):
			return
		if gv.r["wood"].greater(Big.new(gv.g["hard"].d.t).m(gv.g["hard"].b["wood"].t)):
			return
		if gv.r["hard"].greater(Big.new(gv.g["axe"].d.t).m(gv.g["axe"].b["hard"].t)):
			return
	
	print_debug("Axes, Wood, and Hardwood dropped low enough that none of them could take from each other, so you've been given free resources.")
	
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
	
	print_debug("You didn't have enough Seeds to produce any Trees to be able to afford the Seed LORED, so you've been given free Trees.")
	
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
	
	print_debug("You didn't have enough Steel to purchase a Liquid Iron LORED, so you've been given free Steel.")
	
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



func r_net():
	
	var net_text = ""
	
	gn_status._update(net)
	
	var _net = [Big.new(net[0]), Big.new(net[1])]
	
	if _net[0].greater_equal(_net[1]):
		emotes["net - time when last positive"] = OS.get_ticks_msec()
		_net[0].s(_net[1])
		net_text = _net[0].toString()
	else:
		emotes["net - time when last positive"] = OS.get_ticks_msec()
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
	
	while true:
		
		set_buy_modulate()
		
		var t = Timer.new()
		add_child(t)
		t.start(0.25)
		yield(t, "timeout")
		t.queue_free()

func set_buy_modulate():
	
	match lored.cost_check():
		true:
			gn_buy.modulate = Color(1,1,1)
			afford.modulate = Color(1,1,1)
			color_blind.pressed = true
		false:
			afford.modulate = Color(0.2,0.2,0.2)
			gn_buy.modulate = Color(0.5,0.5,0.5)
			color_blind.pressed = false

func r_autobuy() -> void:
	
	if lored.autobuy:
		gn_autobuywheel.show()
		return
	
	gn_autobuywheel.hide()

func r_autobuywheel():
	
	while true:
		if not gn_autobuywheel.visible:
			break
		autobuywheel.speed_scale = lored.speed.b / lored.speed.t
		
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

func r_update_halt() -> void:
	match lored.halt:
		true: get_node(gnhalt).text = "=/="
		false: get_node(gnhalt).text = "=="

func r_update_hold() -> void:
	match lored.hold:
		true: get_node(gnhold + "/icon").texture = gv.sprite["hold_true"]
		false: get_node(gnhold + "/icon").texture = gv.sprite["hold_false"]

func r_buy_button_only() -> void:
	
	if lored.active:
		get_node("v/m/v/interactables/lored/h/buy/h/name").hide()
		get_node(gnhalt).show()
		get_node(gnhold).show()
		return
	
	get_node(gnhalt).hide()
	get_node(gnhold).hide()
	if lored.times_purchased == 0:
		get_node("v/m/v/interactables/lored/h/buy/h/name").show()

func random_shit():
	
	# s2n upgrade menu button
	pass
	#rewrite
#	if not gv.Tab.EXTRA_NORMAL in gv.unlocked_tabs:
#		if b_ubu_s2n_check():
#			rt.unlock_tab(gv.Tab.EXTRA_NORMAL)


func manage_buff(buff) -> void:
	
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
	if not lored.cost_check():
		if manual and is_instance_valid(rt.get_node("global_tip").tip):
			rt.get_node("global_tip").tip.price_flash()
		return
	
	lored.bought()
	update_net(true)
	set_buy_modulate()
	
	random_shit()
	
	for b in lored.b:
		if gv.g[b].active:
			rt.get_node(rt.gnLOREDs).cont[b].update_net(true)
	
	
	if manual:
		rt.get_node("global_tip")._call("no")
		rt.get_node("global_tip")._call("buy lored " + key)
	
	cont["lored up"] = src.buy.instance()
	cont["lored up"].init("lv" + fval.f(lored.level), lored.color)
	get_node("lv/n").add_child(cont["lored up"])
	cont["lored up"].rect_rotation = -10
	
	match key:
		"stone":
			pass
		"coal":
			if lored.times_purchased == 2:
				if gv.dev_mode:
					speak("whoa!")
					continue
			if lored.times_purchased == 1:
				if gv.dev_mode:
					speak("hi")
	
	# not owned
	if lored.level == 1:
		
		start_all()
		
		if lored.smart:
			gn_d.show()
		
		# task
		if key in rt.task_awaiting and not rt.on_task:
			rt.get_node("misc/task")._clear_board()
			rt.get_node("misc/task")._call_board()


func emote():
	
	if not gv.dev_mode:
		return
	
	#note delete this if
	if lored.emote_pool.size() == 0:
		return
	
	while not lored.unlocked:
		
		var t = Timer.new()
		add_child(t)
		var time = 10
		t.start(time)
		yield(t, "timeout")
		t.queue_free()
	
	while lored.unlocked and not lored.active:
		
		var t = Timer.new()
		add_child(t)
		var time = 1
		t.start(time)
		yield(t, "timeout")
		t.queue_free()
	
	while lored.active:
		
		var time = randi() % 90 + 30 # 30-120 sec
		if false:
			time = randi() % 10 + 10 # 10-20
		
		var t = Timer.new()
		add_child(t)
		t.start(time)
		yield(t, "timeout")
		t.queue_free()
		
		while emoting:
			
			# wait for current message to go away.
			
			if true:
				var tt = Timer.new()
				add_child(tt)
				tt.start(1)
				yield(tt, "timeout")
				tt.queue_free()
			
			if not emoting:
				var tt = Timer.new()
				add_child(tt)
				tt.start(3)
				yield(tt, "timeout")
				tt.queue_free()
		
		if not lored.active:
			break
		
		var roll: int
		
		if key == "copo":
			
			#roll = randi() % lored.emote_pool.size()
			if last_emote_index == lored.emote_pool.size() - 1:
				roll = 0
			else:
				roll = last_emote_index + 1
		
		else:
			while true:
				roll = randi() % lored.emote_pool.size()
				if roll == last_emote_index:
					continue
				if lored.emote_pool[roll].requires_unlock:
					if not gv.g[lored.emote_pool[roll].required_unlock_key].unlocked:
						continue
				break
		
		last_emote_index = roll
		var _emote = lored.emote_pool[roll]
		
		if key == "copo":
			if emoting:
				kill_emote()
		
		speak(_emote.message)
		
		if _emote.has_reply and gv.g[_emote.reply_key].unlocked:
			gv.g[_emote.reply_key].manager.reply(_emote.reply_message)
	
	emote()

func reply(message: String):
	
	var t = Timer.new()
	add_child(t)
	t.start(max(message.length() / 10, 3))
	yield(t, "timeout")
	t.queue_free()
	
	speak(message)

func speak(message := ""):
	
	if emoting:
		return
	
	emoting = true
	
	emote = gv.SRC["emote"].instance()
	
	if message != "":
		emote.init(self, key, message)
		emote.rect_position = Vector2(43 - (emote.rect_size.x / 2), 90 - (emote.rect_size.y / 2))
		get_node("texts").add_child(emote)
	
	var t = Timer.new()
	add_child(t)
	t.start(max(message.length() / 5, 3))
	yield(t, "timeout")
	t.queue_free()
	
	kill_emote()

func kill_emote():
	
	if is_instance_valid(emote):
		emote.die()
	

#rewrite
#func b_ubu_s2n_check() -> bool:
#
#	if not gv.Quest.THE_HEART_OF_THINGS in taq.completed_quests:
#		return false
#
#	for x in ["soil", "seed", "water", "tree", "sand", "draw", "axe", "liq", "steel", "wire", "glass", "hard", "wood", "humus"]:
#		if not gv.g[x].active:
#			return false
#
#	return true


func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")

func _on_animation_mouse_entered() -> void:
	rt.get_node("global_tip")._call("mainstuff lored " + key)

func _on_buy_mouse_entered() -> void:
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

