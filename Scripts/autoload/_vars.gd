class_name GlobalVariables
extends Node

# invoke with gv

var hax_pow := 1.0 # 1.0 for normal
const s3_time := true
const DEFAULT_KEY_LOREDS := ["stone", "conc", "malig", "water", "lead", "tree", "soil", "steel", "wire", "glass", "tum", "wood"]

const PATCH_NOTES := {
	
	# [0] is if there are more changes made than can be listed (> 5)
	# [0] determines if the /more Label node in Patch Version.tscn is visible
	
	"2.2.0": [
		false,
		"Refactored the code for how LOREDs sync upgrade bonuses, resulting in improved performance.",
		"Totally reworked the pacing of Stage 2.",
		"Removed a bunch of boring upgrades."
	],
	
	"2.1.4": [
		false,
		"In save texts, the version is now included in the encrypted code.",
	],
	"2.1.3": [
		false,
		"Definitely fixed the hard reset feature.",
	],
	"2.1.2": [
		false,
		"Once again, permanently fixed hard resetting so that it will always and forever work.",
		"Removed the option to \"increase the FPS of every element by 10x\". Better performance options will come in the future.",
	],
	"2.1.1": [
		false,
		"Fixed a bug where some LORED UI elements would not update correctly.",
		"Hard resetting will now correctly correctly reset everything.",
	],
	"2.1.0": [
		false,
		"Added this patch notes thingy!",
		"Hard resetting will now correctly reset everything.",
	],
	
	"2.0.4": [
		false,
		"LORED autobuyers will now not purchase if any of their ingredient LOREDs are on hold.",
		"Updated the game icon to match the Itch.io thumbnail.",
	],
	"2.0.3": [
		false,
		"Fixed a bug where Metastasizing with both DUNKUS and CHUNKUS owned and active would not turn pending Malignant upgrades into owned upgrades.",
	],
	"2.0.2": [
		false,
		"Fixed bugs that were preventing the game from running.",
	],
	"2.0.1": [
		false,
		"Saves from 2.0 BETA (3) and earlier (until 1.x) will now load properly.",
		"The upgrade menu button will now correctly only appear if the Welcome to LORED quest is complete.",
		"The LORED Discord link has been shifted up in the menu.",
		"Shadows on the Quest element and the Menu button have been reduced to not overlap the red line by them.",
	],
	"2.0.0": [
		true,
		"Limit Break has been re-worked.",
		"LORED and upgrade UI have been re-designed.",
		"Many performance improvements have been made.",
		"Base resolution increased from 800x600 to 1024x768.",
		"Water demands have been reduced.",
	],
}


const loreds_required_for_s2_autoup_upgrades_to_begin_purchasing := ["seed", "tree", "water", "soil", "humus", "sand", "glass", "liq", "steel", "hard", "axe", "wood", "draw","wire"]
var s2_upgrades_may_be_autobought := false

func check_for_the_s2_shit():
	if s2_upgrades_may_be_autobought:
		return
	for x in loreds_required_for_s2_autoup_upgrades_to_begin_purchasing:
		if not g[x].active:
			return
	s2_upgrades_may_be_autobought = true

const PREFAB := {
	"flash": preload("res://Prefabs/Flash.tscn")
}

signal limit_break_leveled_up(which) # here -> Limit Break.gd
var lb_xp = Ob.Num.new(1000)

func reset_lb():
	lb_xp = Ob.Num.new(1000)
	up["Limit Break"].effects[0].effect.t = Big.new()
func lb_xp_check():
	
	if lb_xp.f.isLessThan(lb_xp.t):
		return
	
	# level up!
	
	while true:
		
		lb_xp.f.s(lb_xp.t)
		
		up["Limit Break"].effects[0].effect.a.a(1)
		
		var exponent = Big.new(up["Limit Break"].effects[0].effect.a).a(1).square().toFloat() * 1.5
		lb_xp.t = Big.new("1e" + str(exponent))
		if lb_xp.t.isLessThan(Big.new(up["Limit Break"].effects[0].effect.a).m(1000)):
			lb_xp.t = Big.new(up["Limit Break"].effects[0].effect.a).m(1000)
		
		if lb_xp.f.isLessThan(lb_xp.t):
			break
	
	up["Limit Break"].effects[0].effect.sync()
	
	for x in stats.g_list["s1"] + stats.g_list["s2"]:
		g[x].d.lbm = up["Limit Break"].effects[0].effect.t
		g[x].d.sync()
		emit_signal("lored_updated", x, "d")
	
	emit_signal("limit_break_leveled_up", "color")

func increase_lb_xp(value):
	
	if not gv.up["Limit Break"].active():
		return
	
	lb_xp.f.a(value)
	lb_xp_check()

# signals are emitted in multiple places but may only be received in one place

