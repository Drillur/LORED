extends Node2D

onready var tip_lored_prefab = preload("res://Prefabs/tooltip/tip_lored.tscn")
onready var tip_halt_prefab = preload("res://Prefabs/tooltip/tip_halt.tscn")
onready var tip_hold_prefab = preload("res://Prefabs/tooltip/tip_hold.tscn")
onready var tip_upgrade = preload("res://Prefabs/tooltip/tip_upgrade.tscn")
onready var task_tip = preload("res://Prefabs/tooltip/task_tip.tscn")
var prefab := {
	"task" : preload("res://Prefabs/task/task.tscn"),
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

func _call(source : String, other := {}) -> void:
	
	if tip_filled:
		if is_instance_valid(tip):
			tip.queue_free()
		tip_filled = false
	
	type = source
	
	if type == "no":
		return
	
	tip = prefab["tooltip"].instance()
	add_child(tip)
	tip._call(type, other)
	tip_filled = true


