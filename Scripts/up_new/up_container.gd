extends MarginContainer

onready var rt = get_node("/root/Root")
onready var confirmReset = get_node("%confirmReset")



#var fps := 0.0



var src := {
	upgrade_block = preload("res://Prefabs/upgrade/Upgrade Block.tscn"),
	hbox = preload("res://Prefabs/template/HBoxContainer 10 separation.tscn"),
}

var color := {
	gv.Tab.NORMAL: Color(0.733333, 0.458824, 0.031373),
	gv.Tab.MALIGNANT: Color(0.878431, 0.121569, 0.34902),
	gv.Tab.EXTRA_NORMAL: Color(0.47451, 0.870588, 0.694118),
	gv.Tab.RADIATIVE: Color(1, 0.541176, 0.541176),
	gv.Tab.RUNED_DIAL: Color(0.25098, 0.470588, 0.992157),
	gv.Tab.SPIRIT: Color(0.670588, 0.34902, 0.890196),
}

var cont := {}
var cont_flying_texts := {}
var stored_verticals := {gv.Tab.NORMAL: 0, gv.Tab.MALIGNANT: 0, gv.Tab.EXTRA_NORMAL: 0, gv.Tab.RADIATIVE: 0, gv.Tab.RUNED_DIAL: 0, "s3m": 0, "s4n": 0, "s4m": 0}


const gn := {
	category = "v/upgrades/v/%s/v",
}
const gnBack_arrow := "v/header/h/v/m/h/icon/Sprite"
const gnTitle_text := "v/header/h/v/m/h/text"
const gncount := "v/header/h/v/m/h/count"
const gnowned := "v/header/h/v/options/owned"
const gnunowned := "v/header/h/v/options/unowned"
const gnlocked := "v/header/h/v/options/locked"
const gnIcon := "v/header/h/icon/Sprite"

onready var reset = get_node("v/reset/reset")
onready var reset_b = get_node("v/reset/reset/button")
onready var reset_t = get_node("v/reset/reset/m/text")



func _ready():
	
	$v.hide()
	$top.show()
	
	for x in get_node("top").get_children():
		if x.name == str(gv.Tab.NORMAL):
			continue
		x.hide()
	
	gv.connect("upgrade_purchased", self, "upgrade_purchased")
	
	set_physics_process(false)
	set_process(false)

func procedure():
	
	# called at the bottom of the func that positions every upgrade
	
	while shouldDisplayResetResource() and visible:
		
		setResetResourceText()
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	procedure()

func shouldDisplayResetResource() -> bool:
	if gv.open_tab == gv.Tab.MALIGNANT:
		if not gv.up["PROCEDURE"].active():
			return false
		if gv.resource[gv.Resource.MALIGNANCY].less(gv.up["ROUTINE"].cost["malig"].t):
			return false
	
	return true

func setupResetResource():
	
	var color: Color
	var resource: int
	
	if gv.open_tab == gv.Tab.MALIGNANT:
		resource = gv.Resource.TUMORS
	
	color = gv.COLORS[gv.shorthandByResource[resource]]
	
	get_node("%resetResource/amount").self_modulate = color
	get_node("%resetResource/name").self_modulate = color
	
	get_node("%resetResource/name").text = gv.resourceName[resource]
	
	get_node("%resetResource/icon/Sprite").texture = gv.sprite[gv.shorthandByResource[resource]]
	get_node("%resetResource/icon/Sprite/shadow").texture = get_node("%resetResource/icon/Sprite").texture
	
	setResetResourceText()
	
	get_node("%resetResource").show()

func setResetResourceText():
	match gv.open_tab:
		gv.Tab.MALIGNANT:
			var routine = rt.get_node(rt.gnupcon).cont["ROUTINE"].get_routine_info()[0].toString()
			get_node("%resetResource/amount").text = "(" + routine



