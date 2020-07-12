class_name GlobalVariables
extends Node

# invoke with gv

var overcharge := 1.0
var overcharge_list := []
var hax_pow := 1.0 # 1.0 for normal

const LIMIT_BREAK_COLORS := {
	0: Color(1, 0.328125, 0),
	1: Color(1, 1, 0),
	2: Color(0.664063, 1, 0),
	3: Color(0, 1, 0.765625),
	4: Color(0, 0.4, 1),
	5: Color(0.289063, 0, 1),
	6: Color(0.875, 0, 1),
	7: Color(1, 0, 0.494118),
}



const sprite := {
	"coal" : preload("res://Sprites/resources/coal.png"),
	"stone" : preload("res://Sprites/resources/stone.png"),
	"irono" : preload("res://Sprites/resources/irono.png"),
	"copo" : preload("res://Sprites/resources/copo.png"),
	"iron" : preload("res://Sprites/resources/iron.png"),
	"cop" : preload("res://Sprites/resources/cop.png"),
	"growth" : preload("res://Sprites/resources/growth.png"),
	"conc" : preload("res://Sprites/resources/conc.png"),
	"jo" : preload("res://Sprites/resources/jo.png"),
	"malig" : preload("res://Sprites/resources/malig.png"),
	"tar" : preload("res://Sprites/resources/tar.png"),
	"oil" : preload("res://Sprites/resources/oil.png"),
	
	"tum" : preload("res://Sprites/resources/tum.png"),
	"glass" : preload("res://Sprites/resources/glass.png"),
	"wire" : preload("res://Sprites/resources/wire.png"),
	"pet" : preload("res://Sprites/resources/pet.png"),
	"carc" : preload("res://Sprites/resources/carc.png"),
	"ciga" : preload("res://Sprites/resources/ciga.png"),
	"toba" : preload("res://Sprites/resources/toba.png"),
	"water" : preload("res://Sprites/resources/water.png"),
	
	"hard" : preload("res://Sprites/resources/hard.png"),
	"wood" : preload("res://Sprites/resources/wood.png"),
	"tree" : preload("res://Sprites/resources/tree.png"),
	"axe" : preload("res://Sprites/resources/axe.png"),
	"steel" : preload("res://Sprites/resources/steel.png"),
	"sand" : preload("res://Sprites/resources/sand.png"),
	"plast" : preload("res://Sprites/resources/plast.png"),
	"soil" : preload("res://Sprites/resources/soil.png"),
	"seed" : preload("res://Sprites/resources/seed.png"),
	"paper" : preload("res://Sprites/resources/paper.png"),
	"lead" : preload("res://Sprites/resources/lead.png"),
	"gale" : preload("res://Sprites/resources/gale.png"),
	"liq" : preload("res://Sprites/resources/liq.png"),
	"humus" : preload("res://Sprites/resources/humus.png"),
	"draw" : preload("res://Sprites/resources/draw.png"),
	"pulp" : preload("res://Sprites/resources/pulp.png"),

	"s1" : preload("res://Sprites/tab/t0.png"),
	"s2" : preload("res://Sprites/tab/s2.png"),

	"s1nup" : preload("res://Sprites/tab/s1nup.png"),
	"s1mup" : preload("res://Sprites/tab/s1mup.png"),
	"s2nup" : preload("res://Sprites/tab/s2nup.png"),
	"s2mup" : preload("res://Sprites/tab/s2mup.png"),
	
	# misc
	"hold_true" : preload("res://Sprites/misc/hold_true.png"),
	"hold_false" : preload("res://Sprites/misc/hold_false.png"),
	
	"num" : preload("res://Sprites/misc/num.png"),
	"true" : preload("res://Sprites/misc/bool.png"),
	
	"unknown" : preload("res://Sprites/misc/unknown.png"),
	"copy" : preload("res://Sprites/tab/savetoclipboard.png"),
	
	# upsprites
	"thewitchofloredelith" : preload("res://Sprites/upgrades/thewitchofloredelith.png"),
	"abeewithdaggers" : preload("res://Sprites/upgrades/abeewithdaggers.png"),

	# speech sprites
	"ss oh hi" : preload("res://Sprites/speech/oh_hi.png"),
}

