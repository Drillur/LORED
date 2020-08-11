class_name _root
extends Node2D

const PLATFORM = "pc" # keep lower-case
const DEFAULT_KEY_LOREDS := ["stone", "conc", "malig", "water", "lead", "tree", "soil", "steel", "wire", "glass", "tum"]

const SAVE := {
	MAIN = "user://save.lored",
	NEW = "user://new_save.lored",
	OLD = "user://last_save.lored"
}

const prefab := {
	tasks = preload("res://Prefabs/task/tasks.tscn"),
	
	tip_autobuyer = preload("res://Prefabs/tooltip/autobuyer.tscn"),
	
	"dtext": preload("res://Prefabs/dtext.tscn"),
	"confirmation popup": preload("res://Prefabs/lored_buy.tscn"),
	"menu": preload("res://Prefabs/menu/menu.tscn"),
	
	"progress_texture_limit_break": preload("res://Prefabs/lored/progress_texture_limit_break.tscn"),
}


var FPS = 0.04


var content := {}
var content_tasks := {}
var instances := {}
var upgrade_dtexts := {}
var afford_check_fps := 0.0

var save_fps = 0.0
var times_game_loaded = 0
var loredalert = ""

var cur_clock = OS.get_unix_time()
var last_clock = OS.get_unix_time()
var cur_session = 0
var time_fps = 0.0

var menu_window = 0

const gnLOREDs = "m/v/LORED List"
const gntaq = "m/v/bot/h/taq"
const gnquest = gntaq + "/quest"
const gnLB = "m/v/top/h/Limit Break"
const gnupcon = "m/up_container"
const gnalert = "misc/tabs/v/upgrades/alert"
const gn_patch = "m/Patch Notes"

