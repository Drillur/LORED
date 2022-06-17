class_name GlobalVariables
extends Node




const hax_pow := 1.0 # 1.0 for normal
var fps: float
const PLATFORM := "pc" # keep lower-case # "browser", "pc"
const dev_mode := true
const DEFAULT_KEY_LOREDS := ["stone", "conc", "malig", "water", "lead", "tree", "soil", "steel", "wire", "glass", "tum", "wood"]

const PATCH_NOTES := {

#	 "3.0.0": [
#		"Added a main menu with save management.",
#		"Added difficulty options.",
#		"Merged quests and tasks into Wishes."
#		"LOREDs now think out-loud and may speak to each other.",
#	],
	
	"2.2.28": [
		"[Possibly] fixed a bug allowing locked LOREDs/resources to be requirements for random tasks.",
	],
	
	"2.2.27": [
		"Fixed a bug preventing quests from loading properly.",
	],
	
	"2.2.26": [
		"Fixed a bug preventing task-completement quests from receiving any progress.",
	],
	
	"2.2.25": [
		"Changed the menu, as you have already noticed!",
		"Added an option to consolidate flying number labels.",
		"Added an assist mode for those with hearing loss.",
		"Fixed a bug for the quest Horse Doodie where every upgrade would count for quest progress.",
		"Fixed a bug preventing the upgrade menus from being accessed via clicking.",
		"Removed the option to zoom in or out.",
	],
	
	"2.2.24": [
		"Disabled save importing via File Dialog until it is fixed. You can still paste any save code into save.lored, of course.",
		"Fixed the bug preventing Metastasize or Chemotherapy from doing anything.",
		"Fixed the bug preventing the patch notes window from being hidden.",
		"Fixed the bug preventing halt and hold statuses from being saved even when the option to do so was checked.",
	],
	
	"2.2.23": [
		"Upgrade menus correctly appear in the main upgrade window. Don't forget about the hotkeys to access each upgrade menu, which are Q, W, E, and R!",
		"ROUTINE is (once again) no longer counted in the total count of Malignant upgrades, as intended (since it cannot truly be owned).",
	],
	
	"2.2.22": [
		"Fixed a bug that was blocking offline earnings when switching tabs. Feel free to switch tabs all over the place, bay-bee.",
		"Fixed a bug for the quest A Million Reasons to Grind, where you'd actually need to complete 51 tasks instead of 50. Probably. You think I test these bug-fixes? I live in a hole in the ground, what do you want from me?",
		"\"Fixed\" save-importing. It still crashes the game, but it definitely imports the save. Reload the game after it dies!",
	],
	
	"2.2.21": [
		"Removed the Offline Boost system.",
		"Restored the old offline earnings system, with the usual 1.0x modifier.",
	],
	
	"2.2.20": [
		"Fixed a bug that was causing freezes after a reset.",
	],
	
	"2.2.19": [
		"Fixed a bug that wasn't properly turning in quests on load.",
	],
	
	"2.2.18": [
		"Fixed more Offline Boost bugs, woo-hoo!",
	],
	
	"2.2.17": [
		"Probably fixed some Offline Boost bugs, who knows?",
	],
	
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
	
	resetList()
	
	init_menu_and_stats()
	update_clock()
	
	setupFonts()

func setupFonts():
	font.buttonNormal.font_data = load("res://Fonts/Roboto-Light.ttf")
	
	font.buttonHover.font_data = load("res://Fonts/Roboto-Light.ttf")
	font.buttonHover.outline_size = 1
	font.buttonHover.outline_color = Color(1, 1, 1, 0.25)
	
#var dynamic_font = DynamicFont.new()
#    dynamic_font.font_data = load("res://Fonts/Cairo-Bold.ttf")
#    dynamic_font.size = 120
#    dynamic_font.use_filter = true

func init_menu_and_stats():
	
	# menu
	
	option["FPS"] = 0
	option["notation_type"] = 0
	option["status_color"] = false
	option["flying_numbers"] = true
	option["crits_only"] = false
	option["chit chat"] = true
	option["consolidate_numbers"] = false
	option["animations"] = true
	option["tooltip_halt"] = true
	option["tooltip_hold"] = true
	option["tooltip_fuel"] = true
	option["tooltip_autobuyer"] = true
	option["tooltip_cost_only"] = false
	option["on_save_halt"] = false
	option["on_save_hold"] = false
	option["im_ss_show_hint"] = true
	option["task auto"] = false
	option["performance"] = true
	option["color blind"] = false
	option["deaf"] = false
	option["patch alert"] = true
	option["tutorial alert"] = true
	
	# stats
	
	for x in Tab:
		
		if Tab[x] == Tab.S1:
			break



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
	#note i commented this line out because it was unlocking s2n before the quest unlocked it
	#get_node("/root/Root").unlock_tab(Tab.EXTRA_NORMAL)

const SRC := {
	"alert": preload("res://Prefabs/alert.tscn"),
	"emote": preload("res://Prefabs/lored/Emote.tscn"),
	"flash": preload("res://Prefabs/Flash.tscn"),
	
	"wish vico": preload("res://Prefabs/Wish/Wish Vico.tscn"),
	"task entry": preload("res://Prefabs/tooltip/tip_lored_task_entry.tscn"),
	"upgrade block": preload("res://Prefabs/tooltip/upgrade_block.tscn"),
	
	"unit": preload("res://Prefabs/Cavern/Unit.tscn"),
	
	"patch version": preload("res://Prefabs/Patch/version.tscn"),
	"patch entry": preload("res://Prefabs/Patch/entry.tscn"),
	
	"price": preload("res://Prefabs/tooltip/price.tscn"),
	
	"cavern/buff": preload("res://Prefabs/Cavern/Buff.tscn"),
	
	"tooltip/LORED": preload("res://Prefabs/tooltip/LORED.tscn"),
	"tooltip/autobuyer": preload("res://Prefabs/tooltip/AutobuyerTooltip.tscn"),
	"tooltip/spell": preload("res://Prefabs/Cavern/SpellTooltip.tscn"),
	"tooltip/upgrade": preload("res://Prefabs/tooltip/Upgrade Tooltip.tscn"),
	"tooltip/wish": preload("res://Prefabs/Wish/Wish Tooltip.tscn"),
	
	"label": preload("res://Prefabs/template/Label.tscn"),
	"job label": preload("res://Prefabs/template/job label.tscn"),
	"button label": preload("res://Prefabs/template/Button Label.tscn"),
	
	"flying text": preload("res://Prefabs/dtext.tscn"),
	
	"save block": preload("res://Prefabs/menu/Save Block.tscn"),
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
	
	for x in list.lored[Tab.S1] + list.lored[Tab.S2]:
		g[x].d.lbm = up["Limit Break"].effects[0].effect.t
		g[x].d.sync()
	
	emit_signal("limit_break_leveled_up", "color")

func increase_lb_xp(value):
	
	if not up["Limit Break"].active():
		return
	
	lb_xp.f.a(value)
	lb_xp_check()

# signals are emitted in multiple places but may only be received in one place

signal autobuyer_purchased(key) # -> LORED.gd
signal amount_updated(key) # LORED.gd -> resources.gd
signal net_updated(net)
signal wishReward(type, key) # -> Root.gd

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

var spell_sprite := {
	
	Cav.eSpell.ARCANE_FOCUS: preload("res://Sprites/resources/axe.png"),
	Cav.eSpell.CORE_RIFT: preload("res://Sprites/resources/water.png"),
	Cav.eSpell.VITALIZE: preload("res://Sprites/resources/seed.png"),
	Cav.eSpell.ARCANE_FLOW: preload("res://Sprites/resources/iron.png"),
	
}

var buff_sprite := {
	
	Cav.Buff.RIFT: preload("res://Sprites/resources/water.png"),
	Cav.Buff.ARCANE_FLOW: preload("res://Sprites/resources/iron.png"),
	
	Cav.Buff.SCORCHING: preload("res://Sprites/resources/axe.png"),
	
}

var sprite := {
	
	"joy": preload("res://Sprites/resources/Joy.png"),
	"grief": preload("res://Sprites/resources/Grief.png"),
	
	"angry": preload("res://Sprites/reactions/Angry.png"),
	"test": preload("res://Sprites/reactions/Test.png"),
	
	"mana" : preload("res://Sprites/upgrades/thewitchofloredelith.png"),
	"embryo" : preload("res://Sprites/resources/carc.png"),
	"nearly dead" : preload("res://Sprites/resources/carc.png"),
	"corpse" : preload("res://Sprites/resources/carc.png"),
	"bone" : preload("res://Sprites/resources/carc.png"),
	"spirit" : preload("res://Sprites/resources/carc.png"),
	"bagged beast" : preload("res://Sprites/resources/carc.png"),
	"beast body" : preload("res://Sprites/resources/carc.png"),
	"exsanguinated beast" : preload("res://Sprites/resources/carc.png"),
	"meat" : preload("res://Sprites/resources/carc.png"),
	"fur" : preload("res://Sprites/resources/carc.png"),
	
	"blood" : preload("res://Sprites/resources/carc.png"),
	"necro" : preload("res://Sprites/resources/carc.png"),
	"witch" : preload("res://Sprites/upgrades/thewitchofloredelith.png"),
	
	# menu
	"fuel": preload("res://Sprites/Menu/fuel.png"),
	"fuel full": preload("res://Sprites/Menu/Fuel Full.png"),
	
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
	
	str(Tab.S1) : preload("res://Sprites/tab/t0.png"),
	str(Tab.S2) : preload("res://Sprites/tab/s2.png"),
	str(Tab.S3) : preload("res://Sprites/tab/s2.png"),
	str(Tab.S4) : preload("res://Sprites/tab/s2.png"),
	
	str(Tab.NORMAL) : preload("res://Sprites/tab/s1n.png"),
	str(Tab.MALIGNANT) : preload("res://Sprites/tab/s1m.png"),
	str(Tab.EXTRA_NORMAL) : preload("res://Sprites/tab/s2n.png"),
	str(Tab.RADIATIVE) : preload("res://Sprites/tab/s2m.png"),
	str(Tab.RUNED_DIAL) : preload("res://Sprites/tab/s2n.png"),
	str(Tab.SPIRIT) : preload("res://Sprites/tab/s2m.png"),
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
}

var warlock := Unit.new(Cav.UnitClass.ARCANE_LORED)

var autobuy_speed := 0.25
var up := {}

#var color := {
#	Lored.COPPER: Color(1, 0.74, 0.05),
#	Lored.IRON: Color(0.07, 0.89, 1),
#	Lored.COPPER_ORE: Color(0.7, 0.33, 0),
#	Lored.IRON_ORE: Color(0, 0.517647, 0.905882),
#	Lored.STONE: Color(0.79, 0.79, 0.79),
#	Lored.COAL: Color(0.7, 0, 1),
#}
var COLORS := {
	"fire": Color(1, 0, 0),
	"frost": Color(0, 0.694118, 1),
	"air": Color(0.612122, 0.394531, 1),
	"earth": Color(1, 0.6, 0),
	"stamina": Color(0.501961, 1, 0),
	"barrier": Color(1, 0.8, 0),
	"health": Color(1, 0, 0),
	"mana": Color(0, 0.709804, 1),
	"overwhelming power": Color(0.721569, 0.34902, 0.901961), #note too close to air?
	"grief": Color(0.74902, 0.203922, 0.533333),
	"joy": Color(1, 0.909804, 0),
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
	
	"necro": Color(0.88, .12, .35),
	"witch": Color(0.937255, 0.501961, 0.776471),
	
	"spirit": Color(0.88, .12, .35),
	
	"flayed corpse": Color(0.88, .12, .35),
	"defiled dead": Color(0.88, .12, .35),
	"corpse": Color(0.88, .12, .35),
	"nearly dead": Color(0.88, .12, .35),
	"flesh": Color(0.88, .12, .35),
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
	str(Tab.NORMAL): Color(0.733333, 0.458824, 0.031373),
	str(Tab.MALIGNANT): Color(0.878431, 0.121569, 0.34902),
	str(Tab.EXTRA_NORMAL): Color(0.47451, 0.870588, 0.694118),
	str(Tab.RADIATIVE): Color(1, 0.541176, 0.541176),
	str(Tab.S1): Color(0.878431, 0.121569, 0.34902),
	str(Tab.S2): Color(1, 0.541176, 0.541176),
	str(Tab.S3): Color(0.8, 0.8, 0.8),
	str(Tab.S4): Color(0.8, 0.8, 0.8),
	"copy": Color(0.8, 0.8, 0.8),
	"grey": Color(0.8, 0.8, 0.8),
}

var open_tab := -1

func haveLoredsRequiredForExtraNormalUpgradeMenu() -> bool:
	for x in ["soil", "seed", "water", "tree", "sand", "draw", "axe", "liq", "steel", "wire", "glass", "hard", "wood", "humus"]:
		if not g[x].active:
			return false
	return true





func time_remaining_in_seconds(
	lored_key: String,
	present_amount: Big,
	total_amount: Big) -> Big:
	
	
	if g[lored_key].halt:
		return Big.new(0)
	
	var net = g[lored_key].net()
	
	if net[1].greater(net[0]):
		return Big.new(0)
	
	net = net[0].s(net[1])
	
	if net.equal(0):
		return Big.new(0)
	
	var delta: Big = Big.new(total_amount).s(present_amount)
	var incoming_amount := Big.new(0)
	
	
	if g[lored_key].working:
		incoming_amount.a(g[lored_key].d.t)
	
	return Big.new(delta).s(incoming_amount).d(net)

func time_remaining_including_INF(
	lored_key: String,
	present_amount: Big,
	total_amount: Big):
	
	
	if g[lored_key].halt:
		return INF
	
	var net = g[lored_key].net()
	
	if net[1].greater(net[0]):
		return INF
	
	net = net[0].s(net[1])
	
	if net.equal(0):
		return INF
	
	var delta: Big = Big.new(total_amount).s(present_amount)
	var incoming_amount := Big.new(0)
	
	
	if g[lored_key].working:
		incoming_amount.a(g[lored_key].d.t)
	
	return Big.new(delta).s(incoming_amount).d(net)

func time_remaining(
	lored_key: String,
	present_amount: Big,
	total_amount: Big) -> String:
	
	
	if g[lored_key].halt:
		return "Halt"
	
	
	var net = g[lored_key].net()
	
	if net[1].greater(net[0]):
		return "-"
	
	net = net[0].s(net[1])
	
	if net.equal(0):
		return "!?"
	
	var delta: Big = Big.new(total_amount).s(present_amount)
	var incoming_amount := Big.new(0)
	
	
	if g[lored_key].working:
		incoming_amount.a(g[lored_key].d.t)
	
	return parse_time(Big.new(delta).s(incoming_amount).d(net))

func parse_time(value) -> String:
	
	if value is Big:
		return parse_time_big(value)
	else:
		return parse_time_float(value)

func parse_time_big_not_abbreviated(big: Big) -> String:
	
	if big.less(0):
		big = Big.new(0)
	
	if big.less(1):
		return "!"
	
	if big.less(60):
		return big.roundDown().toString() + " seconds"
	
	big.d(60) # minutes
	
	if big.less(60):
		return big.roundDown().toString() + " minutes"
	
	big.d(60) # hours
	
	if big.less(24):
		return big.roundDown().toString() + " hours"
	
	big.d(24) # days
	
	if big.less(365):
		return big.roundDown().toString() + " days"
	
	big.d(365) # years
	
	if big.less(10):
		return big.roundDown().toString() + " years"
	
	big.d(10) # decades
	
	if big.less(100):
		return big.roundDown().toString() + " decades"
	
	big.d(100) # centuries
	
	if big.less(1000):
		return big.roundDown().toString() + " centuries"
	
	return big.roundDown().toString() + " millenia"

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
	"joy": Big.new(0),
	"grief": Big.new(0),
	"embryo": Big.new(0),
	"spirit": Big.new(0),
	"mana": Big.new(0),
}
var r_name := {
	"grief": "Grief",
	"joy": "Joy",
	"spirit": "Spirit",
	#"blood": "Blood",
	"embryo": "Embryo",
	"r": "Mana",
}
var resource := {}




enum NumType {
	TOTAL,
	BASE,
	ADD,
	MULTIPLY,
	FROM_LEVELS,
	FROM_UPGRADES,
	LIMIT_BREAK,
	I_DRINK_YOUR_MILKSHAKE,
}
enum Lored {
	COAL, STONE, IRON_ORE, COPPER_ORE, IRON, COPPER,
	GROWTH, CONCRETE, JOULES, OIL, TARBALLS, MALIGNANCY,
}
enum Job{
	BORER_DIG,
	FURNACE_COOK,
}
enum Upgrade {
	GRINDER,
	UPGRADE_NAME,
}
enum Effect {
	VALUE,
	TYPE,
	APPLY_TO,
	
	HASTE,
	FUEL_DRAIN,
}

var item_names := [
	"mana", "bits", "pieces", "parts", "portions", "crumbs","slices","samples","shards",
]
var active_buffs := []
enum Buff {
	HEX,
}
signal buff_spell_cast(spell, target) # LORED.gd -> LORED List.gd

enum Tab { 
	NORMAL, MALIGNANT,
	EXTRA_NORMAL, RADIATIVE,
	RUNED_DIAL, SPIRIT,
	s4n, s4m,
	S1, S2, S3, S4,
}
var unlocked_tabs := []
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
var list := {}
func resetList():
	list = {
		upgrade = {"owned": {}},
		lored = {
			Tab.S1: [], Tab.S2: [], Tab.S3: [], Tab.S4: [],
			"active": ["stone"], "active " + str(Tab.S1): ["stone"], "active " + str(Tab.S2): [], "active " + str(Tab.S3): [], "active " + str(Tab.S4): [],
			"rare quest whitelist": [],
			"unlocked and inactive": [],
		},
		"unlocked resources": ["stone"], #note stage 3 resources need to be manually added
	}
	
	for t in Tab:
		list.upgrade[str(Tab[t])] = []
		list.upgrade["unowned " + str(Tab[t])] = []
		list.upgrade["owned " + str(Tab[t])] = []
	for t in Tab:
		list.upgrade[str(Tab[t])] = []
		list.upgrade["unowned " + str(Tab[t])] = []
		list.upgrade["owned " + str(Tab[t])] = []

func everyStage2LOREDunlocked() -> bool:
	return list.lored["active " + str(Tab.S2)].size() == list.lored[Tab.S2].size()

enum Objective {
	RESOURCES_PRODUCED,
	LORED_UPGRADED,
	UPGRADE_PURCHASED,
	SPELL_CAST_COUNT,
	UPGRADES_PURCHASED,
	MAXED_FUEL_STORAGE,
	BREAK,
	HOARD,
}
enum WishReward {
	# add new entries at the bottom
	NEW_LORED,
	RESOURCE,
	TAB,
	MAX_RANDOM_WISHES,
	AUTOMATED,
	HALT_AND_HOLD,
	WISH_TURNIN,
	EASIER,
}

func highestResetKey() -> String:
	match highest_run:
		1: return "malig"
		2: return "tum"
		3: return "spirit"
	return "oops" #s4

func isStage1Or2LORED(key: String) -> bool:
	return key in gv.list.lored[gv.Tab.S1] or key in gv.list.lored[gv.Tab.S2]

func setSpellDesc(spell: Spell):
	
	var actions = spell.order.size()
	var i = 0
	for o in spell.order:
		
		match o:
			
			Cav.AbilityAction.DEAL_DAMAGE:
				
				spell.desc += "deals "
				
				var ii = 0
				for d in spell.damage.types:
					
					spell.desc += "{damage" + str(ii) + "}"
					
					ii += 1
					
					if spell.damage.types == ii:
						spell.desc += " damage"
						if ii > 1:
							spell.desc += " simultaneously"
					elif spell.damage.types == ii + 1:
						if spell.damage.types > 2:
							spell.desc += ", "
						spell.desc += " and "
					elif spell.damage.types > ii + 1:
						spell.desc += ", "
			
			Cav.AbilityAction.APPLY_BUFF:
				var buff: String = Cav.Buff.keys()[spell.applied_buff]
				spell.desc += "applies {buff:" + buff + "}"
			
			Cav.AbilityAction.RESTORE_HEALTH:
				if spell.is_channeled:
					spell.desc += "restores {restore_health per sec} health per second"
				else:
					spell.desc += "restores {restore_health} health"
				continue
			
			Cav.AbilityAction.RESTORE_MANA:
				if spell.is_channeled:
					spell.desc += "restores {restore_mana per sec} per second"
				else:
					spell.desc += "restores {restore_mana}"
				continue
			
			Cav.AbilityAction.RESTORE_HEALTH, Cav.AbilityAction.RESTORE_MANA:
				if spell.requires_target:
					spell.desc += " to a target"
				else:
					spell.desc += " to the Warlock"
			
			Cav.AbilityAction.CONSIDER_SPECIAL_EFFECTS:
				
				var buff: String
				
				for x in spell.special_req_type.size():
					
					match spell.special_action_type[x]:
						Cav.SpecialEffect.APPLY_BUFF:
							buff = Cav.Buff.keys()[spell.special_action[x]]
							spell.desc += "Applies " + "{buff:" + buff + "} "
						Cav.SpecialEffect.BECOME_SPLASH:
							buff = Cav.Buff.keys()[spell.special_action[x]]
							spell.desc += "Becomes splash "
					
					match spell.special_req_type[x]:
						Cav.SpecialEffectRequirement.STACK_LIMIT:
							buff = Cav.Buff.keys()[spell.special_req[x]]
							spell.desc += "if the target has 5 stacks of "
							spell.desc += "{buff:" + buff + "}. "
		
		if i == 0:
			spell.desc[0] = spell.desc[0].to_upper()
		
		i += 1
		
		if o == Cav.AbilityAction.CONSIDER_SPECIAL_EFFECTS:
			continue
		
		if actions == i:
			spell.desc += "."
		elif actions == i + 1:
			if actions > 2 or spell.deals_damage and spell.damage.types >= 2:
				spell.desc += ","
			spell.desc += " and "
		elif actions -1 > i + 1:
			spell.desc += ", "

func xIsNearlyY(x: float, y: float) -> bool:
	return x > y * 0.98 and x < y * 1.02


func version_older_than(_save_version: String, _version: String) -> bool:
	
	# _version == the version at hand, to be compared with _save version
	
	var _save_version_split = _save_version.split(".")
	var _version_split = _version.split(".")
	
	var save = {x = int(_save_version_split[0]), y = int(_save_version_split[1]), z = int(_save_version_split[2])}
	var version = {x = int(_version_split[0]), y = int(_version_split[1]), z = int(_version_split[2])}
	
	# save version is either OLDER than version, or EQUAL to version.
	# returns TRUE if OLDER, FALSE if EQUAL
	
	if save.x < version.x:
		return true
	if save.y < version.y:
		return true
	if save.z < version.z:
		return true
	
	return false


func getSpellName(type: int) -> String:
	return Cav.eSpell.keys()[type].to_lower().capitalize().replace("_", " ")
func getBuffName(type: int) -> String:
	return Cav.Buff.keys()[type].to_lower().capitalize().replace("_", " ")

func damageTypeToStr(type: int) -> String:
	return Cav.DamageType.keys()[type].to_lower()

func damageTypeToNR(type: int) -> int:
	
	# Natural Reaction
	
	match type:
		Cav.DamageType.FIRE:
			return Cav.Buff.BURNING
		Cav.DamageType.FROST:
			return Cav.Buff.CHILLED
		Cav.DamageType.EARTH:
			return Cav.Buff.BATTERED
		Cav.DamageType.AIR:
			return Cav.Buff.OXIDIZED
	
	return 0 # will never return this

var target: Unit
signal new_gcd(duration) # Unit.gd -> SpellButton.gd
signal gcd_stopped # Cavern/Cavern.gd -> SpellButton.gd
signal casting_completed # SpellManager.gd -> ?
signal cooldown_completed(spell_type) # should be an int || SpellManager.gd -> ?

signal mana_restored(amount, surplus) # Unit.gd -> Scenes/Cavern.gd
signal buff_applied(target, data) # Unit.gd -> Scenes/Cavern.gd

func getSpellBorderColor(spell: int) -> Color:
	
	if Cav.spell[spell].costs_health:
		return gv.COLORS["health"]
	if Cav.spell[spell].costs_mana:
		return gv.COLORS["mana"]
	if Cav.spell[spell].costs_stamina:
		return gv.COLORS["stamina"]
	if Cav.spell[spell].restores_health:
		return gv.COLORS["health"]
	if Cav.spell[spell].restores_mana:
		return gv.COLORS["mana"]
	return Color(1,1,1)



func commaifyAnArrayOfStrings(list: Array) -> String:
	
	if list.size() == 1:
		return str(list[0])
	
	if list.size() == 2:
		return str(list[0]) + " and " + str(list[1])
	
	if list.size() > 2:
		var i = 0
		var text: String
		for f in list:
			
			if i < list.size() - 2:
				text += f + ","
			elif i == list.size() - 2:
				text += f + ", and "
			elif i == list.size() - 1:
				text += f
			
			i += 1
		
		return text
	
	return "Oops!"



func syncLOREDs(immediately := false):
	
	if immediately:
		for x in g:
			g[x].sync()
		return
	
	for x in g:
		g[x].queueSync()




# stats
var cur_clock = OS.get_unix_time()
var last_clock = OS.get_unix_time()
var save_slot_clock: int
var cur_session := 0

var page: int = Tab.S1 # example gv.Tab.S1

var run1 := 1
var run2 := 1
var run3 := 1
var run4 := 1
var time_played := 0
var wishes_completed := 0
var highest_run := 1
var most_resources_gained := Big.new(0)
var times_game_loaded := 0

var tab_vertical := [0, 0, 0, 0]
var option := {}

func update_clock():
	
	var t = Timer.new()
	add_child(t)
	
	while true:
		
		cur_clock = OS.get_unix_time()
		
		t.start(1)
		yield(t, "timeout")
		
		if active_scene == Scene.ROOT:
			cur_session += 1
			time_played += 1
		else:
			cur_session = 0
	
	t.queue_free()

# scene stuff
enum Scene {
	MAIN_MENU,
	ROOT,
	}
var active_scene: int
func close():
	# Root closed
	resetList()
	
	g.clear()
	up.clear()


# main menu
var font := {
	buttonNormal = DynamicFont.new(),
	buttonHover = DynamicFont.new(),
}
signal edit_save_color(node)
signal hideAllActions


func getRandomColor() -> Color:
	return Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1)




var saved_vars := [
	"run1", "run2", "run3", "run4",
	"cur_clock", "time_played", "wishes_completed", "times_game_loaded", "highest_run",
	"most_resources_gained", "option",
	"lb_xp",
]

func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		if get(x) is Big or get(x) is Ob.Num:
			data[x] = get(x).save()
		else:
			data[x] = var2str(get(x))
	
	data["resources"] = {}
	for x in r:
		data["resources"][x] = r[x].save()
	
	return var2str(data)

func load(data: Dictionary):
	
	#*
	var saved_vars_dict := {}
	
	for x in saved_vars:
		saved_vars_dict[x] = get(x)
	
	var loadedVars = SaveManager.loadSavedVars(saved_vars_dict, data)
	
	for x in saved_vars:
		if get(x) is Ob.Num:
			get(x).load(data[x])
		else:
			set(x, loadedVars[x])
	#*
	
	for x in r:
		if not x in data["resources"]:
			continue
		r[x].load(data["resources"][x])
	
	save_slot_clock = cur_clock
	cur_clock = OS.get_unix_time() # set to the same time as cur_clock in the save data (8 lines up)






