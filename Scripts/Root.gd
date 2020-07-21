class_name _root
extends Node2D

var FPS = 0.04
const SAVE := {
	MAIN = "user://save.lored",
	NEW = "user://new_save.lored",
	OLD = "user://last_save.lored"
}
const PLATFORM = "browser" # keep lower-case

const anim = {
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
const prefab := {
	tasks = preload("res://Prefabs/task/tasks.tscn"),
	
	tip_autobuyer = preload("res://Prefabs/tooltip/autobuyer.tscn"),
	
	"upgrade_back": preload("res://Prefabs/upgrade/upgrade_back.tscn"),
	"upgrade": preload("res://Prefabs/upgrade/upgrade.tscn"),
	"dtext": preload("res://Prefabs/dtext.tscn"),
	"confirmation popup": preload("res://Prefabs/lored_buy.tscn"),
	"resource_bar_text": preload("res://Prefabs/resource_bar_text.tscn"),
	"menu": preload("res://Prefabs/menu/menu.tscn"),
	
	"progress_texture_limit_break": preload("res://Prefabs/lored/progress_texture_limit_break.tscn"),
}

var content := {}
var content_tasks := {}
var instances := {}
var upgrade_dtexts := {}
var upc := {
	"s1nup" : {},
	"s1mup" : {},
	"s2nup" : {},
	"s2mup" : {},
} # all on-screen upgrades are found in here
var afford_check_fps := 0.0

var save_fps = 0.0
var times_game_loaded = 0
var loredalert = ""

var cur_clock = OS.get_unix_time()
var last_clock = OS.get_unix_time()
var cur_session = 0
var time_fps = 0.0

var menu_window = 0


# nam : String, des : String, rr : Dictionary, 	r : Dictionary, stepz : Dictionary, ico : Texture
var tasks := {
	
	"Intro!": taq.Task.new(
		"Intro!",
		"Your Stone LORED requires fuel to work. Buy a Coal LORED with the Stone you already have.",
		{"stone" : Big.new(10)},
		{},
		{"Coal LORED bought": Ob.Num.new()},
		{texture = gv.sprite["coal"], key = "coal"},
		r_lored_color("coal")
	),
	"More Intro!": taq.Task.new(
		"More Intro!",
		"",
		{"stone": Big.new(20), "iron": Big.new(20), "cop": Big.new(10)},
		{"New LORED: Iron Ore": gv.sprite["irono"],
		"New LORED: Copper Ore": gv.sprite["copo"],
		"New LORED: Iron": gv.sprite["iron"],
		"New LORED: Copper": gv.sprite["cop"]},
		{"Stone produced": Ob.Num.new(10.0)},
		{texture = gv.sprite["stone"], key = "stone"},
		r_lored_color("stone")
	),
	"Welcome to LORED": taq.Task.new(
		"Welcome to LORED",
		"Upgrading LOREDs doubles their output and fuel burnt per tick.",
		{"coal": Big.new(10), "stone" : Big.new(25)},
		{"Normal Upgrade Menu": gv.sprite["s1nup"]},
		{"Stone LORED bought": Ob.Num.new()},
		{texture = gv.sprite["stone"], key = "stone"},
		r_lored_color("stone")
	),
	"Upgrades!": taq.Task.new(
		"Upgrades!",
		"Purchase the GRINDER upgrade in the Normal Upgrades menu. (Hotkey: Q)",
		{"iron" : Big.new(3), "cop": Big.new(5)},
		{},
		{"GRINDER purchased": Ob.Num.new()},
		{texture = gv.sprite["s1nup"], key = "s1nup"},
		r_lored_color("s1nup")
	),
	"Menu!": taq.Task.new(
		"Menu!",
		"Turn on the resource bar in the menu. You can turn it off after, if you want.",
		{"stone": Big.new(15)},
		{"Task Board": gv.sprite["copy"]},
		{"Menu opened": Ob.Num.new(),
		"Options tab opened": Ob.Num.new(),
		"Resource bar displayed": Ob.Num.new()},
		{texture = gv.sprite["s1"], key = "s1"},
		r_lored_color("s1")
	),
	
	"Tasks!": taq.Task.new(
		"Tasks!",
		"Tasks are random, mini-quests. They can help you out of a tough spot, or to more quickly purchase what you want!",
		{"coal": Big.new(10)},
		{"Max tasks +1": gv.sprite["copy"]},
		{"Tasks completed": Ob.Num.new(5)},
		{texture = gv.sprite["copy"], key = "copy"},
		r_lored_color("copy")
	),
	
	"Pretty Wet": taq.Task.new(
		"Pretty Wet",
		"",
		{"iron": Big.new(50), "cop": Big.new(50)},
		{"New LORED: Growth": gv.sprite["growth"]},
		{"Stone produced": Ob.Num.new(1000.0)},
		{texture = gv.sprite["growth"], key = "growth"},
		r_lored_color("growth")
	),
	"Progress": taq.Task.new(
		"Progress",
		"",
		{"stone": Big.new(50)},
		{},
		{"RYE purchased": Ob.Num.new()},
		{texture = gv.sprite["cop"], key = "cop"},
		r_lored_color("cop")
	),
	"Electricy": taq.Task.new(
		"Electricy",
		"Some LOREDs run on electricity instead of coal!",
		{"iron": Big.new(250), "cop": Big.new(250)},
		{"New LORED: Joules": gv.sprite["jo"],
		"New LORED: Concrete": gv.sprite["conc"]},
		{"Combined resources produced": Ob.Num.new(10000.0)},
		{texture = gv.sprite["jo"], key = "jo"},
		r_lored_color("jo")
	),
	"Sandy Progress": taq.Task.new(
		"Sandy Progress",
		"",
		{"stone": Big.new(100)},
		{},
		{"SAND purchased": Ob.Num.new()},
		{texture = gv.sprite["growth"], key = "growth"},
		r_lored_color("growth")
	),
	"Spread": taq.Task.new(
		"Spread",
		"",
		{"iron": Big.new(1000), "cop": Big.new(1000), "malig": Big.new(10)},
		{"New LORED: Oil": gv.sprite["oil"],
		"New LORED: Tarballs": gv.sprite["tar"],
		"New LORED: Malignancy": gv.sprite["malig"]},
		{"Combined resources produced": Ob.Num.new(100000.0)},
		{texture = gv.sprite["malig"], key = "malig"},
		r_lored_color("malig")
	),
	
	"Lots of Tasks!": taq.Task.new(
		"Lots of Tasks!",
		"",
		{"iron": Big.new(1000), "cop": Big.new(1000)},
		{"Max tasks +1": gv.sprite["copy"]},
		{"Tasks completed": Ob.Num.new(10)},
		{texture = gv.sprite["copy"], key = "copy"},
		r_lored_color("copy")
	),
	
	"Consume": taq.Task.new(
		"Consume",
		"",
		{},
		{"Malignant Upgrade Menu": gv.sprite["s1mup"]},
		{"Malignancy produced": Ob.Num.new(3000.0)},
		{texture = gv.sprite["malig"], key = "malig"},
		r_lored_color("malig")
	),
	
	"Evolve": taq.Task.new(
		"Evolve",
		"Purchase Malignant upgrade SOCCER DUDE by resetting your game. You are free to save up Malignancy before resetting!",
		{"malig": Big.new(1000)},
		{},
		{"SOCCER DUDE purchased": Ob.Num.new()},
		{texture = gv.sprite["s1"], key = "s1"},
		r_lored_color("malig")
	),
	"A Million Reasons to Grind": taq.Task.new(
		"A Million Reasons to Grind",
		"Hit SPACE, ENTER, or NUM PAD ENTER to turn in all tasks.",
		{"iron": Big.new(100000), "cop": Big.new(100000), "stone": Big.new(199999), "growth": Big.new(600001)},
		{"Max tasks +1": gv.sprite["copy"]},
		{"Tasks completed": Ob.Num.new(50)},
		{texture = gv.sprite["copy"], key = "copy"},
		r_lored_color("malig")
	),
	
	"The Loop": taq.Task.new(
		"The Loop",
		"",
		{"conc": Big.new("1e9")},
		{},
		{"upgrade_name purchased": Ob.Num.new()},
		{texture = gv.sprite["s2"], key = "s2"},
		r_lored_color("s2")
	),
	
	"A New Leaf": taq.Task.new(
		"A New Leaf",
		"Advances your existence to a Stage 2 presence.",
		{"seed": Big.new(2), "soil": Big.new(25), "wood": Big.new(80)},
		{"New LORED: Trees": gv.sprite["tree"], "New LORED: Water": gv.sprite["water"], "New LORED: Seeds": gv.sprite["seed"]},
		{"Combined resources produced": Ob.Num.new("1e9")},
		{texture = gv.sprite["s2"], key = "s2"},
		r_lored_color("s2")
	),
	"Steel Pattern": taq.Task.new(
		"Steel Pattern",
		"",
		{"hard": Big.new(95), "steel": Big.new(25)},
		{"New LORED: Liquid Iron": gv.sprite["liq"], "New LORED: Steel": gv.sprite["steel"]},
		{"Trees produced": Ob.Num.new(5.0)},
		{texture = gv.sprite["steel"], key = "steel"},
		r_lored_color("steel")
	),
	"Wire Trail": taq.Task.new(
		"Wire Trail",
		"",
		{"wire": Big.new(20), "glass": Big.new(30)},
		{"New LORED: Wire": gv.sprite["wire"], "New LORED: Draw Plate": gv.sprite["draw"]},
		{"Steel produced": Ob.Num.new(5.0)},
		{texture = gv.sprite["wire"], key = "wire"},
		r_lored_color("wire")
	),
	"Hardwood Cycle": taq.Task.new(
		"Hardwood Cycle",
		"",
		{"liq": Big.new(100), "axe": Big.new(5)},
		{"New LORED: Wood": gv.sprite["wood"], "New LORED: Axes": gv.sprite["axe"], "New LORED: Hardwood": gv.sprite["hard"]},
		{"Wire produced": Ob.Num.new(50.0)},
		{texture = gv.sprite["hard"], key = "hard"},
		r_lored_color("hard")
	),
	"Glass Pass": taq.Task.new(
		"Glass Pass",
		"",
		{"steel": Big.new(50), "sand": Big.new(250)},
		{"New LORED: Glass": gv.sprite["glass"], "New LORED: Sand": gv.sprite["sand"], "New LORED: Humus": gv.sprite["humus"], "New LORED: Soil": gv.sprite["soil"]},
		{"Hardwood produced": Ob.Num.new(50.0)},
		{texture = gv.sprite["glass"], key = "glass"},
		r_lored_color("glass")
	),
	"The Heart of Things": taq.Task.new(
		"The Heart of Things",
		"",
		{"steel": Big.new(10), "hard": Big.new(10), "wire": Big.new(10), "glass": Big.new(10)},
		{"New LORED: Tumors": gv.sprite["tum"], "Extra-normal Upgrade Menu": gv.sprite["s2nup"]},
		{"Soil produced": Ob.Num.new(25.0)},
		{texture = gv.sprite["tum"], key = "tum"},
		r_lored_color("tum")
	),
	
	"Spike": taq.Task.new(
		"Spike",
		"Rare and Spike tasks take longer than regular tasks, but they reward a lot more stuff!",
		{"wood": Big.new(10000), "water": Big.new(20000), "liq": Big.new(30000)},
		{"Tasks are automatically turned in": gv.sprite["copy"]},
		{"Rare or Spike tasks completed": Ob.Num.new(3)},
		{texture = gv.sprite["copy"], key = "copy"},
		Color(0.933333, 0.839216, 0)
	),
	
	"Lead by Example": taq.Task.new(
		"Lead by Example",
		"",
		{},
		{"New LORED: Galena": gv.sprite["gale"], "New LORED: Lead": gv.sprite["lead"]},
		{"Hardwood produced": Ob.Num.new(200.0),"Wire produced": Ob.Num.new(200.0),"Glass produced": Ob.Num.new(200.0)},
		{texture = gv.sprite["tum"], key = "tum"},
		r_lored_color("tum")
	),
	"Paper or Plastic?": taq.Task.new(
		"Paper or Plastic?",
		"",
		{"axe": Big.new(3000)},
		{"New LORED: Wood Pulp": gv.sprite["pulp"], "New LORED: Paper": gv.sprite["paper"], "New LORED: Petroleum": gv.sprite["pet"], "New LORED: Plastic": gv.sprite["plast"]},
		{"Lead produced": Ob.Num.new(800.0)},
		{texture = gv.sprite["paper"], key = "paper"},
		r_lored_color("lead")
	),
	"Carcinogenic": taq.Task.new(
		"Carcinogenic",
		"Hey, smoke up, Johnny!",
		{},
		{"New LORED: Tobacco": gv.sprite["toba"], "New LORED: Cigarettes": gv.sprite["ciga"], "New LORED: Carcinogens": gv.sprite["carc"]},
		{"Paper produced": Ob.Num.new(100.0), "Plastic produced": Ob.Num.new(100.0)},
		{texture = gv.sprite["carc"], key = "carc"},
		r_lored_color("paper")
	),
	
	"Cringey Progress": taq.Task.new(
		"Cringey Progress",
		"",
		{"steel": Big.new(1000)},
		{},
		{"Sagan purchased": Ob.Num.new()},
		{texture = gv.sprite["s2"], key = "s2"},
		r_lored_color("s2")
	),
	
	"Cancer Lord": taq.Task.new(
		"Cancer Lord",
		"Did you think you'd ever get here?",
		{},
		{"Radiative Upgrade Menu": gv.sprite["s2mup"]},
		{"Tumors produced": Ob.Num.new(5000.0)},
		{texture = gv.sprite["tum"], key = "tum"},
		r_lored_color("tum")
	),
	
	"Horse Doodie": taq.Task.new(
		"Horse Doodie",
		"",
		{},
		{"10x easier tasks": gv.sprite["copy"]},
		{"Spike tasks completed": Ob.Num.new(1)},
		{texture = gv.sprite["copy"], key = "copy"},
		Color(0.756863, 0, 0)
	),
}

var tabby := {}

var tip := {}

var task_awaiting := "no"


const DEFAULT_KEY_LOREDS := " stone conc malig water lead tree soil steel wire glass tum "

var hax = 1 # 1 for normal

func _ready():
	
	# work
	if true:
		
		# menu set up
		if true:
			
			gv.menu.option["on_save_menu_options"] = true
			gv.menu.option["FPS"] = 0
			if "desktop" in PLATFORM:
				gv.menu.option["FPS"] = 7
			else:
				gv.menu.option["FPS"] = 5
			gv.menu.option["notation_type"] = 0
			gv.menu.option["resource_bar"] = false
			gv.menu.option["resource_bar_net"] = false
			gv.menu.option["status_color"] = false
			gv.menu.option["flying_numbers"] = true
			gv.menu.option["crits_only"] = false
			gv.menu.option["animations"] = true
			gv.menu.option["tooltip_halt"] = true
			gv.menu.option["tooltip_hold"] = true
			gv.menu.option["tooltip_fuel"] = true
			gv.menu.option["tooltip_autobuyer"] = true
			gv.menu.option["on_save_halt"] = false
			gv.menu.option["on_save_hold"] = false
			gv.menu.option["im_ss_show_hint"] = true
			gv.menu.option["limit_break_text"] = true
			gv.menu.option["lb_flash"] = false
			gv.menu.option["task auto"] = false
			gv.menu.option["performance"] = true
			gv.menu.option["tank_my_pc"] = false
			
			OS.set_low_processor_usage_mode(true)
		
		# tips
		if true:
			
			tip["Upgrading LOREDs"] = "Doubles output, fuel drain per 1/60th of a second, and fuel storage, and triples the price (excluding upgrades). Input always increases proportionately to output.\n\nIf a LORED costs a resource that belongs to a LORED in a lower stage, the cost increase will be 3^(3 * (Stages above it it is)). Does that even make sense? I swear I'm trying. So the Plastic LORED cost increase is 9x. yea."
			tip["Hotkeys"] = "1: Stage 1 LOREDs\n2: Stage 2 LOREDs\nLetters seen on Upgrade menu buttons: ...upgrade menus\nSPACE, ENTER, or NUMPAD ENTER: Complete all ready tasks. If none, complete quest if ready."
			tip["Status colors"] = "Yellow: possibly bad, probably fine.\nRed: definitely bad.\nLORED color: manually halted."
			tip["Critical strikes"] = "Critical strikes multiply the output by between 7.5 and 12.5. Output texts and earnings calculations account for this like so: (output * (1 + (crit_chance / 10)))"
			tip["Offline earnings"] = "Me brain no big, too smol, to for to account for with autobuyers, but you'll gain resources at a rate of 1.0x of what you were getting them at when you left."
			tip["Notation"] = "e just means how many zeros follow whatever number is before the e (or how many times it's multiplied by 10). So, 1e0 = 1,\n1e1 = 10,\n1e2 = 100,\n1e3 = 1,000.\n5e6 = 5,000,000 -- 5, plus 6 zeros; 5 million."
		
		# menu and stats
		if true:
			
			gv.menu.tabs_unlocked["1"] = false
			gv.menu.tabs_unlocked["2"] = false
			gv.menu.tabs_unlocked["3"] = false
			gv.menu.tabs_unlocked["4"] = false
			
			for x in upc:
				gv.menu.tabs_unlocked[x] = false
				gv.menu.upgrades_owned[x] = 0
			
			gv.stats = Statistics.new(gv.g.keys())
			
			for x in gv.up:
				
				gv.up[x].name = x
				gv.up[x].color = r_lored_color(gv.up[x].main_lored_target)
				
				var uplistkey = gv.up[x].type.split("up ")[1]
				if not uplistkey in gv.stats.up_list.keys():
					gv.stats.up_list[uplistkey] = []
				gv.stats.up_list[uplistkey].append(x)
				
				for v in gv.up:
					if v == x:
						continue
					if gv.up[v].requires == x:
						gv.up[x].required_by.append(v)
			
			for x in gv.up:
				# must be done here, after up_list is defined above
				gv.up[x].sync()
		
		# tab info
		if true:
			
			tabby["last stage"] = "1"
			tabby["1"] = 150.0
			tabby["2"] = 150.0
			tabby["s1n"] = 200.0
			tabby["s1m"] = 200.0
			tabby["s2n"] = 200.0
			tabby["s2m"] = 200.0
		
		_ready_define_loreds(0)
		_ready_define_upgrades()
		
		w_aa()
		$map/loreds.init()
		
		get_tree().get_root().connect("size_changed", self, "r_window_size_changed")
	
	# ref
	if true:
		
		# upprefab
		if true:
			
			var size := Vector2(45, 45)
			var pad := Vector2(size.x + 45, size.y + 45)
			
			# setup
			if true:
				
				for x in gv.up:
					
					if "reset" in gv.up[x].type:
						continue
					
					upc[gv.up[x].path][x] = prefab["upgrade"].instance()
					$map/upgrades.get_node(gv.up[x].path).add_child(upc[gv.up[x].path][x])
					upc[gv.up[x].path][x].init(x, gv.up[x].path, r_lored_color(gv.up[x].main_lored_target))
				
				var i := 0
				var v : Vector2
				for x in upc:
					i = 0
					v = Vector2(10, -1900)
					$map/upgrades.get_node(x).hide()
					for c in upc[x]:
						i += 1
						if i == 20:
							v.y += size.y + 5
							v.x = 10
							i = 1
						upc[x][c].rect_position = Vector2(v.x + i * (size.x / 1.5), v.y)
			
			# s2m
			if true:
				
				var f := "s2mup"
				
				# 0 - 9
				if true:
					
					# -1
					upc[f]["Limit Break"].rect_position = Vector2(400 - size.x /2, 300)
					
					# 0
					upc[f]["FALCON PAWNCH"].rect_position = Vector2(800 - size.x - 15 - pad.y, upc[f]["Limit Break"].rect_position.y - pad.y)
					upc[f]["MILK"].rect_position = Vector2(upc[f]["FALCON PAWNCH"].rect_position.x + pad.x, upc[f]["FALCON PAWNCH"].rect_position.y)
					upc[f]["Rock-hard Entrance"].rect_position = Vector2(upc[f]["FALCON PAWNCH"].rect_position.x - pad.x, upc[f]["FALCON PAWNCH"].rect_position.y)
					upc[f]["Splishy Splashy"].rect_position = Vector2(upc[f]["Rock-hard Entrance"].rect_position.x - pad.x, upc[f]["FALCON PAWNCH"].rect_position.y)
					upc[f]["RELEASE THE RIVER"].rect_position = Vector2(upc[f]["Splishy Splashy"].rect_position.x - pad.x, upc[f]["FALCON PAWNCH"].rect_position.y)
					
					upc[f]["Mudslide"].rect_position = Vector2(upc[f]["RELEASE THE RIVER"].rect_position.x - pad.x, upc[f]["RELEASE THE RIVER"].rect_position.y - pad.y / 2)
					
					upc[f]["MECHANICAL"].rect_position = Vector2(15, upc[f]["FALCON PAWNCH"].rect_position.y)
					upc[f]["RED NECROMANCY"].rect_position = Vector2(upc[f]["MECHANICAL"].rect_position.x + pad.x, upc[f]["MECHANICAL"].rect_position.y)
					
					# 1
					upc[f]["KAIO-KEN"].rect_position = Vector2(upc[f]["FALCON PAWNCH"].rect_position.x, upc[f]["FALCON PAWNCH"].rect_position.y - pad.y)
					upc[f]["GATORADE"].rect_position = Vector2(upc[f]["MILK"].rect_position.x, upc[f]["MILK"].rect_position.y - pad.y)
					upc[f]["Road Head Start"].rect_position = Vector2(upc[f]["Rock-hard Entrance"].rect_position.x, upc[f]["Rock-hard Entrance"].rect_position.y - pad.y)
					upc[f]["AUTOSMITHY"].rect_position = Vector2(upc[f]["Splishy Splashy"].rect_position.x, upc[f]["Splishy Splashy"].rect_position.y - pad.y)
					upc[f]["Iron Liquidizer"].rect_position = Vector2(upc[f]["AUTOSMITHY"].rect_position.x -pad.x, upc[f]["AUTOSMITHY"].rect_position.y)
					upc[f]["The Great Journey"].rect_position = Vector2(upc[f]["Mudslide"].rect_position.x, upc[f]["Mudslide"].rect_position.y - pad.y)
					
					upc[f]["THE WITCH OF LOREDELITH"].rect_position = Vector2(upc[f]["RED NECROMANCY"].rect_position.x, upc[f]["RED NECROMANCY"].rect_position.y - pad.y)
					upc[f]["GRIMOIRE"].rect_position = Vector2(upc[f]["THE WITCH OF LOREDELITH"].rect_position.x + pad.x, upc[f]["THE WITCH OF LOREDELITH"].rect_position.y)
					upc[f]["don't take candy from babies"].rect_position = Vector2(upc[f]["MECHANICAL"].rect_position.x, upc[f]["MECHANICAL"].rect_position.y - pad.y)
					
					# 2
					upc[f]["DANCE OF THE FIRE GOD"].rect_position = Vector2(upc[f]["KAIO-KEN"].rect_position.x, upc[f]["KAIO-KEN"].rect_position.y - pad.y)
					upc[f]["APPLE JUICE"].rect_position = Vector2(upc[f]["GATORADE"].rect_position.x, upc[f]["GATORADE"].rect_position.y - pad.y)
					upc[f]["DIII Boost From Clan Mate"].rect_position = Vector2(upc[f]["Road Head Start"].rect_position.x, upc[f]["Road Head Start"].rect_position.y - pad.y)
					upc[f]["AUTOSENSU"].rect_position = Vector2(upc[f]["AUTOSMITHY"].rect_position.x, upc[f]["AUTOSMITHY"].rect_position.y - pad.y)
					upc[f]["Snake Way"].rect_position = Vector2(upc[f]["AUTOSENSU"].rect_position.x - pad.x, upc[f]["AUTOSENSU"].rect_position.y)
					upc[f]["BEAVER"].rect_position = Vector2(upc[f]["The Great Journey"].rect_position.x, upc[f]["The Great Journey"].rect_position.y - pad.y)
					
					upc[f]["SPEED-SHOPPER"].rect_position = Vector2(upc[f]["don't take candy from babies"].rect_position.x, upc[f]["don't take candy from babies"].rect_position.y - pad.y)
					upc[f]["Elbow Straps"].rect_position = Vector2(upc[f]["THE WITCH OF LOREDELITH"].rect_position.x, upc[f]["THE WITCH OF LOREDELITH"].rect_position.y - pad.y)
					
					# 3
					upc[f]["RASENGAN"].rect_position = Vector2(upc[f]["DANCE OF THE FIRE GOD"].rect_position.x, upc[f]["DANCE OF THE FIRE GOD"].rect_position.y - pad.y)
					upc[f]["PEPPERMINT MOCHA"].rect_position = Vector2(upc[f]["APPLE JUICE"].rect_position.x, upc[f]["APPLE JUICE"].rect_position.y - pad.y)
					upc[f]["Life Ins, RIP Grandma"].rect_position = Vector2(upc[f]["DIII Boost From Clan Mate"].rect_position.x, upc[f]["DIII Boost From Clan Mate"].rect_position.y - pad.y)
					upc[f]["Sudden Commission"].rect_position = Vector2(upc[f]["AUTOSENSU"].rect_position.x, upc[f]["AUTOSENSU"].rect_position.y - pad.y)
					upc[f]["mods enabled"].rect_position = Vector2(upc[f]["BEAVER"].rect_position.x, upc[f]["BEAVER"].rect_position.y - pad.y)
					
					upc[f]["KETO"].rect_position = Vector2(upc[f]["Elbow Straps"].rect_position.x, upc[f]["Elbow Straps"].rect_position.y - pad.y)
					upc[f]["Hey, that's pretty good!"].rect_position = Vector2(upc[f]["KETO"].rect_position.x + pad.x, upc[f]["KETO"].rect_position.y)
					upc[f]["we were so close, now you don't even think about me"].rect_position = Vector2(upc[f]["SPEED-SHOPPER"].rect_position.x, upc[f]["SPEED-SHOPPER"].rect_position.y - pad.y)
					
					# 4
					upc[f]["AVATAR STATE"].rect_position = Vector2(upc[f]["RASENGAN"].rect_position.x, upc[f]["RASENGAN"].rect_position.y - pad.y)
					upc[f]["STRAWBERRY BANANA SMOOTHIE"].rect_position = Vector2(upc[f]["PEPPERMINT MOCHA"].rect_position.x, upc[f]["PEPPERMINT MOCHA"].rect_position.y - pad.y)
					upc[f]["OH YEEAAAAHH"].rect_position = Vector2(upc[f]["Life Ins, RIP Grandma"].rect_position.x, upc[f]["Life Ins, RIP Grandma"].rect_position.y - pad.y)
					upc[f]["Master"].rect_position = Vector2(upc[f]["Sudden Commission"].rect_position.x, upc[f]["Sudden Commission"].rect_position.y - pad.y)
					upc[f]["Apprentice"].rect_position = Vector2(upc[f]["Master"].rect_position.x - pad.x, upc[f]["Master"].rect_position.y)
					
					upc[f]["Power Schlonks"].rect_position = Vector2(upc[f]["Hey, that's pretty good!"].rect_position.x, upc[f]["Hey, that's pretty good!"].rect_position.y - pad.y)
					upc[f]["IT'S SPREADIN ON ME"].rect_position = Vector2(upc[f]["KETO"].rect_position.x, upc[f]["KETO"].rect_position.y - pad.y)
					upc[f]["the athore coments al totol lies!"].rect_position = Vector2(upc[f]["we were so close, now you don't even think about me"].rect_position.x, upc[f]["we were so close, now you don't even think about me"].rect_position.y - pad.y)
					
					# 5
					upc[f]["HAMON"].rect_position = Vector2(upc[f]["AVATAR STATE"].rect_position.x, upc[f]["AVATAR STATE"].rect_position.y - pad.y)
					upc[f]["GREEN TEA"].rect_position = Vector2(upc[f]["STRAWBERRY BANANA SMOOTHIE"].rect_position.x, upc[f]["STRAWBERRY BANANA SMOOTHIE"].rect_position.y - pad.y)
					upc[f]["I know what I'm doing, unlock this shit"].rect_position = Vector2(upc[f]["OH YEEAAAAHH"].rect_position.x, upc[f]["OH YEEAAAAHH"].rect_position.y - pad.y)
					upc[f]["AXELOT"].rect_position = Vector2(upc[f]["Master"].rect_position.x, upc[f]["Master"].rect_position.y - pad.y)
					upc[f]["lemme axe u summ"].rect_position = Vector2(upc[f]["AXELOT"].rect_position.x - pad.x, upc[f]["AXELOT"].rect_position.y)
					upc[f]["Covenant Dance"].rect_position = Vector2(upc[f]["lemme axe u summ"].rect_position.x - pad.x, upc[f]["lemme axe u summ"].rect_position.y - pad.y / 2)
					
					
					upc[f]["AUTO-PERSIST"].rect_position = Vector2(upc[f]["the athore coments al totol lies!"].rect_position.x, upc[f]["the athore coments al totol lies!"].rect_position.y - pad.y)
					upc[f]["CONDUCT"].rect_position = Vector2(upc[f]["Power Schlonks"].rect_position.x, upc[f]["Power Schlonks"].rect_position.y - pad.y)
					var x = "what in cousin-fuckin tarnation alabama betty crocker miss fuckin betty white shit is this"
					upc[f][x].rect_position = Vector2(upc[f]["IT'S SPREADIN ON ME"].rect_position.x, upc[f]["IT'S SPREADIN ON ME"].rect_position.y - pad.y)
					
					# 6
					upc[f]["METAL CAP"].rect_position = Vector2(upc[f]["HAMON"].rect_position.x, upc[f]["HAMON"].rect_position.y - pad.y)
					upc[f]["FRENCH VANILLA"].rect_position = Vector2(upc[f]["GREEN TEA"].rect_position.x, upc[f]["GREEN TEA"].rect_position.y - pad.y)
					upc[f]["AUTOSHIT"].rect_position = Vector2(upc[f]["AXELOT"].rect_position.x, upc[f]["AXELOT"].rect_position.y - pad.y)
					upc[f]["Confirmed Poopy"].rect_position = Vector2(upc[f]["AUTOSHIT"].rect_position.x - pad.x, upc[f]["AUTOSHIT"].rect_position.y)
					upc[f]["Overtime"].rect_position = Vector2(upc[f]["Covenant Dance"].rect_position.x, upc[f]["Covenant Dance"].rect_position.y - pad.y)
					upc[f]["AntiSoftLock"].rect_position = Vector2(upc[f]["I know what I'm doing, unlock this shit"].rect_position.x, upc[f]["I know what I'm doing, unlock this shit"].rect_position.y - pad.y)
					upc[f]["Mega Wonks"].rect_position = Vector2(upc[f]["CONDUCT"].rect_position.x, upc[f]["CONDUCT"].rect_position.y - pad.y)
					
					upc[f]["Mad Science"].rect_position = Vector2(upc[f]["AUTO-PERSIST"].rect_position.x, upc[f]["AUTO-PERSIST"].rect_position.y - pad.y)
					
					# 7
					upc[f]["STAR ROD"].rect_position = Vector2(upc[f]["METAL CAP"].rect_position.x, upc[f]["METAL CAP"].rect_position.y - pad.y)
					upc[f]["Smashy Crashy"].rect_position = Vector2(upc[f]["AUTOSHIT"].rect_position.x, upc[f]["AUTOSHIT"].rect_position.y - pad.y)
					upc[f]["Fangorn"].rect_position = Vector2(upc[f]["Smashy Crashy"].rect_position.x - pad.x, upc[f]["Smashy Crashy"].rect_position.y)
					upc[f]["WATER"].rect_position = Vector2(upc[f]["FRENCH VANILLA"].rect_position.x, upc[f]["FRENCH VANILLA"].rect_position.y - pad.y)
					upc[f]["Bone Meal"].rect_position = Vector2(upc[f]["Overtime"].rect_position.x, upc[f]["Overtime"].rect_position.y - pad.y)
					upc[f]["CAPITAL PUNISHMENT"].rect_position = Vector2(upc[f]["Mega Wonks"].rect_position.x - pad.x / 2, upc[f]["Mega Wonks"].rect_position.y - pad.y)
					
					upc[f]["Jasmine"].rect_position = Vector2(upc[f]["Mad Science"].rect_position.x, upc[f]["Mad Science"].rect_position.y - pad.y)
					
					# 8
					upc[f]["Tolkien"].rect_position = Vector2(upc[f]["STAR ROD"].rect_position.x + pad.x / 2, upc[f]["STAR ROD"].rect_position.y - pad.y)
					upc[f]["A baby Roleum!! Thanks, pa!"].rect_position = Vector2(upc[f]["Smashy Crashy"].rect_position.x, upc[f]["Smashy Crashy"].rect_position.y - pad.y)
					upc[f]["AUTOSQUIRTER"].rect_position = Vector2(upc[f]["A baby Roleum!! Thanks, pa!"].rect_position.x - pad.x, upc[f]["A baby Roleum!! Thanks, pa!"].rect_position.y)
					upc[f]["SILLY"].rect_position = Vector2(upc[f]["Bone Meal"].rect_position.x, upc[f]["Bone Meal"].rect_position.y - pad.y)
					
					upc[f]["UNIONIZE"].rect_position = Vector2(upc[f]["Jasmine"].rect_position.x, upc[f]["Jasmine"].rect_position.y - pad.y)
					
					# 9
					upc[f]["poofy wizard boy"].rect_position = Vector2(upc[f]["A baby Roleum!! Thanks, pa!"].rect_position.x, upc[f]["A baby Roleum!! Thanks, pa!"].rect_position.y - pad.y)
					upc[f]["Second Breakfast"].rect_position = Vector2(upc[f]["poofy wizard boy"].rect_position.x - pad.x, upc[f]["poofy wizard boy"].rect_position.y)
					upc[f]["is it SUPPOSED to be stick dudes?"].rect_position = Vector2(upc[f]["Tolkien"].rect_position.x + pad.x / 2, upc[f]["Tolkien"].rect_position.y - pad.y)
					upc[f]["I Disagree"].rect_position = Vector2(upc[f]["is it SUPPOSED to be stick dudes?"].rect_position.x - pad.x, upc[f]["is it SUPPOSED to be stick dudes?"].rect_position.y)
					upc[f]["PLATE"].rect_position = Vector2(upc[f]["SILLY"].rect_position.x, upc[f]["SILLY"].rect_position.y - pad.y)
					
					upc[f]["CARAVAN"].rect_position = Vector2(upc[f]["UNIONIZE"].rect_position.x, upc[f]["UNIONIZE"].rect_position.y - pad.y)
					
					upc[f]["dust"].rect_position = Vector2(upc[f]["CARAVAN"].rect_position.x + pad.x * 1.5, upc[f]["CARAVAN"].rect_position.y - pad.y / 4)
					
				
				# 10 - 19
				if true:
					
					# 10
					upc[f]["BENEFIT"].rect_position = Vector2(upc[f]["poofy wizard boy"].rect_position.x, upc[f]["poofy wizard boy"].rect_position.y - pad.y)
					upc[f]["Motherlode"].rect_position = Vector2(upc[f]["BENEFIT"].rect_position.x - pad.x, upc[f]["BENEFIT"].rect_position.y)
					upc[f]["HOME-RUN BAT"].rect_position = Vector2(upc[f]["I Disagree"].rect_position.x, upc[f]["I Disagree"].rect_position.y - pad.y)
					upc[f]["BLAM this piece of crap!"].rect_position = Vector2(upc[f]["HOME-RUN BAT"].rect_position.x + pad.x, upc[f]["HOME-RUN BAT"].rect_position.y)
					upc[f]["Child Energy"].rect_position = Vector2(upc[f]["PLATE"].rect_position.x, upc[f]["PLATE"].rect_position.y - pad.y)
					
					upc[f]["Combo Breaker"].rect_position = Vector2(upc[f]["CARAVAN"].rect_position.x, upc[f]["CARAVAN"].rect_position.y - pad.y)
					
					# 11
					upc[f]["AUTOAQUATICICIDE"].rect_position = Vector2(upc[f]["BENEFIT"].rect_position.x, upc[f]["BENEFIT"].rect_position.y - pad.y)
					upc[f]["Plasticular Cancer"].rect_position = Vector2(upc[f]["AUTOAQUATICICIDE"].rect_position.x - pad.x, upc[f]["AUTOAQUATICICIDE"].rect_position.y)
					upc[f]["DOT DOT DOT"].rect_position = Vector2(upc[f]["BLAM this piece of crap!"].rect_position.x, upc[f]["BLAM this piece of crap!"].rect_position.y - pad.y)
					upc[f]["ONE PUNCH"].rect_position = Vector2(upc[f]["DOT DOT DOT"].rect_position.x - pad.x, upc[f]["DOT DOT DOT"].rect_position.y)
					upc[f]["Erebor"].rect_position = Vector2(upc[f]["Child Energy"].rect_position.x, upc[f]["Child Energy"].rect_position.y - pad.y)
					
					upc[f]["RELATIVITY"].rect_position = Vector2(upc[f]["Erebor"].rect_position.x - pad.x * 1.5, upc[f]["Erebor"].rect_position.y)
					
					# 12
					upc[f]["Go on, then, LEAD us!"].rect_position = Vector2(upc[f]["AUTOAQUATICICIDE"].rect_position.x, upc[f]["AUTOAQUATICICIDE"].rect_position.y - pad.y)
					upc[f]["probably radioactive"].rect_position = Vector2(upc[f]["Go on, then, LEAD us!"].rect_position.x - pad.x, upc[f]["Go on, then, LEAD us!"].rect_position.y)
					upc[f]["Sick of the Sun"].rect_position = Vector2(upc[f]["ONE PUNCH"].rect_position.x, upc[f]["ONE PUNCH"].rect_position.y - pad.y)
					upc[f]["axman23 by now"].rect_position = Vector2(upc[f]["Sick of the Sun"].rect_position.x + pad.x, upc[f]["Sick of the Sun"].rect_position.y)
					upc[f]["SPEED DOODS"].rect_position = Vector2(upc[f]["Erebor"].rect_position.x, upc[f]["Erebor"].rect_position.y - pad.y)
					
					upc[f]["upgrade_description"].rect_position = Vector2(upc[f]["RELATIVITY"].rect_position.x, upc[f]["RELATIVITY"].rect_position.y - pad.y)
					
					# 13
					upc[f]["BEEKEEPING"].rect_position = Vector2(upc[f]["Go on, then, LEAD us!"].rect_position.x, upc[f]["Go on, then, LEAD us!"].rect_position.y - pad.y)
					upc[f]["beeware the seed lored"].rect_position = Vector2(upc[f]["BEEKEEPING"].rect_position.x - pad.x, upc[f]["BEEKEEPING"].rect_position.y)
					
					upc[f]["Cthaeh"].rect_position = Vector2(upc[f]["axman23 by now"].rect_position.x - pad.x / 2, upc[f]["axman23 by now"].rect_position.y - pad.y)
					
					# 14
					upc[f]["Scoopy Doopy"].rect_position = Vector2(upc[f]["BEEKEEPING"].rect_position.x, upc[f]["BEEKEEPING"].rect_position.y - pad.y)
					
					# 15
					upc[f]["Master Iron Worker"].rect_position = Vector2(upc[f]["Scoopy Doopy"].rect_position.x, upc[f]["Scoopy Doopy"].rect_position.y - pad.y)
					upc[f]["Steel Pattern"].rect_position = Vector2(upc[f]["Master Iron Worker"].rect_position.x - pad.x, upc[f]["Master Iron Worker"].rect_position.y)
					
					# 16
					upc[f]["JOINTSHACK"].rect_position = Vector2(upc[f]["Master Iron Worker"].rect_position.x, upc[f]["Master Iron Worker"].rect_position.y - pad.y)
					upc[f]["flonky wonky"].rect_position = Vector2(upc[f]["JOINTSHACK"].rect_position.x - pad.x, upc[f]["JOINTSHACK"].rect_position.y)
					
					# 17
					upc[f]["AROUSAL"].rect_position = Vector2(upc[f]["JOINTSHACK"].rect_position.x, upc[f]["JOINTSHACK"].rect_position.y - pad.y)
					upc[f]["Hardwood Cycle"].rect_position = Vector2(upc[f]["AROUSAL"].rect_position.x - pad.x, upc[f]["AROUSAL"].rect_position.y)
					
					# 18
					upc[f]["autofloof"].rect_position = Vector2(upc[f]["AROUSAL"].rect_position.x, upc[f]["AROUSAL"].rect_position.y - pad.y)
					
					# 19
					upc[f]["ELECTRONIC CIRCUITS"].rect_position = Vector2(upc[f]["autofloof"].rect_position.x, upc[f]["autofloof"].rect_position.y - pad.y)
					upc[f]["Wire Trail"].rect_position = Vector2(upc[f]["ELECTRONIC CIRCUITS"].rect_position.x - pad.x, upc[f]["ELECTRONIC CIRCUITS"].rect_position.y)
				
				# 20 - 29
				if true:
					
					# 20
					upc[f]["AUTOBADDECISIONMAKER"].rect_position = Vector2(upc[f]["ELECTRONIC CIRCUITS"].rect_position.x, upc[f]["ELECTRONIC CIRCUITS"].rect_position.y - pad.y)
					
					# 21
					upc[f]["PILLAR OF AUTUMN"].rect_position = Vector2(upc[f]["AUTOBADDECISIONMAKER"].rect_position.x, upc[f]["AUTOBADDECISIONMAKER"].rect_position.y - pad.y)
					upc[f]["Glass Pass"].rect_position = Vector2(upc[f]["PILLAR OF AUTUMN"].rect_position.x - pad.x, upc[f]["PILLAR OF AUTUMN"].rect_position.y)
					
					# 22
					upc[f]["what kind of resource is 'tumors', you hack fraud"].rect_position = Vector2(upc[f]["PILLAR OF AUTUMN"].rect_position.x, upc[f]["PILLAR OF AUTUMN"].rect_position.y - pad.y)
					upc[f]["Tummy Ache"].rect_position = Vector2(upc[f]["what kind of resource is 'tumors', you hack fraud"].rect_position.x - pad.x, upc[f]["what kind of resource is 'tumors', you hack fraud"].rect_position.y)
					
					# 23
					upc[f]["DEVOUR"].rect_position = Vector2(upc[f]["what kind of resource is 'tumors', you hack fraud"].rect_position.x, upc[f]["what kind of resource is 'tumors', you hack fraud"].rect_position.y - pad.y)
					upc[f]["INSIDIUS"].rect_position = Vector2(upc[f]["DEVOUR"].rect_position.x - pad.x, upc[f]["DEVOUR"].rect_position.y)
					
					# 24
					upc[f]["PHILOSOPHER"].rect_position = Vector2(upc[f]["INSIDIUS"].rect_position.x, upc[f]["INSIDIUS"].rect_position.y - pad.y)
					
			
			# s2n
			if true:
				
				var f := "s2nup"
				
				# 0-9
				if true:
					
					# 0
					upc[f]["CANOPY"].rect_position = Vector2(400 - size.x / 2, 300)
					upc[f]["RAIN DANCE"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x - pad.x, upc[f]["CANOPY"].rect_position.y)
					upc[f]["BREAK THE DAM"].rect_position = Vector2(upc[f]["RAIN DANCE"].rect_position.x - pad.x, upc[f]["RAIN DANCE"].rect_position.y)
					
					upc[f]["LIGHTHOUSE"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x + pad.x, upc[f]["CANOPY"].rect_position.y)
					upc[f]["EQUINE"].rect_position = Vector2(upc[f]["LIGHTHOUSE"].rect_position.x + pad.x, upc[f]["CANOPY"].rect_position.y)
					
					# 1
					upc[f]["Carlin"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x, upc[f]["CANOPY"].rect_position.y - pad.y)
					
					upc[f]["Apprentice Iron Worker"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x - pad.x, upc[f]["CANOPY"].rect_position.y - pad.y)
					upc[f]["Double Barrels"].rect_position = Vector2(upc[f]["Apprentice Iron Worker"].rect_position.x - pad.x, upc[f]["Apprentice Iron Worker"].rect_position.y)
					upc[f]["Triple Barrels"].rect_position = Vector2(upc[f]["Double Barrels"].rect_position.x - pad.x, upc[f]["Double Barrels"].rect_position.y)
					upc[f]["This Might Pay Off Someday"].rect_position = Vector2(upc[f]["Triple Barrels"].rect_position.x - pad.x, upc[f]["Triple Barrels"].rect_position.y + pad.y / 2)
					
					upc[f]["Woodthirsty"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x + pad.x, upc[f]["Apprentice Iron Worker"].rect_position.y)
					upc[f]["Seeing Brown"].rect_position = Vector2(upc[f]["Woodthirsty"].rect_position.x + pad.x, upc[f]["Woodthirsty"].rect_position.y)
					upc[f]["Decisive Strikes"].rect_position = Vector2(upc[f]["Seeing Brown"].rect_position.x + pad.x, upc[f]["Woodthirsty"].rect_position.y)
					upc[f]["Woodiac Chopper"].rect_position = Vector2(upc[f]["Decisive Strikes"].rect_position.x + pad.x, upc[f]["Woodthirsty"].rect_position.y - pad.y / 2)
					upc[f]["Flippy Floppies"].rect_position = Vector2(upc[f]["Woodiac Chopper"].rect_position.x, upc[f]["Woodiac Chopper"].rect_position.y - pad.y)
					
					# 2
					upc[f]["Steel Yourself"].rect_position = Vector2(upc[f]["Apprentice Iron Worker"].rect_position.x - pad.x * 0.5, upc[f]["Apprentice Iron Worker"].rect_position.y - pad.y)
					upc[f]["Hardwood Yourself"].rect_position = Vector2(upc[f]["Steel Yourself"].rect_position.x + pad.x, upc[f]["Steel Yourself"].rect_position.y)
					upc[f]["Patreon Artist"].rect_position = Vector2(upc[f]["Hardwood Yourself"].rect_position.x + pad.x, upc[f]["Steel Yourself"].rect_position.y)
					upc[f]["PLASMA BOMBARDMENT"].rect_position = Vector2(upc[f]["Patreon Artist"].rect_position.x + pad.x, upc[f]["Steel Yourself"].rect_position.y)
	
					# 3
					upc[f]["Sagan"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x, upc[f]["Steel Yourself"].rect_position.y - pad.y)
	
					upc[f]["Millery"].rect_position = Vector2(upc[f]["Hardwood Yourself"].rect_position.x - pad.x / 2, upc[f]["Steel Yourself"].rect_position.y - pad.y)
					upc[f]["Quamps"].rect_position = Vector2(upc[f]["Millery"].rect_position.x - pad.x, upc[f]["Millery"].rect_position.y)
					upc[f]["Rogue Blacksmith"].rect_position = Vector2(upc[f]["Quamps"].rect_position.x - pad.x, upc[f]["Quamps"].rect_position.y)
					upc[f]["GIMP"].rect_position = Vector2(upc[f]["Millery"].rect_position.x + pad.x * 2, upc[f]["Millery"].rect_position.y)
					upc[f]["2552"].rect_position = Vector2(upc[f]["GIMP"].rect_position.x + pad.x, upc[f]["GIMP"].rect_position.y)
					upc[f]["Unpredictable Weather"].rect_position = Vector2(upc[f]["2552"].rect_position.x + pad.x, upc[f]["2552"].rect_position.y)
					upc[f]["Dirt Collection Rewards Program"].rect_position = Vector2(upc[f]["Rogue Blacksmith"].rect_position.x - pad.x, upc[f]["Rogue Blacksmith"].rect_position.y - pad.y / 2)
					
					# 4
					upc[f]["Lembas Water"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x + pad.x / 2, upc[f]["Millery"].rect_position.y - pad.y)
					upc[f]["Hole Geometry"].rect_position = Vector2(upc[f]["Lembas Water"].rect_position.x + pad.x, upc[f]["Lembas Water"].rect_position.y)
					upc[f]["Kilty Sbark"].rect_position = Vector2(upc[f]["Hole Geometry"].rect_position.x + pad.x, upc[f]["Hole Geometry"].rect_position.y)
					upc[f]["Journeyman Iron Worker"].rect_position = Vector2(upc[f]["Lembas Water"].rect_position.x - pad.x, upc[f]["Lembas Water"].rect_position.y)
					upc[f]["Quormps"].rect_position = Vector2(upc[f]["Journeyman Iron Worker"].rect_position.x - pad.x - pad.x, upc[f]["Lembas Water"].rect_position.y)
					upc[f]["Cutting Corners"].rect_position = Vector2(upc[f]["Quormps"].rect_position.x + pad.x, upc[f]["Quormps"].rect_position.y)
					upc[f]["Soft and Smooth"].rect_position = Vector2(upc[f]["Flippy Floppies"].rect_position.x, upc[f]["Flippy Floppies"].rect_position.y - pad.y)
					
					# 5
					upc[f]["Henry Cavill"].rect_position = Vector2(upc[f]["Lembas Water"].rect_position.x - pad.x, upc[f]["Lembas Water"].rect_position.y - pad.y)
					upc[f]["Bigger Trees I Guess"].rect_position = Vector2(upc[f]["Henry Cavill"].rect_position.x + pad.x, upc[f]["Henry Cavill"].rect_position.y)
					upc[f]["Wood Lord"].rect_position = Vector2(upc[f]["Henry Cavill"].rect_position.x - pad.x * 1.5, upc[f]["Henry Cavill"].rect_position.y)
					upc[f]["Expert Iron Worker"].rect_position = Vector2(upc[f]["Wood Lord"].rect_position.x - pad.x, upc[f]["Wood Lord"].rect_position.y)
					upc[f]["Where's the boy, String?"].rect_position = Vector2(upc[f]["Bigger Trees I Guess"].rect_position.x + pad.x * 1.5, upc[f]["Bigger Trees I Guess"].rect_position.y)
					upc[f]["They've Always Been Faster"].rect_position = Vector2(upc[f]["Where's the boy, String?"].rect_position.x + pad.x, upc[f]["Where's the boy, String?"].rect_position.y)
					
					# 6
					upc[f]["Cioran"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x, upc[f]["Henry Cavill"].rect_position.y - pad.y)
					upc[f]["Sandal Flandals"].rect_position = Vector2(upc[f]["Cioran"].rect_position.x + pad.x * 1.5, upc[f]["Cioran"].rect_position.y)
					upc[f]["Nikey Wikeys"].rect_position = Vector2(upc[f]["Cioran"].rect_position.x - pad.x * 1.5, upc[f]["Cioran"].rect_position.y)
					
					# 7
					upc[f]["Sp0oKy"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x, upc[f]["Cioran"].rect_position.y - pad.y)
					upc[f]["Factory Squirts"].rect_position = Vector2(upc[f]["Sp0oKy"].rect_position.x + pad.x, upc[f]["Sp0oKy"].rect_position.y)
					upc[f]["VIRILE"].rect_position = Vector2(upc[f]["Sp0oKy"].rect_position.x - pad.x, upc[f]["Sp0oKy"].rect_position.y)
					upc[f]["Glitterdelve"].rect_position = Vector2(upc[f]["VIRILE"].rect_position.x - pad.x, upc[f]["Sp0oKy"].rect_position.y)
					upc[f]["Longbottom Leaf"].rect_position = Vector2(upc[f]["Factory Squirts"].rect_position.x + pad.x, upc[f]["Sp0oKy"].rect_position.y)
					upc[f]["Utter Molester Champ"].rect_position = Vector2(upc[f]["Longbottom Leaf"].rect_position.x + pad.x * 1.5, upc[f]["Sp0oKy"].rect_position.y)
					upc[f]["Squeeormp"].rect_position = Vector2(upc[f]["Glitterdelve"].rect_position.x - pad.x * 1.5, upc[f]["Sp0oKy"].rect_position.y)
					
					# 8
					upc[f]["CANCER'S REAL COOL"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x - pad.x * 1.5, upc[f]["Sp0oKy"].rect_position.y - pad.y)
					upc[f]["INDEPENDENCE"].rect_position = Vector2(upc[f]["Factory Squirts"].rect_position.x + pad.x / 2, upc[f]["CANCER'S REAL COOL"].rect_position.y)
					upc[f]["Le Guin"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x, upc[f]["CANCER'S REAL COOL"].rect_position.y)
					
					# 9
					upc[f]["Steely Dan"].rect_position = Vector2(upc[f]["Expert Iron Worker"].rect_position.x, upc[f]["Le Guin"].rect_position.y - pad.y)
					upc[f]["ERECTWOOD"].rect_position = Vector2(upc[f]["Steely Dan"].rect_position.x + pad.x, upc[f]["Steely Dan"].rect_position.y)
					upc[f]["And this is to go even further beyond!"].rect_position = Vector2(upc[f]["ERECTWOOD"].rect_position.x + pad.x, upc[f]["Steely Dan"].rect_position.y)
					upc[f]["Power Barrels"].rect_position = Vector2(upc[f]["And this is to go even further beyond!"].rect_position.x + pad.x, upc[f]["Steely Dan"].rect_position.y)
					upc[f]["Light as a Feather"].rect_position = Vector2(upc[f]["Power Barrels"].rect_position.x + pad.x, upc[f]["Steely Dan"].rect_position.y)
					upc[f]["PULLEY"].rect_position = Vector2(upc[f]["Light as a Feather"].rect_position.x + pad.x, upc[f]["Steely Dan"].rect_position.y)
					upc[f]["MGALEKGOLO"].rect_position = Vector2(upc[f]["PULLEY"].rect_position.x + pad.x, upc[f]["Steely Dan"].rect_position.y)
					upc[f]["Busy Bee"].rect_position = Vector2(upc[f]["Steely Dan"].rect_position.x - pad.x, upc[f]["Steely Dan"].rect_position.y)
					upc[f]["Fleeormp"].rect_position = Vector2(upc[f]["MGALEKGOLO"].rect_position.x + pad.x, upc[f]["Steely Dan"].rect_position.y)
				
				# 10 - 19
				if true:
					
					# 10
					upc[f]["Steel Yo Mama"].rect_position = Vector2(upc[f]["Steely Dan"].rect_position.x + pad.x / 2, upc[f]["Steely Dan"].rect_position.y - pad.y)
					upc[f]["Hardwood Yo Mama"].rect_position = Vector2(upc[f]["Steel Yo Mama"].rect_position.x + pad.x, upc[f]["Steel Yo Mama"].rect_position.y)
					upc[f]["POTENT"].rect_position = Vector2(upc[f]["Hardwood Yo Mama"].rect_position.x + pad.x, upc[f]["Steel Yo Mama"].rect_position.y)
					upc[f]["DINDER MUFFLIN"].rect_position = Vector2(upc[f]["POTENT"].rect_position.x + pad.x, upc[f]["Steel Yo Mama"].rect_position.y)
					upc[f]["SPOOLY"].rect_position = Vector2(upc[f]["DINDER MUFFLIN"].rect_position.x + pad.x, upc[f]["Steel Yo Mama"].rect_position.y)
					upc[f]["MAGNETIC ACCELERATOR"].rect_position = Vector2(upc[f]["SPOOLY"].rect_position.x + pad.x, upc[f]["Steel Yo Mama"].rect_position.y)
					upc[f]["a bee with tiny daggers!!!"].rect_position = Vector2(upc[f]["Steel Yo Mama"].rect_position.x - pad.x, upc[f]["Steel Yo Mama"].rect_position.y)
					upc[f]["Ultra Shitstinct"].rect_position = Vector2(upc[f]["MAGNETIC ACCELERATOR"].rect_position.x + pad.x, upc[f]["Steel Yo Mama"].rect_position.y)
					
					
					# 11
					upc[f]["Toriyama"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x, upc[f]["Steel Yo Mama"].rect_position.y - pad.y)
					upc[f]["Fingers of Onden"].rect_position = Vector2(upc[f]["Steel Yo Mama"].rect_position.x + pad.x / 2, upc[f]["Toriyama"].rect_position.y)
					upc[f]["Barely Wood by Now"].rect_position = Vector2(upc[f]["Fingers of Onden"].rect_position.x + pad.x, upc[f]["Toriyama"].rect_position.y)
					upc[f]["low rises"].rect_position = Vector2(upc[f]["Toriyama"].rect_position.x + pad.x, upc[f]["Toriyama"].rect_position.y)
					upc[f]["O'SALVATORI"].rect_position = Vector2(upc[f]["low rises"].rect_position.x + pad.x, upc[f]["Toriyama"].rect_position.y)
					upc[f]["BURDENED"].rect_position = Vector2(upc[f]["Fingers of Onden"].rect_position.x - pad.x * 2, upc[f]["Toriyama"].rect_position.y)
					upc[f]["Squeeomp"].rect_position = Vector2(upc[f]["O'SALVATORI"].rect_position.x + pad.x * 2, upc[f]["Toriyama"].rect_position.y)
					
					# 13
					upc[f]["Steel Lord"].rect_position = Vector2(upc[f]["Fingers of Onden"].rect_position.x + pad.x / 2, upc[f]["Fingers of Onden"].rect_position.y - pad.y)
					upc[f]["i'll show you hardwood"].rect_position = Vector2(upc[f]["Steel Lord"].rect_position.x + pad.x, upc[f]["Steel Lord"].rect_position.y)
					upc[f]["MICROSOFT PAINT"].rect_position = Vector2(upc[f]["i'll show you hardwood"].rect_position.x + pad.x, upc[f]["Steel Lord"].rect_position.y)
					upc[f]["FINISH THE FIGHT"].rect_position = Vector2(upc[f]["MICROSOFT PAINT"].rect_position.x + pad.x, upc[f]["Steel Lord"].rect_position.y)
					
					# 14
					upc[f]["John Peter Bain, TotalBiscuit"].rect_position = Vector2(upc[f]["CANOPY"].rect_position.x, upc[f]["Steel Lord"].rect_position.y - pad.y * 1.5)
					
			
			# s1mup
			if true:
				
				var f := "s1mup"
				
				# 0
				upc[f]["SOCCER DUDE"].rect_position = Vector2(400 - size.x / 2, 300)
				
				# 1
				upc[f]["AUTOSHOVELER"].rect_position = Vector2(upc["s1mup"]["SOCCER DUDE"].rect_position.x - pad.x, upc["s1mup"]["SOCCER DUDE"].rect_position.y - pad.y)
				upc["s1mup"]["IT'S GROWIN ON ME"].rect_position = Vector2(upc["s1mup"]["AUTOSHOVELER"].rect_position.x + pad.x + pad.x, upc["s1mup"]["AUTOSHOVELER"].rect_position.y)
				upc["s1mup"]["ENTHUSIASM"].rect_position = Vector2(upc["s1mup"]["AUTOSHOVELER"].rect_position.x - pad.x, upc["s1mup"]["AUTOSHOVELER"].rect_position.y)
				upc["s1mup"]["aw <3"].rect_position = Vector2(upc["s1mup"]["ENTHUSIASM"].rect_position.x - pad.x, upc["s1mup"]["ENTHUSIASM"].rect_position.y)
				upc["s1mup"]["CON-FRICKIN-CRETE"].rect_position = Vector2(upc["s1mup"]["IT'S GROWIN ON ME"].rect_position.x + pad.x, upc["s1mup"]["AUTOSHOVELER"].rect_position.y)
				upc[f]["LB0"].rect_position = Vector2(upc[f]["CON-FRICKIN-CRETE"].rect_position.x + pad.x * 1.5, upc[f]["CON-FRICKIN-CRETE"].rect_position.y)
				
				# 2
				upc["s1mup"]["OREOREUHBor E ALICE"].rect_position = Vector2(upc["s1mup"]["AUTOSHOVELER"].rect_position.x, upc["s1mup"]["AUTOSHOVELER"].rect_position.y - pad.y)
				upc["s1mup"]["how is this an RPG anyway?"].rect_position = Vector2(upc["s1mup"]["SOCCER DUDE"].rect_position.x, upc["s1mup"]["ENTHUSIASM"].rect_position.y - pad.y)
				upc["s1mup"]["you little hard worker, you"].rect_position = Vector2(upc["s1mup"]["IT'S GROWIN ON ME"].rect_position.x, upc["s1mup"]["CON-FRICKIN-CRETE"].rect_position.y - pad.y)
				upc[f]["LB1"].rect_position = Vector2(upc[f]["LB0"].rect_position.x, upc[f]["LB0"].rect_position.y - pad.y)
				
				# 3
				upc["s1mup"]["AUTOSTONER"].rect_position = Vector2(upc["s1mup"]["OREOREUHBor E ALICE"].rect_position.x, upc["s1mup"]["OREOREUHBor E ALICE"].rect_position.y - pad.y)
				upc["s1mup"]["STAY QUENCHED"].rect_position = Vector2(upc["s1mup"]["you little hard worker, you"].rect_position.x + pad.x, upc["s1mup"]["you little hard worker, you"].rect_position.y - pad.y)
				upc["s1mup"]["CHUNKUS"].rect_position = Vector2(upc["s1mup"]["how is this an RPG anyway?"].rect_position.x, upc["s1mup"]["how is this an RPG anyway?"].rect_position.y - pad.y)
				upc["s1mup"]["OH, BABY, A TRIPLE"].rect_position = Vector2(upc["s1mup"]["CHUNKUS"].rect_position.x + pad.x, upc["s1mup"]["CHUNKUS"].rect_position.y)
				upc[f]["LB2"].rect_position = Vector2(upc[f]["LB0"].rect_position.x, upc[f]["LB1"].rect_position.y - pad.y)
				
				# 3.5
				upc["s1mup"]["COMPULSORY JUICE"].rect_position = Vector2(upc["s1mup"]["AUTOSTONER"].rect_position.x - pad.x, upc["s1mup"]["AUTOSTONER"].rect_position.y - pad.y / 2)
				
				# 4
				upc["s1mup"]["BIG TOUGH BOY"].rect_position = Vector2(upc["s1mup"]["CHUNKUS"].rect_position.x, upc["s1mup"]["CHUNKUS"].rect_position.y - pad.y)
				upc["s1mup"]["AUTOPOLICE"].rect_position = Vector2(upc["s1mup"]["AUTOSTONER"].rect_position.x, upc["s1mup"]["AUTOSTONER"].rect_position.y - pad.y)
				upc["s1mup"]["I DRINK YOUR MILKSHAKE"].rect_position = Vector2(upc["s1mup"]["STAY QUENCHED"].rect_position.x, upc["s1mup"]["STAY QUENCHED"].rect_position.y - pad.y)
				upc[f]["LB3"].rect_position = Vector2(upc[f]["LB0"].rect_position.x, upc[f]["LB2"].rect_position.y - pad.y)
				
				# 5
				upc["s1mup"]["ORE LORD"].rect_position = Vector2(upc["s1mup"]["BIG TOUGH BOY"].rect_position.x, upc["s1mup"]["BIG TOUGH BOY"].rect_position.y - pad.y)
				upc["s1mup"]["pippenpaddle- oppsoCOPolis"].rect_position = Vector2(upc["s1mup"]["AUTOPOLICE"].rect_position.x, upc["s1mup"]["AUTOPOLICE"].rect_position.y - pad.y)
				upc["s1mup"]["THE THIRD"].rect_position = Vector2(upc["s1mup"]["pippenpaddle- oppsoCOPolis"].rect_position.x - pad.x, upc["s1mup"]["pippenpaddle- oppsoCOPolis"].rect_position.y)
				upc[f]["LB4"].rect_position = Vector2(upc[f]["LB0"].rect_position.x, upc[f]["LB3"].rect_position.y - pad.y)
				
				# 6
				upc["s1mup"]["upgrade_name"].rect_position = Vector2(upc["s1mup"]["ORE LORD"].rect_position.x, upc["s1mup"]["ORE LORD"].rect_position.y - pad.y)
				upc["s1mup"]["MOIST"].rect_position = Vector2(upc["s1mup"]["pippenpaddle- oppsoCOPolis"].rect_position.x, upc["s1mup"]["pippenpaddle- oppsoCOPolis"].rect_position.y - pad.y)
				upc["s1mup"]["CANCER'S COOL"].rect_position = Vector2(upc["s1mup"]["MOIST"].rect_position.x - pad.x, upc["s1mup"]["MOIST"].rect_position.y)
				upc[f]["LB5"].rect_position = Vector2(upc[f]["LB0"].rect_position.x, upc[f]["LB4"].rect_position.y - pad.y)
				
				# 7
				upc["s1mup"]["DUNKUS"].rect_position = Vector2(upc["s1mup"]["upgrade_name"].rect_position.x, upc["s1mup"]["upgrade_name"].rect_position.y - pad.y)
				upc["s1mup"]["wtf is that musk"].rect_position = Vector2(upc["s1mup"]["MOIST"].rect_position.x, upc["s1mup"]["MOIST"].rect_position.y - pad.y)
				upc[f]["LB6"].rect_position = Vector2(upc[f]["LB0"].rect_position.x, upc[f]["LB5"].rect_position.y - pad.y)
				
				# 8
				upc["s1mup"]["I RUN"].rect_position = Vector2(upc["s1mup"]["DUNKUS"].rect_position.x + pad.x, upc["s1mup"]["DUNKUS"].rect_position.y - pad.y)
				upc["s1mup"]["coal DUDE"].rect_position = Vector2(upc["s1mup"]["I RUN"].rect_position.x + pad.x, upc["s1mup"]["I RUN"].rect_position.y)
				upc["s1mup"]["CANKERITE"].rect_position = Vector2(upc["s1mup"]["wtf is that musk"].rect_position.x, upc["s1mup"]["wtf is that musk"].rect_position.y - pad.y)
				upc[f]["Share the Hit"].rect_position = Vector2(upc[f]["LB0"].rect_position.x - pad.x / 2, upc[f]["LB6"].rect_position.y - pad.y)
				
				# 9
				upc["s1mup"]["FOOD TRUCKS"].rect_position = Vector2(upc["s1mup"]["DUNKUS"].rect_position.x, upc["s1mup"]["DUNKUS"].rect_position.y - pad.y - pad.y)
				upc["s1mup"]["SENTIENT DERRICK"].rect_position = Vector2(upc["s1mup"]["CANKERITE"].rect_position.x, upc["s1mup"]["CANKERITE"].rect_position.y - pad.y)
				upc[f]["LB7"].rect_position = Vector2(upc[f]["LB0"].rect_position.x, upc[f]["Share the Hit"].rect_position.y - pad.y)
				
				# 10
				upc["s1mup"]["OPPAI GUY"].rect_position = Vector2(upc["s1mup"]["FOOD TRUCKS"].rect_position.x, upc["s1mup"]["FOOD TRUCKS"].rect_position.y - pad.y)
				upc["s1mup"]["SLAPAPOW!"].rect_position = Vector2(upc["s1mup"]["SENTIENT DERRICK"].rect_position.x, upc["s1mup"]["SENTIENT DERRICK"].rect_position.y - pad.y)
				upc[f]["LB8"].rect_position = Vector2(upc[f]["LB0"].rect_position.x, upc[f]["LB7"].rect_position.y - pad.y)
				
				# 11
				upc["s1mup"]["SLUGGER"].rect_position = Vector2(upc["s1mup"]["OPPAI GUY"].rect_position.x, upc["s1mup"]["OPPAI GUY"].rect_position.y - pad.y)
				upc["s1mup"]["SIDIUS IRON"].rect_position = Vector2(upc["s1mup"]["SLAPAPOW!"].rect_position.x, upc["s1mup"]["SLAPAPOW!"].rect_position.y - pad.y)
				upc["s1mup"]["THIS GAME IS SO ESEY"].rect_position = Vector2(upc["s1mup"]["SLUGGER"].rect_position.x + pad.x, upc["s1mup"]["SLUGGER"].rect_position.y)
				upc[f]["LB9"].rect_position = Vector2(upc[f]["LB0"].rect_position.x, upc[f]["LB8"].rect_position.y - pad.y)
				
				# 12
				upc["s1mup"]["wait that's not fair"].rect_position = Vector2(upc["s1mup"]["SLUGGER"].rect_position.x, upc["s1mup"]["SLUGGER"].rect_position.y - pad.y)
				upc[f]["MOUND"].rect_position = Vector2(upc["s1mup"]["SIDIUS IRON"].rect_position.x, upc["s1mup"]["SIDIUS IRON"].rect_position.y - pad.y)
				
				# 13
				upc[f]["MALEVOLENT"].rect_position = Vector2(upc["s1mup"]["wait that's not fair"].rect_position.x, upc["s1mup"]["wait that's not fair"].rect_position.y - pad.y)
				upc[f]["PROCEDURE"].rect_position = Vector2(upc[f]["MALEVOLENT"].rect_position.x + pad.x, upc[f]["MALEVOLENT"].rect_position.y - pad.y / 2)
				
				# 14
				upc[f]["ROUTINE"].rect_position = Vector2(upc[f]["MALEVOLENT"].rect_position.x, upc[f]["MALEVOLENT"].rect_position.y - pad.y)
				
			
			# s1nup
			if true:
				
				#for x in nupc:
				#	upc["s1nup"][x].rect_position = Vector2(60, -400)
				#	break
				var f = "s1nup"
				
				# 0
				upc["s1nup"]["GRINDER"].rect_position = Vector2(400 - size.x / 2, 300)
				upc["s1nup"]["GRANDER"].rect_position = Vector2(upc["s1nup"]["GRINDER"].rect_position.x - pad.x, upc["s1nup"]["GRINDER"].rect_position.y)
				upc["s1nup"]["GRANDMA"].rect_position = Vector2(upc["s1nup"]["GRANDER"].rect_position.x - pad.x, upc["s1nup"]["GRANDER"].rect_position.y)
				upc["s1nup"]["GRANDPA"].rect_position = Vector2(upc["s1nup"]["GRANDMA"].rect_position.x - pad.x, upc["s1nup"]["GRANDMA"].rect_position.y)
				
				# 0.5
				upc["s1nup"]["GROUNDER"].rect_position = Vector2(upc["s1nup"]["GRANDPA"].rect_position.x - pad.x, upc["s1nup"]["GRANDPA"].rect_position.y - pad.y / 2)
				
				# 1
				upc["s1nup"]["LIGHTER SHOVEL"].rect_position = Vector2(upc["s1nup"]["GRINDER"].rect_position.x + pad.x / 2, upc["s1nup"]["GRINDER"].rect_position.y - pad.y)
				upc["s1nup"]["SAALNDT"].rect_position = Vector2(upc["s1nup"]["LIGHTER SHOVEL"].rect_position.x + pad.x, upc["s1nup"]["LIGHTER SHOVEL"].rect_position.y)
				upc["s1nup"]["ANCHOVE COVE"].rect_position = Vector2(upc["s1nup"]["SAALNDT"].rect_position.x + pad.x, upc["s1nup"]["SAALNDT"].rect_position.y)
				upc["s1nup"]["RYE"].rect_position = Vector2(upc["s1nup"]["LIGHTER SHOVEL"].rect_position.x - pad.x, upc["s1nup"]["LIGHTER SHOVEL"].rect_position.y)
				upc["s1nup"]["TEXAS"].rect_position = Vector2(upc["s1nup"]["RYE"].rect_position.x - pad.x, upc["s1nup"]["RYE"].rect_position.y)
				
				# 0.5
				upc["s1nup"]["GARLIC"].rect_position = Vector2(upc["s1nup"]["ANCHOVE COVE"].rect_position.x + pad.x, upc["s1nup"]["ANCHOVE COVE"].rect_position.y + pad.y / 2)
				# 1.5
				upc["s1nup"]["PEPPER"].rect_position = Vector2(upc["s1nup"]["GARLIC"].rect_position.x, upc["s1nup"]["GARLIC"].rect_position.y - pad.y)
				
				# 2
				upc["s1nup"]["MIXER"].rect_position = Vector2(upc["s1nup"]["RYE"].rect_position.x + pad.x / 2, upc["s1nup"]["LIGHTER SHOVEL"].rect_position.y - pad.y)
				upc["s1nup"]["SWIRLER"].rect_position = Vector2(upc["s1nup"]["MIXER"].rect_position.x + pad.x, upc["s1nup"]["MIXER"].rect_position.y)
				upc["s1nup"]["MAXER"].rect_position = Vector2(upc["s1nup"]["SWIRLER"].rect_position.x + pad.x, upc["s1nup"]["SWIRLER"].rect_position.y)
				
				# 3
				upc["s1nup"]["SALT"].rect_position = Vector2(upc["s1nup"]["MIXER"].rect_position.x - pad.x / 2, upc["s1nup"]["MIXER"].rect_position.y - pad.y)
				upc["s1nup"]["RIB"].rect_position = Vector2(upc["s1nup"]["SALT"].rect_position.x - pad.x, upc["s1nup"]["SALT"].rect_position.y)
				upc["s1nup"]["MUD"].rect_position = Vector2(upc["s1nup"]["RIB"].rect_position.x - pad.x, upc["s1nup"]["RIB"].rect_position.y)
				upc["s1nup"]["SAND"].rect_position = Vector2(upc["s1nup"]["SALT"].rect_position.x + pad.x, upc["s1nup"]["SALT"].rect_position.y)
				upc["s1nup"]["FLANK"].rect_position = Vector2(upc["s1nup"]["SAND"].rect_position.x + pad.x, upc["s1nup"]["SAND"].rect_position.y)
				upc["s1nup"]["THYME"].rect_position = Vector2(upc["s1nup"]["FLANK"].rect_position.x + pad.x, upc["s1nup"]["FLANK"].rect_position.y)
				
				# 4
				upc["s1nup"]["WATT?"].rect_position = Vector2(upc["s1nup"]["GRINDER"].rect_position.x, upc["s1nup"]["SAND"].rect_position.y - pad.y)
				upc["s1nup"]["SLIMER"].rect_position = Vector2(upc["s1nup"]["WATT?"].rect_position.x - pad.x, upc["s1nup"]["WATT?"].rect_position.y)
				upc["s1nup"]["SLOP"].rect_position = Vector2(upc["s1nup"]["SLIMER"].rect_position.x - pad.x, upc["s1nup"]["SLIMER"].rect_position.y)
				upc["s1nup"]["CHEEKS"].rect_position = Vector2(upc["s1nup"]["GRINDER"].rect_position.x + pad.x, upc["s1nup"]["WATT?"].rect_position.y)
				upc["s1nup"]["GEARED OILS"].rect_position = Vector2(upc["s1nup"]["CHEEKS"].rect_position.x + pad.x, upc["s1nup"]["CHEEKS"].rect_position.y)
				
				# 5
				upc["s1nup"]["STICKYTAR"].rect_position = Vector2(upc["s1nup"]["WATT?"].rect_position.x, upc["s1nup"]["WATT?"].rect_position.y - pad.y)
				upc["s1nup"]["RED GOOPY BOY"].rect_position = Vector2(upc["s1nup"]["STICKYTAR"].rect_position.x + pad.x / 2, upc["s1nup"]["STICKYTAR"].rect_position.y - pad.y)
				upc[f]["INJECT"].rect_position = Vector2(upc[f]["RED GOOPY BOY"].rect_position.x - pad.x, upc[f]["RED GOOPY BOY"].rect_position.y)
			
			for x in gv.up:
				if "reset" in gv.up[x].type: continue
				if upc[gv.up[x].path][x].rect_position.x + upc[gv.up[x].path][x].rect_size.x < 400: continue
				upc[gv.up[x].path][x].get_node("afford_alert").flip_h = true
				upc[gv.up[x].path][x].get_node("afford_alert").position = Vector2(-16, 30)
		
		#$misc/upgrades.init()
	
	# game start:
	if true:
		
		if hax == 2:
			return
		
		game_start(e_load())

func game_start(successful_load: bool) -> void:
	
	#gv.menu.option["task auto"] = false
	
	if not successful_load:
		gv.g["stone"].r = Big.new(5)
	else:
		for x in gv.g:
			if gv.g[x].unlocked:
				continue
			if gv.g[x].active:
				gv.g[x].unlocked = true
	
	print("highest run: ", gv.stats.highest_run)
	print("most_resources_gained: ", gv.stats.most_resources_gained.toString())
	
	# work
	if true:
		
		# upgrades
		if true:
			
			gv.up["ROUTINE"].have = false
			
			for x in gv.stats.up_list["cremover"]:
				if gv.up[x].have:
					gv.g[gv.up[x].benefactor_of[0].split(" ")[0]].cost.erase(gv.up[x].benefactor_of[0].split(" ")[1])
			
			w_task_progress_check()
		
		
		# loreds
		if true:
			
			for x in gv.g:
				
				gv.emit_signal("lored_updated", x, "worker alpha")
				
				for v in gv.up:
					
					# catches
					if gv.up[v].benefactor_of.size() == 0: continue
					if "autoup" in gv.up[v].type: continue
					if "cremover" in gv.up[v].type: continue
					
					var list_type = gv.up[v].type.split("up ")[1] + " list"
					if " buff" in list_type: list_type = list_type.split("buff")[0] + "list"
					
					if gv.g[x].type.split(" ")[0] == gv.up[v].benefactor_of[0]:
						gv.g[x].benefactors[list_type].append(v)
						continue
					
					# burn / cost
					if " " in gv.up[v].benefactor_of[0]:
						for b in gv.up[v].benefactor_of:
							if not x == b.split(" ")[0]: continue
							gv.g[x].benefactors[list_type].append(v)
						continue
					
					if not x in gv.up[v].benefactor_of: continue
					gv.g[x].benefactors[list_type].append(v)
		
		w_aa()
	
	# ref
	if true:
		
		$misc/qol_displays/resource_bar.init()
		
		# lored
		if true:
			
			$map/loreds.r_update_hold(true)
			$map/loreds.r_update_autobuy()
			
			for x in gv.g:
				if not gv.g[x].active:
					continue
				$map/loreds.lored[x].get_node("hold").disabled = false
				$map/loreds.lored[x].get_node("halt").disabled = false
		
		# menu and tab shit
		if true:
			
			menu_window = prefab["menu"].instance()
			$misc.add_child(menu_window)
			menu_window.init(gv.menu.option)
			
			# tab
			b_tabkey(KEY_1)
		
		# b_upgrade_tab
		if true:
			
			$misc/tabs.init()
			$up_container.init()
		
		w_task_effects()
		
		remove_surplus_tasks()
		
		# map
		$map.init()
	
	# hax
	if true:
		
		if not hax == 1:
			
			# upgrades
			if true:
				
				for x in gv.up:
					#break
					gv.up[x].requires = ""
				gv.up["Limit Break"].have = true
				#up["AUTOSHOVELER"].have = true
				#get_node("map/loreds").r_update_autobuy(["coal"])
			
			# resources
			if true:
				
				#gv.g["malig"].r.a(Big.new(gv.up["ROUTINE"].cost["malig"].t).m(1.99))
				
				if not gv.up["THE WITCH OF LOREDELITH"].have:
					gv.g["iron"].r.a(100000)
					gv.g["cop"].r.a(100000)
					gv.g["stone"].r.a(500000)
					#gv.g["malig"].r.a(5"1e6"00)
					gv.g["conc"].r.a(500000)
					gv.g["water"].r.a(25)
					#gv.g["malig"].r.a(10)
					if hax > 1:
						gv.g["tum"].r.a("5e6")
			
			$misc/tabs.unlock()
			if hax > 1:
				$map/upgrades.r_update("all")
				for x in tasks:
					for v in tasks[x].step:
						tasks[x].step[v].b = Big.new()
			
			for x in gv.g:
				if hax > 1:
					$map/loreds.lored[x].show()
					if not gv.up["THE WITCH OF LOREDELITH"].have:
						#g[x].speed.b *= 0.1
						for v in gv.g[x].cost:
							gv.g[v].r.a(gv.g[x].cost[v].t)
					gv.g[x].r.a(100)
				if "s1" in gv.g[x].type:
					if not gv.up["THE WITCH OF LOREDELITH"].have:
						gv.g[x].r.a(500000)
					$map/loreds.lored[x].show()
				#g[x].active = true
				#if not up["THE WITCH OF LOREDELITH"].have: if hax > 1: g[x].output_modifier.b *= 100.0
			
			if hax > 1:
				for x in gv.g:
					$map/loreds.lored[x].b_buy_lored()
		
		if hax < 1:
			#up["SOCCER DUDE"].have = true
			#if up["SOCCER DUDE"].d == 1.0: up["SOCCER DUDE"].d *= w_set_d("SOCCER DUDE")
			pass
		
		w_aa()
	
	# tasks
	if true:
		
		if not $map/loreds.lored["water"].visible and tasks["A New Leaf"].complete:
			$map/loreds.lored["water"].show()
			$map/loreds.lored["seed"].show()
			$map/loreds.lored["tree"].show()
		
		if tasks["Spread"].complete and not tasks["Consume"].complete:
			if gv.g["malig"].r.isLessThan(10) and not gv.g["tar"].active:
				gv.g["malig"].r = Big.new(10)
		
		for x in tasks:
			if tasks[x].complete:
				continue
			if taq.cur_quest == "":
				taq.new_quest(tasks[x])
				break
		
		if taq.cur_quest == "":
			$misc/taq/quest.hide()
		
		if 5==4:#tasks["Menu!"].complete and not "tasks" in content_tasks.keys():
			
			var _tasks := []
			for x in taq.task:
				_tasks.append(taq.task[x])
			content_tasks["tasks"] = prefab.tasks.instance()
			$misc/taq.add_child(content_tasks["tasks"])
			$misc/taq.move_child(get_node("misc/taq/quest"),1)
			content_tasks["tasks"].init(_tasks)
	
	if hax == 1:
		pass

func _ready_define_loreds(reset_type : int):
	
	for x in gv.g:
		
		if not reset_type == 0:
			if reset_type < int(gv.g[x].type[1]): continue
		
		
		if " " + x + " " in DEFAULT_KEY_LOREDS:
			gv.g[x].key_lored = true
		
		gv.g[x].level = 1
		gv.g[x].task = "no"
		gv.g[x].active = true if x == "stone" else false
		if reset_type == 0 or gv.stats.run[0] == 1:
			gv.g[x].unlocked = true if x in ["stone", "coal"] else false
		
		gv.g[x].output_modifier = Big.new(1)
		gv.g[x].cost_modifier = Big.new(1)
		gv.g[x].modifier_from_growin_on_me = Big.new(1)
		
		gv.g[x].fc.b = Big.new(0.0015)
		if "s2" in gv.g[x].type:
			gv.g[x].fc.b.m(10)
		if "fur " in gv.g[x].type:
			gv.g[x].fc.b.m(1.25)
		
		gv.g[x].f.b = Big.new(gv.g[x].fc.b).m(2000)
		gv.g[x].f.b.m(gv.g[x].speed.b).m(0.0125)
		
		gv.g[x].sync()
		
		gv.g[x].f.f = Big.new(gv.g[x].f.t)
		if gv.stats.run[0] == 1 and x == "stone":
			gv.g[x].f.f = Big.new(gv.g[x].fc.b).m(gv.g[x].speed.b).m(1.02)

func _ready_define_upgrades():
	
	for x in gv.stats.up_list:
		for v in gv.stats.up_list[x]:
			
			match x:
				"autob":
					gv.up[v].desc.base = "Unlocks the Autobuyer for your " + gv.g[gv.up[v].main_lored_target].name + " LORED."


func _physics_process(delta):
	
	#gv.g["malig"].r = Big.new("5e8")
	#gv.g["coal"].r = Big.new("1e3")
#	gv.up["SOCCER DUDE"].have = false
#	gv.up["IT'S GROWIN ON ME"].have = false
	#gv.up["GRINDER"].have = false
	
	# work
	if true:
		
#		if input_timer > 0.0:
#			input_timer = max(input_timer - delta, 0.0)
		save_fps += delta
		time_fps += delta
		afford_check_fps += delta
		
		if save_fps > 10:
			save_fps -= 10
			if hax <= 1: e_save()
		
		if time_fps > 1:
			time_fps -= 1
			cur_clock = OS.get_unix_time()
			cur_session += 1
		
		if afford_check_fps > 1:
			afford_check_fps -= 1
			w_afford_alert()

#var input_timer := 0.0
func _input(ev):
	
#	if input_timer > 0.0: return
#	input_timer = 0.03
	
	if ev.is_class("InputEventMouseMotion"):
		return
	
	if ev.is_action_pressed("ui_cancel"):
		b_tabkey(KEY_ESCAPE)
		return
	
	if Input.is_key_pressed(KEY_LEFT):
		match int(tabby["last stage"]):
			2:
				b_tabkey(KEY_1)
		return
	
	if Input.is_key_pressed(KEY_RIGHT):
		match int(tabby["last stage"]):
			1:
				b_tabkey(KEY_2)
		return
	
	if Input.is_key_pressed(KEY_1):
		b_tabkey(KEY_1)
		return#1864712072202289200
	
	if Input.is_key_pressed(KEY_2):
		b_tabkey(KEY_2)
		return
	
	
#	if Input.is_key_pressed(KEY_Q):
#		if $up_container.visible:
#			$up_container.hide()
#		else:
#			$up_container.show()
#		return
	
	
	if Input.is_key_pressed(KEY_Q):
		$misc/tabs.up["s1nup"]._pressed()
		return
	
	if Input.is_key_pressed(KEY_W):
		$misc/tabs.up["s1mup"]._pressed()
		return
	
	if Input.is_key_pressed(KEY_E):
		$misc/tabs.up["s2nup"]._pressed()
		return
	
	if Input.is_key_pressed(KEY_R):
		$misc/tabs.up["s2mup"]._pressed()
		return
	
	if Input.is_key_pressed(KEY_KP_ENTER) or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_ENTER):
		if content_tasks["tasks"].ready_task_count > 0:
			var _content = []
			for x in taq.task:
				_content.append(taq.task[x].code)
			if $global_tip.tip_filled:
				if "taq" in $global_tip.tip.type:
					$global_tip._call("no")
			for x in _content:
				if x in content_tasks["tasks"].content.keys():
					if content_tasks["tasks"].content[x].get_node("tp").value >= 100:
						content_tasks["tasks"].content[x]._on_task_pressed()
			return
		if taq.cur_quest != "":
			if taq.content.get_node("done").visible:
				taq.content.b_end_task()
				return
		return
	
	if Input.is_key_pressed(KEY_EQUAL):
		b_tabkey(KEY_ESCAPE)
		return