# actually quests*
var quests := {
	
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
		{"coal": Big.new(30), "stone" : Big.new(30)},
		{"Normal Upgrade Menu": gv.sprite["s1n"]},
		{"Stone LORED bought": Ob.Num.new()},
		{texture = gv.sprite["stone"], key = "stone"},
		r_lored_color("stone")
	),
	"Upgrades!": taq.Task.new(
		"Upgrades!",
		"Purchase the GRINDER upgrade in the Normal Upgrades menu. (Hotkey: ` or Q)",
		{"iron" : Big.new(30), "cop": Big.new(30), "stone": Big.new(30)},
		{"Task Board": gv.sprite["copy"]},
		{"GRINDER purchased": Ob.Num.new()},
		{texture = gv.sprite["s1n"], key = "s1n"},
		r_lored_color("s1n")
	),
	
	"Tasks!": taq.Task.new(
		"Tasks!",
		"Tasks are random, mini-quests. They can help you out of a tough spot, or to more quickly purchase what you want!",
		{},
		{"Max tasks +1": gv.sprite["copy"]},
		{"Tasks completed": Ob.Num.new(3)},
		{texture = gv.sprite["copy"], key = "copy"},
		r_lored_color("copy")
	),
	
	"Pretty Wet": taq.Task.new(
		"Pretty Wet",
		"",
		{"iron": Big.new(100), "cop": Big.new(100)},
		{"New LORED: Growth": gv.sprite["growth"]},
		{"Stone produced": Ob.Num.new(1000.0)},
		{texture = gv.sprite["growth"], key = "growth"},
		r_lored_color("growth")
	),
	"Progress": taq.Task.new(
		"Progress",
		"",
		{"stone": Big.new(100)},
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
		{"Malignant Upgrade Menu": gv.sprite["s1m"]},
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
		{"steel": Big.new(50), "hard": Big.new(50), "wire": Big.new(50), "glass": Big.new(50)},
		{"New LORED: Tumors": gv.sprite["tum"], "Extra-normal Upgrade Menu": gv.sprite["s2n"]},
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
		{"Radiative Upgrade Menu": gv.sprite["s2m"]},
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

var tip := {}

var task_awaiting := "no"




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
			gv.menu.option["status_color"] = false
			gv.menu.option["flying_numbers"] = true
			gv.menu.option["crits_only"] = false
			gv.menu.option["animations"] = true
			gv.menu.option["tooltip_halt"] = true
			gv.menu.option["tooltip_hold"] = true
			gv.menu.option["tooltip_fuel"] = true
			gv.menu.option["tooltip_autobuyer"] = true
			gv.menu.option["tooltip_cost_only"] = false
			gv.menu.option["on_save_halt"] = false
			gv.menu.option["on_save_hold"] = false
			gv.menu.option["im_ss_show_hint"] = true
			gv.menu.option["task auto"] = false
			gv.menu.option["performance"] = true
			
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
			
			for x in 4:
				gv.menu.tabs_unlocked[str(x + 1)] = false
			
			var stages = gv.menu.tabs_unlocked.keys()
			
			for x in stages:
				
				for v in 2:
					
					var key = "s" + x + "%s"
					
					if v == 0:
						key = key % "n"
					elif v == 1:
						key = key % "m"
					
					gv.menu.tabs_unlocked[key] = false
					gv.menu.upgrades_owned[key] = 0
			
			gv.stats = Statistics.new(gv.g.keys())
			
			gv.stats.up_list["s1"] = []
			gv.stats.up_list["s2"] = []
			gv.stats.up_list["s3"] = []
			gv.stats.up_list["s4"] = []
			
			gv.stats.up_list["main lists"] = ["s1n", "s1m", "s2n","s2m","s3n","s3m","s4n","s4m"]
			
			for x in gv.stats.up_list["main lists"]:
				gv.stats.up_list[x] = []
			
			
			for x in gv.up:
				
				if not "reset" in gv.up[x].type:
					gv.stats.up_list["s" + gv.up[x].type[1]].append(x)
					if gv.up[x].normal:
						gv.stats.up_list["s" + gv.up[x].type[1] + "n"].append(x)
					else:
						gv.stats.up_list["s" + gv.up[x].type[1] + "m"].append(x)
				
				gv.up[x].name = x
				gv.up[x].color = r_lored_color(gv.up[x].main_lored_target)
				
				var uplistkey = gv.up[x].type.split(" ", true, 1)[1]
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
		
		_ready_define_loreds(0)
		_ready_define_upgrades()
		
		for x in gv.g:
			gv.stats.g_list["s" + gv.g[x].type[1]].append(x)
		
		w_aa()
		get_node(gnLOREDs).setup()
		get_node("m/v/top/h/resources").setup()
		
		get_tree().get_root().connect("size_changed", self, "r_window_size_changed")
	
	# game start:
	if true:
		
		if hax == 2:
			return
		
		game_start(e_load())

func game_start(successful_load: bool) -> void:
	
	#gv.menu.option["task auto"] = false
	
	if not successful_load:
		gv.g["stone"].r = Big.new(5)
		get_node("m/Patch Notes").hide()
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
			
			for x in gv.up:
				
				for v in gv.stats.up_list["autoup"]:
					
					if gv.up[v].benefactor_of[0] == "seed" and gv.up[x].main_lored_target == "abeewithdaggers":
						
						gv.up[x].autobuyer_key = v
						break
					
					if not gv.up[v].benefactor_of[0] == gv.up[x].main_lored_target:
						if gv.up[x].type.split(" ", true, 1)[0] == gv.up[v].benefactor_of[0]:
							gv.up[x].autobuyer_key = v
							break
						continue
					
					gv.up[x].autobuyer_key = v
					break
			
			w_task_progress_check()
		
		
		# loreds
		if true:
			
			for x in gv.g:
				
				gv.stats.g_list["s" + gv.g[x].type[1]].append(x)
				
				get_node(gnLOREDs).cont[x].r_update_halt(gv.g[x].halt)
				get_node(gnLOREDs).cont[x].r_update_hold(gv.g[x].hold)
				
				for v in gv.up:
					
					# catches
					if gv.up[v].benefactor_of.size() == 0: continue
					if "autoup" in gv.up[v].type: continue
					if "cremover" in gv.up[v].type: continue
					
					var list_type = gv.up[v].type.split(" ")[1] + " list"
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
			
			for g in gv.g:
				for u in gv.stats.up_list["autob"]:
					if not g == gv.up[u].main_lored_target:
						continue
					gv.g[g].autobuyer_key = u
					break
		
		w_aa()
	
	# ref
	if true:
		
		# lored
		if true:
			
			for x in gv.g:
				
				gv.emit_signal("lored_updated", x, "d")
			
			get_node(gnLOREDs).r_autobuy()
		
		# menu and tab shit
		if true:
			
			menu_window = prefab["menu"].instance()
			$misc.add_child(menu_window)
			menu_window.init(gv.menu.option)
		
		# b_upgrade_tab
		if true:
			
			get_node(gnupcon).init()
		
		w_task_effects()
		
		remove_surplus_tasks()
		
		# map
		$map.init()
	
	# hax
	if true:
		
		if gv.s3_time:
			unlock_tab("1")
			unlock_tab("3")
		pass
	
	# tasks
	if true:
		
		if not get_node(gnLOREDs).cont["water"].visible and quests["A New Leaf"].complete:
			get_node(gnLOREDs).cont["water"].show()
			get_node(gnLOREDs).cont["seed"].show()
			get_node(gnLOREDs).cont["tree"].show()
		
		if quests["Spread"].complete and not quests["Consume"].complete:
			if gv.g["malig"].r.isLessThan(10) and not gv.g["tar"].active:
				gv.g["malig"].r = Big.new(10)
		
		for x in quests:
			
			if taq.cur_quest != "":
				break
			
			if quests[x].complete:
				print(x, " complete")
				continue
			
			taq.new_quest(quests[x])
			print("visible")
			get_node(gnquest).show()
			break
		
		if taq.cur_quest == "":
			get_node(gnquest).hide()
		
		if "tasks" in content_tasks.keys():
			content_tasks["tasks"].hit_max_tasks()
	
	if hax == 1:
		pass

func _ready_define_loreds(reset_type : int):
	
	for x in gv.g:
		
		if not reset_type == 0:
			if reset_type < int(gv.g[x].type[1]): continue
		
		
		if x in DEFAULT_KEY_LOREDS:
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
			afford()

func _input(ev):
	
	if ev.is_class("InputEventMouseMotion"):
		return
	
	if ev.is_action_pressed("ui_cancel"):
		b_tabkey(KEY_ESCAPE)
		return
	
	if Input.is_key_pressed(KEY_1):
		b_tabkey(KEY_1)
		return
	
	if Input.is_key_pressed(KEY_2):
		b_tabkey(KEY_2)
		return
	
	if Input.is_key_pressed(KEY_3):
		b_tabkey(KEY_3)
		return
	
	if Input.is_key_pressed(KEY_4):
		b_tabkey(KEY_4)
		return
	
	
	if ev.is_action_pressed("ui_upgrade_menu"):
		
		if get_node(gnupcon).visible:
			
			if get_node(gnupcon).get_node("v").visible:
				get_node("global_tip")._call("no")
				get_node(gnupcon).go_back()
			else:
				get_node(gnupcon).hide()
				
			
			return
		
		else:
			show_alert_guy(false)
			get_node(gnupcon).show()
			return
	
	
	
	if Input.is_key_pressed(KEY_Q):
		b_tabkey(KEY_Q)
		return

	if Input.is_key_pressed(KEY_W):
		b_tabkey(KEY_W)
		return

	if Input.is_key_pressed(KEY_E):
		b_tabkey(KEY_E)
		return

	if Input.is_key_pressed(KEY_R):
		b_tabkey(KEY_R)
		return
	
	if Input.is_key_pressed(KEY_KP_ENTER) or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_ENTER):
		
		if not "tasks" in content_tasks.keys():
			return
		
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

