extends Panel

var fps := 0.0
var autobuyer_fps := 0.0

onready var rt = get_node("/root/Root")
onready var output_prefab := preload("res://Prefabs/dtext.tscn") # output_text
onready var lored_buy := preload("res://Prefabs/lored_buy.tscn")

var my_lored : String # this prefab's designated lored, set in init
var my_autobuyer : String
var my_color : Color
var crit := false
var critcrit := false
var abw_hidden := true
var abw_shown := false
var frame_set := {}

var content := {
	lbi = 0,
}

var max_frames : int = 25
var halfway_frame : int = 13

var output := {} # dict holding every output text prefab


func _ready():
	$lb.text = ""


func init(type : String) -> void:
	
	my_lored = type
	
	# disabled
	if not type == "stone":
		$halt.disabled = true
		$hold.disabled = true
	
	$halt/text.text = "=="
	if type in rt.anim.keys(): $worker.frames = rt.anim[type]
	else: $worker.frames = rt.anim["copo"]
	
	# frames
	var roll :int=rand_range(0, 16)
	$worker.frame = 0
	$autobuywheel.frame = roll
	
	# flip horizontal
	var flip_list : String = "irono copo iron jo liq "
	if my_lored + " " in flip_list: $worker.flip_h = true
	
	# color
	if true:
		
		my_color = rt.r_lored_color(type)
		
		var color : Color
		
		# fuel bar color
		if "bur" in gv.g[type].type:
			color = rt.r_lored_color("coal")
		elif "ele" in gv.g[type].type:
			color = rt.r_lored_color("jo")
		color = Color(color.r, color.g, color.b, 0.4)
		$fuel.tint_progress = Color(color.r, color.g, color.b, 1.0)
		$fuel.tint_under = Color(color.r, color.g, color.b, 0.35)
		
		# flair colors
		$autobuywheel.modulate = my_color
		$progress.tint_progress = Color(my_color.r, my_color.g, my_color.b, 1.0)
		$progress.tint_under = Color(my_color.r, my_color.g, my_color.b, 0.35)
		$flair_bot.modulate = Color(my_color.r, my_color.g, my_color.b, 0.8)
		
		# worker color
		match type:
			"steel":
				color = Color(0.823529, 0.898039, 0.92549)
			"humus":
				color = Color(0.6, 0.3, 0)
			"gale": color = Color(0.701961, 0.792157, 0.929412)
			"ciga": color = Color(0.97, 0.8, 0.6)
			"liq": color = Color(0.7, 0.94, .985) # Color(0.27, 0.888, .97)
			"wood": color = Color(0.77, 0.68, 0.6)
			"toba":
				color = Color(0.85, 0.75, 0.63)
			"glass":
				color = Color(0.81, 0.93, 1.0)
			"seed": color = Color(.8,.8,.8)
			"tree":
				color = Color(0.864746, 0.988281, 0.679443)
			"water":
				color = Color(0.570313, 0.859009, 1)
			"coal":
				color = Color(0.9, 0.3, 1)
			"stone":
				color = Color(0.788235, 0.788235, 0.788235)
			"irono":
				color = Color(0.5, 0.788732, 1)
			"copo":
				color = Color(0.695313, 0.502379, 0.334076)
			"iron":
				color = Color(0.496094, 0.940717, 1)
			"cop":
				color = Color(1, 0.862001, 0.496094)
			"growth":
				color = Color(0.890041, 1, 0.5)
			"conc":
				color = Color(0.4, 0.4, 0.4)
			"jo":
				color = Color(1, 0.9572, 0.503906)
			"malig":
				color = Color(0.882353, 0.121569, 0.352941)
			"tar":
				color = Color(0.560784, 0.439216, 1)
			"oil":
				color = Color(0.647059, 0.298039, 0.658824)
			_:
				color = Color((1 - my_color.r) / 2 + my_color.r, (1 - my_color.g) / 2 + my_color.g, (1 - my_color.b) / 2 + my_color.b)
		$worker.modulate = Color(color.r, color.g, color.b, 1)
		$hold/icon.modulate = my_color
		
		# text color
		$halt/text.add_color_override("font_color", my_color)
		$amount.add_color_override("font_color", my_color)
	
	for x in gv.stats.up_list["autob"]:
		if not my_lored == gv.up[x].main_lored_target: continue
		my_autobuyer = x
		break
	
	# frame info
	match my_lored:
		"humus": max_frames = 9
		"gale": max_frames = 22
		"ciga": max_frames = 25
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
		"coal": max_frames = 25
		"stone": max_frames = 27
		"irono": max_frames = 28
		"copo": max_frames = 25
		"iron": max_frames = 47
		"cop": max_frames = 30
		"growth": max_frames = 40
		"conc": max_frames = 57
		"jo": max_frames = 32
		"malig": max_frames = 36
		"tar": max_frames = 29
		"oil": max_frames = 8
	
	frame_set[my_lored] = false
	frame_set[my_lored + " last"] = 0
	$worker.animation = "ww"
	
	if gv.g[my_lored].used_by.size() == 0:
		$hold.hide()
		$halt.rect_size.x = 64
	
	# visibility
	hide()


