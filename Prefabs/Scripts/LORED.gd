extends MarginContainer


onready var rt = get_node("/root/Root")


const incomplete_animation_list := ["paper", "soil", "pulp", "axe", "hard", "steel", "draw", "wire", "lead", "pet", "plast", "carc", "tum"]


var crit := false
var critcrit := false
var anim_complete := true

var first_sec := 0.0

var key = "copo"

var slow_fps := 1.0
var medium_fps := 0.25
var quick_fps := 0.025
var fps := {
	# if set == true, then it is queued up
	# each individual "set" is set in relevant places across the code
	"net": FPS.new(slow_fps, true),
	"d": FPS.new(medium_fps),
	"progress": FPS.new(quick_fps),
	"fuel": FPS.new(quick_fps),
	"amount": FPS.new(quick_fps),
	"buy modulate": FPS.new(medium_fps, true),
	"frames": FPS.new(quick_fps, true),
	"autobuywheel": FPS.new(slow_fps),
	"random shit": FPS.new(slow_fps, true),
	"sync": FPS.new(medium_fps),
	"autobuy": FPS.new(medium_fps, true),
}




var gnamount = "h/h/lored/h/v/amount"
var gntask = "h/h/lored/task"
var gntaskf = gntask + "/f"
var gnfuel = "h/h/lored/fuel/fuel"
var gnfuelf = gnfuel + "/f"
var gnnet = "h/h/lored/h/v/net"

var gnicon = "h/h/lored/h/icon/Sprite"
var gnfuelicon = "h/h/lored/fuel/fuel_icon/Sprite"
var gnframes = "h/h/animation/AnimatedSprite"

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
	
	hide()
	
	r_setup()
	
	r_progress()

func r_setup():
	
	# text
	get_node("h/h/lored/h/v/name").text = gv.g[key].name
	r_update_halt(gv.g[key].halt)
	
	# icons
	r_update_hold(gv.g[key].hold)
	get_node("h/h/lored/h/icon/Sprite").texture = gv.sprite[key]
	get_node("h/h/lored/fuel/fuel_icon/Sprite").texture = gv.sprite["coal"] if "bur " in gv.g[key].type else gv.sprite["jo"]
	
	if key in gv.anim.keys():
		get_node(gnframes).frames = gv.anim[key]
	else:
		get_node(gnframes).frames = gv.anim["copo"]
	
	# color
	var fuel_color = get_fuel_color()
	
	get_node("bg2").self_modulate = gv.g[key].color
	
	get_node(gnframes).self_modulate = get_faded_color()
	get_node("h/h/lored/fuel/fuel/f").self_modulate = fuel_color
	get_node("h/h/lored/fuel/fuel/f/flair").self_modulate = fuel_color
	
	get_node(gnhold + "/icon").self_modulate = gv.g[key].color
	get_node(gnhalt + "/text").self_modulate = gv.g[key].color
	get_node(gnbuy + "/autobuywheel").self_modulate = gv.g[key].color
	get_node("h/h/animation").self_modulate = gv.g[key].color
	get_node(gnamount).self_modulate = gv.g[key].color
	get_node("h/h/lored/task/d").self_modulate = gv.g[key].color
	get_node("h/h/lored/task/f").modulate = gv.g[key].color
	
	if key in incomplete_animation_list:
		anim_complete = false
	
	get_node(gnhalt + "/text").text = "=="
	
	# frames
	if true:
		
		get_node(gnframes).frame = 0
		get_node(gnbuy + "/autobuywheel").frame = int(rand_range(0, 16))
		
		match key:
			"humus": max_frames = 9
			"gale": max_frames = 22
			#"ciga": max_frames = 25
			"liq": max_frames = 22
			"sand": max_frames = 45
			"wood": max_frames = 49
			"toba": max_frames = 73
			"glass": max_frames = 37
			"seed":
				max_frames = 30
				halfway_frame = 15
			"tree": max_frames = 77
			"water":
				max_frames = 25
				halfway_frame = 13
			#"coal": max_frames = 25
			"stone": max_frames = 27
			"irono": max_frames = 28
			#"copo": max_frames = 25
			"iron": max_frames = 47
			"cop": max_frames = 30
			"growth": max_frames = 40
			"conc": max_frames = 57
			"jo": max_frames = 32
			"malig": max_frames = 36
			"tar": max_frames = 29
			"oil": max_frames = 8
		
		frame_set[key] = false
		frame_set[key + " last"] = 0
		
		# flip horizontal
		if key in ["irono", "copo", "iron", "jo", "liq"]:
			get_node(gnframes).flip_h = true
		
		get_node(gnframes).animation = "ww"
	
	if gv.g[key].used_by.size() == 0:
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
			return Color((1 - gv.g[key].color.r) / 2 + gv.g[key].color.r, (1 - gv.g[key].color.g) / 2 + gv.g[key].color.g, (1 - gv.g[key].color.b) / 2 + gv.g[key].color.b)

