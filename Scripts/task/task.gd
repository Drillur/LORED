extends Button


onready var rt = get_node("/root/Root")

var code := 0.0
var fps := 0.0

var killing_self := false


func init(_icon:Dictionary, _code:float, _tp_border_color: Color) -> void:
	
	code = _code
	
	# ref
	if true:
		
		$time.add_color_override("font_color", _tp_border_color)
		$icon.texture = _icon.texture
		$tp.self_modulate = Color(_tp_border_color.r, _tp_border_color.g, _tp_border_color.b, 0.5)
		if "(Rare)" in taq.task[code].name:
			$rare.show()
		elif "{Spike}" in taq.task[code].name:
			$spike.show()


func _physics_process(delta):
	
	if not code in taq.task.keys():
		set_physics_process(false)
		return
	
	if killing_self:
		return
	
	if $tp.value >= 100:
		return
	
	fps += delta
	if fps < rt.FPS:
		return
	fps -= rt.FPS
	
	if taq.task[code].step.size() == 1 and " produced" in taq.task[code].step.keys()[0]:
		var gg = rt.w_name_to_short(taq.task[code].step.keys()[0].split(" produced")[0])
		$time.text = gv.time_remaining(gg, taq.task[code].step.values()[0].f, taq.task[code].step.values()[0].t, true)
	else:
		$time.text = ""
	
	r_update_tp()

func r_update_tp() -> void:
	
	var points: Big = Big.new(0)
	for x in taq.task[code].step:
		points.plus(taq.task[code].step[x].f)
	$tp.value = Big.new(points).divide(taq.task[code].total_points).toFloat() * 100
	
	if $tp.value >= 100:
		get_parent().get_parent().ready_task_count += 1
		$time.text = ""
		$tp.self_modulate = Color($tp.self_modulate.r, $tp.self_modulate.g, $tp.self_modulate.b, 1.0)
		
		if gv.menu.option["task auto"]:
			_on_task_pressed(false)


func _on_task_mouse_entered():
	rt.get_node("global_tip")._call("taq " + str(code))#"task " + str(code))
	$time.show()

func _on_task_mouse_exited():
	rt.get_node("global_tip")._call("no")
	$time.hide()


func _on_task_pressed(manual := true):
	
	if $tp.value < 100:
		if manual:
			rt.get_node("global_tip").tip.content["taq"].flash_incomplete_steps = true
		return
	
	if manual:
		rt.get_node("map/tip")._call("no")
	
	gv.stats.tasks_completed += 1
	
	hide()
	get_parent().get_parent().erase(code) # erases this task from content too
	finish_up()

func kill_yourself():
	hide()
	get_parent().get_parent().content.erase(code)
	taq.task.erase(code)
	killing_self = true
	taq.cur_tasks -= 1
	#get_parent().get_parent().ready_task_count += 1
	queue_free()

func finish_up():
	
	if taq.cur_quest != "":
		
		if "Tasks completed" in taq.quest.step.keys():
			var A = Big.new(Big.min(Big.new(taq.quest.step["Tasks completed"].f).plus(1), taq.quest.step["Tasks completed"].b))
			taq.quest.step["Tasks completed"].f = A
		elif "Rare or Spike tasks completed" in taq.quest.step.keys():
			if $rare.visible or $spike.visible:
				var A = Big.new(Big.min(Big.new(taq.quest.step["Rare or Spike tasks completed"].f).plus(1), taq.quest.step["Rare or Spike tasks completed"].b))
				taq.quest.step["Rare or Spike tasks completed"].f = A
		elif "Spike tasks completed" in taq.quest.step.keys():
			if $spike.visible:
				var A = Big.new(Big.min(Big.new(taq.quest.step["Spike tasks completed"].f).plus(1), taq.quest.step["Spike tasks completed"].b))
				taq.quest.step["Spike tasks completed"].f = A
	
	for x in taq.task[code].resource_reward:
		gv.g[x].r.plus(taq.task[code].resource_reward[x].toScientific())
		gv.g[x].task_and_quest_check(taq.task[code].resource_reward[x])
	
	for x in taq.task[code].reward:
		
		break
	
	var gayzo = {}
	for x in taq.task[code].resource_reward:
		gayzo[x] = Big.new(taq.task[code].resource_reward[x])
	
	get_parent().get_parent().flying_numbers(gayzo)
	
	taq.task.erase(code)
	
	queue_free()




func _on_task_button_down():
	rt.get_node("map").status = "no"
