class_name Purchasable
extends "res://Scripts/classes/Object.gd"


var name: String
var type: String
var stage: String # "1", "3"
var cost := {}
var key = 0

var autobuy := false


func cost_check() -> bool:
	# returns true if can be afforded
	for x in cost:
		if gv.resource[x].less(cost[x].t):
			return false
	return true

func sync_cost():
	for c in cost:
		cost[c].sync()

func reset_cost():
	for c in cost:
		cost[c].reset()