func _physics_process(delta) -> void:
	
	if not gv.g[my_lored].unlocked:
		return
	
	wm_lored(gv.g[my_lored])
	
	autobuyer()
	
	# ref
	if true:
		
		fps += delta
		if fps < rt.FPS: return
		fps -= rt.FPS
		
		r_lored(gv.g[my_lored])


func autobuyer() -> void:
	
	if my_autobuyer == "":
		return
	
	autobuyer_fps += get_physics_process_delta_time()
	if autobuyer_fps < 0.25:
		return
	autobuyer_fps -= .25
	
	if "no" in rt.menu.f:
		if int(gv.up[my_autobuyer].type[1]) <= int(rt.menu.f.split("no s")[1]):
			return
	
	if not gv.up[my_autobuyer].active():
		return
	
	if autobuy():
		b_buy_lored()

func autobuy() -> bool:
	
	# active
	if not gv.g[my_lored].active:
		return true
	
	# max fuel
	if true:
		
		var max_fuel = gv.g[my_lored].f.t
		
		if gv.g[my_lored].f.f < max_fuel * 0.1:
			return false
	
	if autobuy_upgrade_check():
		return true
	
	# if ingredient LORED per_sec < per_sec, don't buy
	for x in gv.g[my_lored].b:
		var consm : float = (gv.g[my_lored].d.t / gv.g[my_lored].speed.t * 60 * gv.g[my_lored].b[x].t)
		if gv.g[x].halt:
			if gv.g[x].net(true) - (consm * 2) < 0.0:
				if not autobuy_afford_ingredient_lored_check(x):
					return false
		elif gv.g[x].net() - consm < 0.0:
			if not autobuy_afford_ingredient_lored_check(x):
				return false
	
	if gv.g[my_lored].key_lored:
		return true
	
	# if per_sec > 0, don't buy
	if not gv.g[my_lored].type[1] in gv.overcharge_list:
		if gv.g[my_lored].net(false, true) > 0.0:
			return false
	else:
		var base_ps = gv.g[my_lored].net(false, true) #gv.g[my_lored].d.t / gv.g[my_lored].speed.t * 60
		base_ps /= max(1.0, gv.g[my_lored].f.f / gv.g[my_lored].f.t)
		var sapped_ps = 0.0
		for x in gv.g[my_lored].used_by:
			if (my_lored == "coal" and "bur " in gv.g[x].type) or (my_lored == "jo" and "ele " in gv.g[x].type):
				sapped_ps += gv.g[x].fc.t * 60
			if gv.g[x].halt or not gv.g[x].active:
				continue
			sapped_ps += (gv.g[x].d.t / gv.g[x].speed.t * 60) / max(1.0, gv.g[x].f.f / gv.g[x].f.t)
		if base_ps - sapped_ps > 0.0:
			return false
	
	return true
func autobuy_afford_ingredient_lored_check(_lored: String) -> bool:
	for x in gv.g[_lored].cost:
		if gv.g[x].r < gv.g[_lored].cost[x].t:
			return false
	return true

