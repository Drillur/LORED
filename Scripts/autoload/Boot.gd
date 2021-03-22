extends Node


func _ready() -> void:
	
	init()
	setup()

func init():
	
	init_loreds()
	init_menu_and_stats()
	init_upgrades()
	init_quests()

func init_loreds():
	
	# stage 3
	
	gv.g["hunt"] = LORED.new("hunt", "Hunt", "s3 water", {}, {}, 1)
	gv.g["blood"] = LORED.new("blood", "Blood", "s3 blood", {}, {}, 1)
	gv.g["necro"] = LORED.new("necro", "Necro", "s3 water", {}, {}, 1)
	gv.g["witch"] = LORED.new("witch", "Witch", "s3 mana", {}, {}, 1)
	
	# stage 2
	
	# main
	gv.g["tum"] = LORED.new("tum", "Tumors", "s2 ele fur ", {"growth": Ob.Num.new(10.0), "malig": Ob.Num.new(5.0), "carc": Ob.Num.new(3.0)}, {"hard" : Ob.Num.new(50.0), "wire" : Ob.Num.new(150.0), "glass": Ob.Num.new(150.0), "steel": Ob.Num.new(100.0)}, 1000.0)
	
	# hardwood
	gv.g["hard"] = LORED.new("hard", "Hardwood", "s2 ele fur ", {"wood": Ob.Num.new(2.0), "conc": Ob.Num.new()}, {"iron" : Ob.Num.new(3500.0), "conc" : Ob.Num.new(350.0), "wire": Ob.Num.new(35.0)}, 275.0)
	gv.g["wood"] = LORED.new("wood", "Wood", "s2 ele fur ", {"axe": Ob.Num.new(0.2), "tree": Ob.Num.new(0.04)}, {"cop" : Ob.Num.new(4500.0), "wire": Ob.Num.new(15.0)}, 300.0, 25.0)
	gv.g["axe"] = LORED.new("axe", "Axes", "s2 ele fur ", {"hard": Ob.Num.new(0.8), "steel": Ob.Num.new(0.25)}, {"iron" : Ob.Num.new(1000.0), "hard": Ob.Num.new(55.0)}, 420.0)
	
	# wire
	gv.g["draw"] = LORED.new("draw", "Draw Plate", "s2 bur fur ", {"steel": Ob.Num.new(0.5)}, {"iron" : Ob.Num.new(900.0), "conc": Ob.Num.new(300.0), "wire": Ob.Num.new(20.0)}, 600.0)
	gv.g["wire"] = LORED.new("wire", "Wire", "s2 ele fur ", {"cop": Ob.Num.new(5.0), "draw": Ob.Num.new(0.4)}, {"stone" : Ob.Num.new(13000.0), "glass": Ob.Num.new(30.0)}, 300.0)
	
	# glass
	gv.g["glass"] = LORED.new("glass", "Glass", "s2 ele fur ", {"sand": Ob.Num.new(6.0)}, {"cop" : Ob.Num.new(6000.0), "steel": Ob.Num.new(40.0)}, 350.0)
	gv.g["sand"] = LORED.new("sand", "Sand", "s2 bur fur ", {"humus": Ob.Num.new(0.6)}, {"iron" : Ob.Num.new(700.0), "cop": Ob.Num.new(2850.0)}, 250.0, 2.5)
	
	# steel
	gv.g["steel"] = LORED.new("steel", "Steel", "s2 ele fur ", {"liq": Ob.Num.new(8.0)}, {"iron" : Ob.Num.new(15000.0), "cop" : Ob.Num.new(3000.0), "hard": Ob.Num.new(35.0)}, 800.0)
	gv.g["liq"] = LORED.new("liq", "Liquid Iron", "s2 ele fur ", {"iron": Ob.Num.new(10.0)}, {"conc": Ob.Num.new(900.0), "steel" : Ob.Num.new(25.0)}, 250.0)
	
	# carc
	gv.g["carc"] = LORED.new("carc", "Carcinogens", "s2 ele fur ", {"malig": Ob.Num.new(3.0), "ciga": Ob.Num.new(6.0), "plast": Ob.Num.new(5.0)}, {"growth": Ob.Num.new(8500.0), "conc": Ob.Num.new(2000.0), "steel": Ob.Num.new(150.0), "lead": Ob.Num.new(800.0)}, 450.0)
	gv.g["plast"] = LORED.new("plast", "Plastic", "s2 ele fur ", {"coal": Ob.Num.new(5.0), "pet": Ob.Num.new()}, {"stone": Ob.Num.new(10000.0), "tar": Ob.Num.new(700.0)}, 375.0)
	gv.g["pet"] = LORED.new("pet", "Petroleum", "s2 bur fur ", {"oil": Ob.Num.new(3.0)}, {"iron": Ob.Num.new(3000.0), "cop" : Ob.Num.new(4000.0), "glass" : Ob.Num.new(130.0)}, 300.0)
	gv.g["ciga"] = LORED.new("ciga", "Cigarettes", "s2 ele fur ", {"tar": Ob.Num.new(4.0), "toba": Ob.Num.new(), "paper": Ob.Num.new(0.25)}, {"hard" : Ob.Num.new(50.0), "wire" : Ob.Num.new(120.0)}, 155.0)
	gv.g["toba"] = LORED.new("toba", "Tobacco", "s2 bur fur ", {"water": Ob.Num.new(2.0), "seed": Ob.Num.new()}, {"soil": Ob.Num.new(3.0), "hard": Ob.Num.new(15.0)}, 500.0)
	gv.g["paper"] = LORED.new("paper", "Paper", "s2 bur fur ", {"pulp": Ob.Num.new(0.6)}, {"conc": Ob.Num.new(1200.0), "steel": Ob.Num.new(15.0)}, 320.0)
	gv.g["pulp"] = LORED.new("pulp", "Wood Pulp", "s2 ele fur ", {"stone": Ob.Num.new(2.0), "wood": Ob.Num.new(1.0)}, {"wire": Ob.Num.new(15.0), "glass": Ob.Num.new(30.0)}, 400.0, 5.0)
	
	gv.g["lead"] = LORED.new("lead", "Lead", "s2 bur fur ", {"gale": Ob.Num.new()}, {"stone": Ob.Num.new(400.0), "growth": Ob.Num.new(800.0)}, 300.0)
	gv.g["gale"] = LORED.new("gale", "Galena", "s2 bur bore ", {}, {"stone": Ob.Num.new(1100.0), "wire": Ob.Num.new(200.0)}, 250.0)
	
	# life
	gv.g["seed"] = LORED.new("seed", "Seeds", "s2 bur fur ", {"water": Ob.Num.new(1.5)}, {"cop": Ob.Num.new(800.0), "tree" : Ob.Num.new(2.0)}, 300.0)
	gv.g["tree"] = LORED.new("tree", "Trees", "s2 ele fur ", {"water": Ob.Num.new(6.0), "seed": Ob.Num.new()}, {"growth": Ob.Num.new(150.0), "soil" : Ob.Num.new(25.0)}, 1200.0)
	gv.g["soil"] = LORED.new("soil", "Soil", "s2 bur fur ", {"humus": Ob.Num.new(1.5)}, {"conc": Ob.Num.new(1000.0), "hard" : Ob.Num.new(40.0)}, 300.0)
	gv.g["humus"] = LORED.new("humus", "Humus", "s2 ele fur ", {"growth": Ob.Num.new(0.5), "water": Ob.Num.new()}, {"iron": Ob.Num.new(600.0), "cop" : Ob.Num.new(600.0), "glass" : Ob.Num.new(30.0)}, 275.0)
	gv.g["water"] = LORED.new("water", "Water", "s2 bur bore ", {}, {"stone": Ob.Num.new(2500.0), "wood" : Ob.Num.new(80.0)}, 200.0)
	
	
	
	# stage 1
	
	gv.g["malig"] = LORED.new("malig", "Malignancy", "s1 ele fur key ", {"growth" : Ob.Num.new(), "tar" : Ob.Num.new()}, {"iron" : Ob.Num.new(900.0), "cop" : Ob.Num.new(900.0), "conc" : Ob.Num.new(50.0)}, 300.0)
	gv.g["tar"] = LORED.new("tar", "Tarballs", "s1 ele fur ", {"growth" : Ob.Num.new(), "oil" : Ob.Num.new()}, {"iron" : Ob.Num.new(350.0), "malig" : Ob.Num.new(10.0)}, 250.0)
	gv.g["oil"] = LORED.new("oil", "Oil", "s1 bur bore ", {}, {"cop" : Ob.Num.new(250.0), "conc" : Ob.Num.new(250.0)}, 30.0, 0.075)
	gv.g["growth"] = LORED.new("growth", "Growth", "s1 ele fur key ", { "iron" : Ob.Num.new(), "cop" : Ob.Num.new()}, { "stone" : Ob.Num.new(900.0) }, 400.0)
	gv.g["conc"] = LORED.new("conc", "Concrete", "s1 bur fur key ", {"stone" : Ob.Num.new()}, {"iron" : Ob.Num.new(90.0), "cop" : Ob.Num.new(150.0)}, 600.0)
	gv.g["jo"] = LORED.new("jo", "Joules", "s1 bur fur ", {"coal" : Ob.Num.new()}, {"conc" : Ob.Num.new(25.0)}, 500.0)
	gv.g["iron"] = LORED.new("iron", "Iron", "s1 bur fur ", { "irono" : Ob.Num.new() }, { "stone" : Ob.Num.new(9.0), "cop" : Ob.Num.new(8.0) }, 300.0)
	gv.g["cop"] = LORED.new("cop", "Copper","s1 bur fur ", { "copo" : Ob.Num.new() }, { "stone" : Ob.Num.new(9.0), "iron" : Ob.Num.new(8.0) }, 300.0)
	gv.g["irono"] = LORED.new("irono", "Iron Ore", "s1 bur bore ", {}, { "stone" : Ob.Num.new(8.0) }, 250.0)
	gv.g["copo"] = LORED.new("copo", "Copper Ore", "s1 bur bore ", {}, { "stone" : Ob.Num.new(8.0) }, 250.0)
	gv.g["coal"] = LORED.new("coal", "Coal", "s1 bur bore ", {}, { "stone" : Ob.Num.new(5.0) }, 200.0)
	gv.g["stone"] = LORED.new("stone", "Stone", "s1 bur bore key ", {}, { "iron" : Ob.Num.new(25.0), "cop" : Ob.Num.new(15.0) }, 150.0)

func init_menu_and_stats():
	
	# menu
	
	gv.menu.option["on_save_menu_options"] = true
	gv.menu.option["FPS"] = 0
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
	gv.menu.option["afford check"] = false
	
	
	
	# stats
	
	gv.stats = Statistics.new(gv.g.keys())
	
	var stages = gv.stats.tabs_unlocked.keys()
	
	for x in stages:
		
		for v in 2:
			
			var key = "s" + x + "%s"
			
			if v == 0:
				key = key % "n"
			elif v == 1:
				key = key % "m"
			
			gv.stats.tabs_unlocked[key] = false
			gv.stats.upgrades_owned[key] = 0
	
	for x in gv.g:
		gv.stats.g_list["s" + gv.g[x].stage].append(x)

func init_upgrades():
	
	var f: String
	
	# upreset
	if true:
		
		# s2m
		if true:
			
			f = "CHEMOTHERAPY"
			gv.up[f] = Upgrade.new(f, "s2m reset", "Resets Normal, Malignant, and Extra-normal upgrades, and Stage 1 and Stage 2 resources (except Tumors).", "tum")
			
			f = "RECOVER"
			gv.up["RECOVER"] = Upgrade.new(f, "s2m reset", "Begin your recovery period. Apply your radiative upgrades to your new life. (Blocks the purchase of Radiative upgrades until your next chemotherapy dose.)")
		
		# s1m
		if true:
			
			f = "METASTASIZE"
			gv.up["METASTASIZE"] = Upgrade.new(f, "s1m reset","Resets Normal upgrades and Stage 1 resources (except Malignancy)", "malig")
			
			f = "SPREAD"
			gv.up[f] = Upgrade.new(f, "s1m reset", "Spread to and apply your malignant upgrades to a new host. (Blocks the purchase of Malignant upgrades until your next Metastasis.)")
	
