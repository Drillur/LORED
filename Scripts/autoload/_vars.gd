class_name GlobalVariables
extends Node

# invoke with gv

const hax_pow := 1.0 # 1.0 for normal
var fps: float
const PLATFORM = "pc" # keep lower-case # "browser", "pc"
const dev_mode := false
const test_s3 := false
const DEFAULT_KEY_LOREDS := ["stone", "conc", "malig", "water", "lead", "tree", "soil", "steel", "wire", "glass", "tum", "wood"]

const PATCH_NOTES := {
	
	# [0] is if there are more changes made than can be listed (> 5)
	# [0] determines if the /more Label node in Patch Version.tscn is visible
	
#	 "3.0.0": [
#		false,
#		"LOREDs now think out-loud and may speak to each other.",
#	],
	
	"2.2.16": [
		"Offline earnings have been removed; Offline Boost has been added. Check out the tooltip of the offline boost HUD for more info.",
		"Fixed an issue that was causing the game to freeze after resetting.",
		"The zoom slider can no longer be altered with the mouse wheel.",
	],
	
	"2.2.15": [
		"Changed button UI on upgrades and LOREDs. The intent is to make LORED upgrade buttons more clear, and to make it easier to tell when you can afford to upgrade a LORED or purchase an upgrade.",
		"Improved the color blind mode. When enabled, LORED upgrade buttons and now also upgrade buttons have a checkbox that display when you can afford them.",
		"Squished some buggies.",
	],
	
	"2.2.14": [
		"Fixed a bug that prevented the Windows version from importing saves.",
		"Working on improving button design; changes made to upgrade and LORED upgrade buttons are WIP.",
	],
	
	"2.2.13": [
		"Offline earnings reduced from 1.0x to 0.25x.",
		"Adjusted autobuyer logic. (Pretty sure it was busted from a change made in 2.2.8.)",
		"Updated autobuyer tooltips!",
		"Updated upgrade tooltips!",
		"Fixed various bugs.",
	],
	
	"2.2.12": [
		"LOREDs no longer randomly freeze!",
	],
	
	"2.2.11": [
		"The Pulp LORED is no longer being bullied.",
	],
	
	"2.2.10": [
		"LOREDs now take the proper amount of resources, instead of 1.",
		"Flying numbers no longer appear in the browser version, as they are too laggy.",
	],
	
	"2.2.9": [
		"Fixed the base fuel storage amounts of every LORED.",
	],
	
	"2.2.8": [
		"Attempted to fix a game-breaking issue.",
	],
	
	"2.2.7": [
		"The game no longer needs to be paused to select which Malignant or Radiative upgrades you want to purchase. Simply buy them as you go, and then to activate them, reset whenever you're ready.",
		"Tasks no longer become incompletable.",
		"You can no longer get a task for a LORED that cannot produce any resources. Example: Growth, before you've unlocked Joules.",
		"After hard-resetting, you can no longer get a task for a LORED that you had unlocked in the previous save (until you unlock it again).",
		"Balanced the difficulty and rewards of tasks.",
		"LORED tooltips have been updated.",
		"Progress bars no longer stutter or flash. :thumbsup:",
		"Animations no longer stutter or flash. The Water LORED's animation has been fixed, too. :otherthumbsup:",
		"Fixed timers!",
	],
	
	"2.2.6": [
		"Fixed a bug where tasks would not get removed upon a hard reset.",
		"Fixed a bug where turning in A Million Reasons to Grind would crash the game.",
	],
	
	"2.2.5": [
		"Changed the base resolution to 1280x720.",
		"The stretch mode of the entire game has changed to maintain its aspect ratio.",
	],
	
	"2.2.4": [
		"Added a zoom option in the menu!",
		"The under-the-hood workings of the script that runs tasks and quests has been re-written, so Tasks and Quests have received a fresh UI update!",
		"Fixed a bug preventing access to Extra-normal upgrades.",
		"Fixed a bunch of issues with the progress bars flashing or resetting prematurely.",
		"Fixed an issue that allowed users to purchase Malignant or Radiative upgrades when they should not have been able to.",
	],
	
	"2.2.3": [
		"Might have fixed an issue causing a crash when Metastasizing?",
		"Possibly fixed some more softlocks.",
		"Fixed a bug that prevented autobuyers from working when LOREDs are level 0.",
		"The option to enable or disable animations has been fixed.",
		"Polished some tooltips and fixed the accuracy of some values in tooltips.",
	],
	
	"2.2.2": [
		"Fixed a bug that was preventing some saves from loading.",
		"Fixed inflated per-second values. They should now be accurate!",
	],
	
	"2.2.1": [
		"Added an option called \"Afford check\" that will make it much clearer when you can afford to upgrade a LORED.",
		"As for performance, the FPS dropdown has returned. Please try 5 FPS if your framerate is already 5 because maybe then it will be 6.",
		"Additionally, many unnecessary loops and physics_process methods across the code have been removed.",
		"Stage 3 is on the horizon, finally! Woo!"
	],
	
	"2.2.0": [
		"Refactored the code for how LOREDs sync upgrade bonuses, resulting in improved performance.",
		"Totally reworked the pacing of Stage 2.",
		"Removed a bunch of boring upgrades."
	],
	
	"2.1.4": [
		"In save texts, the version is now included in the encrypted code.",
	],
	"2.1.3": [
		"Definitely fixed the hard reset feature.",
	],
	"2.1.2": [
		"Once again, permanently fixed hard resetting so that it will always and forever work.",
		"Removed the option to \"increase the FPS of every element by 10x\". Better performance options will come in the future.",
	],
	"2.1.1": [
		"Fixed a bug where some LORED UI elements would not update correctly.",
		"Hard resetting will now correctly correctly reset everything.",
	],
	"2.1.0": [
		"Added this patch notes thingy!",
		"Hard resetting will now correctly reset everything.",
	],
	
	"2.0.4": [
		"LORED autobuyers will now not purchase if any of their ingredient LOREDs are on hold.",
		"Updated the game icon to match the Itch.io thumbnail.",
	],
	"2.0.3": [
		"Fixed a bug where Metastasizing with both DUNKUS and CHUNKUS owned and active would not turn pending Malignant upgrades into owned upgrades.",
	],
	"2.0.2": [
		"Fixed bugs that were preventing the game from running.",
	],
	"2.0.1": [
		"Saves from 2.0 BETA (3) and earlier (until 1.x) will now load properly.",
		"The upgrade menu button will now correctly only appear if the Welcome to LORED quest is complete.",
		"The LORED Discord link has been shifted up in the menu.",
		"Shadows on the Quest element and the Menu button have been reduced to not overlap the red line by them.",
	],
	"2.0.0": [
		"Limit Break has been re-worked.",
		"LORED and upgrade UI have been re-designed.",
		"Many performance improvements have been made.",
		"Base resolution increased from 800x600 to 1024x768.",
		"Water demands have been reduced.",
	],
}