func autobuy_upgrade_check() -> bool:
	
	if "1" == gv.g[my_lored].type[1]:
		if gv.up["don't take candy from babies"].active() and gv.g[my_lored].level < 6:
			return true
	
	match my_lored:
		"malig":
			if gv.up["THE WITCH OF LOREDELITH"].active():
				return true
		"iron", "cop":
			if gv.up["IT'S SPREADIN ON ME"].active():
				return true
		"irono":
			if gv.up["I RUN"].active():
				return true
		"copo":
			if gv.up["THE THIRD"].active():
				return true
		"coal":
			if gv.up["wait that's not fair"].active():
				return true
	
	return false


func wm_lored(f: LORED) -> void:
	
	if not f.active:
		return
	
	# if base task duration == 1
	if f.progress.b == 1:
		
		f.inhand = f.d.t
		f.task = w_logic(f)
		wm_tasks(f)
	
	fuel(f)
	
	f.r += f.witch()
	
	if f.progress.b == 1:
		return
	
	if f.f.f >= f.fc.t:
		f.progress.f += 1
	else:
		f.progress.f += 0.05
	
	if f.progress.f < f.progress.t: return
	
	f.progress.f = 0.0
	f.progress.b = 1.0
	if f.crit.t > 0:
		f.inhand = w_crit_roll(f.inhand, true)
	wm_tasks(f, false)

func fuel(f: LORED) -> void:
	
	# f     = lored
	# f.f   = fuel variable
	# f.f.f = fuel amount
	# f.f.t = max_fuel
	
	var fuel_source = "coal" if "bur " in f.type else "jo"
	var max_fuel = f.f.t * gv.overcharge if f.type[1] in gv.overcharge_list else f.f.t
	
	# drain fuel
	var fuel_drain = f.fc.t
	var fuel_fill = fuel_net(
		fuel_source,
		f.progress.b, # progress
		fuel_drain, # fc
		f.f.f > f.f.t - (fuel_drain * 2), # over_ft
		f.type[1] in gv.overcharge_list, # in_lb
		fuel_call_vars(f, "resetting"), # resetting
		f.f.f >= (f.f.t * gv.overcharge) - (fuel_drain * 2), # at_max
		fuel_call_vars(f, "babies"), # babies
		fuel_call_vars(f, "coal_low"), # coal_low
		not fuel_call_vars(f, "fuel amount"), # insufficient_fuel
		f.f.f,
		max_fuel
	)
	
	f.f.f += fuel_fill * gv.hax_pow
	f.f.f = clamp(f.f.f, 0, max_fuel)
	
	limit_break(f)

func fuel_net(
	fuel_source: String,
	progress,
	fc: float, # fuel_cost
	over_ft: bool, # over_fuel_total
	in_lb: bool, # in gv.overcharge_list
	resetting: bool, # metastasize menu
	at_max: bool,
	babies: bool, # see fuel_call_vars - "babies"
	coal_low: bool, # keep coal above certain amount
	insufficient_fuel: bool,
	current: float,
	max_fuel
	) -> float:
	
	# determine whether fuel goes up or down
	
	if resetting:
		return 0.0
	
	# drain
	if true:
		
		if progress != 1: # active
			if insufficient_fuel:
				return -fc
		else:
			if insufficient_fuel:
				return 0.0
		
		if babies: # target is an s1 baby.
			if progress != 1:
				# already active
				return -fc
			else:
				# idle
				return 0.0
		
		if over_ft:
			
			if progress == 1:
				return -fc * 2
			if not in_lb:
				return -fc * 2
	
	if at_max:
		subtract_fuel(fuel_source, fc)
		return 0.0
	
	# gain
	subtract_fuel(fuel_source, fc * 2 * gv.g[my_lored].less_from_full(current, max_fuel))
	return fc * gv.g[my_lored].less_from_full(current, max_fuel)

