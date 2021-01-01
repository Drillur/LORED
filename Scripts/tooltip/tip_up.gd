extends MarginContainer

onready var rt = get_node("/root/Root")

onready var gn_icon = get_node("VBoxContainer/title/h/icon/Sprite")
onready var gn_name = get_node("VBoxContainer/title/h/v/name")
onready var gn_progress = get_node("VBoxContainer/title/h/v/progress")
onready var gn_desc = get_node("VBoxContainer/desc")
onready var gn_desc2 = get_node("VBoxContainer/desc2")
onready var gn_permanent = get_node("VBoxContainer/Active/permanent")
onready var gn_refundable = get_node("VBoxContainer/Active/refundable")

var key := ""
var required_upgrades_purchased := true

var cont := {}
var src := {
	price = preload("res://Prefabs/tooltip/price.tscn"),
	require = preload("res://Prefabs/tooltip/upgrade_block.tscn"),
}


func init(_key: String) -> void:
	
	key = _key
	
	required_upgrades_purchased = requirements()
	
	rect_size = Vector2(0, 0)
	
	labels_and_textures()
	
	effects()
	
	price_stuff()
	
	refundable()
	
	rect_size = Vector2(0, 0)


func price_stuff() -> void:
	
	# catches
	if true:
		
		if not required_upgrades_purchased:
			return
		if gv.up[key].have:
			return
		if gv.up[key].refundable:
			return
		if "reset" in gv.up[key].type:
			return
		if gv.up[key].cost.size() == 0:
			return
	
	$VBoxContainer/m.show()
	get_node("VBoxContainer/m/bg").self_modulate = gv.COLORS[gv.up[key].icon]
	
	var f = gv.up[key].cost
	var i := 0
	
	for x in f:
		
		var val: Big = Big.new(f[x].t)
		
		cont[x] = src.price.instance()
		
		cont[x].setup(key, x)
		
		# alternate backgrounds
		if i % 2 == 1: cont[x].get_node("bg").show()
		
		get_node("VBoxContainer/m/price").add_child(cont[x])
		
		i += 1

func refundable() -> void:
	
	if not gv.up[key].refundable:
		return
	
	gn_refundable.show()

func requirements() -> bool:
	
	for x in gv.up[key].requires:
		
		if not (gv.up[x].have or gv.up[x].refundable):# and gv.up[x].refundable:
			
			cont[x] = src.require.instance()
			$VBoxContainer/requires/v.add_child(cont[x])
			cont[x].init(x)
			$VBoxContainer/requires.show()
			
			return false
	
	return true

func effects() -> void:
	
	var upgrades_with_effects := [
		"IT'S GROWIN ON ME",
		"IT'S SPREADIN ON ME",
		"I DRINK YOUR MILKSHAKE"
	]
	
	# catches
	if not key in upgrades_with_effects:
		return
	if not gv.up[key].active():
		return
	if not gv.up[key].have:
		return
	
	
	
	get_node("VBoxContainer/effects").show()
	get_node("VBoxContainer/effects/bg").self_modulate = gv.g[gv.up[key].icon].color
	
	match key:
		
		"I DRINK YOUR MILKSHAKE":
			
			get_node("VBoxContainer/effects/v/idym").show()
		
		"IT'S GROWIN ON ME", "IT'S SPREADIN ON ME":
			
			if gv.up["IT'S GROWIN ON ME"].active():
				get_node("VBoxContainer/effects/v/igom_iron").show()
				get_node("VBoxContainer/effects/v/igom_cop").show()
			
			if gv.up["IT'S SPREADIN ON ME"].active():
				get_node("VBoxContainer/effects/v/igom_irono").show()
				get_node("VBoxContainer/effects/v/igom_copo").show()

func labels_and_textures() -> void:
	
	gn_name.text = gv.up[key].name
	
	if required_upgrades_purchased:
		
		gn_icon.texture = gv.sprite[gv.up[key].icon]
		gn_desc.text = gv.up[key].desc.f
	
	else:
		
		gn_icon.texture = gv.sprite["unknown"]
		gn_desc.text = random_desc()

func random_desc() -> String:
	
	var roll : int = rand_range(0,40)
	match roll:
		39:
			return "Instantly deletes your sugar and caffeine addictions, and fills your fridge with water bottles."
		38:
			return "Stocks your bathroom cabinets with flushable wipes."
		37:
			return "When your next Chapstick buff expires, it will have a 50% chance to apply another Chapstick buff automatically."
		36:
			return "Uber has 50% better customer service."
		35:
			return "Twitter deletes all of their servers and shuts down permanently."
		34:
			return "Blows the Wind of God™ on Covid-19, destroying it forever and never allowing it to come back."
		33:
			return "Cyberpunk 2077 now additionally allows the customization of nipples."
		32:
			return "Halo Infinite has an increased 25% chance to be good."
		31:
			return "Causes every LORED to become a Super Sonic Racer. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. EVERYBODY."
		30:
			return "Jeremy Soule creates a 30-hour soundtrack for a little internet game called LORED."
		1:
			return "This upgrade could do ANYTHING. It could unlock the WIN command. You don't know."
		2:
			var mant: float = rand_range(1,9)
			var expo: float = rand_range(1000, 100000)
			return "LORED haste x" + Big.new(str(mant)+"e"+str(expo)).toString() + "."
		3:
			return "Improves the quality of every animation."
		4:
			return "LORED dev haste x2.0. Next update will come much sooner."
		5:
			return "Fuel is cancelled."
		6:
			return "Unlocks the MINE feature. Enter the mine, deal damage to ores, and collect your loot!"
		7:
			return "Unlocks the REALISTIC feature. The game ends."
		8:
			return "Unlocks the EARTH feature. All resources bored from the ground are now limited. You must move to a new location when you are out."
		9:
			return "This upgrade doesn't do anything."
		10:
			return "Returns and refunds this upgrade."
		11:
			return "Deletes your save."
		12:
			return "Deletes everyone's save but your own."
		13:
			return "Takes back the White House."
		14:
			return "Removes microtransactions from every video game."
		15:
			return "Delivers a free pizza to your home!"
		16:
			return "Changes the game name to LORDE. I'm gonna swing from the chandeliiiiieeerrr."
		17:
			return "Manipulates real time to become December 24, current year, 8am."
		18:
			return "You restart your entire life, but bring your memories with you. A real-life prestige."
		19:
			return "Enables the game to work on Safari."
		20:
			return "Combines the power of every piece of feedback ever received into an awful abomination of mostly-decent ideas."
		21:
			return "Cures cancer."
		22:
			return "Deletes the most regrettable decision in your life from time, but not your memory."
		23:
			return "Chris Metzen and Mike Morhaime return to Blizzard. Bobby Kotick loses his way in a forest and is never seen again. Activision shuts its doors indefinitely."
		24:
			return "Causes $1 to appear on your head. Time limit: N/A."
		25:
			return "Deletes your insecurities."
		26:
			return "Game of Thrones season 8 is deleted."
		27:
			return "LORED output x0. Game over."
		28:
			return "LOREDs will now dance instead of sleep when idle. (Just kidding but I wish I hadn't just thought of that because now I want to do it but it would take 25 years)"
		29:
			return "You have now spent 10x the amount of time with your parents and grandparents, for free."
		_:
			return "Who the frick knows what this upgrade does?"


func r_desc2():
	
	if gv.up[key].progress.f == 0:
		gn_desc2.hide()
		return
	
	gn_desc2.show()
	#gn_desc2.text = 