func _ready():
	
	randomize()
	
	for x in g:
		r[x] = Big.new(0)
	
	for x in 10:
		cac.append(Cacodemon.new(x))
	
	for x in SpellID:
		spells.append(Spell.new(x))


const loreds_required_for_s2_autoup_upgrades_to_begin_purchasing := ["seed", "tree", "water", "soil", "humus", "sand", "glass", "liq", "steel", "hard", "axe", "wood", "draw","wire"]
var s2_upgrades_may_be_autobought := false

var fresh_run := true

func check_for_the_s2_shit():
	if s2_upgrades_may_be_autobought:
		return
	for x in loreds_required_for_s2_autoup_upgrades_to_begin_purchasing:
		if not g[x].active:
			return
	s2_upgrades_may_be_autobought = true
	get_node("/root/Root").unlock_tab("s2n")

const SRC := {
	"alert": preload("res://Prefabs/alert.tscn"),
	"emote": preload("res://Prefabs/lored/Emote.tscn"),
	"flash": preload("res://Prefabs/Flash.tscn"),
	
	"task": preload("res://Prefabs/task/Task.tscn"),
	"task entry": preload("res://Prefabs/tooltip/tip_lored_task_entry.tscn"),
	"unholy body manager": preload("res://Prefabs/lored/necro bar.tscn"),
	"unholy body manager bar": preload("res://Prefabs/lored/Necro Unholy Body Bar.tscn"),
	"upgrade block": preload("res://Prefabs/tooltip/upgrade_block.tscn"),
	
	"price": preload("res://Prefabs/tooltip/price.tscn"),
	
	"tooltip/LORED": preload("res://Prefabs/tooltip/LORED.tscn"),
	"tooltip/autobuyer": preload("res://Prefabs/tooltip/AutobuyerTooltip.tscn"),
	"tooltip/upgrade": preload("res://Prefabs/tooltip/Upgrade Tooltip.tscn"),
	"tooltip/offline boost": preload("res://Prefabs/tooltip/Off Tooltip.tscn"),
	
	"label": preload("res://Prefabs/template/Label.tscn"),
	"job label": preload("res://Prefabs/template/job label.tscn"),
	"button label": preload("res://Prefabs/template/Button Label.tscn"),
}