func _notification(ev):
	if ev == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		
		get_node("map/tip")._call("no")
		get_node("global_tip")._call("no")
		
		if OS.get_unix_time() - cur_clock <= 1: return
		var clock_dif = OS.get_unix_time() - last_clock
		if clock_dif <= 1: return
		
		w_total_per_sec(clock_dif)
	elif ev == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		last_clock = OS.get_unix_time()
func _on_menu_button_button_down():
	$map.status = "no"
func _on_menu_button_pressed():
	b_tabkey(KEY_ESCAPE)


# working funcs
func w_aa():
	gv.overcharge = mod_overcharge()
	for x in gv.g:
		gv.g[x].sync()

func mod_overcharge() -> float:
	var d := 1.0
	for x in gv.stats.up_list["lbmult"]:
		if gv.up[x].active():
			d *= 2
	return d


func w_total_per_sec(clock_dif : float) -> void:
	
	if "no" in gv.menu.f:
		return
	
	var gained := {}
	var consumed := {}
	var num_of_consumers := {}
	var gain_reduction := {}
	var consumed_reduction := {}
	
	for x in gv.g:
		gain_reduction[x] = Big.new()
		consumed_reduction[x] = Big.new()
		consumed[x] = Big.new(0)
		gained[x] = Big.new(0)
		num_of_consumers[x] = 0
	
	# set gained and consumed for each lored
	for x in gv.g:
		
		if not gv.g[x].active:
			continue
		
		var fuel_gained := true
		if "bur " in gv.g[x].type and not gv.g["coal"].active():
			fuel_gained = false
		if "ele " in gv.g[x].type and not gv.g["jo"].active():
			fuel_gained = false
		
		# coal storage / battery gain
		if fuel_gained:
			
			var max_fuel = Big.new(gv.g[x].f.t)
			if gv.g[x].type[1] in gv.overcharge_list:
				max_fuel.m(gv.overcharge)
			
			var fuel_gain = Big.new(gv.g[x].fc.t)
			fuel_gain.m(clock_dif).m(60)
			fuel_gain.m(gv.g[x].less_from_full(gv.g[x].f.f, max_fuel))
			
			gv.g[x].f.f = Big.new(Big.min(Big.new(gv.g[x].f.f).a(fuel_gain), max_fuel))
			gv.g[x].sync()
		
		if gv.g[x].halt:
			continue
		
		var inactive_input := false
		for v in gv.g[x].b:
			if not gv.g[v].active() or gv.g[v].hold:
				inactive_input = true
				break
		if inactive_input: continue
		
		# fuel consumption
		if true:
			
			if "ye" in gv.menu.f:
				if "bur " in gv.g[x].type:
					consumed["coal"].a(Big.new(gv.g[x].fc.t).m(clock_dif).m(60))
				if "ele " in gv.g[x].type:
					consumed["jo"].a(Big.new(gv.g[x].fc.t).m(clock_dif).m(60))
			
			if "s1" in gv.g[x].type and "s1" in gv.menu.f: continue
			elif "s2" in gv.g[x].type and "s2" in gv.menu.f: continue
		
		var net = gv.g[x].net(true)
		
		# gained
		var _gained = Big.new(net[0]).m(clock_dif)
		gained[x] = Big.new(_gained)
		gv.stats.r_gained[x].a(_gained)
		var per_sec = Big.new(gv.g[x].d.t).d(gv.g[x].speed.t).m(60).m(clock_dif)
		
		# consumed
		for v in gv.g[x].b:
			# by this point, every lored here will be active. see 2 sections up
			consumed[v] = Big.new(per_sec).m(gv.g[x].b[v].t)
			num_of_consumers[v] += 1
	
	# unique gained reductions
	if true:
		
		# routine
		while true:
			
			if gained["malig"].isLessThan(gv.up["ROUTINE"].cost["malig"].t):
				break
			var excess = Big.new(gained["malig"]).s(gv.up["ROUTINE"].cost["malig"].t)
			excess.m(0.1)
			
			gained["malig"] = Big.new(gv.up["ROUTINE"].cost["malig"].t).a(excess)
			
			break
	
	# reduce gained if either fuel or input is insufficient. if gained is reduced, reduce consumed of input.
	if true:
		
		var coal_efficiency : Big = Big.new(gained["coal"])
		if consumed["coal"].isEqualTo(0):
			coal_efficiency = Big.new()
		else:
			coal_efficiency.d(consumed["coal"])
		if coal_efficiency.isLargerThan(1) or Big.new(gv.g["coal"].r).s(consumed["coal"]).isLargerThan(gv.g["coal"].d.t):
			coal_efficiency = Big.new()
		
		var jo_efficiency : Big = Big.new(gained["jo"])
		if consumed["jo"].isEqualTo(0):
			jo_efficiency = Big.new()
		else:
			jo_efficiency.d(consumed["jo"])
		if jo_efficiency.isLargerThan(1) or Big.new(gv.g["jo"].r).s(consumed["jo"]).isLargerThan(gv.g["jo"].d.t):
			jo_efficiency = Big.new()
		
		print("WELCOME BACK!\n\nTime away: ", gv.big_to_time(Big.new(clock_dif)))
		print("coal/joule efficiency: ", coal_efficiency.toString(), "/", jo_efficiency.toString(), "\n")
		
		for x in gv.g:
			
			if not gv.g[x].active: continue
			
			if "bur " in gv.g[x].type: gain_reduction[x].m(coal_efficiency)
			if "ele " in gv.g[x].type: gain_reduction[x].m(jo_efficiency)
			
			if consumed[x].isLessThan(gained[x]): continue
			if Big.new(gv.g[x].r).s(consumed[x]).isLargerThan(0): continue
			
			if "bur " in gv.g[x].type: consumed_reduction[x].m(coal_efficiency)
			if "ele " in gv.g[x].type: consumed_reduction[x].m(jo_efficiency)
			
			if num_of_consumers[x] == 0: num_of_consumers[x] = 1
			
			if consumed[x].isEqualTo(0): consumed[x] = Big.new()
			
			
			var uh = Big.new(gained[x]).d(consumed[x]).d(num_of_consumers[x])
			
			for v in gv.g[x].used_by:
				
				if not gv.g[v].active: continue
				gain_reduction[v].m(uh)
			
			consumed_reduction[x].m(uh)
		
		for x in gain_reduction:
			
			if gain_reduction[x].isEqualTo(1): continue
			
			#prrint(":( alert! - ", x, " gains x", gain_reduction[x].toString(), " :: ", gained[x].toString(), " -> ", Big.new(gained[x]).m(gain_reduction[x]).toString())
			gained[x].m(gain_reduction[x])
		
		# quest
		if taq.cur_quest != "":
			for x in gv.g:
				for z in taq.quest.step:
					if not "produced" in z:
						continue
					if gv.g[x].name in z or z == "Combined resources produced" or (z == "Combined Stage 2 resources produced" and "s2" in gv.g[x].type):
						var a = Big.new(taq.quest.step[z].f).a(gained[x])
						taq.quest.step[z].f = Big.new(Big.min(a, taq.quest.step[z].b))
		
		for x in consumed_reduction:
			
			if consumed_reduction[x].isEqualTo(1): continue
			
			#print(x, " consumed x", fval.f(consumed_reduction[x]), " :: ", fval.f(consumed[x]), " -> ", fval.f(consumed[x] * consumed_reduction[x]))
			consumed[x].m(consumed_reduction[x])
			gained[x] = Big.new(0)
	
	# task stuff
	for x in taq.task:
		for v in taq.task[x].step:
			
			if not "produced" in v:
				continue
			
			if "resources produced" in v:
				for b in gained:
					if "Combined resources produced" == v and "s1" in gv.g[b].type:
						var yikes = Big.new(Big.min(Big.new(taq.task[x].step[v].f).a(gained[b]), taq.task[x].step[v].b))
						taq.task[x].step[v].f = Big.new(yikes)
					elif "Combined Stage 2 resources produced" == v and "s2" in gv.g[b].type:
						var yikes = Big.new(Big.min(Big.new(taq.task[x].step[v].f).a(gained[b]), taq.task[x].step[v].b))
						taq.task[x].step[v].f = Big.new(yikes)
				continue
			
			var f = w_name_to_short(v.split(" produced")[0])
			var ya = Big.new(Big.min(Big.new(taq.task[x].step[v].f).a(gained[f]), taq.task[x].step[v].b))
			taq.task[x].step[v].f = Big.new(ya)
	
	# subtract consumed from gained
	for x in gv.g:
		
		if not gv.g[x].active:
			continue
		
		print(x, " ", Big.new(gained[x]).s(consumed[x]).toString(), " (", gained[x].toString(), " gained, ", consumed[x].toString(), " drained)")
		
		if consumed[x].isLargerThan(gained[x]):
			consumed[x].s(gained[x])
			if consumed[x].isLargerThan(gv.g[x].r):
				gv.g[x].r = Big.new(0)
			else:
				gv.g[x].r.s(consumed[x])
				gv.emit_signal("lored_updated", x, "amount")
		else:
			gained[x].s(consumed[x])
			gv.g[x].r.a(gained[x])
		
		if x != "coal": continue
		if gv.g[x].r.isLessThan(gv.g[x].d.t):
			gv.g[x].r = Big.new(gv.g[x].d.t)
	
	for x in gv.g:
		if gv.g[x].r.isLessThan(0):#isNegative():
			gv.g[x].r = Big.new(0)
	
	# upgrade-only stuff
	if true:
		
		if gv.up["I DRINK YOUR MILKSHAKE"].active():
			var num_of_burner_loreds := 0
			for x in gv.g:
				if not gv.g[x].active: continue
				if not "bur " in gv.g[x].type: continue
				num_of_burner_loreds += 1
			var gay = Big.new(num_of_burner_loreds).m(60).m(clock_dif).m(0.0001)
			gv.up["I DRINK YOUR MILKSHAKE"].set_d.b.a(gay)




