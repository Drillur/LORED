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
onready var gn_icon := get_node("v/m/h/icon/Sprite")
onready var gn_name := get_node("v/m/h/name")
onready var gn_desc := get_node("v/desc")
onready var gn_steps := get_node("v/steps")
onready var gn_rr := get_node("v/RR/v")
onready var gn_r := get_node("v/R/v")


var fps := -0.1
var task: Task

var flash_incomplete_steps := false
var flash_i := 0



func _ready():
	set_process(false)

func _process(delta: float) -> void:
	
	rect_size = Vector2(0, 0)
	set_process(false)

func _physics_process(delta: float) -> void:
	
	flash()
	
	fps += delta
	if fps < gv.fps:
		return
	fps -= gv.fps
	
	r_update()


func r_update() -> void:
	
	# step
	var i = 0
	for r in task.req:
		cont.step[i].get_node("v/h/step/val").text = r.progress.toString() + " / " + r.amount.toString()
		
		cont.step[i].get_node("v/ct/c").rect_size.x = r.progress.percent(r.amount) * cont.step[i].get_node("v/ct").rect_size.x
		cont.step[i].get_node("v/ct/c").rect_size.x = min(cont.step[i].get_node("v/ct/c").rect_size.x, cont.step[i].get_node("v/ct").rect_size.x)
		
		i += 1
		
#		if cont.step[x].get_node("v/ct/c").rect_size.x == cont.step[x].get_node("v/ct").rect_size.x:
#			if not step_check[x]:
#
#				cont.step[x].get_node("v/ct").hide()
#				cont.step[x].get_node("v/h/check").show()
#
#				set_process(true)
#				step_check[x] = true


func flash():
	
	if not flash_incomplete_steps:
		return
	
	# init
	if flash_i == 0:
		
		flash_i = 8
		
		for x in cont.step:
			
			if cont.step[x].get_node("v/h/check").visible:
				continue
			
			cont.step[x].get_node("flash0").show()
			cont.step[x].get_node("flash1").show()
	
	flash_i -= 1
	
	if flash_i == 4:
		
		for x in cont.step:
			cont.step[x].get_node("flash1").hide()
	
	if flash_i == 0:
		
		for x in cont.step:
			cont.step[x].get_node("flash0").hide()
		
		flash_incomplete_steps = false



func init(_task: Task) -> void:
	
	task = _task
	
	gn_name.text = task.name
	gn_desc.text = desc(task.req, task.desc)
	$v/m/bg.modulate = task.color
	gn_icon.texture = task.icon
	
	tags(task.key)
	reward(task.reward)
	req(task.req)
	
	#set_process(true)

func tags(type: int) -> void:
	
	if type == gv.Quest.RANDOM_RARE:
		$v/tags/rare.show()
	elif type == gv.Quest.RANDOM_SPIKE:
		$v/tags/spike.show()

func desc(step: Array, desc: String) -> String:
	
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
		if r.type == gv.TaskRequirement.RESOURCE_PRODUCTION:
			cont.step[i].get_node("v/ct").modulate = r.color
		
		gn_steps.add_child(cont.step[i])
		
		if r.type == gv.TaskRequirement.UPGRADE_PURCHASED:
			
			cont.up_block[i] = gv.SRC["upgrade block"].instance()
			gn_steps.add_child(cont.up_block[i])
			cont.up_block[i].init(r.req_key)
		
		i += 1
	
	r_update()

func reward(reward: Array) -> void:
	
	if reward.size() == 0:
		$v/RR.hide()
		return
	
	var i := 0
	for r in reward:
		cont.rr[i] = src.resource_reward.instance()
		cont.rr[i].get_node("HBoxContainer/icon/Sprite").texture = r.icon
		cont.rr[i].get_node("HBoxContainer/VBoxContainer/type").text = r.text
		cont.rr[i].get_node("HBoxContainer/VBoxContainer/val").text = r.amount.toString()
		cont.rr[i].get_node("HBoxContainer/VBoxContainer/val").add_color_override("font_color", r.color)
		
		if i % 2 == 0:
			cont.rr[i].get_node("bg").hide()
		
		gn_rr.add_child(cont.rr[i])

func r_set_icon(resource : String) -> Texture:
	
	var blah := ""
	for x in gv.g:
		if not gv.g[x].name in resource:
			continue
		
		if "Liquid" in resource and gv.g[x].name == "Iron":
			continue
		if "Pulp" in resource and gv.g[x].name == "Wood":
			continue
		if "Copper Ore" in resource and gv.g[x].name == "Copper":
			continue
		if "Iron Ore" in resource and gv.g[x].name == "Iron":
			continue
		
		blah = x
		break
	
	if blah == "":
		blah = resource.split(" produced")[0]
	
	if "Tasks completed" in resource or "Rare or Spike tasks completed" in resource or "Spike tasks completed" in resource:
		return gv.sprite["copy"]
	
	# upgrade
	if "purchased" in resource:
		return gv.sprite[gv.up[resource.split(" purchased")[0]].icon]
	
	# buy lored
	if "bought" in resource:
		return gv.sprite[blah]
	
	if "combined resources produced" in resource.to_lower():
		return gv.sprite["s1"]
	
	if "combined stage 2 resources produced" in resource.to_lower():
		return gv.sprite["s2"]
	
	if "produced" in resource:
		return gv.sprite[blah]
	
	if " cast" in resource:
		return gv.sprite["witch"]
	
	if "Have" in resource:
		return gv.sprite[blah]
	
	return gv.sprite["unknown"]
