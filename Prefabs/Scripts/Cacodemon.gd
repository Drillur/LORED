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

const src := {
	ft = preload("res://Prefabs/dtext.tscn"),
}
var cont := {}

var last_d: Big # used to tell how much leveling up boosted d

var key: int
var task_timer := Timer.new()

onready var gn_cacodemons = rt.get_node(rt.gnLOREDs + "/sc/v/s3/m")
onready var gn_task = get_node("v/v/task")
onready var gn_CS_count = get_node("v/v/task/consumed spirits")
onready var gn_xp_bar = get_node("v/v/xp")
onready var gn_xp_bar_f = get_node("v/v/xp/f")
onready var gn_host = get_node("host")
onready var gn_attach = get_node("v/Attach")
onready var gn_progress_bar_f = get_node("v/v/task/f")
onready var gn_level_up = get_node("level up")
const gn_offscreen := "offscreen"


func _ready():
	
	set_physics_process(false)
	
	add_child(task_timer)
	
	gn_level_up.self_modulate = level_flash_colors[level_flash_colors.size() - 1]
	gn_level_up.show()
	
	gn_CS_count.text = "0"
	
	hide()


func setup(_key: int):
	
	key = _key
	
	last_d = gv.cac[key].consumed_spirit_gain()
	gn_progress_bar_f.modulate = gv.cac[key].color


func start():
	
	while not gv.cac[key].dead and not gv.cac[key].host:
		
		# if resetting same stage as lored, it cannot act
		if "no" in gv.menu.f:
			if int(gv.menu.f.split(" s")[1]) >= 3:
				break
		
		gv.cac[key].start_task()
		tell_children_the_news()
		
		task_timer.start(gv.cac[key].progress.t)
		yield(task_timer, "timeout")
		task_timer.stop()
		
		gv.cac[key].finish_task()
		
		gn_CS_count.text = gv.cac[key].consumed_spirits.toString()
		gn_xp_bar_f.rect_size.x = min(gv.cac[key].xp.f.percent(gv.cac[key].xp.t) * gn_xp_bar.rect_size.x, gn_xp_bar.rect_size.x)
	
	# after 1 second, will restart the func
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	start()

func tell_children_the_news():
	
	gn_task.start(gv.cac[key].progress.t, OS.get_ticks_msec())
	
	pass


func r_level_up():
	
	if not on_screen():
		return
	
	# amount improved! # flying texts
	if gv.menu.option["flying_numbers"]:
		
		var oom = Big.new(gv.cac[key].consumed_spirit_gain()).d(last_d)
		
		var pos = Vector2(
			rect_global_position.x,
			rect_global_position.y - 5
		)
		
		pos.x += rand_range(0, rect_size.x)
		
		var _key = "ft"
		cont[_key] = src.ft.instance()
		rt.get_node("m/lored texts").add_child(cont[_key])
		
		cont[_key].rect_position = pos
		
		cont[_key].init(false, 0, "x" + oom.toString() + "!", gv.sprite["unknown"], Color(1, 0, 0, 0.8))
		
		last_d = gv.cac[key].consumed_spirit_gain()
	
	# flash gold!
	for f in 6:
		
		gn_level_up.self_modulate = level_flash_colors[f]
		
		var t = Timer.new()
		add_child(t)
		t.start(0.05)
		yield(t, "timeout")
		t.queue_free()


func activate():
	
	gv.cacodemons += 1
	
	gv.cac[key].active = true
	show()
	
	start()


func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")
func _on_back_mouse_entered() -> void:
	rt.get_node("global_tip")._call("cac " + str(key))


func on_screen() -> bool:
	
	# returns true if visible on-screen, false if not
	
	if gv.menu.tab != "3":
		return false
	
	if rect_global_position.y > gn_cacodemons.rect_global_position.y + gn_cacodemons.rect_size.y - 40:
		return false
	if rect_global_position.y + rect_size.y < gn_cacodemons.rect_global_position.y + 50:
		return false
	
	return true


func _on_Attach_pressed() -> void:
	
	gv.cac[key].selected_as_host()
	
	task_timer.stop()
	gn_task.halt()
	
	gn_host.show()
	gn_attach.hide()
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	host()

func host():
	
	var loss := Big.new(1.1)
	var i = 1
	
	while true:
		
		if loss.greater(gv.cac[key].consumed_spirits):
			gv.r["spirit"].a(gv.cac[key].consumed_spirits)
			gv.cac[key].consumed_spirits = Big.new(0)
			break
		
		gv.cac[key].consumed_spirits.s(loss)
		gn_CS_count.text = gv.cac[key].consumed_spirits.toString()
		gv.r["spirit"].a(loss)
		
		i += 1
		loss.m(loss)
		
		var t = Timer.new()
		add_child(t)
		t.start(1 / i)
		yield(t, "timeout")
		t.queue_free()
	
	gv.cac[key].killed()
