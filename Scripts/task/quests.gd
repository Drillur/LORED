extends Panel

onready var rt = get_node("/root/Root")

const prefabs = {
	TASK = preload("res://Prefabs/task/task.tscn"),
	TASK_COMPLETE = preload("res://Prefabs/lored_buy.tscn"),
	D_TEXT = preload("res://Prefabs/dtext.tscn"),
}

var content_effects := {}



func quest_ended() -> void:
	
	rt.w_task_effects([taq.cur_quest])
	
	flying_texts(taq.quest.resource_reward)
	
	match taq.quest.name:
		"Spike":
			rt.menu.option["task auto"] = true
	
	taq.cur_quest = ""
	
	for x in rt.tasks:
		if rt.tasks[x].complete:
			continue
		
		taq.new_quest(rt.tasks[x])
		
		break
	
	if "tasks" in rt.content_tasks.keys():
		if taq.cur_tasks < taq.max_tasks:
			rt.content_tasks["tasks"].hit_max_tasks()
	
	rt.save_fps = 10.0

func flying_texts(resource_reward = {}) -> void:
	
	for x in resource_reward:
		gv.g[x].r += resource_reward[x]
	
	var i := 0
	for x in resource_reward:
		
		var t = Timer.new()
		t.set_wait_time(0.09)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		var rollx :int= rand_range(75,150)
		
		if x == "growth":
			rt.get_node("map/loreds").lored[x].w_bonus_output(x, resource_reward[x])
		
		# dtext
		content_effects["task reward dtext" + str(i)] = prefabs.D_TEXT.instance()
		content_effects["task reward dtext" + str(i)].text = "+ " + fval.f(resource_reward[x])
		content_effects["task reward dtext" + str(i)].add_color_override("font_color", rt.r_lored_color(x))
		content_effects["task reward dtext" + str(i)].get_node("icon").set_texture(gv.sprite[x])
		content_effects["task reward dtext" + str(i)].init(true,-50)
		if i == 0:
			content_effects["task reward dtext" + str(i)].rect_position = Vector2(rollx + rt.get_node("misc/taq").rect_position.x + 25, rt.get_node("misc/taq").rect_position.y - 10)
		else:
			
			for v in i:
				content_effects["task reward dtext" + str(v)].rect_position.y -= 7
			content_effects["task reward dtext" + str(i)].rect_position = Vector2(rollx + 570, content_effects["task reward dtext" + str(i-1)].rect_position.y + content_effects["task reward dtext" + str(i)].rect_size.y)
		rt.add_child(content_effects["task reward dtext" + str(i)])
		i += 1
