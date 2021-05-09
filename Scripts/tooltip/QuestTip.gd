extends MarginContainer

var src := {
	step = preload("res://Prefabs/tooltip/QuestTipStep.tscn"),
	reward = preload("res://Prefabs/tooltip/QuestTipReward.tscn"),
	resource_reward = preload("res://Prefabs/tooltip/QuestTipResourceReward.tscn"),
}
var cont := {
	step = {},
	rr = {},
	r = {},
	up_block = {},
}

onready var rt = get_node("/root/Root")
onready var gn_name := get_node("v/header/h/name")
onready var gn_desc := get_node("v/desc")
onready var gn_steps := get_node("v/steps")
onready var gn_rewards := get_node("v/rewards")
onready var rare = get_node("v/header/h/rare")
onready var spike = get_node("v/header/h/spike")


var fps := -0.1
var task: Task



func _ready():
	
	set_process(false)
	set_physics_process(false)
	
	var t = Timer.new()
	add_child(t)
	t.start(.01)
	yield(t, "timeout")
	t.queue_free()
	
	rect_size = Vector2(0, 0)
	r_update()


func r_update() -> void:
	
	while true:
		
		# step
		var i = 0
		for r in task.req:
			cont.step[i].get_node("v/h/step/val").text = r.progress.toString() + " / " + r.amount.toString()
			cont.step[i].get_node("progress/f").rect_size.x = min(r.progress.percent(r.amount) * cont.step[i].get_node("progress").rect_size.x, cont.step[i].get_node("progress").rect_size.x)
			if r.done:
				cont.step[i].get_node("done").show()
				cont.step[i].get_node("progress/f/flair").hide()
			
			i += 1
		
		var t = Timer.new()
		add_child(t)
		t.start(gv.fps)
		yield(t, "timeout")
		t.queue_free()
		
		
#		if cont.step[x].get_node("v/ct/c").rect_size.x == cont.step[x].get_node("v/ct").rect_size.x:
#			if not step_check[x]:
#
#				cont.step[x].get_node("v/ct").hide()
#				cont.step[x].get_node("v/h/check").show()
#
#				set_process(true)
#				step_check[x] = true


func flash():
	
	for x in cont.step:
		
		if cont.step[x].get_node("done").visible:
			continue
		
		var flash = gv.SRC["flash"].instance()
		cont.step[x].add_child(flash)
		flash.flash()



func init(_task: Task) -> void:
	
	task = _task
	
	gn_name.text = task.name
	gn_desc.text = desc(task.desc)
	$v/header/bg.modulate = task.color
	
	tags(task.key)
	reward(task.reward)
	req(task.req)
	
	#set_process(true)

func tags(type: int) -> void:
	
	if type == gv.Quest.RANDOM_RARE:
		rare.show()
	elif type == gv.Quest.RANDOM_SPIKE:
		spike.show()

func desc(desc: String) -> String:
	
	if task.random:
		return ""
	
	# quests
	if task.desc == "":
		return ""
	
	gn_desc.show()
	
	if task.name in ["Witch", "Necro", "Blood", "Hunt"]:
		
		var poop = desc
		poop = desc.format({"key": task.name, "level": fval.f(gv.g[task.name.to_lower()].level + 1)})
		return poop 
	
	return desc

func req(requirements: Array) -> void:
	
	var i = 0
	for r in requirements:
		
		cont.step[i] = src.step.instance()
		cont.step[i].get_node("v/h/icon/Sprite").texture = r.icon
		
		cont.step[i].get_node("v/h/step/desc").text = r.text
		
		# color
		cont.step[i].get_node("v/h/step/val").add_color_override("font_color", r.color)
		cont.step[i].get_node("progress/f").modulate = r.color
		cont.step[i].get_node("done").modulate = r.color
		
		gn_steps.add_child(cont.step[i])
		
		if r.type == gv.TaskRequirement.UPGRADE_PURCHASED:
			
			cont.up_block[i] = gv.SRC["upgrade block"].instance()
			gn_steps.add_child(cont.up_block[i])
			cont.up_block[i].init(r.req_key)
		
		i += 1
	
	r_update()

func reward(reward: Array) -> void:
	
	if reward.size() == 0:
		gn_rewards.hide()
		return
	
	var i := 0
	for r in reward:
		cont.rr[i] = src.resource_reward.instance()
		cont.rr[i].get_node("HBoxContainer/icon/Sprite").texture = r.icon
		cont.rr[i].get_node("HBoxContainer/VBoxContainer/type").text = r.text
		if "amount" in r.other_keys:
			cont.rr[i].get_node("HBoxContainer/VBoxContainer/val").text = r.amount.toString()
		else:
			cont.rr[i].get_node("HBoxContainer/VBoxContainer/val").hide()
		cont.rr[i].get_node("HBoxContainer/VBoxContainer/val").add_color_override("font_color", r.color)
		
		if i % 2 == 0:
			cont.rr[i].get_node("bg").hide()
		else:
			cont.rr[i].get_node("bg").self_modulate = r.color
		
		gn_rewards.add_child(cont.rr[i])
		i += 1

