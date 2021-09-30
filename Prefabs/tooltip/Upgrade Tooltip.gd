extends MarginContainer


onready var icon = get_node("v/header/v/h/icon")
onready var gn_name = get_node("v/header/v/h/name")
onready var desc = get_node("v/desc")
onready var req = get_node("v/req")
onready var req_icon = get_node("v/req/v/h/icon")
onready var req_name = get_node("v/req/v/h/name")
onready var price = get_node("v/price")
onready var refundable = get_node("v/header/v/refundable")

var up: Upgrade
var cont := {}
var price_filled := false


func init(_upgrade_key: String) -> void:
	
	up = gv.up[_upgrade_key]
	up.active_tooltip = self
	up.active_tooltip_exists = true
	
	icon.init(_upgrade_key)
	gn_name.text = up.name
	
	display()

func display():
	
	refundable.visible = up.refundable
	
	if not up.requirements():
		req.show()
		req_icon.init(up.requires[0])
		req_name.text = gv.up[up.requires[0]].name
		desc.bbcode_text = random_desc()
	else:
		req.hide()
		set_desc()
		price_stuff()
	
	var t = Timer.new()
	add_child(t)
	t.start(.05)
	yield(t, "timeout")
	t.queue_free()
	
	rect_size = Vector2.ZERO

func set_desc():
	
	up.sync_desc()
	desc.bbcode_text = up.desc.f
	
	match up.key:
		
		"I DRINK YOUR MILKSHAKE":
			desc.bbcode_text += " (+[b][color=#" + gv.COLORS["coal"].to_html() + "]" + up.effects[0].effect.print() + "[/color][/b])"
		
		"IT'S GROWIN ON ME", "IT'S SPREADIN ON ME":
			desc.bbcode_text += " ("
			if gv.up["IT'S GROWIN ON ME"].active():
				desc.bbcode_text += " +[b][color=#" + gv.COLORS["iron"].to_html() + "]" + gv.up["IT'S GROWIN ON ME"].effects[0].effect.print() + "[/color][/b],"
				desc.bbcode_text += " +[b][color=#" + gv.COLORS["cop"].to_html() + "]" + gv.up["IT'S GROWIN ON ME"].effects[1].effect.print() + "[/color][/b]"
			
			if gv.up["IT'S SPREADIN ON ME"].active():
				desc.bbcode_text += ", +[b][color=#" + gv.COLORS["irono"].to_html() + "]" + gv.up["IT'S SPREADIN ON ME"].effects[0].effect.print() + "[/color][/b],"
				desc.bbcode_text += " +[b][color=#" + gv.COLORS["copo"].to_html() + "]" + gv.up["IT'S SPREADIN ON ME"].effects[1].effect.print() + "[/color][/b]"
			desc.bbcode_text += ")"
	
	if desc.rect_size.x > 240:
		desc.rect_min_size.x = 240

func price_stuff() -> void:
	
	price.hide()
	
	if price_filled:
		return
	
	if up.have:
		return
	if up.refundable:
		return
	if "reset" in up.type:
		return
	if up.cost.size() == 0:
		return
	
	price.show()
	
	price.setup(up.key, up.cost)
	price.get_node("bg").show()
	
	price_filled = true

func random_desc() -> String:
	
	var roll : int = randi() % 40
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
			return "Jeremy Soule creates a 30-hour soundtrack for a little game called LORED."
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
			return "Developing free-to-play games with forced, skippable ads is now punishable by up to ten years in maximum-security prison."
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