func w_afford_alert() -> void:
	
	for x in gv.up:
		
		# catches
		if true:
			
			if gv.up[x].type[1] == "1":
				if gv.up["we were so close, now you don't even think about me"].active():
					continue
			if not "nup" in gv.up[x].type: continue
			if gv.up[x].have:
				upc[gv.up[x].path][x].get_node("afford_alert").hide()
				continue
			if not gv.up[x].requires == "": if not gv.up[gv.up[x].requires].have: continue
			var cont := false
			for v in gv.stats.up_list["autoup"]:
				if not gv.up[v].have: continue
				if not gv.up[v].active: continue
				var matches := false
				if gv.up[v].benefactor_of[0] == "seed" and gv.up[x].main_lored_target == "abeewithdaggers":
					matches = true
				else:
					if not gv.up[v].benefactor_of[0] == gv.up[x].main_lored_target: continue
					matches = true
				if not matches: continue
				cont = true
				break
			if cont: continue
			if not r_buy_color(1, x, gv.up[x].type) == Color(1,1,1):
				upc[gv.up[x].path][x].get_node("afford_alert").hide()
				upc[gv.up[x].path][x].afford_alert_displayed = false
				continue
			if upc[gv.up[x].path][x].afford_alert_displayed: continue
		
		# pass :D
		
		upc[gv.up[x].path][x].get_node("afford_alert").show()
		upc[gv.up[x].path][x].afford_alert_displayed = true
		$misc/tabs.up[gv.up[x].path].get_node("alert").b_flash(true)
