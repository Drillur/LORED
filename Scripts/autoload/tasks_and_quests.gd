extends Node

# access with taq

const prefabs = {
	TASK = preload("res://Prefabs/task/task.tscn"),
}

var quest = 0
var cur_quest := ""

var max_tasks := 1
var cur_tasks := 0
var task := {}

var content = 0


class Task:
	
	var code : float
	var name := "task name"
	var desc := "task description"
	var next_in_chain : String
	var resource_reward := {} # resource_reward["iron"] = 50.0
	var reward := {} # unlock : Growth LORED
	var step := {} # ["buy iron ore lored"] = Num.new()
	var complete := false
	var icon := {texture = gv.sprite["unknown"], key = "unknown"}
	var can_quit : bool
	var effect_loaded := false
	var color := Color(0,0,0)
	var total_points := Big.new(0)
	func _init(nam : String, des : String, rr : Dictionary, r : Dictionary, stepz : Dictionary, _icon : Dictionary, _color: Color):
		name = nam
		desc = des
		resource_reward = rr
		reward = r
		step = stepz
		icon.key = _icon.key
		icon.texture = _icon.texture
		color = _color
		for x in step:
			total_points.plus(step[x].b)


func new_quest(_quest: Task) -> void:
	
	cur_quest = _quest.name
	
	quest = Task.new(_quest.name, _quest.desc, _quest.resource_reward, _quest.reward, _quest.step, _quest.icon, _quest.color)
	
	content = prefabs.TASK.instance()
	get_node("/root/Root/misc/taq/quest").add_child(content)
	content.init()
	
	#content.rect_position = Vector2(800 - content.rect_size.x - 10, 600 - content.rect_size.y - 10)