var g := {
	"coal" : LORED,
	"stone" : LORED,
	"irono" : LORED,
	"copo" : LORED,
	"iron" : LORED,
	"cop" : LORED,
	"growth" : LORED,
	"conc" : LORED,
	"jo" : LORED,
	"malig" : LORED,
	"tar" : LORED,
	"oil" : LORED,
	"tum" : LORED,
	"hard" : LORED,
	"wood" : LORED,
	"axe" : LORED,
	"draw" : LORED,
	"wire" : LORED,
	"glass" : LORED,
	"sand" : LORED,
	"steel" : LORED,
	"liq" : LORED,
	"tree" : LORED,
	"water" : LORED,
	"seed" : LORED,
	"soil" : LORED,
	"humus" : LORED,
	"carc" : LORED,
	"plast" : LORED,
	"pet" : LORED,
	"ciga" : LORED,
	"toba" : LORED,
	"paper" : LORED,
	"pulp" : LORED,
	"lead" : LORED,
	"gale" : LORED,
}
var up := {}


var stats : Statistics

class Menu:
	
	# When metastasizing, menu.f = "no s1"
	# when ... chemotherapying, menu.f = "no s2"
	
	var f := "ye"
	var tab := "1"
	var upgrades_owned := {}
	var tabs_unlocked := {}
	var option := {}
var menu := Menu.new()


func time_remaining(
	lored_key: String,
	present_amount: Big,
	total_amount: Big,
	task_or_quest: bool) -> String:
	
	
	var net = gv.g[lored_key].net(true)
	
	if net[1].isLargerThan(net[0]):
		return "-"
	
	net = net[0].minus(net[1])
	
	var less: Big = Big.new(0)
	if not gv.g[lored_key].hold and not task_or_quest:
		for x in gv.g[lored_key].used_by:
			if not gv.g[x].active():
				continue
			less.plus(Big.new(gv.g[x].d.t).multiply(60).divide(gv.g[x].speed.t).multiply(gv.g[x].b[lored_key].t))
	
	if less.isLargerThan(net):
		return "-"
	
	net.minus(less)
	
	if net.isEqualTo(0):
		return "!?"
	
	var delta: Big = Big.new(total_amount).minus(present_amount)
	var incoming_amount := Big.new(0)
	
	
	if not gv.g[lored_key].progress.t.isEqualTo(0):
		var percent_task_complete = Big.new(gv.g[lored_key].progress.f).divide(gv.g[lored_key].progress.t).toFloat()
		incoming_amount.plus(Big.new(gv.g[lored_key].d.t).multiply(percent_task_complete))
	
	var seconds: Big = Big.new(delta).minus(incoming_amount)
	seconds.divide(Big.new(net).divide(1))
	
	return big_to_time(seconds)

func big_to_time(big: Big) -> String:
	
	big = Big.max(big, Big.new(0))
	
	if big.isLessThan(1) or big.toString()[0] == "-":
		return "!"
	
	if big.isLessThan(60):
		return big.roundDown().toString() + "s"
	
	big.divide(60) # minutes
	
	if big.isLessThan(60):
		return big.roundDown().toString() + "m"
	
	big.divide(60) # hours
	
	if big.isLessThan(24):
		return big.roundDown().toString() + "h"
	
	big.divide(24) # days
	
	if big.isLessThan(365):
		return big.roundDown().toString() + "d"
	
	big.divide(365) # years
	
	if big.isLessThan(10):
		return big.roundDown().toString() + "y"
	
	big.divide(10) # decades
	
	if big.isLessThan(100):
		return big.roundDown().toString() + "dec"
	
	big.divide(100) # centuries
	
	if big.isLessThan(1000):
		return big.roundDown().toString() + "cen"
	
	return big.roundDown().toString() + "mil"
