extends Node2D

onready var tip_lored_prefab = preload("res://Prefabs/tooltip/tip_lored.tscn")
onready var price_prefab = preload("res://Prefabs/price.tscn")
onready var fuel_prefab = preload("res://Prefabs/fuel.tscn")
onready var tip_halt_prefab = preload("res://Prefabs/tooltip/tip_halt.tscn")
onready var tip_hold_prefab = preload("res://Prefabs/tooltip/tip_hold.tscn")
onready var tip_upgrade = preload("res://Prefabs/tooltip/tip_upgrade.tscn")
onready var task_tip = preload("res://Prefabs/tooltip/task_tip.tscn")
const prefab := {}
onready var rt = get_owner() 

var tip = 0
var tip_filled := false
var type := "no"

func _ready():
	
	prefab["task"] = preload("res://Prefabs/task/task.tscn")
	prefab["task step"] = preload("res://Prefabs/task/task_step.tscn")
	prefab["task rr"] = preload("res://Prefabs/task/task_rr.tscn")
	prefab["task r"] = preload("res://Prefabs/task/task_r.tscn")
	prefab["dtext"] = preload("res://Prefabs/dtext.tscn")
	prefab["task complete"] = preload("res://Prefabs/lored_buy.tscn")
	prefab["tooltip"] = preload("res://Prefabs/tooltip/tooltip.tscn")

func _call(source : String, color := Color(1,1,1)) -> void:
	
	if tip_filled:
		if is_instance_valid(tip):
			tip.queue_free()
		tip_filled = false
	
	type = source
	
	if type == "no":
		return
	
	tip = prefab["tooltip"].instance()
	add_child(tip)
	tip._call(type,color)
	tip_filled = true