signal limit_break_leveled_up(which) # here -> Limit Break.gd
var lb_xp = Ob.Num.new(1000)

func reset_lb():
	lb_xp = Ob.Num.new(1000)
	up["Limit Break"].effects[0].effect.t = Big.new()
	up["Limit Break"].sync_effects()
func lb_xp_check():
	
	if lb_xp.f.less(lb_xp.t):
		return
	
	# level up!
	
	while true:
		
		lb_xp.f.s(lb_xp.t)
		
		up["Limit Break"].effects[0].effect.a.a(1)
		
		var exponent = Big.new(up["Limit Break"].effects[0].effect.a).a(1).square().toFloat() * 1.5
		lb_xp.t = Big.new("1e" + str(exponent))
		if lb_xp.t.less(Big.new(up["Limit Break"].effects[0].effect.a).m(1000)):
			lb_xp.t = Big.new(up["Limit Break"].effects[0].effect.a).m(1000)
		
		if lb_xp.f.less(lb_xp.t):
			break
	
	up["Limit Break"].sync_effects()
	
	for x in stats.g_list["s1"] + stats.g_list["s2"]:
		g[x].d.lbm = up["Limit Break"].effects[0].effect.t
		g[x].d.sync()
	
	emit_signal("limit_break_leveled_up", "color")

func increase_lb_xp(value):
	
	if not gv.up["Limit Break"].active():
		return
	
	lb_xp.f.a(value)
	lb_xp_check()

# signals are emitted in multiple places but may only be received in one place

signal autobuyer_purchased(key) # -> LORED.gd
signal amount_updated(key) # LORED.gd -> resources.gd
signal net_updated(net)
signal quest_reward(type_key, other_key) # -> Root.gd

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
	
	"mana" : preload("res://Sprites/upgrades/thewitchofloredelith.png"),
	"embryo" : preload("res://Sprites/resources/carc.png"),
	"nearly dead" : preload("res://Sprites/resources/carc.png"),
	"terror" : preload("res://Sprites/resources/carc.png"),
	"corpse" : preload("res://Sprites/resources/carc.png"),
	"bone" : preload("res://Sprites/resources/carc.png"),
	"spirit" : preload("res://Sprites/resources/carc.png"),
	"bagged beast" : preload("res://Sprites/resources/carc.png"),
	"beast body" : preload("res://Sprites/resources/carc.png"),
	"exsanguinated beast" : preload("res://Sprites/resources/carc.png"),
	"meat" : preload("res://Sprites/resources/carc.png"),
	"fur" : preload("res://Sprites/resources/carc.png"),
	
	"hunt" : preload("res://Sprites/resources/carc.png"),
	"blood" : preload("res://Sprites/resources/carc.png"),
	"necro" : preload("res://Sprites/resources/carc.png"),
	"witch" : preload("res://Sprites/upgrades/thewitchofloredelith.png"),
	
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
	"s3n" : preload("res://Sprites/tab/s2n.png"),
	"s3m" : preload("res://Sprites/tab/s2m.png"),
	"s4n" : preload("res://Sprites/tab/s2n.png"),
	"s4m" : preload("res://Sprites/tab/s2m.png"),
	
	# misc
	"hold_true" : preload("res://Sprites/misc/hold_true.png"),
	"hold_false" : preload("res://Sprites/misc/hold_false.png"),
	
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