func get_fuel_color() -> Color:
	
	if "bur " in gv.g[key].type:
		return gv.g["coal"].color
	
	return gv.g["jo"].color


func _on_buy_pressed() -> void:
	buy(true)


func _on_halt_pressed():
	
	if "no" in gv.menu.f:
		if int(gv.g[key].type[1]) <= int(gv.menu.f.split("no s")[1]): return
	
	match gv.g[key].halt:
		true:
			gv.g[key].halt = false
		false:
			gv.g[key].halt = true
	
	if is_instance_valid(rt.get_node("global_tip").tip):
		rt.get_node("global_tip").tip.cont["halt"].r_update()
	
	r_update_halt(gv.g[key].halt)
	
	gv.emit_signal("lored_updated", key, "net")
	
	for x in gv.g:
		if key in gv.g[x].used_by:
			gv.emit_signal("lored_updated", x, "net")

func _on_hold_pressed():
	
	if "no" in gv.menu.f:
		if int(gv.g[key].type[1]) <= int(gv.menu.f.split("no s")[1]): return
	
	match gv.g[key].hold:
		true: gv.g[key].hold = false
		false: gv.g[key].hold = true
	
	if is_instance_valid(rt.get_node("global_tip").tip):
		rt.get_node("global_tip").tip.cont["hold"].r_update()
	
	r_update_hold(gv.g[key].hold)
	
	gv.emit_signal("lored_updated", key, "net")
	
	for x in gv.g[key].used_by:
		gv.emit_signal("lored_updated", x, "net")


func _physics_process(delta: float) -> void:
	
	if not gv.g[key].unlocked:
		return
	
	wm_lored(gv.g[key])
	
	fps()
	
	if first_sec < 1:
		first_sec += delta


func autobuy():
	
	if gv.g[key].autobuy():
		buy()


func wm_lored(f: LORED) -> void:
	
	if not f.active:
		return
	
	# if base task duration == 1
	if f.progress.b == 1:
		
		f.inhand = Big.new(f.d.t)
		f.task = w_logic(f)
		wm_tasks(f)
	
	fuel()
	
	var witch = f.witch(true)
	gv.r[key].a(witch)
	gv.increase_lb_xp(witch)
	gv.emit_signal("lored_updated", key, "amount")
	
	if f.progress.b == 1:
		softlock_check()
		return
	
	if f.f.f.isLargerThanOrEqualTo(f.fc.t):
		
		f.progress.f += 1
		
		fps["progress"].set = true#gv.emit_signal("lored_updated", key, "progress")
		r_progress()
	
	else:
		f.progress.f += 0.05
	
	
	if f.progress.f < f.progress.t:
		return
	
	
	f.progress.f = 0
	
	fps["progress"].set = true#gv.emit_signal("lored_updated", key, "progress")
	r_progress()
	
	f.progress.b = 1
	if f.crit.t.isLargerThan(0):
		f.inhand.m(w_crit_roll(true))
	wm_tasks(f, false)


