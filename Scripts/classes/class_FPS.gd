class_name FPS
extends Reference


var set := false

var f := 0.0 # current
var t := 0.0 # total (actual)
var b := 0.0 # base


func _init(base: float):
	
	b = base
	t = base