func subtract_fuel(fuel_source: String, amount: float) -> void:
	
	gv.g[fuel_source].r -= amount
	
	# milkshake
	if true:
		
		if fuel_source != "coal":
			return
		if not gv.up["I DRINK YOUR MILKSHAKE"].active():
			return
		
		gv.up["I DRINK YOUR MILKSHAKE"].set_d.b += 0.0001

func fuel_call_vars(f, type: String) -> bool:
	
	var fuel_source = "coal" if "bur " in f.type else "jo"
	
	match type:
		"resetting":
			if "no" in rt.menu.f:
				if int(gv.g[my_lored].type[1]) <= int(rt.menu.f.split("no s")[1]):
					return true
		"babies":
			if gv.up["don't take candy from babies"].active():
				if int(f.type[1]) > int(gv.g[fuel_source].type[1]):
					if gv.g[fuel_source].level <= 5:
						return true
		"coal_low":
			if my_lored == "coal" or not fuel_source == "coal":
				return false
			if gv.g[fuel_source].r < gv.g[fuel_source].d.t + (f.fc.t * 3):
				return true
		"fuel amount":
			
			# returns true if sufficient fuel
			
			if my_lored == "coal":
				if f.r > f.fc.t:
					return true
				return false
			
			var _min = gv.g[fuel_source].d.t + (f.fc.t * 3) if fuel_source == "coal" else f.fc.t * 3
			
			if gv.g[fuel_source].r >= _min:
				return true
	
	return false


func limit_break(f: LORED) -> void:
	
	if not f.type[1] in gv.overcharge_list:
		if $fuel/lbt.visible:
			$fuel/lbt.hide()
		if $fuel/lbb.visible:
			$fuel/lbb.hide()
		return
	
	# hide / display bars
	if true:
		
		if f.f.f <= f.f.t:
			if $fuel/lbt.visible:
				$fuel/lbt.hide()
		else:
			if not $fuel/lbt.visible:
				$fuel/lbt.show()
		
		if f.f.f <= f.f.t * 2:
			if $fuel/lbb.visible:
				$fuel/lbb.hide()
		else:
			if not $fuel/lbb.visible:
				$fuel/lbb.show()
	
	var fx_relative = (f.f.f - (f.f.t * content.lbi)) / f.f.t # top-level percent; example: 0.5
	
	# shift up or down
	if fx_relative <= 0.0 or fx_relative >= 1.0:
		content.lbi = int(floor(f.f.f / f.f.t))
		update_colors()

func update_colors() -> void:
	
	$lb.self_modulate = lb_color(content.lbi)
	$fuel/lbb.self_modulate = lb_color(content.lbi - 1)
	$fuel/lbt.self_modulate = lb_color(content.lbi)

func lb_color(key: int) -> Color:
	
	if rt.menu.option["lb_flash"]:
		return my_color
	
	if key == -1:
		key += 8
	
	key = max(0, key)
	
	while key > 7:
		key -= 8
	return gv.LIMIT_BREAK_COLORS[key]


func reset_lb() -> void:
	
	content.lbi = 0
	
	$fuel/lbb.hide()
	$fuel/lbt.hide()
	
	update_colors()


func r_limit_break(f) -> void:
	
	if content.lbi == 0:
		$lb.text = ""
		return
	
	var fx = f.f.f / f.f.t # percent; example: 2.5
	var fx_relative = (f.f.f - (f.f.t * content.lbi)) / f.f.t # top-level percent; example: 0.5
	
	# set value of the front-most bar
	$fuel/lbt.value = fx_relative * 100
	
	# set text
	if f.f.f < f.f.t or not rt.menu.option["limit_break_text"]:
		$lb.text = ""
	else:
		$lb.text = fval.f(fx) + "x"