func fuel() -> void:
	
	# catches
	if "no" in gv.menu.f:
		if int(gv.g[key].type[1]) <= int(gv.menu.f.split("no s")[1]):
			return
	
	
	var gain := Big.new(0)
	var drain := Big.new(0)
	
	var working = false if gv.g[key].progress.b == 1 else true
	var fuel_source = "coal" if "bur " in gv.g[key].type else "jo"
	
	
	# drain
	if working:
		drain.a(gv.g[key].fc.t)
	
	# gain
	if gv.g[key].f.f.isLessThan(gv.g[key].f.t):
		if not gv.g[fuel_source].is_baby(int(gv.g[key].type[1])):
			if sufficient_fuel(fuel_source):
				
				gain.a(gv.g[key].fc.t)
				gain.m(2)
	
	
	
	gv.r[fuel_source].s(gain)
	milkshake(fuel_source)
	gv.emit_signal("lored_updated", fuel_source, "amount")
	
	
	gv.emit_signal("lored_updated", key, "fuel")
	
	gv.g[key].f.f.s(drain)
	gv.g[key].f.f.a(gain)
	
	if gv.g[key].f.f.isLargerThan(gv.g[key].f.t):
		gv.g[key].f.f = Big.new(gv.g[key].f.t)

func milkshake(fuel_source: String) -> void:
	
	if fuel_source != "coal":
		return
	if not gv.up["I DRINK YOUR MILKSHAKE"].active():
		return
	
	gv.up["I DRINK YOUR MILKSHAKE"].effects[0].effect.a.a(0.0001)

func sufficient_fuel(fuel_source: String) -> bool:
	
	if key == "coal":
		if gv.r[key].isLargerThan(gv.g[key].fc.t):
			return true
		return false
	
	var _min = Big.new(gv.g[key].fc.t).m(3)
	if fuel_source == "coal":
		_min.a(gv.g[fuel_source].d.t)
	
	if gv.r[fuel_source].isLargerThanOrEqualTo(_min):
		return true
	
	return false

func wm_tasks(f, beginning = true):
	
	if beginning:
		
		if not "idle" in f.task and not "na " in f.task:
			f.progress.b = f.speed.t.toFloat()
			if f.sync_queued:
				f.sync()
				fps["sync"].f = fps["sync"].b # fps["sync"].t = fps["sync"].b
			else:
				f.progress.sync()
		
		if "cook " in f.task:
			
			for x in f.b:
				var less = Big.new(f.d.t).m(f.b[x].t)
				gv.r[x].s(less)
				gv.emit_signal("lored_updated", x, "amount")
		
		if fps["sync"].f <= 0:
			if f.sync_queued:
				f.sync()
				fps["sync"].f = fps["sync"].b # fps["sync"].t = fps["sync"].b
		
		r_wm_tasks(true)
		
		return
	
	# below here, beginning = false
	
	w_output_master(f)
	
	r_wm_tasks(false)
	
	crit = false
	critcrit = false

func r_wm_tasks(beginning: bool):
	
	if not rt.get_node(rt.gnLOREDs + "/sc/v/s" + gv.g[key].type[1]).visible:
		return
	
	if beginning:
		
		# animation
		if gv.menu.option["animations"]:
			var anim = "ff"
			if not anim_complete or "idle" in gv.g[key].task or "na " in gv.g[key].task: anim = "ww"
			get_node(gnframes).animation = anim
		
		return
	
	# dtext # flying
	if gv.menu.option["flying_numbers"]:
		
		var luck_to_go := true
		if gv.menu.option["crits_only"]:
			if not crit: luck_to_go = false
		
		if get_node("h/h/lored/h/v/amount").rect_global_position.y < rt.get_node("m/v/top").rect_global_position.y + rt.get_node("m/v/top").rect_size.y:
			luck_to_go = false
		elif get_node("h/h/lored/h/v/amount").rect_global_position.y > rt.get_node("m/v/bot").rect_global_position.y:
			luck_to_go = false
		
		if luck_to_go:
			
			output["hi"] = src.output.instance()
			output["hi"].init(true, 0, "+ " + gv.g[key].inhand.toString(), gv.sprite[key], gv.g[key].color)
			if crit:
				if critcrit:
					output["hi"].text += " (Power crit!)"
				else:
					output["hi"].text += " (Crit!)"
			
