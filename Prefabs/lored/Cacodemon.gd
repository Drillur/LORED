extends MarginContainer


onready var rt = get_node("/root/Root")


const level_flash_colors := {
	0: Color(1, 0.909804, 0, 1.0),
	1: Color(1, 0.909804, 0, 0.75),
	2: Color(1, 0.909804, 0, 0.5),
	3: Color(1, 0.909804, 0, 0.25),
	4: Color(1, 0.909804, 0, 0.125),
	5: Color(0, 0, 0, 0),
}

var src := {
	ft = preload("res://Prefabs/dtext.tscn"),
}
var cont := {}

var fps := {
	"task": FPS.new(0.01, true),
	"xp": FPS.new(0.1),
}

var last_d: Big # used to tell how much leveling up boosted d

var key: int

var gnd := "v/task/d"
var gnProgressBarF := "v/task/f"
var gnProgressBarT := "v/task"
var gnProgressTextF := "v/task/text f"
#var gnProgressTextT := "v/task/text t"
var gnXpBarF := "v/xp/f"
var gnXpBarT := "v/xp"
var gnLevelUp := "level up"


func _ready():
	
	set_physics_process(false)
	
	get_node(gnLevelUp).self_modulate = level_flash_colors[4]
	
	hide()


func setup(_key: int):
	
	key = _key
	
	last_d = gv.cac[key].consumed_spirit_gain(gv.cac[key].d.t)
	
	sync()

func sync():
	
	# called on boot and when Cacodemon levels up
	
	get_node(gnd).text = "+" + gv.cac[key].consumed_spirit_gain(gv.cac[key].d.t).toString()
	#get_node(gnProgressTextT).text = fval.f(gv.cac[key].progress.t)
	
	

func _physics_process(delta: float) -> void:
	
	work()
	
	ref()

func work():
	
	gv.cac[key].work()
	
	gv.cac[key].progress.f += get_physics_process_delta_time() * 100



func ref():
	
	if not rt.get_node(rt.gnLOREDs + "/sc/v/s3").visible:
		return
	
	for x in fps:
		
		if fps[x].f > 0:
			
			fps[x].f -= get_physics_process_delta_time()
			
			continue
		
		if not fps[x].set:
			continue
		
		fps[x].f = fps[x].t
		fps[x].set = fps[x].always_set
		
		match x:
			"task":
				r_task()
			"xp":
				r_xp()

func r_task():
	
	get_node(gnProgressBarF).rect_size.x = min(gv.cac[key].progress.f / gv.cac[key].progress.t * get_node(gnProgressBarT).rect_size.x, get_node(gnProgressBarT).rect_size.x)
	get_node(gnProgressTextF).text = fval.f(gv.cac[key].progress.f) + "\n" + fval.f(gv.cac[key].progress.t)

func r_xp():
	
	get_node(gnXpBarF).rect_size.x = min(gv.cac[key].xp.f.percent(gv.cac[key].xp.t) * get_node(gnXpBarT).rect_size.x, get_node(gnXpBarT).rect_size.x)


func level_up():
	
	sync()
	
	# amount improved! # flying texts
	if true:
		
		var oom = Big.new(gv.cac[key].consumed_spirit_gain(gv.cac[key].d.t)).d(last_d)
		
		var pos = Vector2(
			rect_global_position.x,
			rect_global_position.y - 5
		)
		
		pos.x += rand_range(0, rect_size.x)
		
		var _key = "ft"
		cont[_key] = src.ft.instance()
		rt.get_node("texts").add_child(cont[_key])
		
		cont[_key].rect_position = pos
		
		cont[_key].init(false, 0, "x" + oom.toString() + "!", gv.sprite["unknown"], Color(1, 0, 0, 0.8))
		
		last_d = gv.cac[key].consumed_spirit_gain(gv.cac[key].d.t)
	
	# flash gold!
	for f in 6:
		
		get_node(gnLevelUp).self_modulate = level_flash_colors[f]
		
		var t = Timer.new()
		t.set_wait_time(0.05)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()


func activate():
	
	gv.cac[key].active = true
	set_physics_process(true)
	show()
