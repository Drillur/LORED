extends Panel

var fps := 0.0
var fps25 := 0.0
var fps1 := 1.0
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

var sync_fps := 0.0
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
	
	if sync_fps > 0:
		sync_fps -= delta
	
	# ref
	if true:
		
		r_lored_25(gv.g[my_lored])
		r_lored_1(gv.g[my_lored])
		
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
	
	if "no" in gv.menu.f:
		if int(gv.up[my_autobuyer].type[1]) <= int(gv.menu.f.split("no s")[1]):
			return
	
	if not gv.up[my_autobuyer].active():
		return
	
	if autobuy():
		b_buy_lored()

func autobuy() -> bool:
	
	# active
	if not gv.g[my_lored].active:
		return true
	
#	if autobuy_too_much_malig():
#		return false
	
	# max fuel
	if true:
		
		var max_fuel = Big.new(gv.g[my_lored].f.t).multiply(0.1)
		
		if gv.g[my_lored].f.f.isLessThan(max_fuel):
			return false
	
	if autobuy_upgrade_check():
		return true
	
	# if ingredient LORED per_sec < per_sec, don't buy
	for x in gv.g[my_lored].b:
		
		var consm = Big.new(gv.g[my_lored].d.t).divide(gv.g[my_lored].speed.t)
		consm.multiply(60).multiply(gv.g[my_lored].b[x].t)
		
		if gv.g[x].halt:
			if Big.new(gv.g[x].net(true)[0]).minus(Big.new(consm).multiply(2)).isLessThan(0):
				if not autobuy_afford_ingredient_lored_check(x):
					return false
		else:
			#note changed recently
			var net = gv.g[x].net()
			if net[0].isLargerThanOrEqualTo(net[1]):
				net = Big.new(net[0]).minus(net[1])
				if consm.isLargerThan(net):
					if not autobuy_afford_ingredient_lored_check(x):
						return false
	
	if gv.g[my_lored].key_lored:
		return true
	
	var net = gv.g[my_lored].net(false, true)
	
	# if per_sec > 0, don't buy
	if not gv.g[my_lored].type[1] in gv.overcharge_list:
		if net[0].isLargerThanOrEqualTo(net[1]):
			# if gain/s >= drain/s: net is positive
			return false
	
	return true
func autobuy_afford_ingredient_lored_check(_lored: String) -> bool:
	for x in gv.g[_lored].cost:
		if gv.g[x].r.isLessThan(gv.g[_lored].cost[x].t):
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

func autobuy_too_much_malig() -> bool:
	
	if "s2" in gv.g[my_lored].type:
		return false
	
	if gv.g["malig"].r.isLessThan(gv.up["ROUTINE"].cost["malig"].t):
		return false
	
	return true


func wm_lored(f: LORED) -> void:
	
	if not f.active:
		return
	
	# if base task duration == 1
	if f.progress.b.isEqualTo(1):
		
		f.inhand = Big.new(f.d.t)
		f.task = w_logic(f)
		wm_tasks(f)
	
	fuel(f)
	
	f.r.plus(f.witch(true))
	
	if f.progress.b.isEqualTo(1):
		softlock_check()
		return
	
	if f.f.f.isLargerThanOrEqualTo(f.fc.t):
		f.progress.f.plus(1)
	else:
		f.progress.f.plus(0.05)
	
	if f.progress.f.isLessThan(f.progress.t):
		return
	
	f.progress.f = Big.new(0.0)
	f.progress.b = Big.new(1.0)
	if f.crit.t.isLargerThan(0):
		f.inhand.multiply(w_crit_roll(true))
	wm_tasks(f, false)