#			var pos = Vector2(
#				get_node("h/h/lored/h/v/amount").rect_global_position.x + int(rand_range(-10,10)),
#				get_node("h/h/lored/h/v/amount").rect_global_position.y - 15
#			)
			
			var pos = Vector2(30,15)
			
			output["hi"].rect_position = pos
			
			#rt.get_node("m/lored texts").add_child(output["hi"])
			get_node("texts").add_child(output["hi"])
	

func w_output_master(f) -> void:
	
	w_bonus_output(f.key, f.inhand)
	
	gv.r[f.key].a(f.inhand)
	gv.increase_lb_xp(f.inhand)
	gv.emit_signal("lored_updated", key, "amount")
	gv.g[key].task_and_quest_check(f.inhand)
	gv.stats.r_gained[f.key].a(f.inhand)

func w_bonus_output(key : String, inhand : Big) -> void:
	
	match key:
		"coal":
			if gv.up["wait that's not fair"].active():
				var bla = Big.new(inhand).m(10)
				gv.r["stone"].a(bla)
				gv.increase_lb_xp(bla)
				gv.emit_signal("lored_updated", "stone", "amount")
				gv.g["stone"].task_and_quest_check(bla)
		"irono":
			if gv.up["I RUN"].active():
				gv.r["iron"].a(inhand)
				gv.increase_lb_xp(inhand)
				gv.emit_signal("lored_updated", "iron", "amount")
				gv.g["iron"].task_and_quest_check(inhand)
		"copo":
			if gv.up["THE THIRD"].active():
				gv.r["cop"].a(inhand)
				gv.increase_lb_xp(inhand)
				gv.emit_signal("lored_updated", "cop", "amount")
				gv.g["cop"].task_and_quest_check(inhand)
		"growth":
			if gv.up["IT'S GROWIN ON ME"].active():
				var buff = 0.1 * gv.g["growth"].level
				if not gv.up["IT'S SPREADIN ON ME"].active():
					var roll = randi()%2
					match roll:
						0:
							gv.up["IT'S GROWIN ON ME"].effects[0].effect.a.a(buff)
							gv.emit_signal("lored_updated", "iron", "d")
						1:
							gv.up["IT'S GROWIN ON ME"].effects[1].effect.a.a(buff)
							gv.emit_signal("lored_updated", "cop", "d")
				else:
					gv.up["IT'S GROWIN ON ME"].effects[0].effect.a.a(buff)
					gv.up["IT'S GROWIN ON ME"].effects[1].effect.a.a(buff)
					gv.up["IT'S SPREADIN ON ME"].effects[0].effect.a.a(buff)
					gv.up["IT'S SPREADIN ON ME"].effects[1].effect.a.a(buff)
					gv.emit_signal("lored_updated", "iron", "d")
					gv.emit_signal("lored_updated", "cop", "d")
					gv.emit_signal("lored_updated", "irono", "d")
					gv.emit_signal("lored_updated", "copo", "d")

func w_logic(f) -> String:
	
	
	if "no" in gv.menu.f:
		if int(f.type[1]) <= int(gv.menu.f.split(" s")[1]): return "idle"
	
	if f.halt:
		return "idle"
	
	if f.f.f.isLessThan(Big.new(f.speed.t).m(f.fc.t).m(1.1)):
		if "bur " in f.type: return "na coal"
		if "ele " in f.type: return "na jo"
	
	if "bore " in f.type:
		return "bore " + f.key
	
	# all below has "fur " in type
	
	# catches -- return "na "
	if true:
		
		for x in f.b:
			if gv.g[x].hold:
				return "na burn"
			if gv.r[x].isLessThan(Big.new(f.d.t).m(f.b[x].t)):
				return "na burn"
			if x == "iron" and Big.new(gv.r["iron"]).a(f.d.t).isLessThanOrEqualTo(20):
				return "na burn"
			if x == "cop" and Big.new(gv.r["cop"]).a(f.d.t).isLessThanOrEqualTo(20):
				return "na burn"
			if x == "stone" and Big.new(gv.r["stone"]).a(f.d.t).isLessThanOrEqualTo(30):
				return "na burn"
			if gv.up["don't take candy from babies"].active():
				if "s1" in gv.g[x].type and not "s1" in f.type and gv.g[x].level < 5:
					return "na burn"
		
		# unique ifs
		if true:
			match f.key:
				"jo":
					if gv.r["coal"].isLessThan(gv.g["coal"].d.t):
						return "na burn"
	
	return "cook " + f.key


