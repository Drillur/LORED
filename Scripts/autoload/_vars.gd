class_name GlobalVariables
extends Node

# invoke with gv

var hax_pow := 1.0 # 1.0 for normal

signal limit_break_leveled_up(which) # here -> Limit Break.gd
var lb_xp = Ob.Num.new(1000)
var lb_d = Big.new(1)
var overcharge_list := []

func lb_xp_check():
	
	if lb_xp.f.isLessThan(lb_xp.t):
		return
	
	# level up!
	
	while true:
		
		lb_xp.f.s(lb_xp.t)
		
		lb_d.a(1)
		
		var exponent = Big.new(lb_d).square().toFloat() * 1.5
		lb_xp.t = Big.new("1e" + str(exponent))
		if lb_xp.t.isLessThan(Big.new(lb_d).m(1000)):
			lb_xp.t = Big.new(lb_d).m(1000)
		
		if lb_xp.f.isLessThan(lb_xp.t):
			break
	
	emit_signal("limit_break_leveled_up", "color")

func increase_lb_xp(value, type):
	
	if not type in overcharge_list:
		return
	
	lb_xp.f.a(value)
	lb_xp_check()

# signals are emitted in multiple places but may only be received in one place

signal lored_updated(_lored, _updated_stat) # lored.gd -> lored_master.gd
signal amount_updated(key)
signal net_updated(net)

signal upgrade_purchased(key, routine) # Upgrade Slot.gd -> up_container.gd


const LIMIT_BREAK_COLORS := {
	0: Color(0.121569, 0.819608, 0.376471),
	1: Color(0.156433, 0.910156, 0.85716),
	2: Color(0.020966, 0.607893, 0.894531),
	3: Color(0.398941, 0.569263, 0.972656),
	4: Color(0.374929, 0.340576, 0.96875),
	5: Color(0.449463, 0.199219, 1),
	6: Color(0.54937, 0.123367, 0.902344),
	7: Color(0.828125, 0, 1),
	8: Color(1, 0, 0),
	9: Color(1, 0.375, 0),
	10: Color(0.824219, 0.579529, 0),
	11: Color(1, 0.855957, 0.078125),
	12: Color(1, 1, 0.372549),
	13: Color(0.812012, 1, 0.140625),
	14: Color(0, 1, 0),
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

	"s1n" : preload("res://Sprites/tab/s1n.png"),
	"s1m" : preload("res://Sprites/tab/s1m.png"),
	"s2n" : preload("res://Sprites/tab/s2n.png"),
	"s2m" : preload("res://Sprites/tab/s2m.png"),
	
	# misc
	"haste": preload("res://Sprites/misc/haste.png"),
	"output": preload("res://Sprites/misc/output.png"),
	
	"hold_true" : preload("res://Sprites/misc/hold_true.png"),
	"hold_false" : preload("res://Sprites/misc/hold_false.png"),
	
	"num" : preload("res://Sprites/misc/num.png"),
	"true" : preload("res://Sprites/misc/bool.png"),
	
	"unknown" : preload("res://Sprites/misc/unknown.png"),
	"copy" : preload("res://Sprites/tab/savetoclipboard.png"),
	
	# upsprites
	"thewitchofloredelith" : preload("res://Sprites/upgrades/thewitchofloredelith.png"),
	"abeewithdaggers" : preload("res://Sprites/upgrades/abeewithdaggers.png"),
}

const anim = {
	"tum": preload("res://Sprites/animations/tum.tres"),
	"carc": preload("res://Sprites/animations/carc.tres"),
	"plast": preload("res://Sprites/animations/plast.tres"),
	"pet": preload("res://Sprites/animations/pet.tres"),
	"lead": preload("res://Sprites/animations/lead.tres"),
	"wire": preload("res://Sprites/animations/wire.tres"),
	"draw": preload("res://Sprites/animations/draw.tres"),
	"steel": preload("res://Sprites/animations/steel.tres"),
	"hard": preload("res://Sprites/animations/hard.tres"),
	"axe": preload("res://Sprites/animations/axe.tres"),
	"pulp": preload("res://Sprites/animations/pulp.tres"),
	"soil": preload("res://Sprites/animations/soil.tres"),
	"paper": preload("res://Sprites/animations/paper.tres"),
	"coal" : preload("res://Sprites/animations/coal.tres"),
	"stone" : preload("res://Sprites/animations/stone.tres"),
	"irono" : preload("res://Sprites/animations/irono.tres"),
	"copo" : preload("res://Sprites/animations/copo.tres"),
	"iron" : preload("res://Sprites/animations/iron.tres"),
	"cop" : preload("res://Sprites/animations/cop.tres"),
	"growth" : preload("res://Sprites/animations/growth.tres"),
	"conc" : preload("res://Sprites/animations/conc.tres"),
	"jo" : preload("res://Sprites/animations/jo.tres"),
	"malig" : preload("res://Sprites/animations/malig.tres"),
	"tar" : preload("res://Sprites/animations/tar.tres"),
	"oil" : preload("res://Sprites/animations/oil.tres"),
	"water" : preload("res://Sprites/animations/water.tres"),
	"tree" : preload("res://Sprites/animations/tree.tres"),
	"seed" : preload("res://Sprites/animations/seed.tres"),
	"glass" : preload("res://Sprites/animations/glass.tres"),
	"toba" : preload("res://Sprites/animations/toba.tres"),
	"wood" : preload("res://Sprites/animations/wood.tres"),
	"sand" : preload("res://Sprites/animations/sand.tres"),
	"liq" : preload("res://Sprites/animations/liq.tres"),
	"ciga" : preload("res://Sprites/animations/ciga.tres"),
	"gale" : preload("res://Sprites/animations/gale.tres"),
	"humus" : preload("res://Sprites/animations/humus.tres"),
}

