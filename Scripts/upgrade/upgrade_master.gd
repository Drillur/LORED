extends Node2D

onready var rt = get_owner()
var autobuyer_fps := 0.0

var own_list_good := {}

func _ready():
	
	own_list_good[2] = false
	
	
	# upgrades
	if true:
		
		init()

func init(f := "") -> void:
	
	# master upgrade initializer
	
	# if mlt == "s1", do not need to declare
	
	# upreset
	if true:
		
		# s2m
		if true:
			
			f = "CHEMOTHERAPY"
			gv.up[f] = Upgrade.new(f, "s2 mup reset", "Resets ALL of Stage 1, Extra-normal upgrades, and Stage 2 resources (except Tumors). (Refunds cost.)", 0.0, "tum")
			
			f = "RECOVER"
			gv.up["RECOVER"] = Upgrade.new(f, "s2 mup reset", "Begin your recovery period. Apply your radiative upgrades to your new life. (Blocks the purchase of Radiative upgrades until your next chemotherapy dose.)", 0.0)
		
		# s1m
		if true:
			
			f = "METASTASIZE"
			gv.up["METASTASIZE"] = Upgrade.new(f, "s1 mup reset","Resets Normal upgrades and Stage 1 resources (except Malignancy). (Refunds cost.)", 0.0, "malig")
			
			f = "SPREAD"
			gv.up[f] = Upgrade.new(f, "s1 mup reset", "Spread to and apply your malignant upgrades to a new host. (Blocks the purchase of Malignant upgrades until your next Metastasis.)", 0.0)
	
	# upauto
	if true:
		
		# s2m
		if true:
			
			# lored
			if true:
				
				f = "Sudden Commission"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "literally doesn't fucking matter", 0.0, "draw")
				gv.up[f].cost["tum"] = Ob.Num.new(32000) # k
				gv.up[f].requires = "AUTOSENSU"
				
				f = "AUTOSENSU"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Wood LORED if it won't cause your Axe LORED's net output to drop below 0.", 0.0, "wood")
				gv.up[f].cost["tum"] = Ob.Num.new(16000) # bil
				gv.up[f].requires = "AUTOSMITHY"
				
				f = "Master"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Sand LORED if it won't cause your Humus LORED's net output to drop below 0.", 0.0, "sand")
				gv.up[f].cost["tum"] = Ob.Num.new(64 * 1000.0) # k
				gv.up[f].requires = "Sudden Commission"
				
				f = "AXELOT"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Axe LORED if it won't cause your Hardwood LORED's net output to drop below 0.", 0.0, "axe")
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["Master"].cost["tum"].b).multiply(2 * 5))
				gv.up[f].requires = "Master"
				
				f = "AUTOSHIT"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Humus LORED if it won't cause your Water LORED's net output to drop below 0.", 0.0, "humus")
				gv.up[f].requires = "AXELOT"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2)) # bil
				
				f = "Smashy Crashy"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Tree LORED if its net output is less than 0.", 0.0, "tree")
				gv.up[f].requires = "AUTOSHIT"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2)) # bil
				
				f = "A baby Roleum!! Thanks, pa!"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "AKJSLHDFKLJHASDFKL", 0.0, "pet")
				gv.up[f].requires = "Smashy Crashy"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2)) # bil
				
				f = "poofy wizard boy"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Tobacco LORED if its net output is less than 0.", 0.0, "toba")
				gv.up[f].requires = "A baby Roleum!! Thanks, pa!"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2)) # bil
				
				f = "BENEFIT"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Galena LORED.", 0.0, "gale")
				gv.up[f].requires = "poofy wizard boy"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "AUTOAQUATICICIDE"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "AKJSLHDFKLJHASDFKL", 0.0, "plast")
				gv.up[f].requires = "BENEFIT"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "Go on, then, LEAD us!"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Lead LORED if it won't cause your Galena LORED's net output to drop below 0.", 0.0, "lead")
				gv.up[f].requires = "AUTOAQUATICICIDE"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "BEEKEEPING"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Seed LORED if its net output is less than 0.", 0.0, "seed")
				gv.up[f].requires = "Go on, then, LEAD us!"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "Scoopy Doopy"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Soil LORED if it won't cause your Humus LORED's net output to drop below 0.", 0.0, "soil")
				gv.up[f].requires = "BEEKEEPING"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "Master Iron Worker"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Steel LORED if it won't cause your Liquid Iron LORED's net output to drop below 0.", 0.0, "steel")
				gv.up[f].requires = "Scoopy Doopy"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "JOINTSHACK"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Paper LORED if its net output is less than 0.", 0.0, "paper")
				gv.up[f].requires = "Master Iron Worker"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "AROUSAL"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Hardwood LORED if it won't cause your Wood LORED's net output to drop below 0.", 0.0, "hard")
				gv.up[f].requires = "JOINTSHACK"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "autofloof"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Wood Pulp LORED if its net output is less than 0.", 0.0, "pulp")
				gv.up[f].requires = "AROUSAL"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "ELECTRONIC CIRCUITS"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "AKJSLHDFKLJHASDFKL", 0.0, "wire")
				gv.up[f].requires = "autofloof"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "AUTOBADDECISIONMAKER"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Cigarette LORED if its net output is less than 0.", 0.0, "ciga")
				gv.up[f].requires = "ELECTRONIC CIRCUITS"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "PILLAR OF AUTUMN"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Glass LORED if it won't cause your Sand LORED's net output to drop below 0.", 0.0, "glass")
				gv.up[f].requires = "AUTOBADDECISIONMAKER"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "what kind of resource is 'tumors', you hack fraud"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "AKJSLHDFKLJHASDFKL", 0.0, "tum")
				gv.up[f].requires = "PILLAR OF AUTUMN"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "DEVOUR"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "AKJSLHDFKLJHASDFKL", 0.0, "carc")
				gv.up[f].requires = "what kind of resource is 'tumors', you hack fraud"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).multiply(2))
				
				f = "Splishy Splashy"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Water LORED.", 0.0, "water")
				gv.up[f].cost["tum"] = Ob.Num.new(4000.0)
				
				f = "AUTOSMITHY"
				gv.up[f] = Upgrade.new(f, "s2 mup autob", "Automatically purchases your Liquid Iron LORED.", 0.0, "liq")
				gv.up[f].cost["tum"] = Ob.Num.new(8000.0)
				gv.up[f].requires = "Splishy Splashy"
			
			# upgr
			if true:
				
				f = "PHILOSOPHER"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "s2")
				gv.up[f].cost["tum"] = Ob.Num.new("5e12")
				gv.up[f].requires = "INSIDIUS"
				gv.up[f].benefactor_of.append("s2")
				
				f = "beeware the seed lored"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon (but also the bee with daggers too obviously shucks).", 0.0, "seed")
				gv.up[f].requires = "BEEKEEPING"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("seed")
				
				f = "flonky wonky"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "paper")
				gv.up[f].requires = "JOINTSHACK"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("paper")
				
				f = "INSIDIUS"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "carc")
				gv.up[f].requires = "DEVOUR"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("carc")
				
				f = "Tummy Ache"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "tum")
				gv.up[f].requires = "what kind of resource is 'tumors', you hack fraud"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("tum")
				
				f = "Second Breakfast"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "toba")
				gv.up[f].requires = "poofy wizard boy"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("toba")
				
				f = "AUTOSQUIRTER"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "pet")
				gv.up[f].requires = "A baby Roleum!! Thanks, pa!"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("pet")
				
				f = "Motherlode"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "gale")
				gv.up[f].requires = "BENEFIT"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("gale")
				
				f = "Plasticular Cancer"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "plast")
				gv.up[f].requires = "AUTOAQUATICICIDE"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("plast")
				
				f = "probably radioactive"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "lead")
				gv.up[f].requires = "Go on, then, LEAD us!"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("lead")
				
				f = "Fangorn"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "tree")
				gv.up[f].requires = "Smashy Crashy"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("tree")
				
				f = "Glass Pass"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "glass")
				gv.up[f].requires = "PILLAR OF AUTUMN"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("glass")
				
				f = "Wire Trail"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "wire")
				gv.up[f].requires = "ELECTRONIC CIRCUITS"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("wire")
				
				f = "Hardwood Cycle"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "hard")
				gv.up[f].requires = "AROUSAL"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("hard")
				
				f = "Steel Pattern"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "steel")
				gv.up[f].requires = "Master Iron Worker"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("steel")
				
				f = "Iron Liquidizer"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "liq")
				gv.up[f].cost["tum"] = Ob.Num.new(4000)
				gv.up[f].requires = "AUTOSMITHY"
				gv.up[f].benefactor_of.append("liq")
				
				f = "Confirmed Poopy"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "humus")
				gv.up[f].requires = "AUTOSHIT"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("humus")
				
				f = "lemme axe u summ"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "axe")
				gv.up[f].requires = "AXELOT"
				gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up[gv.up[f].requires].cost["tum"].b).divide(2))
				gv.up[f].benefactor_of.append("axe")
				
				f = "Apprentice"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "sand")
				gv.up[f].cost["tum"] = Ob.Num.new(32 * 1000)
				gv.up[f].requires = "Master"
				gv.up[f].benefactor_of.append("sand")
				
				f = "Snake Way"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "wood")
				gv.up[f].cost["tum"] = Ob.Num.new(8000.0)
				gv.up[f].requires = "AUTOSENSU"
				gv.up[f].benefactor_of.append("wood")
				
				f = "RELEASE THE RIVER"
				gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Extra-normal upgrades that share this icon.", 0.0, "water")
				gv.up[f].cost["tum"] = Ob.Num.new(2000.0)
				gv.up[f].requires = "Splishy Splashy"
				gv.up[f].benefactor_of.append("water")
				
				# works on s1
				if true:
					
					f = "we were so close, now you don't even think about me"
					gv.up[f] = Upgrade.new(f, "s2 mup autoup", "Automatically purchases Normal upgrades.", 0.0, "s1")
					gv.up[f].cost["malig"] = Ob.Num.new("5e20")
					gv.up[f].cost["tum"] = Ob.Num.new("10e6")
					gv.up[f].requires = "SPEED-SHOPPER"
					gv.up[f].benefactor_of.append("s1 nup")
					
					f = "RED NECROMANCY"
					gv.up[f] = Upgrade.new(f, "s2 mup autoup","Automatically purchases Malignancy upgrades; removes your ability to metastasize.", 0.0, "s1mup")
					gv.up[f].cost["tum"] = Ob.Num.new(10000)
					gv.up[f].benefactor_of.append("s1 mup")
		
		# s1m
		if true:
			
			f = "DUNKUS"
			gv.up[f] = Upgrade.new(f, "s1 mup saveup", "Upgrades that benefit your Growth, Concrete, Joule, Malignancy, Tarball or Oil LOREDs will persist through Metastasis.", 0.0)
			gv.up[f].cost["malig"] = Ob.Num.new("1e9")
			gv.up[f].requires = "upgrade_name"
			
			f = "CHUNKUS"
			gv.up[f] = Upgrade.new(f, "s1 mup saveup", "Upgrades that benefit your Coal, Stone, Iron Ore, Copper Ore, Iron, or Copper LOREDs will persist through Metastasis.", 0.0)
			gv.up[f].cost["malig"] = Ob.Num.new(18500.0)
			gv.up[f].requires = "how is this an RPG anyway?"
			
			f = "SENTIENT DERRICK"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "Automatically purchases your Oil LORED if its net output is less than 0.", 0.0, "oil")
			gv.up[f].cost["malig"] = Ob.Num.new("85e10")
			
			f = "SLAPAPOW!"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "Automatically purchases your Tarball LORED if its net output is less than 0.", 0.0, "tar")
			gv.up["SLAPAPOW!"].cost["malig"] = Ob.Num.new("17e11")
			
			f = "MOUND"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "Automatically purchases your Malignancy LORED.", 0.0, "malig")
			gv.up["MOUND"].cost["malig"] = Ob.Num.new("35e12")
			
			f = "wtf is that musk"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "Automatically purchases your Joule LORED if its net output is less than 0.", 0.0, "jo")
			gv.up[f].cost["malig"] = Ob.Num.new("43e7")
			
			f = "CANKERITE"
			gv.up[f] = Upgrade.new(f, "s1 mup autob","Automatically purchases your Concrete LORED if its output is less than your Stone LORED's output.", 0.0,"conc")
			gv.up[f].cost["malig"] = Ob.Num.new("15e9")
			
			f = "MOIST"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "Automatically purchases your Growth LORED.", 0.0, "growth")
			gv.up[f].cost["malig"] = Ob.Num.new("12e6")
			
			f = "AUTOPOLICE"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "asdf", 0.0, "cop")
			gv.up["AUTOPOLICE"].cost["malig"] = Ob.Num.new(140000.0)
			
			f = "SIDIUS IRON"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "asd", 0.0, "iron")
			gv.up["SIDIUS IRON"].cost["malig"] = Ob.Num.new("8e12")
			
			f = "pippenpaddle- oppsoCOPolis"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "Automatically purchases your Copper Ore LORED if its net output is less than 0.", 0.0, "copo")
			gv.up["pippenpaddle- oppsoCOPolis"].cost["malig"] = Ob.Num.new(600000.0)
			
			f = "OREOREUHBor E ALICE"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "Automatically purchases your Iron Ore LORED if its net output is less than 0.", 0.0, "irono")
			gv.up["OREOREUHBor E ALICE"].cost["malig"] = Ob.Num.new(12000.0)
			
			f = "AUTOSTONER"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "Automatically purchases your Stone LORED.", 0.0, "stone")
			gv.up["AUTOSTONER"].cost["malig"] = Ob.Num.new(35000.0)
			
			f = "AUTOSHOVELER"
			gv.up[f] = Upgrade.new(f, "s1 mup autob", "Automatically purchases your Coal LORED if its net output is less than 0.", 0.0, "coal")
			gv.up["AUTOSHOVELER"].cost["malig"] = Ob.Num.new(1500.0)
	
	# upcost
	if true:
		
		# s2m
		if true:
			
			f = "mods enabled"
			gv.up[f] = Upgrade.new(f, "s2 mup cost","Petroleum LORED Glass cost x0.8.", 0.75, "pet")
			gv.up[f].cost["tum"] = Ob.Num.new(400000)
			gv.up[f].benefactor_of.append("pet glass")
			gv.up[f].requires = "BEAVER"
			
			f = "Mudslide"
			gv.up[f] = Upgrade.new(f, "s2 mup cost","Humus LORED Glass cost x0.75.", 0.75, "humus")
			gv.up[f].cost["tum"] = Ob.Num.new(1000)
			gv.up[f].benefactor_of.append("humus glass")
			
			f = "The Great Journey"
			gv.up[f] = Upgrade.new(f, "s2 mup cost","Glass LORED Steel cost x0.8.", 0.8, "glass")
			gv.up[f].cost["tum"] = Ob.Num.new(6000)
			gv.up[f].benefactor_of.append("glass steel")
			
			f = "BEAVER"
			gv.up[f] = Upgrade.new(f, "s2 mup cost","Water LORED Wood cost x0.8.", 0.8, "water")
			gv.up[f].cost["tum"] = Ob.Num.new(60000)
			gv.up[f].benefactor_of.append("water wood")
		
		# s1m
		if true:
			
			f = "FOOD TRUCKS"
			gv.up[f] = Upgrade.new(f, "s1 mup cost", "All Stage 1 costs x0.5.", 0.5)
			gv.up[f].cost["malig"] = Ob.Num.new("1e13") # 10e12
			gv.up[f].requires = "DUNKUS"
			gv.up[f].benefactor_of.append("s1")
			
			f = "CON-FRICKIN-CRETE"
			gv.up[f] = Upgrade.new(f, "s1 mup cost", "Oil LORED Concrete cost x0.5.", 0.5, "oil")
			gv.up["CON-FRICKIN-CRETE"].cost["malig"] = Ob.Num.new(12000.0)
			gv.up[f].benefactor_of.append("oil conc")
			
			f = "COMPULSORY JUICE"
			gv.up[f] = Upgrade.new(f, "s1 mup cost", "Iron Ore and Copper Ore LORED Stone cost x0.5.", 0.5, "stone")
			gv.up["COMPULSORY JUICE"].cost["malig"] = Ob.Num.new(50000.0)
			gv.up["COMPULSORY JUICE"].requires = "AUTOSTONER"
			gv.up[f].benefactor_of.append("irono stone")
			gv.up[f].benefactor_of.append("copo stone")
	
	# uphaste
	if true:
		
		# s2m
		if true:
			
			f = "SPEED DOODS"
			gv.up[f] = Upgrade.new(f, "s2 mup haste","Draw Plate LORED haste x1.5.", 1.5, "draw")
			gv.up[f].cost["tum"] = Ob.Num.new(6400000)
			gv.up[f].requires = "Erebor"
			gv.up[f].benefactor_of.append("draw")
			
			f = "Erebor"
			gv.up[f] = Upgrade.new(f, "s2 mup haste","Galena LORED haste x1.5.", 1.5, "gale")
			gv.up[f].cost["tum"] = Ob.Num.new(3200000)
			gv.up[f].requires = "Child Energy"
			gv.up[f].benefactor_of.append("gale")
			
			f = "Child Energy"
			gv.up[f] = Upgrade.new(f, "s2 mup haste","Soil LORED haste x1.5.", 1.5, "soil")
			gv.up[f].cost["tum"] = Ob.Num.new(1600000)
			gv.up[f].requires = "PLATE"
			gv.up[f].benefactor_of.append("soil")
			
			f = "PLATE"
			gv.up[f] = Upgrade.new(f, "s2 mup haste","Steel LORED haste x1.5.", 1.5, "steel")
			gv.up[f].cost["tum"] = Ob.Num.new(800000)
			gv.up[f].requires = "SILLY"
			gv.up[f].benefactor_of.append("steel")
			
			f = "SILLY"
			gv.up[f] = Upgrade.new(f, "s2 mup haste","Hardwood LORED haste x1.5.", 1.5, "hard")
			gv.up[f].cost["tum"] = Ob.Num.new(400000)
			gv.up[f].requires = "Bone Meal"
			gv.up[f].benefactor_of.append("hard")
			
			f = "Bone Meal"
			gv.up[f] = Upgrade.new(f, "s2 mup haste","Tree LORED haste x1.5.", 1.5, "tree")
			gv.up[f].cost["tum"] = Ob.Num.new(200000)
			gv.up[f].requires = "Overtime"
			gv.up[f].benefactor_of.append("tree")
			
			f = "Overtime"
			gv.up[f] = Upgrade.new(f, "s2 mup haste","Liquid Iron LORED haste x1.5.", 1.5, "liq")
			gv.up[f].cost["tum"] = Ob.Num.new(100000)
			gv.up[f].requires = "Covenant Dance"
			gv.up[f].benefactor_of.append("liq")
			
			f = "Covenant Dance"
			gv.up[f] = Upgrade.new(f, "s2 mup haste","Humus LORED haste x1.5.", 1.5, "humus")
			gv.up[f].cost["tum"] = Ob.Num.new(50000)
			gv.up[f].requires = "APPLE JUICE"
			gv.up[f].benefactor_of.append("humus")
			
			f = "MILK"
			gv.up[f] = Upgrade.new(f, "s2 mup haste buff","Stage 2 haste x%s.", 1.1, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new(2000)
			gv.up[f].benefactor_of.append("s2")
			
			f = "GATORADE"
			gv.up[f] = Upgrade.new(f, "s2 mup haste buff","Stage 2 haste x%s.", 1.1, "s2")
			gv.up[f].requires = "MILK"
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["MILK"].cost["tum"].b).multiply(3))
			gv.up[f].benefactor_of.append("s2")
			
			f = "APPLE JUICE"
			gv.up[f] = Upgrade.new(f, "s2 mup haste buff","Stage 2 haste x%s.", 1.1, "s2")
			gv.up[f].requires = "GATORADE"
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["GATORADE"].cost["tum"].b).multiply(6))
			gv.up[f].benefactor_of.append("s2")
			
			f = "PEPPERMINT MOCHA"
			gv.up[f] = Upgrade.new(f, "s2 mup haste buff","Stage 2 haste x%s.", 1.1, "s2")
			gv.up[f].requires = "APPLE JUICE"
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["APPLE JUICE"].cost["tum"].b).multiply(3))
			gv.up[f].benefactor_of.append("s2")
			
			f = "STRAWBERRY BANANA SMOOTHIE"
			gv.up[f] = Upgrade.new(f, "s2 mup haste buff","Stage 2 haste x%s.", 1.1, "s2")
			gv.up[f].requires = "PEPPERMINT MOCHA"
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["PEPPERMINT MOCHA"].cost["tum"].b).multiply(3))
			gv.up[f].benefactor_of.append("s2")
			
			f = "GREEN TEA"
			gv.up[f] = Upgrade.new(f, "s2 mup haste buff","Stage 2 haste x%s.", 1.1, "s2")
			gv.up[f].requires = "STRAWBERRY BANANA SMOOTHIE"
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["STRAWBERRY BANANA SMOOTHIE"].cost["tum"].b).multiply(3))
			gv.up[f].benefactor_of.append("s2")
			
			f = "FRENCH VANILLA"
			gv.up[f] = Upgrade.new(f, "s2 mup haste buff","Stage 2 haste x%s.", 1.1, "s2")
			gv.up[f].requires = "GREEN TEA"
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["GREEN TEA"].cost["tum"].b).multiply(3))
			gv.up[f].benefactor_of.append("s2")
			
			f = "WATER"
			gv.up[f] = Upgrade.new(f, "s2 mup haste buff","Stage 2 haste x%s.", 1.1, "s2")
			gv.up[f].requires = "FRENCH VANILLA"
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["FRENCH VANILLA"].cost["tum"].b).multiply(3))
			gv.up[f].benefactor_of.append("s2")
		
		# s2n
		if true:
			
			f = "SPOOLY"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Wire LORED haste x1.25.", 1.25, "wire")
			gv.up[f].cost["hard"] = Ob.Num.new("750e6")
			gv.up[f].cost["carc"] = Ob.Num.new("25e6")
			gv.up[f].requires = "PULLEY"
			gv.up[f].benefactor_of.append("wire")
			
			f = "Utter Molester Champ"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Petroleum LORED haste x1.15.", 1.15, "pet")
			gv.up[f].cost["carc"] = Ob.Num.new(100000.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("pet")
			
			f = "CANCER'S REAL COOL"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Tumor LORED haste x1.25.", 1.25, "tum")
			gv.up[f].cost["water"] = Ob.Num.new(150000.0)
			gv.up[f].cost["tree"] = Ob.Num.new(150000.0)
			gv.up[f].cost["humus"] = Ob.Num.new(150000.0)
			gv.up[f].cost["axe"] = Ob.Num.new(150000.0)
			gv.up[f].cost["wire"] = Ob.Num.new(150000.0)
			gv.up[f].cost["glass"] = Ob.Num.new(150000.0)
			gv.up[f].cost["hard"] = Ob.Num.new(150000.0)
			gv.up[f].cost["steel"] = Ob.Num.new(150000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(150000.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("tum")
			
			f = "Wood Lord"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Axe, Wood, and Hardwood LORED haste x1.15.", 1.15, "hard")
			gv.up[f].cost["steel"] = Ob.Num.new(35000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(2500.0)
			gv.up[f].requires = "Cutting Corners"
			gv.up[f].benefactor_of.append("axe")
			gv.up[f].benefactor_of.append("wood")
			gv.up[f].benefactor_of.append("hard")
			
			f = "Expert Iron Worker"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Liquid Iron and Steel LORED haste x1.15.", 1.15, "steel")
			gv.up[f].cost["glass"] = Ob.Num.new(40000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(2500.0)
			gv.up[f].requires = "Quormps"
			gv.up[f].benefactor_of.append("liq")
			gv.up[f].benefactor_of.append("steel")
			
			f = "Where's the boy, String?"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Draw Plate and Wire LORED haste x1.15.", 1.15, "wire")
			gv.up[f].cost["hard"] = Ob.Num.new(35000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(2500.0)
			gv.up[f].requires = "Hole Geometry"
			gv.up[f].benefactor_of.append("draw")
			gv.up[f].benefactor_of.append("wire")
			
			f = "They've Always Been Faster"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Humus, Sand, and Glass LORED x1.15.", 1.15, "glass")
			gv.up[f].cost["wire"] = Ob.Num.new(75000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(2500.0)
			gv.up[f].requires = "Kilty Sbark"
			gv.up[f].benefactor_of.append("humus")
			gv.up[f].benefactor_of.append("sand")
			gv.up[f].benefactor_of.append("glass")
			
			f = "Sp0oKy"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Carcinogen LORED haste x1.15.", 1.15, "carc")
			gv.up[f].cost["carc"] = Ob.Num.new(1000.0)
			gv.up[f].cost["tum"] = Ob.Num.new(2500.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("carc")
			
			f = "RAIN DANCE"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Water LORED haste x1.2.", 1.2, "water")
			gv.up[f].cost["sand"] = Ob.Num.new(40.0)
			gv.up[f].benefactor_of.append("water")
			
			f = "BREAK THE DAM"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Water LORED haste x1.25.", 1.25, "water")
			gv.up[f].cost["liq"] = Ob.Num.new(30.0)
			gv.up[f].requires = "RAIN DANCE"
			gv.up[f].benefactor_of.append("water")
			
			f = "Carlin"
			gv.up[f] = Upgrade.new(f, "s2 nup haste buff","Stage 2 haste x%s.", 1.05, "s2")
			gv.up[f].cost["lead"] = Ob.Num.new(600.0)
			gv.up[f].benefactor_of.append("s2")
			
			f = "Sagan"
			gv.up[f] = Upgrade.new(f, "s2 nup haste buff","Stage 2 haste x%s.", 1.05, "s2")
			gv.up[f].cost["carc"] = Ob.Num.new(5.0)
			gv.up[f].requires = "Carlin"
			gv.up[f].benefactor_of.append("s2")

			f = "Patreon Artist"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Wire LORED haste x1.2.", 1.2, "wire")
			gv.up[f].cost["hard"] = Ob.Num.new(200.0)
			gv.up[f].requires = "Carlin"
			gv.up[f].benefactor_of.append("wire")

			f = "LIGHTHOUSE"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Sand LORED haste x1.15.", 1.15, "sand")
			gv.up["LIGHTHOUSE"].cost["wire"] = Ob.Num.new(130.0)
			gv.up[f].benefactor_of.append("sand")

			f = "Woodthirsty"
			gv.up["Woodthirsty"] = Upgrade.new(f, "s2 nup haste","Axe LORED haste x1.3.", 1.3, "axe")
			gv.up["Woodthirsty"].cost["wood"] = Ob.Num.new(800.0)
			gv.up["Woodthirsty"].cost["hard"] = Ob.Num.new(100.0)
			gv.up[f].benefactor_of.append("axe")

			f = "Woodiac Chopper"
			gv.up["Woodiac Chopper"] = Upgrade.new(f, "s2 nup haste","Axe LORED haste x1.4.", 1.4, "axe")
			gv.up["Woodiac Chopper"].cost["carc"] = Ob.Num.new(50.0)
			gv.up["Woodiac Chopper"].requires = "Seeing Brown"
			gv.up[f].benefactor_of.append("axe")

			f = "Millery"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Hardwood LORED haste x1.25.", 1.25, "hard")
			gv.up[f].cost["steel"] = Ob.Num.new(385.0)
			gv.up[f].cost["carc"] = Ob.Num.new(25.0)
			gv.up[f].requires = "Hardwood Yourself"
			gv.up[f].benefactor_of.append("hard")

			f = "Quamps"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Steel LORED haste x1.35.", 1.35, "steel")
			gv.up[f].cost["glass"] = Ob.Num.new(600.0)
			gv.up[f].cost["carc"] = Ob.Num.new(25.0)
			gv.up[f].requires = "Steel Yourself"
			gv.up[f].benefactor_of.append("steel")

			f = "Kilty Sbark"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Glass LORED haste x1.15.", 1.15, "glass")
			gv.up[f].cost["wire"] = Ob.Num.new(6500.0)
			gv.up[f].cost["carc"] = Ob.Num.new(200.0)
			gv.up[f].requires = "2552"
			gv.up[f].benefactor_of.append("glass")

			f = "Dirt Collection Rewards Program"
			gv.up[f] = Upgrade.new(f, "s2 nup haste","Humus LORED haste x1.25.", 1.25, "humus")
			gv.up[f].cost["soil"] = Ob.Num.new(25000.0)
			gv.up[f].cost["lead"] = Ob.Num.new(25000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(350.0)
			gv.up[f].requires = "Rogue Blacksmith"
			gv.up[f].benefactor_of.append("humus")
		
		# s1m
		if true: # mup
			
			f = "MALEVOLENT"
			gv.up[f] = Upgrade.new(f, "s1 mup haste","Tar, Concrete, and Malignancy LORED haste x4.0.", 4.0, "malig")
			gv.up["MALEVOLENT"].cost["malig"] = Ob.Num.new("1e20")
			gv.up["MALEVOLENT"].requires = "MOUND"
			gv.up[f].benefactor_of.append("tar")
			gv.up[f].benefactor_of.append("conc")
			gv.up[f].benefactor_of.append("malig")
			
			f = "OH, BABY, A TRIPLE"
			gv.up["OH, BABY, A TRIPLE"] = Upgrade.new(f, "s1 mup haste","Tarball LORED haste x3.0.", 3.0, "tar")
			gv.up["OH, BABY, A TRIPLE"].cost["malig"] = Ob.Num.new(55000.0)
			gv.up["OH, BABY, A TRIPLE"].requires = "you little hard worker, you"
			gv.up[f].benefactor_of.append("tar")
			
			f = "STAY QUENCHED"
			gv.up["STAY QUENCHED"] = Upgrade.new(f, "s1 mup haste","Coal and Joule LORED haste x1.8.", 1.8, "jo")
			gv.up["STAY QUENCHED"].cost["malig"] = Ob.Num.new(60000.0)
			gv.up["STAY QUENCHED"].requires = "you little hard worker, you"
			gv.up[f].benefactor_of.append("coal")
			gv.up[f].benefactor_of.append("jo")

			f = "CANCER'S COOL"
			gv.up[f] = Upgrade.new(f, "s1 mup haste","Growth and Malignancy LORED haste x2.0.", 2.0, "malig")
			gv.up[f].cost["malig"] = Ob.Num.new("3e9")
			gv.up[f].requires = "MOIST"
			gv.up[f].benefactor_of.append("growth")
			gv.up[f].benefactor_of.append("malig")

			f = "you little hard worker, you"
			gv.up["you little hard worker, you"] = Upgrade.new(f, "s1 mup haste","Stone and Concrete LORED haste x2.0.", 2.0, "conc")
			gv.up["you little hard worker, you"].cost["malig"] = Ob.Num.new(40000.0)
			gv.up[f].benefactor_of.append("stone")
			gv.up[f].benefactor_of.append("conc")

			f = "ORE LORD"
			gv.up["ORE LORD"] = Upgrade.new(f, "s1 mup haste","Iron Ore, Copper Ore, Iron, and Copper LORED haste x2.0.", 2.0)
			gv.up["ORE LORD"].cost["malig"] = Ob.Num.new("1e6")
			gv.up["ORE LORD"].requires = "BIG TOUGH BOY"
			gv.up[f].benefactor_of.append("irono")
			gv.up[f].benefactor_of.append("copo")
			gv.up[f].benefactor_of.append("iron")
			gv.up[f].benefactor_of.append("cop")

			f = "OPPAI GUY"
			gv.up[f] = Upgrade.new(f, "s1 mup haste","Stage 1 haste x2.0.", 2.0)
			gv.up["OPPAI GUY"].cost["malig"] = Ob.Num.new("1e15")
			gv.up["OPPAI GUY"].requires = "FOOD TRUCKS"
			gv.up[f].benefactor_of.append("s1")

			f = "SOCCER DUDE"
			gv.up["SOCCER DUDE"] = Upgrade.new(f, "s1 mup haste","Stage 1 haste x2.0.", 2.0)
			gv.up["SOCCER DUDE"].cost["malig"] = Ob.Num.new(1600.0)
			gv.up[f].benefactor_of.append("s1")

			f = "coal DUDE"
			gv.up[f] = Upgrade.new(f, "s1 mup haste","Coal LORED haste x2.0.", 2.0, "coal")
			gv.up[f].cost["malig"] = Ob.Num.new("1e11")
			gv.up[f].benefactor_of.append("coal")

		# nup
		if true:
			
			f = "GRINDER"
			gv.up["GRINDER"] = Upgrade.new(f, "s1 nup haste","Stone LORED haste x1.25.", 1.25, "stone")
			gv.up["GRINDER"].cost["stone"] = Ob.Num.new(90.0)
			gv.up[f].benefactor_of.append("stone")
			
			f = "SLOP"
			gv.up["SLOP"] = Upgrade.new(f, "s1 nup haste", "Growth LORED haste x1.95.", 1.95, "growth")
			gv.up["SLOP"].cost["stone"] = Ob.Num.new("1e6")
			gv.up["SLOP"].requires = "SLIMER"
			gv.up[f].benefactor_of.append("growth")
			
			f = "SLIMER"
			gv.up["SLIMER"] = Upgrade.new(f, "s1 nup haste", "Growth LORED haste x1.5.", 1.5, "growth")
			gv.up["SLIMER"].cost["malig"] = Ob.Num.new(150.0)
			gv.up["SLIMER"].requires = "RYE"
			gv.up[f].benefactor_of.append("growth")

			f = "GRANDER"
			gv.up["GRANDER"] = Upgrade.new(f, "s1 nup haste", "Stone LORED haste x1.3.", 1.3, "stone")
			gv.up["GRANDER"].cost["coal"] = Ob.Num.new(400.0)
			gv.up["GRANDER"].requires = "GRINDER"
			gv.up[f].benefactor_of.append("stone")

			f = "LIGHTER SHOVEL"
			gv.up["LIGHTER SHOVEL"] = Upgrade.new(f, "s1 nup haste","Coal LORED haste x1.2.", 1.2, "coal")
			gv.up["LIGHTER SHOVEL"].cost["cop"] = Ob.Num.new(155.0)
			gv.up["LIGHTER SHOVEL"].requires = "GRINDER"
			gv.up[f].benefactor_of.append("coal")

			f = "GROUNDER"
			gv.up["GROUNDER"] = Upgrade.new(f, "s1 nup haste","Stone LORED haste x1.35.", 1.35, "stone")
			gv.up["GROUNDER"].cost["growth"] = Ob.Num.new(100.0)
			gv.up["GROUNDER"].cost["jo"] = Ob.Num.new(100.0)
			gv.up["GROUNDER"].requires = "GRANDPA"
			gv.up[f].benefactor_of.append("stone")

			f = "GRANDMA"
			gv.up["GRANDMA"] = Upgrade.new(f, "s1 nup haste","Stone LORED haste x1.3.", 1.3, "stone")
			gv.up["GRANDMA"].cost["iron"] = Ob.Num.new(400.0)
			gv.up["GRANDMA"].cost["cop"] = Ob.Num.new(400.0)
			gv.up["GRANDMA"].cost["conc"] = Ob.Num.new(20.0)
			gv.up["GRANDMA"].requires = "GRANDER"
			gv.up[f].benefactor_of.append("stone")

			f = "MIXER"
			gv.up["MIXER"] = Upgrade.new(f, "s1 nup haste","Concrete LORED haste x1.5.", 1.5, "conc")
			gv.up["MIXER"].cost["conc"] = Ob.Num.new(11.0)
			gv.up[f].benefactor_of.append("conc")
			gv.up[f].requires = "RYE"

			f = "SWIRLER"
			gv.up["SWIRLER"] = Upgrade.new(f, "s1 nup haste","Concrete LORED haste x1.5.", 1.5, "conc")
			gv.up["SWIRLER"].cost["coal"] = Ob.Num.new(9500.0)
			gv.up["SWIRLER"].cost["stone"] = Ob.Num.new(6000.0)
			gv.up["SWIRLER"].requires = "MIXER"
			gv.up[f].benefactor_of.append("conc")

			f = "SAALNDT"
			gv.up["SAALNDT"] = Upgrade.new(f, "s1 nup haste","Iron Ore and Copper Ore LORED haste x1.5.", 1.5, "irono")
			gv.up["SAALNDT"].cost["irono"] = Ob.Num.new(1500.0)
			gv.up["SAALNDT"].cost["copo"] = Ob.Num.new(1500.0)
			gv.up["SAALNDT"].requires = "GRINDER"
			gv.up[f].benefactor_of.append("irono")
			gv.up[f].benefactor_of.append("copo")

			f = "ANCHOVE COVE"
			gv.up[f] = Upgrade.new(f, "s1 nup haste","Iron Ore and Copper Ore LORED haste x2.0.", 2.0, "copo")
			gv.up["ANCHOVE COVE"].cost["irono"] = Ob.Num.new(450000.0)
			gv.up["ANCHOVE COVE"].cost["copo"] = Ob.Num.new(450000.0)
			gv.up["ANCHOVE COVE"].requires = "SAALNDT"
			gv.up[f].benefactor_of.append("irono")
			gv.up[f].benefactor_of.append("copo")

			f = "FLANK"
			gv.up["FLANK"] = Upgrade.new(f, "s1 nup haste","Iron LORED haste x1.4.", 1.4, "iron")
			gv.up["FLANK"].cost["malig"] = Ob.Num.new(125.0)
			gv.up["FLANK"].requires = "SAND"
			gv.up[f].benefactor_of.append("iron")

			f = "TEXAS"
			gv.up["TEXAS"] = Upgrade.new(f, "s1 nup haste","Iron LORED haste x1.25.", 1.25, "iron")
			gv.up["TEXAS"].cost["growth"] = Ob.Num.new(30.0)
			gv.up["TEXAS"].cost["cop"] = Ob.Num.new(400.0)
			gv.up["TEXAS"].requires = "RYE"
			gv.up[f].benefactor_of.append("iron")
			
			f = "SAND"
			gv.up["SAND"] = Upgrade.new(f, "s1 nup haste","Copper LORED haste x1.25.", 1.25, "cop")
			gv.up["SAND"].cost["growth"] = Ob.Num.new(200.0)
			gv.up["SAND"].requires = "TEXAS"
			gv.up[f].benefactor_of.append("cop")
			
			f = "RYE"
			gv.up["RYE"] = Upgrade.new(f, "s1 nup haste","Copper LORED haste x1.25.", 1.25, "cop")
			gv.up["RYE"].cost["growth"] = Ob.Num.new(15.0)
			gv.up["RYE"].cost["iron"] = Ob.Num.new(100.0)
			gv.up[f].benefactor_of.append("cop")
			gv.up[f].requires = "GRINDER"
	
	# upout
	if true:
		
		# s2m
		if true:
			
			f = "Cthaeh"
			gv.up[f] = Upgrade.new(f, "s2 mup out","Tree LORED output x10.0.", 10.0, "tree")
			gv.up[f].requires = "axman23 by now"
			gv.up[f].cost["tum"] = Ob.Num.new("3e12") # e12
			gv.up[f].benefactor_of.append("tree")
			
			f = "ONE PUNCH"
			gv.up[f] = Upgrade.new(f, "s2 mup out","Stage 2 output x1.5.", 2.0, "s2")
			gv.up[f].requires = "DOT DOT DOT"
			gv.up[f].cost["tum"] = Ob.Num.new("200e9") # b
			gv.up[f].benefactor_of.append("s2")
			
			f = "FALCON PAWNCH"
			gv.up[f] = Upgrade.new(f, "s2 mup add buff","Stage 2 base output +%s.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new(1250)
			gv.up[f].benefactor_of.append("s2")
			
			f = "KAIO-KEN"
			gv.up[f] = Upgrade.new(f, "s2 mup add buff","Stage 2 base output +%s.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["FALCON PAWNCH"].cost["tum"].b).multiply(3))
			gv.up[f].requires = "FALCON PAWNCH"
			gv.up[f].benefactor_of.append("s2")
			
			f = "DANCE OF THE FIRE GOD"
			gv.up[f] = Upgrade.new(f, "s2 mup add buff","Stage 2 base output +%s.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["KAIO-KEN"].cost["tum"].b).multiply(6))
			gv.up[f].requires = "KAIO-KEN"
			gv.up[f].benefactor_of.append("s2")
			
			f = "RASENGAN"
			gv.up[f] = Upgrade.new(f, "s2 mup add buff","Stage 2 base output +%s.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["DANCE OF THE FIRE GOD"].cost["tum"].b).multiply(3))
			gv.up[f].requires = "DANCE OF THE FIRE GOD"
			gv.up[f].benefactor_of.append("s2")
			
			f = "AVATAR STATE"
			gv.up[f] = Upgrade.new(f, "s2 mup add buff","Stage 2 base output +%s.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["RASENGAN"].cost["tum"].b).multiply(3)) # 1.01mil
			gv.up[f].requires = "RASENGAN"
			gv.up[f].benefactor_of.append("s2")
			
			f = "HAMON"
			gv.up[f] = Upgrade.new(f, "s2 mup add buff","Stage 2 base output +%s.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["AVATAR STATE"].cost["tum"].b).multiply(3))
			gv.up[f].requires = "AVATAR STATE"
			gv.up[f].benefactor_of.append("s2")
			
			f = "METAL CAP"
			gv.up[f] = Upgrade.new(f, "s2 mup add buff","Stage 2 base output +%s.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["HAMON"].cost["tum"].b).multiply(3))
			gv.up[f].requires = "HAMON"
			gv.up[f].benefactor_of.append("s2")
			
			f = "STAR ROD"
			gv.up[f] = Upgrade.new(f, "s2 mup add buff","Stage 2 base output +%s.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new(Big.new(gv.up["METAL CAP"].cost["tum"].b).multiply(3))
			gv.up[f].requires = "METAL CAP"
			gv.up[f].benefactor_of.append("s2")
			
			# s1 only
			if true:
				
				f = "Elbow Straps"
				gv.up[f] = Upgrade.new(f, "s2 mup add buff","Coal LORED base output +%s.", 1.0, "coal")
				gv.up[f].cost["malig"] = Ob.Num.new("5e9")
				gv.up[f].cost["tum"] = Ob.Num.new(65000) # k
				gv.up[f].requires = "THE WITCH OF LOREDELITH"
				gv.up[f].benefactor_of.append("coal")
				
				f = "MECHANICAL"
				gv.up[f] = Upgrade.new(f, "s2 mup out","Stage 1 output x2.0.", 2.0)
				gv.up[f].cost["tum"] = Ob.Num.new(250)
				gv.up[f].benefactor_of.append("s1")
				
				f = "SPEED-SHOPPER"
				gv.up[f] = Upgrade.new(f, "s2 mup out","Stage 1 output x2.0.", 2.0)
				gv.up[f].cost["tum"] = Ob.Num.new("5e6")
				gv.up[f].requires = "don't take candy from babies"
				gv.up[f].benefactor_of.append("s1")
		
		# s2n
		if true:
			
			f = "John Peter Bain, TotalBiscuit"
			gv.up[f] = Upgrade.new(f, "s2 nup out", "Stage 2 output x2.0.\n\"I am here to ask and answer one simple question: WTF is LORED?\"", 2.0, "s2")
			gv.up[f].cost["carc"] = Ob.Num.new("1e12") # t
			gv.up[f].cost["tum"] = Ob.Num.new("10e9")
			gv.up[f].requires = "Toriyama"
			
			f = "Ultra Shitstinct"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Humus LORED output x1.35.", 1.35, "humus")
			gv.up[f].cost["water"] = Ob.Num.new("1e9")
			gv.up[f].cost["seed"] = Ob.Num.new("25e6")
			gv.up[f].cost["carc"] = Ob.Num.new("10e6")
			gv.up[f].requires = "Le Guin"
			gv.up[f].benefactor_of.append("humus")
			
			f = "BURDENED"
			gv.up[f] = Upgrade.new(f, "s2 nup add buff","Lead LORED base output +%s.", 1.0, "lead")
			gv.up[f].cost["humus"] = Ob.Num.new("10e9")
			gv.up[f].cost["pulp"] = Ob.Num.new("4e9")
			gv.up[f].cost["paper"] = Ob.Num.new(1)
			gv.up[f].requires = "Toriyama"
			gv.up[f].benefactor_of.append("lead")
			
			f = "low rises"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Wire LORED output x1.35.", 1.25, "wire")
			gv.up[f].cost["hard"] = Ob.Num.new("10e9")
			gv.up[f].cost["carc"] = Ob.Num.new("1e9")
			gv.up[f].requires = "SPOOLY"
			gv.up[f].benefactor_of.append("wire")
			
			f = "Fingers of Onden"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Steel LORED output x1.25.", 1.25, "steel")
			gv.up[f].cost["glass"] = Ob.Num.new("15e9")
			gv.up[f].cost["carc"] = Ob.Num.new("1e9")
			gv.up[f].requires = "Steel Yo Mama"
			gv.up[f].benefactor_of.append("steel")
			
			f = "Busy Bee"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Seed LORED output x1.3.", 1.3, "seed")
			gv.up[f].cost["steel"] = Ob.Num.new("10e6")
			gv.up[f].cost["glass"] = Ob.Num.new("15e6")
			gv.up[f].cost["lead"] = Ob.Num.new("50e6")
			gv.up[f].requires = "Le Guin"
			gv.up[f].benefactor_of.append("seed")
			
			f = "DINDER MUFFLIN"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Paper LORED output x1.25.", 1.25, "paper")
			gv.up[f].cost["steel"] = Ob.Num.new("100e6")
			gv.up[f].cost["glass"] = Ob.Num.new("150e6")
			gv.up[f].cost["lead"] = Ob.Num.new("500e6")
			gv.up[f].requires = "Le Guin"
			gv.up[f].benefactor_of.append("paper")
			
			f = "MGALEKGOLO"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Glass LORED output x1.3.", 1.3, "glass")
			gv.up[f].cost["wire"] = Ob.Num.new("80e6")
			gv.up[f].cost["carc"] = Ob.Num.new("1e6")
			gv.up[f].requires = "They've Always Been Faster"
			gv.up[f].benefactor_of.append("glass")
			
			f = "Power Barrels"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Liquid Iron LORED output x1.2.", 1.2, "liq")
			gv.up[f].cost["steel"] = Ob.Num.new("100e6")
			gv.up[f].cost["glass"] = Ob.Num.new("25e6")
			gv.up[f].requires = "Le Guin"
			gv.up[f].benefactor_of.append("liq")
			
			f = "And this is to go even further beyond!"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Wood LORED output x1.25.", 1.25, "wood")
			gv.up[f].cost["paper"] = Ob.Num.new("1e7")
			gv.up[f].cost["pulp"] = Ob.Num.new("3e7")
			gv.up[f].cost["water"] = Ob.Num.new("25e6")
			gv.up[f].requires = "Le Guin"
			gv.up[f].benefactor_of.append("wood")
			
			f = "ERECTWOOD"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Hardwood LORED output x1.3.", 1.3, "hard")
			gv.up[f].cost["steel"] = Ob.Num.new("2e7")
			gv.up[f].cost["carc"] = Ob.Num.new("1e6")
			gv.up[f].requires = "Wood Lord"
			gv.up[f].benefactor_of.append("hard")
			
			f = "Glitterdelve"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Galena LORED output x1.25.", 1.25, "gale")
			gv.up[f].cost["lead"] = Ob.Num.new(100000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(8000.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("gale")
			
			f = "Longbottom Leaf"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Tobacco LORED output x1.25.", 1.25, "toba")
			gv.up[f].cost["wood"] = Ob.Num.new(500000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(5000.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("toba")
			
			f = "Factory Squirts"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Petroleum LORED output x1.25.", 1.25, "pet")
			gv.up[f].cost["growth"] = Ob.Num.new("2e8")
			gv.up[f].cost["lead"] = Ob.Num.new(3000.0)
			gv.up[f].cost["tum"] = Ob.Num.new(500.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("pet")
			
			f = "CANOPY"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Water LORED output x1.25.", 1.25, "water")
			gv.up["CANOPY"].cost["tree"] = Ob.Num.new(10.0)
			gv.up[f].benefactor_of.append("water")
			
			f = "EQUINE"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Humus LORED output x1.3.", 1.3, "humus")
			gv.up["EQUINE"].cost["glass"] = Ob.Num.new(90.0)
			gv.up[f].benefactor_of.append("humus")
			
			f = "PLASMA BOMBARDMENT"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Glass LORED output x1.25.", 1.25, "glass")
			gv.up[f].cost["wire"] = Ob.Num.new(310.0)
			gv.up[f].requires = "Carlin"
			gv.up[f].benefactor_of.append("glass")
			
			f = "Double Barrels"
			gv.up[f] = Upgrade.new(f, "s2 nup add buff","Liquid Iron LORED base output +%s.", 1.0, "liq")
			gv.up["Double Barrels"].cost["glass"] = Ob.Num.new(50.0)
			gv.up["Double Barrels"].cost["hard"] = Ob.Num.new(100.0)
			gv.up[f].benefactor_of.append("liq")
			
			f = "Triple Barrels"
			gv.up[f] = Upgrade.new(f, "s2 nup add buff","Liquid Iron LORED base output +%s.", 1.0, "liq")
			gv.up["Triple Barrels"].cost["wire"] = Ob.Num.new(350.0)
			gv.up["Triple Barrels"].cost["steel"] = Ob.Num.new(100.0)
			gv.up["Triple Barrels"].cost["soil"] = Ob.Num.new(250.0)
			gv.up["Triple Barrels"].requires = "Double Barrels"
			gv.up[f].benefactor_of.append("liq")
			
			f = "Seeing Brown"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Axe LORED output x1.25.", 1.25, "axe")
			gv.up[f].cost["glass"] = Ob.Num.new(300.0)
			gv.up[f].cost["wire"] = Ob.Num.new(300.0)
			gv.up[f].cost["tree"] = Ob.Num.new(100.0)
			gv.up[f].benefactor_of.append("axe")
			
			f = "GIMP"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Wire LORED output x1.3.", 1.3, "wire")
			gv.up[f].cost["hard"] = Ob.Num.new(900.0)
			gv.up[f].cost["carc"] = Ob.Num.new(25.0)
			gv.up[f].requires = "Patreon Artist"
			gv.up[f].benefactor_of.append("wire")
			
			f = "Henry Cavill"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Water LORED output x1.3.", 1.3, "water")
			gv.up[f].cost["ciga"] = Ob.Num.new(23.23)
			gv.up[f].cost["pulp"] = Ob.Num.new(70.0)
			gv.up[f].requires = "Sagan"
			gv.up[f].benefactor_of.append("water")
			
			f = "Journeyman Iron Worker"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Liquid Iron and Steel LORED output x1.3.", 1.3, "steel")
			gv.up[f].cost["axe"] = Ob.Num.new(250.0)
			gv.up[f].cost["carc"] = Ob.Num.new(50.0)
			gv.up[f].requires = "Sagan"
			gv.up[f].benefactor_of.append("liq")
			gv.up[f].benefactor_of.append("steel")
			
			f = "Soft and Smooth"
			gv.up[f] = Upgrade.new(f, "s2 nup out","Sand LORED output x1.25", 1.25, "sand")
			gv.up[f].cost["steel"] = Ob.Num.new(4500.0)
			gv.up[f].cost["carc"] = Ob.Num.new(900.0)
			gv.up[f].requires = "Unpredictable Weather"
			gv.up[f].benefactor_of.append("sand")
		
		# s1mup
		if true:
			
			f = "I DRINK YOUR MILKSHAKE"
			gv.up[f] = Upgrade.new(f, "s1 mup out","Whenever a LORED takes Coal, your Coal LORED gets an output boost.", 1.0, "coal")
			gv.up["I DRINK YOUR MILKSHAKE"].cost["malig"] = Ob.Num.new(800000.0)
			gv.up["I DRINK YOUR MILKSHAKE"].requires = "STAY QUENCHED"
			gv.up[f].benefactor_of.append("coal")
			
			f = "SLUGGER"
			gv.up[f] = Upgrade.new(f, "s1 mup out","Stage 1 output x2.0.", 2.0)
			gv.up["SLUGGER"].cost["malig"] = Ob.Num.new("1e16")
			gv.up["SLUGGER"].requires = "OPPAI GUY"
			gv.up[f].benefactor_of.append("s1")
			
			f = "BIG TOUGH BOY"
			gv.up[f] = Upgrade.new(f, "s1 mup out","Stage 1 output x2.0.", 2.0)
			gv.up["BIG TOUGH BOY"].cost["malig"] = Ob.Num.new(175000.0)
			gv.up["BIG TOUGH BOY"].requires = "CHUNKUS"
			gv.up[f].benefactor_of.append("s1")
			
			f = "ENTHUSIASM"
			gv.up[f] = Upgrade.new(f, "s1 mup out","Coal LORED output x1.25.", 1.25, "coal")
			gv.up["ENTHUSIASM"].cost["malig"] = Ob.Num.new(3000.0)
			gv.up["ENTHUSIASM"].requires = "AUTOSHOVELER"
			gv.up[f].benefactor_of.append("coal")
		
		# s1nup
		if true:
			
			f = "INJECT"
			gv.up[f] = Upgrade.new(f, "s1 nup add buff","Tarballs LORED base output +%s.", 1.0, "tar")
			gv.up[f].cost["tum"] = Ob.Num.new(100.0)
			gv.up[f].benefactor_of.append("tar")
			gv.up[f].requires = "STICKYTAR"
			
			f = "GEARED OILS"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Oil LORED output x2.0.", 2.0, "oil")
			gv.up["GEARED OILS"].cost["iron"] = Ob.Num.new("6e6")
			gv.up[f].benefactor_of.append("oil")
			gv.up[f].requires = "CHEEKS"
			
			f = "PEPPER"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Iron Ore LORED output x10.0.", 10.0, "irono")
			gv.up["PEPPER"].cost["cop"] = Ob.Num.new("25e9")
			gv.up["PEPPER"].cost["malig"] = Ob.Num.new("15e6")
			gv.up["PEPPER"].requires = "ANCHOVE COVE"
			gv.up[f].benefactor_of.append("irono")
			
			f = "GARLIC"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Copper Ore LORED output x10.0.", 10.0, "copo")
			gv.up["GARLIC"].cost["iron"] = Ob.Num.new("25e9")
			gv.up["GARLIC"].cost["malig"] = Ob.Num.new("15e6")
			gv.up["GARLIC"].requires = "ANCHOVE COVE"
			gv.up[f].benefactor_of.append("copo")
			
			f = "MUD"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Iron Ore and Iron LORED output x1.75.", 1.75, "iron")
			gv.up["MUD"].cost["cop"] = Ob.Num.new("2e6")
			gv.up["MUD"].cost["malig"] = Ob.Num.new(35000.0)
			gv.up["MUD"].requires = "RIB"
			gv.up[f].benefactor_of.append("irono")
			gv.up[f].benefactor_of.append("iron")
			
			f = "THYME"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Copper Ore and Copper LORED output x1.75.", 1.75, "cop")
			gv.up["THYME"].cost["iron"] = Ob.Num.new("2e6")
			gv.up["THYME"].cost["malig"] = Ob.Num.new(35000.0)
			gv.up["THYME"].requires = "FLANK"
			gv.up[f].benefactor_of.append("cop")
			gv.up[f].benefactor_of.append("copo")
			
			f = "RED GOOPY BOY"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Malignancy LORED output x1.4.", 1.4, "malig")
			gv.up["RED GOOPY BOY"].cost["iron"] = Ob.Num.new(30000.0)
			gv.up["RED GOOPY BOY"].cost["cop"] = Ob.Num.new(30000.0)
			gv.up["RED GOOPY BOY"].cost["malig"] = Ob.Num.new(50.0)
			gv.up["RED GOOPY BOY"].requires = "STICKYTAR"
			gv.up[f].benefactor_of.append("malig")
			
			f = "SALT"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Iron LORED output x1.25.", 1.25, "iron")
			gv.up["SALT"].cost["growth"] = Ob.Num.new(150.0)
			gv.up[f].benefactor_of.append("iron")
			gv.up[f].requires = "MIXER"
			
			f = "RIB"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Copper LORED output x1.4.", 1.4, "cop")
			gv.up["RIB"].cost["malig"] = Ob.Num.new(125.0)
			gv.up["RIB"].requires = "SALT"
			gv.up[f].benefactor_of.append("cop")
			
			f = "GRANDPA"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Stone LORED output x1.35.", 1.35, "stone")
			gv.up["GRANDPA"].cost["iron"] = Ob.Num.new(2500.0)
			gv.up["GRANDPA"].cost["cop"] = Ob.Num.new(2500.0)
			gv.up["GRANDPA"].requires = "GRANDMA"
			gv.up[f].benefactor_of.append("stone")
			
			f = "MAXER"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Concrete LORED output x1.4.", 1.4, "conc")
			gv.up["MAXER"].cost["growth"] = Ob.Num.new(400.0)
			gv.up["MAXER"].requires = "SWIRLER"
			gv.up[f].benefactor_of.append("conc")
			
			f = "WATT?"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Joule LORED output x1.45.", 1.45, "jo")
			gv.up["WATT?"].cost["iron"] = Ob.Num.new(3500.0)
			gv.up["WATT?"].cost["cop"] = Ob.Num.new(3500.0)
			gv.up[f].requires = "MIXER"
			gv.up[f].benefactor_of.append("jo")
			
			f = "CHEEKS"
			gv.up[f] = Upgrade.new(f, "s1 nup out","Oil LORED output x1.5.", 1.5, "oil")
			gv.up["CHEEKS"].cost["coal"] = Ob.Num.new(30000.0)
			gv.up["CHEEKS"].cost["stone"] = Ob.Num.new(200000.0)
			gv.up["CHEEKS"].cost["iron"] = Ob.Num.new(120000.0)
			gv.up["CHEEKS"].cost["cop"] = Ob.Num.new(40000.0)
			gv.up["CHEEKS"].cost["growth"] = Ob.Num.new(1500.0)
			gv.up["CHEEKS"].cost["conc"] = Ob.Num.new(5000.0)
			gv.up["CHEEKS"].cost["malig"] = Ob.Num.new(15.0)
			gv.up["CHEEKS"].cost["oil"] = Ob.Num.new(1.0)
			gv.up[f].requires = "SALT"
			gv.up[f].benefactor_of.append("oil")
	
	# upburn
	if true:
		
		# s2m
		if true:
			
			f = "Sick of the Sun"
			gv.up[f] = Upgrade.new(f, "s2 mup burn", "Stage 2 inputs x0.9.", 0.9, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new("400e9")
			gv.up[f].requires = "ONE PUNCH"
			gv.up[f].benefactor_of.append("s2")
			
			f = "I Disagree"
			gv.up[f] = Upgrade.new(f, "s2 mup burn", "Stage 2 inputs x0.9.", 0.9, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new("150e6") # million
			gv.up[f].requires = "is it SUPPOSED to be stick dudes?"
			gv.up[f].benefactor_of.append("s2")
			
			# benefits s1
			if true:
				
				f = "KETO"
				gv.up[f] = Upgrade.new(f, "s2 mup burn","Iron LORED Iron Ore input x0.1;\nCopper LORED Copper Ore input x0.1.", 0.1, "irono")
				gv.up[f].cost["tum"] = Ob.Num.new(100000) # m
				gv.up[f].requires = "Elbow Straps"
				gv.up[f].benefactor_of.append("iron irono")
				gv.up[f].benefactor_of.append("cop copo")
		
		# s2n
		if true:
			
			f = "Fleeormp"
			gv.up[f] = Upgrade.new(f, "s2 nup burn", "Lead LORED Galena input x0.8.", 0.8, "gale")
			gv.up[f].cost["gale"] = Ob.Num.new("100e6")
			gv.up[f].cost["lead"] = Ob.Num.new("80e6")
			gv.up[f].cost["wire"] = Ob.Num.new("50e6")
			gv.up[f].requires = "Le Guin"
			gv.up[f].benefactor_of.append("lead gale")
			
			f = "Squeeomp"
			gv.up[f] = Upgrade.new(f, "s2 nup burn", "Plastic LORED Petroleum input x0.85.", 0.85, "plast")
			gv.up[f].cost["toba"] = Ob.Num.new("12e9")
			gv.up[f].cost["carc"] = Ob.Num.new("3e9")
			gv.up[f].requires = "Toriyama"
			gv.up[f].benefactor_of.append("plast pet")
			
			f = "Barely Wood by Now"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Hardwood LORED Wood input x0.8.", .8, "hard")
			gv.up[f].cost["steel"] = Ob.Num.new("15e9")
			gv.up[f].cost["carc"] = Ob.Num.new("1e9")
			gv.up[f].requires = "Hardwood Yo Mama"
			gv.up[f].benefactor_of.append("hard wood")
			
			f = "MAGNETIC ACCELERATOR"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Glass LORED Sand input x0.8.", .8, "glass")
			gv.up[f].cost["wire"] = Ob.Num.new("750e6") #mil
			gv.up[f].cost["carc"] = Ob.Num.new("25e6") #mil
			gv.up[f].requires = "MGALEKGOLO"
			gv.up[f].benefactor_of.append("glass sand")
			
			f = "POTENT"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Tobacco LORED Water input x0.85.", 0.85, "toba")
			gv.up[f].cost["seed"] = Ob.Num.new("30e6")
			gv.up[f].cost["paper"] = Ob.Num.new("45e6")
			gv.up[f].cost["soil"] = Ob.Num.new("60e6")
			gv.up[f].requires = "Le Guin"
			gv.up[f].benefactor_of.append("toba water")
			
			f = "Hardwood Yo Mama"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Axe LORED Hardwood input x0.8.", .8, "hard")
			gv.up[f].cost["steel"] = Ob.Num.new("750e6")
			gv.up[f].cost["carc"] = Ob.Num.new("25e6")
			gv.up[f].requires = "ERECTWOOD"
			gv.up[f].benefactor_of.append("axe hard")
			
			f = "Steel Yo Mama"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Steel LORED Liquid Iron input x0.85.", .85, "steel")
			gv.up[f].cost["glass"] = Ob.Num.new("750e6")
			gv.up[f].cost["carc"] = Ob.Num.new("25e6")
			gv.up[f].requires = "Steely Dan"
			gv.up[f].benefactor_of.append("steel liq")
			
			f = "PULLEY"
			gv.up[f] = Upgrade.new(f, "s2 nup burn", "Wire LORED Draw Plate input x0.9.", 0.9, "wire")
			gv.up[f].cost["hard"] = Ob.Num.new("95e6")
			gv.up[f].cost["carc"] = Ob.Num.new("1e6")
			gv.up[f].requires = "Where's the boy, String?"
			gv.up[f].benefactor_of.append("wire draw")
			
			f = "Light as a Feather"
			gv.up[f] = Upgrade.new(f, "s2 nup burn", "Axe LORED Steel input x0.9.", 0.9, "steel")
			gv.up[f].cost["draw"] = Ob.Num.new("10e6")
			gv.up[f].cost["carc"] = Ob.Num.new("10e6")
			gv.up[f].requires = "Le Guin"
			gv.up[f].benefactor_of.append("axe steel")
			
			f = "Squeeormp"
			gv.up[f] = Upgrade.new(f, "s2 nup burn", "Plastic LORED Petroleum input x0.9.", 0.9, "plast")
			gv.up[f].cost["carc"] = Ob.Num.new(100000.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("plast pet")
			
			f = "Sandal Flandals"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Sand LORED Humus input x0.8.", 0.8, "humus")
			gv.up[f].cost["sand"] = Ob.Num.new(100000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(10000.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("sand humus")
			
			f = "VIRILE"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Tobacco LORED Seed input x0.85.", 0.85, "toba")
			gv.up[f].cost["ciga"] = Ob.Num.new(50000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(1500.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("toba seed")
			
			f = "Lembas Water"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Tree LORED Water input x0.8.", .8, "tree")
			gv.up[f].cost["toba"] = Ob.Num.new(45.0)
			gv.up[f].cost["water"] = Ob.Num.new(300.0)
			gv.up[f].requires = "Sagan"
			gv.up[f].benefactor_of.append("tree water")
			
			f = "This Might Pay Off Someday"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Liquid Iron LORED Iron input x0.9.", .9, "iron")
			gv.up[f].cost["iron"] = Ob.Num.new("1e6")
			gv.up[f].requires = "Double Barrels"
			gv.up[f].benefactor_of.append("liq iron")
			
			f = "Steel Yourself"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Steel LORED Liquid Iron input x0.9.", .9, "steel")
			gv.up[f].cost["glass"] = Ob.Num.new(200.0)
			gv.up[f].requires = "Carlin"
			gv.up[f].benefactor_of.append("steel liq")
			
			f = "Decisive Strikes"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Wood LORED Axes input x0.9.", .9, "wood")
			gv.up[f].cost["wire"] = Ob.Num.new(350.0)
			gv.up[f].cost["glass"] = Ob.Num.new(425.0)
			gv.up[f].cost["soil"] = Ob.Num.new(500.0)
			gv.up[f].benefactor_of.append("wood axe")
			
			f = "Hardwood Yourself"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Axe LORED Hardwood input x0.8.", .8, "hard")
			gv.up[f].cost["steel"] = Ob.Num.new(185.0)
			gv.up[f].requires = "Carlin"
			gv.up[f].benefactor_of.append("axe hard")
			
			f = "2552"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Glass LORED Sand input x0.85.", .85, "glass")
			gv.up[f].cost["wire"] = Ob.Num.new(750.0)
			gv.up[f].cost["carc"] = Ob.Num.new(25.0)
			gv.up[f].requires = "PLASMA BOMBARDMENT"
			gv.up[f].benefactor_of.append("glass sand")
			
			f = "Quormps"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Steel LORED Liquid Iron input x0.85.", .85, "steel")
			gv.up[f].cost["glass"] = Ob.Num.new(4500.0)
			gv.up[f].cost["carc"] = Ob.Num.new(200.0)
			gv.up[f].requires = "Quamps"
			gv.up[f].benefactor_of.append("steel liq")
			
			f = "Cutting Corners"
			gv.up[f] = Upgrade.new(f, "s2 nup burn","Hardwood LORED Wood input x0.85.", .85, "hard")
			gv.up[f].cost["steel"] = Ob.Num.new(5500.0)
			gv.up[f].cost["carc"] = Ob.Num.new(200.0)
			gv.up[f].requires = "Millery"
			gv.up[f].benefactor_of.append("hard wood")
			
			f = "Bigger Trees I Guess"
			gv.up[f] = Upgrade.new(f, "s2 nup burn", "Wood LORED Tree input x0.9.", .9, "wood")
			gv.up[f].cost["plast"] = Ob.Num.new(10000.0)
			gv.up[f].cost["pulp"] = Ob.Num.new(1000.0)
			gv.up[f].requires = "Sagan"
			gv.up[f].benefactor_of.append("wood tree")
			
			f = "Hole Geometry"
			gv.up[f] = Upgrade.new(f, "s2 nup burn", "Wire LORED Draw Plate input x0.9.", .9, "wire")
			gv.up[f].cost["pulp"] = Ob.Num.new(10000.0)
			gv.up[f].cost["hard"] = Ob.Num.new(5200.0)
			gv.up[f].cost["carc"] = Ob.Num.new(200.0)
			gv.up[f].requires = "GIMP"
			gv.up[f].benefactor_of.append("wire draw")
			
			f = "Flippy Floppies"
			gv.up[f] = Upgrade.new(f, "s2 nup burn", "Sand LORED Humus input x0.9.", .9, "humus")
			gv.up[f].cost["carc"] = Ob.Num.new(850.0)
			gv.up[f].requires = "Unpredictable Weather"
			gv.up[f].benefactor_of.append("sand humus")
		
		# s1n
		if true:
			
			f = "STICKYTAR"
			gv.up[f] = Upgrade.new(f, "s1 nup burn","Malignancy LORED Tarball input x0.5.", 0.5, "malig")
			gv.up[f].cost["growth"] = Ob.Num.new(1400.0)
			gv.up[f].cost["oil"] = Ob.Num.new(75.0)
			gv.up[f].requires = "SLIMER"
			gv.up[f].benefactor_of.append("malig tar")
	
	# upcrit
	if true:
		
		# s2m
		if true:
			
			f = "BLAM this piece of crap!"
			gv.up[f] = Upgrade.new(f, "s2 mup crit buff","Stage 2 +{crit}% crit chance.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new("16e9")
			gv.up[f].requires = "HOME-RUN BAT"
			gv.up[f].benefactor_of.append("s2")
			
			f = "is it SUPPOSED to be stick dudes?"
			gv.up[f] = Upgrade.new(f, "s2 mup crit buff","Stage 2 +{crit}% crit chance.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new("75e6") # million
			gv.up[f].requires = "Tolkien"
			gv.up[f].benefactor_of.append("s2")
		
		# s2n
		if true:
			
			f = "FINISH THE FIGHT"
			gv.up[f] = Upgrade.new(f, "s2 nup crit buff","Humus, Sand, and Glass LORED +{crit}% crit chance.", 1.0, "glass")
			gv.up[f].cost["wire"] = Ob.Num.new("1e12") # t
			gv.up[f].cost["carc"] = Ob.Num.new("250e9")
			gv.up[f].requires = "O'SALVATORI"
			gv.up[f].benefactor_of.append("humus")
			gv.up[f].benefactor_of.append("sand")
			gv.up[f].benefactor_of.append("glass")
			
			f = "MICROSOFT PAINT"
			gv.up[f] = Upgrade.new(f, "s2 nup crit buff","Draw Plate and Wire LORED +{crit}% crit chance.", 1.0, "wire")
			gv.up[f].cost["hard"] = Ob.Num.new("1e12")
			gv.up[f].cost["carc"] = Ob.Num.new("250e9")
			gv.up[f].requires = "low rises"
			gv.up[f].benefactor_of.append("wire")
			gv.up[f].benefactor_of.append("draw")
			
			f = "i'll show you hardwood"
			gv.up[f] = Upgrade.new(f, "s2 nup crit buff","Axe, Wood, and Hardwood LORED +{crit}% crit chance.", 1.0, "hard")
			gv.up[f].cost["steel"] = Ob.Num.new("1e12") # t
			gv.up[f].cost["carc"] = Ob.Num.new("250e9")
			gv.up[f].requires = "Barely Wood by Now"
			gv.up[f].benefactor_of.append("hard")
			gv.up[f].benefactor_of.append("axe")
			gv.up[f].benefactor_of.append("wood")
			
			f = "Steel Lord"
			gv.up[f] = Upgrade.new(f, "s2 nup crit buff","Liquid Iron and Steel LORED +{crit}% crit chance.", 1.0, "steel")
			gv.up[f].cost["glass"] = Ob.Num.new("1e12") # t
			gv.up[f].cost["carc"] = Ob.Num.new("250e9")
			gv.up[f].requires = "Fingers of Onden"
			gv.up[f].benefactor_of.append("liq")
			gv.up[f].benefactor_of.append("steel")
			
			f = "O'SALVATORI"
			gv.up[f] = Upgrade.new(f, "s2 nup crit","Glass LORED +5% crit chance.", 5.0, "glass")
			gv.up[f].cost["wire"] = Ob.Num.new("15e9")
			gv.up[f].cost["carc"] = Ob.Num.new("1e9")
			gv.up[f].requires = "MAGNETIC ACCELERATOR"
			gv.up[f].benefactor_of.append("glass")
			
			f = "a bee with tiny daggers!!!"
			gv.up[f] = Upgrade.new(f, "s2 nup crit buff","Seed LORED +{crit}% crit chance.", 1.0, "abeewithdaggers")
			gv.up[f].cost["water"] = Ob.Num.new("1e9")
			gv.up[f].cost["seed"] = Ob.Num.new("25e6")
			gv.up[f].cost["carc"] = Ob.Num.new("10e6")
			gv.up[f].requires = "Busy Bee"
			gv.up[f].benefactor_of.append("seed")
			
			f = "Toriyama"
			gv.up[f] = Upgrade.new(f, "s2 nup crit buff","Stage 2 +{crit}% crit chance.", 1.0, "s2")
			gv.up[f].cost["steel"] = Ob.Num.new("1e9") # bil
			gv.up[f].cost["hard"] = Ob.Num.new("1e9") # bil
			gv.up[f].cost["wire"] = Ob.Num.new("1e9") # bil
			gv.up[f].cost["glass"] = Ob.Num.new("1e9") # bil
			gv.up[f].cost["carc"] = Ob.Num.new("50e6") # mil
			gv.up[f].requires = "Le Guin"
			gv.up[f].benefactor_of.append("s2")
			
			f = "Steely Dan"
			gv.up[f] = Upgrade.new(f, "s2 nup crit","Steel LORED +7% crit chance.", 7.0, "steel")
			gv.up[f].cost["glass"] = Ob.Num.new("3e7")
			gv.up[f].cost["carc"] = Ob.Num.new("1e6")
			gv.up[f].requires = "Expert Iron Worker"
			gv.up[f].benefactor_of.append("steel")
			
			f = "INDEPENDENCE"
			gv.up[f] = Upgrade.new(f, "s2 nup crit","Lead LORED +10% crit chance.", 10.0, "lead")
			gv.up[f].cost["gale"] = Ob.Num.new(450000.0)
			gv.up[f].cost["lead"] = Ob.Num.new(450000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(10000.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("lead")
			
			f = "Nikey Wikeys"
			gv.up[f] = Upgrade.new(f, "s2 nup crit","Humus LORED +7% crit chance.", 7.0, "humus")
			gv.up[f].cost["soil"] = Ob.Num.new("1e6")
			gv.up[f].cost["carc"] = Ob.Num.new(10000.0)
			gv.up[f].requires = "Cioran"
			gv.up[f].benefactor_of.append("humus")
			
			f = "Unpredictable Weather"
			gv.up[f] = Upgrade.new(f, "s2 nup crit","Water LORED +8% crit chance.", 8.0, "water")
			gv.up[f].cost["wire"] = Ob.Num.new(1000.0)
			gv.up[f].cost["glass"] = Ob.Num.new(1000.0)
			gv.up[f].cost["tree"] = Ob.Num.new(2500.0)
			gv.up[f].cost["carc"] = Ob.Num.new(35.0)
			gv.up[f].requires = "BREAK THE DAM"
			gv.up[f].benefactor_of.append("water")
			
			f = "Rogue Blacksmith"
			gv.up[f] = Upgrade.new(f, "s2 nup crit","Liquid Iron LORED +6% crit chance.", 6.0, "liq")
			gv.up[f].cost["wire"] = Ob.Num.new(1000.0)
			gv.up[f].cost["glass"] = Ob.Num.new(1000.0)
			gv.up[f].cost["carc"] = Ob.Num.new(35.0)
			gv.up[f].requires = "Apprentice Iron Worker"
			gv.up[f].benefactor_of.append("liq")
			
			f = "Apprentice Iron Worker"
			gv.up[f] = Upgrade.new(f, "s2 nup crit","Liquid Iron LORED +6% crit chance.", 6.0, "liq")
			gv.up[f].cost["steel"] = Ob.Num.new(25.0)
			gv.up[f].benefactor_of.append("liq")
			
			f = "Cioran"
			gv.up[f] = Upgrade.new(f, "s2 nup crit buff","Stage 2 +{crit}% crit chance.", 1.0, "s2")
			gv.up[f].cost["carc"] = Ob.Num.new(1000.0)
			gv.up[f].cost["tum"] = Ob.Num.new(100.0)
			gv.up[f].requires = "Sagan"
			gv.up[f].benefactor_of.append("s2")
		
		# s1m
		if true:
			
			f = "THIS GAME IS SO ESEY"
			gv.up[f] = Upgrade.new(f, "s1 mup crit","Stage 1 +5% crit chance.", 5.0)
			gv.up[f].cost["malig"] = Ob.Num.new("50e15")
			gv.up[f].requires = "SLUGGER"
			gv.up[f].benefactor_of.append("s1")

			f = "how is this an RPG anyway?"
			gv.up[f] = Upgrade.new(f, "s1 mup crit","Stage 1 +5% crit chance.", 5.0)
			gv.up[f].cost["malig"] = Ob.Num.new(10 * 1000.0)
			gv.up[f].requires = "SOCCER DUDE"
			gv.up[f].benefactor_of.append("s1")
	
	# upbuff
	if true:
		
		# s2m
		if true:
			
			f = "axman23 by now"
			gv.up[f] = Upgrade.new(f, "s2 mup benefactor crit", "Crit upgrades at +1% (base) +2%", 2.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new("720e9") # b
			gv.up[f].requires = "Sick of the Sun"
			
			f = "HOME-RUN BAT"
			gv.up[f] = Upgrade.new(f, "s2 mup benefactor add", "Output upgrades at +1 (base) +2.", 2.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new("1e9") # bil
			gv.up[f].requires = "I Disagree"
			
			f = "DOT DOT DOT"
			gv.up[f] = Upgrade.new(f, "s2 mup benefactor crit", "Crit upgrades at +1% (base) +1%", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new("50e9")
			gv.up[f].requires = "BLAM this piece of crap!"
			
			f = "Tolkien"
			gv.up[f] = Upgrade.new(f, "s2 mup benefactor add", "Output upgrades at +1 (base) +1.", 1.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new("5e7")
		
		# s2n
		if true:
			
			f = "Le Guin"
			gv.up[f] = Upgrade.new(f, "s2 nup benefactor haste", "Haste upgrades at 1.1x or less (base) x1.1.", 1.1, "s2")
			gv.up[f].cost["carc"] = Ob.Num.new("1e6") # mil
			gv.up[f].cost["tum"] = Ob.Num.new(100000)
			gv.up[f].requires = "Cioran"
	
	# upmisc
	if true:
		
		# s2mup
		if true:
			
			# limit break
			if true:
				
				f = "upgrade_description"
				gv.up[f] = Upgrade.new(f, "s2 mup misc", "Reduces the cost increase of every LORED by 10%; LORED fuel drain x10.0.", 0.0, "s2")
				gv.up[f].cost["tum"] = Ob.Num.new("1e14")
				gv.up[f].requires = "RELATIVITY"
				
				f = "RELATIVITY"
				gv.up[f] = Upgrade.new(f, "s2 mup misc", "LOREDs now load fuel much more quickly, based on how much they are missing from being full.", 0.0, "s2")
				gv.up[f].cost["tum"] = Ob.Num.new("1e11")
				gv.up[f].requires = "Tolkien"
				
				f = "LB9"
				gv.up[f] = Upgrade.new(f, "s1 mup lbmult", "Limit Break overcharge limit x2.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new("1e21")
				gv.up[f].requires = "LB8"
				
				f = "LB8"
				gv.up[f] = Upgrade.new(f, "s1 mup lbmult", "Limit Break overcharge limit x2.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new("1e18")
				gv.up[f].requires = "LB7"
				
				f = "LB7"
				gv.up[f] = Upgrade.new(f, "s1 mup lbmult", "Limit Break overcharge limit x2.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new("1e15") # 1e15
				gv.up[f].requires = "Share the Hit"
				
				f = "Share the Hit"
				gv.up[f] = Upgrade.new(f, "s1 mup misc", "Limit Break now also applies to Stage 2 LOREDs.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new("1e12") # 1e12
				gv.up[f].requires = "LB6"
				
				f = "LB6"
				gv.up[f] = Upgrade.new(f, "s1 mup lbmult", "Limit Break overcharge limit x2.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new("1e11")
				gv.up[f].requires = "LB5"
				
				f = "LB5"
				gv.up[f] = Upgrade.new(f, "s1 mup lbmult", "Limit Break overcharge limit x2.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new("1e10")
				gv.up[f].requires = "LB4"
				
				f = "LB4"
				gv.up[f] = Upgrade.new(f, "s1 mup lbmult", "Limit Break overcharge limit x2.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new("1e9")
				gv.up[f].requires = "LB3"
				
				f = "LB3"
				gv.up[f] = Upgrade.new(f, "s1 mup lbmult", "Limit Break overcharge limit x2.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new("1e7") # 1e7
				gv.up[f].requires = "LB2"
				
				f = "LB2"
				gv.up[f] = Upgrade.new(f, "s1 mup lbmult", "Limit Break overcharge limit x2.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new("1e6") # 1e6
				gv.up[f].requires = "LB1"
				
				f = "LB1"
				gv.up[f] = Upgrade.new(f, "s1 mup lbmult", "Limit Break overcharge limit x2.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new(1000.0) # 1e3
				gv.up[f].requires = "LB0"
				
				f = "LB0"
				gv.up[f] = Upgrade.new(f, "s1 mup lbmult", "Limit Break overcharge limit x2.", 0.0, "s2")
				gv.up[f].cost["malig"] = Ob.Num.new(100.0) # 1e2
				gv.up[f].requires = "Limit Break"
				
				f = "Limit Break"
				gv.up[f] = Upgrade.new(f, "s2 mup lbmult", "Stage 1 LOREDs now continue to fill their fuel containers to overcharge their output.", 0.0, "s2")
			
			f = "dust"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","Metastasizing no longer resets Stage 1 LORED levels.", 0.0, "s1")
			gv.up[f].cost["tum"] = Ob.Num.new("750e9")
			gv.up[f].requires = "CAPITAL PUNISHMENT"
			
			f = "AntiSoftLock"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","After you receive Chemotherapy, begin the game with +10,000 of every Stage 2 resource.", 0.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new("250e9")
			gv.up[f].requires = "I know what I'm doing, unlock this shit"
			
			f = "OH YEEAAAAHH"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","After you receive Chemotherapy, begin the game with +1,000 Steel, Hardwood, Wire, and Glass.", 0.0, "s2")
			gv.up[f].cost["tum"] = Ob.Num.new("3e6") # k
			gv.up[f].requires = "Life Ins, RIP Grandma"
			
			f = "what in cousin-fuckin tarnation alabama betty crocker miss fuckin betty white shit is this"
			gv.up[f] = Upgrade.new(f, "s2 mup cremover","Your Tarball LORED no longer costs Malignancy.", 0.0, "tar")
			gv.up[f].cost["tum"] = Ob.Num.new("6e9")
			gv.up[f].requires = "IT'S SPREADIN ON ME"
			gv.up[f].benefactor_of.append("tar malig")
			
			f = "Hey, that's pretty good!"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","Tumor gain from the Malignant upgrade PROCEDURE x1.5.", 1.5, "s1mup")
			gv.up[f].cost["tum"] = Ob.Num.new(750000)
			gv.up[f].requires = "KETO"
			
			f = "Power Schlonks"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","Tumor gain from the Malignant upgrade PROCEDURE x3.0.", 3.0, "s1mup")
			gv.up[f].cost["tum"] = Ob.Num.new("15e6") # mil
			gv.up[f].requires = "Hey, that's pretty good!"
			
			f = "CONDUCT"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","Metastasizing no longer resets Stage 1 resources.", 0.0, "s1mup")
			gv.up[f].cost["tum"] = Ob.Num.new("45e6") # mil
			gv.up[f].requires = "Power Schlonks"
			
			f = "Mega Wonks"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","Tumor gain from the Malignant upgrade PROCEDURE x10.0.", 10.0, "s1mup")
			gv.up[f].cost["tum"] = Ob.Num.new("2.5e9")
			gv.up[f].requires = "CONDUCT"
			
			f = "CAPITAL PUNISHMENT"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","Tumor gain from the Malignant upgrade PROCEDURE is multiplied by your Stage 1 run count.", 1.0, "s1mup")
			gv.up[f].cost["tum"] = Ob.Num.new("250e9")
			gv.up[f].requires = "Mega Wonks"
			
			f = "IT'S SPREADIN ON ME"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","Malignant upgrade IT'S GROWIN ON ME now always applies its buff to both your Iron AND Copper LOREDs, as well as your Iron Ore and Copper Ore LOREDs.", 0.0, "growth")
			gv.up[f].cost["tum"] = Ob.Num.new("25e6") # mil
			gv.up[f].requires = "KETO"
			
			f = "the athore coments al totol lies!"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","Stage 1 crits gain a 1% chance to crit.", 0.0, "s1")
			gv.up[f].cost["tum"] = Ob.Num.new("33e6") # mil
			gv.up[f].requires = "we were so close, now you don't even think about me"
			
			f = "I know what I'm doing, unlock this shit"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","Extra-normal upgrades are now unlocked immediately after you receive Chemotherapy.", 0.0, "s2nup")
			gv.up[f].cost["tum"] = Ob.Num.new("10e6")
			gv.up[f].requires = "OH YEEAAAAHH"
			
			f = "Life Ins, RIP Grandma"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","After you receive Chemotherapy, begin the game with +60 Steel, +60 Hardwood, +60 Wire, and +100 Glass.", 0.0, "glass")
			gv.up[f].cost["tum"] = Ob.Num.new("100e3")
			gv.up[f].requires = "DIII Boost From Clan Mate"
			
			f = "DIII Boost From Clan Mate"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","After you receive Chemotherapy, begin the game with +20 Steel, +20 Hardwood, and +40 Wire.", 0.0, "wire")
			gv.up[f].cost["tum"] = Ob.Num.new("15e3")
			gv.up[f].requires = "Road Head Start"
			
			f = "Road Head Start"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","After you receive Chemotherapy, begin the game with +10 Steel and +20 Hardwood.", 0.0, "hard")
			gv.up[f].cost["tum"] = Ob.Num.new("2e3")
			gv.up[f].requires = "Rock-hard Entrance"
			
			f = "Rock-hard Entrance"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","After you receive Chemotherapy, begin the game with +10 Steel", 0.0, "steel")
			gv.up[f].cost["tum"] = Ob.Num.new(100)
			gv.up[f].requires = "FALCON PAWNCH"
			
			f = "don't take candy from babies"
			gv.up[f] = Upgrade.new(f, "s2 mup misc","Stage 2 and up LOREDs will not take fuel or resources from a Stage 1 LORED if it is level 5 or below.", 0.0)
			gv.up[f].cost["tum"] = Ob.Num.new(1000)
			gv.up[f].requires = "MECHANICAL"
			
			# benefits stage 1 only
			if true:
				
				f = "Combo Breaker"
				gv.up[f] = Upgrade.new(f, "s2 mup misc", "The Malignant upgrades OREOREUHBor E ALICE and AUTOSHOVELER persist through Chemotherapy.",0.0,  "coal")
				gv.up[f].cost["tum"] = Ob.Num.new(195000)
				gv.up[f].requires = "CARAVAN"
				
				f = "CARAVAN"
				gv.up[f] = Upgrade.new(f, "s2 mup misc","The Malignant upgrades AUTOPOLICE and AUTOSTONER persist through Chemotherapy.",0.0, "stone")
				gv.up[f].cost["tum"] = Ob.Num.new(175000)
				gv.up[f].requires = "UNIONIZE"
				
				f = "UNIONIZE"
				gv.up[f] = Upgrade.new(f, "s2 mup misc","The Malignant upgrades MOIST and pippenpaddle- oppsoCOPolis persist through Chemotherapy.", 0.0, "copo")
				gv.up[f].cost["tum"] = Ob.Num.new(155000)
				gv.up[f].requires = "Jasmine"
				
				f = "Jasmine"
				gv.up[f] = Upgrade.new(f, "s2 mup misc","The Malignant upgrades CANKERITE and wtf is that musk persist through Chemotherapy.", 0.0, "jo")
				gv.up[f].cost["tum"] = Ob.Num.new(135000)
				gv.up[f].requires = "Mad Science"
				
				f = "Mad Science"
				gv.up[f] = Upgrade.new(f, "s2 mup misc","The Malignant upgrades SLAPAPOW! and SENTIENT DERRICK persist through Chemotherapy.", 0.0, "tar")
				gv.up[f].cost["tum"] = Ob.Num.new(115000)
				gv.up[f].requires = "AUTO-PERSIST"
				
				f = "AUTO-PERSIST"
				gv.up[f] = Upgrade.new(f, "s2 mup misc","The Malignant upgrades MOUND and SIDIUS IRON persist through Chemotherapy.", 0.0, "malig")
				gv.up[f].cost["tum"] = Ob.Num.new(95000)
				gv.up[f].requires = "RED NECROMANCY"
				
				f = "THE WITCH OF LOREDELITH"
				gv.up[f] = Upgrade.new(f, "s2 mup misc","Stage 1 LOREDs produce %s of their (output * haste modifier) each frame.", 0.0, "thewitchofloredelith")
				gv.up[f].cost["tum"] = Ob.Num.new(50 * 1000)
				gv.up[f].requires = "RED NECROMANCY"
				
				f = "GRIMOIRE"
				gv.up[f] = Upgrade.new(f, "s2 mup misc","Radiative upgrade THE WITCH OF LOREDELITH percent modifier is affected by your Stage 1 run count.", 0.0, "thewitchofloredelith")
				gv.up[f].cost["tum"] = Ob.Num.new("5e9")
				gv.up[f].requires = "THE WITCH OF LOREDELITH"
		
		# s1mup
		if true:
			
			f = "ROUTINE"
			gv.up[f] = Upgrade.new(f, "s1 mup misc","Metastasizes and then resets this upgrade.", 0.0, "s1mup")
			gv.up[f].cost["malig"] = Ob.Num.new("1e24")
			gv.up[f].requires = "PROCEDURE"
			
			f = "PROCEDURE"
			gv.up[f] = Upgrade.new(f, "s1 mup misc","Metastasizing will now reward you with %s Tumors.", 1000000.0, "tum")
			gv.up[f].cost["malig"] = Ob.Num.new("3e20")
			gv.up[f].requires = "RED NECROMANCY"
			
			f = "aw <3"
			gv.up[f] = Upgrade.new(f, "s1 mup misc","Start the game with a free Coal LORED.", 0.0, "coal")
			gv.up[f].cost["malig"] = Ob.Num.new(2.0)
			gv.up[f].requires = "ENTHUSIASM"
			
			f = "THE THIRD"
			gv.up[f] = Upgrade.new(f, "s1 mup misc","Whenever your Copper Ore LORED produces ore, it will produce an equal amount of Copper.", 0.0, "copo")
			gv.up[f].cost["malig"] = Ob.Num.new("2e8")
			gv.up[f].requires = "pippenpaddle- oppsoCOPolis"
			
			f = "I RUN"
			gv.up[f] = Upgrade.new(f, "s1 mup misc","Whenever your Iron Ore LORED produces ore, it will produce an equal amount of Iron.",0.0, "irono")
			gv.up[f].cost["malig"] = Ob.Num.new("25e9")
			
			f = "wait that's not fair"
			gv.up[f] = Upgrade.new(f, "s1 mup misc","Whenever your Coal LORED produces Coal, it produces ten times as much Stone.", 0.0, "stone")
			gv.up["wait that's not fair"].cost["malig"] = Ob.Num.new("1e18")
			
			f = "IT'S GROWIN ON ME"
			gv.up[f] = Upgrade.new(f, "s1 mup misc","Whenever Growth is spawned, either your Iron or your Copper LORED will receive an output boost based on your Growth LORED's level.", 0.0, "growth")
			gv.up[f].cost["malig"] = Ob.Num.new(2000.0)
			
			f = "upgrade_name"
			gv.up[f] = Upgrade.new(f, "s1 mup misc","Reduces the cost increase of every Stage 1 LORED from x3.0 to x2.75; Stage 1 burner LORED fuel drain x10.0.", 2.75, "s1", 3.0)
			gv.up[f].cost["malig"] = Ob.Num.new("25e6")
			gv.up[f].requires = "ORE LORD"



func _physics_process(delta):
	
	autobuyer_fps += delta
	if autobuyer_fps < 1: return
	
	autobuyer_fps -= 1
	w_autobuyer()



func w_autobuyer():
	
	for x in gv.stats.up_list["autoup"]:
		
		# catches
		if not gv.up[x].have:
			continue
		if not gv.up[x].active:
			continue
		if "no" in gv.menu.f:
			if int(gv.up[x].type[1]) <= int(gv.menu.f.split("no s")[1]): continue
		if " " in gv.up[x].benefactor_of[0]:
			var path : String = gv.up[x].benefactor_of[0].split(" ")[0] + gv.up[x].benefactor_of[0].split(" ")[1]
			if gv.menu.upgrades_owned[path] == rt.upc[path].size(): continue
		
		b_autobuyer_assist(x)
func b_autobuyer_assist(b : String) -> void:
	
	# catches
	if b == "RED NECROMANCY" and gv.g["malig"].r.isEqualTo(10):
		return
	
	# s1
	if gv.up[b].benefactor_of[0].split(" ")[0] == "s1":
		
		var path = "s1" + gv.up[b].benefactor_of[0].split(" ")[1]
		
		for x in rt.upc[path]:
			
			if gv.up[x].have: continue
			var cont := false
			for c in gv.up[x].cost:
				if gv.g[c].r.isLessThan(gv.up[x].cost[c].t):
					cont = true
					break
			if cont: continue
			
			rt.upc[path][x].buy_upgrade(x, false, true)
		
		return
	
	for x in gv.up:
		
		# catches
		if gv.up[x].have: continue
		if gv.up[b].benefactor_of[0] == "seed" and gv.up[x].main_lored_target == "abeewithdaggers":
			pass
		else:
			if not gv.up[b].benefactor_of[0] == gv.up[x].main_lored_target: continue
		if "mup" in gv.up[x].type: continue
		if not own_list_good[int(gv.up[b].type[1])]:
			var must_own_list := ["seed", "tree", "water", "soil", "humus", "sand", "glass", "liq", "steel", "hard", "axe", "wood", "draw","wire"]
			var cont := false
			for v in must_own_list:
				if not gv.g[v].active:
					cont = true
					break
			if cont: continue
			own_list_good[2] = true
		
		rt.upc[gv.up[x].path][x].buy_upgrade(x, false, true)

func r_update(folder : String) -> void:
	
	if folder == "all":
		for x in get_children():
			if "dtext" in x.name:
				continue
			for v in get_node(x.name).get_children():
				get_node(x.name).get_node(v.name).modulated_one_last_time = false
				get_node(x.name).get_node(v.name).r_update()
		return
	
	for x in get_node(folder).get_children():
		get_node(folder).get_node(x.name).r_update()