func w_crit_roll(by_thine_own_hand : bool) -> Big:
	
	var f := Big.new(1)
	
	var roll := Big.new(rand_range(0,100))
	if roll.isLessThanOrEqualTo(gv.g[key].crit.t):
		f.m(rand_range(7.5, 12.5))
		if by_thine_own_hand: crit = true
	
	if gv.g[key].type[1] == "1":
		
		if not gv.up["the athore coments al totol lies!"].active():
			return f
		
		roll = Big.new(rand_range(0,101))
		if roll.isLessThanOrEqualTo(1):
			f.m(rand_range(7.5, 12.5))
			if by_thine_own_hand: critcrit = true
	
	return f


func softlock_check():
	
	# softlock checks done out of "ye" can be done above here
	
	if not "ye" in gv.menu.f:
		return
	
	softlock_wood_cycle()
	softlock_no_seeds()
	softlock_no_steel_for_liq()
	softlock_not_enough_wire()

func softlock_not_enough_wire():
	
	if key != "wire":
		return
	
	if gv.g["draw"].active:
		return
	
	if gv.r["wire"].isLessThan(20):
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
		
		if gv.r["axe"].isLargerThan(Big.new(gv.g["wood"].d.t).m(gv.g["wood"].b["axe"].t)):
			return
		if gv.r["wood"].isLargerThan(Big.new(gv.g["hard"].d.t).m(gv.g["hard"].b["wood"].t)):
			return
		if gv.r["hard"].isLargerThan(Big.new(gv.g["axe"].d.t).m(gv.g["axe"].b["hard"].t)):
			return
	
	print("Axes, Wood, and Hardwood dropped low enough that none of them could take from each other, so you've been given free resources.")
	
	for x in axe_wood_hard:
		gv.r[x].a(gv.g[x].d.t)
		gv.emit_signal("lored_updated", x, "amount")

func softlock_no_seeds():
	
	if key != "tree":
		return
	
	if gv.g["seed"].active:
		return
	if gv.r["tree"].isLargerThanOrEqualTo(2):
		return
	if gv.r["seed"].isLargerThanOrEqualTo(Big.new(gv.g["tree"].d.t).m(gv.g["tree"].b["seed"].t)):
		return
	
	print("You didn't have enough Seeds to produce any Trees to be able to afford the Seed LORED, so you've been given free Trees.")
	
	gv.r["tree"].a(2)
	gv.emit_signal("lored_updated", "tree", "amount")

func softlock_no_steel_for_liq():
	
	if key != "steel":
		return
	
	if gv.g["liq"].active:
		return
	
	if gv.r["liq"].isLargerThan(Big.new(gv.g[key].d.t).m(gv.g[key].b["liq"].t)):
		return
	
	if gv.r[key].isLargerThan(gv.g["liq"].cost["steel"].t):
		return
	
	print("You didn't have enough Steel to purchase a Liquid Iron LORED, so you've been given free Steel.")
	
	gv.r[key] = Big.new(gv.g["liq"].cost["steel"].t)


func fps():
	
	for x in fps:
		
		# see: FPS.gd
		if not fps[x].process(get_physics_process_delta_time()) and not fps[x].pending:
			continue
		
		work(x)
		ref(x)


