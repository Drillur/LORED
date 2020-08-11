extends MarginContainer

var src := {
	step = preload("res://Prefabs/tooltip/QuestTipStep.tscn"),
	reward = preload("res://Prefabs/tooltip/QuestTipReward.tscn"),
	resource_reward = preload("res://Prefabs/tooltip/QuestTipResourceReward.tscn"),
	up_block = preload("res://Prefabs/tooltip/upgrade_block.tscn"),
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

var fps := 0.0
var task: taq.Task
var step_check := {}

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
	if fps < rt.FPS:
		return
	fps -= rt.FPS
	
	r_update()


func r_update() -> void:
	
	# step
	for x in task.step:
		cont.step[x].get_node("v/h/step/val").text = task.step[x].f.toString() + " / " + task.step[x].b.toString()
		
		cont.step[x].get_node("v/ct/c").rect_size.x = task.step[x].f.percent(task.step[x].b) * cont.step[x].get_node("v/ct").rect_size.x
		cont.step[x].get_node("v/ct/c").rect_size.x = min(cont.step[x].get_node("v/ct/c").rect_size.x, cont.step[x].get_node("v/ct").rect_size.x)
		
		if cont.step[x].get_node("v/ct/c").rect_size.x == cont.step[x].get_node("v/ct").rect_size.x:
			if not step_check[x]:
				
				cont.step[x].get_node("v/ct").hide()
				cont.step[x].get_node("v/h/check").show()
				
				set_process(true)
				step_check[x] = true


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



func init(_task: taq.Task) -> void:
	
	task = _task
	
	gn_name.text = _name(task.name)
	gn_desc.text = desc(task.step, task.desc)
	if task.icon.key in gv.g.keys():
		$v/m/bg.modulate = gv.g[task.icon.key].color
	gn_icon.texture = task.icon.texture
	
	tags(task.name)
	step(task.step)
	resource_reward(task.resource_reward)
	reward(task.reward)
	
	#set_process(true)

func _name(_name: String) -> String:
	
	if "(Rare)" in _name:
		return _name.split(" (Rare)")[0]
	
	if "{Spike}" in _name:
		return _name.split(" {Spike}")[0]
	
	return _name

func tags(_name: String) -> void:
	
	if "(Rare)" in _name:
		$v/tags/rare.show()
	
	elif "{Spike}" in _name:
		$v/tags/spike.show()

func desc(step: Dictionary, desc: String) -> String:
	
	if not task.name in rt.quests.keys():
		if step.size() == 1:
			for x in step.keys():
				if " purchased" in x:
					return ""
				if " produced" in x:
					return ""
	
	# quests
	if task.desc == "":
		return ""
	
	gn_desc.show()
	
	return desc

func step(step: Dictionary) -> void:
	
	for x in step:
		
		step_check[x] = false
		
		cont.step[x] = src.step.instance()
		cont.step[x].get_node("v/h/icon/Sprite").texture = r_set_icon(x)
		cont.step[x].get_node("v/h/step/desc").text = x
		var color: Color
		if "LORED bought" in x:
			color = gv.g[rt.w_name_to_short(x.split(" LORED")[0])].color
		elif " produced" in x and not "Combined resources" in x:
			color = gv.g[rt.w_name_to_short(x.split(" produced")[0])].color
		else:
			color = Color(0.8, 0.8, 0.8)
		cont.step[x].get_node("v/h/step/val").add_color_override("font_color", color)
		if " produced" in x:
			cont.step[x].get_node("v/ct").modulate = color
		
		gn_steps.add_child(cont.step[x])
		
		if "purchased" in x:
			
			cont.up_block[x] = src.up_block.instance()
			gn_steps.add_child(cont.up_block[x])
			cont.up_block[x].init(x.split(" purchased")[0])
	
	r_update()

func resource_reward(rr: Dictionary) -> void:
	
	if rr.size() == 0:
		$v/RR.hide()
		return
	
	var i := 0
	for x in rr:
		
		cont.rr[x] = src.resource_reward.instance()
		cont.rr[x].get_node("HBoxContainer/icon/Sprite").texture = gv.sprite[x]
		cont.rr[x].get_node("HBoxContainer/VBoxContainer/type").text = gv.g[x].name
		cont.rr[x].get_node("HBoxContainer/VBoxContainer/val").text = task.resource_reward[x].toString()
		cont.rr[x].get_node("HBoxContainer/VBoxContainer/val").add_color_override("font_color", gv.g[x].color)
		
		if i % 2 == 0:
			cont.rr[x].get_node("bg").hide()
		
		gn_rr.add_child(cont.rr[x])
		
		i += 1

func reward(r: Dictionary) -> void:
	
	if r.size() == 0:
		return
	
	$v/R.show()
	
	var i = 0
	for x in r:
		
		cont.r[x] = src.reward.instance()
		cont.r[x].get_node("h/icon/Sprite").texture = task.reward[x]
		cont.r[x].get_node("h/text").text = x
		
		if i % 2 == 0:
			cont.r[x].get_node("bg").hide()
		
		gn_r.add_child(cont.r[x])
		
		i += 1

func r_set_icon(resource : String) -> Texture:
	
	var blah := ""
	for x in gv.g:
		if not gv.g[x].name in resource:
			continue
		
		if "Liquid" in resource and gv.g[x].name == "Iron":
			continue
		if "Pulp" in resource and gv.g[x].name == "Wood":
			continue
		
		blah = x
		break
	
	if "Tasks completed" in resource or "Rare or Spike tasks completed" in resource or "Spike tasks completed" in resource:
		return gv.sprite["copy"]
	
	# upgrade
	if "purchased" in resource:
		return gv.sprite[gv.up[resource.split(" purchased")[0]].main_lored_target]
	
	# buy lored
	if "bought" in resource:
		return gv.sprite[blah]
	
	if "combined resources produced" in resource.to_lower():
		return gv.sprite["s1"]
	
	if "combined stage 2 resources produced" in resource.to_lower():
		return gv.sprite["s2"]
	
	if "produced" in resource:
		return gv.sprite[blah]
	
	if "Have" in resource:
		return gv.sprite[blah]
	
	return gv.sprite["unknown"]