func fuel(f: LORED) -> void:
	
	# catches
	if "no" in gv.menu.f:
		if int(gv.g[my_lored].type[1]) <= int(gv.menu.f.split("no s")[1]):
			return
	
	# f     = lored
	# f.f   = fuel variable
	# f.f.f = fuel amount
	# f.f.t = max_fuel
	
	var fuel_source = "coal" if "bur " in f.type else "jo"
	var max_fuel = Big.new(f.f.t).multiply(gv.overcharge) if f.type[1] in gv.overcharge_list else Big.new(f.f.t)
	
	# drain fuel
	var fuel_drain = Big.new(f.fc.t)
	var over_ft = Big.new(fuel_drain).multiply(2)
	var at_max_a = Big.new(f.f.t).multiply(gv.overcharge)
	var at_max_b = Big.new(fuel_drain).multiply(2)
	var fuel_fill = fuel_net(
		fuel_source,
		f.progress.b, # progress
		fuel_drain, # fc
		f.f.f.isLargerThan(Big.new(f.f.t).multiply(0.999).minus(over_ft)), # over_ft
		f.type[1] in gv.overcharge_list, # in_lb
		f.f.f.isLargerThanOrEqualTo(Big.new(at_max_a).minus(at_max_b)), # at_max
		fuel_call_vars(f, "babies"), # babies
		fuel_call_vars(f, "coal_low"), # coal_low
		not fuel_call_vars(f, "fuel amount"), # insufficient_fuel
		f.f.f,
		max_fuel
	)
	
	if fuel_fill[1] == "plus":
		f.f.f.plus(fuel_fill[0].multiply(gv.hax_pow))
	else:
		f.f.f.minus(fuel_fill[0])
	
	f.f.sync()
	if f.f.f.isLargerThan(max_fuel):
		f.f.f = Big.new(max_fuel)
	
	limit_break(f)

func fuel_net(
	fuel_source: String,
	progress: Big,
	fc: Big, # fuel_cost
	over_ft: bool, # over_fuel_total
	in_lb: bool, # in gv.overcharge_list
	at_max: bool,
	babies: bool, # see fuel_call_vars - "babies"
	coal_low: bool, # keep coal above certain amount
	insufficient_fuel: bool,
	current: Big,
	max_fuel ) -> Array:
	
	# determine whether fuel goes up or down
	
	
	# drain
	if true:
		
		if not progress.isEqualTo(1): # active
			if insufficient_fuel:
				return [Big.new(fc), "minus"]
		else:
			if insufficient_fuel:
				return [Big.new(0), "plus"]
		
		if babies: # target is an s1 baby.
			if not progress.isEqualTo(1):
				# already active
				return [Big.new(fc), "minus"]
			else:
				# idle
				return [Big.new(0), "plus"]
		
		if over_ft:
			
			if progress.isEqualTo(1):
				return [Big.new(fc), "minus"]
			if not in_lb:
				return [Big.new(fc), "minus"]
	
	if at_max:
		subtract_fuel(fuel_source, fc)
		return [Big.new(0), "plus"]
	
	# gain
	subtract_fuel(fuel_source, Big.new(fc).multiply(2).multiply(gv.g[my_lored].less_from_full(current, max_fuel)))
	if progress.isEqualTo(1):
		return [Big.new(fc).multiply(2).multiply(gv.g[my_lored].less_from_full(current, max_fuel)), "plus"]
	return [Big.new(fc).multiply(gv.g[my_lored].less_from_full(current, max_fuel)), "plus"]

func subtract_fuel(fuel_source: String, amount: Big) -> void:
	
	gv.g[fuel_source].r.minus(amount)
	
	# milkshake
	if true:
		
		if fuel_source != "coal":
			return
		if not gv.up["I DRINK YOUR MILKSHAKE"].active():
			return
		
		gv.up["I DRINK YOUR MILKSHAKE"].set_d.b.plus(0.0001)

func fuel_call_vars(f, type: String) -> bool:
	
	var fuel_source = "coal" if "bur " in f.type else "jo"
	
	match type:
		"babies":
			if gv.up["don't take candy from babies"].active():
				if int(f.type[1]) > int(gv.g[fuel_source].type[1]):
					if gv.g[fuel_source].level <= 5:
						return true
		"coal_low":
			if my_lored == "coal" or not fuel_source == "coal":
				return false
			if gv.g[fuel_source].r.isLessThan(Big.new(gv.g[fuel_source].d.t).plus(Big.new(f.fc.t).multiply(3))):
				return true
		"fuel amount":
			
			# returns true if sufficient fuel
			
			if my_lored == "coal":
				if f.r.isLargerThan(f.fc.t):
					return true
				return false
			
			var _min = Big.new(gv.g[fuel_source].d.t).plus(Big.new(f.fc.t).multiply(3)) if fuel_source == "coal" else Big.new(f.fc.t).multiply(3)
			
			if gv.g[fuel_source].r.isLargerThanOrEqualTo(_min):
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
		
		if f.f.f.isLessThanOrEqualTo(f.f.t):
			if $fuel/lbt.visible:
				$fuel/lbt.hide()
		else:
			if not $fuel/lbt.visible:
				$fuel/lbt.show()
		
		if f.f.f.isLessThanOrEqualTo(Big.new(f.f.t).multiply(2)):
			if $fuel/lbb.visible:
				$fuel/lbb.hide()
		else:
			if not $fuel/lbb.visible:
				$fuel/lbb.show()
	
	var fx_over = Big.new(f.f.f).minus(Big.new(f.f.t).multiply(content.lbi))
	var fx_relative = Big.new(fx_over).divide(f.f.t).toFloat() # top-level percent; example: 0.5
	
	# shift up or down
	if fx_relative <= 0.0 or fx_relative >= 1.0:
		content.lbi = int(Big.new(f.f.f).divide(f.f.t).roundDown().toFloat())

