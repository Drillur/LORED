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
	
	if killing_self:
		return
	
	if $tp.value >= 100:
		return
	
	fps += delta
	if fps < rt.FPS:
		return
	fps -= rt.FPS
	
	$time.text = w_get_time_remaining()
	
	r_update_tp()

func r_update_tp() -> void:
	
	var points := 0.0
	for x in taq.task[code].step:
		points += taq.task[code].step[x].f
	$tp.value = points / taq.task[code].total_points * 100
	
	if $tp.value >= 100:
		get_parent().get_parent().ready_task_count += 1
		$time.text = ""
		$tp.self_modulate = Color($tp.self_modulate.r, $tp.self_modulate.g, $tp.self_modulate.b, 1.0)
		
		if rt.menu.option["task auto"]:
			_on_task_pressed(false)


func _on_task_mouse_entered():
	rt.get_node("global_tip")._call("taq " + str(code))#"task " + str(code))
	$time.show()

func _on_task_mouse_exited():
	rt.get_node("global_tip")._call("no")
	$time.hide()


func _on_task_pressed(manual := true):
	
	if $tp.value < 100:
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
	
	if "Tasks completed" in taq.quest.step.keys():
		taq.quest.step["Tasks completed"].f = min(taq.quest.step["Tasks completed"].f + 1, taq.quest.step["Tasks completed"].b)
	elif "Rare or Spike tasks completed" in taq.quest.step.keys():
		if $rare.visible or $spike.visible:
			taq.quest.step["Rare or Spike tasks completed"].f = min(taq.quest.step["Rare or Spike tasks completed"].f + 1, taq.quest.step["Rare or Spike tasks completed"].b)
	elif "Spike tasks completed" in taq.quest.step.keys():
		if $spike.visible:
			taq.quest.step["Spike tasks completed"].f = min(taq.quest.step["Spike tasks completed"].f + 1, taq.quest.step["Spike tasks completed"].b)
	
	for x in taq.task[code].resource_reward:
		gv.g[x].r += taq.task[code].resource_reward[x]
		gv.g[x].task_and_quest_check(taq.task[code].resource_reward[x])
	
	for x in taq.task[code].reward:
		
		pass
	
	var i := 0
	for x in taq.task[code].resource_reward:
		
		rt.save_fps -= 0.09
		var t = Timer.new()
		t.set_wait_time(0.09)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		var rollx :int= rand_range(-20,40)
		
		if x == "growth":
			rt.get_node("map/loreds").lored[x].w_bonus_output(x, taq.task[code].resource_reward[x])
		
		var key = "task reward dtext" + str(i) + str(code)
		
		get_parent().get_parent().effects_content[key] = get_parent().get_parent().prefabs.d_text.instance()
		get_parent().get_parent().effects_content[key].text = "+ " + fval.f(taq.task[code].resource_reward[x])
		get_parent().get_parent().effects_content[key].add_color_override("font_color", rt.r_lored_color(x))
		get_parent().get_parent().effects_content[key].get_node("icon").set_texture(gv.sprite[x])
		get_parent().get_parent().effects_content[key].init(true,-50)
		get_parent().get_parent().get_parent().get_parent().add_child(get_parent().get_parent().effects_content[key])
		
		var left_x = rollx + rt.get_node("misc/taq").rect_position.x + rect_position.x
		var ypos = get_node("/root/Root/misc/taq").rect_position.y - 17
		if i == 0:
			get_parent().get_parent().effects_content[key].rect_position = Vector2(left_x, ypos)
		else:
			for v in i:
				get_parent().get_parent().effects_content["task reward dtext" + str(v) + str(code)].rect_position.y -= 7
			get_parent().get_parent().effects_content[key].rect_position = Vector2(left_x, get_parent().get_parent().effects_content["task reward dtext" + str(i-1) + str(code)].rect_position.y + get_parent().get_parent().effects_content[key].rect_size.y)
		
		
		i += 1
	
	get_parent().get_parent().ready_task_count -= 1
	get_parent().get_parent().time_since_last_shake = 0.0
	
	taq.task.erase(code)
	
	queue_free()


func w_get_time_remaining() -> String:
	
	if taq.task[code].step.size() == 1 and " produced" in taq.task[code].step.keys()[0]:
		
		var remaining_amount : float = taq.task[code].step.values()[0].t - taq.task[code].step.values()[0].f
		var gg = rt.w_name_to_short(taq.task[code].step.keys()[0].split(" produced")[0])
		
		if gv.g[gg].halt:
			return "=/="
		
		var per_sec = gv.g[gg].net(true)
		var intermittent := 1.0
		if not gv.g[gg].progress.t == 0.0:
			intermittent = gv.g[gg].d.t * (gv.g[gg].progress.f / gv.g[gg].progress.t)
		var final := 1.0
		if not per_sec == 0.0:
			final = (remaining_amount - intermittent) / per_sec
		else:
			return "!?"
		if final > 3600 * 24 * 365:
			var days:= int(final /60 / 60 / 24 / 365)
			return fval.f(days) + "y"
		if final > 3600 * 24:
			var days:= int(final /60 / 60 / 24)
			return str(days) + "d"
		if final > 3600:
			var hours := int(final / 60 / 60)
			return str(hours) + "h"
		if final > 60:
			var minutes := int(final / 60)
			#var sec := int(final - (minutes * 60))
			return str(minutes) + "m"# " + str(sec) + "s"
		if final >= 1:
			return String(int(final)) + "s"
		if not taq.task[code].step.values()[0].f >= taq.task[code].step.values()[0].t:
			return "!"
	
	return ""


func _on_task_button_down():
	rt.get_node("map").status = "no"