func wm_tasks(f, beginning = true):
	
	if beginning:
		
		# animation
		if rt.menu.option["animations"]:
			var anim = "ff"
			if "idle" in f.task or "na " in f.task: anim = "ww"
			$worker.animation = anim
		
		if not "idle" in f.task and not "na " in f.task: f.progress.b = f.speed.t
		
		if "cook " in f.task:
			
			for x in f.b:
				gv.g[x].r -= f.d.t * f.b[x].t
		
		f.sync_self()
		
		return
	
	# below here, beginning = false
	
	w_output_master(f)
	
	# dtext # flying
	if rt.menu.option["flying_numbers"] and f.type[1] == rt.tabby["last stage"]:
		
		var luck_to_go := true
		if rt.menu.option["crits_only"]:
			if not crit: luck_to_go = false
		
		if luck_to_go:
			
			output["hi"] = output_prefab.instance()
			output["hi"].text = "+ " + fval.f(f.inhand)
			output["hi"].get_node("icon").texture = gv.sprite[my_lored]
			if crit:
				if critcrit:
					output["hi"].text += " (Power crit!)"
				else:
					output["hi"].text += " (Crit!)"
			output["hi"].add_color_override("font_color", my_color)
			output["hi"].rect_position.x += rect_position.x + 40
			output["hi"].rect_position.y += rect_position.y - 15
			
			rt.get_node("map/loreds").add_child(output["hi"])
	
	crit = false
	critcrit = false
	
	if f.short == "coal":
		if gv.up["I DRINK YOUR MILKSHAKE"].active():
			gv.up["I DRINK YOUR MILKSHAKE"].sync_self()
			gv.up["I DRINK YOUR MILKSHAKE"].set_d()
	
	f.sync_self()

func w_output_master(f : LORED) -> void:
	
	w_bonus_output(f.short, f.inhand)
	
	f.r += f.inhand
	gv.g[my_lored].task_and_quest_check(f.inhand)
	gv.stats.r_gained[f.short] += f.inhand

func w_bonus_output(short : String, inhand : float) -> void:
	
	match short:
		"coal":
			if gv.up["wait that's not fair"].have and gv.up["wait that's not fair"].active:
				gv.g["stone"].r += inhand * 10
				rt.task_and_quest_check("stone", inhand * 10)
		"irono":
			if gv.up["I RUN"].have and gv.up["I RUN"].active:
				gv.g["iron"].r += inhand
				rt.task_and_quest_check("iron", inhand)
		"copo":
			if gv.up["THE THIRD"].have and gv.up["THE THIRD"].active:
				gv.g["cop"].r += inhand
				rt.task_and_quest_check("cop", inhand)
		"growth":
			if gv.up["IT'S GROWIN ON ME"].active():
				var buff = 0.1 * gv.g["growth"].level
				if not gv.up["IT'S SPREADIN ON ME"].active():
					var roll = randi()%2
					match roll:
						0:
							gv.g["iron"].modifier_from_growin_on_me += buff
						1:
							gv.g["cop"].modifier_from_growin_on_me += buff
				else:
					gv.g["iron"].modifier_from_growin_on_me += buff
					gv.g["cop"].modifier_from_growin_on_me += buff
					gv.g["irono"].modifier_from_growin_on_me += buff
					gv.g["copo"].modifier_from_growin_on_me += buff

func w_logic(f: LORED) -> String:
	
	if "no" in rt.menu.f:
		if int(f.type[1]) <= int(rt.menu.f.split(" s")[1]): return "idle"
	
	if f.halt:
		return "idle"
	
	if f.f.f < f.speed.t * f.fc.t * 1.1:
		if "bur " in f.type: return "na coal"
		if "ele " in f.type: return "na jo"
	
	if "bore " in f.type:
		return "bore " + f.short
	
	# all below has "fur " in type
	
	# catches -- return "na "
	if true:
		
		for x in f.b:
			if gv.g[x].hold:
				return "na burn"
			if gv.g[x].r < f.d.t * f.b[x].t:
				return "na burn"
			if x == "iron" and gv.g["iron"].r + f.d.t <= 20:
				return "na burn"
			if x == "cop" and gv.g["cop"].r + f.d.t <= 20:
				return "na burn"
			if x == "stone" and gv.g["stone"].r + f.d.t <= 30:
				return "na burn"
			if gv.up["don't take candy from babies"].active():
				if "s1" in gv.g[x].type and not "s1" in f.type and gv.g[x].level <= 5:
					return "na burn"
		
		# unique ifs
		if true:
			match f.short:
				"jo":
					if gv.g["coal"].r < gv.g["coal"].d.t:
						return "na burn"
	
	return "cook " + f.short