func work(x: String):
	
	# funcs that should be called regardless of whether the LORED is visible or not
	
	match x:
		"autobuy": autobuy()


func ref(x: String):
	
	# funcs that should only be done when the LORED is visible
	
	# catches
	if first_sec >= 1:
		if not visible:
			return
		if not rt.get_node(rt.gnLOREDs + "/sc/v/s" + gv.g[key].type[1]).visible:
			fps[x].pending = true
			return
	
	fps[x].pending = false
	
	match x:
		"frames": r_frames()
		"progress": r_progress()
		"fuel": r_fuel()
		"amount": r_amount()
		"d": r_d()
		"net": r_net()
		"buy modulate": r_buy_modulate()
		"autobuywheel": r_autobuywheel()
		"random shit": random_shit()

func r_amount():
	get_node(gnamount).text = gv.r[key].toString()
	gv.emit_signal("amount_updated", key)

func r_net():
	
	var net = gv.g[key].net()
	
	gv.emit_signal("net_updated", key, [Big.new(net[0]), Big.new(net[1])])
	get_node("h/h/animation/status").self_modulate = r_status_indicator([Big.new(net[0]), Big.new(net[1])])
	
	var net_text = ""
	
	if net[0].isLargerThanOrEqualTo(net[1]):
		net[0].s(net[1])
		net_text = net[0].toString()
	else:
		net[1].s(net[0])
		net_text = "-" + net[1].toString()
	
	get_node(gnnet).text = net_text + "/s"

func r_d():
	
	get_node("h/h/lored/task/d").text = "+" + gv.g[key].d.print()

func r_progress():
	
	var task_percent = gv.g[key].progress.f / gv.g[key].progress.t * get_node(gntask).rect_size.x
	get_node(gntaskf).rect_size.x = task_percent

func r_frames():
	
	# catches
	if true:
		
		if "idle" in gv.g[key].task or "na " in gv.g[key].task:
			get_node(gnframes).playing = true
			return
	
	if gv.g[key].speed.t.percent(gv.g[key].speed.b) < 0.15 or gv.g[key].speed.t.isLessThan(15):
		get_node(gnframes).playing = true
		return
	
	
	get_node(gnframes).playing = false
	
	match key:
		
		"water", "seed":
			
			var frame = int(gv.g[key].progress.f / gv.g[key].progress.t * max_frames)
			frame /= 2
			
			if frame == 0 and not frame_set[key]:
				
				frame_set[key] = true
				
				if frame_set[key + " last"] == 0:
					get_node(gnframes).frame = halfway_frame
					frame_set[key + " last"] = 1
				else:
					get_node(gnframes).frame = 0
					frame_set[key + " last"] = 0
			
			else:
				
				if frame > 0:
					frame_set[key] = false
				
				get_node(gnframes).frame = frame
				if frame_set[key + " last"] == 1:
					get_node(gnframes).frame += halfway_frame
		
		_:
			
			get_node(gnframes).frame = int(gv.g[key].progress.f / gv.g[key].progress.t * max_frames)

func r_fuel():
	
	var fuel_percent = min(gv.g[key].f.f.percent(gv.g[key].f.t), 1.0) * get_node(gnfuel).rect_size.x
	get_node(gnfuelf).rect_size.x = fuel_percent
	if get_node(gnfuel).rect_size.x - get_node(gnfuelf).rect_size.x <= 3:
		get_node(gnfuelf).rect_size.x = get_node(gnfuel).rect_size.x

func r_buy_modulate():
	
	var BAD := Color(1.3, 0, 0)
	var GOOD := Color(1, 1, 1)
	
	get_node(gnbuy).self_modulate = GOOD if gv.g[key].cost_check() else BAD

func r_autobuy() -> void:
	
	if gv.g[key].autobuy:
		get_node(gnbuy + "/autobuywheel").show()
		return
	
	get_node(gnbuy + "/autobuywheel").hide()

func r_autobuywheel():
	
	if not get_node(gnbuy + "/autobuywheel").visible:
		return
	
	get_node(gnbuy + "/autobuywheel").speed_scale = gv.g[key].speed.b.percent(gv.g[key].speed.t)