func _on_upgrades_pressed() -> void:
	
	# duplicate code, also found under _input -> ui_upgrades or whatever
	
	if get_node(gnupcon).visible:
		
		get_node(gnupcon).go_back()
		get_node(gnupcon).hide()
		
		return
	
	get_node(gnupcon).show()
	get_node(gnalert).hide()


func _on_s1_pressed() -> void:
	b_tabkey(KEY_1)

func _on_s2_pressed() -> void:
	b_tabkey(KEY_2)


# working funcs
func w_aa():
	for x in gv.g:
		gv.g[x].sync()


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
			
			var fuel_gain = Big.new(gv.g[x].fc.t)
			fuel_gain.m(clock_dif).m(60)
			
			gv.g[x].f.f = Big.new(Big.min(Big.new(gv.g[x].f.f).a(fuel_gain), gv.g[x].f.t))
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
			
			
			var uh = Big.new(gained[x].percent(consumed[x])).d(num_of_consumers[x])
			
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
			
			print(x, " consumed x", consumed_reduction[x].toString(), " :: ", consumed[x].toString(), " -> ", Big.new(consumed[x]).m(consumed_reduction[x]).toString())
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
		
		
		if consumed[x].isLargerThan(gained[x]):
			consumed[x].s(gained[x])
			if consumed[x].isLargerThan(gv.g[x].r):
				gv.g[x].r = Big.new(0)
			else:
				gv.g[x].r.s(consumed[x])
				gv.emit_signal("lored_updated", x, "amount")
			print(x, ": -", consumed[x].toString(), " (", gained[x].toString(), " gained, ", consumed[x].toString(), " drained)")
		else:
			gained[x].s(consumed[x])
			print(x, ": +", consumed[x].toString(), " (", gained[x].toString(), " gained, ", consumed[x].toString(), " drained)")
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


func afford():
	
	afford_check_fps = 0
	
	if not gv.up["we were so close, now you don't even think about me"].active():
		for x in gv.stats.up_list["s1"]:
			afford_check(x)
	
	if gv.menu.tabs_unlocked["2"]:
		for x in gv.stats.up_list["s2"]:
			afford_check(x)



func afford_check(x: String):
	
	if not gv.up[x].normal:
		return
	
	if gv.up[x].have:
		get_node(gnupcon).alert(false, x)
		return
	
	if not gv.up[x].requires == "":
		if not gv.up[gv.up[x].requires].have:
			return
	
	# upgrade will be bought by its autobuyer
	if gv.up[x].autobuyer_key in gv.up.keys():
		if gv.up[gv.up[x].autobuyer_key].active():
			return
	
	if not gv.up[x].cost_check():
		#if get_node(gnupcon).cont[x].already_displayed_alert_guy:
			#get_node(gnupcon).cont[x].already_displayed_alert_guy = false
		get_node(gnupcon).alert(false, x)
		return
	
	if get_node(gnupcon).cont[x].already_displayed_alert_guy:
		return
	
	# pass!
	
	show_alert_guy()
	#get_node(gnupcon).cont[x].already_displayed_alert_guy = true
	get_node(gnupcon).alert(true, x)

func show_alert_guy(show := true):
	
	if show:
		if get_node(gnupcon).visible:
			return
	
	get_node(gnalert).visible = show

func w_name_to_short(f: String) -> String:
	for x in gv.g:
		if gv.g[x].name == f:
			return x
	return "Did not send a proper name to w_name_to_short() in _Root.gd"
	
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
		for x in quests:
			which.append(x)
	
	for x in which:
		
		if not quests[x].complete:
			continue
		if quests[x].effect_loaded:
			print("effect loaded", x)
			continue
		quests[x].effect_loaded = true
		
		for v in quests[x].reward:
			if not "New LORED: " in v:
				continue
			var key = w_name_to_short(v.split("New LORED: ")[1])
			gv.g[key].unlocked = true
			get_node(gnLOREDs).cont[key].show()
		
		if "Max tasks +1" in quests[x].reward.keys():
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
			"Upgrades!":
				if not "tasks" in content_tasks.keys():
					var _tasks := []
					for v in taq.task:
						_tasks.append(taq.task[v])
					content_tasks["tasks"] = prefab.tasks.instance()
					get_node(gntaq).add_child(content_tasks["tasks"])
					get_node(gntaq).move_child(get_node(gnquest), 2)
					content_tasks["tasks"].init(_tasks)
			"A New Leaf":
				unlock_tab("1")
				unlock_tab("2")
				get_node("misc/menu").w_display_run(quests[x].complete)
			"Welcome to LORED":
				unlock_tab("s1n")
			"Consume":
				unlock_tab("s1m")
			"The Heart of Things":
				gv.g["tum"].unlocked = true
				if gv.up["I know what I'm doing, unlock this shit"].active():
					unlock_tab("s2n")
				else:
					if get_node(gnLOREDs).cont["seed"].b_ubu_s2n_check():
						unlock_tab("s2n")
			"Cancer Lord":
				unlock_tab("s2m")



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