var quest: Array
var g := { #DO NOT RE-ARRANGE. ui depends on them being like this
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
	
	"hunt": LORED,
	"blood": LORED,
	"necro": LORED,
	"witch": LORED,
}
var up := {}
var chains := {}

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
	"water": Color(0, 0.647059, 1),
	"tree": Color(0.772549, 1, 0.247059),
	"pet": Color(0.76, 0.53, 0.14),
	"axe": Color(0.691406, 0.646158, 0.586075),
	"hard": Color(0.92549, 0.690196, 0.184314),
	"carc": Color(0.772549, 0.223529, 0.192157),
	"steel": Color(0.607843, 0.802328, 0.878431),
	"draw": Color(0.333333, 0.639216, 0.811765),
	"liq": Color(0.27, 0.888, .9),
	"humus": Color(0.458824, 0.25098, 0),
	
	"hunt": Color(0.88, .12, .35),
	"necro": Color(0.88, .12, .35),
	"witch": Color(0.937255, 0.501961, 0.776471),
	
	"spirit": Color(0.88, .12, .35),
	"mana": Color(0.721569, 0.352941, 0.905882),
	
	"flayed corpse": Color(0.88, .12, .35),
	"defiled dead": Color(0.88, .12, .35),
	"corpse": Color(0.88, .12, .35),
	"nearly dead": Color(0.88, .12, .35),
	"flesh": Color(0.88, .12, .35),
	"terror": Color(0.88, .12, .35),
	"embryo": Color(0.88, .12, .35),
	"blood": Color(0.88, 0, 0),
	"bone": Color(0.88, .12, .35),
	"wax": Color(0.88, .12, .35),
	"fur": Color(0.88, .12, .35),
	"meat": Color(0.88, .12, .35),
	"bagged beast": Color(0.88, .12, .35),
	"beast body": Color(0.88, .12, .35),
	"exsanguinated beast": Color(0.88, .12, .35),
	
	"thewitchofloredelith": Color(0.937255, 0.501961, 0.776471),
	"spike": Color(0.76, 0, 0),
	"rare": Color(0.93, .84, 0),
	"common": Color(0.35, 0.35, 0.35),
	"s1n": Color(0.733333, 0.458824, 0.031373),
	"s1m": Color(0.878431, 0.121569, 0.34902),
	"s2n": Color(0.47451, 0.870588, 0.694118),
	"s2m": Color(1, 0.541176, 0.541176),
	"s1": Color(0.878431, 0.121569, 0.34902),
	"s2": Color(1, 0.541176, 0.541176),
	"s3": Color(0.8, 0.8, 0.8),
	"s4": Color(0.8, 0.8, 0.8),
	"copy": Color(0.8, 0.8, 0.8),
	"grey": Color(0.8, 0.8, 0.8),
}

var open_upgrade_folder := "no"


var stats : Statistics

class Menu:
	var tab := "1"
	var tab_vertical := [0, 0, 0, 0]
	var option := {}
var menu := Menu.new()


