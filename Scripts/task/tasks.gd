extends MarginContainer

onready var rt = get_node("/root/Root")

const prefabs := {
	block = preload("res://Prefabs/task/random_task_block.tscn"),
	task_complete = preload("res://Prefabs/lored_buy.tscn"),
	d_text = preload("res://Prefabs/dtext.tscn"),
}

var content := []
var effects_content := {}

var ready_task_count = 0
var time_since_last_shake = 0.0
var last_y := 0.0

func _physics_process(delta):
	
	shake()

func shake() -> void:
	
	# shake if done
	
	if ready_task_count == 0:
		return
	
	time_since_last_shake += get_physics_process_delta_time()
	if time_since_last_shake < 5:
		return
	
	time_since_last_shake -= 5
	
	w_shake_self()

func init(_tasks := []):
	
	if not gv.menu.option["task auto"]:
		$HBoxContainer/auto/Label.show()
		$HBoxContainer/auto/AnimatedSprite.hide()
	
	for x in _tasks:
		add_task(x)

func hit_max_tasks():
	while taq.cur_tasks < taq.max_tasks:
		add_task(Task.new(gv.Quest.RANDOM))


func flying_numbers(f := {}):
	
	ready_task_count -= 1
	time_since_last_shake = 0.0
	
	if not gv.menu.option["flying_numbers"]:
		return
	
	var left_x = rect_global_position.x + rect_size.x / 2
	var ypos = rect_global_position.y - 5
	
	var i = 0
	for x in f:
		
		rt.save_fps -= 0.09
		var t = Timer.new()
		t.set_wait_time(0.09)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		left_x += rand_range(-10,10)
		
		if x == "growth":
			rt.get_node(rt.gnLOREDs).cont[x].w_bonus_output(x, f[x])
		
		var key = "flying freaking numbers " + str(i)
		
		effects_content[key] = prefabs.d_text.instance()
		effects_content[key].init(false,-50, "+ " + f[x].toString(), gv.sprite[x], gv.g[x].color)
		rt.get_node("texts").add_child(effects_content[key])
		
		if i == 0:
			effects_content[key].rect_position = Vector2(left_x, ypos)
		else:
			for v in i:
				effects_content["flying freaking numbers " + str(v)].rect_position.y -= 7
			effects_content[key].rect_position = Vector2(
				left_x - effects_content[key].rect_size.x / 2,
				effects_content["flying freaking numbers " + str(i-1)].rect_position.y + effects_content[key].rect_size.y
			)
		
		i += 1


func add_task(task: Task) -> void:
	
	#task.code = stepify(task.code, 0.01)
	
	var i = content.size()
	content.append(prefabs.block.instance())
	$HBoxContainer.add_child(content[i])
	$HBoxContainer.move_child(content[i], 0)
	taq.task.append(task)
	content[i].init(task)
	
	taq.cur_tasks += 1




func erase(_erase := -1.0) -> void:
	
	if _erase != -1.0:
		taq.cur_tasks -= 1
		content.erase(_erase)
		add_task(Task.new(gv.Quest.RANDOM))


func w_shake_self() -> void:
	
	# shake
	var time_between_shakes = 0.1
	
	rect_rotation = 1
	w_move_around(-rect_rotation * 1.5)
	
	var t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = -1
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = 0.8
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = -.7
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = .5
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = -0.2
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = .05
	w_move_around(-rect_rotation * 1.5)
	
	t = Timer.new()
	t.set_wait_time(time_between_shakes)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	rect_rotation = 0
	w_move_around(-rect_rotation * 1.5)
	last_y = 0.0
func w_move_around(y) -> void:
	rect_position.y -= last_y
	rect_position.y += y
	last_y = y


func _on_auto_button_down() -> void:
	rt.get_node("map").status = "no"


func _on_auto_pressed() -> void:
	
	if not gv.menu.option["task auto"]:
		gv.menu.option["task auto"] = true
		$HBoxContainer/auto/Label.hide()
		$HBoxContainer/auto/AnimatedSprite.show()
		for x in content:
			if content[x].get_node("tp").value >= 100:
				content[x]._on_task_pressed()
		return
	
	gv.menu.option["task auto"] = false
	$HBoxContainer/auto/Label.show()
	$HBoxContainer/auto/AnimatedSprite.hide()
