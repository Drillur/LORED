extends Node2D

var prefab := {
	"task step" : preload("res://Prefabs/task/task_step.tscn"),
	"task rr" : preload("res://Prefabs/task/task_rr.tscn"),
	"task r" : preload("res://Prefabs/task/task_r.tscn"),
	"dtext" : preload("res://Prefabs/dtext.tscn"),
	"task complete" : preload("res://Prefabs/lored_buy.tscn"),
	"tooltip" : preload("res://Prefabs/tooltip/tooltip.tscn"),
}
onready var rt = get_owner() 

var tip = 0
var tip_filled := false
var type := "no"
var other: Dictionary

func _call(source : String, _other := {}) -> void:
	
	if tip_filled:
		if is_instance_valid(tip):
			tip.queue_free()
		tip_filled = false
	
	type = source
	other = _other
	
	if type == "no":
		return
	
	tip = prefab["tooltip"].instance()
	add_child(tip)
	tip._call(type, other)
	tip_filled = true



func refresh():
	var _type = type
	var _other = other
	_call("no")
	_call(_type, _other)