func w_name_to_short(f: String) -> String:
	for x in gv.g:
		if gv.g[x].name == f:
			return x
	return "god fucking what the fucking shit fuck damnit fucking cocks in my ass fucking cocks in my cocks"
func w_index_to_short(f : int) -> String:
	var i := 0
	for x in gv.g:
		if f == i: return x
		i += 1
	return "fucking oops"
func w_distribute_upgrade_buff(benefactor : String) -> void:
	
	# catches
	if not "benefactor" in gv.up[benefactor].type: return
	if not gv.up[benefactor].have: return
	
	gv.up[benefactor].sync()
	
	var buff_type : String = gv.up[benefactor].type.split("benefactor ")[1] + " buff"
	
	for x in gv.stats.up_list[buff_type]:
		gv.up[benefactor].sync()
func w_task_effects(which := []) -> void:
	
	if which == []:
		for x in tasks:
			which.append(x)
	
	for x in which:
		
		if not tasks[x].complete:
			continue
		if tasks[x].effect_loaded:
			continue
		tasks[x].effect_loaded = true
		
		for v in tasks[x].reward:
			if not "New LORED: " in v:
				continue
			var key = w_name_to_short(v.split("New LORED: ")[1])
			gv.g[key].unlocked = true
			if gv.g[key].type[1] == tabby["last stage"]:
				$map/loreds.lored[key].show()
		
		if "Max tasks +1" in tasks[x].reward.keys():
			taq.max_tasks += 1
		
		match x:
			"Spike":
				if "tasks" in content_tasks.keys():
					content_tasks["tasks"].get_node("HBoxContainer/auto").show()
					content_tasks["tasks"].get_node("HBoxContainer/auto/AnimatedSprite").show()
					content_tasks["tasks"].get_node("HBoxContainer/auto/Label").hide()
					for v in content_tasks["tasks"].content:
						if content_tasks["tasks"].content[v].get_node("tp").value >= 100:
							content_tasks["tasks"].content[v]._on_task_pressed()
			"Menu!":
				if not "tasks" in content_tasks.keys():
					var _tasks := []
					for v in taq.task:
						_tasks.append(taq.task[v])
					content_tasks["tasks"] = prefab.tasks.instance()
					$misc/taq.add_child(content_tasks["tasks"])
					$misc/taq.move_child(get_node("misc/taq/quest"),1)
					content_tasks["tasks"].init(_tasks)
			"A New Leaf":
				get_node("misc/tabs").unlock(["1", "2"])
				get_node("misc/menu").w_display_run(tasks[x].complete)
			"Welcome to LORED":
				get_node("misc/tabs").unlock(["s1nup"])
			"Consume":
				get_node("misc/tabs").unlock(["s1mup"])
			"The Heart of Things":
				gv.g["tum"].unlocked = true
				if gv.up["I know what I'm doing, unlock this shit"].active():
					get_node("misc/tabs").unlock(["s2nup"])
				else:
					if $map/loreds.lored["seed"].b_ubu_s2n_check("2"):
						get_node("misc/tabs").unlock(["s2nup"])
			"Cancer Lord":
				get_node("misc/tabs").unlock(["s2mup"])