func time_remaining(
	lored_key: String,
	present_amount: Big,
	total_amount: Big) -> String:
	
	
	if gv.g[lored_key].halt:
		return "Halt"
	
	
	var net = gv.g[lored_key].net()
	
	if net[1].greater(net[0]):
		return "-"
	
	net = net[0].s(net[1])
	
	if net.equal(0):
		return "!?"
	
	var delta: Big = Big.new(total_amount).s(present_amount)
	var incoming_amount := Big.new(0)
	
	
	if gv.g[lored_key].working:
		incoming_amount.a(gv.g[lored_key].d.t)
	
	return parse_time(Big.new(delta).s(incoming_amount).d(net))

func parse_time(value) -> String:
	
	if typeof(value) == TYPE_OBJECT:
		return parse_time_big(value)
	else:
		return parse_time_float(value)

func parse_time_big(big: Big) -> String:
	
	# big should be equal to the amount of seconds required to complete the objective
	
	if big.less(0):
		big = Big.new(0)
	
	if big.less(1) or big.toString()[0] == "-":
		return "!"
	
	if big.less(60):
		return big.roundDown().toString() + "s"
	
	big.d(60) # minutes
	
	if big.less(60):
		return big.roundDown().toString() + "m"
	
	big.d(60) # hours
	
	if big.less(24):
		return big.roundDown().toString() + "h"
	
	big.d(24) # days
	
	if big.less(365):
		return big.roundDown().toString() + "d"
	
	big.d(365) # years
	
	if big.less(10):
		return big.roundDown().toString() + "y"
	
	big.d(10) # decades
	
	if big.less(100):
		return big.roundDown().toString() + "dec"
	
	big.d(100) # centuries
	
	if big.less(1000):
		return big.roundDown().toString() + "cen"
	
	return big.roundDown().toString() + "mil"

func parse_time_float(val: float) -> String:
	
	if val < 1:
		return "!"
	
	if val < 60:
		return str(floor(val)) + "s"
	
	val /= 60
	
	if val < 60:
		return str(floor(val)) + "m"
	
	val /= 60
	
	if val < 24:
		return str(floor(val)) + "h"
	
	val /= 24
	
	if val < 365:
		return str(floor(val)) + "d"
	
	val /= 365
	
	if val < 10:
		return str(floor(val)) + "y"
	
	val /= 10
	
	if val < 100:
		return str(floor(val)) + "dec"
	
	val /= 100
	
	if val < 1000:
		return str(floor(val)) + "cen"
	
	return str(floor(val)) + "mil"

#class PowersOf10:
#
#	var powers := []
#
#	func _init():
#
#		for x in 3080:
#			powers.append(pow(10, x))#(Big.new("1e" + str(x)))
#
#	func lookup(power: int):
#
#		return powers[power]
#
#var powers_of_10 = PowersOf10.new()

var r := {
	"spirit": Big.new(0),
	"blood": Big.new(0),
	"embryo": Big.new(0),
	"bone": Big.new(0),
	"flesh": Big.new(0),
	"nearly dead": Big.new(0),
	"corpse": Big.new(0),
	"flayed corpse": Big.new(0),
	"unholy body": Big.new(0),
	"defiled dead": Big.new(0),
	"terror": Big.new(0),
	"wax": Big.new(0),
	"fur": Big.new(0),
	"meat": Big.new(0),
	"bagged beast": Big.new(0),
	"processed beast": Big.new(0),
	"exsanguinated beast": Big.new(0),
}

signal cac_leveled_up(key) # class_cacodemon.gd -> Cacodemons.gd
signal cac_fps(fps_key, key) # class_cacodemon.gd -> Cacodemons.gd
signal cac_slain(key) # class_cacodemon.gd -> Cacodemons.gd

signal item_produced(key) # somewhere -> Inventory.gd

func increase_cac_cost():
	
	cac_cost["blood"].m(300)
	cac_cost["bone"].m(300)
	
	if cac_cost["embryo"].less(10):
		cac_cost["embryo"].a(cacodemons - 1)
	else:
		cac_cost["embryo"].m(1.1)
	
	if cac_cost["embryo"].less(100):
		cac_cost["embryo"].roundDown()

