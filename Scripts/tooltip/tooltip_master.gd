extends Node2D

var prefab := {
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



func refresh(currentType: String = type):
	
	if not tip_filled:
		return
	if currentType != type:
		return
	
	var currentOther = other
	_call("no")
	_call(currentType, currentOther)
