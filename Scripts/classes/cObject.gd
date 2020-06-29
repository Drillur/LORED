class_name Ob
extends Reference



class Num:
	var f := 0.0 # current value
	var b := 1.0 # base
	var t := 1.0 # total after upgrades/buffs
	func _init(base = 1.0):
		b = base
		t = base