func update_lb_colors() -> void:
	
	$lb.self_modulate = lb_color(content.lbi)
	$fuel/lbb.self_modulate = lb_color(content.lbi - 1)
	$fuel/lbt.self_modulate = lb_color(content.lbi)

func lb_color(key: int) -> Color:
	
	if gv.menu.option["lb_flash"]:
		return my_color
	
	if key == -1:
		key += 8
	
	key = max(0, key)
	
#	while key > 7:
#		key -= 8
	key = key % 8
	return gv.LIMIT_BREAK_COLORS[key]


func reset_lb() -> void:
	
	content.lbi = 0
	
	$fuel/lbb.hide()
	$fuel/lbt.hide()


func r_limit_break(f) -> void:
	#return
	if content.lbi == 0:
		$lb.text = ""
		return
	
	var fx = Big.new(f.f.f).divide(f.f.t).toFloat() # percent; example: 2.5
	var fx_over = Big.new(f.f.f).minus(Big.new(f.f.t).multiply(content.lbi))
	var fx_relative = fx_over.divide(f.f.t).toFloat() # top-level percent; example: 0.5
	
	# set value of the front-most bar
	$fuel/lbt.value = fx_relative * 100
	
	# set text
	if f.f.f.isLessThan(f.f.t) or not gv.menu.option["limit_break_text"]:
		$lb.text = ""
	else:
		$lb.text = fval.f(fx) + "x"
	
	update_lb_colors()


func wm_tasks(f, beginning = true):
	
	if beginning:
		
		# animation
		if gv.menu.option["animations"]:
			var anim = "ff"
			if "idle" in f.task or "na " in f.task: anim = "ww"
			$worker.animation = anim
		
		if not "idle" in f.task and not "na " in f.task:
			f.progress.b = Big.new(f.speed.t)
			f.sync()
			sync_fps = 0.5
		
		if "cook " in f.task:
			
			for x in f.b:
				var less = Big.new(f.d.t).multiply(f.b[x].t)
				gv.g[x].r.minus(less)
		
		if sync_fps <= 0:
			f.sync()
			sync_fps = 0.5
		
		return
	
	# below here, beginning = false
	
	w_output_master(f)
	
	# dtext # flying
	if gv.menu.option["flying_numbers"] and f.type[1] == rt.tabby["last stage"]:
		
		var luck_to_go := true
		if gv.menu.option["crits_only"]:
			if not crit: luck_to_go = false
		
		if luck_to_go:
			
			output["hi"] = output_prefab.instance()
			output["hi"].text = "+ " + f.inhand.toString()
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
			gv.up["I DRINK YOUR MILKSHAKE"].sync()
	
	f.sync()

func w_output_master(f : LORED) -> void:
	
	w_bonus_output(f.short, f.inhand)
	
	f.r.plus(f.inhand)
	gv.g[my_lored].task_and_quest_check(f.inhand)
	gv.stats.r_gained[f.short].plus(f.inhand)

func w_bonus_output(short : String, inhand : Big) -> void:
	
	match short:
		"coal":
			if gv.up["wait that's not fair"].active():
				var bla = Big.new(inhand).multiply(10)
				gv.g["stone"].r.plus(bla)
				gv.g["stone"].task_and_quest_check(bla)
		"irono":
			if gv.up["I RUN"].active():
				gv.g["iron"].r.plus(inhand)
				gv.g["iron"].task_and_quest_check(inhand)
		"copo":
			if gv.up["THE THIRD"].active():
				gv.g["cop"].r.plus(inhand)
				gv.g["cop"].task_and_quest_check(inhand)
		"growth":
			if gv.up["IT'S GROWIN ON ME"].active():
				var buff = 0.1 * gv.g["growth"].level
				if not gv.up["IT'S SPREADIN ON ME"].active():
					var roll = randi()%2
					match roll:
						0:
							gv.g["iron"].modifier_from_growin_on_me.plus(buff)
						1:
							gv.g["cop"].modifier_from_growin_on_me.plus(buff)
				else:
					gv.g["iron"].modifier_from_growin_on_me.plus(buff)
					gv.g["cop"].modifier_from_growin_on_me.plus(buff)
					gv.g["irono"].modifier_from_growin_on_me.plus(buff)
					gv.g["copo"].modifier_from_growin_on_me.plus(buff)