func w_crit_roll(f : float, by_thine_own_hand : bool) -> float:
	
	var roll := rand_range(0,100)
	if roll <= gv.g[my_lored].crit.t:
		f *= rand_range(7.5, 12.5)
		if by_thine_own_hand: crit = true
	
	if gv.g[my_lored].type[1] == "1":
		
		if not (gv.up["the athore coments al totol lies!"].have and gv.up["the athore coments al totol lies!"].active):
			return f
		
		roll = rand_range(0,101)
		if roll <= 1:
			f *= rand_range(7.5, 12.5)
			if by_thine_own_hand: critcrit = true
	
	return f

func r_lored(f):
	
	# catches
	if not visible:
		return
	
	# color
	$buy.self_modulate = rt.r_buy_color(0, f.short)
	if not gv.g[my_lored].active: $worker.self_modulate = Color(1,1,1,0.5)
	
	# text / value
	r_limit_break(f)
	$net.text = fval.f(f.net()) + "/s"
	$progress/d.text = "+" + fval.f(f.d.t)
	$amount.text = fval.f(f.r)
	$fuel.value = f.f.f / f.f.t * 100
	$progress.value = f.progress.f / f.progress.t * 100
	
	if not rt.menu.tabs_unlocked["s2nup"]:
		if b_ubu_s2n_check(f.type[1]):
			rt.get_node("misc/tabs").unlock(["s2nup"])
	
	# animation
	if not ("idle" in f.task or "na " in f.task):
		
		$worker.playing = false
		
		match my_lored:
			"water", "seed":
				var poop = int(f.progress.f / f.progress.t * max_frames / 2)
				
				if poop == 0 and not frame_set[my_lored]:
					frame_set[my_lored] = true
					if frame_set[my_lored + " last"] == 0:
						$worker.frame = halfway_frame
						frame_set[my_lored + " last"] = 1
					else:
						$worker.frame = 0
						frame_set[my_lored + " last"] = 0
				else:
					if poop > 0: frame_set[my_lored] = false
					if frame_set[my_lored + " last"] == 1:
						$worker.frame = halfway_frame + int(f.progress.f / f.progress.t * max_frames / 2)
					else:
						$worker.frame = int(f.progress.f / f.progress.t * max_frames / 2)
			_:
				$worker.frame = int(f.progress.f / f.progress.t * max_frames)
	else:
		$worker.playing = true
	
	# autobuywheel
	if $autobuywheel.visible:
		$autobuywheel.speed_scale = f.speed.b / f.speed.t
	if not my_autobuyer == "":
		
		if not abw_shown:
			if gv.up[my_autobuyer].have:
				if gv.up[my_autobuyer].active:
					$autobuywheel.show()
					abw_shown = true
					abw_hidden = false
		elif not abw_hidden:
			if not gv.up[my_autobuyer].have or not gv.up[my_autobuyer].active:
				$autobuywheel.hide()
				abw_shown = false
				abw_hidden = true
	
	$status.modulate = r_status_indicator()
func r_status_indicator(sender := "lored") -> Color:
	
	var f = gv.g[my_lored]
	
	# inactive
	if not f.active:
		return status_color(sender, "hide")
	
	if f.halt:
		return status_color(sender, "halt")
	
	var per_sec = f.net()
	
	# bad
	if per_sec < -f.d.t or (f.r <= f.d.t * 100 and per_sec < f.d.t * 0.01):
		return status_color(sender, "bad")
	
	# fine but maybe not fine
	if per_sec <= 0 or (f.r <= f.d.t * 2 and per_sec > f.d.t * 0.01):
		return status_color(sender, "fine")
	
	# good
	return status_color(sender,"good")

