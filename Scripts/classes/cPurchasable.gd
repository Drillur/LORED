class_name Purchasable
extends "res://Scripts/classes/cObject.gd"


var name: String
var type: String
var cost := {}
var key = 0


func cost_check() -> bool:
	# returns true if can be afforded
	for x in cost:
		if gv.g[x].r.isLessThan(cost[x].t):
			return false
	return true