func remove_surplus_tasks():
	
	if taq.cur_tasks <= taq.max_tasks:
		return
	
	print(taq.cur_tasks, " tasks; the maximum is ", taq.max_tasks, ". Deleting some.")
	
	for x in content_tasks["tasks"].content.keys():
		
		if taq.cur_tasks == taq.max_tasks:
			break
		content_tasks["tasks"].content[x].kill_yourself()


func activate_lb_effects():
	
	if gv.up["Limit Break"].active():
		
		if not "1" in gv.overcharge_list:
			gv.overcharge_list.append("1")
			gv.overcharge_list.append("2")
			get_node(gnLB).r_limit_break()
			get_node(gnLB).r_set_colors()
			get_node(gnLB).show()
	
	else:
		
		if "1" in gv.overcharge_list:
			gv.overcharge_list.erase("1")
			gv.overcharge_list.erase("2")
		
		get_node(gnLB).hide()


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

func r_window_size_changed() -> void:
	
	var win :Vector2= get_viewport_rect().size
	var node = 0
	
	get_node("m").rect_size = win
	
	get_node(gnupcon).get_node("v/upgrades").scroll_vertical = 0
	
	# menu
	if true:
		node = menu_window.get_node("ScrollContainer")
		menu_window.position = Vector2(int(win.x / 2 - node.rect_size.x / 2), int(win.y / 2 - node.rect_size.y / 2))
		$map.pos["menu"] = menu_window.position





func reset(reset_type: int, manual := true) -> void:
	
	reset_stats(reset_type)
	reset_upgrades(reset_type, manual)
	reset_resources(reset_type)
	# did not re-write anything below this line for this new reset func
	reset_loreds(reset_type)
	reset_tasks(reset_type)
	reset_limit_break(reset_type)
	
	# ref
	if true:
		
		if reset_type == 0:
			unlock_tab("1", false)
			unlock_tab("2", false)
			unlock_tab("3", false)
			unlock_tab("4", false)
			unlock_tab("s1n", false)
			unlock_tab("s1m", false)
			unlock_tab("s2n", false)
			unlock_tab("s2m", false)
			get_node(gnupcon).clear_alerts()
		
		if reset_type >= 2:
			if not gv.up["I know what I'm doing, unlock this shit"].active():
				unlock_tab("s2n", false)
			else:
				if not gv.menu.tabs_unlocked["s2n"]:
					unlock_tab("s2n", true)
	
	if manual:
		b_tabkey(KEY_1)
	
	gv.menu.f = "ye"
	
	get_node(gnupcon).sync()
	
	if reset_type == 0:
		get_tree().reload_current_scene()
		

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
		
		if gv.stats.most_resources_gained.isLessThan(gv.stats.r_gained[gg]):
			gv.stats.most_resources_gained = Big.new(gv.stats.r_gained[gg])
			print("new highest resources gained: ", gv.stats.most_resources_gained.toString(), " (", gg, ")")
	
	for x in reset_type:
		
		gv.stats.run[x] += 1
		gv.stats.last_run_dur[x] = OS.get_unix_time() - gv.stats.last_reset_clock[x]
		gv.stats.last_reset_clock[x] = OS.get_unix_time()

func reset_upgrades(reset_type: int, manual: bool):
	
	gv.up["I DRINK YOUR MILKSHAKE"].set_d.b = Big.new()
	
	# full reset
	if reset_type == 0:
		
		for x in $map/upgrades.own_list_good:
			$map/upgrades.own_list_good[x] = false
		
		for x in gv.up:
			
			gv.up[x].refundable = false
			
			if not gv.up[x].have:
				continue
			
			gv.up[x].have = false
			gv.up[x].active = true
			
			gv.up[x].sync()
			
			if x == "I DRINK YOUR MILKSHAKE":
				gv.up["I DRINK YOUR MILKSHAKE"].set_d.b = Big.new()
			
			get_node(gnupcon).cont[x].r_update()
		
		# sync again just in case?
		for x in gv.up:
			gv.up[x].sync()
		
		# upgrade tabs are locked in the reset func
		
		return
	
	# for s2 upgrade autobuyers; won't buy if loreds in own_list aren't owned
	for x in $map/upgrades.own_list_good:
		if x >= reset_type:
			continue
		$map/upgrades.own_list_good[x] = false
	
	# routine reset; don't reset every upgrade
	
	if reset_type >= 1:
		for x in gv.stats.up_list["s1"]:
			reset_upgrade(x, reset_type)
			
	if reset_type >= 2:
		for x in gv.stats.up_list["s2"]:
			reset_upgrade(x, reset_type)