func init() -> void:
	
	var i = 0
	var stage = "1"
	var parent_path = gn.category % "0"
	
	# s1n
	if true:
		
		instance_block("GRINDER", parent_path, "h" + str(i))
		instance_block("LIGHTER SHOVEL", parent_path, "h" + str(i))
		
		i += 1
		instance_block("TEXAS", parent_path, "h" + str(i))
		instance_block("RYE", parent_path, "h" + str(i))
		instance_block("GRANDER", parent_path, "h" + str(i))
		instance_block("SAALNDT", parent_path, "h" + str(i))
		
		i += 1
		instance_block("SALT", parent_path, "h" + str(i))
		instance_block("SAND", parent_path, "h" + str(i))
		instance_block("GRANDMA", parent_path, "h" + str(i))
		instance_block("MIXER", parent_path, "h" + str(i))
		
		i += 1
		instance_block("FLANK", parent_path, "h" + str(i))
		instance_block("RIB", parent_path, "h" + str(i))
		instance_block("GRANDPA", parent_path, "h" + str(i))
		instance_block("WATT?", parent_path, "h" + str(i))
		instance_block("SWIRLER", parent_path, "h" + str(i))
		
		i += 1
		instance_block("GEARED OILS", parent_path, "h" + str(i))
		instance_block("CHEEKS", parent_path, "h" + str(i))
		instance_block("GROUNDER", parent_path, "h" + str(i))
		instance_block("MAXER", parent_path, "h" + str(i))
		
		i += 1
		instance_block("THYME", parent_path, "h" + str(i))
		instance_block("PEPPER", parent_path, "h" + str(i))
		instance_block("ANCHOVE COVE", parent_path, "h" + str(i))
		instance_block("GARLIC", parent_path, "h" + str(i))
		instance_block("MUD", parent_path, "h" + str(i))
		
		i += 1
		instance_block("SLOP", parent_path, "h" + str(i))
		instance_block("SLIMER", parent_path, "h" + str(i))
		instance_block("STICKYTAR", parent_path, "h" + str(i))
		
		i += 1
		instance_block("INJECT", parent_path, "h" + str(i))
		instance_block("RED GOOPY BOY", parent_path, "h" + str(i))
	
	# s1m
	if true:
		
		i = 0
		stage = "1"
		parent_path = gn.category % "1"
		
		#i += 1
		instance_block("AUTOSHOVELER", parent_path, "h" + str(i))
		instance_block("SOCCER DUDE", parent_path, "h" + str(i))
		
		i += 1
		instance_block("aw <3", parent_path, "h" + str(i))
		instance_block("ENTHUSIASM", parent_path, "h" + str(i))
		instance_block("CON-FRICKIN-CRETE", parent_path, "h" + str(i))
		instance_block("how is this an RPG anyway?", parent_path, "h" + str(i))
		instance_block("IT'S GROWIN ON ME", parent_path, "h" + str(i))
		
		i += 1
		instance_block("AUTOSTONER", parent_path, "h" + str(i))
		instance_block("OREOREUHBor E ALICE", parent_path, "h" + str(i))
		instance_block("you little hard worker, you", parent_path, "h" + str(i))
		
		i += 1
		instance_block("COMPULSORY JUICE", parent_path, "h" + str(i))
		instance_block("BIG TOUGH BOY", parent_path, "h" + str(i))
		
		i += 1
		instance_block("STAY QUENCHED", parent_path, "h" + str(i))
		instance_block("OH, BABY, A TRIPLE", parent_path, "h" + str(i))
		
		i += 1
		instance_block("AUTOPOLICE", parent_path, "h" + str(i))
		instance_block("pippenpaddle- oppsoCOPolis", parent_path, "h" + str(i))
		instance_block("I DRINK YOUR MILKSHAKE", parent_path, "h" + str(i))
		instance_block("ORE LORD", parent_path, "h" + str(i))
		
		i += 1
		instance_block("MOIST", parent_path, "h" + str(i))
		instance_block("THE THIRD", parent_path, "h" + str(i))
		instance_block("we were so close, now you don't even think about me", parent_path, "h" + str(i))
		instance_block("upgrade_name", parent_path, "h" + str(i))
		
		i += 1
		instance_block("wtf is that musk", parent_path, "h" + str(i))
		instance_block("CANCER'S COOL", parent_path, "h" + str(i))
		instance_block("I RUN", parent_path, "h" + str(i))
		instance_block("coal DUDE", parent_path, "h" + str(i))
		
		i += 1
		instance_block("CANKERITE", parent_path, "h" + str(i))
		instance_block("SENTIENT DERRICK", parent_path, "h" + str(i))
		instance_block("SLAPAPOW!", parent_path, "h" + str(i))
		instance_block("SIDIUS IRON", parent_path, "h" + str(i))
		
		i += 1
		instance_block("MOUND", parent_path, "h" + str(i))
		instance_block("FOOD TRUCKS", parent_path, "h" + str(i))
		instance_block("OPPAI GUY", parent_path, "h" + str(i))
		
		i += 1
		instance_block("MALEVOLENT", parent_path, "h" + str(i))
		instance_block("SLUGGER", parent_path, "h" + str(i))
		instance_block("THIS GAME IS SO ESEY", parent_path, "h" + str(i))
		
		i += 1
		instance_block("wait that's not fair", parent_path, "h" + str(i))
		instance_block("PROCEDURE", parent_path, "h" + str(i))
		
		i += 1
		instance_block("ROUTINE", parent_path, "h" + str(i))
	
	# s2n
	if true:
		
		i = 0
		stage = "2"
		parent_path = gn.category % "2"
		
		#i += 1
		instance_block("CANOPY", parent_path, "h" + str(i))
		instance_block("Apprentice Iron Worker", parent_path, "h" + str(i))
		instance_block("Double Barrels", parent_path, "h" + str(i))
		instance_block("RAIN DANCE", parent_path, "h" + str(i))
		
		i += 1
		instance_block("LIGHTHOUSE", parent_path, "h" + str(i))
		instance_block("Rogue Blacksmith", parent_path, "h" + str(i))
		instance_block("Triple Barrels", parent_path, "h" + str(i))
		instance_block("BREAK THE DAM", parent_path, "h" + str(i))
		
		i += 1
		instance_block("This Might Pay Off Someday", parent_path, "h" + str(i))
		instance_block("Dirt Collection Rewards Program", parent_path, "h" + str(i))
		instance_block("EQUINE", parent_path, "h" + str(i))
		instance_block("Unpredictable Weather", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Decisive Strikes", parent_path, "h" + str(i))
		instance_block("Soft and Smooth", parent_path, "h" + str(i))
		instance_block("Flippy Floppies", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Woodthirsty", parent_path, "h" + str(i))
		instance_block("Seeing Brown", parent_path, "h" + str(i))
		instance_block("Woodiac Chopper", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Carlin", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Hardwood Yourself", parent_path, "h" + str(i))
		instance_block("Steel Yourself", parent_path, "h" + str(i))
		instance_block("PLASMA BOMBARDMENT", parent_path, "h" + str(i))
		instance_block("Patreon Artist", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Millery", parent_path, "h" + str(i))
		instance_block("Quamps", parent_path, "h" + str(i))
		instance_block("2552", parent_path, "h" + str(i))
		instance_block("GIMP", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Sagan", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Henry Cavill", parent_path, "h" + str(i))
		instance_block("Lembas Water", parent_path, "h" + str(i))
		instance_block("Bigger Trees I Guess", parent_path, "h" + str(i))
		instance_block("Journeyman Iron Worker", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Cutting Corners", parent_path, "h" + str(i))
		instance_block("Quormps", parent_path, "h" + str(i))
		instance_block("Kilty Sbark", parent_path, "h" + str(i))
		instance_block("Hole Geometry", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Cioran", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Wood Lord", parent_path, "h" + str(i))
		instance_block("Expert Iron Worker", parent_path, "h" + str(i))
		instance_block("They've Always Been Faster", parent_path, "h" + str(i))
		instance_block("Where's the boy, String?", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Utter Molester Champ", parent_path, "h" + str(i))
		instance_block("CANCER'S REAL COOL", parent_path, "h" + str(i))
		instance_block("Sp0oKy", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Squeeormp", parent_path, "h" + str(i))
		instance_block("Sandal Flandals", parent_path, "h" + str(i))
		instance_block("Glitterdelve", parent_path, "h" + str(i))
		instance_block("VIRILE", parent_path, "h" + str(i))
		instance_block("Factory Squirts", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Longbottom Leaf", parent_path, "h" + str(i))
		instance_block("INDEPENDENCE", parent_path, "h" + str(i))
		instance_block("Nikey Wikeys", parent_path, "h" + str(i))
		
		i += 1
		instance_block("ERECTWOOD", parent_path, "h" + str(i))
		instance_block("Steely Dan", parent_path, "h" + str(i))
		instance_block("MGALEKGOLO", parent_path, "h" + str(i))
		instance_block("PULLEY", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Le Guin", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Fleeormp", parent_path, "h" + str(i))
		instance_block("POTENT", parent_path, "h" + str(i))
		instance_block("Light as a Feather", parent_path, "h" + str(i))
		instance_block("Busy Bee", parent_path, "h" + str(i))
		
		i += 1
		instance_block("DINDER MUFFLIN", parent_path, "h" + str(i))
		instance_block("Ultra Shitstinct", parent_path, "h" + str(i))
		instance_block("And this is to go even further beyond!", parent_path, "h" + str(i))
		instance_block("Power Barrels", parent_path, "h" + str(i))
		instance_block("a bee with tiny daggers!!!", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Hardwood Yo Mama", parent_path, "h" + str(i))
		instance_block("Steel Yo Mama", parent_path, "h" + str(i))
		instance_block("MAGNETIC ACCELERATOR", parent_path, "h" + str(i))
		instance_block("SPOOLY", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Toriyama", parent_path, "h" + str(i))
		
		i += 1
		instance_block("BURDENED", parent_path, "h" + str(i))
		instance_block("Squeeomp", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Barely Wood by Now", parent_path, "h" + str(i))
		instance_block("Fingers of Onden", parent_path, "h" + str(i))
		instance_block("O'SALVATORI", parent_path, "h" + str(i))
		instance_block("low rises", parent_path, "h" + str(i))
		
		i += 1
		instance_block("i'll show you hardwood", parent_path, "h" + str(i))
		instance_block("Steel Lord", parent_path, "h" + str(i))
		instance_block("FINISH THE FIGHT", parent_path, "h" + str(i))
		instance_block("MICROSOFT PAINT", parent_path, "h" + str(i))
		
		i += 1
		instance_block("John Peter Bain, TotalBiscuit", parent_path, "h" + str(i))
	
	# s2m
	if true:
		
		i = 0
		stage = "2"
		parent_path = gn.category % "3"
		
		#i += 1
		instance_block("MECHANICAL", parent_path, "h" + str(i))
		instance_block("Limit Break", parent_path, "h" + str(i))
		
		i += 1
		instance_block("don't take candy from babies", parent_path, "h" + str(i))
		instance_block("Splishy Splashy", parent_path, "h" + str(i))
		instance_block("MILK", parent_path, "h" + str(i))
		instance_block("FALCON PAWNCH", parent_path, "h" + str(i))
		
		i += 1
		instance_block("SPEED-SHOPPER", parent_path, "h" + str(i))
		instance_block("AUTOSMITHY", parent_path, "h" + str(i))
		instance_block("GATORADE", parent_path, "h" + str(i))
		instance_block("KAIO-KEN", parent_path, "h" + str(i))
		
		i += 1
		instance_block("AUTOSENSU", parent_path, "h" + str(i))
		instance_block("APPLE JUICE", parent_path, "h" + str(i))
		instance_block("DANCE OF THE FIRE GOD", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Sudden Commission", parent_path, "h" + str(i))
		instance_block("PEPPERMINT MOCHA", parent_path, "h" + str(i))
		instance_block("RASENGAN", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Mudslide", parent_path, "h" + str(i))
		instance_block("The Great Journey", parent_path, "h" + str(i))
		instance_block("BEAVER", parent_path, "h" + str(i))
		instance_block("mods enabled", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Covenant Dance", parent_path, "h" + str(i))
		instance_block("Overtime", parent_path, "h" + str(i))
		instance_block("Bone Meal", parent_path, "h" + str(i))
		instance_block("SILLY", parent_path, "h" + str(i))
		
		i += 1
		instance_block("SPEED DOODS", parent_path, "h" + str(i))
		instance_block("Erebor", parent_path, "h" + str(i))
		instance_block("Child Energy", parent_path, "h" + str(i))
		instance_block("PLATE", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Master", parent_path, "h" + str(i))
		instance_block("STRAWBERRY BANANA SMOOTHIE", parent_path, "h" + str(i))
		instance_block("AVATAR STATE", parent_path, "h" + str(i))
		
		i += 1
		instance_block("AXELOT", parent_path, "h" + str(i))
		instance_block("GREEN TEA", parent_path, "h" + str(i))
		instance_block("HAMON", parent_path, "h" + str(i))
		
		i += 1
		instance_block("AUTOSHIT", parent_path, "h" + str(i))
		instance_block("FRENCH VANILLA", parent_path, "h" + str(i))
		instance_block("METAL CAP", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Smashy Crashy", parent_path, "h" + str(i))
		instance_block("WATER", parent_path, "h" + str(i))
		instance_block("STAR ROD", parent_path, "h" + str(i))
		
		i += 1
		instance_block("A baby Roleum!! Thanks, pa!", parent_path, "h" + str(i))
		instance_block("poofy wizard boy", parent_path, "h" + str(i))
		instance_block("BENEFIT", parent_path, "h" + str(i))
		instance_block("AUTOAQUATICICIDE", parent_path, "h" + str(i))
		instance_block("Go on, then, LEAD us!", parent_path, "h" + str(i))
		
		i += 1
		instance_block("THE WITCH OF LOREDELITH", parent_path, "h" + str(i))
		instance_block("Tolkien", parent_path, "h" + str(i))
		
		i += 1
		instance_block("BEEKEEPING", parent_path, "h" + str(i))
		instance_block("Elbow Straps", parent_path, "h" + str(i))
		instance_block("AUTO-PERSIST", parent_path, "h" + str(i))
		instance_block("KETO", parent_path, "h" + str(i))
		instance_block("Now That's What I'm Talkin About, YeeeeeeaaaaaaaAAAAAAGGGGGHHH", parent_path, "h" + str(i))
		
		i += 1
		instance_block("Scoopy Doopy", parent_path, "h" + str(i))
		instance_block("the athore coments al totol lies!", parent_path, "h" + str(i))
		instance_block("IT'S SPREADIN ON ME", parent_path, "h" + str(i))
		instance_block("what in cousin-fuckin tarnation alabama betty crocker miss fuckin betty white shit is this", parent_path, "h" + str(i))
		instance_block("Master Iron Worker", parent_path, "h" + str(i))
		
		i += 1
		instance_block("JOINTSHACK", parent_path, "h" + str(i))
		instance_block("dust", parent_path, "h" + str(i))
		instance_block("CAPITAL PUNISHMENT", parent_path, "h" + str(i))
		instance_block("AROUSAL", parent_path, "h" + str(i))
		
		i += 1
		instance_block("autofloof", parent_path, "h" + str(i))
		instance_block("ELECTRONIC CIRCUITS", parent_path, "h" + str(i))
		instance_block("AUTOBADDECISIONMAKER", parent_path, "h" + str(i))
		
		i += 1
		instance_block("CONDUCT", parent_path, "h" + str(i))
		
		i += 1
		instance_block("PILLAR OF AUTUMN", parent_path, "h" + str(i))
		instance_block("what kind of resource is 'tumors', you hack fraud", parent_path, "h" + str(i))
		instance_block("DEVOUR", parent_path, "h" + str(i))
		
		i += 1
		instance_block("is it SUPPOSED to be stick dudes?", parent_path, "h" + str(i))
		instance_block("I Disagree", parent_path, "h" + str(i))
		instance_block("HOME-RUN BAT", parent_path, "h" + str(i))
		instance_block("BLAM this piece of crap!", parent_path, "h" + str(i))
		instance_block("DOT DOT DOT", parent_path, "h" + str(i))
		
		i += 1
		instance_block("ONE PUNCH", parent_path, "h" + str(i))
		instance_block("Sick of the Sun", parent_path, "h" + str(i))
		instance_block("axman23 by now", parent_path, "h" + str(i))
		instance_block("Cthaeh", parent_path, "h" + str(i))
		
		i += 1
		instance_block("RED NECROMANCY", parent_path, "h" + str(i))
		instance_block("upgrade_description", parent_path, "h" + str(i))
		instance_block("GRIMOIRE", parent_path, "h" + str(i))
		
		i += 1
		#instance_block("Cthaeh", parent_path, "h" + str(i))
	
	# s3n
	if true:
		
		i = 0
		stage = "3"
		parent_path = gn.category % "4"
		
		#i += 1
		instance_block("Carcinogenesis", parent_path, "h" + str(i))
	
	
	sync()
	
	r_update()
	
	
	var t = Timer.new()
	add_child(t)
	t.start(2.5)
	yield(t, "timeout")
	t.queue_free()

	procedure()

func instance_block(
		upgrade_key: String,
		parent_path: String,
		hbox_name: String
	):
	
	cont[upgrade_key] = src.upgrade_block.instance()
	
	hbox_name = parent_path + " " + hbox_name
	
	if not hbox_name in cont.keys():
		cont[hbox_name] = src.hbox.instance()
		get_node(parent_path).add_child(cont[hbox_name])
	
	cont[hbox_name].add_child(cont[upgrade_key])
	cont[upgrade_key].setup(upgrade_key)
	yield(cont[upgrade_key], "ready")



func sync() -> void:
	
	for x in gv.Tab:
		if gv.Tab[x] == gv.Tab.S1:
			break
		get_node("top/" + str(gv.Tab[x]) + "/h/count").text = sync_count(gv.Tab[x])


func sync_count(_path: int) -> String:
	
	var owned :int= gv.list.upgrade["owned " + str(_path)].size()
	var total = gv.list.upgrade[str(_path)].size()
	
	if _path == gv.Tab.MALIGNANT:
		total -= 1
	
	if get_node("v").visible:
		if get_node("v/upgrades/v/" + str(_path)).visible:
			get_node(gncount).text = str(owned) + "/" + str(total)
	
	return str(owned) + "/" + str(total)



func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")

func _on_reset_mouse_entered() -> void:
	
	if gv.open_tab == -1:
		return
	
	var reset_name := get_reset_name().to_upper() 
	
	rt.get_node("global_tip")._call("buy upgrade " + reset_name)

func get_reset_name() -> String:
	
	if gv.open_tab == gv.Tab.MALIGNANT:
		return "Metastasize"
	if gv.open_tab == gv.Tab.RADIATIVE:
		return "Chemotherapy"
	
	return "oops"


var confirmed := false
func _on_reset_pressed() -> void:
	
	if confirmed:
		var stage: int
		match gv.open_tab:
			gv.Tab.NORMAL, gv.Tab.MALIGNANT:
				stage = gv.Tab.S1
			gv.Tab.EXTRA_NORMAL, gv.Tab.RADIATIVE:
				stage = gv.Tab.S2
			gv.Tab.RUNED_DIAL, gv.Tab.SPIRIT:
				stage = gv.Tab.S3
		rt.reset(stage)
		confirmed_false()
		return
	
	confirmed = true
	confirmReset.show()
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	if confirmed:
		confirmed_false()

func confirmed_false():
	confirmed = false
	set_gnreset()



func r_setup_setup():
	
	if not gv.open_tab in [gv.Tab.MALIGNANT, gv.Tab.RADIATIVE, gv.Tab.SPIRIT]:
		
		get_node("v/reset").hide()
		
		return
	
	set_gnreset()
	
	get_node("v/reset").show()
	
	if shouldDisplayResetResource():
		setupResetResource()
	else:
		get_node("%resetResource").hide()

func set_gnreset():
	
	confirmReset.hide()
	
	var mod_color: Color
	
	if gv.open_tab == gv.Tab.MALIGNANT:
		mod_color = gv.COLORS["malig"]
	elif gv.open_tab == gv.Tab.RADIATIVE:
		mod_color = gv.COLORS["tum"]
	
	get_node("%reset/Button").modulate = mod_color
	get_node("%resetIcon").modulate = mod_color



func col_time(node: String) -> void:
	
	show()
	
	get_node("top").hide()
	get_node("v").show()
	
	if gv.open_tab != -1:
		stored_verticals[gv.open_tab] = get_node("v/upgrades").scroll_vertical
	
	gv.open_tab = int(node)
	
	for x in get_node("v/upgrades/v").get_children():
		if x.name == node:
			x.show()
		else:
			x.hide()
	
	var tex = gv.sprite[str(gv.open_tab)]
	get_node(gnIcon).texture = tex
	
	get_node("v/header/bg").self_modulate = color[int(node)]
	get_node(gnBack_arrow).self_modulate = color[int(node)]
	
	get_node(gnTitle_text).text = get_proper_name(node)
	get_node(gncount).text = get_node("top/" + node + "/h/count").text
	
	clear_tip_n_stuff()
	
	update_folder()
	
	r_setup_setup()
	
	var t = Timer.new()
	add_child(t)
	t.start(0.01)
	yield(t, "timeout")
	t.queue_free()
	
	get_node("v/upgrades").scroll_vertical = stored_verticals[int(node)]

func get_proper_name(path: String) -> String:
	
	match int(path):
		gv.Tab.RADIATIVE:
			return "Radiative"
		gv.Tab.EXTRA_NORMAL:
			return "Extra-normal"
		gv.Tab.MALIGNANT:
			return "Malignant"
		_:
			return "Normal"


func go_back():
	
	if gv.open_tab == -1:
		return
	
	clear_tip_n_stuff()
	
	get_node("v").hide()
	
	for x in get_node("v/upgrades/v").get_children():
		x.hide()
	get_node("top").show()
	
	stored_verticals[gv.open_tab] = get_node("v/upgrades").scroll_vertical
	
	gv.open_tab = -1
	
	rect_size.x = 0


func clear_tip_n_stuff():
	
	if not is_instance_valid(rt.get_node("global_tip").tip):
		return
	
	if "upgrade" in rt.get_node("global_tip").tip.type:
		var key = rt.get_node("global_tip").tip.type.split("upgrade ")[1]
		if key in cont.keys():
			cont[key]._on_Button_mouse_exited()
	
	rt.get_node("global_tip")._call("no")



func r_update(which := []):
	
	if which == []:
		for x in get_node("v/upgrades/v").get_children():
			which.append(x.name)
	
	
	for x in which:
		
		for h in get_node("v/upgrades/v/" + x + "/v").get_children():
			for u in h.get_children():
				u.r_update()


func upgrade_purchased(key: String, routine := []):
	
	# catches
	if cont[key].tab != gv.open_tab:
		return
	if not visible:
		return
	
	update_folder()
	
	
	
	# flying texts below
	
	if not gv.option["flying_numbers"]:
		return
	
	var rollx :int= randi() % 20 - 10 + get_global_mouse_position().x - rect_position.x
	var rolly :int= randi() % 20 - 10 + get_global_mouse_position().y - rect_position.y
	
	var i := 0
	
	if key == "ROUTINE" and gv.up["PROCEDURE"].active():
		
		cont_flying_texts["(upgrade purchased flying text)" + str(i)] = rt.prefab["dtext"].instance()
		cont_flying_texts["(upgrade purchased flying text)" + str(i)].init(false, -50, "+ " + routine[0].toString(), gv.sprite["tum"], gv.COLORS["tum"])
		cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(
			rollx, 
			rolly
		)
		$flying_texts.add_child(cont_flying_texts["(upgrade purchased flying text)" + str(i)])
		
		i += 1
	
	var t = Timer.new()
	add_child(t)
	for x in gv.up[key].cost:
		
		# dtext
		cont_flying_texts["(upgrade purchased flying text)" + str(i)] = rt.prefab["dtext"].instance()
		
		var _text = "- " + gv.up[key].cost[x].t.toString()
		if key == "ROUTINE":
			_text = "- " + routine[1].toString()
		
		var icon = gv.sprite[gv.shorthandByResource[x]]
		
		cont_flying_texts["(upgrade purchased flying text)" + str(i)].init({"text": _text, "icon": icon, "color": gv.resourceColor[x], "life": 20})
		
		if i == 0:
			cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(
				rollx,
				rolly
			)
		else:
			
			for v in i:
				if not "(upgrade purchased flying text)" + str(v) in cont_flying_texts.keys():
					return
				cont_flying_texts["(upgrade purchased flying text)" + str(v)].rect_position.y -= 7
			
			cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(
				cont_flying_texts["(upgrade purchased flying text)" + str(i-1)].rect_position.x,
				cont_flying_texts["(upgrade purchased flying text)" + str(i-1)].rect_position.y + cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_size.y
			)
		
		$flying_texts.add_child(cont_flying_texts["(upgrade purchased flying text)" + str(i)])
		
		i += 1
		
		t.start(0.02)
		yield(t, "timeout")
	
	t.queue_free()


func update_folder():
	
	for x in get_node("v/upgrades/v/" + str(gv.open_tab) + "/v").get_children():
		if not x.name in gv.up.keys():
			continue
		x.r_update()



func flash_reset_button():
	
	var test = gv.SRC["flash"].instance()
	reset_t.add_child(test)
	test.flash()