func w_task_progress_check() -> void:
	
	if taq.cur_quest == "":
		return
	
	match taq.quest.name:
		"Intro!":
			if gv.g["coal"].active:
				taq.quest.step["Coal LORED bought"].f.mantissa = 1.0
		"Sandy Progress":
			if gv.up["SAND"].have:
				taq.quest.step["SAND purchased"].f.mantissa = 1.0
		"Upgrades!":
			if gv.up["GRINDER"].have:
				taq.quest.step["GRINDER purchased"].f.mantissa = 1.0
		"Progress":
			if gv.up["RYE"].have:
				taq.quest.step["RYE purchased"].f.mantissa = 1.0
		"Cringey Progress":
			if gv.up["Sagan"].have:
				taq.quest.step["Sagan purchased"].f.mantissa = 1.0
		"Menu!":
			if gv.menu.option["resource_bar"]:
				for x in taq.quest.step:
					taq.quest.step[x].f.mantissa = 1.0


func price_increase(type: String) -> float:
	
	var mod = 3.0
	
	if gv.up["upgrade_name"].active():
		if type[1] == "1" and "bur " in type:
			mod = 2.75
	if gv.up["upgrade_description"].active():
		mod *= 0.9
	
	return mod


func remove_surplus_tasks():
	
	if taq.cur_tasks <= taq.max_tasks:
		return
	
	print(taq.cur_tasks, " tasks; the maximum is ", taq.max_tasks, ". Deleting some.")
	
	for x in content_tasks["tasks"].content.keys():
		
		if taq.cur_tasks == taq.max_tasks:
			break
		content_tasks["tasks"].content[x].kill_yourself()



# reflective funcs
func r_lored_color(key : String) -> Color:
	if "ciga" in key:
		return Color(0.929412, 0.584314, 0.298039)
	if "toba" in key:
		return Color(0.639216, 0.454902, 0.235294)
	if "plast" in key:
		return Color(0.85, 0.85, 0.85)
	if "pulp" in key:
		return Color(0.94902, 0.823529, 0.54902)
	if "paper" in key:
		return Color(0.792157, 0.792157, 0.792157)
	if "lead" in key:
		return Color(0.53833, 0.714293, 0.984375)
	if "gale" in key:
		return Color(0.701961, 0.792157, 0.929412)
	if "coal" in key:
		return Color(0.7, 0, 1)
	if "stone" in key:
		return Color(0.79, 0.79, 0.79)
	if "irono" in key:
		return Color(0, 0.517647, 0.905882)
	if "copo" in key:
		return Color(0.7, 0.33, 0)
	if "iron" in key:
		return Color(0.07, 0.89, 1)
	if "cop" in key:
		return Color(1, 0.74, 0.05)
	if "growth" in key:
		return Color(0.79, 1, 0.05)
	if "jo" in key:
		return Color(1, 0.98, 0)
	if "conc" in key:
		return Color(0.35, 0.35, 0.35)
	if "malig" in key:
		return Color(0.88, .12, .35)
	if "tar" in key:
		return Color(.56, .44, 1)
	if "soil" in key:
		return Color(0.737255, 0.447059, 0)
	if "oil" in key:# and not "soil" in key:
		return Color(.65, .3, .66)
	if "tum" in key:
		return Color(1, .54, .54)
	if "glass" in key:
		return Color(0.81, 0.93, 1.0)
	if "wire" in key:
		return Color(0.9, 0.6, 0.14)
	if "seed" in key:
		return Color(1, 0.878431, 0.431373)
	if "wood" in key:
		return Color(0.545098, 0.372549, 0.015686)
	if "water" in key:
		return Color(0.14902, 0.52549, 0.792157)
	if "tree" in key:
		return Color(0.772549, 1, 0.247059)
	if "pet" in key:
		return Color(0.76, 0.53, 0.14)
	if "axe" in key:
		return Color(0.691406, 0.646158, 0.586075)
	if "hard" in key:
		return Color(0.92549, 0.690196, 0.184314)
	if "carc" in key:
		return Color(0.772549, 0.223529, 0.192157)
	if "steel" in key:
		return Color(0.607843, 0.802328, 0.878431)
	if "draw" in key:
		return Color(0.333333, 0.639216, 0.811765)
	if "liq" in key:
		return Color(0.27, 0.888, .97)
	if "humus" in key:
		return Color(0.458824, 0.25098, 0)
	return Color(0.764706, 0.733333, 0.603922) # default // old : Color(0.5, 0.5, 0.5)