func reset_upgrade(x: String, reset_type: int):
	
	# make refundable upgrade owned
	if gv.up[x].refundable and str(reset_type) == gv.up[x].type[1]:
		
		if not gv.up[x].normal:
			gv.menu.upgrades_owned[gv.up[x].type.split(" ", true, 1)[0]] += 1
		gv.up[x].refundable = false
		gv.up[x].have = true
		
		get_node(gnupcon).cont[x].upgrade_effects(true, true)
		
		# quest stuff
		if taq.cur_quest != "":
			for t in taq.quest.step:
				if x in t:
					taq.quest.step[t].f = Big.new()
		
		get_node(gnupcon).cont[x].r_update()
		return
	
	# catches
	if true:
		
		if not gv.up[x].have:
			return
		
		# if s2 reset, will not reset s2m. if s3, will reset s2m, wont reset s3m
		if int(gv.up[x].type[1]) == reset_type and not gv.up[x].normal:
			return
		
		# radiative -> malig
		if reset_type == 2:
			
			if x in ["MOUND", "SIDIUS IRON"] and (gv.up["AUTO-PERSIST"].refundable or gv.up["AUTO-PERSIST"].have):
				return
			if (x == "SLAPAPOW!" or x == "SENTIENT DERRICK") and (gv.up["Mad Science"].refundable or gv.up["Mad Science"].have):
				return
			if (x == "CANKERITE" or x == "wtf is that musk") and (gv.up["Jasmine"].refundable or gv.up["Jasmine"].have):
				return
			if (x == "MOIST" or x == "pippenpaddle- oppsoCOPolis") and (gv.up["UNIONIZE"].refundable or gv.up["UNIONIZE"].have):
				return
			if (x == "AUTOPOLICE" or x == "AUTOSTONER") and (gv.up["CARAVAN"].refundable or gv.up["CARAVAN"].have):
				return
			if (x == "OREOREUHBor E ALICE" or x == "AUTOSHOVELER") and (gv.up["Combo Breaker"].refundable or gv.up["Combo Breaker"].have):
				return
		
		if reset_type == 1 and "s1n" in gv.up[x].type:
			
			var s1sec_half := "INJECT CHEEKS RED GOOPY BOY SWIRLER GEARED OILS STICKYTAR GOOF LOPS C GOOF LOPS I SHMOOF SHMOPS NOOF BLOPS STICKY ICKY T STICKY ICKY M WATT? MAXER MIXER SLIMER SLOP "
			var s1first_half := "MUD THYME PEPPER GARLIC TEXAS RYE ANCHOVE COVE GROUNDER GRANDMA GRANDPA GRANDER GRINDER ORE ASSIST I ORE ASSIST C SAND SALT SAALNDT LIGHTER SHOVEL FLANK RIB "
			
			if x + " " in s1first_half:
				if gv.up["CHUNKUS"].refundable or gv.up["CHUNKUS"].active():
					return
			if x + " " in s1sec_half:
				if gv.up["DUNKUS"].refundable or gv.up["DUNKUS"].active():
					return
	
	# reset every other upgrade:
	
	gv.up[x].have = false
	gv.up[x].active = true
	
	get_node(gnupcon).cont[x].r_update()
	
	w_distribute_upgrade_buff(x)
	
	# syncs this upgrade
	get_node(gnupcon).cont[x].upgrade_effects(false, false)
	
	# ref
	get_node(gnupcon).cont[x].r_update()
	gv.menu.upgrades_owned[gv.up[x].type.split(" ", true, 1)[0]] -= 1

func reset_resources(reset_type: int):
	
	if reset_type == 0:
		
		for x in gv.g:
			
			gv.g[x].r = Big.new(0)
			gv.emit_signal("lored_updated", x, "amount")
		
		return
	
	
	if reset_type >= 1 and not gv.up["CONDUCT"].active():
		
		for x in gv.stats.g_list["s1"]:
			
			if x == "malig" and reset_type == 1:
				continue
			
			gv.g[x].r = Big.new(0)
		
		gv.g["stone"].r.a(5.0)
		if not reset_type == 0:
			gv.g["iron"].r.a(10.0)
			gv.g["cop"].r.a(10.0)
			gv.g["malig"].r = Big.new(Big.max(gv.g["malig"].r, 10))
		if gv.up["FOOD TRUCKS"].active():
			gv.g["cop"].r.a(100.0)
			gv.g["iron"].r.a(100.0)
	
	if reset_type >= 2:
		
		for x in gv.stats.g_list["s2"]:
			
			if x == "tum" and reset_type == 2:
				continue
			
			gv.g[x].r = Big.new(0)
	
		gv.g["wood"].r.a(100)
		gv.g["soil"].r.a(40)
		gv.g["tree"].r.a(5)
		gv.g["steel"].r.a(85)
		gv.g["hard"].r.a(150)
		gv.g["wire"].r.a(90)
		gv.g["glass"].r.a(80)
		
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
			for x in gv.stats.g_list["s2"]:
				gv.g[x].r.a(10000)

func reset_loreds(reset_type: int):
	
	if (reset_type == 1 and not gv.up["dust"].active()) or reset_type != 1:
		
		_ready_define_loreds(reset_type)
		
		for x in gv.g:
			
			if reset_type > 0 and int(gv.g[x].type[1]) > reset_type:
				continue
			
			if reset_type == 0:
				if not (x == "coal" or x == "stone"):
					get_node(gnLOREDs).cont[x].hide()
			get_node(gnLOREDs).cont[x].get_node("h/h/animation/AnimatedSprite").animation = "ww"
			get_node(gnLOREDs).cont[x].get_node("h/h/animation/AnimatedSprite").playing = true
			gv.g[x].inhand = Big.new(0)
			gv.g[x].progress.f = Big.new(0)
			gv.g[x].progress.b = Big.new()
			gv.g[x].halt = false
			gv.g[x].hold = false
			if x == "coal" and gv.up["aw <3"].active() and not 0 == reset_type:
				gv.g[x].active = true
				gv.g[x].increase_cost()
				if gv.menu.option["animations"]:
					get_node(gnLOREDs).cont[x].get_node(get_node(gnLOREDs).cont[x].gnframes).animation = "ff"
			
			gv.g[x].sync()
			
			gv.emit_signal("lored_updated", x, "net")
		
		get_node(gnLOREDs).r_autobuy()
		
		for x in gv.stats.up_list["cremover"]:
			if not gv.up[x].have:
				continue
			if not gv.up[x].benefactor_of[0].split(" ")[1] in gv.g[gv.up[x].benefactor_of[0].split(" ")[0]].cost.keys(): continue
			gv.g[gv.up[x].benefactor_of[0].split(" ")[0]].cost.erase(gv.up[x].benefactor_of[0].split(" ")[1])
	
	else:
		
		for x in ["iron", "irono", "copo", "cop"]:
			gv.g[x].modifier_from_growin_on_me = Big.new(1)