signal lored_updated(_lored, _updated_stat) # LORED.gd -> LORED List.gd
signal amount_updated(key) # LORED.gd -> resources.gd
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
	"embryo" : preload("res://Sprites/resources/carc.png"),
	"bone" : preload("res://Sprites/resources/carc.png"),
	"blood" : preload("res://Sprites/resources/carc.png"),
	"spirit" : preload("res://Sprites/resources/carc.png"),
	
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
const COLORS := {
	"ciga": Color(0.929412, 0.584314, 0.298039),
	"toba": Color(0.639216, 0.454902, 0.235294),
	"plast": Color(0.85, 0.85, 0.85),
	"pulp": Color(0.94902, 0.823529, 0.54902),
	"paper": Color(0.792157, 0.792157, 0.792157),
	"lead": Color(0.53833, 0.714293, 0.984375),
	"gale": Color(0.701961, 0.792157, 0.929412),
	"coal": Color(0.7, 0, 1),
	"stone": Color(0.79, 0.79, 0.79),
	"irono": Color(0, 0.517647, 0.905882),
	"copo": Color(0.7, 0.33, 0),
	"iron": Color(0.07, 0.89, 1),
	"cop": Color(1, 0.74, 0.05),
	"growth": Color(0.79, 1, 0.05),
	"jo": Color(1, 0.98, 0),
	"conc": Color(0.35, 0.35, 0.35),
	"malig": Color(0.88, .12, .35),
	"tar": Color(.56, .44, 1),
	"soil": Color(0.737255, 0.447059, 0),
	"oil": Color(.65, .3, .66),
	"tum": Color(1, .54, .54),
	"glass": Color(0.81, 0.93, 1.0),
	"wire": Color(0.9, 0.6, 0.14),
	"seed": Color(1, 0.878431, 0.431373),
	"abeewithdaggers": Color(1, 0.878431, 0.431373),
	"sand": Color(.87, .70, .45),
	"wood": Color(0.545098, 0.372549, 0.015686),
	"water": Color(0.14902, 0.52549, 0.792157),
	"tree": Color(0.772549, 1, 0.247059),
	"pet": Color(0.76, 0.53, 0.14),
	"axe": Color(0.691406, 0.646158, 0.586075),
	"hard": Color(0.92549, 0.690196, 0.184314),
	"carc": Color(0.772549, 0.223529, 0.192157),
	"steel": Color(0.607843, 0.802328, 0.878431),
	"draw": Color(0.333333, 0.639216, 0.811765),
	"liq": Color(0.27, 0.888, .9),
	"humus": Color(0.458824, 0.25098, 0),
	
	"thewitchofloredelith": Color(0.937255, 0.501961, 0.776471),
	"s1n": Color(0.733333, 0.458824, 0.031373),
	"s1m": Color(0.878431, 0.121569, 0.34902),
	"s2n": Color(0.47451, 0.870588, 0.694118),
	"s2m": Color(1, 0.541176, 0.541176),
	"s1": Color(0.8, 0.8, 0.8),
	"s2": Color(0.8, 0.8, 0.8),
	"s3": Color(0.8, 0.8, 0.8),
	"s4": Color(0.8, 0.8, 0.8),
	"copy": Color(0.8, 0.8, 0.8),
	"grey": Color(0.8, 0.8, 0.8),
}

var open_upgrade_folder := "no"


var stats : Statistics

class Menu:
	
	# When metastasizing, menu.f = "no s1"
	# when ... chemotherapying, menu.f = "no s2"
	
	var f := "ye"
	var tab := "1"
	var tab_vertical := [0, 0, 0, 0]
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
	
	
	if not gv.g[lored_key].progress.t == 0.0:
		
		var percent_task_complete = gv.g[lored_key].progress.f / gv.g[lored_key].progress.t
		
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

var r := {
	"spirit": Big.new(0),
	"blood": Big.new(0),
	"embryo": Big.new(0),
	"bone": Big.new(0),
}
var color := {
	"spirit": Color(0.9,0.9,0.9),
}

signal cac_leveled_up(key) # class_cacodemon.gd -> Cacodemons.gd
signal cac_fps(fps_key, key) # class_cacodemon.gd -> Cacodemons.gd
signal cac_consumed # class_cacodemon.gd -> Cacodemons.gd
signal cac_slain(key) # class_cacodemon.gd -> Cacodemons.gd

func increase_cac_cost():
	
	cac_cost["blood"].m(3)
	cac_cost["bone"].m(3)
	
	if cac_cost["embryo"].isLessThan(10):
		cac_cost["embryo"].a(cacodemons - 1)
	else:
		cac_cost["embryo"].m(1.1)
	
	if cac_cost["embryo"].isLessThan(100):
		cac_cost["embryo"].roundDown()

var cac := []
var cacodemons = 0
var cac_cost := {
	"embryo": Big.new(1),
	"blood": Big.new(1000),
	"bone": Big.new(100),
}

func _ready():
	
	randomize()
	
	for x in g:
		r[x] = Big.new(0)
	
	for x in 100:
		cac.append(Cacodemon.new(x))
