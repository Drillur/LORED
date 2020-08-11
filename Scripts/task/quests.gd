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
			gv.menu.option["task auto"] = true
	
	taq.cur_quest = ""
	
	for x in rt.quests:
		if rt.quests[x].complete:
			continue
		taq.new_quest(rt.quests[x])
		break
	
	if taq.cur_quest == "":
		hide()
	
	if "tasks" in rt.content_tasks.keys():
		if taq.cur_tasks < taq.max_tasks:
			rt.content_tasks["tasks"].hit_max_tasks()
	
	rt.save_fps = 10.0

func flying_texts(resource_reward = {}) -> void:
	
	for x in resource_reward:
		gv.g[x].r.a(resource_reward[x])
		gv.emit_signal("lored_updated", x, "amount")
	
	var left_x = rect_global_position.x + rect_size.x / 2
	var ypos = rect_global_position.y - 5
	
	var i := 0
	for x in resource_reward:
		
		var t = Timer.new()
		t.set_wait_time(0.09)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		left_x += rand_range(-20, 20)
		
		if x == "growth":
			rt.get_node(rt.gnLOREDs).cont[x].w_bonus_output(x, resource_reward[x])
		
		var key = "task reward dtext" + str(i)
		
		# dtext
		content_effects[key] = prefabs.D_TEXT.instance()
		content_effects[key].init(false,-50, "+ " + resource_reward[x].toString(), gv.sprite[x], gv.g[x].color)
		rt.get_node("texts").add_child(content_effects[key])
		
		if i == 0:
			content_effects[key].rect_position = Vector2(left_x, ypos)
		else:
			
			for v in i:
				content_effects["task reward dtext" + str(v)].rect_position.y -= 7
			content_effects[key].rect_position = Vector2(
				content_effects["task reward dtext" + str(0)].rect_position.x + int(rand_range(-5,5)),
				content_effects["task reward dtext" + str(i-1)].rect_position.y + content_effects[key].rect_size.y
			)
		
		
		i += 1
