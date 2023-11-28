class_name Persist
extends Resource



var s1 := LoudBool.new(false)
var s2 := LoudBool.new(false)
var s3 := LoudBool.new(false)
var s4 := LoudBool.new(false)

var highest := 0



func _init() -> void:
	s1.changed.connect(set_highest)
	s2.changed.connect(set_highest)
	s3.changed.connect(set_highest)
	s4.changed.connect(set_highest)



# - Signal Receivers


func set_highest() -> void:
	if s4.is_true():
		highest = 4
	elif s3.is_true():
		highest = 3
	elif s2.is_true():
		highest = 2
	elif s1.is_true():
		highest = 1
	else:
		highest = 0



# - Get


func through_stage(_stage: Stage.Type) -> bool:
	return highest >= _stage