func r_lored_alert(word : String) -> void:

	word = word.to_lower()
	get_node("misc/loredalert/t").add_color_override("font_color", r_lored_color(word))
	get_node("misc/loredalert/sprite").set_texture(gv.sprite[word])
	get_node("misc/loredalert").visible = true
	loredalert = word
	match word:
		"growth":
			$misc/loredalert.rect_position.x = $map/loreds.get_child(6).rect_position.x
		"malig":
			$misc/loredalert.rect_position.x = $map/loreds.get_child(9).rect_position.x
		"tum":
			$misc/loredalert.rect_position.x = $map/loreds.get_child(12).rect_position.x
func r_buy_color(which: int, key: String, type = "whatever") -> Color:
	
	# which 0 = lored
	# which 1 = upgrade
	
	var BAD := Color(1.3, 0, 0)
	var GOOD := Color(1, 1, 1)
	
	# upgrade types
	if not "whatever" in type:
		
		if "reset" in type:
			return GOOD
		
		var tier : int = int(type.split("s")[1].split(" ")[0])
		var menu_tier : int
		if not "ye" in gv.menu.f:
			menu_tier = int(gv.menu.f.split("no s")[1])
		
		if "no" in gv.menu.f:
			if "nup" in type:
				if menu_tier >= tier: return BAD
			if "mup" in type:
				if not menu_tier == tier: return BAD
		
		if "ye" in gv.menu.f and "mup" in type:
			return BAD
	
	# price check
	match which:
		0:
			if not gv.g[key].cost_check():
				return BAD
		1:
			if not gv.up[key].cost_check():
				return BAD
	
	# good to go!
	return GOOD
func r_window_size_changed() -> void:
	
	var win :Vector2= get_viewport_rect().size
	var node = 0
	
	# loreds
	if true:
		node = $map/loreds
		node.position = Vector2(int(win.x / 2 - 400), int(win.y / 2 - 300))
	
	# upgrades
	if true:
		node = $map/upgrades
		node.position = Vector2(int(win.x / 2 - 400), int(win.y / 2 - 300))
		
		# up_back up_count
		if "up back" in content.keys():#is_instance_valid(content["up back"]):
			node = content["up back"].get_node("up_count")
			node.rect_position.x = int(win.x - node.rect_size.x - 10)
	
	# menu
	if true:
		node = menu_window.get_node("ScrollContainer")
		menu_window.position = Vector2(int(win.x / 2 - node.rect_size.x / 2), int(win.y / 2 - node.rect_size.y / 2))
		$map.pos["menu"] = menu_window.position
	
	# resource bar
	if true:
		node = get_node("misc/qol_displays")
		node.rect_position.x = max(58, int(win.x / 2 - node.rect_size.x / 2))
	
	# tabs
	if true:
		node = get_node("misc/tabs")
		node.position.y = int(win.y - 600)
	
	# taq
	if true:
		node = get_node("misc/taq")
		node.rect_position = Vector2(int(win.x - node.rect_size.x - 10), int(win.y - node.rect_size.y - 10))





func reset(reset_type: int, manual := true) -> void:
	
	reset_stats(reset_type)
	#reset_upgrades(reset_type)

func reset_stats(reset_type: int):
	
	if reset_type == 0:
		
		for x in gv.stats.run.size():
			gv.stats.run[x] = 1
			gv.stats.last_run_dur[x] = 0
			gv.stats.last_reset_clock[x] = OS.get_unix_time()
		
		gv.stats.most_resources_gained = Big.new(0)
		gv.stats.highest_run = 1
		
		return
	
	
	if reset_type > gv.stats.highest_run:
		gv.stats.highest_run = reset_type
		gv.stats.most_resources_gained = Big.new(0)
	
	if reset_type == gv.stats.highest_run:
		
		var gg = "malig"
		match reset_type:
			2:
				gg = "tum"
		
		if gv.stats.most_resources_gained.isLessThan(gv.g[gg].r):
			gv.stats.most_resources_gained = Big.new(gv.g[gg].r)
			print("new highest resources gained: ", gv.stats.most_resources_gained.toString(), " (", gg, ")")
	
	for x in reset_type:
		
		gv.stats.run[x] += 1
		gv.stats.last_run_dur[x] = OS.get_unix_time() - gv.stats.last_reset_clock[x]
		gv.stats.last_reset_clock[x] = OS.get_unix_time()

func reset_upgrades(reset_type: int):
	
	gv.up["I DRINK YOUR MILKSHAKE"].set_d.b = Big.new()
	
	# full reset
	if reset_type == 0:
		
		for x in $map/upgrades.own_list_good:
			$map/upgrades.own_list_good[x] = false
		
		for x in gv.up:
			
			gv.up[x].icon_set = false
			
			if not gv.up[x].have:
				continue
			
			gv.up[x].have = false
			gv.up[x].active = true
			gv.up[x].refundable = false
			gv.up[x].sync()
			
			if x == "I DRINK YOUR MILKSHAKE":
				gv.up["I DRINK YOUR MILKSHAKE"].set_d.b = Big.new()
			
			# ref
			upc[gv.up[x].path][x].r_set_shadow("not owned")
			upc[gv.up[x].path][x].get_node("border").hide()
			
			upc[gv.up[x].path][x].modulated_one_last_time = false
			upc[gv.up[x].path][x].r_update()
		
		gv.overcharge_list.clear()
		
		return
	
	for x in gv.up:
		
		# refundable upgrades are now owned
		if gv.up[x].refundable and str(reset_type) in gv.up[x].type:
			upc[gv.up[x].path][x].get_node("border").show()
			if "mup" in gv.up[x].type:
				upc[gv.up[x].path][x].r_set_shadow("active")
				gv.menu.upgrades_owned[gv.up[x].path] += 1
			gv.up[x].refundable = false
			gv.up[x].have = true
			upc[gv.up[x].path][x].upgrade_effects(x, true, true)

			# task stuff
			if taq.cur_quest != "":
				for t in taq.quest.step:
					if x in t:
						taq.quest.step[t].f = Big.new()

			gv.up[x].sync()

			upc[gv.up[x].path][x].modulated_one_last_time = false
			upc[gv.up[x].path][x].r_update()

			continue
	






#
#func b_reset(reset_type : int, manual_reset := true) -> void:
#
#	# upgrades
#	while true:
#
#
#		w_aa()
#
#		for x in gv.up:
#
#			gv.up[x].icon_set = false
#
#			# refundable upgrades are now owned
#			if gv.up[x].refundable and str(reset_type) in gv.up[x].type:
#				upc[gv.up[x].path][x].get_node("border").show()
#				if "mup" in gv.up[x].type:
#					upc[gv.up[x].path][x].r_set_shadow("active")
#					gv.menu.upgrades_owned[gv.up[x].path] += 1
#				gv.up[x].refundable = false
#				gv.up[x].have = true
#				upc[gv.up[x].path][x].upgrade_effects(x, true, true)
#
#				# task stuff
#				if taq.cur_quest != "":
#					for t in taq.quest.step:
#						if x in t:
#							taq.quest.step[t].f = Big.new()
#
#				gv.up[x].sync()
#
#				upc[gv.up[x].path][x].modulated_one_last_time = false
#				upc[gv.up[x].path][x].r_update()
#
#				continue
#
#			if not gv.up[x].have:
#				continue
#			# if only resetting 1, stage 2 and up will continue
#			if reset_type < int(gv.up[x].type[1]): continue
#			# if s2 reset, will not reset s2m. if s3, will reset s2m, wont reset s3m
#			if int(gv.up[x].type[1]) == reset_type and "mup" in gv.up[x].type: continue
#
#			# radiative -> malig
#			if reset_type == 2:
#
#				if x in ["MOUND", "SIDIUS IRON"] and ((gv.up["AUTO-PERSIST"].refundable or gv.up["AUTO-PERSIST"].have) and gv.up["AUTO-PERSIST"].active): continue
#				if (x == "SLAPAPOW!" or x == "SENTIENT DERRICK") and ((gv.up["Mad Science"].refundable or gv.up["Mad Science"].have) and gv.up["Mad Science"].active): continue
#				if (x == "CANKERITE" or x == "wtf is that musk") and ((gv.up["Jasmine"].refundable or gv.up["Jasmine"].have) and gv.up["Jasmine"].active): continue
#				if (x == "MOIST" or x == "pippenpaddle- oppsoCOPolis") and ((gv.up["UNIONIZE"].refundable or gv.up["UNIONIZE"].have) and gv.up["UNIONIZE"].active): continue
#				if (x == "AUTOPOLICE" or x == "AUTOSTONER") and ((gv.up["CARAVAN"].refundable or gv.up["CARAVAN"].have) and gv.up["CARAVAN"].active): continue
#				if (x == "OREOREUHBor E ALICE" or x == "AUTOSHOVELER") and ((gv.up["Combo Breaker"].refundable or gv.up["Combo Breaker"].have) and gv.up["Combo Breaker"].active): continue
#
#			if "s1 nup" in gv.up[x].type:
#
#				var s1sec_half := "INJECT CHEEKS RED GOOPY BOY SWIRLER GEARED OILS STICKYTAR GOOF LOPS C GOOF LOPS I SHMOOF SHMOPS NOOF BLOPS STICKY ICKY T STICKY ICKY M WATT? MAXER MIXER SLIMER SLOP"
#				var s1first_half := "MUD THYME PEPPER GARLIC TEXAS RYE ANCHOVE COVE GROUNDER GRANDMA GRANDPA GRANDER GRINDER ORE ASSIST I ORE ASSIST C SAND SALT SAALNDT LIGHTER SHOVEL FLANK RIB"
#				var reset := false
#
#				if x in s1first_half:
#					if not (gv.up["CHUNKUS"].have or gv.up["CHUNKUS"].refundable): reset = true
#				if x in s1sec_half:
#					if not (gv.up["DUNKUS"].refundable or gv.up["DUNKUS"].have): reset = true
#
#				if not reset: continue
#
#			# reset every other upgrade:
#
#			gv.up[x].have = false
#			gv.up[x].active = true
#			upc[gv.up[x].path][x].modulated_one_last_time = false
#			upc[gv.up[x].path][x].r_update()
#
#			w_distribute_upgrade_buff(x)
#			if x == "Share the Hit":
#				if "2" in gv.overcharge_list:
#					gv.overcharge_list.erase("2")
#
#			# ref
#			gv.up[x].icon_set = false
#			upc[gv.up[x].path][x].get_node("border").hide()
#			upc[gv.up[x].path][x].r_set_shadow("not owned")
#			gv.menu.upgrades_owned[gv.up[x].path] -= 1
#
#		for x in $map/upgrades.own_list_good:
#			if x >= reset_type: continue
#			$map/upgrades.own_list_good[x] = false
#
#		for x in gv.up:
#			gv.up[x].sync()
#
#		break
#
#	# resources
#	if true:
#
#		# reset r
#		for x in gv.g:
#
#			if not reset_type == 0 and int(gv.g[x].type[1]) > reset_type:
#				continue
#
#			var top_loreds := ["malig", "tum"]
#			if x in top_loreds and int(gv.g[x].type[1]) == reset_type:
#				continue
#
#			if reset_type >= 1 and not gv.up["CONDUCT"].active() and gv.g[x].type[1] == "1":
#				gv.g[x].r = Big.new(0)
#			else:
#				gv.g[x].r = Big.new(0)
#
#		# s2
#		if reset_type >= 2:
#
#			gv.g["wood"].r.a(80)
#			gv.g["soil"].r.a(25)
#			gv.g["tree"].r.a(2)
#			gv.g["steel"].r.a(65)
#			gv.g["hard"].r.a(130)
#			gv.g["wire"].r.a(70)
#			gv.g["glass"].r.a(60)
#
#			if gv.up["Rock-hard Entrance"].active():
#				gv.g["steel"].r.a(10)
#			if gv.up["Road Head Start"].active():
#				gv.g["steel"].r.a(10)
#				gv.g["hard"].r.a(20)
#			if gv.up["DIII Boost From Clan Mate"].active():
#				gv.g["steel"].r.a(20)
#				gv.g["hard"].r.a(20)
#				gv.g["wire"].r.a(40)
#			if gv.up["Life Ins, RIP Grandma"].active():
#				gv.g["steel"].r.a(60)
#				gv.g["hard"].r.a(60)
#				gv.g["wire"].r.a(60)
#				gv.g["glass"].r.a(100)
#			if gv.up["OH YEEAAAAHH"].active():
#				gv.g["steel"].r.a(1000)
#				gv.g["hard"].r.a(1000)
#				gv.g["wire"].r.a(1000)
#				gv.g["glass"].r.a(1000)
#			if gv.up["AntiSoftLock"].active():
#				for x in gv.g:
#					if "1" == gv.g[x].type[1]:
#						continue
#					gv.g[x].r.a(10000)
#
#		# s1
#		gv.g["stone"].r.a(5.0)
#		if not reset_type == 0:
#			gv.g["iron"].r.a(10.0)
#			gv.g["cop"].r.a(10.0)
#			gv.g["malig"].r = Big.new(Big.max(gv.g["malig"].r, 10))
#		if gv.up["FOOD TRUCKS"].active():
#			gv.g["cop"].r.a(100.0)
#			gv.g["iron"].r.a(100.0)
#
#	# loreds
#	if true:
#
#		if (reset_type == 1 and not gv.up["dust"].active()) or reset_type != 1:
#
#			_ready_define_loreds(reset_type)
#
#			for x in gv.g:
#
#				if reset_type > 0 and int(gv.g[x].type[1]) > reset_type:
#					continue
#
#				$map/loreds.lored[x].reset_lb()
#
#				if reset_type == 0:
#					if not (x == "coal" or x == "stone"):
#						$map/loreds.lored[x].hide()
#				$map/loreds.lored[x].get_node("worker").animation = "ww"
#				$map/loreds.lored[x].get_node("worker").playing = true
#				if not x == "stone":
#					$map/loreds.lored[x].get_node("hold").disabled = true
#					$map/loreds.lored[x].get_node("halt").disabled = true
#				gv.g[x].inhand = Big.new(0)
#				gv.g[x].progress.f = Big.new(0)
#				gv.g[x].progress.b = Big.new()
#				gv.g[x].halt = false
#				gv.g[x].hold = false
#				$map/loreds.lored[x].r_update_halt(gv.g[x].halt)
#				$map/loreds.lored[x].r_update_hold(gv.g[x].hold)
#				if x == "coal" and gv.up["aw <3"].active() and not 0 == reset_type:
#					gv.g[x].active = true
#					$map/loreds.lored[x].get_node("worker").self_modulate = Color(1,1,1,1)
#					$map/loreds.lored[x].get_node("hold").disabled = false
#					$map/loreds.lored[x].get_node("halt").disabled = false
#					gv.g[x].cost["stone"].b.m(price_increase(gv.g[x].type))
#					if gv.menu.option["animations"]:
#						get_node("map/loreds").lored[x].get_node("worker").animation = "ff"
#
#				gv.g[x].sync()
#
#				gv.emit_signal("lored_updated", x, "amount")
#				gv.emit_signal("lored_updated", x, "net")
#
#			$map/loreds.r_update_autobuy()
#
#			for x in gv.stats.up_list["cremover"]:
#				if not gv.up[x].have: continue
#				if not gv.up[x].benefactor_of[0].split(" ")[1] in gv.g[gv.up[x].benefactor_of[0].split(" ")[0]].cost.keys(): continue
#				gv.g[gv.up[x].benefactor_of[0].split(" ")[0]].cost.erase(gv.up[x].benefactor_of[0].split(" ")[1])
#
#		else:
#			for x in ["iron", "irono", "copo", "cop"]:
#				gv.g[x].modifier_from_growin_on_me = Big.new(1)
#
#	w_aa()
#
#	# tasks
#	if true:
#
#		var list = []
#		for x in taq.task:
#			if reset_type > 0:
#				if int(gv.g[taq.task[x].icon.key].type[1]) > reset_type:
#					continue
#			if "{Spike}" in taq.task[x].name:
#				continue
#			list.append(x)
#
#		for x in list:
#			content_tasks["tasks"].content[x].kill_yourself()
#			var bla = content_tasks["tasks"].ready_task_count
#			content_tasks["tasks"].ready_task_count = max(0, bla - 1)
#		if reset_type > 0:
#			content_tasks["tasks"].hit_max_tasks()
#
#	# ref
#	if true:
#
#		if reset_type == 0:
#			$misc/tabs.reset() # default: ["all"]
#			for x in upc:
#				for c in upc[x]:
#					upc[x][c].r_set_shadow("not owned")
#					upc[x][c].get_node("afford_alert").hide()
#					upc[x][c].afford_alert_displayed = false
#
#		if reset_type >= 2:
#			if not gv.up["I know what I'm doing, unlock this shit"].active():
#				$misc/tabs.reset(["s2nup"])
#			else:
#				if not gv.menu.tabs_unlocked["s2nup"]: $misc/tabs.unlock(["s2nup"])
#
#	gv.up["Limit Break"].sync()
#
#	if manual_reset: b_tabkey(KEY_1)
#
#	gv.menu.f = "ye"
#













# buttons
func _clear_content():
	for x in content:
		if not is_instance_valid(content[x]): continue
		content[x].queue_free()
	content.clear()