enum G {
	coal,
	stone,
	stone,
	tar,
	malignancy,
	oil,
	growth,
	joules,
	concrete,
	iron,
	copper
	iron_ore,
	copper_ore,
	tumors,
	hard_wood,
	wood,
	axes,
	draw_plate,
	wire,
	glass,
	sand,
	steel,
	liquid_iron
	trees,
	water,
	seeds,
	soil,
	humus,
	carcinogens,
	plastic,
	petroleum,
	cigarettes,
	tobacco,
	paper,
	wood_pulp,
	lead,
	galena
}
var g := {
	"tar" : LORED,
	"malig" : LORED,
	"oil" : LORED,
	"growth" : LORED,
	"jo" : LORED,
	"conc" : LORED,
	"iron" : LORED,
	"cop" : LORED,
	"irono" : LORED,
	"copo" : LORED,
	"coal" : LORED,
	"stone" : LORED,
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

var open_upgrade_folder := "no"


var stats : Statistics

class Menu:
	
	# When metastasizing, menu.f = "no s1"
	# when ... chemotherapying, menu.f = "no s2"
	
	var f := "ye"
	var tab := "1"
	var tab_vertical := [0, 0, 0, 0]
	var upgrades_owned := {}
	var tabs_unlocked := {}
	var option := {}
var menu := Menu.new()


func time_remaining(
	lored_key: String,
	present_amount: Big,
	total_amount: Big,
	task_or_quest: bool) -> String:
	
	
	if gv.g[lored_key].halt:
		return "=/="
	
	
	var net = gv.g[lored_key].net(true)
	
	if net[1].isLargerThan(net[0]):
		return "-"
	
	net = net[0].s(net[1])
	
	var less: Big = Big.new(0)
	if not gv.g[lored_key].hold and not task_or_quest:
		for x in gv.g[lored_key].used_by:
			if not gv.g[x].active():
				continue
			less.a(Big.new(gv.g[x].d.t).m(60).d(gv.g[x].speed.t).m(gv.g[x].b[lored_key].t))
	
	if less.isLargerThan(net):
		return "-"
	
	net.s(less)
	
	if net.isEqualTo(0):
		return "!?"
	
	var delta: Big = Big.new(total_amount).s(present_amount)
	var incoming_amount := Big.new(0)
	
	
	if not gv.g[lored_key].progress.t.isEqualTo(0):
		
		var percent_task_complete = gv.g[lored_key].progress.f.percent(gv.g[lored_key].progress.t)
		
		incoming_amount.a(gv.g[lored_key].d.t)
		incoming_amount.m(percent_task_complete)
	
	return big_to_time(Big.new(delta).s(incoming_amount).d(net))

func big_to_time(big: Big) -> String:
	
	# big should be equal to the amount of seconds required to complete the objective
	
	if big.isLessThan(0):
		big = Big.new(0)
	
	if big.isLessThan(1) or big.toString()[0] == "-":
		return "!"
	
	if big.isLessThan(60):
		return big.roundDown().toString() + "s"
	
	big.d(60) # minutes
	
	if big.isLessThan(60):
		return big.roundDown().toString() + "m"
	
	big.d(60) # hours
	
	if big.isLessThan(24):
		return big.roundDown().toString() + "h"
	
	big.d(24) # days
	
	if big.isLessThan(365):
		return big.roundDown().toString() + "d"
	
	big.d(365) # years
	
	if big.isLessThan(10):
		return big.roundDown().toString() + "y"
	
	big.d(10) # decades
	
	if big.isLessThan(100):
		return big.roundDown().toString() + "dec"
	
	big.d(100) # centuries
	
	if big.isLessThan(1000):
		return big.roundDown().toString() + "cen"
	
	return big.roundDown().toString() + "mil"


class PowersOf10:
	
	var powers := []
	
	func _init():
		
		for x in 3080:
			powers.append(pow(10, x))#(Big.new("1e" + str(x)))
	
	func lookup(power: int):
		
		return powers[power]

var powers_of_10 = PowersOf10.new()


enum R {
	consumed_spirit,
	
}
var r := []

signal cac_leveled_up(key) # class_cacodemon.gd -> Cacodemons.gd
signal cac_xp_gained(key) # class_cacodemon.gd -> Cacodemons.gd
var cac := []

func _ready():
	
	for x in R:
		r.append(Big.new(0))
	
	for x in 100:
		cac.append(Cacodemon.new(x))