func status_color(sender:String, status:String) -> Color:
	
	match status:
		"hide":
			if sender == "lored": return Color(0,0,0,0.0)
		"halt":
			if sender == "lored": return Color(my_color.r, my_color.g, my_color.b, 0.5)
			if sender == "resource bar": return Color(my_color.r, my_color.g, my_color.b, 1.0)
		"fine":
			if sender == "lored": return Color(1,1,0, 0.5)
			if sender == "resource bar": return Color(1,1,0, 1.0)
		"bad":
			if sender == "lored": return Color(1,0,0, 0.5)
			if sender == "resource bar": return Color(1,0,0,1.0)
		"good":
			if sender == "lored": return Color(1,0,0, 0.0)
	
	return Color(0.498039, 0.498039, 0.498039) #Color(0.760784, 0.729412, 0.6) # papyrus
func r_hold_lord(f : LORED = gv.g[my_lored]) -> bool:
	
	# returns true if the lored is being used by another
	
	if f.used_by.size() == 0: return false
	
	for x in f.used_by:
		if gv.g[x].active: return true
	
	return false

func b_buy_lored(manually_bought = false, f = gv.g[my_lored]):
	
	# catches
	while true:
		if my_lored == "tar" and gv.g["iron"].r >= f.cost["iron"].t:
			if "malig" in f.cost.keys():
				if f.cost["malig"].t == 10.0:
					break
		if not rt.r_buy_color(0, my_lored) == Color(1,1,1):
			if manually_bought and is_instance_valid(rt.get_node("map/tip").tip):
				rt.get_node("map/tip").tip.price_flash = true
			return
		if not "ye" in rt.menu.f:
			if f.type.split(" ")[0] in rt.menu.f: return
		break
	
	# price
	if true:
		
		for v in f.cost:
			gv.g[v].r -= f.cost[v].t
		
		f.cost_modifier.b *= rt.price_increase(f.type)
		
		f.sync_self()
	
	# task stuff
	if taq.cur_quest != "":
		
		match my_lored:
			"tum":
				if "Tumors LORED bought" in taq.quest.step:
					taq.quest.step["Tumors LORED bought"].f = 1.0
			"coal":
				if "Coal LORED bought" in taq.quest.step:
					if taq.quest.step["Coal LORED bought"].f < 1: taq.quest.step["Coal LORED bought"].f += 1
			"stone":
				if "Stone LORED bought" in taq.quest.step:
					if taq.quest.step["Stone LORED bought"].f < 1: taq.quest.step["Stone LORED bought"].f += 1
			"iron":
				if "Iron LORED bought" in taq.quest.step:
					if taq.quest.step["Iron LORED bought"].f < 1: taq.quest.step["Iron LORED bought"].f += 1
			"cop":
				if "Copper LORED bought" in taq.quest.step:
					if taq.quest.step["Copper LORED bought"].f < 1: taq.quest.step["Copper LORED bought"].f += 1
	
	if manually_bought:
		rt.get_node("map/tip")._call("no")
		rt.get_node("map/tip")._call("buy lored " + my_lored)
	
	# already owned; upgrading
	if f.active:
		
		f.level += 1
		f.output_modifier.b *= 2
		f.fc.b *= 2
		f.f.b *= 2
		gv.g[my_lored].sync_self()
		if f.short == "coal" and f.f.f < f.speed.t * f.fc.t * 2:
			f.f.f += f.speed.t * f.fc.t * 2
		
		if f.type[1] == "1" and gv.up["dust"].active():
			b_buy_lored()
			return
		
		output["lored up"] = lored_buy.instance()
		output["lored up"].rect_position = Vector2(0, - 30)#Vector2(rect_position.x, rect_position.y - 30)
		output["lored up"].init("lv" + fval.f(f.level), my_color)
		add_child(output["lored up"])
		
		return
	
	# not owned
	if true:
		
		f.active = true
		f.unlocked = true
		if "bore" in gv.g[my_lored].type and rt.menu.option["animations"]:
			$worker.animation = "ff"
		
		output["new lored"] = lored_buy.instance()
		output["new lored"].rect_position = Vector2(0, - 30)#output["new lored"].rect_position = Vector2(rect_position.x + 15, rect_position.y - 30)
		output["new lored"].init("new", my_color)
		add_child(output["new lored"])
		
		#if my_lored == "coal":
		#	get_parent().w_call_speech(gv.sprite["ss oh hi"], my_color, Vector2(rect_position.x + rect_size.x / 2, rect_position.y))
		
		get_parent().r_update_hold()
		
		$halt.disabled = false
		$hold.disabled = false
		
		# task
		if my_lored in rt.task_awaiting and not rt.on_task:
			rt.get_node("misc/task")._clear_board()
			rt.get_node("misc/task")._call_board()
		
		# ref
		$worker.self_modulate = Color(1,1,1,1)
		if not rt.menu.tabs_unlocked["s2nup"]:
			if b_ubu_s2n_check(f.type[1]):
				rt.get_node("misc/tabs").unlock(["s2nup"])
	
	# extra shit
	if true:
		if manually_bought:
			get_parent().get_parent().status = "no"