var cac := []
var cacodemons = 0
var cac_cost := {
	"embryo": Big.new(1),
	"blood": Big.new(100),
	"bone": Big.new(25),
}
var cac_chance_mod := Ob.Num.new(1)
var spells := []
enum SpellID {
	HEX, # gives witch boon to random lored
	STIM, # gives random s3 resources -- upgrades allow it to give any requested resource in any Cost tooltip
}
enum Item {
	MANA, 
	BITS, PIECES, PARTS, PORTIONS, # parts, pieces, and portions cost bits.
	CRUMBS, SLICES, SAMPLES, SHARDS, # shards, samples, and slices cost crumbs.
}
enum Quest {
	
	# DO NOT REARRANGE.
	# !!! Add new quests at the BOTTOM !!!
	
	# s1
	INTRO,
	MORE_INTRO,
	WELCOME_TO_LORED,
	UPGRADES,
	TASKS,
	PRETTY_WET,
	PROGRESS,
	ELECTRICY,
	SANDY_PROGRESS,
	SPREAD,
	LOTS_OF_TASKS,
	CONSUME,
	EVOLVE,
	A_MILLION_REASONS_TO_GRIND,
	THE_LOOP,
	
	# s2
	A_NEW_LEAF,
	STEEL_PATTERN, WIRE_TRAIL, HARDWOOD_CYCLE, GLASS_PASS,
	THE_HEART_OF_THINGS,
	SPIKE,
	LEAD_BY_EXAMPLE,
	PAPER_OR_PLASTIC,
	CARCINOGENIC,
	CRINGEY_PROGRESS,
	CANCER_LORD,
	HORSE_DOODIE,
	
	# s3
	A_DARK_DISCOVERY,
	HUNT, WITCH, BLOOD, NECRO,
	
	# add new quests here
	
	# auto
	RANDOM,
	RANDOM_COMMON,
	RANDOM_RARE,
	RANDOM_SPIKE
	
	# do not add new quests here.
}
enum QuestReward {
	NEW_LORED,
	RESOURCE,
	UPGRADE_MENU,
	STAGE,
	UPGRADE_LORED,
	MAX_TASKS,
	OTHER,
}
enum TaskRequirement {
	RESOURCE_PRODUCTION,
	SPELL_CAST,
	RARE_OR_SPIKE_TASKS_COMPLETED,
	TASKS_COMPLETED,
	UPGRADE_PURCHASED,
	UPGRADES_PURCHASED,
	LORED_UPGRADED,
}
enum Job{
	BORER_DIG,
	FURNACE_COOK,
}

var item_names := [
	"mana", "bits", "pieces", "parts", "portions", "crumbs","slices","samples","shards",
]
var active_buffs := []
enum Buff {
	HEX,
}
var spell_materials := {
	"hex": {"mana": 1, "candle": 3, "orchid root": 1},
}
signal buff_spell_cast(spell, target) # LORED.gd -> LORED List.gd

var unholy_bodies := {}
var latest_unholy_body: int # key
var ub_count := 0
signal new_unholy_body(amount) # -> Unholy Body Manager.gd

var animationless = ["hard", "draw", "carc", "tum", "axe", "wire", "soil", "pet", "paper", "lead", "steel", "plast", "pulp"]
var max_frame = {
	"humus":  9,
	"gale":  22,
	"ciga":  25,
	"liq":  22,
	"sand":  45,
	"wood":  49,
	"toba":  73,
	"glass":  37,
	"seed": 30,
	"tree":  77,
	"water": 25,
	"coal":  25,
	"stone":  27,
	"irono":  28,
	"copo":  25,
	"iron":  47,
	"cop":  30,
	"growth":  40,
	"conc":  57,
	"jo":  32,
	"malig":  36,
	"tar":  29,
	"oil":  8,
}

var off_boost := false
var offline_time := 0.0
var off_boost_time: float
var off_d := 1.0
var off_locked := false
var receives_off_boost := [
	false,
	false,
	false,
	false
]
