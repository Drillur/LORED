class_name GlobalVariables
extends Node




const hax_pow := 1.0 # 1.0 for normal
var fps: float = 0.0666 # default (15 fps) - [0.0666, 0.0333, 0.0166] # 15, 30, 60
const PLATFORM := 1 # see line 12
const dev_mode := false

enum Platform {
	BROWSER, # 0
	PC, # 1
}

const PATCH_NOTES := {
	
	"3.0.0": [
		"Added a main menu with save management (desktop-only).",
		"Added difficulty options (desktop-only).",
		"Merged quests and tasks into Wishes.",
		"LOREDs now think out-loud and may speak to each other.",
		"New LORED UI and tooltips.",
		"Completely re-wrote the LORED and Quest/Task classes and separated resources from LOREDs in the code.",
		"LOREDs no longer automatically refill their fuel. They must refuel manually.",
		"Every main and random Wish has dialogue.",
		"Added the Steel and Soil animations.",
		"Added and removed some options.",
	],
	
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


var saved_vars := [
	"run1", "run2", "run3", "run4",
	"run1duration", "run2duration", "run3duration", "run4duration", 
	"cur_clock", "time_played", "times_game_loaded", "highest_run",
	"most_resources_gained", "stats",
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
	for x in resource:
		data["resources"][x] = resource[x].save()
	
	return var2str(data)

func load(data: Dictionary):
	
	#* Copy-paste this block to a script where saving a Dictionary is necessary
	var saved_vars_dict := {}
	
	for x in saved_vars:
		saved_vars_dict[x] = get(x)
	
	var loadedVars = SaveManager.loadSavedVars(saved_vars_dict, data)
	
	for x in saved_vars:
		if not x in loadedVars:
			continue
		if get(x) is Ob.Num or get(x) is Big:
			get(x).load(data[x])
		else:
			set(x, loadedVars[x])
	#*
	
	for x in resource:
		if not x in data["resources"]:
			continue
		resource[x].load(data["resources"][x])
	
	save_slot_clock = cur_clock
	cur_clock = OS.get_unix_time() # set to the same time as cur_clock in the save data (8 lines up)
	
	times_game_loaded += 1



func _ready():
	
	setShorthandByResource()
	resetList()
	
	setupOptions()
	update_clock()
	
	setupFonts()
	
	for r in gv.Resource.values():
		gv.resourceName[r] = gv.Resource.keys()[r].capitalize().replace("_", " ")
		gv.resourceText[r] = ""
	
	setResourceColors()
	
	connect("startGame", self, "gameStarted")
	connect("Reset", self, "runReset")

func setupFonts():
	font.buttonNormal.font_data = load("res://Fonts/Roboto-Light.ttf")
	
	font.buttonHover.font_data = load("res://Fonts/Roboto-Light.ttf")
	font.buttonHover.outline_size = 1
	font.buttonHover.outline_color = Color(1, 1, 1, 0.25)
	
#var dynamic_font = DynamicFont.new()
#    dynamic_font.font_data = load("res://Fonts/Cairo-Bold.ttf")
#    dynamic_font.size = 120
#    dynamic_font.use_filter = true

func setupOptions():
	
	option["FPS"] = 0
	option["notation_type"] = 0
	option["animations"] = true
	option["loredOutputNumbers"] = true
	option["loredFuel"] = true
	option["tipSleep"] = true
	option["autosave"] = true
	option["loredCritsOnly"] = false
	option["flying_numbers"] = true
	option["levelUpDetails"] = true
	option["wishVicosOnMainScreen"] = true
	option["loredChitChat"] = true



var loreds_required_for_s2_autoup_upgrades_to_begin_purchasing: Array
var s2_upgrades_may_be_autobought := false

func check_for_the_s2_shit():
	if s2_upgrades_may_be_autobought:
		return
	for x in loreds_required_for_s2_autoup_upgrades_to_begin_purchasing:
		if not lv.lored[x].purchased:
			return
	s2_upgrades_may_be_autobought = true
	get_node("/root/Root").unlock_tab(Tab.EXTRA_NORMAL)

const SRC := {
	"emote": preload("res://Prefabs/NewLORED/Emote.tscn"),
	"flash": preload("res://Prefabs/Flash.tscn"),
	
	"wish vico": preload("res://Prefabs/Wish/Wish Vico.tscn"),
	"task entry": preload("res://Prefabs/tooltip/tip_lored_task_entry.tscn"),
	
	"manual labor": preload("res://Prefabs/lored/Manual Labor.tscn"),
	"LORED": preload("res://Prefabs/NewLORED/LORED.tscn"),
	
	"PatchEntry": preload("res://Prefabs/menu/PatchEntry.tscn"),
	
	"price": preload("res://Prefabs/tooltip/price.tscn"),
	
	"tooltip/LORED": preload("res://Prefabs/tooltip/LORED.tscn"),
	"tooltip/autobuyer": preload("res://Prefabs/tooltip/AutobuyerTooltip.tscn"),
	"tooltip/upgrade": preload("res://Prefabs/tooltip/Upgrade Tooltip.tscn"),
	"tooltip/wish": preload("res://Prefabs/Wish/Wish Tooltip.tscn"),
	"tooltip/level up": preload("res://Prefabs/tooltip/Tooltip Level Up.tscn"),
	"tooltip/lored info": preload("res://Prefabs/tooltip/Tooltip Info.tscn"),
	"tooltip/lored alert": preload("res://Prefabs/tooltip/Tooltip Lored Alert.tscn"),
	"tooltip/lored jobs": preload("res://Prefabs/tooltip/LORED Tooltip Jobs.tscn"),
	"tooltip/lored job": preload("res://Prefabs/tooltip/LORED Tooltip Job.tscn"),
	"tooltip/lored asleep": preload("res://Prefabs/tooltip/Asleep.tscn"),
	"tooltip/lored export": preload("res://Prefabs/tooltip/LORED Tooltip Export.tscn"),
	"tooltip/active buffs": preload("res://Prefabs/tooltip/LORED Active Buffs.tscn"),
	"tooltip/buff tooltip": preload("res://Prefabs/tooltip/LORED Buff Tooltip.tscn"),
	
	"earnings report/resource": preload("res://Prefabs/ui/Earnings Report Resource.tscn"),
	"labels/medium label": preload("res://Prefabs/Labels/Medium Label.tscn"),
	
	"label": preload("res://Prefabs/template/Label.tscn"),
	"button label": preload("res://Prefabs/template/Button Label.tscn"),
	
	"flying text": preload("res://Prefabs/dtext.tscn"),
	
	"save block": preload("res://Prefabs/menu/Save Block.tscn"),
}

signal limit_break_leveled_up # here -> Limit Break.gd
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
		
		var exponent = Big.new(up["Limit Break"].effects[0].effect.a).square().toFloat() * 1.5
		lb_xp.t = Big.new("1e" + str(exponent))
		if lb_xp.t.less(Big.new(up["Limit Break"].effects[0].effect.a).m(1000)):
			lb_xp.t = Big.new(up["Limit Break"].effects[0].effect.a).m(1000)
		
		if lb_xp.f.less(lb_xp.t):
			break
	
	up["Limit Break"].sync_effects()
	
	emit_signal("limit_break_leveled_up")

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

signal throwFuel(resource) # LORED Manager.gd -> LORED Manager.gd

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

var resourceSprite := {
	
}
var sprite := {
	
	"RANDOM_SEED": preload("res://Sprites/resources/seed.png"),
	
	"JOY": preload("res://Sprites/resources/Joy.png"),
	"GRIEF": preload("res://Sprites/resources/Grief.png"),
	
	"angry": preload("res://Sprites/reactions/Angry.png"),
	"test": preload("res://Sprites/reactions/Test.png"),
	
	"mana" : preload("res://Sprites/upgrades/thewitchofloredelith.png"),
	"embryo" : preload("res://Sprites/resources/carc.png"),
	
	"blood" : preload("res://Sprites/resources/carc.png"),
	"necro" : preload("res://Sprites/resources/carc.png"),
	"witch" : preload("res://Sprites/upgrades/thewitchofloredelith.png"),
	
	# menu
	"fuel": preload("res://Sprites/Menu/fuel.png"),
	"fuel full": preload("res://Sprites/Menu/Fuel Full.png"),
	"view": preload("res://Sprites/Menu/View.png"),
	"viewHide": preload("res://Sprites/Menu/ViewHide.png"),
	"fuelCost": preload("res://Sprites/Menu/drain rate.png"),
	"level": preload("res://Sprites/Menu/Level.png"),
	"log": preload("res://Sprites/Menu/Log.png"),
	
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
	str(Tab.s4n) : preload("res://Sprites/tab/s2m.png"),
	str(Tab.s4m) : preload("res://Sprites/tab/s2m.png"),
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
var shorthandByResource := {}
func setShorthandByResource():
	shorthandByResource[Resource.COAL] = "coal"
	shorthandByResource[Resource.IRON] = "iron"
	shorthandByResource[Resource.COPPER] = "cop"
	shorthandByResource[Resource.STONE] = "stone"
	shorthandByResource[Resource.IRON_ORE] = "irono"
	shorthandByResource[Resource.COPPER_ORE] = "copo"
	shorthandByResource[Resource.GROWTH] = "growth"
	shorthandByResource[Resource.JOULES] = "jo"
	shorthandByResource[Resource.CONCRETE] = "conc"
	shorthandByResource[Resource.MALIGNANCY] = "malig"
	shorthandByResource[Resource.TARBALLS] = "tar"
	shorthandByResource[Resource.OIL] = "oil"
	shorthandByResource[Resource.WATER] = "water"
	shorthandByResource[Resource.HUMUS] = "humus"
	shorthandByResource[Resource.SEEDS] = "seed"
	shorthandByResource[Resource.TREES] = "tree"
	shorthandByResource[Resource.SOIL] = "soil"
	shorthandByResource[Resource.AXES] = "axe"
	shorthandByResource[Resource.WOOD] = "wood"
	shorthandByResource[Resource.HARDWOOD] = "hard"
	shorthandByResource[Resource.LIQUID_IRON] = "liq"
	shorthandByResource[Resource.STEEL] = "steel"
	shorthandByResource[Resource.SAND] = "sand"
	shorthandByResource[Resource.GLASS] = "glass"
	shorthandByResource[Resource.DRAW_PLATE] = "draw"
	shorthandByResource[Resource.WIRE] = "wire"
	shorthandByResource[Resource.GALENA] = "gale"
	shorthandByResource[Resource.LEAD] = "lead"
	shorthandByResource[Resource.PETROLEUM] = "pet"
	shorthandByResource[Resource.WOOD_PULP] = "pulp"
	shorthandByResource[Resource.PAPER] = "paper"
	shorthandByResource[Resource.PLASTIC] = "plast"
	shorthandByResource[Resource.TOBACCO] = "toba"
	shorthandByResource[Resource.CIGARETTES] = "ciga"
	shorthandByResource[Resource.CARCINOGENS] = "carc"
	shorthandByResource[Resource.TUMORS] = "tum"
	
	var rKeys = Resource.keys()
	for r in Resource.values():
		if r in shorthandByResource:
			continue
		shorthandByResource[r] = rKeys[r]

const anim = {
	"refuel": preload("res://Sprites/animations/Refuel.tres"),
	"TUMORS": preload("res://Sprites/animations/tum.tres"),
	"CARCINOGENS": preload("res://Sprites/animations/carc.tres"),
	"PLASTIC": preload("res://Sprites/animations/plast.tres"),
	"PETROLEUM": preload("res://Sprites/animations/pet.tres"),
	"LEAD": preload("res://Sprites/animations/lead.tres"),
	"WIRE": preload("res://Sprites/animations/wire.tres"),
	"DRAW_PLATE": preload("res://Sprites/animations/draw.tres"),
	"STEEL": preload("res://Sprites/animations/steel.tres"),
	"HARDWOOD": preload("res://Sprites/animations/hard.tres"),
	"AXES": preload("res://Sprites/animations/axe.tres"),
	"WOOD_PULP": preload("res://Sprites/animations/pulp.tres"),
	"SOIL": preload("res://Sprites/animations/soil.tres"),
	"PAPER": preload("res://Sprites/animations/paper.tres"),
	"COAL" : preload("res://Sprites/animations/coal.tres"),
	"STONE" : preload("res://Sprites/animations/stone.tres"),
	"IRON_ORE" : preload("res://Sprites/animations/irono.tres"),
	"COPPER_ORE" : preload("res://Sprites/animations/copo.tres"),
	"IRON" : preload("res://Sprites/animations/iron.tres"),
	"COPPER" : preload("res://Sprites/animations/cop.tres"),
	"GROWTH" : preload("res://Sprites/animations/growth.tres"),
	"CONCRETE" : preload("res://Sprites/animations/conc.tres"),
	"JOULES" : preload("res://Sprites/animations/jo.tres"),
	"MALIGNANCY" : preload("res://Sprites/animations/malig.tres"),
	"TARBALLS" : preload("res://Sprites/animations/tar.tres"),
	"OIL" : preload("res://Sprites/animations/oil.tres"),
	"WATER" : preload("res://Sprites/animations/water.tres"),
	"TREES" : preload("res://Sprites/animations/tree.tres"),
	"SEEDS" : preload("res://Sprites/animations/seed.tres"),
	"GLASS" : preload("res://Sprites/animations/glass.tres"),
	"TOBACCO" : preload("res://Sprites/animations/toba.tres"),
	"WOOD" : preload("res://Sprites/animations/wood.tres"),
	"SAND" : preload("res://Sprites/animations/sand.tres"),
	"LIQUID_IRON" : preload("res://Sprites/animations/liq.tres"),
	"CIGARETTES" : preload("res://Sprites/animations/ciga.tres"),
	"GALENA" : preload("res://Sprites/animations/gale.tres"),
	"HUMUS" : preload("res://Sprites/animations/humus.tres"),
}

var autobuy_speed := 0.25
var up := {}

var COLORS := {
#	"fire": Color(1, 0, 0),
#	"frost": Color(0, 0.694118, 1),
#	"air": Color(0.612122, 0.394531, 1),
#	"earth": Color(1, 0.6, 0),
#	"stamina": Color(0.501961, 1, 0),
#	"barrier": Color(1, 0.8, 0),
#	"health": Color(1, 0, 0),
#	"mana": Color(0, 0.709804, 1),
#	"overwhelming power": Color(0.721569, 0.34902, 0.901961), #note too close to air?
	"GRIEF": Color(0.74902, 0.203922, 0.533333),
	"JOY": Color(1, 0.909804, 0),
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
	
	"seed": Color(1, 0.878431, 0.431373), # same as RANDOM_SEED v
	"RANDOM_SEED": Color(1, 0.878431, 0.431373), # same as seed ^
	
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
	
	"thewitchofloredelith": Color(0.937255, 0.501961, 0.776471),
	"spike": Color(0.76, 0, 0),
	"rare": Color(0.93, .84, 0),
	"common": Color(0.35, 0.35, 0.35),
	str(Tab.NORMAL): Color(0.733333, 0.458824, 0.031373),
	str(Tab.MALIGNANT): Color(0.878431, 0.121569, 0.34902),
	str(Tab.EXTRA_NORMAL): Color(0.47451, 0.870588, 0.694118),
	str(Tab.RADIATIVE): Color(1, 0.541176, 0.541176),
	str(Tab.SPIRIT): Color(1, 0.541176, 0.541176),
	str(Tab.RUNED_DIAL): Color(1, 0.541176, 0.541176),
	str(Tab.s4n): Color(1, 0.541176, 0.541176),
	str(Tab.s4m): Color(1, 0.541176, 0.541176),
	str(Tab.S1): Color(0.878431, 0.121569, 0.34902),
	str(Tab.S2): Color(1, 0.541176, 0.541176),
	str(Tab.S3): Color(0.8, 0.8, 0.8),
	str(Tab.S4): Color(0.8, 0.8, 0.8),
	"copy": Color(0.8, 0.8, 0.8),
	"grey": Color(0.8, 0.8, 0.8),
}

var open_tab := -1

func haveLoredsRequiredForExtraNormalUpgradeMenu() -> bool:
	for x in [lv.Type.SOIL, lv.Type.SEEDS, lv.Type.WATER, lv.Type.TREES, lv.Type.SAND, lv.Type.DRAW_PLATE, lv.Type.AXES, lv.Type.LIQUID_IRON, lv.Type.STEEL, lv.Type.WIRE, lv.Type.GLASS, lv.Type.HARDWOOD, lv.Type.WOOD, lv.Type.HUMUS]:
		if not lv.lored[x].purchased:
			return false
	return true






func time_remaining_including_INF(
	lored: int,
	present_amount: Big,
	total_amount: Big):
	
	
	if lv.lored[lored].asleep:
		return INF
	
	var net = lv.lored[lored].net()
	
	if net[1].greater(net[0]):
		return INF
	
	net = net[0].s(net[1])
	
	if net.equal(0):
		return INF
	
	var delta: Big = Big.new(total_amount).s(present_amount)
	var incoming_amount := Big.new(0)
	
	
	if lv.lored[lored].working:
		incoming_amount.a(lv.lored[lored].d.t)
	
	return Big.new(delta).s(incoming_amount).d(net)

func timeUntil(_resource: int, threshold: Big):
	
	if gv.resource[_resource].greater_equal(threshold):
		return Big.new(0)
	
	var rawNet = lv.net(_resource)
	var net = rawNet[0]
	var _sign = rawNet[1]
	
	if _sign < 1:
		return INF
	
	var amountRemaining = Big.new(threshold).s(gv.resource[_resource])
	
	return Big.new(amountRemaining).d(net)

func time_remaining(
	lored: int,
	present_amount: Big,
	total_amount: Big) -> String:
	
	
	if lv.lored[lored].asleep:
		return "Asleep"
	
	
	var net = lv.lored[lored].net() #z
	
	if net[1].greater(net[0]):
		return "-"
	
	net = net[0].s(net[1])
	
	if net.equal(0):
		return "!?"
	
	var delta: Big = Big.new(total_amount).s(present_amount)
	var incoming_amount := Big.new(0)
	
	
	if lv.lored[lored].working:
		incoming_amount.a(lv.lored[lored].output)
	
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

func parse_time_float(val) -> String:
	
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


func resetResources():
	for r in Resource.values():
		resource[r] = Big.new(0)



enum Resource {
	STONE,
	COAL,
	IRON_ORE,
	COPPER_ORE,
	IRON,
	COPPER,
	GROWTH,
	JOULES,
	CONCRETE,
	MALIGNANCY,
	TARBALLS,
	OIL,
	
	WATER,
	HUMUS,
	SEEDS,
	TREES,
	SOIL,
	AXES,
	WOOD,
	HARDWOOD,
	LIQUID_IRON,
	STEEL,
	SAND,
	GLASS,
	DRAW_PLATE,
	WIRE,
	GALENA,
	LEAD,
	PETROLEUM,
	WOOD_PULP,
	PAPER,
	PLASTIC,
	TOBACCO,
	CIGARETTES,
	CARCINOGENS,
	TUMORS,
	
	JOY,
	GRIEF,
	#EMBRYO,
	#SPIRIT,
	
	RANDOM_SEED,
	#MANA,
}
var resource := {}
var resourceName := {}
var resourceText := {}
var resourceColor := {}
func addToResource(key: int, val):
	resource[key].a(val)
	emit_signal("resourceChanged", key)
	stats["ResourceStats"]["collected"][key].a(val)
	emit_signal("ResourceCollected", key)
func subtractFromResource(key: int, val):
	if val.greater(resource[key]):
		resource[key] = Big.new(0)
	else:
		resource[key].s(val)
	emit_signal("resourceChanged", key)
func setResource(key: int, val):
	resource[key] = Big.new(val)
	emit_signal("resourceChanged", key)
func updateResources():
	for r in resource:
		emit_signal("resourceChanged", r)
var resourcesNotBeingExported := []
func exportBlocked(_resource: int):
	if _resource in resourcesNotBeingExported:
		return
	resourcesNotBeingExported.append(_resource)
	emit_signal("exportChanged")
func exportResumed(_resource: int):
	if not _resource in resourcesNotBeingExported:
		return
	resourcesNotBeingExported.erase(_resource)
	emit_signal("exportChanged")


var offlineEarnings := {}
func logOfflineEarnings(_resource: int, amount: Big, _sign: int):
	if not _resource in offlineEarnings:
		offlineEarnings[_resource] = [Big.new(amount), _sign]
		return
	
	if _sign == 1:
		if offlineEarnings[_resource][1] == 1:
			offlineEarnings[_resource][0].a(amount)
		else:
			if amount.greater_equal(offlineEarnings[_resource][0]):
				amount.s(offlineEarnings[_resource][0])
				offlineEarnings[_resource][0] = Big.new(amount)
				offlineEarnings[_resource][1] = 1
			else:
				offlineEarnings[_resource][0].s(amount)
	else:
		if offlineEarnings[_resource][1] == 1:
			if offlineEarnings[_resource][0].greater_equal(amount):
				offlineEarnings[_resource][0].s(amount)
			else:
				amount.s(offlineEarnings[_resource][0])
				offlineEarnings[_resource][0] = Big.new(amount)
				offlineEarnings[_resource][1] = -1
		else:
			offlineEarnings[_resource][0].a(amount)

func reportOfflineEarnings():
	for _resource in offlineEarnings:
		if offlineEarnings[_resource][1] == 1:
			print("+", offlineEarnings[_resource][0].toString(), " ", resourceName[_resource])
		else:
			print("-", offlineEarnings[_resource][0].toString(), " ", resourceName[_resource])

func clearOfflineEarnings():
	offlineEarnings.clear()

func setResourceColors():
	for _resource in Resource.values():
		resourceColor[_resource] = COLORS[shorthandByResource[_resource]]

signal exportChanged(_resource) # lored manager -> exportBlockedhere -> lored manager

signal resourceChanged(key)

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


var animationless = ["CARCINOGENS", "TUMORS", "PETROLEUM", "PAPER", "PLASTIC", "WOOD_PULP"]
var max_frame = {
	"STONE": 27,
	"COAL": 25,
	"IRON_ORE": 28,
	"COPPER_ORE": 25,
	"IRON": 47,
	"COPPER": 30,
	"GROWTH": 40,
	"JOULES": 32,
	"CONCRETE": 57,
	"MALIGNANCY": 36,
	"TARBALLS": 29,
	"OIL": 8,

	"WATER": 12,
	"HUMUS": 9,
	"SEEDS": 14,
	"TREES": 77,
	"SOIL": 42,
	"AXES": 2,
	"WOOD": 49,
	"HARDWOOD": 37,
	"LIQUID_IRON": 22,
	"STEEL": 58,
	"SAND": 45,
	"GLASS": 37,
	"DRAW_PLATE": 33,
	"WIRE": 27,
	"GALENA": 22,
	"LEAD": 11,
#	"PETROLEUM": ,
#	"WOOD_PULP": ,
#	"PAPER": ,
#	"PLASTIC": ,
	"TOBACCO": 73,
	"CIGARETTES": 25,
#	"CARCINOGENS": ,
#	"TUMORS": ,
	"refuel1": 28,
	"refuel0": 27,
}
var list := {}
func resetList():
	list = {
		upgrade = {"owned": {}},
		lored = {
			Tab.S1: [], Tab.S2: [], Tab.S3: [], Tab.S4: [],
			"active": [lv.Type.STONE], "active " + str(Tab.S1): [lv.Type.STONE], "active " + str(Tab.S2): [], "active " + str(Tab.S3): [], "active " + str(Tab.S4): [],
			"unlocked and inactive": [],
		},
		"stage 1 resources": [
			Resource.COAL,
			Resource.STONE,
			Resource.IRON_ORE,
			Resource.COPPER_ORE,
			Resource.IRON,
			Resource.COPPER,
			Resource.GROWTH,
			Resource.JOULES,
			Resource.CONCRETE,
			Resource.OIL,
			Resource.TARBALLS,
			Resource.MALIGNANCY
		],
		"stage 2 resources": [
			Resource.WATER,
			Resource.HUMUS,
			Resource.SEEDS,
			Resource.TREES,
			Resource.SOIL,
			Resource.AXES,
			Resource.WOOD,
			Resource.HARDWOOD,
			Resource.LIQUID_IRON,
			Resource.STEEL,
			Resource.SAND,
			Resource.GLASS,
			Resource.DRAW_PLATE,
			Resource.WIRE,
			Resource.GALENA,
			Resource.LEAD,
			Resource.PETROLEUM,
			Resource.WOOD_PULP,
			Resource.PAPER,
			Resource.PLASTIC,
			Resource.TOBACCO,
			Resource.CIGARETTES,
			Resource.CARCINOGENS,
			Resource.TUMORS
		],
		"unlocked resources": [Resource.STONE], #note stage 3 resources need to be manually added
		"matured resources": [],
		"fuel resource": [],
		"resource producer": {},
	}
	
	for t in Tab:
		list.upgrade[str(Tab[t])] = []
		list.upgrade["unowned " + str(Tab[t])] = []
		list.upgrade["owned " + str(Tab[t])] = []
	for t in Tab:
		list.upgrade[str(Tab[t])] = []
		list.upgrade["unowned " + str(Tab[t])] = []
		list.upgrade["owned " + str(Tab[t])] = []

func append(list: Array, value):
	if value in list:
		return
	list.append(value)

func everyStage2LOREDunlocked() -> bool:
	return list.lored["active " + str(Tab.S2)].size() == list.lored[Tab.S2].size()

func unlockResource(resource: int):
	if not resource in list["unlocked resources"]:
		list["unlocked resources"].append(resource)
	emit_signal("stats_unlockResource", resource)

func addResourceProducer(resource: int, lored: int):
	if not resource in list["resource producer"]:
		list["resource producer"][resource] = []
	if not lored in list["resource producer"][resource]:
		list["resource producer"][resource].append(lored)

func resourceBeingProduced(resource: int) -> bool:
	if list["resource producer"][resource].size() == 0:
		return false
	for lored in list["resource producer"][resource]:
		if lv.lored[lored].purchased:
			return true
	return false

func producerDrainUpdated(resource: int):
	if not resource in list["resource producer"]:
		return
	for producer in list["resource producer"][resource]:
		lv.lored[producer].updateOfflineNet(resource)


enum Objective {
	RESOURCES_PRODUCED,
	LORED_UPGRADED,
	UPGRADE_PURCHASED,
	SPELL_CAST_COUNT,
	LIMIT_BREAK_LEVEL,
	MAXED_FUEL_STORAGE,
	BREAK,
	HAVE_COMPANY,
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
	LORED_FUNCTIONALITY,
	ENABLE_RANDOM_EMOTES,
	NEW_JOB,
}

func highestResetKey() -> int:
	match highest_run:
		1: return gv.Resource.MALIGNANCY
		2: return gv.Resource.TUMORS
		#3: return gv.Resource.SPIRIT #s3
	return -1 #s4

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
var highest_run := 1
var most_resources_gained := Big.new(0)
var times_game_loaded := 0
var durationSinceLastReset := 0
var run1duration := 0
var run2duration := 0
var run3duration := 0
var run4duration := 0

signal TimesLeveledUp(lored, manual)
signal AnimationsPlayed(lored)
signal TimesRefueled(lored)
signal OtherJobs(lored)
signal TimeAsleep(lored)
signal Crits(lored)
signal statChanged(stat)
signal statChanged2(stat, type)
signal LOREDGranted(lored)
signal LOREDDenied(lored)
signal UpgradesPurchased(tier)
signal ResourceCollected(resource)
signal ResourceUsed(resource)
signal ResourceSpent(resource)
signal Reset(stage)
signal stats_unlockLOREDStats(lored)
signal stats_unlockResource(resource)
signal stats_unlockRuns
signal stats_unlockTab(tab)

var stats := {
	"WishMain": 0,
	"WishGranted": 0,
	"WishDenied": 0,
	"AnimationsPlayed": {},
	"TimesRefueled": {},
	"OtherJobs": {},
	"TimeAsleep": {},
	"Crits": {},
	"TimesLeveledUp": {"manual": {}, "automated": {}},
	"LOREDGranted": {},
	"LOREDDenied": {},
	"WishStats": {
		"Level Up": {"granted": 0, "denied": 0,},
		"Random Resource": {"granted": 0, "denied": 0,},
		"Sleep": {"granted": 0, "denied": 0,},
		"Buy Upgrade": {"granted": 0, "denied": 0,},
		"Refuel": {"granted": 0, "denied": 0,},
		"Joy Collection": {"granted": 0, "denied": 0,},
		"Grief Collection": {"granted": 0, "denied": 0,},
		#"Limit Break": {"granted": 0, "denied": 0,},
	},
	"UpgradesPurchased": {},
	"ResourceStats": {"collected": {}, "used": {}, "spent": {}},
	"Run": {
		Tab.S1: {"quickest": 1000000000000, "longest": 0},
		Tab.S2: {"quickest": 1000000000000, "longest": 0},
		Tab.S3: {"quickest": 1000000000000, "longest": 0},
		Tab.S4: {"quickest": 1000000000000, "longest": 0},
	}
}
func setupStats():
	for x in lv.lored:
		stats["AnimationsPlayed"][x] = 0
		stats["TimesRefueled"][x] = 0
		stats["OtherJobs"][x] = 0
		stats["TimeAsleep"][x] = 0
		stats["Crits"][x] = 0
		stats["TimesLeveledUp"]["manual"][x] = 0
		stats["TimesLeveledUp"]["automated"][x] = 0
		stats["LOREDGranted"][x] = 0
		stats["LOREDDenied"][x] = 0
	for x in Tab.values():
		if x == Tab.S1:
			break
		stats["UpgradesPurchased"][x] = 0
	for x in Resource.values():
		stats["ResourceStats"]["used"][x] = Big.new(0)
		stats["ResourceStats"]["collected"][x] = Big.new(0)
		stats["ResourceStats"]["spent"][x] = Big.new(0)

func runReset(stage: int):
	match stage:
		Tab.S1:
			if run1duration < stats["Run"][Tab.S1]["quickest"]:
				stats["Run"][Tab.S1]["quickest"] = max(run1duration, 1)
			if run1duration > stats["Run"][Tab.S1]["longest"]:
				stats["Run"][Tab.S1]["longest"] = max(run1duration, 1)
			run1duration = 0
		Tab.S2:
			if run2duration < stats["Run"][Tab.S2]["quickest"]:
				stats["Run"][Tab.S2]["quickest"] = max(run2duration, 1)
			if run2duration > stats["Run"][Tab.S2]["longest"]:
				stats["Run"][Tab.S2]["longest"] = max(run2duration, 1)
			run2duration = 0
		Tab.S3:
			if run3duration < stats["Run"][Tab.S3]["quickest"]:
				stats["Run"][Tab.S3]["quickest"] = max(run3duration, 1)
			if run3duration > stats["Run"][Tab.S3]["longest"]:
				stats["Run"][Tab.S3]["longest"] = max(run3duration, 1)
			run3duration = 0
		Tab.S4:
			if run4duration < stats["Run"][Tab.S4]["quickest"]:
				stats["Run"][Tab.S4]["quickest"] = max(run4duration, 1)
			if run4duration > stats["Run"][Tab.S4]["longest"]:
				stats["Run"][Tab.S4]["longest"] = max(run4duration, 1)
			run4duration = 0


var tab_vertical := [0, 0, 0, 0]
var option := {}

var lastSaveClock = OS.get_unix_time()

func update_clock():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		cur_clock = OS.get_unix_time()
		
		t.start(1)
		yield(t, "timeout")
		
		if active_scene == Scene.ROOT:
			cur_session += 1
			time_played += 1
			run1duration += 1
			run2duration += 1
			run3duration += 1
			run4duration += 1
			durationSinceLastReset += 1
			if option["autosave"]:
				if cur_clock - lastSaveClock >= 30:
					SaveManager.save()
		else:
			cur_session = 0
	
	t.queue_free()

# scene stuff
enum Scene {
	MAIN_MENU,
	ROOT,
	}
var active_scene: int
var closing: bool
func close():
	closing = true
	# Root closed
	resetList()
	setupOptions()
	
	time_played = 0
	
	lv.close()
	up.clear()
	resource.clear()
	for r in resource:
		gv.resourceChanged[r] = true
func open():
	closing = false
	resetResources()


# main menu
var font := {
	buttonNormal = DynamicFont.new(),
	buttonHover = DynamicFont.new(),
}
signal edit_save_color(node)
signal hideAllActions


func getRandomColor() -> Color:
	return Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1)







func changeScene(newScene: int):
	
	Boot.go()
	open()
	
	match newScene:
		Scene.ROOT:
			get_tree().change_scene("res://Scenes/Root.tscn")


signal manualLabor
var manualLaborActive := false

var gameStarted := false
signal startGame
func gameStarted():
	gameStarted = true

func upgradeTierByTab(tab: int) -> String:
	return Tab.keys()[tab].replace("_", "-").capitalize()

func tabByShorthand(shorthand: String) -> int:
	match shorthand:
		"s1m":
			return Tab.MALIGNANT
		"s2n":
			return Tab.EXTRA_NORMAL
		"s2m":
			return Tab.RADIATIVE
	return Tab.NORMAL


func inFirstTwoSecondsOfRun() -> bool:
	return durationSinceLastReset < 2



func randomLORED() -> int:
	return list.lored["active"][randi() % list.lored["active"].size()]


func timer(duration: float):
	yield(get_tree().create_timer(duration), "timeout")



func throwOutputTexts(allTexts: Array, parent_node):
	for textDetails in allTexts:
		newOutputText(textDetails, parent_node)
		yield(get_tree().create_timer(0.1), "timeout")


func newOutputText(details: Dictionary, parent_node):
	
	var outputText = SRC["flying text"].instance()
	outputText.init(details)
	parent_node.add_child(outputText)
