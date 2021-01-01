class_name FPS
extends Reference


var set := true
var always_set := false
var pending := false

var f := 0.0 # current
var t := 0.0 # total (actual)
var b := 0.0 # base


func _init(base: float, _always_set = false):
	
	b = base
	t = base
	
	always_set = _always_set


func process(delta) -> bool:
	
	if f > 0:
		f -= delta
		return false
	
	if not set:
		return false
	
	set = always_set
	f = t
	
	return true