#	# upunlock
#	if true:
#
#		# s2 unlocking s3
#		f = ""
	
	# re-buyables
	if true:
		
		# s3n
		if true:
			
			f = "Carcinogenesis"
			gv.up[f] = Upgrade.new(f, "s3n rebuy", "Resets Radiative upgrades and then performs Chemotherapy, resetting Stage 1 and Stage 2 LOREDs and resources.\n\nRequires 80 Radiative upgrades.\nGains 1 Embryo.", "tum")
		
	
	# uptasks
	if true:
		
		# blood
		if true:
			
			f = "Incision"
			gv.up[f] = Upgrade.new(f, "s3n task", "The Blood LORED will now sacrifice his own blood.", "tum")
			gv.up[f].effects.append(Effect.new("task", ["blood"], 1, "sacrifice own blood"))
			#gv.up[f].cost["tum"] = Ob.Num.new("1e6")
			#gv.up[f].requires.append("AUTOSENSU")
			
			f = "blood 0"
			gv.chains[f] = UpgradeChain.new("", ["Incision"])
			#gv.chains[f].effects.append(Effect.new("drain", ["blood"], 1.1))
	
	# upauto
	if true:
		
		# s2m
		if true:
			
			# lored
			if true:
				
				f = "Sudden Commission"
				gv.up[f] = Upgrade.new(f, "s2m autob", "literally doesn't fucking matter", "draw")
				gv.up[f].effects.append(Effect.new("autob", ["draw"]))
				gv.up[f].cost["tum"] = Ob.Num.new("1e6") # k
				gv.up[f].requires.append("AUTOSENSU")
				
				f = "AUTOSENSU"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Wood LORED if it won't cause your Axe LORED's net output to drop below 0.", "wood")
				gv.up[f].effects.append(Effect.new("autob", ["wood"]))
				gv.up[f].cost["tum"] = Ob.Num.new(160000) # bil
				gv.up[f].requires.append("AUTOSMITHY")
				
				f = "Master"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Sand LORED if it won't cause your Humus LORED's net output to drop below 0.", "sand")
				gv.up[f].effects.append(Effect.new("autob", ["sand"]))
				gv.up[f].cost["tum"] = Ob.Num.new("1e9") # k
				gv.up[f].requires.append("Sudden Commission")
				
				f = "AXELOT"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Axe LORED if it won't cause your Hardwood LORED's net output to drop below 0.", "axe")
				gv.up[f].effects.append(Effect.new("autob",["axe"]))
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["Master"].cost["tum"].b).m(2 * 5))
				gv.up[f].requires.append("Master")
				
				f = "AUTOSHIT"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Humus LORED if it won't cause your Water LORED's net output to drop below 0.", "humus")
				gv.up[f].effects.append(Effect.new("autob", ["humus"]))
				gv.up[f].requires.append("AXELOT")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2)) # bil
				
				f = "Smashy Crashy"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Tree LORED if its net output is less than 0.", "tree")
				gv.up[f].effects.append(Effect.new("autob", ["tree"]))
				gv.up[f].requires.append("AUTOSHIT")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2)) # bil
				
				f = "A baby Roleum!! Thanks, pa!"
				gv.up[f] = Upgrade.new(f, "s2m autob", "AKJSLHDFKLJHASDFKL", "pet")
				gv.up[f].effects.append(Effect.new("autob", ["pet"]))
				gv.up[f].requires.append("Smashy Crashy")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2)) # bil
				
				f = "poofy wizard boy"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Tobacco LORED if its net output is less than 0.", "toba")
				gv.up[f].effects.append(Effect.new("autob", ["toba"]))
				gv.up[f].requires.append("A baby Roleum!! Thanks, pa!")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2)) # bil
				
				f = "BENEFIT"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Galena LORED.", "gale")
				gv.up[f].effects.append(Effect.new("autob", ["gale"]))
				gv.up[f].requires.append("poofy wizard boy")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "AUTOAQUATICICIDE"
				gv.up[f] = Upgrade.new(f, "s2m autob", "AKJSLHDFKLJHASDFKL", "plast")
				gv.up[f].effects.append(Effect.new("autob", ["plast"]))
				gv.up[f].requires.append("BENEFIT")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "Go on, then, LEAD us!"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Lead LORED if it won't cause your Galena LORED's net output to drop below 0.", "lead")
				gv.up[f].effects.append(Effect.new("autob", ["lead"]))
				gv.up[f].requires.append("AUTOAQUATICICIDE")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "BEEKEEPING"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Seed LORED if its net output is less than 0.", "seed")
				gv.up[f].effects.append(Effect.new("autob", ["seed"]))
				gv.up[f].requires.append("Go on, then, LEAD us!")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "Scoopy Doopy"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Soil LORED if it won't cause your Humus LORED's net output to drop below 0.", "soil")
				gv.up[f].effects.append(Effect.new("autob", ["soil"]))
				gv.up[f].requires.append("BEEKEEPING")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "Master Iron Worker"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Steel LORED if it won't cause your Liquid Iron LORED's net output to drop below 0.", "steel")
				gv.up[f].effects.append(Effect.new("autob", ["steel"]))
				gv.up[f].requires.append("Scoopy Doopy")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "JOINTSHACK"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Paper LORED if its net output is less than 0.", "paper")
				gv.up[f].effects.append(Effect.new("autob", ["paper"]))
				gv.up[f].requires.append("Master Iron Worker")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "AROUSAL"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Hardwood LORED if it won't cause your Wood LORED's net output to drop below 0.", "hard")
				gv.up[f].effects.append(Effect.new("autob", ["hard"]))
				gv.up[f].requires.append("JOINTSHACK")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "autofloof"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Wood Pulp LORED if its net output is less than 0.", "pulp")
				gv.up[f].effects.append(Effect.new("autob", ["pulp"]))
				gv.up[f].requires.append("AROUSAL")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "ELECTRONIC CIRCUITS"
				gv.up[f] = Upgrade.new(f, "s2m autob", "AKJSLHDFKLJHASDFKL", "wire")
				gv.up[f].effects.append(Effect.new("autob", ["wire"]))
				gv.up[f].requires.append("autofloof")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "AUTOBADDECISIONMAKER"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Cigarette LORED if its net output is less than 0.", "ciga")
				gv.up[f].effects.append(Effect.new("autob", ["ciga"]))
				gv.up[f].requires.append("ELECTRONIC CIRCUITS")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "PILLAR OF AUTUMN"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Glass LORED if it won't cause your Sand LORED's net output to drop below 0.", "glass")
				gv.up[f].effects.append(Effect.new("autob", ["glass"]))
				gv.up[f].requires.append("AUTOBADDECISIONMAKER")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(200))
				
				f = "what kind of resource is 'tumors', you hack fraud"
				gv.up[f] = Upgrade.new(f, "s2m autob", "AKJSLHDFKLJHASDFKL", "tum")
				gv.up[f].effects.append(Effect.new("autob", ["tum"]))
				gv.up[f].requires.append("PILLAR OF AUTUMN")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "DEVOUR"
				gv.up[f] = Upgrade.new(f, "s2m autob", "AKJSLHDFKLJHASDFKL", "carc")
				gv.up[f].effects.append(Effect.new("autob", ["carc"]))
				gv.up[f].requires.append("what kind of resource is 'tumors', you hack fraud")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost["tum"].b).m(2))
				
				f = "Splishy Splashy"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Water LORED.", "water")
				gv.up[f].effects.append(Effect.new("autob", ["water"]))
				gv.up[f].cost["tum"] = Ob.Num.new(4000.0)
				
				f = "AUTOSMITHY"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases your Liquid Iron LORED.", "liq")
				gv.up[f].effects.append(Effect.new("autob", ["liq"]))
				gv.up[f].cost["tum"] = Ob.Num.new(8000.0)
				gv.up[f].requires.append("Splishy Splashy")
			
			# upgr
			if true:
				
				f = "Now That's What I'm Talkin About, YeeeeeeaaaaaaaAAAAAAGGGGGHHH"
				gv.up[f] = Upgrade.new(f, "s2m autoup", "Automatically purchases Extra-normal upgrades. Does not work until most of your Stage 2 LOREDs are at least level 1.", "s2")
				gv.up[f].cost["tum"] = Ob.Num.new("1e12")
				gv.up[f].requires.append("THE WITCH OF LOREDELITH")
				
				# works on s1
				if true:
					
					f = "RED NECROMANCY"
					gv.up[f] = Upgrade.new(f, "s2m autoup", "Automatically purchases Malignant upgrades.", "s1m")
					gv.up[f].cost["tum"] = Ob.Num.new("1e24")
					gv.up[f].requires.append("THE WITCH OF LOREDELITH")
		
		# s1m
		if true:
			
			f = "we were so close, now you don't even think about me"
			gv.up[f] = Upgrade.new(f, "s1m autoup", "Automatically purchases Normal upgrades.", "s1n")
			gv.up[f].cost["malig"] = Ob.Num.new("1e6")
			gv.up[f].requires.append("how is this an RPG anyway?")
			
			f = "SENTIENT DERRICK"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases your Oil LORED if its net output is less than 0.", "oil")
			gv.up[f].effects.append(Effect.new("autob", ["oil"]))
			gv.up[f].cost["malig"] = Ob.Num.new("85e10")
			
			f = "SLAPAPOW!"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases your Tarball LORED if its net output is less than 0.", "tar")
			gv.up[f].effects.append(Effect.new("autob", ["tar"]))
			gv.up["SLAPAPOW!"].cost["malig"] = Ob.Num.new("17e11")
			
			f = "MOUND"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases your Malignancy LORED.", "malig")
			gv.up[f].effects.append(Effect.new("autob", ["malig"]))
			gv.up["MOUND"].cost["malig"] = Ob.Num.new("35e12")
			
			f = "wtf is that musk"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases your Joule LORED if its net output is less than 0.", "jo")
			gv.up[f].effects.append(Effect.new("autob", ["jo"]))
			gv.up[f].cost["malig"] = Ob.Num.new("43e7")
			
			f = "CANKERITE"
			gv.up[f] = Upgrade.new(f, "s1m autob","Automatically purchases your Concrete LORED if its output is less than your Stone LORED's output.","conc")
			gv.up[f].effects.append(Effect.new("autob", ["conc"]))
			gv.up[f].cost["malig"] = Ob.Num.new("15e9")
			
			f = "MOIST"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases your Growth LORED.", "growth")
			gv.up[f].effects.append(Effect.new("autob", ["growth"]))
			gv.up[f].cost["malig"] = Ob.Num.new("12e6")
			
			f = "AUTOPOLICE"
			gv.up[f] = Upgrade.new(f, "s1m autob", "asdf", "cop")
			gv.up[f].effects.append(Effect.new("autob", ["cop"]))
			gv.up["AUTOPOLICE"].cost["malig"] = Ob.Num.new(140000.0)
			
			f = "SIDIUS IRON"
			gv.up[f] = Upgrade.new(f, "s1m autob", "asd", "iron")
			gv.up[f].effects.append(Effect.new("autob", ["iron"]))
			gv.up["SIDIUS IRON"].cost["malig"] = Ob.Num.new("8e12")
			
			f = "pippenpaddle- oppsoCOPolis"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases your Copper Ore LORED if its net output is less than 0.", "copo")
			gv.up[f].effects.append(Effect.new("autob", ["copo"]))
			gv.up["pippenpaddle- oppsoCOPolis"].cost["malig"] = Ob.Num.new(600000.0)
			
			f = "OREOREUHBor E ALICE"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases your Iron Ore LORED if its net output is less than 0.", "irono")
			gv.up[f].effects.append(Effect.new("autob", ["irono"]))
			gv.up["OREOREUHBor E ALICE"].cost["malig"] = Ob.Num.new(12000.0)
			
			f = "AUTOSTONER"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases your Stone LORED.", "stone")
			gv.up[f].effects.append(Effect.new("autob", ["stone"]))
			gv.up["AUTOSTONER"].cost["malig"] = Ob.Num.new(35000.0)
			
			f = "AUTOSHOVELER"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases your Coal LORED if its net output is less than 0.", "coal")
			gv.up[f].effects.append(Effect.new("autob", ["coal"]))
			gv.up["AUTOSHOVELER"].cost["malig"] = Ob.Num.new(1500.0)
	
	# upcost
	if true:
		
		# s2m
		if true:
			
			f = "Mudslide"
			gv.up[f] = Upgrade.new(f, "s2m cost","Humus LORED Glass cost x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("cost", ["humus"], 0.75, "glass"))
			gv.up[f].cost["tum"] = Ob.Num.new("1e7")
			
			f = "The Great Journey"
			gv.up[f] = Upgrade.new(f, "s2m cost","Glass LORED Steel cost x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("cost", ["glass"], 0.8, "steel"))
			gv.up[f].cost["tum"] = Ob.Num.new("1e7")
			
			f = "BEAVER"
			gv.up[f] = Upgrade.new(f, "s2m cost","Water LORED Wood cost x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("cost", ["water"], 0.8, "wood"))
			gv.up[f].cost["tum"] = Ob.Num.new("1e7")
			
			f = "mods enabled"
			gv.up[f] = Upgrade.new(f, "s2m cost","Petroleum LORED Glass cost x{e0}.", "pet")
			gv.up[f].effects.append(Effect.new("cost", ["pet"], 0.75, "glass"))
			gv.up[f].cost["tum"] = Ob.Num.new("1e7")
		
		# s1m
		if true:
			
			f = "FOOD TRUCKS"
			gv.up[f] = Upgrade.new(f, "s1m cost", "All Stage 1 costs x{e0}.")
			gv.up[f].effects.append(Effect.new("cost", gv.stats.g_list["s1"], 0.5, "all"))
			gv.up[f].cost["malig"] = Ob.Num.new("1e13") # 10e12
			gv.up[f].requires.append("upgrade_name")
			
			f = "CON-FRICKIN-CRETE"
			gv.up[f] = Upgrade.new(f, "s1m cost", "Oil LORED Concrete cost x{e0}.", "oil")
			gv.up[f].effects.append(Effect.new("cost", ["oil"], 0.5, "conc"))
			gv.up["CON-FRICKIN-CRETE"].cost["malig"] = Ob.Num.new(12000.0)
			
			f = "COMPULSORY JUICE"
			gv.up[f] = Upgrade.new(f, "s1m cost", "Iron Ore and Copper Ore LORED Stone cost x{e0}.", "stone")
			gv.up[f].effects.append(Effect.new("cost", ["irono", "copo"], 0.5, "stone"))
			gv.up[f].cost["malig"] = Ob.Num.new(50000.0)
			gv.up[f].requires.append("AUTOSTONER")
	
	# uphaste
	if true:
		
		# s2m
		if true:
			
			f = "Covenant Dance"
			gv.up[f] = Upgrade.new(f, "s2m haste","Humus LORED haste x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("haste", ["humus"], 1.5))
			gv.up[f].cost["tum"] = Ob.Num.new("1e7")
			gv.up[f].requires.append("PEPPERMINT MOCHA")
			
			f = "Overtime"
			gv.up[f] = Upgrade.new(f, "s2m haste","Liquid Iron LORED haste x{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("haste", ["liq"], 1.5))
			gv.up[f].requires.append("Covenant Dance")
			gv.up[f].cost["tum"] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost["tum"].b.m(2))
			
			f = "Bone Meal"
			gv.up[f] = Upgrade.new(f, "s2m haste","Tree LORED haste x{e0}.", "tree")
			gv.up[f].effects.append(Effect.new("haste", ["tree"], 1.5))
			gv.up[f].requires.append("Overtime")
			gv.up[f].cost["tum"] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost["tum"].b.m(2))
			
			f = "SILLY"
			gv.up[f] = Upgrade.new(f, "s2m haste","Hardwood LORED haste x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("haste", ["hard"], 1.5))
			gv.up[f].requires.append("Bone Meal")
			gv.up[f].cost["tum"] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost["tum"].b.m(2))
			
			f = "PLATE"
			gv.up[f] = Upgrade.new(f, "s2m haste","Steel LORED haste x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("haste", ["steel"], 1.5))
			gv.up[f].requires.append("SILLY")
			gv.up[f].cost["tum"] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost["tum"].b.m(2))
			
			f = "Child Energy"
			gv.up[f] = Upgrade.new(f, "s2m haste","Soil LORED haste x{e0}.", "soil")
			gv.up[f].effects.append(Effect.new("haste", ["soil"], 1.5))	
			gv.up[f].requires.append("PLATE")
			gv.up[f].cost["tum"] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost["tum"].b.m(2))
			
			f = "Erebor"
			gv.up[f] = Upgrade.new(f, "s2m haste","Galena LORED haste x{e0}.", "gale")
			gv.up[f].effects.append(Effect.new("haste", ["gale"], 1.5))
			gv.up[f].requires.append("Child Energy")
			gv.up[f].cost["tum"] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost["tum"].b.m(2))
			
			f = "SPEED DOODS"
			gv.up[f] = Upgrade.new(f, "s2m haste","Draw Plate LORED haste x{e0}.", "draw")
			gv.up[f].effects.append(Effect.new("haste", ["draw"], 1.5))
			gv.up[f].requires.append("Erebor")
			gv.up[f].cost["tum"] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost["tum"].b.m(2))
			
			f = "MILK"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s2"], 1.1))
			gv.up[f].cost["tum"] = Ob.Num.new(2000)
			
			f = "GATORADE"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s2"], 1.1))
			gv.up[f].requires.append("MILK")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["MILK"].cost["tum"].b).m(5))
			
			f = "APPLE JUICE"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s2"], 1.1))
			gv.up[f].requires.append("GATORADE")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["GATORADE"].cost["tum"].b).m(6 * 10))
			
			f = "PEPPERMINT MOCHA"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s2"], 1.1))
			gv.up[f].requires.append("APPLE JUICE")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["APPLE JUICE"].cost["tum"].b).m(3))
			
			f = "STRAWBERRY BANANA SMOOTHIE"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s2"], 1.1))
			gv.up[f].requires.append("PEPPERMINT MOCHA")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["PEPPERMINT MOCHA"].cost["tum"].b).m(3 * 100))
			
			f = "GREEN TEA"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s2"], 1.1))
			gv.up[f].requires.append("STRAWBERRY BANANA SMOOTHIE")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["STRAWBERRY BANANA SMOOTHIE"].cost["tum"].b).m(3))
			
			f = "FRENCH VANILLA"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s2"], 1.1))
			gv.up[f].requires.append("GREEN TEA")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["GREEN TEA"].cost["tum"].b).m(3))
			
			f = "WATER"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s2"], 1.1))
			gv.up[f].requires.append("FRENCH VANILLA")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["FRENCH VANILLA"].cost["tum"].b).m(3))
		
		# s2n
		if true:
			
			f = "SPOOLY"
			gv.up[f] = Upgrade.new(f, "s2n haste","Wire LORED haste x{e0}.", "wire")
			gv.up[f].effects.append(Effect.new("haste", ["wire"], 1.25))
			gv.up[f].cost["hard"] = Ob.Num.new("750e6")
			gv.up[f].cost["carc"] = Ob.Num.new("25e6")
			gv.up[f].requires.append("PULLEY")
			
			f = "Utter Molester Champ"
			gv.up[f] = Upgrade.new(f, "s2n haste","Petroleum LORED haste x{e0}.", "pet")
			gv.up[f].effects.append(Effect.new("haste", ["pet"], 1.15))
			gv.up[f].cost["carc"] = Ob.Num.new(100000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "CANCER'S REAL COOL"
			gv.up[f] = Upgrade.new(f, "s2n haste","Tumor LORED haste x{e0}.", "tum")
			gv.up[f].effects.append(Effect.new("haste", ["tum"], 1.25))
			gv.up[f].cost["water"] = Ob.Num.new(150000.0)
			gv.up[f].cost["tree"] = Ob.Num.new(150000.0)
			gv.up[f].cost["humus"] = Ob.Num.new(150000.0)
			gv.up[f].cost["axe"] = Ob.Num.new(150000.0)
			gv.up[f].cost["wire"] = Ob.Num.new(150000.0)
			gv.up[f].cost["glass"] = Ob.Num.new(150000.0)
			gv.up[f].cost["hard"] = Ob.Num.new(150000.0)
			gv.up[f].cost["steel"] = Ob.Num.new(150000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(150000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Wood Lord"
			gv.up[f] = Upgrade.new(f, "s2n haste","Axe, Wood, and Hardwood LORED haste x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("haste", ["axe", "wood", "hard"], 1.15))
			gv.up[f].cost["steel"] = Ob.Num.new(35000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("Cutting Corners")
			
			f = "Expert Iron Worker"
			gv.up[f] = Upgrade.new(f, "s2n haste","Liquid Iron and Steel LORED haste x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("haste", ["liq", "steel"], 1.15))
			gv.up[f].cost["glass"] = Ob.Num.new(40000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("Quormps")
			
			f = "Where's the boy, String?"
			gv.up[f] = Upgrade.new(f, "s2n haste","Draw Plate and Wire LORED haste x{e0}.", "wire")
			gv.up[f].effects.append(Effect.new("haste", ["draw", "wire"], 1.15))
			gv.up[f].cost["hard"] = Ob.Num.new(35000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("Hole Geometry")
			
			f = "They've Always Been Faster"
			gv.up[f] = Upgrade.new(f, "s2n haste","Humus, Sand, and Glass LORED x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("haste", ["humus", "sand", "glass"], 1.15))
			gv.up[f].cost["wire"] = Ob.Num.new(75000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("Kilty Sbark")
			
			f = "Sp0oKy"
			gv.up[f] = Upgrade.new(f, "s2n haste","Carcinogen LORED haste x{e0}.", "carc")
			gv.up[f].effects.append(Effect.new("haste", ["carc"], 1.15))
			gv.up[f].cost["carc"] = Ob.Num.new(1000.0)
			gv.up[f].cost["tum"] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("Cioran")
			
			f = "RAIN DANCE"
			gv.up[f] = Upgrade.new(f, "s2n haste","Water LORED haste x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("haste", ["water"], 1.2))
			gv.up[f].cost["sand"] = Ob.Num.new(40.0)
			
			f = "BREAK THE DAM"
			gv.up[f] = Upgrade.new(f, "s2n haste","Water LORED haste x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("haste", ["water"], 1.25))
			gv.up[f].cost["liq"] = Ob.Num.new(30.0)
			gv.up[f].requires.append("RAIN DANCE")
			
			f = "Carlin"
			gv.up[f] = Upgrade.new(f, "s2n haste buff","Stage 2 haste x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s2"], 1.05))
			gv.up[f].cost["lead"] = Ob.Num.new(600.0)
			
			f = "Sagan"
			gv.up[f] = Upgrade.new(f, "s2n haste buff","Stage 2 haste x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s2"], 1.05))
			gv.up[f].cost["carc"] = Ob.Num.new(5.0)
			gv.up[f].requires.append("Carlin")

			f = "Patreon Artist"
			gv.up[f] = Upgrade.new(f, "s2n haste","Wire LORED haste x{e0}.", "wire")
			gv.up[f].effects.append(Effect.new("haste", ["wire"], 1.2))
			gv.up[f].cost["hard"] = Ob.Num.new(200.0)
			gv.up[f].requires.append("Carlin")

			f = "LIGHTHOUSE"
			gv.up[f] = Upgrade.new(f, "s2n haste","Sand LORED haste x{e0}.", "sand")
			gv.up[f].effects.append(Effect.new("haste", ["sand"], 1.15))
			gv.up["LIGHTHOUSE"].cost["wire"] = Ob.Num.new(130.0)

			f = "Woodthirsty"
			gv.up["Woodthirsty"] = Upgrade.new(f, "s2n haste","Axe LORED haste x{e0}.", "axe")
			gv.up[f].effects.append(Effect.new("haste", ["axe"], 1.3))
			gv.up["Woodthirsty"].cost["wood"] = Ob.Num.new(800.0)
			gv.up["Woodthirsty"].cost["hard"] = Ob.Num.new(100.0)

			f = "Woodiac Chopper"
			gv.up["Woodiac Chopper"] = Upgrade.new(f, "s2n haste","Axe LORED haste x{e0}.", "axe")
			gv.up[f].effects.append(Effect.new("haste", ["axe"], 1.4))
			gv.up["Woodiac Chopper"].cost["carc"] = Ob.Num.new(50.0)
			gv.up["Woodiac Chopper"].requires.append("Seeing Brown")

			f = "Millery"
			gv.up[f] = Upgrade.new(f, "s2n haste","Hardwood LORED haste x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("haste", ["hard"], 1.25))
			gv.up[f].cost["steel"] = Ob.Num.new(385.0)
			gv.up[f].cost["carc"] = Ob.Num.new(25.0)
			gv.up[f].requires.append("Hardwood Yourself")

			f = "Quamps"
			gv.up[f] = Upgrade.new(f, "s2n haste","Steel LORED haste x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("haste", ["steel"], 1.35))
			gv.up[f].cost["glass"] = Ob.Num.new(600.0)
			gv.up[f].cost["carc"] = Ob.Num.new(25.0)
			gv.up[f].requires.append("Steel Yourself")

			f = "Kilty Sbark"
			gv.up[f] = Upgrade.new(f, "s2n haste","Glass LORED haste x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("haste", ["glass"], 1.15))
			gv.up[f].cost["wire"] = Ob.Num.new(6500.0)
			gv.up[f].cost["carc"] = Ob.Num.new(200.0)
			gv.up[f].requires.append("2552")

			f = "Dirt Collection Rewards Program"
			gv.up[f] = Upgrade.new(f, "s2n haste","Humus LORED haste x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("haste", ["humus"], 1.25))
			gv.up[f].cost["soil"] = Ob.Num.new(25000.0)
			gv.up[f].cost["lead"] = Ob.Num.new(25000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(350.0)
		
		# s1m
		if true: # mup
			
			f = "MALEVOLENT"
			gv.up[f] = Upgrade.new(f, "s1m haste","Tar, Concrete, and Malignancy LORED haste x{e0}.", "malig")
			gv.up[f].effects.append(Effect.new("haste", ["tar", "conc", "malig"], 4.0))
			gv.up["MALEVOLENT"].cost["malig"] = Ob.Num.new("1e24")
			gv.up["MALEVOLENT"].requires.append("MOUND")
			
			f = "OH, BABY, A TRIPLE"
			gv.up[f] = Upgrade.new(f, "s1m haste","Tarball LORED haste x{e0}.", "tar")
			gv.up[f].effects.append(Effect.new("haste", ["tar"], 3.0))
			gv.up[f].cost["malig"] = Ob.Num.new(55000.0)
			gv.up[f].requires.append("you little hard worker, you")
			
			f = "STAY QUENCHED"
			gv.up[f] = Upgrade.new(f, "s1m haste","Coal and Joule LORED haste x{e0}.", "jo")
			gv.up[f].effects.append(Effect.new("haste", ["coal", "jo"], 1.8))
			gv.up[f].cost["malig"] = Ob.Num.new(60000.0)
			gv.up[f].requires.append("you little hard worker, you")

			f = "CANCER'S COOL"
			gv.up[f] = Upgrade.new(f, "s1m haste","Growth and Malignancy LORED haste x{e0}.", "malig")
			gv.up[f].effects.append(Effect.new("haste", ["growth", "malig"], 2.0))
			gv.up[f].cost["malig"] = Ob.Num.new("3e9")
			gv.up[f].requires.append("MOIST")

			f = "you little hard worker, you"
			gv.up[f] = Upgrade.new(f, "s1m haste","Stone and Concrete LORED haste x{e0}.", "conc")
			gv.up[f].effects.append(Effect.new("haste", ["stone", "conc"], 2.0))
			gv.up[f].cost["malig"] = Ob.Num.new(40000.0)

			f = "ORE LORD"
			gv.up["ORE LORD"] = Upgrade.new(f, "s1m haste","Iron Ore, Copper Ore, Iron, and Copper LORED haste x{e0}.")
			gv.up[f].effects.append(Effect.new("haste", ["irono", "copo", "iron", "cop"], 2.0))
			gv.up["ORE LORD"].cost["malig"] = Ob.Num.new("1e6")
			gv.up["ORE LORD"].requires.append("BIG TOUGH BOY")

			f = "OPPAI GUY"
			gv.up[f] = Upgrade.new(f, "s1m haste","Stage 1 haste x{e0}.")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s1"], 2.0))
			gv.up["OPPAI GUY"].cost["malig"] = Ob.Num.new("1e15")
			gv.up["OPPAI GUY"].requires.append("FOOD TRUCKS")

			f = "SOCCER DUDE"
			gv.up[f] = Upgrade.new(f, "s1m haste","Stage 1 haste x{e0}.")
			gv.up[f].effects.append(Effect.new("haste", gv.stats.g_list["s1"], 2.0))
			gv.up[f].cost["malig"] = Ob.Num.new(1600.0)
			
			f = "coal DUDE"
			gv.up[f] = Upgrade.new(f, "s1m haste","Coal LORED haste x{e0}.", "coal")
			gv.up[f].effects.append(Effect.new("haste", ["coal"], 2.0))
			gv.up[f].cost["malig"] = Ob.Num.new("1e11")
		
		# n
		if true:
			
			f = "GRINDER"
			gv.up[f] = Upgrade.new(f, "s1n haste","Stone LORED haste x{e0}.", "stone")
			gv.up[f].cost["stone"] = Ob.Num.new(90.0)
			gv.up[f].effects.append(Effect.new("haste", ["stone"], 1.25))
			
			f = "SLOP"
			gv.up["SLOP"] = Upgrade.new(f, "s1n haste", "Growth LORED haste x{e0}.", "growth")
			gv.up[f].effects.append(Effect.new("haste", ["growth"], 1.95))
			gv.up["SLOP"].cost["stone"] = Ob.Num.new("1e6")
			gv.up["SLOP"].requires.append("SLIMER")
			
			f = "SLIMER"
			gv.up["SLIMER"] = Upgrade.new(f, "s1n haste", "Growth LORED haste x{e0}.", "growth")
			gv.up[f].effects.append(Effect.new("haste", ["growth"], 1.5))
			gv.up["SLIMER"].cost["malig"] = Ob.Num.new(150.0)
			gv.up["SLIMER"].requires.append("RYE")

			f = "GRANDER"
			gv.up[f] = Upgrade.new(f, "s1n haste", "Stone LORED haste x{e0}.", "stone")
			gv.up[f].effects.append(Effect.new("haste", ["stone"], 1.3))
			gv.up[f].cost["coal"] = Ob.Num.new(400.0)
			gv.up[f].requires.append("GRINDER")

			f = "LIGHTER SHOVEL"
			gv.up[f] = Upgrade.new(f, "s1n haste","Coal LORED haste x{e0}.", "coal")
			gv.up[f].effects.append(Effect.new("haste", ["coal"], 1.2))
			gv.up[f].cost["cop"] = Ob.Num.new(155.0)
			gv.up[f].requires.append("GRINDER")

			f = "GROUNDER"
			gv.up["GROUNDER"] = Upgrade.new(f, "s1n haste","Stone LORED haste x{e0}.", "stone")
			gv.up[f].effects.append(Effect.new("haste", ["stone"], 1.35))
			gv.up["GROUNDER"].cost["growth"] = Ob.Num.new(100.0)
			gv.up["GROUNDER"].cost["jo"] = Ob.Num.new(100.0)
			gv.up["GROUNDER"].requires.append("GRANDPA")

			f = "GRANDMA"
			gv.up["GRANDMA"] = Upgrade.new(f, "s1n haste","Stone LORED haste x{e0}.", "stone")
			gv.up[f].effects.append(Effect.new("haste", ["stone"], 1.3))
			gv.up["GRANDMA"].cost["iron"] = Ob.Num.new(400.0)
			gv.up["GRANDMA"].cost["cop"] = Ob.Num.new(400.0)
			gv.up["GRANDMA"].cost["conc"] = Ob.Num.new(20.0)
			gv.up["GRANDMA"].requires.append("GRANDER")
			
			f = "MIXER"
			gv.up["MIXER"] = Upgrade.new(f, "s1n haste","Concrete LORED haste x{e0}.", "conc")
			gv.up[f].effects.append(Effect.new("haste", ["conc"], 1.5))
			gv.up["MIXER"].cost["conc"] = Ob.Num.new(11.0)
			gv.up[f].requires.append("RYE")
			
			f = "SWIRLER"
			gv.up["SWIRLER"] = Upgrade.new(f, "s1n haste","Concrete LORED haste x{e0}.", "conc")
			gv.up[f].effects.append(Effect.new("haste", ["conc"], 1.5))
			gv.up["SWIRLER"].cost["coal"] = Ob.Num.new(9500.0)
			gv.up["SWIRLER"].cost["stone"] = Ob.Num.new(6000.0)
			gv.up["SWIRLER"].requires.append("MIXER")
			
			f = "SAALNDT"
			gv.up["SAALNDT"] = Upgrade.new(f, "s1n haste","Iron Ore and Copper Ore LORED haste x{e0}.", "irono")
			gv.up[f].effects.append(Effect.new("haste", ["irono", "copo"], 1.5))
			gv.up["SAALNDT"].cost["irono"] = Ob.Num.new(1500.0)
			gv.up["SAALNDT"].cost["copo"] = Ob.Num.new(1500.0)
			gv.up["SAALNDT"].requires.append("GRINDER")

			f = "ANCHOVE COVE"
			gv.up[f] = Upgrade.new(f, "s1n haste","Iron Ore and Copper Ore LORED haste x{e0}.", "copo")
			gv.up[f].effects.append(Effect.new("haste", ["irono", "copo"], 2.0))
			gv.up["ANCHOVE COVE"].cost["irono"] = Ob.Num.new(450000.0)
			gv.up["ANCHOVE COVE"].cost["copo"] = Ob.Num.new(450000.0)
			gv.up["ANCHOVE COVE"].requires.append("SAALNDT")

			f = "FLANK"
			gv.up["FLANK"] = Upgrade.new(f, "s1n haste","Iron LORED haste x{e0}.", "iron")
			gv.up[f].effects.append(Effect.new("haste", ["iron"], 1.4))
			gv.up["FLANK"].cost["malig"] = Ob.Num.new(125.0)
			gv.up["FLANK"].requires.append("SALT")

			f = "TEXAS"
			gv.up["TEXAS"] = Upgrade.new(f, "s1n haste","Iron LORED haste x{e0}.", "iron")
			gv.up[f].effects.append(Effect.new("haste", ["iron"], 1.25))
			gv.up["TEXAS"].cost["growth"] = Ob.Num.new(30.0)
			gv.up["TEXAS"].cost["cop"] = Ob.Num.new(400.0)
			gv.up["TEXAS"].requires.append("RYE")
			
			f = "SAND"
			gv.up["SAND"] = Upgrade.new(f, "s1n haste","Copper LORED haste x{e0}.", "cop")
			gv.up[f].effects.append(Effect.new("haste", ["cop"], 1.25))
			gv.up["SAND"].cost["growth"] = Ob.Num.new(200.0)
			gv.up["SAND"].requires.append("RYE")
			
			f = "RYE"
			gv.up[f] = Upgrade.new(f, "s1n haste","Copper LORED haste x{e0}.", "cop")
			gv.up[f].effects.append(Effect.new("haste", ["cop"], 1.25))
			gv.up[f].cost["growth"] = Ob.Num.new(10.0)
			gv.up[f].cost["iron"] = Ob.Num.new(100.0)
			gv.up[f].requires.append("GRINDER")
	
	# upout
	if true:
		
		# s2m
		if true:
			
			f = "Cthaeh"
			gv.up[f] = Upgrade.new(f, "s2m output","Tree LORED output x{e0}.", "tree")
			gv.up[f].effects.append(Effect.new("output", ["tree"], 10.0))
			gv.up[f].requires.append("axman23 by now")
			gv.up[f].cost["tum"] = Ob.Num.new("5e21") # e12
			
			f = "ONE PUNCH"
			gv.up[f] = Upgrade.new(f, "s2m output", "Stage 2 output x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s2"], 1.5))
			gv.up[f].requires.append("DOT DOT DOT")
			gv.up[f].cost["tum"] = Ob.Num.new("1e20") # b
			
			f = "FALCON PAWNCH"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s2"], 1.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new(1250)
			
			f = "KAIO-KEN"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s2"], 1.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["FALCON PAWNCH"].cost["tum"].b).m(5))
			gv.up[f].requires.append("FALCON PAWNCH")
			
			f = "DANCE OF THE FIRE GOD"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s2"], 1.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["KAIO-KEN"].cost["tum"].b).m(6 * 12))
			gv.up[f].requires.append("KAIO-KEN")
			
			f = "RASENGAN"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s2"], 1.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["DANCE OF THE FIRE GOD"].cost["tum"].b).m(3))
			gv.up[f].requires.append("DANCE OF THE FIRE GOD")
			
			f = "AVATAR STATE"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s2"], 1.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["RASENGAN"].cost["tum"].b).m(3 * 100)) # 1.01mil
			gv.up[f].requires.append("RASENGAN")
			
			f = "HAMON"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s2"], 1.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["AVATAR STATE"].cost["tum"].b).m(3))
			gv.up[f].requires.append("AVATAR STATE")
			
			f = "METAL CAP"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s2"], 1.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["HAMON"].cost["tum"].b).m(3))
			gv.up[f].requires.append("HAMON")
			
			f = "STAR ROD"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s2"], 1.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["METAL CAP"].cost["tum"].b).m(3))
			gv.up[f].requires.append("METAL CAP")
			
			# s1 only
			if true:
				
				f = "Elbow Straps"
				gv.up[f] = Upgrade.new(f, "s2m output buff","Coal LORED base output +{e0}.", "coal")
				gv.up[f].effects.append(Effect.new("output", ["coal"], 1.0, "", false))
				gv.up[f].cost["tum"] = Ob.Num.new("3e12")
				gv.up[f].requires.append("THE WITCH OF LOREDELITH")
				
				f = "MECHANICAL"
				gv.up[f] = Upgrade.new(f, "s2m output","Stage 1 output x{e0}.")
				gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s1"], 2.0))
				gv.up[f].cost["tum"] = Ob.Num.new(250)
				
				f = "SPEED-SHOPPER"
				gv.up[f] = Upgrade.new(f, "s2m output","Stage 1 output x{e0}.")
				gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s1"], 2.0))
				gv.up[f].cost["tum"] = Ob.Num.new("35000")
				gv.up[f].requires.append("don't take candy from babies")
		
		# s2n
		if true:
			
			f = "John Peter Bain, TotalBiscuit"
			gv.up[f] = Upgrade.new(f, "s2n output", "Stage 2 output x{e0}.\n\"I am here to ask and answer one simple question: WTF is LORED?\"", "s2")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s2"], 2.0))
			gv.up[f].cost["carc"] = Ob.Num.new("1e12") # t
			gv.up[f].cost["tum"] = Ob.Num.new("10e9")
			gv.up[f].requires.append("Toriyama")
			
			f = "Ultra Shitstinct"
			gv.up[f] = Upgrade.new(f, "s2n output","Humus LORED output x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("output", ["humus"], 1.35))
			gv.up[f].cost["water"] = Ob.Num.new("1e9")
			gv.up[f].cost["seed"] = Ob.Num.new("25e6")
			gv.up[f].cost["carc"] = Ob.Num.new("10e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "BURDENED"
			gv.up[f] = Upgrade.new(f, "s2n output buff","Lead LORED base output +{e0}.", "lead")
			gv.up[f].effects.append(Effect.new("output", ["lead"], 1.0, "", false))
			gv.up[f].cost["humus"] = Ob.Num.new("10e9")
			gv.up[f].cost["pulp"] = Ob.Num.new("4e9")
			gv.up[f].cost["paper"] = Ob.Num.new(1)
			gv.up[f].requires.append("Toriyama")
			
			f = "low rises"
			gv.up[f] = Upgrade.new(f, "s2n output","Wire LORED output x{e0}.", "wire")
			gv.up[f].effects.append(Effect.new("output", ["wire"], 1.35))
			gv.up[f].cost["hard"] = Ob.Num.new("10e9")
			gv.up[f].cost["carc"] = Ob.Num.new("1e9")
			gv.up[f].requires.append("SPOOLY")
			
			f = "Fingers of Onden"
			gv.up[f] = Upgrade.new(f, "s2n output","Steel LORED output x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("output", ["steel"], 1.25))
			gv.up[f].cost["glass"] = Ob.Num.new("15e9")
			gv.up[f].cost["carc"] = Ob.Num.new("1e9")
			gv.up[f].requires.append("Steel Yo Mama")
			
			f = "Busy Bee"
			gv.up[f] = Upgrade.new(f, "s2n output","Seed LORED output x{e0}.", "seed")
			gv.up[f].effects.append(Effect.new("output", ["seed"], 1.3))
			gv.up[f].cost["steel"] = Ob.Num.new("10e6")
			gv.up[f].cost["glass"] = Ob.Num.new("15e6")
			gv.up[f].cost["lead"] = Ob.Num.new("50e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "DINDER MUFFLIN"
			gv.up[f] = Upgrade.new(f, "s2n output","Paper LORED output x{e0}.", "paper")
			gv.up[f].effects.append(Effect.new("output", ["paper"], 1.25))
			gv.up[f].cost["steel"] = Ob.Num.new("100e6")
			gv.up[f].cost["glass"] = Ob.Num.new("150e6")
			gv.up[f].cost["lead"] = Ob.Num.new("500e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "MGALEKGOLO"
			gv.up[f] = Upgrade.new(f, "s2n output","Glass LORED output x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("output", ["glass"], 1.3))
			gv.up[f].cost["wire"] = Ob.Num.new("80e6")
			gv.up[f].cost["carc"] = Ob.Num.new("1e6")
			gv.up[f].requires.append("They've Always Been Faster")
			
			f = "Power Barrels"
			gv.up[f] = Upgrade.new(f, "s2n output","Liquid Iron LORED output x{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("output", ["liq"], 1.2))
			gv.up[f].cost["steel"] = Ob.Num.new("100e6")
			gv.up[f].cost["glass"] = Ob.Num.new("25e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "And this is to go even further beyond!"
			gv.up[f] = Upgrade.new(f, "s2n output","Wood LORED output x{e0}.", "wood")
			gv.up[f].effects.append(Effect.new("output", ["wood"], 1.25))
			gv.up[f].cost["paper"] = Ob.Num.new("1e7")
			gv.up[f].cost["pulp"] = Ob.Num.new("3e7")
			gv.up[f].cost["water"] = Ob.Num.new("25e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "ERECTWOOD"
			gv.up[f] = Upgrade.new(f, "s2n output","Hardwood LORED output x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("output", ["hard"], 1.3))
			gv.up[f].cost["steel"] = Ob.Num.new("2e7")
			gv.up[f].cost["carc"] = Ob.Num.new("1e6")
			gv.up[f].requires.append("Wood Lord")
			
			f = "Glitterdelve"
			gv.up[f] = Upgrade.new(f, "s2n output","Galena LORED output x{e0}.", "gale")
			gv.up[f].effects.append(Effect.new("output", ["gale"], 1.25))
			gv.up[f].cost["lead"] = Ob.Num.new(100000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(8000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Longbottom Leaf"
			gv.up[f] = Upgrade.new(f, "s2n output","Tobacco LORED output x{e0}.", "toba")
			gv.up[f].effects.append(Effect.new("output", ["toba"], 1.25))
			gv.up[f].cost["wood"] = Ob.Num.new(500000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(5000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Factory Squirts"
			gv.up[f] = Upgrade.new(f, "s2n output","Petroleum LORED output x{e0}.", "pet")
			gv.up[f].effects.append(Effect.new("output", ["pet"], 1.25))
			gv.up[f].cost["growth"] = Ob.Num.new("2e8")
			gv.up[f].cost["lead"] = Ob.Num.new(3000.0)
			gv.up[f].cost["tum"] = Ob.Num.new(500.0)
			gv.up[f].requires.append("Cioran")
			
			f = "CANOPY"
			gv.up[f] = Upgrade.new(f, "s2n output","Water LORED output x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("output", ["water"], 1.25))
			gv.up["CANOPY"].cost["tree"] = Ob.Num.new(10.0)
			
			f = "EQUINE"
			gv.up[f] = Upgrade.new(f, "s2n output","Humus LORED output x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("output", ["humus"], 1.3))
			gv.up["EQUINE"].cost["glass"] = Ob.Num.new(90.0)
			
			f = "PLASMA BOMBARDMENT"
			gv.up[f] = Upgrade.new(f, "s2n output","Glass LORED output x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("output", ["glass"], 1.25))
			gv.up[f].cost["wire"] = Ob.Num.new(310.0)
			gv.up[f].requires.append("Carlin")
			
			f = "Double Barrels"
			gv.up[f] = Upgrade.new(f, "s2n output buff","Liquid Iron LORED base output +{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("output", ["liq"], 1.0, "", false))
			gv.up["Double Barrels"].cost["glass"] = Ob.Num.new(50.0)
			gv.up["Double Barrels"].cost["hard"] = Ob.Num.new(100.0)
			
			f = "Triple Barrels"
			gv.up[f] = Upgrade.new(f, "s2n output buff","Liquid Iron LORED base output +{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("output", ["liq"], 1.0, "", false))
			gv.up["Triple Barrels"].cost["wire"] = Ob.Num.new(350.0)
			gv.up["Triple Barrels"].cost["steel"] = Ob.Num.new(100.0)
			gv.up["Triple Barrels"].cost["soil"] = Ob.Num.new(250.0)
			gv.up["Triple Barrels"].requires.append("Double Barrels")
			
			f = "Seeing Brown"
			gv.up[f] = Upgrade.new(f, "s2n output","Axe LORED output x{e0}.", "axe")
			gv.up[f].effects.append(Effect.new("output", ["axe"], 1.25))
			gv.up[f].cost["glass"] = Ob.Num.new(300.0)
			gv.up[f].cost["wire"] = Ob.Num.new(300.0)
			gv.up[f].cost["tree"] = Ob.Num.new(100.0)
			gv.up[f].requires.append("Woodthirsty")
			
			f = "GIMP"
			gv.up[f] = Upgrade.new(f, "s2n output","Wire LORED output x{e0}.", "wire")
			gv.up[f].effects.append(Effect.new("output", ["wire"], 1.3))
			gv.up[f].cost["hard"] = Ob.Num.new(900.0)
			gv.up[f].cost["carc"] = Ob.Num.new(25.0)
			gv.up[f].requires.append("Patreon Artist")
			
			f = "Henry Cavill"
			gv.up[f] = Upgrade.new(f, "s2n output","Water LORED output x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("output", ["water"], 1.3))
			gv.up[f].cost["ciga"] = Ob.Num.new(23.23)
			gv.up[f].cost["pulp"] = Ob.Num.new(70.0)
			gv.up[f].requires.append("Sagan")
			
			f = "Journeyman Iron Worker"
			gv.up[f] = Upgrade.new(f, "s2n output","Liquid Iron and Steel LORED output x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("output", ["liq", "steel"], 1.3))
			gv.up[f].cost["axe"] = Ob.Num.new(250.0)
			gv.up[f].cost["carc"] = Ob.Num.new(50.0)
			gv.up[f].requires.append("Sagan")
			
			f = "Soft and Smooth"
			gv.up[f] = Upgrade.new(f, "s2n output","Sand LORED output x{e0}", "sand")
			gv.up[f].effects.append(Effect.new("output", ["sand"], 1.25))
			gv.up[f].cost["steel"] = Ob.Num.new(4500.0)
			gv.up[f].cost["carc"] = Ob.Num.new(900.0)
			gv.up[f].requires.append("Unpredictable Weather")
		
		# s1mup
		if true:
			
			f = "I DRINK YOUR MILKSHAKE"
			gv.up[f] = Upgrade.new(f, "s1m output","Whenever a LORED takes Coal, your Coal LORED gets an output boost.", "coal")
			gv.up[f].effects.append(Effect.new("output", ["coal"], 0.0, "", false))
			gv.up[f].effects[0].dynamic = true
			gv.up[f].cost["malig"] = Ob.Num.new(800000.0)
			gv.up[f].requires.append("STAY QUENCHED")
			
			f = "SLUGGER"
			gv.up[f] = Upgrade.new(f, "s1m output","Stage 1 output x{e0}.")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s1"], 2.0))
			gv.up["SLUGGER"].cost["malig"] = Ob.Num.new("1e16")
			gv.up["SLUGGER"].requires.append("OPPAI GUY")
			
			f = "BIG TOUGH BOY"
			gv.up[f] = Upgrade.new(f, "s1m output","Stage 1 output x{e0}.")
			gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s1"], 2.0))
			gv.up["BIG TOUGH BOY"].cost["malig"] = Ob.Num.new(175000.0)
			gv.up["BIG TOUGH BOY"].requires.append("how is this an RPG anyway?")
			
			f = "ENTHUSIASM"
			gv.up[f] = Upgrade.new(f, "s1m output","Coal LORED output x{e0}.", "coal")
			gv.up[f].effects.append(Effect.new("output", ["coal"], 1.25))
			gv.up[f].cost["malig"] = Ob.Num.new(3000.0)
			gv.up[f].requires.append("AUTOSHOVELER")
		
		# s1n
		if true:
			
			f = "INJECT"
			gv.up[f] = Upgrade.new(f, "s1n output buff","Tarballs LORED base output +{e0}.", "tar")
			gv.up[f].effects.append(Effect.new("output", ["tar"], 1.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new(100.0)
			gv.up[f].requires.append("STICKYTAR")
			
			f = "GEARED OILS"
			gv.up[f] = Upgrade.new(f, "s1n output","Oil LORED output x{e0}.", "oil")
			gv.up[f].effects.append(Effect.new("output", ["oil"], 2.0))
			gv.up["GEARED OILS"].cost["iron"] = Ob.Num.new("6e6")
			gv.up[f].requires.append("CHEEKS")
			
			f = "PEPPER"
			gv.up[f] = Upgrade.new(f, "s1n output","Iron Ore LORED output x{e0}.", "irono")
			gv.up[f].effects.append(Effect.new("output", ["irono"], 10.0))
			gv.up["PEPPER"].cost["cop"] = Ob.Num.new("25e9")
			gv.up["PEPPER"].cost["malig"] = Ob.Num.new("15e6")
			gv.up["PEPPER"].requires.append("ANCHOVE COVE")
			
			f = "GARLIC"
			gv.up[f] = Upgrade.new(f, "s1n output","Copper Ore LORED output x{e0}.", "copo")
			gv.up[f].effects.append(Effect.new("output", ["copo"], 10.0))
			gv.up["GARLIC"].cost["iron"] = Ob.Num.new("25e9")
			gv.up["GARLIC"].cost["malig"] = Ob.Num.new("15e6")
			gv.up["GARLIC"].requires.append("ANCHOVE COVE")
			
			f = "MUD"
			gv.up[f] = Upgrade.new(f, "s1n output","Iron Ore and Iron LORED output x{e0}.", "iron")
			gv.up[f].effects.append(Effect.new("output", ["irono", "iron"], 1.75))
			gv.up["MUD"].cost["cop"] = Ob.Num.new("2e6")
			gv.up["MUD"].cost["malig"] = Ob.Num.new(35000.0)
			gv.up["MUD"].requires.append("RIB")
			
			f = "THYME"
			gv.up[f] = Upgrade.new(f, "s1n output","Copper Ore and Copper LORED output x{e0}.", "cop")
			gv.up[f].effects.append(Effect.new("output", ["copo", "cop"], 1.75))
			gv.up["THYME"].cost["iron"] = Ob.Num.new("2e6")
			gv.up["THYME"].cost["malig"] = Ob.Num.new(35000.0)
			gv.up["THYME"].requires.append("FLANK")
			
			f = "RED GOOPY BOY"
			gv.up[f] = Upgrade.new(f, "s1n output","Malignancy LORED output x{e0}.", "malig")
			gv.up[f].effects.append(Effect.new("output", ["malig"], 1.4))
			gv.up["RED GOOPY BOY"].cost["iron"] = Ob.Num.new(30000.0)
			gv.up["RED GOOPY BOY"].cost["cop"] = Ob.Num.new(30000.0)
			gv.up["RED GOOPY BOY"].cost["malig"] = Ob.Num.new(50.0)
			gv.up["RED GOOPY BOY"].requires.append("STICKYTAR")
			
			f = "SALT"
			gv.up[f] = Upgrade.new(f, "s1n output","Iron LORED output x{e0}.", "iron")
			gv.up[f].effects.append(Effect.new("output", ["iron"], 1.25))
			gv.up["SALT"].cost["growth"] = Ob.Num.new(150.0)
			gv.up[f].requires.append("TEXAS")
			
			f = "RIB"
			gv.up[f] = Upgrade.new(f, "s1n output","Copper LORED output x{e0}.", "cop")
			gv.up[f].effects.append(Effect.new("output", ["cop"], 1.4))
			gv.up["RIB"].cost["malig"] = Ob.Num.new(125.0)
			gv.up["RIB"].requires.append("SALT")
			
			f = "GRANDPA"
			gv.up[f] = Upgrade.new(f, "s1n output","Stone LORED output x{e0}.", "stone")
			gv.up[f].effects.append(Effect.new("output", ["stone"], 1.35))
			gv.up["GRANDPA"].cost["iron"] = Ob.Num.new(2500.0)
			gv.up["GRANDPA"].cost["cop"] = Ob.Num.new(2500.0)
			gv.up["GRANDPA"].requires.append("GRANDMA")
			
			f = "MAXER"
			gv.up[f] = Upgrade.new(f, "s1n output","Concrete LORED output x{e0}.", "conc")
			gv.up[f].effects.append(Effect.new("output", ["conc"], 1.4))
			gv.up["MAXER"].cost["growth"] = Ob.Num.new(400.0)
			gv.up["MAXER"].requires.append("SWIRLER")
			
			f = "WATT?"
			gv.up[f] = Upgrade.new(f, "s1n output","Joule LORED output x{e0}.", "jo")
			gv.up[f].effects.append(Effect.new("output", ["jo"], 1.45))
			gv.up["WATT?"].cost["iron"] = Ob.Num.new(3500.0)
			gv.up["WATT?"].cost["cop"] = Ob.Num.new(3500.0)
			gv.up[f].requires.append("MIXER")
			
			f = "CHEEKS"
			gv.up[f] = Upgrade.new(f, "s1n output","Oil LORED output x{e0}.", "oil")
			gv.up[f].effects.append(Effect.new("output", ["oil"], 1.5))
			gv.up["CHEEKS"].cost["coal"] = Ob.Num.new(30000.0)
			gv.up["CHEEKS"].cost["stone"] = Ob.Num.new(200000.0)
			gv.up["CHEEKS"].cost["iron"] = Ob.Num.new(120000.0)
			gv.up["CHEEKS"].cost["cop"] = Ob.Num.new(40000.0)
			gv.up["CHEEKS"].cost["growth"] = Ob.Num.new(1500.0)
			gv.up["CHEEKS"].cost["conc"] = Ob.Num.new(5000.0)
			gv.up["CHEEKS"].cost["malig"] = Ob.Num.new(15.0)
			gv.up["CHEEKS"].cost["oil"] = Ob.Num.new(1.0)
			gv.up[f].requires.append("SALT")
	
	# upburn
	if true:
		
		# s2m
		if true:
			
			f = "Sick of the Sun"
			gv.up[f] = Upgrade.new(f, "s2m burn", "Stage 2 inputs x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("input", gv.stats.g_list["s2"], 0.9, "all"))
			gv.up[f].cost["tum"] = Ob.Num.new("5e20")
			gv.up[f].requires.append("ONE PUNCH")
			
			f = "I Disagree"
			gv.up[f] = Upgrade.new(f, "s2m burn", "Stage 2 inputs x{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("input", gv.stats.g_list["s2"], 0.9, "all"))
			gv.up[f].cost["tum"] = Ob.Num.new("3e18") # million
			gv.up[f].requires.append("is it SUPPOSED to be stick dudes?")
			
			# benefits s1
			if true:
				
				f = "KETO"
				gv.up[f] = Upgrade.new(f, "s2m burn","Iron LORED Iron Ore input x{e0};\nCopper LORED Copper Ore input x{e1}.", "irono")
				gv.up[f].effects.append(Effect.new("input", ["iron"], 0.01, "irono"))
				gv.up[f].effects.append(Effect.new("input", ["cop"], 0.01, "copo"))
				gv.up[f].cost["tum"] = Ob.Num.new("3e13") # m
				gv.up[f].requires.append("THE WITCH OF LOREDELITH")
		
		# s2n
		if true:
			
			f = "Fleeormp"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Lead LORED Galena input x{e0}.","gale")
			gv.up[f].effects.append(Effect.new("input", ["lead"], 0.8, "gale"))
			gv.up[f].cost["gale"] = Ob.Num.new("100e6")
			gv.up[f].cost["lead"] = Ob.Num.new("80e6")
			gv.up[f].cost["wire"] = Ob.Num.new("50e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "Squeeomp"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Plastic LORED Petroleum input x{e0}.", "pet")
			gv.up[f].effects.append(Effect.new("input", ["plast"], 0.85, "pet"))
			gv.up[f].cost["toba"] = Ob.Num.new("12e9")
			gv.up[f].cost["carc"] = Ob.Num.new("3e9")
			gv.up[f].requires.append("Toriyama")
			
			f = "Barely Wood by Now"
			gv.up[f] = Upgrade.new(f, "s2n burn","Hardwood LORED Wood input x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("input", ["hard"], 0.8, "wood"))
			gv.up[f].cost["steel"] = Ob.Num.new("15e9")
			gv.up[f].cost["carc"] = Ob.Num.new("1e9")
			gv.up[f].requires.append("Hardwood Yo Mama")
			
			f = "MAGNETIC ACCELERATOR"
			gv.up[f] = Upgrade.new(f, "s2n burn","Glass LORED Sand input x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("input", ["glass"], 0.8, "sand"))
			gv.up[f].cost["wire"] = Ob.Num.new("750e6") #mil
			gv.up[f].cost["carc"] = Ob.Num.new("25e6") #mil
			gv.up[f].requires.append("MGALEKGOLO")
			
			f = "POTENT"
			gv.up[f] = Upgrade.new(f, "s2n burn","Tobacco LORED Water input x{e0}.", "toba")
			gv.up[f].effects.append(Effect.new("input", ["toba"], 0.85, "water"))
			gv.up[f].cost["seed"] = Ob.Num.new("30e6")
			gv.up[f].cost["paper"] = Ob.Num.new("45e6")
			gv.up[f].cost["soil"] = Ob.Num.new("60e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "Hardwood Yo Mama"
			gv.up[f] = Upgrade.new(f, "s2n burn","Axe LORED Hardwood input x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("input", ["axe"], 0.8, "hard"))
			gv.up[f].cost["steel"] = Ob.Num.new("750e6")
			gv.up[f].cost["carc"] = Ob.Num.new("25e6")
			gv.up[f].requires.append("ERECTWOOD")
			
			f = "Steel Yo Mama"
			gv.up[f] = Upgrade.new(f, "s2n burn","Steel LORED Liquid Iron input x{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("input", ["steel"], 0.85, "liq"))
			gv.up[f].cost["glass"] = Ob.Num.new("750e6")
			gv.up[f].cost["carc"] = Ob.Num.new("25e6")
			gv.up[f].requires.append("Steely Dan")
			
			f = "PULLEY"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Wire LORED Draw Plate input x{e0}.", "draw")
			gv.up[f].effects.append(Effect.new("input", ["wire"], 0.9, "draw"))
			gv.up[f].cost["hard"] = Ob.Num.new("95e6")
			gv.up[f].cost["carc"] = Ob.Num.new("1e6")
			gv.up[f].requires.append("Where's the boy, String?")
			
			f = "Light as a Feather"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Axe LORED Steel input x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("input", ["axe"], 0.9, "steel"))
			gv.up[f].cost["draw"] = Ob.Num.new("10e6")
			gv.up[f].cost["carc"] = Ob.Num.new("10e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "Squeeormp"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Plastic LORED Petroleum input x{e0}.", "plast")
			gv.up[f].effects.append(Effect.new("input", ["plast"], 0.9, "pet"))
			gv.up[f].cost["carc"] = Ob.Num.new(100000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Sandal Flandals"
			gv.up[f] = Upgrade.new(f, "s2n burn","Sand LORED Humus input x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("input", ["sand"], 0.8, "humus"))
			gv.up[f].cost["sand"] = Ob.Num.new(100000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(10000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "VIRILE"
			gv.up[f] = Upgrade.new(f, "s2n burn","Tobacco LORED Seed input x{e0}.", "seed")
			gv.up[f].effects.append(Effect.new("input", ["toba"], 0.85, "seed"))
			gv.up[f].cost["ciga"] = Ob.Num.new(50000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(1500.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Lembas Water"
			gv.up[f] = Upgrade.new(f, "s2n burn","Tree LORED Water input x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("input", ["tree"], 0.8, "water"))
			gv.up[f].cost["toba"] = Ob.Num.new(45.0)
			gv.up[f].cost["water"] = Ob.Num.new(300.0)
			gv.up[f].requires.append("Sagan")
			
			f = "This Might Pay Off Someday"
			gv.up[f] = Upgrade.new(f, "s2n burn","Liquid Iron LORED Iron input x{e0}.", "iron")
			gv.up[f].effects.append(Effect.new("input", ["liq"], 0.9, "iron"))
			gv.up[f].cost["iron"] = Ob.Num.new("1e6")
			
			f = "Steel Yourself"
			gv.up[f] = Upgrade.new(f, "s2n burn","Steel LORED Liquid Iron input x{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("input", ["steel"], 0.9, "liq"))
			gv.up[f].cost["glass"] = Ob.Num.new(200.0)
			gv.up[f].requires.append("Carlin")
			
			f = "Decisive Strikes"
			gv.up[f] = Upgrade.new(f, "s2n burn","Wood LORED Axes input x{e0}.", "wood")
			gv.up[f].effects.append(Effect.new("input", ["wood"], 0.9, "axe"))
			gv.up[f].cost["wire"] = Ob.Num.new(350.0)
			gv.up[f].cost["glass"] = Ob.Num.new(425.0)
			gv.up[f].cost["soil"] = Ob.Num.new(500.0)
			
			f = "Hardwood Yourself"
			gv.up[f] = Upgrade.new(f, "s2n burn","Axe LORED Hardwood input x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("input", ["axe"], 0.8, "hard"))
			gv.up[f].cost["steel"] = Ob.Num.new(185.0)
			gv.up[f].requires.append("Carlin")
			
			f = "2552"
			gv.up[f] = Upgrade.new(f, "s2n burn","Glass LORED Sand input x{e0}.", "sand")
			gv.up[f].effects.append(Effect.new("input", ["glass"], 0.85, "sand"))
			gv.up[f].cost["wire"] = Ob.Num.new(750.0)
			gv.up[f].cost["carc"] = Ob.Num.new(25.0)
			gv.up[f].requires.append("PLASMA BOMBARDMENT")
			
			f = "Quormps"
			gv.up[f] = Upgrade.new(f, "s2n burn","Steel LORED Liquid Iron input x{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("input", ["steel"], 0.85, "liq"))
			gv.up[f].cost["glass"] = Ob.Num.new(4500.0)
			gv.up[f].cost["carc"] = Ob.Num.new(200.0)
			gv.up[f].requires.append("Quamps")
			
			f = "Cutting Corners"
			gv.up[f] = Upgrade.new(f, "s2n burn","Hardwood LORED Wood input x{e0}.", "wood")
			gv.up[f].effects.append(Effect.new("input", ["hard"], 0.85, "wood"))
			gv.up[f].cost["steel"] = Ob.Num.new(5500.0)
			gv.up[f].cost["carc"] = Ob.Num.new(200.0)
			gv.up[f].requires.append("Millery")
			
			f = "Bigger Trees I Guess"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Wood LORED Tree input x{e0}.", "tree")
			gv.up[f].effects.append(Effect.new("input", ["wood"], 0.9, "tree"))
			gv.up[f].cost["plast"] = Ob.Num.new(10000.0)
			gv.up[f].cost["pulp"] = Ob.Num.new(1000.0)
			gv.up[f].requires.append("Sagan")
			
			f = "Hole Geometry"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Wire LORED Draw Plate input x{e0}.", "draw")
			gv.up[f].effects.append(Effect.new("input", ["wire"], 0.9, "draw"))
			gv.up[f].cost["pulp"] = Ob.Num.new(10000.0)
			gv.up[f].cost["hard"] = Ob.Num.new(5200.0)
			gv.up[f].cost["carc"] = Ob.Num.new(200.0)
			gv.up[f].requires.append("GIMP")
			
			f = "Flippy Floppies"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Sand LORED Humus input x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("input", ["sand"], 0.9, "humus"))
			gv.up[f].cost["carc"] = Ob.Num.new(850.0)
			gv.up[f].requires.append("Unpredictable Weather")
		
		# s1n
		if true:
			
			f = "STICKYTAR"
			gv.up[f] = Upgrade.new(f, "s1n burn","Malignancy LORED Tarball input x{e0}.", "malig")
			gv.up[f].effects.append(Effect.new("input", ["malig"], 0.5, "tar"))
			gv.up[f].cost["growth"] = Ob.Num.new(1400.0)
			gv.up[f].cost["oil"] = Ob.Num.new(75.0)
			gv.up[f].requires.append("SLIMER")
	
	# upcrit
	if true:
		
		# s2m
		if true:
			
			f = "BLAM this piece of crap!"
			gv.up[f] = Upgrade.new(f, "s2m crit buff","Stage 2 +{e0}% crit chance.", "s2")
			gv.up[f].effects.append(Effect.new("crit", gv.stats.g_list["s2"]))
			gv.up[f].cost["tum"] = Ob.Num.new("27e18")
			gv.up[f].requires.append("HOME-RUN BAT")
			
			f = "is it SUPPOSED to be stick dudes?"
			gv.up[f] = Upgrade.new(f, "s2m crit buff","Stage 2 +{e0}% crit chance.", "s2")
			gv.up[f].effects.append(Effect.new("crit", gv.stats.g_list["s2"]))
			gv.up[f].cost["tum"] = Ob.Num.new("1e18") # million
			gv.up[f].requires.append("Tolkien")
		
		# s2n
		if true:
			
			f = "FINISH THE FIGHT"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Humus, Sand, and Glass LORED +{e0}% crit chance.", "glass")
			gv.up[f].effects.append(Effect.new("crit", ["humus","sand","glass"]))
			gv.up[f].cost["wire"] = Ob.Num.new("1e12") # t
			gv.up[f].cost["carc"] = Ob.Num.new("250e9")
			gv.up[f].requires.append("O'SALVATORI")
			
			f = "MICROSOFT PAINT"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Draw Plate and Wire LORED +{e0}% crit chance.", "wire")
			gv.up[f].effects.append(Effect.new("crit", ["draw","wire"]))
			gv.up[f].cost["hard"] = Ob.Num.new("1e12")
			gv.up[f].cost["carc"] = Ob.Num.new("250e9")
			gv.up[f].requires.append("low rises")
			
			f = "i'll show you hardwood"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Axe, Wood, and Hardwood LORED +{e0}% crit chance.", "hard")
			gv.up[f].effects.append(Effect.new("crit", ["axe","wood","hard"]))
			gv.up[f].cost["steel"] = Ob.Num.new("1e12") # t
			gv.up[f].cost["carc"] = Ob.Num.new("250e9")
			gv.up[f].requires.append("Barely Wood by Now")
			
			f = "Steel Lord"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Liquid Iron and Steel LORED +{e0}% crit chance.", "steel")
			gv.up[f].effects.append(Effect.new("crit", ["liq","steel"]))
			gv.up[f].cost["glass"] = Ob.Num.new("1e12") # t
			gv.up[f].cost["carc"] = Ob.Num.new("250e9")
			gv.up[f].requires.append("Fingers of Onden")
			
			f = "O'SALVATORI"
			gv.up[f] = Upgrade.new(f, "s2n crit","Glass LORED +{e0}% crit chance.", "glass")
			gv.up[f].effects.append(Effect.new("crit", ["glass"], 5.0))
			gv.up[f].cost["wire"] = Ob.Num.new("15e9")
			gv.up[f].cost["carc"] = Ob.Num.new("1e9")
			gv.up[f].requires.append("MAGNETIC ACCELERATOR")
			
			f = "a bee with tiny daggers!!!"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Seed LORED +{e0}% crit chance.", "abeewithdaggers")
			gv.up[f].effects.append(Effect.new("crit", ["seed"]))
			gv.up[f].cost["water"] = Ob.Num.new("1e9")
			gv.up[f].cost["seed"] = Ob.Num.new("25e6")
			gv.up[f].cost["carc"] = Ob.Num.new("10e6")
			gv.up[f].requires.append("Busy Bee")
			
			f = "Toriyama"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Stage 2 +{e0}% crit chance.", "s2")
			gv.up[f].effects.append(Effect.new("crit", gv.stats.g_list["s2"]))
			gv.up[f].cost["steel"] = Ob.Num.new("1e9") # bil
			gv.up[f].cost["hard"] = Ob.Num.new("1e9") # bil
			gv.up[f].cost["wire"] = Ob.Num.new("1e9") # bil
			gv.up[f].cost["glass"] = Ob.Num.new("1e9") # bil
			gv.up[f].cost["carc"] = Ob.Num.new("50e6") # mil
			gv.up[f].requires.append("Le Guin")
			
			f = "Steely Dan"
			gv.up[f] = Upgrade.new(f, "s2n crit","Steel LORED +{e0}% crit chance.", "steel")
			gv.up[f].effects.append(Effect.new("crit", ["steel"], 7.0))
			gv.up[f].cost["glass"] = Ob.Num.new("3e7")
			gv.up[f].cost["carc"] = Ob.Num.new("1e6")
			gv.up[f].requires.append("Expert Iron Worker")
			
			f = "INDEPENDENCE"
			gv.up[f] = Upgrade.new(f, "s2n crit","Lead LORED +{e0}% crit chance.", "lead")
			gv.up[f].effects.append(Effect.new("crit", ["lead"], 10.0))
			gv.up[f].cost["gale"] = Ob.Num.new(450000.0)
			gv.up[f].cost["lead"] = Ob.Num.new(450000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(10000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Nikey Wikeys"
			gv.up[f] = Upgrade.new(f, "s2n crit","Humus LORED +{e0}% crit chance.", "humus")
			gv.up[f].effects.append(Effect.new("crit", ["humus"], 7.0))
			gv.up[f].cost["soil"] = Ob.Num.new("1e6")
			gv.up[f].cost["carc"] = Ob.Num.new(10000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Unpredictable Weather"
			gv.up[f] = Upgrade.new(f, "s2n crit","Water LORED +{e0}% crit chance.", "water")
			gv.up[f].effects.append(Effect.new("crit", ["water"], 8.0))
			gv.up[f].cost["wire"] = Ob.Num.new(1000.0)
			gv.up[f].cost["glass"] = Ob.Num.new(1000.0)
			gv.up[f].cost["tree"] = Ob.Num.new(2500.0)
			gv.up[f].cost["carc"] = Ob.Num.new(35.0)
			gv.up[f].requires.append("BREAK THE DAM")
			
			f = "Rogue Blacksmith"
			gv.up[f] = Upgrade.new(f, "s2n crit","Liquid Iron LORED +{e0}% crit chance.", "liq")
			gv.up[f].effects.append(Effect.new("crit", ["liq"], 6.0))
			gv.up[f].cost["wire"] = Ob.Num.new(1000.0)
			gv.up[f].cost["glass"] = Ob.Num.new(1000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(35.0)
			gv.up[f].requires.append("Apprentice Iron Worker")
			
			f = "Apprentice Iron Worker"
			gv.up[f] = Upgrade.new(f, "s2n crit","Liquid Iron LORED +{e0}% crit chance.", "liq")
			gv.up[f].effects.append(Effect.new("crit", ["liq"], 6.0))
			gv.up[f].cost["steel"] = Ob.Num.new(25.0)
			
			f = "Cioran"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Stage 2 +{e0}% crit chance.", "s2")
			gv.up[f].effects.append(Effect.new("crit", gv.stats.g_list["s2"]))
			gv.up[f].cost["carc"] = Ob.Num.new(1000.0)
			gv.up[f].cost["tum"] = Ob.Num.new(100.0)
			gv.up[f].requires.append("Sagan")
		
		# s1m
		if true:
			
			f = "THIS GAME IS SO ESEY"
			gv.up[f] = Upgrade.new(f, "s1m crit","Stage 1 +{e0}% crit chance.")
			gv.up[f].effects.append(Effect.new("crit", gv.stats.g_list["s1"], 5.0))
			gv.up[f].cost["malig"] = Ob.Num.new("50e15")
			gv.up[f].requires.append("SLUGGER")

			f = "how is this an RPG anyway?"
			gv.up[f] = Upgrade.new(f, "s1m crit","Stage 1 +{e0}% crit chance.")
			gv.up[f].effects.append(Effect.new("crit", gv.stats.g_list["s1"], 5.0))
			gv.up[f].cost["malig"] = Ob.Num.new(10 * 1000.0)
			gv.up[f].requires.append("SOCCER DUDE")
	
	# upbuff
	if true:
		
		# s2m
		if true:
			
			f = "axman23 by now"
			gv.up[f] = Upgrade.new(f, "s2m buff crit", "Any crit upgrade with a value of +1% or less (base) +{e0}%.", "s2")
			gv.up[f].effects.append(Effect.new("buff crit", [], 2.0))
			gv.up[f].cost["tum"] = Ob.Num.new("1e21") # b
			gv.up[f].requires.append("Sick of the Sun")
			
			f = "HOME-RUN BAT"
			gv.up[f] = Upgrade.new(f, "s2m buff output", "Any output upgrade with a value of +1 or less (base) +{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("buff output", [], 2.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new("9e18") # bil
			gv.up[f].requires.append("I Disagree")
			
			f = "DOT DOT DOT"
			gv.up[f] = Upgrade.new(f, "s2m buff crit", "Any crit upgrade with a value of +1% or less (base) +{e0}%.", "s2")
			gv.up[f].effects.append(Effect.new("buff crit", []))
			gv.up[f].cost["tum"] = Ob.Num.new("60e18")
			gv.up[f].requires.append("BLAM this piece of crap!")
			
			f = "Tolkien"
			gv.up[f] = Upgrade.new(f, "s2m buff output", "Any output upgrade with a value of +1 or less (base) +{e0}.", "s2")
			gv.up[f].effects.append(Effect.new("buff output", [], 1.0, "", false))
			gv.up[f].cost["tum"] = Ob.Num.new("1e12")
		
		# s2n
		if true:
			
			f = "Le Guin"
			gv.up[f] = Upgrade.new(f, "s2n buff haste", "Any haste upgrade with a multiplier of 1.1 or less (base) gets multiplied by {e0}.", "s2")
			gv.up[f].effects.append(Effect.new("buff haste", [], 1.1))
			gv.up[f].cost["carc"] = Ob.Num.new("1e6") # mil
			gv.up[f].cost["tum"] = Ob.Num.new(100000)
			gv.up[f].requires.append("Cioran")
	
	# upmisc
	if true:
		
		# s2mup
		if true:
			
			# limit break
			if true:
				
				f = "upgrade_description"
				gv.up[f] = Upgrade.new(f, "s2m misc", "Reduces the cost increase of every LORED by 10%; LORED fuel drain x{e0}.", "s2")
				gv.up[f].effects.append(Effect.new("drain", gv.g.keys(), 2.0))
				gv.up[f].cost["tum"] = Ob.Num.new("1e24")
				gv.up[f].requires.append("Tolkien")
				
				f = "Limit Break"
				gv.up[f] = Upgrade.new(f, "s2m lbmult", "Whenever a LORED produces a resource, it charges Limit Break by an equal amount. Limit Break acts as an output modifier for every Stage 1 and Stage 2 LORED.", "s2")
				gv.up[f].effects.append(Effect.new("output", gv.stats.g_list["s1"] + gv.stats.g_list["s2"]))
				gv.up[f].cost["tum"] = Ob.Num.new("1e3")
				gv.up[f].effects[0].dynamic = true
			
			f = "dust"
			gv.up[f] = Upgrade.new(f, "s2m misc","Metastasizing no longer resets Stage 1 LORED levels.", "s1")
			gv.up[f].cost["tum"] = Ob.Num.new("3e14")
			gv.up[f].requires.append("the athore coments al totol lies!")
			gv.up[f].requires.append("IT'S SPREADIN ON ME")
			
			f = "what in cousin-fuckin tarnation alabama betty crocker miss fuckin betty white shit is this"
			gv.up[f] = Upgrade.new(f, "s2m cremover","Your Tarball LORED no longer costs Malignancy.", "tar")
			gv.up[f].effects.append(Effect.new("cremover", ["tar"], gv.g["tar"].cost["malig"].b.toFloat(), "malig"))
			gv.up[f].cost["tum"] = Ob.Num.new("5e13")
			gv.up[f].requires.append("KETO")
			
			f = "CONDUCT"
			gv.up[f] = Upgrade.new(f, "s2m misc","Metastasizing no longer resets Stage 1 resources.", "s1m")
			gv.up[f].cost["tum"] = Ob.Num.new("1e15") # mil
			
			f = "CAPITAL PUNISHMENT"
			gv.up[f] = Upgrade.new(f, "s2m misc","Tumor gain from Malignant upgrade PROCEDURE is multiplied by your Stage 1 run count.", "s1m")
			gv.up[f].cost["tum"] = Ob.Num.new("3e14")
			gv.up[f].requires.append("what in cousin-fuckin tarnation alabama betty crocker miss fuckin betty white shit is this")
			gv.up[f].requires.append("IT'S SPREADIN ON ME")
			
			f = "IT'S SPREADIN ON ME"
			gv.up[f] = Upgrade.new(f, "s2m output","Malignant upgrade IT'S GROWIN ON ME now always applies its buff to both your Iron AND Copper LOREDs, as well as your Iron Ore and Copper Ore LOREDs.", "growth")
			gv.up[f].effects.append(Effect.new("output", ["irono"]))
			gv.up[f].effects[0].dynamic = true
			gv.up[f].effects.append(Effect.new("output", ["copo"]))
			gv.up[f].effects[1].dynamic = true
			gv.up[f].cost["tum"] = Ob.Num.new("8e13") # mil
			gv.up[f].requires.append("AUTO-PERSIST")
			
			f = "the athore coments al totol lies!"
			gv.up[f] = Upgrade.new(f, "s2m misc","Stage 1 crits gain a 1% chance to crit.", "s1")
			gv.up[f].cost["tum"] = Ob.Num.new("2e13") # mil
			gv.up[f].requires.append("Elbow Straps")
			
			f = "don't take candy from babies"
			gv.up[f] = Upgrade.new(f, "s2m misc","Stage 2 and up LOREDs will not take fuel or resources from a Stage 1 LORED if it is below level 5.")
			gv.up[f].cost["tum"] = Ob.Num.new(1000)
			gv.up[f].requires.append("MECHANICAL")
			
			# benefits stage 1 only
			if true:
				
				f = "AUTO-PERSIST"
				gv.up[f] = Upgrade.new(f, "s2m saveup","Malignant autobuyer upgrades persist through Chemotherapy.", "malig")
				gv.up[f].effects.append(Effect.new("saveup", ["MOUND","SIDIUS IRON", "SLAPAPOW!","SENTIENT DERRICK", "CANKERITE", "wtf is that musk", "MOIST", "pippenpaddle- oppsoCOPolis", "AUTOPOLICE", "AUTOSTONER", "OREOREUHBor E ALICE", "AUTOSHOVELER"], 2))
				gv.up[f].cost["tum"] = Ob.Num.new("1e13")
				gv.up[f].requires.append("THE WITCH OF LOREDELITH")
				
				f = "THE WITCH OF LOREDELITH"
				gv.up[f] = Upgrade.new(f, "s2m misc","Stage 1 LOREDs gain Circe's powerful boon.", "thewitchofloredelith")
				gv.up[f].cost["tum"] = Ob.Num.new("1e12")
				
				f = "GRIMOIRE"
				gv.up[f] = Upgrade.new(f, "s2m misc","Radiative upgrade THE WITCH OF LOREDELITH percent modifier is affected by your Stage 1 run count.", "thewitchofloredelith")
				gv.up[f].requires.append("THE WITCH OF LOREDELITH")
				gv.up[f].cost["tum"] = Ob.Num.new("1e24")
		
		# s1m
		if true:
			
			f = "ROUTINE"
			gv.up[f] = Upgrade.new(f, "s1m misc","Metastasizes and then resets this upgrade. Additionally, Normal upgrades now persist through Metastasis.", "s1m")
			gv.up[f].cost["malig"] = Ob.Num.new("1e20")
			gv.up[f].requires.append("RED NECROMANCY")
			
			f = "PROCEDURE"
			var cock = Big.new("1e20").toString()
			gv.up[f] = Upgrade.new(f, "s1m misc","When Metastasizing, every " + cock + " Malignancy will reward you with 1,000x your Tumor LORED's output Tumors.", "tum")
			gv.up[f].cost["malig"] = Ob.Num.new("1e19")
			gv.up[f].requires.append("upgrade_name")
			
			f = "aw <3"
			gv.up[f] = Upgrade.new(f, "s1m misc","Start the game with a free Coal LORED.", "coal")
			gv.up[f].cost["malig"] = Ob.Num.new(2.0)
			gv.up[f].requires.append("ENTHUSIASM")
			
			f = "THE THIRD"
			gv.up[f] = Upgrade.new(f, "s1m misc","Whenever your Copper Ore LORED produces ore, it will produce an equal amount of Copper.", "copo")
			gv.up[f].cost["malig"] = Ob.Num.new("2e8")
			gv.up[f].requires.append("pippenpaddle- oppsoCOPolis")
			
			f = "I RUN"
			gv.up[f] = Upgrade.new(f, "s1m misc","Whenever your Iron Ore LORED produces ore, it will produce an equal amount of Iron.", "irono")
			gv.up[f].cost["malig"] = Ob.Num.new("25e9")
			
			f = "wait that's not fair"
			gv.up[f] = Upgrade.new(f, "s1m misc","Whenever your Coal LORED produces Coal, it produces ten times as much Stone.", "stone")
			gv.up["wait that's not fair"].cost["malig"] = Ob.Num.new("1e18")
			
			f = "IT'S GROWIN ON ME"
			gv.up[f] = Upgrade.new(f, "s1m output","Whenever Growth is spawned, either your Iron or your Copper LORED will receive an output boost based on your Growth LORED's level.", "growth")
			gv.up[f].effects.append(Effect.new("output", ["iron"]))
			gv.up[f].effects[0].dynamic = true
			gv.up[f].effects.append(Effect.new("output", ["cop"]))
			gv.up[f].effects[1].dynamic = true
			gv.up[f].cost["malig"] = Ob.Num.new(2000.0)
			
			f = "upgrade_name"
			gv.up[f] = Upgrade.new(f, "s1m misc","Reduces the cost increase of every Stage 1 LORED from x3.0 to x2.75; Stage 1 burner LORED fuel drain x{e0}.", "s1")
			gv.up[f].effects.append(Effect.new("drain", ["coal", "irono", "stone", "copo", "iron", "cop", "conc", "jo", "oil"], 10.0))
			gv.up[f].cost["malig"] = Ob.Num.new("25e6")
			gv.up[f].requires.append("ORE LORD")

func init_quests():
	
	for q in gv.Quest.values():
		if q == gv.Quest.RANDOM:
			break
		gv.quest.append(Task.new(q))


func setup():
	
	setup_loreds()
	setup_upgrades()

func setup_loreds():
	
	gv.g["blood"].speed.b = 40.0
	gv.g["necro"].speed.b = 1.0
	gv.g["hunt"].speed.b = 40.0
	gv.g["witch"].speed.b = 40.0
	
	# task_list
	if true:
		
		gv.g["hunt"].task_list.append("hunt beast")
		
		gv.g["necro"].task_list.append("resurrect corpse")
		
		gv.g["blood"].task_list.append("process growth")
		
		gv.g["witch"].task_list.append("cast hex")
		
		if gv.s3_time:
			
			#gv.g["witch"].inventory[gv.Item.PARTS].a(0)
			
			gv.g["hunt"].task_list.append("use water flasks")
			
			gv.g["blood"].task_list.append("sacrifice own blood")
			gv.g["blood"].task_list.append("exsanguinate nearly dead")
			gv.g["blood"].task_list.append("exsanguinate beast body")
			gv.g["blood"].task_list.append("process tumors")
			
			gv.g["necro"].task_list.append("debone defiled dead")
			gv.g["necro"].task_list.append("debone exsanguinated beast")
			gv.g["necro"].task_list.append("flay corpse")
			gv.g["necro"].task_list.append("resurrect flayed corpse")
	
	# things that cannot be done in cLORED.gd _init()
	
	for x in gv.g:
		
		for v in gv.g:
			if gv.g[v].b.size() == 0: continue
			if not x in gv.g[v].b.keys(): continue
			gv.g[x].used_by.append(v)
	
	gv.stats.g_list["rare quest whitelist"] = gv.stats.g_list["s1"] + gv.stats.g_list["s2"]
	for x in ["plast", "jo", "coal", "irono", "copo", "oil", "tar", "growth", "draw", "humus", "sand", "gale", "pulp", "paper", "soil", "toba", "tree"]:
		gv.stats.g_list["rare quest whitelist"].erase(x)

func setup_upgrades():
	
	for x in gv.up:
		
		var n_or_m = "n" if gv.up[x].normal else "m"
		
		if not "reset" in gv.up[x].type:
			gv.stats.up_list["s" + gv.up[x].type[1]].append(x)
			gv.stats.up_list["s" + gv.up[x].type[1] + n_or_m].append(x)
			if gv.up[x].normal:
				gv.stats.up_list["unowned s" + gv.up[x].type[1] + "n"].append(x)
		
		if "autob" in gv.up[x].type:
			gv.up[x].desc.base = "Unlocks the Autobuyer for your " + gv.g[gv.up[x].icon].name + " LORED."
		
		gv.up[x].name = x
		gv.up[x].color = gv.COLORS[gv.up[x].icon] if gv.up[x].icon in gv.COLORS else gv.COLORS["s" + gv.up[x].type[1] + n_or_m]
		
		var uplistkey = gv.up[x].type.split(" ", true, 1)[1]
		if not uplistkey in gv.stats.up_list.keys():
			gv.stats.up_list[uplistkey] = []
		gv.stats.up_list[uplistkey].append(x)
		
		for v in gv.up:
			if v == x:
				continue
			if x in gv.up[v].requires:
				gv.up[x].required_by.append(v)
	
	for c in gv.chains:
		for x in gv.chains[c].chain_keys:
			gv.up[x].chain_length = gv.chains[c].chain_keys.size()
			gv.up[x].chain_key = c
	
	gv.up["RED NECROMANCY"].effects.append(Effect.new("autoup", gv.stats.up_list["s1m"]))
	gv.up["Now That's What I'm Talkin About, YeeeeeeaaaaaaaAAAAAAGGGGGHHH"].effects.append(Effect.new("autoup", gv.stats.up_list["s2n"]))
	gv.up["we were so close, now you don't even think about me"].effects.append(Effect.new("autoup", gv.stats.up_list["s1n"]))
	gv.up["ROUTINE"].effects.append(Effect.new("saveup", gv.stats.up_list["s1n"], 2))
	
	for x in gv.up:
		if gv.up[x].requires.size() == 0:
			gv.up[x].unlocked = true
		gv.up[x].sync()