func reset_tasks(reset_type: int):
	
	if reset_type == 0:
		
		for t in quests:
			quests[t].reset()
		
		
		var list = []
		for x in taq.task:
			list.append(x)
		
		taq.max_tasks = 1
		taq.cur_quest = ""
		
		if not "tasks" in content_tasks.keys():
			return
		
		for x in list:
			content_tasks["tasks"].content[x].kill_yourself()
		
		content_tasks["tasks"].ready_task_count = 0
		content_tasks["tasks"].queue_free()
		content_tasks.erase("tasks")
		
		return
	
	var list = []
	for x in taq.task:
		if int(gv.g[taq.task[x].icon.key].type[1]) > reset_type:
			continue
		if "{Spike}" in taq.task[x].name:
			continue
		list.append(x)
	
	for x in list:
		content_tasks["tasks"].content[x].kill_yourself()
		var bla = content_tasks["tasks"].ready_task_count
		content_tasks["tasks"].ready_task_count = max(0, bla - 1)
	
	content_tasks["tasks"].hit_max_tasks()

func reset_limit_break(reset_type: int):
	
	if reset_type == 0:
		
		gv.reset_lb()
		
		activate_lb_effects()
		
		return
	
	gv.up["Limit Break"].sync()




# buttons
func _clear_content():
	for x in content:
		if not is_instance_valid(content[x]): continue
		content[x].queue_free()
	content.clear()




func b_tabkey(key):
	
	$global_tip._call("no")
	
	match key:
		
		KEY_ESCAPE:
			
			if get_node(gnupcon).visible:
				
				if get_node(gnupcon).get_node("v").visible:
					get_node(gnupcon).go_back()
				
				get_node(gnupcon).hide()
				
				return
			
			# open the menu
			if not $misc/menu.visible:
				$misc/menu.show()
				return
			
			# close the menu (should probably stay at the bottom. if must move above something, make this func return a bool. if return g.visible = true, then RETURN below the func)
			b_close_menu()
		
		KEY_1:
			switch_tabs("s1")
		
		KEY_2:
			switch_tabs("s2")
		
		KEY_3:
			switch_tabs("s3")
		
		KEY_4:
			switch_tabs("s4")
		
		KEY_Q:
			open_up_tab("s1n")
		
		KEY_W:
			open_up_tab("s1m")
		
		KEY_E:
			open_up_tab("s2n")
		
		KEY_R:
			open_up_tab("s2m")

func switch_tabs(target: String):
	
	if not gv.menu.tabs_unlocked[target[1]]:
		return
	
	var int_tab = int(gv.menu.tab) - 1
	gv.menu.tab_vertical[int_tab] = get_node(gnLOREDs + "/sc").scroll_vertical
	
	gv.menu.tab = target[1] # "2"
	get_node("m/v/top/h/resources").switch_tabs(target[1])
	get_node(gnupcon).hide()
	
	for x in get_node(gnLOREDs + "/sc/v").get_children():
		if x.name in target:
			x.show()
		else:
			x.hide()
	
	var t = Timer.new()
	t.set_wait_time(0.005)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	int_tab = int(gv.menu.tab) - 1
	get_node(gnLOREDs + "/sc").scroll_vertical = gv.menu.tab_vertical[int_tab]

func open_up_tab(target: String):
	
	if not gv.menu.tabs_unlocked[target]:
		return
	
	get_node(gnupcon).col_time(target)
	
	b_close_menu()
	show_alert_guy(false)
	get_node("global_tip")._call("no")

func b_close_menu() -> void:
	$misc/menu.hide()
func b_move_map(x, y):

	$map.status = "no"
	$map.set_global_position(Vector2(x, y))


func unlock_tab(which: String, unlock := true):
	
	gv.menu.tabs_unlocked[which] = unlock
	
	if "s" in which:
		get_node(gnupcon).get_node("top/" + which).visible = unlock
	
	if which == "s1n":
		get_node("misc/tabs/v/upgrades").visible = unlock
	elif which.length() == 1:
		get_node("misc/tabs/v/s" + which).visible = gv.menu.tabs_unlocked[which]


