class_name UpgradeChain
extends Reference

var desc: String # desc for the reward for completing the chain
var chain_keys: Array
var effects := []

func _init(_desc: String, upgrades_in_chain: Array):
	
	desc = _desc
	chain_keys = upgrades_in_chain

func apply():
	for e in effects:
		e.apply()
func remove():
	for e in effects:
		e.remove()
