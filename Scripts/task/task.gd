extends Button


onready var rt = get_node("/root/Root")

var task: Task

var fps := 0.0



func init(_task: Task) -> void:
	
	task = _task
	
	task.manager = self
	
	# ref
	if true:
		
		$icon.texture = task.icon
		$tp.self_modulate = Color(task.color.r, task.color.g, task.color.b, 0.5)
		if task.type == gv.Quest.RANDOM_RARE:
			$rare.show()
		elif task.type == gv.Quest.RANDOM_SPIKE:
			$spike.show()



func _physics_process(delta):
	
	return
	
	if $tp.value >= 100:
		return
	
	fps += delta
	if fps < gv.fps:
		return
	fps -= gv.fps
	
	r_update_tp()

func r_update_tp() -> void:
	
	$tp.value = task.points.percent(task.total_points) * 100
	
	if task.ready:
		get_parent().get_parent().ready_task_count += 1
		$time.text = ""
		$tp.self_modulate = Color($tp.self_modulate.r, $tp.self_modulate.g, $tp.self_modulate.b, 1.0)
		
		if gv.menu.option["task auto"]:
			_on_task_pressed(false)


func _on_task_mouse_entered():
	rt.get_node("global_tip")._call("taq", {"random": task})#"task " + str(code))
	$time.show()

func _on_task_mouse_exited():
	rt.get_node("global_tip")._call("no")
	$time.hide()


func _on_task_pressed(manual := true):
	
	if $tp.value < 100:
		if manual:
			rt.get_node("global_tip").tip.cont["taq"].flash_incomplete_steps = true
		return
	
	if manual:
		rt.get_node("global_tip")._call("no")
	
	gv.stats.tasks_completed += 1
	
	hide()
	get_parent().get_parent().content.remove(self) # erases this task from content too
	finish_up()

func kill_yourself():
	set_physics_process(false)
	hide()
	get_parent().get_parent().content.remove(self)
	taq.task.erase(task)
	taq.cur_tasks -= 1
	queue_free()

func finish_up():
	
	if taq.cur_quest != -1:
		
		if "Tasks completed" in taq.quest.step.keys():
			var A = Big.new(Big.min(Big.new(taq.quest.step["Tasks completed"].f).a(1), taq.quest.step["Tasks completed"].b))
			taq.quest.step["Tasks completed"].f = A
		elif "Rare or Spike tasks completed" in taq.quest.step.keys():
			if $rare.visible or $spike.visible:
				var A = Big.new(Big.min(Big.new(taq.quest.step["Rare or Spike tasks completed"].f).a(1), taq.quest.step["Rare or Spike tasks completed"].b))
				taq.quest.step["Rare or Spike tasks completed"].f = A
		elif "Spike tasks completed" in taq.quest.step.keys():
			if $spike.visible:
				var A = Big.new(Big.min(Big.new(taq.quest.step["Spike tasks completed"].f).a(1), taq.quest.step["Spike tasks completed"].b))
				taq.quest.step["Spike tasks completed"].f = A
	
	var gayzo = {}
	for r in task.reward:
		if not r.type == gv.TaskRequirement.REDSOURCE_PRODUCTION:
			continue
		
		taq.progress(gv.TaskRequirement.RESOURCE_PRODUCTION, r.other_key, r.amount)
		
		gayzo[r.other_key] = Big.new(r.amount)
	
	get_parent().get_parent().flying_numbers(gayzo)
	
	taq.task.erase(task)
	
	queue_free()




func _on_task_button_down():
	rt.get_node("map").status = "no"