func b_reset(reset_type : int, manual_reset := true) -> void:
	
	# reset_type = 0, 1, 2, 3, 4
	
	# times reset
	if true:
		if reset_type == 0:
			for x in gv.stats.run.size():
				gv.stats.run[x] = 1
				gv.stats.last_run_dur[x] = 0
				gv.stats.last_reset_clock[x] = OS.get_unix_time()
			gv.stats.most_resources_gained = Big.new(0)
			gv.stats.highest_run = 1
		else:
			
			if reset_type > gv.stats.highest_run:
				gv.stats.highest_run = reset_type
				gv.stats.most_resources_gained = Big.new(0)
			
			if reset_type == gv.stats.highest_run:
				var gg = "malig"
				match reset_type:
					2:
						gg = "tum"
				if gv.stats.most_resources_gained.isLessThan(gv.g[gg].r):
					gv.stats.most_resources_gained = Big.new(gv.g[gg].r)
					print("new highest resources gained: ", gv.stats.most_resources_gained.toString(), " (", gg, ")")
			
			for x in reset_type:
				gv.stats.run[x] += 1
				gv.stats.last_run_dur[x] = OS.get_unix_time() - gv.stats.last_reset_clock[x]
				gv.stats.last_reset_clock[x] = OS.get_unix_time()
	
	# upgrades
	while true:
		
		gv.up["I DRINK YOUR MILKSHAKE"].set_d.b = Big.new()
		
		# full reset
		if reset_type == 0:
			
			for x in $map/upgrades.own_list_good:
				$map/upgrades.own_list_good[x] = false
			
			for x in gv.up:
				
				gv.up[x].icon_set = false
				
				if not gv.up[x].have:
					continue
				
				gv.up[x].have = false
				gv.up[x].active = true
				gv.up[x].refundable = false
				gv.up[x].sync()
				
				if x == "I DRINK YOUR MILKSHAKE":
					gv.up["I DRINK YOUR MILKSHAKE"].set_d.b = Big.new()
				
				# ref
				upc[gv.up[x].path][x].r_set_shadow("not owned")
				upc[gv.up[x].path][x].get_node("border").hide()
				
				upc[gv.up[x].path][x].modulated_one_last_time = false
				upc[gv.up[x].path][x].r_update()
			
			gv.overcharge_list.clear()
			
			break
		
		w_aa()
		
		for x in gv.up:
			
			gv.up[x].icon_set = false
			
			# refundable upgrades are now owned
			if gv.up[x].refundable and str(reset_type) in gv.up[x].type:
				upc[gv.up[x].path][x].get_node("border").show()
				if "mup" in gv.up[x].type:
					upc[gv.up[x].path][x].r_set_shadow("active")
					gv.menu.upgrades_owned[gv.up[x].path] += 1
				gv.up[x].refundable = false
				gv.up[x].have = true
				upc[gv.up[x].path][x].upgrade_effects(x, true, true)
				
				# task stuff
				if taq.cur_quest != "":
					for t in taq.quest.step:
						if x in t:
							taq.quest.step[t].f = Big.new()
				
				gv.up[x].sync()
				
				upc[gv.up[x].path][x].modulated_one_last_time = false
				upc[gv.up[x].path][x].r_update()
				
				continue
			
			if not gv.up[x].have:
				continue
			# if only resetting 1, stage 2 and up will continue
			if reset_type < int(gv.up[x].type[1]): continue
			# if s2 reset, will not reset s2m. if s3, will reset s2m, wont reset s3m
			if int(gv.up[x].type[1]) == reset_type and "mup" in gv.up[x].type: continue
			
			# radiative -> malig
			if reset_type == 2:
				
				if x in ["MOUND", "SIDIUS IRON"] and ((gv.up["AUTO-PERSIST"].refundable or gv.up["AUTO-PERSIST"].have) and gv.up["AUTO-PERSIST"].active): continue
				if (x == "SLAPAPOW!" or x == "SENTIENT DERRICK") and ((gv.up["Mad Science"].refundable or gv.up["Mad Science"].have) and gv.up["Mad Science"].active): continue
				if (x == "CANKERITE" or x == "wtf is that musk") and ((gv.up["Jasmine"].refundable or gv.up["Jasmine"].have) and gv.up["Jasmine"].active): continue
				if (x == "MOIST" or x == "pippenpaddle- oppsoCOPolis") and ((gv.up["UNIONIZE"].refundable or gv.up["UNIONIZE"].have) and gv.up["UNIONIZE"].active): continue
				if (x == "AUTOPOLICE" or x == "AUTOSTONER") and ((gv.up["CARAVAN"].refundable or gv.up["CARAVAN"].have) and gv.up["CARAVAN"].active): continue
				if (x == "OREOREUHBor E ALICE" or x == "AUTOSHOVELER") and ((gv.up["Combo Breaker"].refundable or gv.up["Combo Breaker"].have) and gv.up["Combo Breaker"].active): continue
			
			if "s1 nup" in gv.up[x].type:
				
				var s1sec_half := "INJECT CHEEKS RED GOOPY BOY SWIRLER GEARED OILS STICKYTAR GOOF LOPS C GOOF LOPS I SHMOOF SHMOPS NOOF BLOPS STICKY ICKY T STICKY ICKY M WATT? MAXER MIXER SLIMER SLOP"
				var s1first_half := "MUD THYME PEPPER GARLIC TEXAS RYE ANCHOVE COVE GROUNDER GRANDMA GRANDPA GRANDER GRINDER ORE ASSIST I ORE ASSIST C SAND SALT SAALNDT LIGHTER SHOVEL FLANK RIB"
				var reset := false
				
				if x in s1first_half:
					if not (gv.up["CHUNKUS"].have or gv.up["CHUNKUS"].refundable): reset = true
				if x in s1sec_half:
					if not (gv.up["DUNKUS"].refundable or gv.up["DUNKUS"].have): reset = true
				
				if not reset: continue
			
			# reset every other upgrade:
			
			gv.up[x].have = false
			gv.up[x].active = true
			upc[gv.up[x].path][x].modulated_one_last_time = false
			upc[gv.up[x].path][x].r_update()
			
			w_distribute_upgrade_buff(x)
			if x == "Share the Hit":
				if "2" in gv.overcharge_list:
					gv.overcharge_list.erase("2")
			
			# ref
			gv.up[x].icon_set = false
			upc[gv.up[x].path][x].get_node("border").hide()
			upc[gv.up[x].path][x].r_set_shadow("not owned")
			gv.menu.upgrades_owned[gv.up[x].path] -= 1
		
		for x in $map/upgrades.own_list_good:
			if x >= reset_type: continue
			$map/upgrades.own_list_good[x] = false
		
		for x in gv.up:
			gv.up[x].sync()
		
		break
	
	# resources
	if true:
		
		# reset r
		for x in gv.g:
			
			if not reset_type == 0 and int(gv.g[x].type[1]) > reset_type:
				continue
			
			var top_loreds := ["malig", "tum"]
			if x in top_loreds and int(gv.g[x].type[1]) == reset_type:
				continue
			
			if reset_type >= 1 and not gv.up["CONDUCT"].active() and gv.g[x].type[1] == "1":
				gv.g[x].r = Big.new(0)
			else:
				gv.g[x].r = Big.new(0)
		
		# s2
		if reset_type >= 2:
			
			gv.g["wood"].r.a(80)
			gv.g["soil"].r.a(25)
			gv.g["tree"].r.a(2)
			gv.g["steel"].r.a(65)
			gv.g["hard"].r.a(130)
			gv.g["wire"].r.a(70)
			gv.g["glass"].r.a(60)
			
			if gv.up["Rock-hard Entrance"].active():
				gv.g["steel"].r.a(10)
			if gv.up["Road Head Start"].active():
				gv.g["steel"].r.a(10)
				gv.g["hard"].r.a(20)
			if gv.up["DIII Boost From Clan Mate"].active():
				gv.g["steel"].r.a(20)
				gv.g["hard"].r.a(20)
				gv.g["wire"].r.a(40)
			if gv.up["Life Ins, RIP Grandma"].active():
				gv.g["steel"].r.a(60)
				gv.g["hard"].r.a(60)
				gv.g["wire"].r.a(60)
				gv.g["glass"].r.a(100)
			if gv.up["OH YEEAAAAHH"].active():
				gv.g["steel"].r.a(1000)
				gv.g["hard"].r.a(1000)
				gv.g["wire"].r.a(1000)
				gv.g["glass"].r.a(1000)
			if gv.up["AntiSoftLock"].active():
				for x in gv.g:
					if "1" == gv.g[x].type[1]:
						continue
					gv.g[x].r.a(10000)
		
		# s1
		gv.g["stone"].r.a(5.0)
		if not reset_type == 0:
			gv.g["iron"].r.a(10.0)
			gv.g["cop"].r.a(10.0)
			gv.g["malig"].r = Big.new(Big.max(gv.g["malig"].r, 10))
		if gv.up["FOOD TRUCKS"].active():
			gv.g["cop"].r.a(100.0)
			gv.g["iron"].r.a(100.0)
	
	# loreds
	if true:
		
		if (reset_type == 1 and not gv.up["dust"].active()) or reset_type != 1:
			
			_ready_define_loreds(reset_type)
			
			for x in gv.g:
				
				if reset_type > 0 and int(gv.g[x].type[1]) > reset_type:
					continue
				
				$map/loreds.lored[x].reset_lb()
				
				if reset_type == 0:
					if not (x == "coal" or x == "stone"):
						$map/loreds.lored[x].hide()
				$map/loreds.lored[x].get_node("worker").animation = "ww"
				$map/loreds.lored[x].get_node("worker").playing = true
				if not x == "stone":
					$map/loreds.lored[x].get_node("hold").disabled = true
					$map/loreds.lored[x].get_node("halt").disabled = true
				gv.g[x].inhand = Big.new(0)
				gv.g[x].progress.f = Big.new(0)
				gv.g[x].progress.b = Big.new()
				gv.g[x].halt = false
				gv.g[x].hold = false
				$map/loreds.lored[x].r_update_halt(gv.g[x].halt)
				$map/loreds.lored[x].r_update_hold(gv.g[x].hold)
				if x == "coal" and gv.up["aw <3"].active() and not 0 == reset_type:
					gv.g[x].active = true
					$map/loreds.lored[x].get_node("worker").self_modulate = Color(1,1,1,1)
					$map/loreds.lored[x].get_node("hold").disabled = false
					$map/loreds.lored[x].get_node("halt").disabled = false
					gv.g[x].cost["stone"].b.m(price_increase(gv.g[x].type))
					if gv.menu.option["animations"]:
						get_node("map/loreds").lored[x].get_node("worker").animation = "ff"
				
				gv.g[x].sync()
				
				gv.emit_signal("lored_updated", x, "amount")
				gv.emit_signal("lored_updated", x, "net")
			
			$map/loreds.r_update_autobuy()
			
			for x in gv.stats.up_list["cremover"]:
				if not gv.up[x].have: continue
				if not gv.up[x].benefactor_of[0].split(" ")[1] in gv.g[gv.up[x].benefactor_of[0].split(" ")[0]].cost.keys(): continue
				gv.g[gv.up[x].benefactor_of[0].split(" ")[0]].cost.erase(gv.up[x].benefactor_of[0].split(" ")[1])
		
		else:
			for x in ["iron", "irono", "copo", "cop"]:
				gv.g[x].modifier_from_growin_on_me = Big.new(1)
	
	w_aa()
	
	# tasks
	if true:
		
		var list = []
		for x in taq.task:
			if reset_type > 0:
				if int(gv.g[taq.task[x].icon.key].type[1]) > reset_type:
					continue
			if "{Spike}" in taq.task[x].name:
				continue
			list.append(x)
		
		for x in list:
			content_tasks["tasks"].content[x].kill_yourself()
			var bla = content_tasks["tasks"].ready_task_count
			content_tasks["tasks"].ready_task_count = max(0, bla - 1)
		if reset_type > 0:
			content_tasks["tasks"].hit_max_tasks()
	
	# ref
	if true:
		
		if reset_type == 0:
			$misc/tabs.reset() # default: ["all"]
			for x in upc:
				for c in upc[x]:
					upc[x][c].r_set_shadow("not owned")
					upc[x][c].get_node("afford_alert").hide()
					upc[x][c].afford_alert_displayed = false
		
		if reset_type >= 2:
			if not gv.up["I know what I'm doing, unlock this shit"].active():
				$misc/tabs.reset(["s2nup"])
			else:
				if not gv.menu.tabs_unlocked["s2nup"]: $misc/tabs.unlock(["s2nup"])
	
	gv.up["Limit Break"].sync()
	
	if manual_reset: b_tabkey(KEY_1)
	
	gv.menu.f = "ye"
func b_tabkey(key):
	
	tabby[gv.menu.tab] = $map.get_global_position().y
	$map/tip._call("no")
	$global_tip._call("no")
	
	var y = 150
	
	match key:
		
		KEY_ESCAPE:
			
			# exit the upgrade tab you're in
			if $up_container.visible:
				$up_container.hide()
				return
			if "s" == gv.menu.tab[0]:
				_clear_content()
				$misc.show()
				match tabby["last stage"]:
					"1":
						b_tabkey(KEY_1)
					"2":
						b_tabkey(KEY_2)
					"3":
						b_tabkey(KEY_3)
					"4":
						b_tabkey(KEY_4)
				return
			
			# open the menu
			if not $misc/menu.visible:
				$misc/menu.show()
				return
			
			# close the menu (should probably stay at the bottom. if must move above something, make this func return a bool. if return g.visible = true, then RETURN below the func)
			b_close_menu()
			return
		
		# lored tabs
		KEY_1:
			
			if gv.menu.tab == "1" and $map.get_global_position().y != 150:
				b_move_map(0, y)
				return
			
			w_tabkey_assist_lored("1", 800)
		
		KEY_2:
			
			if not gv.menu.tabs_unlocked["2"]: return
			
			if gv.menu.tab == "2" and $map.get_global_position().y != 150:
				b_move_map(-1200, y)
				return
			
			w_tabkey_assist_lored("2", 1295)
		
		# key 3: tab2, key 4: tab3. boom, all stages.
		
		KEY_Q:
			
			if not gv.menu.tabs_unlocked["s" + tabby["last stage"] + "nup"]: return
			
			if gv.menu.tab == "s" + tabby["last stage"] + "n":
				b_move_map(0, y)
				return
			
			w_tabkey_assist_upgrade("s" + tabby["last stage"] + "n")
			
			content["up back"].init("s" + tabby["last stage"] + "n", get_viewport_rect().size.x)
			
			$misc/tabs.up["s" + tabby["last stage"] + "nup"].get_node("alert").b_flash(false)
		
		KEY_W:
			
			if not gv.menu.tabs_unlocked["s" + tabby["last stage"] + "mup"]: return
			
			if gv.menu.tab == "s" + tabby["last stage"] + "m":
				b_move_map(0, y)
				return
			
			w_tabkey_assist_upgrade("s" + tabby["last stage"] + "m")
			
			content["up back"].init("s" + tabby["last stage"] + "m", get_viewport_rect().size.x)
func w_tabkey_assist_lored(last_stage : String, map_height_limit : int) -> void:
	
	tabby["last stage"] = last_stage
	
	# clear upgrades
	if "s" == gv.menu.tab[0]:
		_clear_content()
		$misc.show()
	
	$map/misc/t0.hide()
	$map/misc/t1.hide()
	
	for x in gv.g:
		if not last_stage in gv.g[x].type:
			$map/loreds.lored[x].hide()
		else:
			if gv.g[x].unlocked:
				if last_stage in gv.g[x].type:
					$map/loreds.lored[x].show()
	
	$map.height_limit = map_height_limit
	gv.menu.tab = last_stage
	b_move_map(-1200 * (int(gv.menu.tab) - 1), tabby[gv.menu.tab])
	$misc/qol_displays/resource_bar.r_adjust()
	$map/loreds.show()
	$map/upgrades.hide()
	
	b_close_menu()
	
	for x in $misc/tabs.lored:
		if int(x) == int(tabby["last stage"]):
			$misc/tabs.lored[x].r_update(true)
			continue
		$misc/tabs.lored[x].r_update(false)
func w_tabkey_assist_upgrade(tab : String) -> void:
	
	gv.menu.tab = tab
	match tab:
		"s1n": $map.height_limit = 600
		"s1m": $map.height_limit = 1200
		"s2n": $map.height_limit = 1200
		"s2m": $map.height_limit = 2200
	_clear_content()
	$misc/qol_displays/resource_bar.r_adjust()
	b_move_map(0, tabby[gv.menu.tab])
	content["up back"] = prefab["upgrade_back"].instance()
	$upgrades.add_child(content["up back"])
	$misc.hide()
	$map/upgrades.show()
	
	$map/misc/t0.show()
	$map/misc/t1.show()
	
	# hide time on tasks
	if "tasks" in content_tasks.keys():
		for x in content_tasks["tasks"].content:
			var f = content_tasks["tasks"].content
			if f[x].get_node("time").visible:
				f[x].get_node("time").hide()
	
	# display upgrades
	if true:
	
		# this loop only cycles through four nodes (2 per stage), instead of through every single upgrade
		for x in $map/upgrades.get_children():
			if not tab in x.name:
				$map/upgrades.get_node(x.name).hide()
			else:
				$map/upgrades.get_node(x.name).show()
		$map/loreds.hide()
	
	b_close_menu()
func b_close_menu() -> void:
	if not $misc/menu.visible: return
	$misc/menu.hide()
func b_move_map(x, y):

	$map.status = "no"
	$map.set_global_position(Vector2(x, y))

#func w_handle_timer(t : Timer) -> void:
#

# essential (brought to every godot project and used a fucking lot)
func e_save(type := "normal", path := SAVE.MAIN):
	
	var save := _save.new()
	
	# menu and stats
	if true:
		
		save.game_version = ProjectSettings.get_setting("application/config/Version")
		
		save.data["menu"] = gv.menu.f
		for x in gv.stats.run.size():
			save.data["gv.stats.run[" + str(x) + "]"] = gv.stats.run[x]
			save.data["stats.last_run_dur[" + str(x) + "]"] = gv.stats.last_run_dur[x]
			save.data["stats.last_reset_clock[" + str(x) + "]"] = gv.stats.last_reset_clock[x]
		save.data["cur_clock"] = cur_clock
		save.data["times game loaded"] = times_game_loaded
		
		for x in gv.menu.option:
			save.data["option " + x] = gv.menu.option[x]
			if x == "on_save_menu_options" and not gv.menu.option[x]: break
		
		save.data["time_played"] = gv.stats.time_played
		save.data["tasks_completed"] = gv.stats.tasks_completed
		for x in gv.stats.r_gained:
			save.data["r_gained " + x] = gv.stats.r_gained[x].toScientific()
		
		save.data["most_resources_gained"] = gv.stats.most_resources_gained.toScientific()
		save.data["stats.highest_run"] = gv.stats.highest_run
		
		var ref := [Big.new(0), Big.new(0)]
		for x in gv.up:
			if gv.up[x].cost.size() == 0: continue
			if "mup" in gv.up[x].type and gv.up[x].refundable:
				ref[0].a(gv.up[x].cost.values()[0].t)
		save.data["ref_0"] = ref[0].toScientific()
		save.data["ref_1"] = ref[1].toScientific()
		
		for x in gv.stats.last_reset_clock.size():
			save.data["save last reset clock " + String(x)] = gv.stats.last_reset_clock[x]
	
	# tasks
	if true:
		
		for x in tasks:
			save.data["task " + x + " complete"] = tasks[x].complete
		
		if taq.cur_quest != "":
			
			save.data["load quest"] = true
			
			save.data["on quest"] = taq.cur_quest
			for x in taq.quest.step:
				save.data["quest step " + x + " f"] = taq.quest.step[x].f.toScientific()
		else:
			save.data["load quest"] = false
		
		var i = 0
		for x in taq.task:
			
			save.data["task " + str(i) + " name"] = taq.task[x].name
			save.data["task " + str(i) + " desc"] = taq.task[x].desc
			save.data["task " + str(i) + " icon"] = taq.task[x].icon.key
			
			var ii := 0
			for v in taq.task[x].step:
				save.data["task " + str(i) + " step key " + str(ii)] = v
				save.data["task " + str(i) + " b " + str(ii)] = taq.task[x].step[v].b.toScientific()
				save.data["task " + str(i) + " f " + str(ii)] = taq.task[x].step[v].f.toScientific()
				ii += 1
			save.data["task " + str(i) + " steps"] = ii
			
			ii = 0
			for v in taq.task[x].resource_reward:
				save.data["task " + str(i) + " rr key " + str(ii)] = v
				save.data["task " + str(i) + " rr " + str(ii)] = taq.task[x].resource_reward[v].toScientific()
				ii += 1
			save.data["task " + str(i) + " rr num"] = ii
			
			ii = 0
			for v in taq.task[x].reward:
				save.data["task " + str(i) + " r key " + str(ii)] = v
				save.data["task " + str(i) + " r " + str(ii)] = taq.task[x].reward[v].toScientific()
				ii += 1
			save.data["task " + str(i) + " r num"] = ii
			
			i += 1
		
		save.data["task count"] = i
	
	# upgrades
	if true:
		
		if gv.up["I DRINK YOUR MILKSHAKE"].active():
			save.data["[I DRINK YOUR MILKSHAKE] d"] = gv.up["I DRINK YOUR MILKSHAKE"].set_d.b.toScientific()
		
		if gv.up["IT'S GROWIN ON ME"].active():
			save.data["[IT'S GROWIN ON ME] d"] = gv.up["IT'S GROWIN ON ME"].set_d.b.toScientific()
		
		for x in gv.up:
			save.data["[" + x + "] have"] = gv.up[x].have
			save.data["[" + x + "] active"] = gv.up[x].active
			save.data["[" + x + "] refundable"] = gv.up[x].refundable
			save.data["[" + x + "] unlocked"] = gv.up[x].unlocked
			save.data["[" + x + "] times_purchased"] = gv.up[x].times_purchased
	
	# loreds
	if true:
		
		for x in gv.g:
			
			save.data["g" + x + " r"] = Big.new(gv.g[x].r).roundDown().toScientific()
			save.data["g" + x + " active"] = gv.g[x].active
			save.data["g" + x + " unlocked"] = gv.g[x].unlocked
			save.data["g" + x + " key"] = gv.g[x].key_lored
			
			if not gv.g[x].active:
				continue
			
			save.data["g" + x + " modifier_from_growin_on_me"] = gv.g[x].modifier_from_growin_on_me.toScientific()
			save.data["g" + x + " level"] = gv.g[x].level
			save.data["g" + x + " fuel"] = gv.g[x].f.f.toScientific()
			
			save.data["g" + x + " halt"] = gv.g[x].halt
			
			save.data["g" + x + " hold"] = gv.g[x].hold
			save.data["g" + x + " task"] = gv.g[x].task
			save.data["g" + x + " progress"] = gv.g[x].progress.f.toScientific()
			save.data["g" + x + " progress b"] = gv.g[x].progress.b.toScientific()
			save.data["g" + x + " inhand"] = gv.g[x].inhand.toScientific()
	
	# fin & misc
	if true:
		
		var save_file = File.new()
		
		match type:
			"normal":
				
				# save to new temp file
				if true:
					
					# delete old NEW SAVE
					if save_file.file_exists(SAVE.NEW):
						var dir = Directory.new()
						dir.remove(SAVE.NEW)
					
					# create NEW SAVE
					save_file.open(SAVE.NEW, File.WRITE)
					save_file.store_line(save.game_version)
					save_file.store_line(Marshalls.variant_to_base64(save.data))
					save_file.close()
				
				# save old SAVE to OLD SAVE
				if true:
					
					if save_file.file_exists(SAVE.MAIN):
						
						save_file.open(SAVE.MAIN, File.READ)
						
						var save2 = _save.new()
						save2.game_version = save_file.get_line()
						save2.data = Marshalls.base64_to_variant(save_file.get_line())
						
						save_file.close()
						
						# delete old OLD SAVE
						
						if save_file.file_exists(SAVE.OLD):
							var dir = Directory.new()
							dir.remove(SAVE.OLD)
						
						# create OLD SAVE
						
						save_file.open(SAVE.OLD, File.WRITE)
						save_file.store_line(save2.game_version)
						save_file.store_line(Marshalls.variant_to_base64(save2.data))
						save_file.close()
				
				# save to SAVE and delete NEW SAVE
				if true:
					
					# delete SAVE
					if save_file.file_exists(SAVE.MAIN):
						var dir = Directory.new()
						dir.remove(SAVE.MAIN)
					
					# create SAVE
					save_file.open(SAVE.MAIN, File.WRITE)
					save_file.store_line(save.game_version)
					save_file.store_line(Marshalls.variant_to_base64(save.data))
					save_file.close()
					
					# delete NEW SAVE
					if save_file.file_exists(SAVE.NEW):
						var dir = Directory.new()
						dir.remove(SAVE.NEW)
			
			"export":
				
				# create SAVE
				save_file.open(path, File.WRITE)
				save_file.store_line(save.game_version)
				save_file.store_line(Marshalls.variant_to_base64(save.data))
				save_file.close()
			
			"print to console":
				print("Save is below! Copy the game version and the save data to a text file.")
				print(save.game_version)
				print(Marshalls.variant_to_base64(save.data))
		
		w_aa()