func e_save(type := "normal", path := SAVE.MAIN):
	
	var save := _save.new()
	
	# menu and stats
	if true:
		
		save.game_version = ProjectSettings.get_setting("application/config/Version")
		
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
			if not gv.up[x].normal and gv.up[x].refundable:
				ref[0].a(gv.up[x].cost.values()[0].t)
		save.data["ref_0"] = ref[0].toScientific()
		save.data["ref_1"] = ref[1].toScientific()
		
		for x in gv.stats.last_reset_clock.size():
			save.data["save last reset clock " + String(x)] = gv.stats.last_reset_clock[x]
	
	# tasks
	if true:
		
		for x in quests:
			save.data["task " + x + " complete"] = quests[x].complete
		
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
		
		if gv.up["Limit Break"].active():
			save.data["Limit Break d"] = gv.lb_d.toScientific()
			save.data["Limit Break xpf"] = gv.lb_xp.f.toScientific()
			save.data["Limit Break xpt"] = gv.lb_xp.t.toScientific()
		
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
		
		if not save_file.file_exists(path):
			return false
		
		# load from base64
		save_file.open(path, File.READ)
		
		save.game_version = save_file.get_line()
		
		# sub version
		save.data = Marshalls.base64_to_variant(save_file.get_line())
		
		save_file.close()
		
		break
	
	get_node(gn_patch).setup(save.game_version)
	
	if not "2" in save.game_version[0]:
		print("Save from 1.2c or earlier--what the heck, have you really not played since then? Welcome back, jeez!")
		return false
	
	var pre_beta_4 := false
	if "(" in save.game_version:
		var beta_version = save.game_version.split("(")[1].split(")")[0]
		if int(beta_version) <= 3:
			pre_beta_4 = true
	
	var keys = save.data.keys()
	
	load_stats(save.data, keys, pre_beta_4)
	load_upgrades(save.data, keys, pre_beta_4)
	load_loreds(save.data, keys, pre_beta_4)
	load_tasks(save.data, keys, pre_beta_4)
	
	# shit that needs to be done before offline earnings
	if true:
		
		# limit break
		if true:
			
			activate_lb_effects()
	
	# offline earnings
	if true:
		
		var clock_dif = cur_clock - save.data["cur_clock"] - 10
		if clock_dif > 0:
			w_total_per_sec(clock_dif)
	
	# fin & misc
	if true:
		
		if quests["Pretty Wet"].complete:
			var butt = ["Intro!", "More Intro!", "Welcome to LORED", "Upgrades!", "Tasks!"]
			for x in butt:
				quests[x].complete = true
	
	return true

func load_stats(data: Dictionary, keys: Array, pre_beta_4: bool):
	
	for x in gv.stats.run.size():
		if "gv.stats.run[" + str(x) + "]" in keys:
			gv.stats.run[x] = data["gv.stats.run[" + str(x) + "]"]
		if "stats.last_run_dur[" + str(x) + "]" in keys:
			gv.stats.last_run_dur[x] = data["stats.last_run_dur[" + str(x) + "]"]
		if "stats.last_reset_clock[" + str(x) + "]" in keys:
			gv.stats.last_reset_clock[x] = data["stats.last_reset_clock[" + str(x) + "]"]
	times_game_loaded = data["times game loaded"] + 1
	
	for x in gv.menu.option:
		
		if not "option " + x in keys: continue
		if PLATFORM == "browser" and x == "performance": continue
		
		gv.menu.option[x] = data["option " + x]
		if x == "on_save_menu_options" and not gv.menu.option[x]: break
	
	gv.stats.time_played = data["time_played"]
	gv.stats.tasks_completed = data["tasks_completed"]
	
	if "stats.highest_run" in keys:
		gv.stats.highest_run = data["stats.highest_run"]
	
	for x in gv.stats.last_reset_clock.size():
		if not ("save last reset clock " + str(x)) in keys: continue
		gv.stats.last_reset_clock[x] = data["save last reset clock " + str(x)]
	
	
	
	if pre_beta_4:
		
		for x in gv.stats.r_gained:
			if not "r_gained" + x in keys:
				continue
			gv.stats.r_gained[x] = Big.new(fval.f(data["r_gained " + x]))
		
		if "most_resources_gained" in keys:
			gv.stats.most_resources_gained = Big.new(fval.f(data["most_resources_gained"]))
		
		return
	
	
	
	for x in gv.stats.r_gained:
		if not "r_gained" + x in keys:
			continue
		gv.stats.r_gained[x] = Big.new(data["r_gained " + x])
	
	if "most_resources_gained" in keys:
		gv.stats.most_resources_gained = Big.new(data["most_resources_gained"])

func load_upgrades(data: Dictionary, keys: Array, pre_beta_4: bool):
	
	if "Limit Break d" in keys:
		gv.lb_d = Big.new(data["Limit Break d"])
		gv.lb_xp.t = Big.new(data["Limit Break xpt"])
		gv.lb_xp.f = Big.new(data["Limit Break xpf"])
		emit_signal("limit_break_leveled_up", "color")
	
	if "[I DRINK YOUR MILKSHAKE] d" in keys:
		if pre_beta_4:
			gv.up["I DRINK YOUR MILKSHAKE"].set_d.b = Big.new(fval.f(data["[I DRINK YOUR MILKSHAKE] d"]))
		else:
			gv.up["I DRINK YOUR MILKSHAKE"].set_d.b = Big.new(data["[I DRINK YOUR MILKSHAKE] d"])
	
	if "[IT'S GROWIN ON ME] d" in keys:
		if pre_beta_4:
			gv.up["IT'S GROWIN ON ME"].set_d.b = Big.new(fval.f(data["[IT'S GROWIN ON ME] d"]))
		else:
			gv.up["IT'S GROWIN ON ME"].set_d.b = Big.new(data["[IT'S GROWIN ON ME] d"])
	
	for x in gv.up:
		
		if not "[" + x + "] have" in keys: continue
		
		gv.up[x].have = data["[" + x + "] have"]
		gv.up[x].active = data["[" + x + "] active"]
		gv.up[x].refundable = data["[" + x + "] refundable"]
		if "[" + x + "] times_purchased" in keys:
			gv.up[x].times_purchased = data["[" + x + "] times_purchased"]
		if "[" + x + "] unlocked" in keys:
			gv.up[x].unlocked = data["[" + x + "] unlocked"]
		
		if not gv.up[x].refundable:
			continue
		
		gv.up[x].refundable = false
		
		gv.up[x].sync()
		
		for c in gv.up[x].cost:
			gv.g[c].r.a(gv.up[x].cost[c].t)
			gv.emit_signal("lored_updated", c, "amount")
	
	for x in gv.up:
		gv.up[x].sync()
		if not gv.up[x].have: continue
		gv.menu.upgrades_owned[gv.up[x].type.split(" ", true, 1)[0]] += 1
	
	for x in gv.stats.up_list:
		if not "benefactor" in x: continue
		for v in gv.stats.up_list[x]:
			w_distribute_upgrade_buff(v)