func w_logic(f: LORED) -> String:
	
	if "no" in gv.menu.f:
		if int(f.type[1]) <= int(gv.menu.f.split(" s")[1]): return "idle"
	
	if f.halt:
		return "idle"
	
	if f.f.f.isLessThan(Big.new(f.speed.t).multiply(f.fc.t).multiply(1.1)):
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
			if gv.g[x].r.isLessThan(Big.new(f.d.t).multiply(f.b[x].t)):
				return "na burn"
			if x == "iron" and Big.new(gv.g["iron"].r).plus(f.d.t).isLessThanOrEqualTo(20):
				return "na burn"
			if x == "cop" and Big.new(gv.g["cop"].r).plus(f.d.t).isLessThanOrEqualTo(20):
				return "na burn"
			if x == "stone" and Big.new(gv.g["stone"].r).plus(f.d.t).isLessThanOrEqualTo(30):
				return "na burn"
			if gv.up["don't take candy from babies"].active():
				if "s1" in gv.g[x].type and not "s1" in f.type and gv.g[x].level <= 5:
					return "na burn"
		
		# unique ifs
		if true:
			match f.short:
				"jo":
					if gv.g["coal"].r.isLessThan(gv.g["coal"].d.t):
						return "na burn"
	
	return "cook " + f.short


func w_crit_roll(by_thine_own_hand : bool) -> Big:
	
	var f := Big.new(1)
	
	var roll := Big.new(rand_range(0,100))
	if roll.isLessThanOrEqualTo(gv.g[my_lored].crit.t):
		f.multiply(rand_range(7.5, 12.5))
		if by_thine_own_hand: crit = true
	
	if gv.g[my_lored].type[1] == "1":
		
		if not gv.up["the athore coments al totol lies!"].active():
			return f
		
		roll = Big.new(rand_range(0,101))
		if roll.isLessThanOrEqualTo(1):
			f.multiply(rand_range(7.5, 12.5))
			if by_thine_own_hand: critcrit = true
	
	return f


func softlock_check():
	
	# softlock checks done out of "ye" can be done above here
	
	if not "ye" in gv.menu.f:
		return
	
	softlock_wood_cycle()
	softlock_no_seeds()

func softlock_wood_cycle():
	
	if my_lored != "axe":
		return
	
	var axe_wood_hard = ["axe", "wood", "hard"]
	
	for x in axe_wood_hard:
		
		if not gv.g[x].progress.f.isEqualTo(0):
			return
		if gv.g[x].halt:
			return
		
		if gv.g["axe"].r.isLargerThan(Big.new(gv.g["wood"].d.t).multiply(gv.g["wood"].b["axe"].t)):
			return
		if gv.g["wood"].r.isLargerThan(Big.new(gv.g["hard"].d.t).multiply(gv.g["hard"].b["wood"].t)):
			return
		if gv.g["hard"].r.isLargerThan(Big.new(gv.g["axe"].d.t).multiply(gv.g["axe"].b["hard"].t)):
			return
	
	print("Axes, Wood, and Hardwood dropped low enough that none of them could take from each other, so you've been given free resources.")
	
	for x in axe_wood_hard:
		gv.g[x].r.plus(gv.g[x].d.t)

func softlock_no_seeds():
	
	if my_lored != "tree":
		return
	
	if gv.g["seed"].active:
		return
	if gv.g["tree"].r.isLargerThanOrEqualTo(2):
		return
	if gv.g["seed"].r.isLargerThanOrEqualTo(Big.new(gv.g["tree"].d.t).multiply(gv.g["tree"].b["seed"].t)):
		return
	
	print("You didn't have enough Seeds to produce any Trees to be able to afford the Seed LORED, so you've been given free Trees.")
	
	gv.g["tree"].r.plus(2)