func e_load(path := SAVE.MAIN) -> bool:
	
	var save_file = File.new()
	var save := _save.new()
	
	# file shit
	while true:
		
#		if importing:
#
#			if get_node("misc/menu/g/save/g/t0/g/textedit").text != "":
#
#				save.game_version = get_node("misc/menu/g/save/g/t0/g/textedit").text.split("\n")[0]
#				save.data = Marshalls.base64_to_variant(get_node("misc/menu/g/save/g/t0/g/textedit").text.split("\n")[1])
#				get_node("misc/menu/g/save/g/t0/g/textedit").text = ""
#
#			else:
#
#				save.game_version = OS.get_clipboard().split("\n")[0]
#				save.data = Marshalls.base64_to_variant(OS.get_clipboard().split("\n")[1])
#
#			break
		
		if not save_file.file_exists(path):
			return false
		
		# load from base64
		save_file.open(path, File.READ)
		
		save.game_version = save_file.get_line()
		
		# sub version
		save.data = Marshalls.base64_to_variant(save_file.get_line())
		
		save_file.close()
		
		break
	
	if not "2" in save.game_version[0]:
		print("Save from 1.2c or earlier--what the heck, have you really not played since then? Welcome back, jeez!")
		return false
	
	var beta_version = save.game_version.split("(")[1].split(")")[0] if "(" in save.game_version else "0"
	
	if int(beta_version) <= 3:
		return e_load_pre_beta_4(save)
	
	var keys = save.data.keys()
	
	# menu and stats
	if true:
		
		gv.menu.f = save.data["menu"]
		for x in gv.stats.run.size():
			if "gv.stats.run[" + str(x) + "]" in keys:
				gv.stats.run[x] = save.data["gv.stats.run[" + str(x) + "]"]
			if "stats.last_run_dur[" + str(x) + "]" in keys:
				gv.stats.last_run_dur[x] = save.data["stats.last_run_dur[" + str(x) + "]"]
			if "stats.last_reset_clock[" + str(x) + "]" in keys:
				gv.stats.last_reset_clock[x] = save.data["stats.last_reset_clock[" + str(x) + "]"]
		times_game_loaded = save.data["times game loaded"] + 1
		
		for x in gv.menu.option:
			
			if not "option " + x in keys: continue
			if PLATFORM == "browser" and x == "performance": continue
			
			gv.menu.option[x] = save.data["option " + x]
			if x == "on_save_menu_options" and not gv.menu.option[x]: break
		
		gv.stats.time_played = save.data["time_played"]
		gv.stats.tasks_completed = save.data["tasks_completed"]
		for x in gv.stats.r_gained:
			gv.stats.r_gained[x] = Big.new(save.data["r_gained " + x])
		
		if "most_resources_gained" in keys:
			gv.stats.most_resources_gained = Big.new(save.data["most_resources_gained"])
		if "stats.highest_run" in keys:
			gv.stats.highest_run = save.data["stats.highest_run"]
		
		for x in gv.stats.last_reset_clock.size():
			if not ("save last reset clock " + str(x)) in keys: continue
			gv.stats.last_reset_clock[x] = save.data["save last reset clock " + str(x)]
	
	# upgrades
	if true:
		
		if "[I DRINK YOUR MILKSHAKE] d" in keys:
			gv.up["I DRINK YOUR MILKSHAKE"].set_d.b = Big.new(save.data["[I DRINK YOUR MILKSHAKE] d"])
		
		if "[IT'S GROWIN ON ME] d" in keys:
			gv.up["IT'S GROWIN ON ME"].set_d.b = Big.new(save.data["[IT'S GROWIN ON ME] d"])
		
		for x in gv.up:
			
			if not "[" + x + "] have" in keys: continue
			
			gv.up[x].have = save.data["[" + x + "] have"]
			gv.up[x].active = save.data["[" + x + "] active"]
			gv.up[x].refundable = save.data["[" + x + "] refundable"]
			if "[" + x + "] times_purchased" in keys:
				gv.up[x].times_purchased = save.data["[" + x + "] times_purchased"]
			if "[" + x + "] unlocked" in keys:
				gv.up[x].unlocked = save.data["[" + x + "] unlocked"]
			
			if gv.up[x].have:
				
				upc[gv.up[x].path][x].get_node("border").show()
				
				if gv.up[x].active:
					upc[gv.up[x].path][x].r_set_shadow("active")
				else:
					upc[gv.up[x].path][x].r_set_shadow("inactive")
			
			if not gv.up[x].refundable: continue
			
			gv.up[x].refundable = false
			if not "no" in gv.menu.f: continue
			if not gv.menu.f.split("no s")[1] == gv.up[x].type[1]: continue
			
			gv.up[x].sync()
			
			for c in gv.up[x].cost:
				gv.g[c].r.a(gv.up[x].cost[c].t)
				gv.emit_signal("lored_updated", c, "amount")
		
		for x in gv.up:
			gv.up[x].sync()
			if not "reset" in gv.up[x].type:
				upc[gv.up[x].path][x].r_update()
#				if x in $misc/upgrades.cont_ups[gv.up[x].path].keys():
#					$misc/upgrades.cont_ups[gv.up[x].path][x].r_update()
			if not gv.up[x].have: continue
			gv.menu.upgrades_owned[gv.up[x].path] += 1
		
		for x in gv.stats.up_list:
			if not "benefactor" in x: continue
			for v in gv.stats.up_list[x]:
				w_distribute_upgrade_buff(v)
	
	# loreds
	if true:
		
		for x in gv.g:
			
			gv.g[x].active = save.data["g" + x + " active"]
			gv.g[x].r.a(Big.new(save.data["g" + x + " r"]))
			if "g" + x + " unlocked" in keys:
				gv.g[x].unlocked = save.data["g" + x + " unlocked"]
			if "g" + x + " key" in keys:
				gv.g[x].key_lored = save.data["g" + x + " key"]
			
			if not gv.g[x].active:
				continue
			
			if ("g" + x + " modifier_from_growin_on_me") in keys:
				gv.g[x].modifier_from_growin_on_me = Big.new(save.data["g" + x + " modifier_from_growin_on_me"])
			
			gv.g[x].level = save.data["g" + x + " level"]
			
			if x != "stone":
				gv.g[x].cost_modifier.m(price_increase(gv.g[x].type))
			
			for v in gv.g[x].level - 1:
				gv.g[x].output_modifier.m(2)
				gv.g[x].fc.b.m(2)
				gv.g[x].f.b.m(2)
				gv.g[x].cost_modifier.m(price_increase(gv.g[x].type))
			
			if gv.menu.option["on_save_halt"] and "g" + x + " halt" in keys: gv.g[x].halt = save.data["g" + x + " halt"]
			if gv.menu.option["on_save_hold"] and "g" + x + " hold" in keys: gv.g[x].hold = save.data["g" + x + " hold"]
			
			if gv.menu.option["tank_my_pc"]:
				for v in get_node("map/loreds").lored[x].fps:
					get_node("map/loreds").lored[x].fps[v]["t"] *= 0.1
			
			$map/loreds.lored[x].r_update_halt(gv.g[x].halt)
			$map/loreds.lored[x].r_update_hold(gv.g[x].hold)
			
			gv.g[x].f.f = Big.new(save.data["g" + x + " fuel"])
			gv.g[x].task = save.data["g" + x + " task"]
			
			gv.g[x].progress.f = Big.new(save.data["g" + x + " progress"])
			gv.g[x].progress.b = Big.new(save.data["g" + x + " progress b"])
			gv.g[x].inhand = Big.new(save.data["g" + x + " inhand"])
			
			if gv.g[x].progress.f.isLargerThan(0) and gv.menu.option["animations"]:
				$map/loreds.lored[x].get_node("worker").animation = "ff"
			
			gv.g[x].sync()
	
	# tasks and quests
	if true:
		
		for x in tasks:
			if "task " + x + " complete" in keys:
				tasks[x].complete = save.data["task " + x + " complete"]
		
		if "load quest" in keys:
			if save.data["load quest"]:
				taq.new_quest(tasks[save.data["on quest"]])
				for x in taq.quest.step:
					if not "quest step " + x + " f" in keys:
						continue
					taq.quest.step[x].f = Big.new(save.data["quest step " + x + " f"])
		
		if "task count" in keys:
			if save.data["task count"] > 0:
				
				for i in save.data["task count"]:
					
					if taq.cur_tasks >= taq.max_tasks:
						break
					
					var name = save.data["task " + str(i) + " name"]
					var desc = save.data["task " + str(i) + " desc"]
					var icon = {texture = gv.sprite[save.data["task " + str(i) + " icon"]], key = save.data["task " + str(i) + " icon"]}
					var steps := {}
					var rr := {}
					var r := {}
					
					for ii in save.data["task " + str(i) + " steps"]:
						steps[save.data["task " + str(i) + " step key " + str(ii)]] = Ob.Num.new(save.data["task " + str(i) + " b " + str(ii)])
						steps[save.data["task " + str(i) + " step key " + str(ii)]].f = Big.new(save.data["task " + str(i) + " f " + str(ii)])
					
					for ii in save.data["task " + str(i) + " rr num"]:
						rr[save.data["task " + str(i) + " rr key " + str(ii)]] = Big.new(save.data["task " + str(i) + " rr " + str(ii)])
					
					for ii in save.data["task " + str(i) + " r num"]:
						r[save.data["task " + str(i) + " r key " + str(ii)]] = save.data["task " + str(i) + " r " + str(ii)]
					
					taq.task[float(i)] = taq.Task.new(name, desc, rr, r, steps, icon, r_lored_color(save.data["task " + str(i) + " icon"]))
					taq.task[float(i)].code = float(i)
	
	# shit that needs to be done before offline earnings
	if true:
		
		# limit break
		if true:
			
			gv.overcharge = mod_overcharge()
			
			if gv.up["Limit Break"].active():
				gv.overcharge_list.append("1")
			if gv.up["Share the Hit"].active():
				gv.overcharge_list.append("2")
	
	# offline earnings
	if true:
		
		var clock_dif = cur_clock - save.data["cur_clock"] - 10
		if clock_dif > 0:
			w_total_per_sec(clock_dif)
	
	# fin & misc
	if true:
		
		if tasks["Pretty Wet"].complete:
			var butt = ["Intro!", "More Intro!", "Welcome to LORED", "Upgrades!", "Menu!", "Tasks!"]
			for x in butt:
				tasks[x].complete = true
	
	return true

func e_load_pre_beta_4(save: _save, path := SAVE.MAIN) -> bool:
	
	print("Save is from 2.0 BETA (3) or earlier; converting floats to Bigs!")
	
	var keys = save.data.keys()
	
	# menu and stats
	if true:
		
		gv.menu.f = save.data["menu"]
		for x in gv.stats.run.size():
			if "gv.stats.run[" + str(x) + "]" in keys:
				gv.stats.run[x] = save.data["gv.stats.run[" + str(x) + "]"]
			if "stats.last_run_dur[" + str(x) + "]" in keys:
				gv.stats.last_run_dur[x] = save.data["stats.last_run_dur[" + str(x) + "]"]
			if "stats.last_reset_clock[" + str(x) + "]" in keys:
				gv.stats.last_reset_clock[x] = save.data["stats.last_reset_clock[" + str(x) + "]"]
		times_game_loaded = save.data["times game loaded"] + 1
		
		for x in gv.menu.option:
			if not "option " + x in keys: continue
			gv.menu.option[x] = save.data["option " + x]
			if x == "on_save_menu_options" and not gv.menu.option[x]: break
		
		# this is only for this function
		gv.menu.option["notation_type"] = 0
		
		gv.stats.time_played = save.data["time_played"]
		gv.stats.tasks_completed = save.data["tasks_completed"]
		for x in gv.stats.r_gained:
			gv.stats.r_gained[x] = Big.new(fval.f(save.data["r_gained " + x]))
		
		if "most_resources_gained" in keys:
			gv.stats.most_resources_gained = Big.new(fval.f(save.data["most_resources_gained"]))
		if "stats.highest_run" in keys:
			gv.stats.highest_run = save.data["stats.highest_run"]
		
		for x in gv.stats.last_reset_clock.size():
			if not ("save last reset clock " + str(x)) in keys: continue
			gv.stats.last_reset_clock[x] = save.data["save last reset clock " + str(x)]
	
	# upgrades
	if true:
		
		if "[I DRINK YOUR MILKSHAKE] d" in keys:
			gv.up["I DRINK YOUR MILKSHAKE"].set_d.b = Big.new(fval.f(save.data["[I DRINK YOUR MILKSHAKE] d"]))
		
		if "[IT'S GROWIN ON ME] d" in keys:
			gv.up["IT'S GROWIN ON ME"].set_d.b = Big.new(fval.f(save.data["[IT'S GROWIN ON ME] d"]))
		
		for x in gv.up:
			
			if not "[" + x + "] have" in keys: continue
			
			gv.up[x].have = save.data["[" + x + "] have"]
			gv.up[x].active = save.data["[" + x + "] active"]
			gv.up[x].refundable = save.data["[" + x + "] refundable"]
			if "[" + x + "] times_purchased" in keys:
				gv.up[x].times_purchased = save.data["[" + x + "] times_purchased"]
			if "[" + x + "] unlocked" in keys:
				gv.up[x].unlocked = save.data["[" + x + "] unlocked"]
			
			if gv.up[x].have:
				
				upc[gv.up[x].path][x].get_node("border").show()
				
				if gv.up[x].active:
					upc[gv.up[x].path][x].r_set_shadow("active")
				else:
					upc[gv.up[x].path][x].r_set_shadow("inactive")
			
			if not gv.up[x].refundable: continue
			
			gv.up[x].refundable = false
			if not "no" in gv.menu.f: continue
			if not gv.menu.f.split("no s")[1] == gv.up[x].type[1]: continue
			
			gv.up[x].sync()
			
			for c in gv.up[x].cost:
				gv.g[c].r.a(gv.up[x].cost[c].t)
				gv.emit_signal("lored_updated", c, "amount")
		
		for x in gv.up:
			
			gv.up[x].sync()
			
			if not "reset" in gv.up[x].type:
				upc[gv.up[x].path][x].r_update()
#				if x in $misc/upgrades.cont_ups[gv.up[x].path].keys():
#					$misc/upgrades.cont_ups[gv.up[x].path][x].r_update()
			if not gv.up[x].have: continue
			gv.menu.upgrades_owned[gv.up[x].path] += 1
		
		for x in gv.stats.up_list:
			if not "benefactor" in x: continue
			for v in gv.stats.up_list[x]:
				w_distribute_upgrade_buff(v)
	
	# loreds
	if true:
		
		for x in gv.g:
			
			gv.g[x].r.a(Big.new(save.data["g" + x + " r"]))
			gv.emit_signal("lored_updated", x, "amount")
			gv.g[x].active = save.data["g" + x + " active"]
			if "g" + x + " unlocked" in keys:
				gv.g[x].unlocked = save.data["g" + x + " unlocked"]
			if "g" + x + " key" in keys:
				gv.g[x].key_lored = save.data["g" + x + " key"]
			
			if not gv.g[x].active:
				continue
			
			if ("g" + x + " modifier_from_growin_on_me") in keys:
				gv.g[x].modifier_from_growin_on_me = Big.new(fval.f(save.data["g" + x + " modifier_from_growin_on_me"]))
			
			gv.g[x].level = save.data["g" + x + " level"]
			
			if x != "stone":
				gv.g[x].cost_modifier.m(price_increase(gv.g[x].type))
			
			for v in gv.g[x].level - 1:
				gv.g[x].output_modifier.m(2)
				gv.g[x].fc.b.m(2)
				gv.g[x].f.b.m(2)
				gv.g[x].cost_modifier.m(price_increase(gv.g[x].type))
			
			if gv.menu.option["on_save_halt"] and "g" + x + " halt" in keys: gv.g[x].halt = save.data["g" + x + " halt"]
			if gv.menu.option["on_save_hold"] and "g" + x + " hold" in keys: gv.g[x].hold = save.data["g" + x + " hold"]
			$map/loreds.lored[x].r_update_halt(gv.g[x].halt)
			$map/loreds.lored[x].r_update_hold(gv.g[x].hold)
			
			gv.g[x].f.f = Big.new(fval.f(save.data["g" + x + " fuel"]))
			
			gv.g[x].task = save.data["g" + x + " task"]
			gv.g[x].progress.f = Big.new(fval.f(save.data["g" + x + " progress"]))
			gv.g[x].progress.b = Big.new(fval.f(save.data["g" + x + " progress b"]))
			gv.g[x].inhand = Big.new(fval.f(save.data["g" + x + " inhand"]))
			
			if gv.g[x].progress.f.isLargerThan(0) and gv.menu.option["animations"]:
				$map/loreds.lored[x].get_node("worker").animation = "ff"
			
			gv.g[x].sync()
	
	# tasks and quests
	if true:
		
		for x in tasks:
			if "task " + x + " complete" in keys:
				tasks[x].complete = save.data["task " + x + " complete"]
		
		if "load quest" in keys:
			if save.data["load quest"]:
				taq.new_quest(tasks[save.data["on quest"]])
				for x in taq.quest.step:
					taq.quest.step[x].f = Big.new(fval.f(save.data["quest step " + x + " f"]))
		
		if "task count" in keys:
			if save.data["task count"] > 0:
				
				for i in save.data["task count"]:
					
					var name = save.data["task " + str(i) + " name"]
					var desc = save.data["task " + str(i) + " desc"]
					var icon = {texture = gv.sprite[save.data["task " + str(i) + " icon"]], key = save.data["task " + str(i) + " icon"]}
					var steps := {}
					var rr := {}
					var r := {}
					
					for ii in save.data["task " + str(i) + " steps"]:
						steps[save.data["task " + str(i) + " step key " + str(ii)]] = Ob.Num.new(save.data["task " + str(i) + " b " + str(ii)])
						steps[save.data["task " + str(i) + " step key " + str(ii)]].f = Big.new(fval.f(save.data["task " + str(i) + " f " + str(ii)]))
					
					for ii in save.data["task " + str(i) + " rr num"]:
						rr[save.data["task " + str(i) + " rr key " + str(ii)]] = Big.new(fval.f(save.data["task " + str(i) + " rr " + str(ii)]))
					
					for ii in save.data["task " + str(i) + " r num"]:
						r[save.data["task " + str(i) + " r key " + str(ii)]] = save.data["task " + str(i) + " r " + str(ii)]
					
					taq.task[float(i)] = taq.Task.new(name, desc, rr, r, steps, icon, r_lored_color(save.data["task " + str(i) + " icon"]))
					taq.task[float(i)].code = float(i)
	
	# shit that needs to be done before offline earnings
	if true:
		
		# limit break
		if true:
			
			gv.overcharge = mod_overcharge()
			
			if gv.up["Limit Break"].active():
				gv.overcharge_list.append("1")
			if gv.up["Share the Hit"].active():
				gv.overcharge_list.append("2")
	
	# offline earnings
	if true:
		
		var clock_dif = cur_clock - save.data["cur_clock"] - 10
		if clock_dif > 0:
			w_total_per_sec(clock_dif)
	
	# fin & misc
	if true:
		
		if tasks["Pretty Wet"].complete:
			var butt = ["Intro!", "More Intro!", "Welcome to LORED", "Upgrades!", "Menu!", "Tasks!"]
			for x in butt:
				tasks[x].complete = true
	
	return true

#var gold = Big.new("1e5")
func _on_Button_pressed() -> void:
	#gold.m(1.01)
	#print(gold.toString())
	#gv.g["tum"].r.m(2)
	pass
	