func load_loreds(data: Dictionary, keys: Array, pre_beta_4: bool):
	
	for x in gv.g:
		
		gv.g[x].active = data["g" + x + " active"]
		gv.g[x].r.a(Big.new(data["g" + x + " r"]))
		if "g" + x + " unlocked" in keys:
			gv.g[x].unlocked = data["g" + x + " unlocked"]
		if "g" + x + " key" in keys:
			gv.g[x].key_lored = data["g" + x + " key"]
		
		if not gv.g[x].active:
			continue
		
		if ("g" + x + " modifier_from_growin_on_me") in keys:
			if pre_beta_4:
				gv.g[x].modifier_from_growin_on_me = Big.new(fval.f(data["g" + x + " modifier_from_growin_on_me"]))
			else:
				gv.g[x].modifier_from_growin_on_me = Big.new(data["g" + x + " modifier_from_growin_on_me"])
		
		gv.g[x].level = data["g" + x + " level"]
		
		if x != "stone":
			gv.g[x].increase_cost()
		
		for v in gv.g[x].level - 1:
			gv.g[x].output_modifier.m(2)
			gv.g[x].fc.b.m(2)
			gv.g[x].f.b.m(2)
			gv.g[x].increase_cost()
		
		if gv.menu.option["on_save_halt"] and "g" + x + " halt" in keys: gv.g[x].halt = data["g" + x + " halt"]
		if gv.menu.option["on_save_hold"] and "g" + x + " hold" in keys: gv.g[x].hold = data["g" + x + " hold"]
		
		gv.g[x].task = data["g" + x + " task"]
		
		if pre_beta_4:
			
			gv.g[x].f.f = Big.new(fval.f(data["g" + x + " fuel"]))
			gv.g[x].progress.f = Big.new(fval.f(data["g" + x + " progress"]))
			gv.g[x].progress.b = Big.new(fval.f(data["g" + x + " progress b"]))
			gv.g[x].inhand = Big.new(fval.f(data["g" + x + " inhand"]))
		
		else:
			
			gv.g[x].f.f = Big.new(data["g" + x + " fuel"])
			gv.g[x].progress.f = Big.new(data["g" + x + " progress"])
			gv.g[x].progress.b = Big.new(data["g" + x + " progress b"])
			gv.g[x].inhand = Big.new(data["g" + x + " inhand"])
		
		if gv.g[x].progress.f.isLargerThan(0) and gv.menu.option["animations"]:
			get_node(gnLOREDs).cont[x].get_node("h/h/animation/AnimatedSprite").animation = "ff"
		
		gv.g[x].sync()

func load_tasks(data: Dictionary, keys: Array, pre_beta_4: bool):
	
	for x in quests:
		if "task " + x + " complete" in keys:
			quests[x].complete = data["task " + x + " complete"]
	
	if "load quest" in keys:
		if data["load quest"]:
			if data["on quest"] in quests.keys():
				taq.new_quest(quests[data["on quest"]])
				for x in taq.quest.step:
					if not "quest step " + x + " f" in keys:
						continue
					
					if pre_beta_4:
						taq.quest.step[x].f = Big.new(fval.f(data["quest step " + x + " f"]))
					else:
						taq.quest.step[x].f = Big.new(data["quest step " + x + " f"])
	
	if "task count" in keys:
		if data["task count"] > 0:
			
			for i in data["task count"]:
				
				if taq.cur_tasks >= taq.max_tasks:
					break
				
				var name = data["task " + str(i) + " name"]
				var desc = data["task " + str(i) + " desc"]
				var icon = {texture = gv.sprite[data["task " + str(i) + " icon"]], key = data["task " + str(i) + " icon"]}
				var steps := {}
				var rr := {}
				var r := {}
				
				for ii in data["task " + str(i) + " steps"]:
					steps[data["task " + str(i) + " step key " + str(ii)]] = Ob.Num.new(data["task " + str(i) + " b " + str(ii)])
					if pre_beta_4:
						steps[data["task " + str(i) + " step key " + str(ii)]].f = Big.new(fval.f(data["task " + str(i) + " f " + str(ii)]))
					else:
						steps[data["task " + str(i) + " step key " + str(ii)]].f = Big.new(data["task " + str(i) + " f " + str(ii)])
				
				for ii in data["task " + str(i) + " rr num"]:
					if pre_beta_4:
						rr[data["task " + str(i) + " rr key " + str(ii)]] = Big.new(fval.f(data["task " + str(i) + " rr " + str(ii)]))
					else:
						rr[data["task " + str(i) + " rr key " + str(ii)]] = Big.new(data["task " + str(i) + " rr " + str(ii)])
				
				for ii in data["task " + str(i) + " r num"]:
					r[data["task " + str(i) + " r key " + str(ii)]] = data["task " + str(i) + " r " + str(ii)]
				
				taq.task[float(i)] = taq.Task.new(name, desc, rr, r, steps, icon, r_lored_color(data["task " + str(i) + " icon"]))
				taq.task[float(i)].code = float(i)



func _on_Button_pressed() -> void:
	#print(gv.r[gv.R.consumed_spirit].toString())
	gv.cac[0].xp.f = Big.new(gv.cac[0].xp.t)
	gv.cac[0].progress.f = gv.cac[0].progress.t
	return
	gv.g["malig"].r.a(1)
	gv.g["malig"].r.m(2)
	gv.g["tum"].r.a(1)
	gv.g["tum"].r.m(2)
	
	pass