func r_lored(f):
	
	# catches
	if not visible:
		return
	
	# text / value
	$amount.text = f.r.toString()
	$fuel.value = Big.new(f.f.f).divide(f.f.t).toFloat() * 100
	$progress.value = Big.new(f.progress.f).divide(f.progress.t).toFloat() * 100
	
	# animation
	if not ("idle" in f.task or "na " in f.task):
		
		$worker.playing = false
		
		match my_lored:
			
			"water", "seed":
				
				var frame = Big.new(f.progress.f).divide(f.progress.t).toFloat()
				frame *= max_frames
				frame /= 2
				frame = int(frame)
				
				if frame == 0 and not frame_set[my_lored]:
					
					frame_set[my_lored] = true
					
					if frame_set[my_lored + " last"] == 0:
						$worker.frame = halfway_frame
						frame_set[my_lored + " last"] = 1
					else:
						$worker.frame = 0
						frame_set[my_lored + " last"] = 0
				
				else:
					
					if frame > 0:
						frame_set[my_lored] = false
					
					$worker.frame = int(frame)
					if frame_set[my_lored + " last"] == 1:
						$worker.frame += halfway_frame
			
			_:
				$worker.frame = int(Big.new(f.progress.f).divide(f.progress.t).toFloat() * max_frames)
	else:
		$worker.playing = true
	
func r_status_indicator(net, sender := "lored") -> Color:
	
	var f = gv.g[my_lored]
	
	# inactive
	if not f.active:
		return status_color(sender, "hide")
	
	if f.halt:
		return status_color(sender, "halt")
	
	# bad
	if true:
		
		if net[1].isLargerThan(Big.new(net[0]).multiply(2)):
			return status_color(sender, "bad")
		
		if net[1].isLargerThan(net[0]):
			if f.r.isLessThanOrEqualTo(Big.new(f.d.t).multiply(100)) and Big.new(net[1]).minus(net[0]).isLessThan(Big.new(f.d.t).multiply(0.01)):
				return status_color(sender, "bad")
	
	# possibly fine
	if true:
		
		if net[1].isLargerThan(net[0]):
			return status_color(sender, "fine")
		
		if f.r.isLessThanOrEqualTo(Big.new(f.d.t).multiply(2)) and Big.new(net[0]).minus(net[1]).isLessThan(Big.new(f.d.t).multiply(0.01)):
			return status_color(sender, "fine")
	
	# good
	return status_color(sender,"good")
func r_lored_25(f):
	
	# catches
	if true:
		
		fps25 += get_physics_process_delta_time()
		if fps25 < 0.2:
			return
		fps25 -= 0.2
	
	# color
	$buy.self_modulate = rt.r_buy_color(0, f.short)
	if not gv.g[my_lored].active: $worker.self_modulate = Color(1,1,1,0.5)
	
	# text / value
	r_limit_break(f)
	
	$progress/d.text = "+" + f.d.t.toString()
	
	if not gv.menu.tabs_unlocked["s2nup"]:
		if b_ubu_s2n_check(f.type[1]):
			rt.get_node("misc/tabs").unlock(["s2nup"])
	
	# autobuywheel
	if $autobuywheel.visible:
		$autobuywheel.speed_scale = Big.new(f.speed.b).divide(f.speed.t).toFloat()
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

func r_lored_1(f, allow_catches := true):
	
	if allow_catches:
		
		if fps1 < 1:
			fps1 += get_physics_process_delta_time()
			return
		
		if not f.update_net_text:
			return
		
		fps1 -= 1
	
	f.update_net_text = false
	
	var schlonk = f.net()
	$status.modulate = r_status_indicator(schlonk)
	
	var net = ""
	if schlonk[0].isLargerThanOrEqualTo(schlonk[1]):
		net = Big.new(schlonk[0]).minus(schlonk[1]).toString() + "/s"
	else:
		net = "-" + Big.new(schlonk[1].minus(schlonk[0])).toString() + "/s"
	$net.text = net
	

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

