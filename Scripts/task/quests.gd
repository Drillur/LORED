extends MarginContainer

onready var rt = get_node("/root/Root")

const prefabs = {
	D_TEXT = preload("res://Prefabs/dtext.tscn"),
}

var content_effects := {}


func quest_ended() -> void:
	
	flying_texts(taq.main_quest.reward)
	
	taq.cur_quest = -1
	
	for q in gv.Quest:
		if not q in taq.completed_quests:
			taq.new_quest(q)
			break
	
	if taq.cur_quest == -1:
		hide()
		set_physics_process(false)
	
	taq.hit_max_tasks()

func flying_texts(reward = []) -> void:
	
	if not gv.menu.option["flying_numbers"]:
		return
	
	var poop = []
	
	for r in reward:
		if r.type == gv.QuestReward.RESOURCE:
			poop.append(r)
	
	var left_x = rect_global_position.x / rt.scale.x + (rect_size.x / rt.scale.x) / 2
	var ypos = rect_global_position.y / rt.scale.y - 5
	
	var i := 0
	for x in poop:
		
		var t = Timer.new()
		add_child(t)
		t.start(0.09)
		yield(t, "timeout")
		t.queue_free()
		
		left_x += rand_range(-20, 20)
		
		var key = "task reward dtext" + str(i)
		
		# dtext
		content_effects[key] = prefabs.D_TEXT.instance()
		content_effects[key].init(false,-50, "+ " + x.amount.toString(), x.icon, x.color)
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
