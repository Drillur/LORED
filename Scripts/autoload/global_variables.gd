class_name GlobalVariables
extends Node

# invoke with gv

var overcharge := 1.0
var overcharge_list := []
var hax_pow := 2.0 # 1.0 for normal

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

var g := {}
var up := {}


var stats : Statistics