func b_buy_lored(manually_bought = false, f: LORED = gv.g[my_lored]):
	
	# catches
	while true:
		if my_lored == "tar" and gv.g["iron"].r.isLargerThanOrEqualTo(f.cost["iron"].t):
			if "malig" in f.cost.keys():
				if f.cost["malig"].t.isEqualTo(10):
					break
		if not rt.r_buy_color(0, my_lored) == Color(1,1,1):
			if manually_bought and is_instance_valid(rt.get_node("map/tip").tip):
				rt.get_node("map/tip").tip.price_flash = true
			return
		if not "ye" in gv.menu.f:
			if f.type.split(" ")[0] in gv.menu.f: return
		break
	
	# price
	if true:
		
		for v in f.cost:
			gv.g[v].r.minus(f.cost[v].t)
		
		f.cost_modifier.multiply(rt.price_increase(f.type))
		
		f.sync_cost()
	
	# task stuff
	if taq.cur_quest != "":
		
		match my_lored:
			"coal":
				if "Coal LORED bought" in taq.quest.step:
					taq.quest.step["Coal LORED bought"].f = Big.new()
						
			"stone":
				if "Stone LORED bought" in taq.quest.step:
					taq.quest.step["Stone LORED bought"].f = Big.new()
			"iron":
				if "Iron LORED bought" in taq.quest.step:
					taq.quest.step["Iron LORED bought"].f = Big.new()
			"cop":
				if "Copper LORED bought" in taq.quest.step:
					taq.quest.step["Copper LORED bought"].f = Big.new()
	
	if manually_bought:
		rt.get_node("map/tip")._call("no")
		rt.get_node("map/tip")._call("buy lored " + my_lored)
	
	# already owned; upgrading
	if f.active:
		
		f.level += 1
		f.output_modifier.multiply(2)
		f.fc.b.multiply(2)
		f.f.b.multiply(2)
		
		f.sync()
		
		if f.short == "coal" and f.f.f.isLessThan(Big.new(f.speed.t).multiply(f.fc.t).multiply(2)):
			f.f.f.plus(Big.new(f.speed.t).multiply(f.fc.t).multiply(2))
		
		output["lored up"] = lored_buy.instance()
		output["lored up"].rect_position = Vector2(0, - 30)#Vector2(rect_position.x, rect_position.y - 30)
		output["lored up"].init("lv" + fval.f(f.level), my_color)
		add_child(output["lored up"])
		
		r_lored_1(gv.g[my_lored], false)
		for x in gv.g[my_lored].b:
			gv.g[x].update_net_text = true
		
		return
	
	# not owned
	if true:
		
		f.active = true
		f.unlocked = true
		if "bore" in gv.g[my_lored].type and gv.menu.option["animations"]:
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
		if not gv.menu.tabs_unlocked["s2nup"]:
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
	if not gv.menu.option["tooltip_fuel"]: return
	rt.get_node("map/tip")._call("fuel lored " + my_lored)
func _on_worker_mouse_entered():
	rt.get_node("map/tip")._call("mainstuff lored " + my_lored)
func _on_halt_mouse_entered():
	if not gv.g[my_lored].active: return
	if not gv.menu.option["tooltip_halt"]: return
	rt.get_node("map/tip")._call("tip halt lored " + my_lored)
func _on_hold_mouse_entered():
	if not gv.g[my_lored].active: return
	if not gv.menu.option["tooltip_hold"]: return
	rt.get_node("map/tip")._call("tip hold lored " + my_lored)

func _on_mouse_exited():
	rt.get_node("map/tip")._call("no")


func _on_buy_pressed():
	b_buy_lored(true)


func _on_halt_pressed():
	
	if "no" in gv.menu.f:
		if int(gv.g[my_lored].type[1]) <= int(gv.menu.f.split("no s")[1]): return
	
	match gv.g[my_lored].halt:
		true:
			gv.g[my_lored].halt = false
		false:
			gv.g[my_lored].halt = true
	
	if is_instance_valid(rt.get_node("map/tip").tip):
		rt.get_node("map/tip").tip.content["halt"].r_update()
	
	r_update_halt(gv.g[my_lored].halt)
	
	gv.g[my_lored].update_net_text = true
	
	for x in gv.g:
		if my_lored in gv.g[x].used_by:
			gv.g[x].update_net_text = true
	
	if rt.hax == 1:
		return
	
	var haxx = Big.new(gv.g[my_lored].d.t).multiply(1000)
	gv.g[my_lored].r.plus(haxx)
	rt.task_and_quest_check(my_lored, haxx)

func _on_hold_pressed():
	
	if "no" in gv.menu.f:
		if int(gv.g[my_lored].type[1]) <= int(gv.menu.f.split("no s")[1]): return
	
	match gv.g[my_lored].hold:
		true: gv.g[my_lored].hold = false
		false: gv.g[my_lored].hold = true
	
	if is_instance_valid(rt.get_node("map/tip").tip):
		rt.get_node("map/tip").tip.content["hold"].r_update()
	
	r_update_hold(gv.g[my_lored].hold)
	
	gv.g[my_lored].update_net_text = true
	
	for x in gv.g[my_lored].used_by:
		gv.g[x].update_net_text = true
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