func r_update_halt(halt:bool) -> void:
	match halt:
		true: get_node(gnhalt + "/text").text = "=/="
		false: get_node(gnhalt + "/text").text = "=="

func r_update_hold(hold:bool) -> void:
	match hold:
		true: get_node(gnhold + "/icon").texture = gv.sprite["hold_true"]
		false: get_node(gnhold + "/icon").texture = gv.sprite["hold_false"]

func r_status_indicator(net) -> Color:
	
	# inactive
	if not gv.g[key].active:
		return status_color("hide")
	
	if gv.g[key].halt:
		return status_color("halt")
	
	# bad
	if true:
		
		if net[1].isLargerThan(Big.new(net[0]).m(2)):
			return status_color("bad")
		
		if net[1].isLargerThan(net[0]):
			if gv.r[key].isLessThanOrEqualTo(Big.new(gv.g[key].d.t).m(100)) and Big.new(net[1]).s(net[0]).isLessThan(Big.new(gv.g[key].d.t).m(0.01)):
				return status_color("bad")
	
	# possibly fine
	if true:
		
		if net[1].isLargerThan(net[0]):
			return status_color("fine")
		
		if gv.r[key].isLessThanOrEqualTo(Big.new(gv.g[key].d.t).m(2)) and Big.new(net[0]).s(net[1]).isLessThan(Big.new(gv.g[key].d.t).m(0.01)):
			return status_color("fine")
	
	# good
	return status_color("good")

func status_color(status:String) -> Color:
	
	match status:
		"hide":
			return Color(0,0,0,0.0)
		"halt":
			return Color(gv.g[key].color.r, gv.g[key].color.g, gv.g[key].color.b, 1)
		"fine":
			return Color(1,1,0, 1)
		"bad":
			return Color(1,0,0, 1)
		"good":
			return Color(1,0,0, 0.0)
	
	return Color(0.498039, 0.498039, 0.498039) #Color(0.760784, 0.729412, 0.6) # papyrus

func random_shit():
	
	# s2n upgrade menu button
	if not gv.stats.tabs_unlocked["s2n"]:
		if b_ubu_s2n_check():
			rt.unlock_tab("s2n")




func buy(manual := false):
	
	# catches
	if true:
		
		if not gv.g[key].cost_check():
			if manual and is_instance_valid(rt.get_node("global_tip").tip):
				rt.get_node("global_tip").tip.price_flash = true
			return
		
		if gv.g[key].type[1] in gv.menu.f:
			return
	
	gv.g[key].bought()
	
	if manual:
		rt.get_node("global_tip")._call("no")
		rt.get_node("global_tip")._call("buy lored " + key)
	
	gv.emit_signal("lored_updated", key, "d")
	if manual:
		fps["net"].f = 0
	gv.emit_signal("lored_updated", key, "net")
	
	cont["lored up"] = src.buy.instance()
	cont["lored up"].init("lv" + fval.f(gv.g[key].level), gv.g[key].color)
	get_node("lv/n").add_child(cont["lored up"])
	cont["lored up"].rect_rotation = -10
	
	# not owned
	if gv.g[key].level == 1:
		
		if gv.g[key].borer and gv.menu.option["animations"]:
			get_node(gnframes).animation = "ff"
		
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
	rt.get_node("global_tip")._call("buy lored " + key)

func _on_fuel_mouse_entered() -> void:
	if not gv.menu.option["tooltip_fuel"]: return
	rt.get_node("global_tip")._call("fuel lored " + key)

func _on_halt_mouse_entered():
	if not gv.g[key].active: return
	if not gv.menu.option["tooltip_halt"]: return
	rt.get_node("global_tip")._call("tip halt lored " + key)

func _on_hold_mouse_entered():
	if not gv.g[key].active: return
	if not gv.menu.option["tooltip_hold"]: return
	rt.get_node("global_tip")._call("tip hold lored " + key)
