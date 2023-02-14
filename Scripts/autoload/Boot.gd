extends Node



func go():
	init()
	setup()


func init():
	
	init_loreds()
	init_list()
	init_upgrades()
	
	#initSaveShit here?

func init_list():
	for lored in lv.lored:
		gv.list.lored[lv.lored[lored].tab].append(lored)

func init_loreds():
	lv.open()
	pass


func init_upgrades():
	
	var f: String
	
	# upreset
	if true:
		
		f = "CHEMOTHERAPY"
		gv.up[f] = Upgrade.new(f, "s2m reset", "Resets Normal, Malignant, and Extra-normal upgrades, and Stage 1 and Stage 2 resources (except Tumors).\n\nBegin your recovery period. Apply your Radiative upgrades to your new life.", "tum")
		
		f = "METASTASIZE"
		gv.up[f] = Upgrade.new(f, "s1m reset","Resets Normal upgrades and Stage 1 resources (except Malignancy).", "malig")
	
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
			
			pass
#			f = "Incision"
#			gv.up[f] = Upgrade.new(f, "s3n task", "The Blood LORED will now sacrifice his own blood.", "tum")
#			gv.up[f].effects.append(Effect.new("task", ["blood"], 1, "sacrifice own blood"))
#			#gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e6")
#			#gv.up[f].requires.append("AUTOSENSU")
#
#			f = "blood 0"
	
	# upauto
	if true:
		
		# s2m
		if true:
			
			# lored
			if true:
				
				f = "Sudden Commission"
				gv.up[f] = Upgrade.new(f, "s2m autob", "literally doesn't fucking matter", "draw")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.DRAW_PLATE]))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e6") # k
				gv.up[f].requires.append("AUTOSENSU")
				
				f = "AUTOSENSU"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Wood if it won't cause Axe's net output to drop below 0.", "wood")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.WOOD]))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(160000) # bil
				gv.up[f].requires.append("AUTOSMITHY")
				
				f = "Master"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Sand if it won't cause Humus's net output to drop below 0.", "sand")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.SAND]))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e9") # k
				gv.up[f].requires.append("Sudden Commission")
				
				f = "AXELOT"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Axe if it won't cause Hardwood's net output to drop below 0.", "axe")
				gv.up[f].effects.append(Effect.new("autob",[lv.Type.AXES]))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["Master"].cost[gv.Resource.TUMORS].b).m(2 * 5))
				gv.up[f].requires.append("Master")
				
				f = "AUTOSHIT"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Humus if it won't cause Water's net output to drop below 0.", "humus")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.HUMUS]))
				gv.up[f].requires.append("AXELOT")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2)) # bil
				
				f = "Smashy Crashy"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Trees if his net output is less than 0.", "tree")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.TREES]))
				gv.up[f].requires.append("AUTOSHIT")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2)) # bil
				
				f = "A baby Roleum!! Thanks, pa!"
				gv.up[f] = Upgrade.new(f, "s2m autob", "AKJSLHDFKLJHASDFKL", "pet")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.PETROLEUM]))
				gv.up[f].requires.append("Smashy Crashy")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2)) # bil
				
				f = "poofy wizard boy"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Tobacco if his net output is less than 0.", "toba")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.TOBACCO]))
				gv.up[f].requires.append("A baby Roleum!! Thanks, pa!")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2)) # bil
				
				f = "BENEFIT"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Galena.", "gale")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.GALENA]))
				gv.up[f].requires.append("poofy wizard boy")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "AUTOAQUATICICIDE"
				gv.up[f] = Upgrade.new(f, "s2m autob", "AKJSLHDFKLJHASDFKL", "plast")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.PLASTIC]))
				gv.up[f].requires.append("BENEFIT")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "Go on, then, LEAD us!"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Lead if it won't cause Galena's net output to drop below 0.", "lead")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.LEAD]))
				gv.up[f].requires.append("AUTOAQUATICICIDE")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "BEEKEEPING"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Seeds if his net output is less than 0.", "seed")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.SEEDS]))
				gv.up[f].requires.append("Go on, then, LEAD us!")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "Scoopy Doopy"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Soil if it won't cause Humus's net output to drop below 0.", "soil")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.SOIL]))
				gv.up[f].requires.append("BEEKEEPING")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "Master Iron Worker"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Steel if it won't cause Liquid Iron's net output to drop below 0.", "steel")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.STEEL]))
				gv.up[f].requires.append("Scoopy Doopy")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "JOINTSHACK"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Paper if his net output is less than 0.", "paper")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.PAPER]))
				gv.up[f].requires.append("Master Iron Worker")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "AROUSAL"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Hardwood if it won't cause Wood's net output to drop below 0.", "hard")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.HARDWOOD]))
				gv.up[f].requires.append("JOINTSHACK")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "autofloof"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Wood Pulp if his net output is less than 0.", "pulp")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.WOOD_PULP]))
				gv.up[f].requires.append("AROUSAL")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "ELECTRONIC CIRCUITS"
				gv.up[f] = Upgrade.new(f, "s2m autob", "AKJSLHDFKLJHASDFKL", "wire")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.WIRE]))
				gv.up[f].requires.append("autofloof")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "AUTOBADDECISIONMAKER"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Cigarettes if his net output is less than 0.", "ciga")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.CIGARETTES]))
				gv.up[f].requires.append("ELECTRONIC CIRCUITS")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "PILLAR OF AUTUMN"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Glass if it won't cause Sand's net output to drop below 0.", "glass")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.GLASS]))
				gv.up[f].requires.append("AUTOBADDECISIONMAKER")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(200))
				
				f = "what kind of resource is 'tumors', you hack fraud"
				gv.up[f] = Upgrade.new(f, "s2m autob", "AKJSLHDFKLJHASDFKL", "tum")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.TUMORS]))
				gv.up[f].requires.append("PILLAR OF AUTUMN")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "DEVOUR"
				gv.up[f] = Upgrade.new(f, "s2m autob", "AKJSLHDFKLJHASDFKL", "carc")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.CARCINOGENS]))
				gv.up[f].requires.append("what kind of resource is 'tumors', you hack fraud")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b).m(2))
				
				f = "Splishy Splashy"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Water.", "water")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.WATER]))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(4000.0)
				
				f = "AUTOSMITHY"
				gv.up[f] = Upgrade.new(f, "s2m autob", "Automatically purchases Liquid Iron.", "liq")
				gv.up[f].effects.append(Effect.new("autob", [lv.Type.LIQUID_IRON]))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(8000.0)
				gv.up[f].requires.append("Splishy Splashy")
			
			# upgr
			if true:
				
				f = "Now That's What I'm Talkin About, YeeeeeeaaaaaaaAAAAAAGGGGGHHH"
				gv.up[f] = Upgrade.new(f, "s2m autoup", "Automatically purchases Extra-normal upgrades. Does not work until most of the Stage 2 LOREDs are at least level 1.", gv.Tab.S2)
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e12")
				gv.up[f].requires.append("THE WITCH OF LOREDELITH")
				
				# works on s1
				if true:
					
					f = "RED NECROMANCY"
					gv.up[f] = Upgrade.new(f, "s2m autoup", "Automatically purchases Malignant upgrades.", gv.Tab.MALIGNANT)
					gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e24")
					gv.up[f].requires.append("THE WITCH OF LOREDELITH")
		
		# s1m
		if true:
			
			f = "we were so close, now you don't even think about me"
			gv.up[f] = Upgrade.new(f, "s1m autoup", "Automatically purchases Normal upgrades.", gv.Tab.NORMAL)
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("1e6")
			gv.up[f].requires.append("how is this an RPG anyway?")
			
			f = "SENTIENT DERRICK"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases Oil if their net output is less than 0.", "oil")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.OIL]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("85e10")
			
			f = "SLAPAPOW!"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases Tarballs if his net output is less than 0.", "tar")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.TARBALLS]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("17e11")
			
			f = "MOUND"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases Malignancy.", "malig")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.MALIGNANCY]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("35e12")
			
			f = "wtf is that musk"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases Joules if his net output is less than 0.", "jo")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.JOULES]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("43e7")
			
			f = "CANKERITE"
			gv.up[f] = Upgrade.new(f, "s1m autob","Automatically purchases Concrete if his output is less than Stone's output.","conc")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.CONCRETE]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("15e9")
			
			f = "MOIST"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases Growth.", "growth")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.GROWTH]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("12e6")
			
			f = "AUTOPOLICE"
			gv.up[f] = Upgrade.new(f, "s1m autob", "asdf", "cop")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.COPPER]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(140000.0)
			
			f = "SIDIUS IRON"
			gv.up[f] = Upgrade.new(f, "s1m autob", "asd", "iron")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.IRON]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("8e12")
			
			f = "pippenpaddle- oppsoCOPolis"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases Copper Ore if his net output is less than 0.", "copo")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.COPPER_ORE]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(600000.0)
			
			f = "OREOREUHBor E ALICE"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases Iron Ore if his net output is less than 0.", "irono")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.IRON_ORE]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(12000.0)
			
			f = "AUTOSTONER"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases Stone.", "stone")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.STONE]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(35000.0)
			
			f = "AUTOSHOVELER"
			gv.up[f] = Upgrade.new(f, "s1m autob", "Automatically purchases Coal if his net output is less than 0.", "coal")
			gv.up[f].effects.append(Effect.new("autob", [lv.Type.COAL]))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(1500.0)
	
	# upcost
	if true:
		
		# s2m
		if true:
			
			f = "Mudslide"
			gv.up[f] = Upgrade.new(f, "s2m cost","Humus's Glass cost x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("cost", [lv.Type.HUMUS], 0.75, gv.Resource.GLASS))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e7")
			
			f = "The Great Journey"
			gv.up[f] = Upgrade.new(f, "s2m cost","Glass's Steel cost x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("cost", [lv.Type.GLASS], 0.8, gv.Resource.STEEL))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e7")
			
			f = "BEAVER"
			gv.up[f] = Upgrade.new(f, "s2m cost","Water's Wood cost x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("cost", [lv.Type.WATER], 0.8, gv.Resource.WOOD))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e7")
			
			f = "mods enabled"
			gv.up[f] = Upgrade.new(f, "s2m cost","Petroleum's Glass cost x{e0}.", "pet")
			gv.up[f].effects.append(Effect.new("cost", [lv.Type.PETROLEUM], 0.75, gv.Resource.GLASS))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e7")
		
		# s1m
		if true:
			
			f = "FOOD TRUCKS"
			gv.up[f] = Upgrade.new(f, "s1m cost", "All Stage 1 costs x{e0}.")
			gv.up[f].effects.append(Effect.new("cost", gv.list.lored[gv.Tab.S1], 0.5, "all"))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("1e13") # 10e12
			gv.up[f].requires.append("upgrade_name")
			
			f = "CON-FRICKIN-CRETE"
			gv.up[f] = Upgrade.new(f, "s1m cost", "Oil's Concrete cost x{e0}.", "oil")
			gv.up[f].effects.append(Effect.new("cost", [lv.Type.OIL], 0.5, gv.Resource.CONCRETE))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(12000.0)
			
			f = "COMPULSORY JUICE"
			gv.up[f] = Upgrade.new(f, "s1m cost", "Iron Ore and Copper Ore's Stone costs x{e0}.", "stone")
			gv.up[f].effects.append(Effect.new("cost", [lv.Type.IRON_ORE, lv.Type.COPPER_ORE], 0.5, gv.Resource.STONE))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(50000.0)
			gv.up[f].requires.append("AUTOSTONER")
	
	# uphaste
	if true:
		
		# s2m
		if true:
			
			f = "Covenant Dance"
			gv.up[f] = Upgrade.new(f, "s2m haste","Humus haste x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.HUMUS], 1.5))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e7")
			gv.up[f].requires.append("PEPPERMINT MOCHA")
			
			f = "Overtime"
			gv.up[f] = Upgrade.new(f, "s2m haste","Liquid Iron haste x{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.LIQUID_IRON], 1.5))
			gv.up[f].requires.append("Covenant Dance")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b.m(2))
			
			f = "Bone Meal"
			gv.up[f] = Upgrade.new(f, "s2m haste","Tree haste x{e0}.", "tree")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.TREES], 1.5))
			gv.up[f].requires.append("Overtime")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b.m(2))
			
			f = "SILLY"
			gv.up[f] = Upgrade.new(f, "s2m haste","Hardwood haste x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.HARDWOOD], 1.5))
			gv.up[f].requires.append("Bone Meal")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b.m(2))
			
			f = "PLATE"
			gv.up[f] = Upgrade.new(f, "s2m haste","Steel haste x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.STEEL], 1.5))
			gv.up[f].requires.append("SILLY")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b.m(2))
			
			f = "Child Energy"
			gv.up[f] = Upgrade.new(f, "s2m haste","Soil haste x{e0}.", "soil")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.SOIL], 1.5))
			gv.up[f].requires.append("PLATE")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b.m(2))
			
			f = "Erebor"
			gv.up[f] = Upgrade.new(f, "s2m haste","Galena haste x{e0}.", "gale")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.GALENA], 1.5))
			gv.up[f].requires.append("Child Energy")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b.m(2))
			
			f = "SPEED DOODS"
			gv.up[f] = Upgrade.new(f, "s2m haste","Draw Plate haste x{e0}.", "draw")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.DRAW_PLATE], 1.5))
			gv.up[f].requires.append("Erebor")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(gv.up[gv.up[f].requires[0]].cost[gv.Resource.TUMORS].b.m(2))
			
			f = "MILK"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S2], 1.1))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(2000)
			
			f = "GATORADE"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S2], 1.1))
			gv.up[f].requires.append("MILK")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["MILK"].cost[gv.Resource.TUMORS].b).m(5))
			
			f = "APPLE JUICE"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S2], 1.1))
			gv.up[f].requires.append("GATORADE")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["GATORADE"].cost[gv.Resource.TUMORS].b).m(6 * 10))
			
			f = "PEPPERMINT MOCHA"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S2], 1.1))
			gv.up[f].requires.append("APPLE JUICE")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["APPLE JUICE"].cost[gv.Resource.TUMORS].b).m(3))
			
			f = "STRAWBERRY BANANA SMOOTHIE"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S2], 1.1))
			gv.up[f].requires.append("PEPPERMINT MOCHA")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["PEPPERMINT MOCHA"].cost[gv.Resource.TUMORS].b).m(3 * 100))
			
			f = "GREEN TEA"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S2], 1.1))
			gv.up[f].requires.append("STRAWBERRY BANANA SMOOTHIE")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["STRAWBERRY BANANA SMOOTHIE"].cost[gv.Resource.TUMORS].b).m(3))
			
			f = "FRENCH VANILLA"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S2], 1.1))
			gv.up[f].requires.append("GREEN TEA")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["GREEN TEA"].cost[gv.Resource.TUMORS].b).m(3))
			
			f = "WATER"
			gv.up[f] = Upgrade.new(f, "s2m haste buff","Stage 2 haste x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S2], 1.1))
			gv.up[f].requires.append("FRENCH VANILLA")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["FRENCH VANILLA"].cost[gv.Resource.TUMORS].b).m(3))
		
		# s2n
		if true:
			
			f = "SPOOLY"
			gv.up[f] = Upgrade.new(f, "s2n haste","Wire haste x{e0}.", "wire")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.WIRE], 1.25))
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new("750e6")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("25e6")
			gv.up[f].requires.append("PULLEY")
			
			f = "Utter Molester Champ"
			gv.up[f] = Upgrade.new(f, "s2n haste","Petroleum haste x{e0}.", "pet")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.PETROLEUM], 1.15))
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(100000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "CANCER'S REAL COOL"
			gv.up[f] = Upgrade.new(f, "s2n haste","Tumor haste x{e0}.", "tum")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.TUMORS], 1.25))
			gv.up[f].cost[gv.Resource.WATER] = Ob.Num.new(150000.0)
			gv.up[f].cost[gv.Resource.TREES] = Ob.Num.new(150000.0)
			gv.up[f].cost[gv.Resource.HUMUS] = Ob.Num.new(150000.0)
			gv.up[f].cost[gv.Resource.AXES] = Ob.Num.new(150000.0)
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(150000.0)
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(150000.0)
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new(150000.0)
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new(150000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(150000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Wood Lord"
			gv.up[f] = Upgrade.new(f, "s2n haste","Axe, Wood, and Hardwood haste x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.AXES, lv.Type.WOOD, lv.Type.HARDWOOD], 1.15))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new(35000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("Cutting Corners")
			
			f = "Expert Iron Worker"
			gv.up[f] = Upgrade.new(f, "s2n haste","Liquid Iron and Steel haste x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.LIQUID_IRON, lv.Type.STEEL], 1.15))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(40000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("Quormps")
			
			f = "Where's the boy, String?"
			gv.up[f] = Upgrade.new(f, "s2n haste","Draw Plate and Wire haste x{e0}.", "wire")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.DRAW_PLATE, lv.Type.WIRE], 1.15))
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new(35000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("Hole Geometry")
			
			f = "They've Always Been Faster"
			gv.up[f] = Upgrade.new(f, "s2n haste","Humus, Sand, and Glass haste x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.HUMUS, lv.Type.SAND, lv.Type.GLASS], 1.15))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(75000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("Kilty Sbark")
			
			f = "Sp0oKy"
			gv.up[f] = Upgrade.new(f, "s2n haste","Carcinogen haste x{e0}.", "carc")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.CARCINOGENS], 1.15))
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(1000.0)
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("Cioran")
			
			f = "RAIN DANCE"
			gv.up[f] = Upgrade.new(f, "s2n haste","Water haste x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.WATER], 1.2))
			gv.up[f].cost[gv.Resource.SAND] = Ob.Num.new(40.0)
			
			f = "BREAK THE DAM"
			gv.up[f] = Upgrade.new(f, "s2n haste","Water haste x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.WATER], 1.25))
			gv.up[f].cost[gv.Resource.LIQUID_IRON] = Ob.Num.new(30.0)
			gv.up[f].requires.append("RAIN DANCE")
			
			f = "Carlin"
			gv.up[f] = Upgrade.new(f, "s2n haste buff","Stage 2 haste x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S2], 1.05))
			gv.up[f].cost[gv.Resource.LEAD] = Ob.Num.new(600.0)
			
			f = "Sagan"
			gv.up[f] = Upgrade.new(f, "s2n haste buff","Stage 2 haste x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S2], 1.05))
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(5.0)
			gv.up[f].requires.append("Carlin")

			f = "Patreon Artist"
			gv.up[f] = Upgrade.new(f, "s2n haste","Wire haste x{e0}.", "wire")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.WIRE], 1.2))
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new(200.0)
			gv.up[f].requires.append("Carlin")

			f = "LIGHTHOUSE"
			gv.up[f] = Upgrade.new(f, "s2n haste","Sand haste x{e0}.", "sand")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.SAND], 1.15))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(130.0)

			f = "Woodthirsty"
			gv.up[f] = Upgrade.new(f, "s2n haste","Axe haste x{e0}.", "axe")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.AXES], 1.3))
			gv.up[f].cost[gv.Resource.WOOD] = Ob.Num.new(800.0)
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new(100.0)

			f = "Woodiac Chopper"
			gv.up[f] = Upgrade.new(f, "s2n haste","Axe haste x{e0}.", "axe")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.AXES], 1.4))
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(50.0)
			gv.up[f].requires.append("Seeing Brown")

			f = "Millery"
			gv.up[f] = Upgrade.new(f, "s2n haste","Hardwood haste x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.HARDWOOD], 1.25))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new(385.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(25.0)
			gv.up[f].requires.append("Hardwood Yourself")

			f = "Quamps"
			gv.up[f] = Upgrade.new(f, "s2n haste","Steel haste x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.STEEL], 1.35))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(600.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(25.0)
			gv.up[f].requires.append("Steel Yourself")

			f = "Kilty Sbark"
			gv.up[f] = Upgrade.new(f, "s2n haste","Glass haste x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.GLASS], 1.15))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(6500.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(200.0)
			gv.up[f].requires.append("2552")

			f = "Dirt Collection Rewards Program"
			gv.up[f] = Upgrade.new(f, "s2n haste","Humus haste x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.HUMUS], 1.25))
			gv.up[f].cost[gv.Resource.SOIL] = Ob.Num.new(25000.0)
			gv.up[f].cost[gv.Resource.LEAD] = Ob.Num.new(25000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(350.0)
		
		# s1m
		if true: # mup
			
			f = "MALEVOLENT"
			gv.up[f] = Upgrade.new(f, "s1m haste","Tar, Concrete, and Malignancy haste x{e0}.", "malig")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.TARBALLS, lv.Type.CONCRETE, lv.Type.MALIGNANCY], 4.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("1e24")
			gv.up[f].requires.append("MOUND")
			
			f = "OH, BABY, A TRIPLE"
			gv.up[f] = Upgrade.new(f, "s1m haste","Tarball haste x{e0}.", "tar")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.TARBALLS], 3.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(55000.0)
			gv.up[f].requires.append("you little hard worker, you")
			
			f = "STAY QUENCHED"
			gv.up[f] = Upgrade.new(f, "s1m haste","Coal and Joule haste x{e0}.", "jo")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.COAL, lv.Type.JOULES], 1.8))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(60000.0)
			gv.up[f].requires.append("you little hard worker, you")

			f = "CANCER'S COOL"
			gv.up[f] = Upgrade.new(f, "s1m haste","Growth and Malignancy haste x{e0}.", "malig")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.GROWTH, lv.Type.MALIGNANCY], 2.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("3e9")
			gv.up[f].requires.append("MOIST")

			f = "you little hard worker, you"
			gv.up[f] = Upgrade.new(f, "s1m haste","Stone and Concrete haste x{e0}.", "conc")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.STONE, lv.Type.CONCRETE], 2.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(40000.0)

			f = "ORE LORD"
			gv.up[f] = Upgrade.new(f, "s1m haste","Iron Ore, Copper Ore, Iron, and Copper haste x{e0}.")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.IRON_ORE, lv.Type.COPPER_ORE, lv.Type.IRON, lv.Type.COPPER], 2.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("1e6")
			gv.up[f].requires.append("BIG TOUGH BOY")

			f = "OPPAI GUY"
			gv.up[f] = Upgrade.new(f, "s1m haste","Stage 1 haste x{e0}.")
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S1], 2.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("1e15")
			gv.up[f].requires.append("FOOD TRUCKS")

			f = "SOCCER DUDE"
			gv.up[f] = Upgrade.new(f, "s1m haste","Stage 1 haste x{e0}.")
			gv.up[f].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S1], 2.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(1600.0)
			
			f = "coal DUDE"
			gv.up[f] = Upgrade.new(f, "s1m haste","Coal haste x{e0}.", "coal")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.COAL], 2.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("1e11")
		
		# n
		if true:
			
			f = "GRINDER"
			gv.up[f] = Upgrade.new(f, "s1n haste","Stone haste x{e0}.", "stone")
			gv.up[f].cost[gv.Resource.STONE] = Ob.Num.new(90.0)
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.STONE], 1.25))
			
			f = "SLOP"
			gv.up[f] = Upgrade.new(f, "s1n haste", "Growth haste x{e0}.", "growth")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.GROWTH], 1.95))
			gv.up[f].cost[gv.Resource.STONE] = Ob.Num.new("1e6")
			gv.up[f].requires.append("SLIMER")
			
			f = "SLIMER"
			gv.up[f] = Upgrade.new(f, "s1n haste", "Growth haste x{e0}.", "growth")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.GROWTH], 1.5))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(150.0)
			gv.up[f].requires.append("RYE")

			f = "GRANDER"
			gv.up[f] = Upgrade.new(f, "s1n haste", "Stone haste x{e0}.", "stone")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.STONE], 1.3))
			gv.up[f].cost[gv.Resource.COAL] = Ob.Num.new(400.0)
			gv.up[f].requires.append("GRINDER")

			f = "LIGHTER SHOVEL"
			gv.up[f] = Upgrade.new(f, "s1n haste","Coal haste x{e0}.", "coal")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.COAL], 1.2))
			gv.up[f].cost[gv.Resource.COPPER] = Ob.Num.new(155.0)
			gv.up[f].requires.append("GRINDER")

			f = "GROUNDER"
			gv.up[f] = Upgrade.new(f, "s1n haste","Stone haste x{e0}.", "stone")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.STONE], 1.35))
			gv.up[f].cost[gv.Resource.GROWTH] = Ob.Num.new(100.0)
			gv.up[f].cost[gv.Resource.JOULES] = Ob.Num.new(100.0)
			gv.up[f].requires.append("GRANDPA")

			f = "GRANDMA"
			gv.up[f] = Upgrade.new(f, "s1n haste","Stone haste x{e0}.", "stone")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.STONE], 1.3))
			gv.up[f].cost[gv.Resource.IRON] = Ob.Num.new(400.0)
			gv.up[f].cost[gv.Resource.COPPER] = Ob.Num.new(400.0)
			gv.up[f].cost[gv.Resource.CONCRETE] = Ob.Num.new(20.0)
			gv.up[f].requires.append("GRANDER")
			
			f = "MIXER"
			gv.up[f] = Upgrade.new(f, "s1n haste","Concrete haste x{e0}.", "conc")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.CONCRETE], 1.5))
			gv.up[f].cost[gv.Resource.CONCRETE] = Ob.Num.new(11.0)
			gv.up[f].requires.append("RYE")
			
			f = "SWIRLER"
			gv.up[f] = Upgrade.new(f, "s1n haste","Concrete haste x{e0}.", "conc")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.CONCRETE], 1.5))
			gv.up[f].cost[gv.Resource.COAL] = Ob.Num.new(9500.0)
			gv.up[f].cost[gv.Resource.STONE] = Ob.Num.new(6000.0)
			gv.up[f].requires.append("MIXER")
			
			f = "SAALNDT"
			gv.up[f] = Upgrade.new(f, "s1n haste","Iron Ore and Copper Ore haste x{e0}.", "irono")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.IRON_ORE, lv.Type.COPPER_ORE], 1.5))
			gv.up[f].cost[gv.Resource.IRON_ORE] = Ob.Num.new(1500.0)
			gv.up[f].cost[gv.Resource.COPPER_ORE] = Ob.Num.new(1500.0)
			gv.up[f].requires.append("GRINDER")

			f = "ANCHOVE COVE"
			gv.up[f] = Upgrade.new(f, "s1n haste","Iron Ore and Copper Ore haste x{e0}.", "copo")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.IRON_ORE, lv.Type.COPPER_ORE], 2.0))
			gv.up[f].cost[gv.Resource.IRON_ORE] = Ob.Num.new(450000.0)
			gv.up[f].cost[gv.Resource.COPPER_ORE] = Ob.Num.new(450000.0)
			gv.up[f].requires.append("SAALNDT")

			f = "FLANK"
			gv.up[f] = Upgrade.new(f, "s1n haste","Iron haste x{e0}.", "iron")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.IRON], 1.4))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(125.0)
			gv.up[f].requires.append("SALT")

			f = "TEXAS"
			gv.up[f] = Upgrade.new(f, "s1n haste","Iron haste x{e0}.", "iron")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.IRON], 1.25))
			gv.up[f].cost[gv.Resource.GROWTH] = Ob.Num.new(30.0)
			gv.up[f].cost[gv.Resource.COPPER] = Ob.Num.new(400.0)
			gv.up[f].requires.append("RYE")
			
			f = "SAND"
			gv.up[f] = Upgrade.new(f, "s1n haste","Copper haste x{e0}.", "cop")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.COPPER], 1.25))
			gv.up[f].cost[gv.Resource.GROWTH] = Ob.Num.new(200.0)
			gv.up[f].requires.append("RYE")
			
			f = "RYE"
			gv.up[f] = Upgrade.new(f, "s1n haste","Copper haste x{e0}.", "cop")
			gv.up[f].effects.append(Effect.new("haste", [lv.Type.COPPER], 1.25))
			gv.up[f].cost[gv.Resource.GROWTH] = Ob.Num.new(3.0)
			gv.up[f].cost[gv.Resource.IRON] = Ob.Num.new(100.0)
			gv.up[f].requires.append("GRINDER")
	
	# upout
	if true:
		
		# s2m
		if true:
			
			f = "Cthaeh"
			gv.up[f] = Upgrade.new(f, "s2m output","Trees output x{e0}.", "tree")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.TREES], 10.0))
			gv.up[f].requires.append("axman23 by now")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("5e21") # e12
			
			f = "ONE PUNCH"
			gv.up[f] = Upgrade.new(f, "s2m output", "Stage 2 output x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S2], 1.5))
			gv.up[f].requires.append("DOT DOT DOT")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e20") # b
			
			f = "FALCON PAWNCH"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S2], 1.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(1250)
			
			f = "KAIO-KEN"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S2], 1.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["FALCON PAWNCH"].cost[gv.Resource.TUMORS].b).m(5))
			gv.up[f].requires.append("FALCON PAWNCH")
			
			f = "DANCE OF THE FIRE GOD"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S2], 1.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["KAIO-KEN"].cost[gv.Resource.TUMORS].b).m(6 * 12))
			gv.up[f].requires.append("KAIO-KEN")
			
			f = "RASENGAN"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S2], 1.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["DANCE OF THE FIRE GOD"].cost[gv.Resource.TUMORS].b).m(3))
			gv.up[f].requires.append("DANCE OF THE FIRE GOD")
			
			f = "AVATAR STATE"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S2], 1.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["RASENGAN"].cost[gv.Resource.TUMORS].b).m(3 * 100)) # 1.01mil
			gv.up[f].requires.append("RASENGAN")
			
			f = "HAMON"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S2], 1.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["AVATAR STATE"].cost[gv.Resource.TUMORS].b).m(3))
			gv.up[f].requires.append("AVATAR STATE")
			
			f = "METAL CAP"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S2], 1.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["HAMON"].cost[gv.Resource.TUMORS].b).m(3))
			gv.up[f].requires.append("HAMON")
			
			f = "STAR ROD"
			gv.up[f] = Upgrade.new(f, "s2m output buff","Stage 2 base output +{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S2], 1.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(Big.new(gv.up["METAL CAP"].cost[gv.Resource.TUMORS].b).m(3))
			gv.up[f].requires.append("METAL CAP")
			
			# s1 only
			if true:
				
				f = "Elbow Straps"
				gv.up[f] = Upgrade.new(f, "s2m output buff","Coal base output +{e0}.", "coal")
				gv.up[f].effects.append(Effect.new("output", [lv.Type.COAL], 1.0, "", false))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("3e12")
				gv.up[f].requires.append("THE WITCH OF LOREDELITH")
				
				f = "MECHANICAL"
				gv.up[f] = Upgrade.new(f, "s2m output","Stage 1 output and input x{e0}.")
				gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S1], 2.0))
				gv.up[f].effects.append(Effect.new("input", gv.list.lored[gv.Tab.S1], 2.0))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(250)
				
				f = "SPEED-SHOPPER"
				gv.up[f] = Upgrade.new(f, "s2m output","Stage 1 output and input x{e0}.")
				gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S1], 2.0))
				gv.up[f].effects.append(Effect.new("input", gv.list.lored[gv.Tab.S1], 2.0))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("35000")
				gv.up[f].requires.append("don't take candy from babies")
		
		# s2n
		if true:
			
			f = "John Peter Bain, TotalBiscuit"
			gv.up[f] = Upgrade.new(f, "s2n output", "Stage 2 output x{e0}.\n\"[i]I am here to ask and answer one simple question: WTF is LORED?\"[/i]", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S2], 2.0))
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("1e12") # t
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("10e9")
			gv.up[f].requires.append("Toriyama")
			
			f = "Ultra Shitstinct"
			gv.up[f] = Upgrade.new(f, "s2n output","Humus output and input x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.HUMUS], 1.35))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.HUMUS], 1.35))
			gv.up[f].cost[gv.Resource.WATER] = Ob.Num.new("1e9")
			gv.up[f].cost[gv.Resource.SEEDS] = Ob.Num.new("25e6")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("10e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "BURDENED"
			gv.up[f] = Upgrade.new(f, "s2n output buff","Lead base output +{e0}.", "lead")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.LEAD], 1.0, "", false))
			gv.up[f].cost[gv.Resource.HUMUS] = Ob.Num.new("10e9")
			gv.up[f].cost[gv.Resource.WOOD_PULP] = Ob.Num.new("4e9")
			gv.up[f].cost[gv.Resource.PAPER] = Ob.Num.new(1)
			gv.up[f].requires.append("Toriyama")
			
			f = "low rises"
			gv.up[f] = Upgrade.new(f, "s2n output","Wire output x{e0}.", "wire")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.WIRE], 1.35))
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new("10e9")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("1e9")
			gv.up[f].requires.append("SPOOLY")
			
			f = "Fingers of Onden"
			gv.up[f] = Upgrade.new(f, "s2n output","Steel output and input x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.STEEL], 1.25))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.STEEL], 1.25))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new("15e9")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("1e9")
			gv.up[f].requires.append("Steel Yo Mama")
			
			f = "Busy Bee"
			gv.up[f] = Upgrade.new(f, "s2n output","Seed output and input x{e0}.", "seed")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.SEEDS], 1.3))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.SEEDS], 1.3))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new("10e6")
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new("15e6")
			gv.up[f].cost[gv.Resource.LEAD] = Ob.Num.new("50e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "DINDER MUFFLIN"
			gv.up[f] = Upgrade.new(f, "s2n output","Paper output and input x{e0}.", "paper")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.PAPER], 1.25))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.PAPER], 1.25))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new("100e6")
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new("150e6")
			gv.up[f].cost[gv.Resource.LEAD] = Ob.Num.new("500e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "MGALEKGOLO"
			gv.up[f] = Upgrade.new(f, "s2n output","Glass output and input x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.GLASS], 1.3))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.GLASS], 1.3))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new("80e6")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("1e6")
			gv.up[f].requires.append("They've Always Been Faster")
			
			f = "Power Barrels"
			gv.up[f] = Upgrade.new(f, "s2n output","Liquid Iron output x{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.LIQUID_IRON], 1.2))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new("100e6")
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new("25e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "And this is to go even further beyond!"
			gv.up[f] = Upgrade.new(f, "s2n output","Wood output and input x{e0}.", "wood")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.WOOD], 1.25))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.WOOD], 1.25))
			gv.up[f].cost[gv.Resource.PAPER] = Ob.Num.new("1e7")
			gv.up[f].cost[gv.Resource.WOOD_PULP] = Ob.Num.new("3e7")
			gv.up[f].cost[gv.Resource.WATER] = Ob.Num.new("25e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "ERECTWOOD"
			gv.up[f] = Upgrade.new(f, "s2n output","Hardwood output and input x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.HARDWOOD], 1.3))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.HARDWOOD], 1.3))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new("2e7")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("1e6")
			gv.up[f].requires.append("Wood Lord")
			
			f = "Glitterdelve"
			gv.up[f] = Upgrade.new(f, "s2n output","Galena output and input x{e0}.", "gale")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.GALENA], 1.25))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.GALENA], 1.25))
			gv.up[f].cost[gv.Resource.LEAD] = Ob.Num.new(100000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(8000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Longbottom Leaf"
			gv.up[f] = Upgrade.new(f, "s2n output","Tobacco output and input x{e0}.", "toba")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.TOBACCO], 1.25))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.TOBACCO], 1.25))
			gv.up[f].cost[gv.Resource.WOOD] = Ob.Num.new(500000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(5000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Factory Squirts"
			gv.up[f] = Upgrade.new(f, "s2n output","Petroleum output and input x{e0}.", "pet")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.PETROLEUM], 1.25))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.PETROLEUM], 1.25))
			gv.up[f].cost[gv.Resource.GROWTH] = Ob.Num.new("2e8")
			gv.up[f].cost[gv.Resource.LEAD] = Ob.Num.new(3000.0)
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(500.0)
			gv.up[f].requires.append("Cioran")
			
			f = "CANOPY"
			gv.up[f] = Upgrade.new(f, "s2n output","Water output x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.WATER], 1.25))
			gv.up[f].cost[gv.Resource.TREES] = Ob.Num.new(10.0)
			
			f = "EQUINE"
			gv.up[f] = Upgrade.new(f, "s2n output","Humus output and input x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.HUMUS], 1.3))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.HUMUS], 1.3))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(90.0)
			
			f = "PLASMA BOMBARDMENT"
			gv.up[f] = Upgrade.new(f, "s2n output","Glass output and input x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.GLASS], 1.25))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.GLASS], 1.25))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(310.0)
			gv.up[f].requires.append("Carlin")
			
			f = "Double Barrels"
			gv.up[f] = Upgrade.new(f, "s2n output buff","Liquid Iron base output +{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.LIQUID_IRON], 1.0, "", false))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(50.0)
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new(100.0)
			
			f = "Triple Barrels"
			gv.up[f] = Upgrade.new(f, "s2n output buff","Liquid Iron base output +{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.LIQUID_IRON], 1.0, "", false))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(350.0)
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new(100.0)
			gv.up[f].cost[gv.Resource.SOIL] = Ob.Num.new(250.0)
			gv.up[f].requires.append("Double Barrels")
			
			f = "Seeing Brown"
			gv.up[f] = Upgrade.new(f, "s2n output","Axe output and input x{e0}.", "axe")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.AXES], 1.25))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.AXES], 1.25))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(300.0)
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(300.0)
			gv.up[f].cost[gv.Resource.TREES] = Ob.Num.new(100.0)
			gv.up[f].requires.append("Woodthirsty")
			
			f = "GIMP"
			gv.up[f] = Upgrade.new(f, "s2n output","Wire output and input x{e0}.", "wire")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.WIRE], 1.3))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.WIRE], 1.3))
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new(900.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(25.0)
			gv.up[f].requires.append("Patreon Artist")
			
			f = "Henry Cavill"
			gv.up[f] = Upgrade.new(f, "s2n output","Water output x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.WATER], 1.3))
			gv.up[f].cost[gv.Resource.CIGARETTES] = Ob.Num.new(23.23)
			gv.up[f].cost[gv.Resource.WOOD_PULP] = Ob.Num.new(70.0)
			gv.up[f].requires.append("Sagan")
			
			f = "Journeyman Iron Worker"
			gv.up[f] = Upgrade.new(f, "s2n output","Liquid Iron and Steel output and input x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.LIQUID_IRON, lv.Type.STEEL], 1.3))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.LIQUID_IRON, lv.Type.STEEL], 1.3))
			gv.up[f].cost[gv.Resource.AXES] = Ob.Num.new(250.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(50.0)
			gv.up[f].requires.append("Sagan")
			
			f = "Soft and Smooth"
			gv.up[f] = Upgrade.new(f, "s2n output","Sand output and input x{e0}", "sand")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.SAND], 1.25))
			gv.up[f].effects.append(Effect.new("input", [lv.Type.SAND], 1.25))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new(4500.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(900.0)
			gv.up[f].requires.append("Unpredictable Weather")
		
		# s1mup
		if true:
			
			f = "I DRINK YOUR MILKSHAKE"
			gv.up[f] = Upgrade.new(f, "s1m output","Whenever a LORED takes coal, Coal gets an output boost.", "coal")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.COAL], 1.0, "", false))
			gv.up[f].effects[0].dynamic = true
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(800000.0)
			gv.up[f].requires.append("STAY QUENCHED")
			gv.up[f].saveEffects()
			
			f = "SLUGGER"
			gv.up[f] = Upgrade.new(f, "s1m output","Stage 1 output and input x{e0}.")
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S1], 2.0))
			gv.up[f].effects.append(Effect.new("input", gv.list.lored[gv.Tab.S1], 2.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("1e16")
			gv.up[f].requires.append("OPPAI GUY")
			
			f = "BIG TOUGH BOY"
			gv.up[f] = Upgrade.new(f, "s1m output","Stage 1 output and input x{e0}.")
			gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S1], 2.0))
			gv.up[f].effects.append(Effect.new("input", gv.list.lored[gv.Tab.S1], 2.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(175000.0)
			gv.up[f].requires.append("how is this an RPG anyway?")
			
			f = "ENTHUSIASM"
			gv.up[f] = Upgrade.new(f, "s1m output","Coal output x{e0}.", "coal")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.COAL], 1.25))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(3000.0)
			gv.up[f].requires.append("AUTOSHOVELER")
		
		# s1n
		if true:
			
			f = "INJECT"
			gv.up[f] = Upgrade.new(f, "s1n output buff","Tarballs base output +{e0}.", "tar")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.TARBALLS], 1.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(100.0)
			gv.up[f].requires.append("STICKYTAR")
			
			f = "GEARED OILS"
			gv.up[f] = Upgrade.new(f, "s1n output","Oil output x{e0}.", "oil")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.OIL], 2.0))
			gv.up[f].cost[gv.Resource.IRON] = Ob.Num.new("6e6")
			gv.up[f].requires.append("CHEEKS")
			
			f = "PEPPER"
			gv.up[f] = Upgrade.new(f, "s1n output","Iron Ore output x{e0}.", "irono")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.IRON_ORE], 10.0))
			gv.up[f].cost[gv.Resource.COPPER] = Ob.Num.new("25e9")
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("15e6")
			gv.up[f].requires.append("ANCHOVE COVE")
			
			f = "GARLIC"
			gv.up[f] = Upgrade.new(f, "s1n output","Copper Ore output x{e0}.", "copo")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.COPPER_ORE], 10.0))
			gv.up[f].cost[gv.Resource.IRON] = Ob.Num.new("25e9")
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("15e6")
			gv.up[f].requires.append("ANCHOVE COVE")
			
			f = "MUD"
			gv.up[f] = Upgrade.new(f, "s1n output","Iron Ore and Iron output x{e0}.", "iron")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.IRON_ORE, lv.Type.IRON], 1.75))
			gv.up[f].cost[gv.Resource.COPPER] = Ob.Num.new("2e6")
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(35000.0)
			gv.up[f].requires.append("RIB")
			
			f = "THYME"
			gv.up[f] = Upgrade.new(f, "s1n output","Copper Ore and Copper output x{e0}.", "cop")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.COPPER_ORE, lv.Type.COPPER], 1.75))
			gv.up[f].cost[gv.Resource.IRON] = Ob.Num.new("2e6")
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(35000.0)
			gv.up[f].requires.append("FLANK")
			
			f = "RED GOOPY BOY"
			gv.up[f] = Upgrade.new(f, "s1n output","Malignancy output x{e0}.", "malig")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.MALIGNANCY], 1.4))
			gv.up[f].cost[gv.Resource.IRON] = Ob.Num.new(30000.0)
			gv.up[f].cost[gv.Resource.COPPER] = Ob.Num.new(30000.0)
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(50.0)
			gv.up[f].requires.append("STICKYTAR")
			
			f = "SALT"
			gv.up[f] = Upgrade.new(f, "s1n output","Iron output x{e0}.", "iron")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.IRON], 1.25))
			gv.up[f].cost[gv.Resource.GROWTH] = Ob.Num.new(150.0)
			gv.up[f].requires.append("TEXAS")
			
			f = "RIB"
			gv.up[f] = Upgrade.new(f, "s1n output","Copper output x{e0}.", "cop")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.COPPER], 1.4))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(125.0)
			gv.up[f].requires.append("SALT")
			
			f = "GRANDPA"
			gv.up[f] = Upgrade.new(f, "s1n output","Stone output x{e0}.", "stone")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.STONE], 1.35))
			gv.up[f].cost[gv.Resource.IRON] = Ob.Num.new(2500.0)
			gv.up[f].cost[gv.Resource.COPPER] = Ob.Num.new(2500.0)
			gv.up[f].requires.append("GRANDMA")
			
			f = "MAXER"
			gv.up[f] = Upgrade.new(f, "s1n output","Concrete output x{e0}.", "conc")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.CONCRETE], 1.4))
			gv.up[f].cost[gv.Resource.GROWTH] = Ob.Num.new(400.0)
			gv.up[f].requires.append("SWIRLER")
			
			f = "WATT?"
			gv.up[f] = Upgrade.new(f, "s1n output","Joules output x{e0}.", "jo")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.JOULES], 1.45))
			gv.up[f].cost[gv.Resource.IRON] = Ob.Num.new(3500.0)
			gv.up[f].cost[gv.Resource.COPPER] = Ob.Num.new(3500.0)
			gv.up[f].requires.append("MIXER")
			
			f = "CHEEKS"
			gv.up[f] = Upgrade.new(f, "s1n output","Oil output x{e0}.", "oil")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.OIL], 1.5))
			gv.up[f].cost[gv.Resource.COAL] = Ob.Num.new(30000.0)
			gv.up[f].cost[gv.Resource.STONE] = Ob.Num.new(200000.0)
			gv.up[f].cost[gv.Resource.IRON] = Ob.Num.new(120000.0)
			gv.up[f].cost[gv.Resource.COPPER] = Ob.Num.new(40000.0)
			gv.up[f].cost[gv.Resource.GROWTH] = Ob.Num.new(1500.0)
			gv.up[f].cost[gv.Resource.CONCRETE] = Ob.Num.new(5000.0)
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(15.0)
			gv.up[f].cost[gv.Resource.OIL] = Ob.Num.new(1.0)
			gv.up[f].requires.append("SALT")
	
	# upburn
	if true:
		
		# s2m
		if true:
			
			f = "Sick of the Sun"
			gv.up[f] = Upgrade.new(f, "s2m burn", "Stage 2 inputs x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("input", gv.list.lored[gv.Tab.S2], 0.9, "all"))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("5e20")
			gv.up[f].requires.append("ONE PUNCH")
			
			f = "I Disagree"
			gv.up[f] = Upgrade.new(f, "s2m burn", "Stage 2 inputs x{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("input", gv.list.lored[gv.Tab.S2], 0.9, "all"))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("3e18") # million
			gv.up[f].requires.append("is it SUPPOSED to be stick dudes?")
			
			# benefits s1
			if true:
				
				f = "KETO"
				gv.up[f] = Upgrade.new(f, "s2m burn","Iron's Iron Ore input x{e0};\nCopper's Copper Ore input x{e1}.", "irono")
				gv.up[f].effects.append(Effect.new("input", [lv.Type.IRON], 0.01, "irono"))
				gv.up[f].effects.append(Effect.new("input", [lv.Type.COPPER], 0.01, "copo"))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("3e13") # m
				gv.up[f].requires.append("THE WITCH OF LOREDELITH")
		
		# s2n
		if true:
			
			f = "Fleeormp"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Lead's Galena input x{e0}.","gale")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.LEAD], 0.8, "gale"))
			gv.up[f].cost[gv.Resource.GALENA] = Ob.Num.new("100e6")
			gv.up[f].cost[gv.Resource.LEAD] = Ob.Num.new("80e6")
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new("50e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "Squeeomp"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Plastic's Petroleum input x{e0}.", "pet")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.PLASTIC], 0.85, "pet"))
			gv.up[f].cost[gv.Resource.TOBACCO] = Ob.Num.new("12e9")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("3e9")
			gv.up[f].requires.append("Toriyama")
			
			f = "Barely Wood by Now"
			gv.up[f] = Upgrade.new(f, "s2n burn","Hardwood's Wood input x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.HARDWOOD], 0.8, "wood"))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new("15e9")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("1e9")
			gv.up[f].requires.append("Hardwood Yo Mama")
			
			f = "MAGNETIC ACCELERATOR"
			gv.up[f] = Upgrade.new(f, "s2n burn","Glass's Sand input x{e0}.", "glass")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.GLASS], 0.8, "sand"))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new("750e6") #mil
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("25e6") #mil
			gv.up[f].requires.append("MGALEKGOLO")
			
			f = "POTENT"
			gv.up[f] = Upgrade.new(f, "s2n burn","Tobacco's Water input x{e0}.", "toba")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.TOBACCO], 0.85, "water"))
			gv.up[f].cost[gv.Resource.SEEDS] = Ob.Num.new("30e6")
			gv.up[f].cost[gv.Resource.PAPER] = Ob.Num.new("45e6")
			gv.up[f].cost[gv.Resource.SOIL] = Ob.Num.new("60e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "Hardwood Yo Mama"
			gv.up[f] = Upgrade.new(f, "s2n burn","Axe's Hardwood input x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.AXES], 0.8, "hard"))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new("750e6")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("25e6")
			gv.up[f].requires.append("ERECTWOOD")
			
			f = "Steel Yo Mama"
			gv.up[f] = Upgrade.new(f, "s2n burn","Steel's Liquid Iron input x{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.STEEL], 0.85, "liq"))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new("750e6")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("25e6")
			gv.up[f].requires.append("Steely Dan")
			
			f = "PULLEY"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Wire's Draw Plate input x{e0}.", "draw")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.WIRE], 0.9, "draw"))
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new("95e6")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("1e6")
			gv.up[f].requires.append("Where's the boy, String?")
			
			f = "Light as a Feather"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Axe's Steel input x{e0}.", "steel")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.AXES], 0.9, "steel"))
			gv.up[f].cost[gv.Resource.DRAW_PLATE] = Ob.Num.new("10e6")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("10e6")
			gv.up[f].requires.append("Le Guin")
			
			f = "Squeeormp"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Plastic's Petroleum input x{e0}.", "plast")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.PLASTIC], 0.9, "pet"))
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(100000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Sandal Flandals"
			gv.up[f] = Upgrade.new(f, "s2n burn","Sand's Humus input x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.SAND], 0.8, "humus"))
			gv.up[f].cost[gv.Resource.SAND] = Ob.Num.new(100000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(10000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "VIRILE"
			gv.up[f] = Upgrade.new(f, "s2n burn","Tobacco's Seed input x{e0}.", "seed")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.TOBACCO], 0.85, "seed"))
			gv.up[f].cost[gv.Resource.CIGARETTES] = Ob.Num.new(50000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(1500.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Lembas Water"
			gv.up[f] = Upgrade.new(f, "s2n burn","Tree's Water input x{e0}.", "water")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.TREES], 0.8, "water"))
			gv.up[f].cost[gv.Resource.TOBACCO] = Ob.Num.new(45.0)
			gv.up[f].cost[gv.Resource.WATER] = Ob.Num.new(300.0)
			gv.up[f].requires.append("Sagan")
			
			f = "This Might Pay Off Someday"
			gv.up[f] = Upgrade.new(f, "s2n burn","Liquid Iron's Iron input x{e0}.", "iron")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.LIQUID_IRON], 0.9, "iron"))
			gv.up[f].cost[gv.Resource.IRON] = Ob.Num.new("1e6")
			
			f = "Steel Yourself"
			gv.up[f] = Upgrade.new(f, "s2n burn","Steel's Liquid Iron input x{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.STEEL], 0.9, "liq"))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(200.0)
			gv.up[f].requires.append("Carlin")
			
			f = "Decisive Strikes"
			gv.up[f] = Upgrade.new(f, "s2n burn","Wood's Axe input x{e0}.", "wood")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.WOOD], 0.9, "axe"))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(350.0)
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(425.0)
			gv.up[f].cost[gv.Resource.SOIL] = Ob.Num.new(500.0)
			
			f = "Hardwood Yourself"
			gv.up[f] = Upgrade.new(f, "s2n burn","Axe's Hardwood input x{e0}.", "hard")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.AXES], 0.8, "hard"))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new(185.0)
			gv.up[f].requires.append("Carlin")
			
			f = "2552"
			gv.up[f] = Upgrade.new(f, "s2n burn","Glass's Sand input x{e0}.", "sand")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.GLASS], 0.85, "sand"))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(750.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(25.0)
			gv.up[f].requires.append("PLASMA BOMBARDMENT")
			
			f = "Quormps"
			gv.up[f] = Upgrade.new(f, "s2n burn","Steel's Liquid Iron input x{e0}.", "liq")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.STEEL], 0.85, "liq"))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(4500.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(200.0)
			gv.up[f].requires.append("Quamps")
			
			f = "Cutting Corners"
			gv.up[f] = Upgrade.new(f, "s2n burn","Hardwood's Wood input x{e0}.", "wood")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.HARDWOOD], 0.85, "wood"))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new(5500.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(200.0)
			gv.up[f].requires.append("Millery")
			
			f = "Bigger Trees I Guess"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Wood's Tree input x{e0}.", "tree")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.WOOD], 0.9, "tree"))
			gv.up[f].cost[gv.Resource.PLASTIC] = Ob.Num.new(10000.0)
			gv.up[f].cost[gv.Resource.WOOD_PULP] = Ob.Num.new(1000.0)
			gv.up[f].requires.append("Sagan")
			
			f = "Hole Geometry"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Wire's Draw Plate input x{e0}.", "draw")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.WIRE], 0.9, "draw"))
			gv.up[f].cost[gv.Resource.WOOD_PULP] = Ob.Num.new(10000.0)
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new(5200.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(200.0)
			gv.up[f].requires.append("GIMP")
			
			f = "Flippy Floppies"
			gv.up[f] = Upgrade.new(f, "s2n burn", "Sand's Humus input x{e0}.", "humus")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.SAND], 0.9, "humus"))
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(850.0)
			gv.up[f].requires.append("Unpredictable Weather")
		
		# s1n
		if true:
			
			f = "STICKYTAR"
			gv.up[f] = Upgrade.new(f, "s1n burn","Malignancy's Tarball input x{e0}.", "malig")
			gv.up[f].effects.append(Effect.new("input", [lv.Type.MALIGNANCY], 0.5, str(gv.Resource.TARBALLS)))
			gv.up[f].cost[gv.Resource.GROWTH] = Ob.Num.new(1400.0)
			gv.up[f].cost[gv.Resource.OIL] = Ob.Num.new(75.0)
			gv.up[f].requires.append("SLIMER")
	
	# upcrit
	if true:
		
		# s2m
		if true:
			
			f = "BLAM this piece of crap!"
			gv.up[f] = Upgrade.new(f, "s2m crit buff","Stage 2 +{e0}% crit chance.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("crit", gv.list.lored[gv.Tab.S2]))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("27e18")
			gv.up[f].requires.append("HOME-RUN BAT")
			
			f = "is it SUPPOSED to be stick dudes?"
			gv.up[f] = Upgrade.new(f, "s2m crit buff","Stage 2 +{e0}% crit chance.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("crit", gv.list.lored[gv.Tab.S2]))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e18") # million
			gv.up[f].requires.append("Tolkien")
		
		# s2n
		if true:
			
			f = "FINISH THE FIGHT"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Humus, Sand, and Glass crit chance +{e0}% .", "glass")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.HUMUS, lv.Type.SAND, lv.Type.GLASS]))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new("1e12") # t
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("250e9")
			gv.up[f].requires.append("O'SALVATORI")
			
			f = "MICROSOFT PAINT"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Draw Plate and Wire crit chance +{e0}% .", "wire")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.DRAW_PLATE, lv.Type.WIRE]))
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new("1e12")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("250e9")
			gv.up[f].requires.append("low rises")
			
			f = "i'll show you hardwood"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Axe, Wood, and Hardwood crit chance +{e0}%.", "hard")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.AXES, lv.Type.WOOD, lv.Type.HARDWOOD]))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new("1e12") # t
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("250e9")
			gv.up[f].requires.append("Barely Wood by Now")
			
			f = "Steel Lord"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Liquid Iron and Steel crit chance +{e0}%.", "steel")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.LIQUID_IRON, lv.Type.STEEL]))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new("1e12") # t
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("250e9")
			gv.up[f].requires.append("Fingers of Onden")
			
			f = "O'SALVATORI"
			gv.up[f] = Upgrade.new(f, "s2n crit","Glass crit chance +{e0}%.", "glass")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.GLASS], 5.0))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new("15e9")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("1e9")
			gv.up[f].requires.append("MAGNETIC ACCELERATOR")
			
			f = "a bee with tiny daggers!!!"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Seed crit chance +{e0}%.", "abeewithdaggers")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.SEEDS]))
			gv.up[f].cost[gv.Resource.WATER] = Ob.Num.new("1e9")
			gv.up[f].cost[gv.Resource.SEEDS] = Ob.Num.new("25e6")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("10e6")
			gv.up[f].requires.append("Busy Bee")
			
			f = "Toriyama"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Stage 2 crit chance +{e0}%.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("crit", gv.list.lored[gv.Tab.S2]))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new("1e9") # bil
			gv.up[f].cost[gv.Resource.HARDWOOD] = Ob.Num.new("1e9") # bil
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new("1e9") # bil
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new("1e9") # bil
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("50e6") # mil
			gv.up[f].requires.append("Le Guin")
			
			f = "Steely Dan"
			gv.up[f] = Upgrade.new(f, "s2n crit","Steel crit chance +{e0}%.", "steel")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.STEEL], 7.0))
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new("3e7")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("1e6")
			gv.up[f].requires.append("Expert Iron Worker")
			
			f = "INDEPENDENCE"
			gv.up[f] = Upgrade.new(f, "s2n crit","Lead crit chance +{e0}%.", "lead")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.LEAD], 10.0))
			gv.up[f].cost[gv.Resource.GALENA] = Ob.Num.new(450000.0)
			gv.up[f].cost[gv.Resource.LEAD] = Ob.Num.new(450000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(10000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Nikey Wikeys"
			gv.up[f] = Upgrade.new(f, "s2n crit","Humus crit chance +{e0}%.", "humus")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.HUMUS], 7.0))
			gv.up[f].cost[gv.Resource.SOIL] = Ob.Num.new("1e6")
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(10000.0)
			gv.up[f].requires.append("Cioran")
			
			f = "Unpredictable Weather"
			gv.up[f] = Upgrade.new(f, "s2n crit","Water crit chance +{e0}%.", "water")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.WATER], 8.0))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(1000.0)
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(1000.0)
			gv.up[f].cost[gv.Resource.TREES] = Ob.Num.new(2500.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(35.0)
			gv.up[f].requires.append("BREAK THE DAM")
			
			f = "Rogue Blacksmith"
			gv.up[f] = Upgrade.new(f, "s2n crit","Liquid Iron crit chance +{e0}%.", "liq")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.LIQUID_IRON], 6.0))
			gv.up[f].cost[gv.Resource.WIRE] = Ob.Num.new(1000.0)
			gv.up[f].cost[gv.Resource.GLASS] = Ob.Num.new(1000.0)
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(35.0)
			gv.up[f].requires.append("Apprentice Iron Worker")
			
			f = "Apprentice Iron Worker"
			gv.up[f] = Upgrade.new(f, "s2n crit","Liquid Iron crit chance +{e0}%.", "liq")
			gv.up[f].effects.append(Effect.new("crit", [lv.Type.LIQUID_IRON], 6.0))
			gv.up[f].cost[gv.Resource.STEEL] = Ob.Num.new(25.0)
			
			f = "Cioran"
			gv.up[f] = Upgrade.new(f, "s2n crit buff","Stage 2 crit chance +{e0}%.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("crit", gv.list.lored[gv.Tab.S2]))
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new(1000.0)
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(100.0)
			gv.up[f].requires.append("Sagan")
		
		# s1m
		if true:
			
			f = "THIS GAME IS SO ESEY"
			gv.up[f] = Upgrade.new(f, "s1m crit","Stage 1 crit chance +{e0}%.")
			gv.up[f].effects.append(Effect.new("crit", gv.list.lored[gv.Tab.S1], 5.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("50e15")
			gv.up[f].requires.append("SLUGGER")

			f = "how is this an RPG anyway?"
			gv.up[f] = Upgrade.new(f, "s1m crit","Stage 1 crit chance +{e0}%.")
			gv.up[f].effects.append(Effect.new("crit", gv.list.lored[gv.Tab.S1], 5.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(10 * 1000.0)
			gv.up[f].requires.append("SOCCER DUDE")
	
	# upbuff
	if true:
		
		# s2m
		if true:
			
			f = "axman23 by now"
			gv.up[f] = Upgrade.new(f, "s2m buff crit", "Any crit upgrade with a value of +1% or less (base) +{e0}%.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("buff crit", [], 2.0))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e21") # b
			gv.up[f].requires.append("Sick of the Sun")
			
			f = "HOME-RUN BAT"
			gv.up[f] = Upgrade.new(f, "s2m buff output", "Any output upgrade with a value of +1 or less (base) +{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("buff output", [], 2.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("9e18") # bil
			gv.up[f].requires.append("I Disagree")
			
			f = "DOT DOT DOT"
			gv.up[f] = Upgrade.new(f, "s2m buff crit", "Any crit upgrade with a value of +1% or less (base) +{e0}%.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("buff crit", []))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("60e18")
			gv.up[f].requires.append("BLAM this piece of crap!")
			
			f = "Tolkien"
			gv.up[f] = Upgrade.new(f, "s2m buff output", "Any output upgrade with a value of +1 or less (base) +{e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("buff output", [], 1.0, "", false))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e12")
		
		# s2n
		if true:
			
			f = "Le Guin"
			gv.up[f] = Upgrade.new(f, "s2n buff haste", "Any haste upgrade with a multiplier of 1.1 or less (base) gets multiplied by {e0}.", gv.Tab.S2)
			gv.up[f].effects.append(Effect.new("buff haste", [], 1.1))
			gv.up[f].cost[gv.Resource.CARCINOGENS] = Ob.Num.new("1e6") # mil
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(100000)
			gv.up[f].requires.append("Cioran")
	
	# upmisc
	if true:
		
		# s2mup
		if true:
			
			# limit break
			if true:
				
				f = "upgrade_description"
				gv.up[f] = Upgrade.new(f, "s2m misc", "Reduces the cost increase of every Stage 1 and 2 LORED by 10%; LORED fuel drain x{e0}.", gv.Tab.S2)
				gv.up[f].effects.append(Effect.new("drain", lv.lored.keys(), 2.0))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e24")
				gv.up[f].requires.append("Tolkien")
				
				f = "Limit Break"
				gv.up[f] = Upgrade.new(f, "s2m lbmult", "Whenever a LORED produces a resource, they will charge Limit Break by an equal amount. Limit Break acts as an output modifier for every Stage 1 and Stage 2 LORED.", gv.Tab.S2)
				gv.up[f].effects.append(Effect.new("output", gv.list.lored[gv.Tab.S1] + gv.list.lored[gv.Tab.S2]))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e3")
				gv.up[f].effects[0].dynamic = true
				gv.up[f].saveEffects()
			
			f = "dust"
			gv.up[f] = Upgrade.new(f, "s2m misc","Metastasizing no longer resets Stage 1 LORED levels.", gv.Tab.S1)
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("3e14")
			gv.up[f].requires.append("the athore coments al totol lies!")
			gv.up[f].requires.append("IT'S SPREADIN ON ME")
			
			f = "what in cousin-fuckin tarnation alabama betty crocker miss fuckin betty white shit is this"
			gv.up[f] = Upgrade.new(f, "s2m cremover","Upgrading Tarballs no longer costs Malignancy.", "tar")
			gv.up[f].effects.append(Effect.new("cremover", [lv.Type.TARBALLS], lv.lored[lv.Type.TARBALLS].baseCost[gv.Resource.MALIGNANCY], "malig"))
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("5e13")
			gv.up[f].requires.append("KETO")
			
			f = "CONDUCT"
			gv.up[f] = Upgrade.new(f, "s2m misc","Metastasizing no longer resets Stage 1 resources.", gv.Tab.MALIGNANT)
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e15") # mil
			
			f = "CAPITAL PUNISHMENT"
			gv.up[f] = Upgrade.new(f, "s2m misc","Tumor gain from Malignant upgrade PROCEDURE is multiplied by your Stage 1 run count.", gv.Tab.MALIGNANT)
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("3e14")
			gv.up[f].requires.append("what in cousin-fuckin tarnation alabama betty crocker miss fuckin betty white shit is this")
			gv.up[f].requires.append("IT'S SPREADIN ON ME")
			
			f = "IT'S SPREADIN ON ME"
			gv.up[f] = Upgrade.new(f, "s2m output","Malignant upgrade IT'S GROWIN ON ME now always applies its buff to both Iron AND Copper. This upgrade has the same effect, but on Iron Ore and Copper Ore.", "growth")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.IRON_ORE, lv.Type.COPPER_ORE]))
			gv.up[f].effects[0].dynamic = true
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("8e13") # mil
			gv.up[f].requires.append("AUTO-PERSIST")
			gv.up[f].saveEffects()
			
			f = "the athore coments al totol lies!"
			gv.up[f] = Upgrade.new(f, "s2m misc","Stage 1 crits gain a 1% chance to crit.", gv.Tab.S1)
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("2e13") # mil
			gv.up[f].requires.append("Elbow Straps")
			
			f = "don't take candy from babies"
			gv.up[f] = Upgrade.new(f, "s2m misc","Stage 2 and up LOREDs will not take fuel or resources from a Stage 1 LORED if it is below level 5.")
			gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new(1000)
			gv.up[f].requires.append("MECHANICAL")
			
			# benefits stage 1 only
			if true:
				
				f = "AUTO-PERSIST"
				gv.up[f] = Upgrade.new(f, "s2m saveup","Malignant autobuyer upgrades persist through Chemotherapy.", "malig")
				gv.up[f].effects.append(Effect.new("saveup", ["MOUND","SIDIUS IRON", "SLAPAPOW!","SENTIENT DERRICK", "CANKERITE", "wtf is that musk", "MOIST", "pippenpaddle- oppsoCOPolis", "AUTOPOLICE", "AUTOSTONER", "OREOREUHBor E ALICE", "AUTOSHOVELER"], 2))
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e13")
				gv.up[f].requires.append("THE WITCH OF LOREDELITH")
				
				f = "THE WITCH OF LOREDELITH"
				gv.up[f] = Upgrade.new(f, "s2m misc","Stage 1 LOREDs gain Circe's powerful boon, which produces 1% of their net output per tick, multiplied by their haste. Effects the autobuyer logic of multiple LOREDs.", "thewitchofloredelith")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e12")
				
				f = "GRIMOIRE"
				gv.up[f] = Upgrade.new(f, "s2m misc","Radiative upgrade THE WITCH OF LOREDELITH percent modifier is affected by your Stage 1 run count.", "thewitchofloredelith")
				gv.up[f].requires.append("THE WITCH OF LOREDELITH")
				gv.up[f].cost[gv.Resource.TUMORS] = Ob.Num.new("1e24")
		
		# s1m
		if true:
			
			f = "ROUTINE"
			gv.up[f] = Upgrade.new(f, "s1m misc","Metastasizes and then resets this upgrade. Additionally, Normal upgrades now persist through Metastasis.", gv.Tab.MALIGNANT)
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("1e20")
			gv.up[f].requires.append("RED NECROMANCY")
			
			f = "PROCEDURE"
			var cock = Big.new("1e20").toString()
			gv.up[f] = Upgrade.new(f, "s1m misc","When Metastasizing, every " + cock + " Malignancy will be spent to reward you with (1,000 * Tumor's output) Tumors.", "tum")
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("1e19")
			gv.up[f].requires.append("upgrade_name")
			
			f = "aw <3"
			gv.up[f] = Upgrade.new(f, "s1m misc","Start the game with a free Coal LORED.", "coal")
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(2.0)
			gv.up[f].requires.append("ENTHUSIASM")
			
			f = "THE THIRD"
			gv.up[f] = Upgrade.new(f, "s1m misc","Whenever Copper Ore produces ore, he will produce an equal amount of Copper. Effects the Copper Ore autobuyer logic.", "copo")
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("2e8")
			gv.up[f].requires.append("pippenpaddle- oppsoCOPolis")
			
			f = "I RUN"
			gv.up[f] = Upgrade.new(f, "s1m misc","Whenever Iron Ore produces ore, he will produce an equal amount of Iron. Effects the Iron Ore autobuyer logic.", "irono")
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("25e9")
			
			f = "wait that's not fair"
			gv.up[f] = Upgrade.new(f, "s1m misc","Whenever Coal produces Coal, he will produce ten times as much Stone. Effects the Coal autobuyer logic.", "stone")
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("1e18")
			
			f = "IT'S GROWIN ON ME"
			gv.up[f] = Upgrade.new(f, "s1m output","Whenever Growth is spawned, either Iron or Copper will receive an output and input boost based on Growth's level.", "growth")
			gv.up[f].effects.append(Effect.new("output", [lv.Type.IRON], 1.0))
			gv.up[f].effects[0].dynamic = true
			gv.up[f].effects[0].index = 0
			gv.up[f].effects.append(Effect.new("output", [lv.Type.COPPER], 1.0))
			gv.up[f].effects[1].dynamic = true
			gv.up[f].effects[1].index = 1
			gv.up[f].effects.append(Effect.new("input", [lv.Type.IRON], 1.0))
			gv.up[f].effects[2].dynamic = true
			gv.up[f].effects[2].index = 2
			gv.up[f].effects.append(Effect.new("input", [lv.Type.COPPER], 1.0))
			gv.up[f].effects[3].dynamic = true
			gv.up[f].effects[3].index = 3
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new(2000.0)
			gv.up[f].saveEffects()
			
			f = "upgrade_name"
			gv.up[f] = Upgrade.new(f, "s1m misc","Reduces the cost increase of every Stage 1 LORED from x3.0 to x2.75; Fuel Cost and Fuel Storage for Stage 1 LOREDs x{e0}.", gv.Tab.S1)
			gv.up[f].effects.append(Effect.new("drain", gv.list.lored[gv.Tab.S1], 10.0))
			gv.up[f].effects.append(Effect.new("FUEL_STORAGE", gv.list.lored[gv.Tab.S1], 10.0))
			gv.up[f].cost[gv.Resource.MALIGNANCY] = Ob.Num.new("25e6")
			gv.up[f].requires.append("ORE LORD")



func setup():
	
	setup_loreds()
	setup_upgrades()

func setup_loreds():
	
	for firstLORED in lv.lored:
		for secondLORED in lv.lored:
			if lv.lored[secondLORED].lored.usedResources.size() == 0:
				continue
			for r in lv.lored[firstLORED].lored.producedResources:
				if r in lv.lored[secondLORED].lored.usedResources:
					lv.lored[firstLORED].lored.usedBy.append(secondLORED)
					break

func setup_upgrades():
	
	for x in gv.up:
		
		if not "reset" in gv.up[x].type:
			gv.list.upgrade[str(gv.up[x].tab)].append(x)
			gv.list.upgrade[str(gv.up[x].stage_key)].append(x)
			if gv.up[x].normal:
				gv.list.upgrade["unowned " + str(gv.up[x].tab)].append(x)
		
		if "autob" in gv.up[x].type:
			gv.up[x].desc.base = "Unlocks the Autobuyer for " + lv.lored[lv.loredByShorthand[gv.up[x].icon]].name + "."
		
		gv.up[x].name = x
		
		var uplistkey = gv.up[x].type.split(" ", true, 1)[1]
		if not uplistkey in gv.list.upgrade.keys():
			gv.list.upgrade[uplistkey] = []
		gv.list.upgrade[uplistkey].append(x)
		
		for v in gv.up:
			if v == x:
				continue
			if x in gv.up[v].requires:
				gv.up[x].required_by.append(v)
	
	gv.up["RED NECROMANCY"].effects.append(Effect.new("autoup", gv.list.upgrade[str(gv.Tab.MALIGNANT)]))
	gv.up["Now That's What I'm Talkin About, YeeeeeeaaaaaaaAAAAAAGGGGGHHH"].effects.append(Effect.new("autoup", gv.list.upgrade[str(gv.Tab.EXTRA_NORMAL)]))
	gv.up["we were so close, now you don't even think about me"].effects.append(Effect.new("autoup", gv.list.upgrade[str(gv.Tab.NORMAL)]))
	gv.up["ROUTINE"].effects.append(Effect.new("saveup", gv.list.upgrade[str(gv.Tab.NORMAL)], 2))


