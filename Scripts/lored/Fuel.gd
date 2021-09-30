extends HBoxContainer

var key: String
var fuel_source := "coal"
onready var gn_f = get_node("bar/f")
onready var gn_t = get_node("bar")


func _ready() -> void:
	gn_f.rect_size.x = gn_t.rect_size.x

func init(_key: String) -> void:
	
	key = _key
	
	if "ele" in gv.g[key].type:
		fuel_source = "jo"
	
	if gv.g[key].smart:
		smart_start()
	else:
		start()

func start() -> void:
	
	while gv.g[key].unlocked and gv.g[key].active:
		
		if gv.g[key].working:
			
			gv.g[key].f.f.s(Big.new(gv.g[key].fc.t).m(gv.fps))
		
		if gv.g[fuel_source].is_baby(int(gv.g[key].type[1])):
			break
		
		if gv.g[key].f.f.less(gv.g[key].f.t):
			if sufficient_fuel():
				# example:
				# gain = 10
				# FPS is 1
				# gain *= 1 = 10
				# happens 1x a sec = 10/s
				# ////
				# gain = 10
				# fps is 0.2
				# gain *= 0.2 = 2
				# happens 5x a sec = 10/s
				# ////
				# gain = 10
				# fps is 0.04
				# gain *= 0.04 = 0.4
				# happens 25x a sec = 10/s
				var gain = Big.new(gv.g[key].fc.t).m(2).m(gv.fps)
				gv.g[key].f.f.a(gain)
				gv.r[fuel_source].s(gain)
				milkshake()
		
		gn_f.rect_size.x = min(gv.g[key].f.f.percent(gv.g[key].f.t) * gn_t.rect_size.x, gn_t.rect_size.x)
		
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
	
	start()

func smart_start():
	
	match key:
		"blood", "witch":
			blood_start()

func blood_start():
	
	while gv.g[key].unlocked and gv.g[key].active and gv.g[key].f.f.less(gv.g[key].f.t):
		
		gv.g[key].f.f.a(Big.new(gv.g[key].fc.t).m(gv.fps))
		
		gn_f.rect_size.x =  min(gv.g[key].f.f.percent(gv.g[key].f.t) * gn_t.rect_size.x, gn_t.rect_size.x)
		
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
	
	gn_f.rect_size.x =  min(gv.g[key].f.f.percent(gv.g[key].f.t) * gn_t.rect_size.x, gn_t.rect_size.x)
	
	blood_start()

func hunt_start():
	
	while gv.g[key].unlocked and gv.g[key].active and gv.g[key].working:
		
		gv.g[key].f.f.s(Big.new(gv.g[key].fc.t).m(gv.fps))
		
		gn_f.rect_size.x = min(gv.g[key].f.f.percent(gv.g[key].f.t) * gn_t.rect_size.x, gn_t.rect_size.x)
		
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
	
	hunt_start()

func sufficient_fuel() -> bool:
	
	if key == "coal":
		if gv.r[key].greater(gv.g[key].fc.t):
			return true
		return false
	
	var _min = Big.new(gv.g[key].fc.t).m(3)
	if fuel_source == "coal":
		_min.a(gv.g[fuel_source].d.t)
	
	if gv.r[fuel_source].greater_equal(_min):
		return true
	
	return false

func milkshake() -> void:
	
	if fuel_source != "coal":
		return
	if not gv.up["I DRINK YOUR MILKSHAKE"].active():
		return
	
	gv.up["I DRINK YOUR MILKSHAKE"].effects[0].effect.a.a(0.0001)