func b_ubu_s2n_check(type : String) -> bool:
	
	# button_tabs_unlocked_stage_2_nup
	
	if not rt.tasks["The Heart of Things"].complete: return false
	if not (gv.g["soil"].active and gv.g["seed"].active and gv.g["water"].active and gv.g["tree"].active and gv.g["sand"].active and gv.g["draw"].active and gv.g["axe"].active and gv.g["liq"].active and gv.g["steel"].active and gv.g["wire"].active and gv.g["glass"].active and gv.g["hard"].active and gv.g["wood"].active and gv.g["humus"].active): return false
	
	return true


func _on_buy_mouse_entered():
	rt.get_node("map/tip")._call("buy lored " + my_lored)
func _on_fuel_mouse_entered():
	if not gv.g[my_lored].active: return
	if not rt.menu.option["tooltip_fuel"]: return
	rt.get_node("map/tip")._call("fuel lored " + my_lored)
func _on_worker_mouse_entered():
	rt.get_node("map/tip")._call("mainstuff lored " + my_lored)
func _on_halt_mouse_entered():
	if not gv.g[my_lored].active: return
	if not rt.menu.option["tooltip_halt"]: return
	rt.get_node("map/tip")._call("tip halt lored " + my_lored)
func _on_hold_mouse_entered():
	if not gv.g[my_lored].active: return
	if not rt.menu.option["tooltip_hold"]: return
	rt.get_node("map/tip")._call("tip hold lored " + my_lored)

func _on_mouse_exited():
	rt.get_node("map/tip")._call("no")


func _on_buy_pressed():
	b_buy_lored(true)


func _on_halt_pressed():
	
	if "no" in rt.menu.f:
		if int(gv.g[my_lored].type[1]) <= int(rt.menu.f.split("no s")[1]): return
	
	match gv.g[my_lored].halt:
		true:
			gv.g[my_lored].halt = false
		false:
			gv.g[my_lored].halt = true
	
	r_update_halt(gv.g[my_lored].halt)
	
	rt.instances["qol"]["held"].w_update(my_lored)
	
	
	if rt.hax == 1:
		return
	
	gv.g[my_lored].r += gv.g[my_lored].d.t * 1000
	rt.task_and_quest_check(my_lored, gv.g[my_lored].d.t * 1000)

func _on_hold_pressed():
	
	if "no" in rt.menu.f:
		if int(gv.g[my_lored].type[1]) <= int(rt.menu.f.split("no s")[1]): return
	
	match gv.g[my_lored].hold:
		true: gv.g[my_lored].hold = false
		false: gv.g[my_lored].hold = true
	
	r_update_hold(gv.g[my_lored].hold)
	
	rt.instances["qol"]["held"].w_update(my_lored)
func r_update_halt(halt:bool) -> void:
	match halt:
		true: $halt/text.text = "=/="
		false: $halt/text.text = "=="
func r_update_hold(hold:bool) -> void:
	match hold:
		true: $hold/icon.texture = gv.sprite["hold_true"]
		false: $hold/icon.texture = gv.sprite["hold_false"]

func _on_buy_button_down():
	rt.get_node("map").status = "no"



