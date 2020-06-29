extends Panel

onready var upgrade_requires = preload("res://Prefabs/upgrade/upgrade_requires.tscn")
onready var rt = get_parent().rt

var content := {}


func init(key : String) -> int:
	
	randomize()
	
	$name.text = key
	if not gv.up[key].requires == "":
		if gv.up[gv.up[key].requires].have:
			$icon.texture = gv.sprite[gv.up[key].main_lored_target]
	else:
		$icon.texture = gv.sprite[gv.up[key].main_lored_target]
	var required_upgrades_purchased : bool = true
	if not gv.up[key].requires == "":
		if not "mup" in gv.up[key].type and not gv.up[gv.up[key].requires].have and not gv.up[gv.up[key].requires].refundable:
			required_upgrades_purchased = false
	if required_upgrades_purchased:
		if not gv.up[key].requires == "":
			if not ("mup" in gv.up[key].type and not gv.up[gv.up[key].requires].have and not gv.up[gv.up[key].requires].refundable):
				$desc.text = gv.up[key].desc.f
			else:
				$desc.text = random_desc()
		else:
			$desc.text = gv.up[key].desc.f
	else:
		$desc.text = random_desc()
	
	var height : int
	
	if not gv.up[key].have:
		
		if "no" in rt.menu.f and gv.up[key].refundable:
			
			$refund.show()
			var refund_type : String = rt.menu.f.split("no ")[1]
			
			var price : float
			
			for x in gv.up[key].cost:
				price = gv.up[key].cost[x].t
			
			if key == "Limit Break" or key == "Share the Hit":
				get_parent().content["tip up"].get_node("refund").text = "You do not own this upgrade until you reset."
			else:
				get_parent().content["tip up"].get_node("refund").init(refund_type, fval.f(price))
			height = 30
		
		else:
			
			var i = 0
			if not gv.up[key].requires == "":
				if not gv.up[gv.up[key].requires].have and not gv.up[gv.up[key].requires].refundable:
					i = 32
					content[gv.up[key].requires] = upgrade_requires.instance()
					add_child(content[gv.up[key].requires])
					content[gv.up[key].requires].init(gv.up[key].requires)
					content[gv.up[key].requires].rect_position = Vector2(10, 115 + 0)
			
			if required_upgrades_purchased:
				height = i + ($price.init(gv.up[key].cost, "upgrade"))
			else:
				height = i
			$price.rect_position.y = 115 + i
	
	else:
		
		if gv.up[key].have:
			$active.show()
			height = 55
	
	return height


func random_desc() -> String:
	
	var roll : int = rand_range(0,32)
	match roll:
		31:
			return "Causes every LORED to become a Super Sonic Racer. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. EVERYBODY."
		30:
			return "Jeremy Soule creates a 30-hour soundtrack for a little internet game called LORED."
		1:
			return "This upgrade could do ANYTHING. It could unlock the WIN command. You don't know."
		2:
			return "LORED haste x" + fval.f(5000000000) + "."
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
