extends MarginContainer


onready var icon = get_node("%icon")
onready var upgradeName = get_node("%upgradeName")
onready var desc = get_node("%desc")
onready var req = get_node("%req")
onready var reqIcon = get_node("%reqIcon")
onready var reqName = get_node("%reqName")
onready var cost = get_node("%cost")
onready var refundable = get_node("%refundable")

var up: Upgrade
var cont := {}
var price_filled := false


func init(_upgrade_key: String) -> void:
	
	up = gv.up[_upgrade_key]
	up.active_tooltip = self
	up.active_tooltip_exists = true
	
	upgradeName.text = up.name
	
	icon.init(_upgrade_key)
	
	display()

func display():
	
	if up.refundable:
		refundable.show()
		get_node("%sub").show()
	
	if not up.requirements():
		req.show()
		reqIcon.init(up.requires[0])
		reqName.text = gv.up[up.requires[0]].name
		desc.bbcode_text = random_desc()
	else:
		req.hide()
		set_desc()
		price_stuff()
	
	var t = Timer.new()
	add_child(t)
	t.start(.01)
	yield(t, "timeout")
	t.queue_free()
	
	rect_size = Vector2.ZERO

func set_desc():
	
	up.sync_desc()
	desc.bbcode_text = up.desc.f
	
	match up.key:
		
		"I DRINK YOUR MILKSHAKE":
			desc.bbcode_text += " ([b][color=#" + gv.COLORS["coal"].to_html() + "]" + up.effects[0].effect.read() + "[/color][/b])"
		
		"IT'S GROWIN ON ME", "IT'S SPREADIN ON ME":
			desc.bbcode_text += " ("
			if gv.up["IT'S GROWIN ON ME"].active():
				desc.bbcode_text += " [b][color=#" + gv.COLORS["iron"].to_html() + "]" + gv.up["IT'S GROWIN ON ME"].effects[0].effect.read() + "[/color][/b],"
				desc.bbcode_text += " [b][color=#" + gv.COLORS["cop"].to_html() + "]" + gv.up["IT'S GROWIN ON ME"].effects[1].effect.read() + "[/color][/b]"
			
			if gv.up["IT'S SPREADIN ON ME"].active():
				desc.bbcode_text += ", [b][color=#" + gv.COLORS["irono"].to_html() + "]" + gv.up["IT'S SPREADIN ON ME"].effects[0].effect.read() + "[/color][/b],"
				desc.bbcode_text += " [b][color=#" + gv.COLORS["copo"].to_html() + "]" + gv.up["IT'S SPREADIN ON ME"].effects[1].effect.read() + "[/color][/b]"
			desc.bbcode_text += ")"
	
	if desc.rect_size.x > 240:
		desc.rect_min_size.x = 240

func price_stuff() -> void:
	
	cost.hide()
	
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
	
	cost.show()
	get_node("%sub").show()
	
	cost.setupUpgrade(up.key, up.cost)
	#cost.get_node("bg").show()
	
	price_filled = true

func random_desc() -> String:
	
	var roll : int = randi() % 44
	match roll:
		43: return "Sends curry chicken ramen directly to your door, for free!"
		42:
			return "Nintendo accepts their fans for who they are and release all of their first party games on PC with Steam Workshop and mod support."
		41:
			return "Your favorite candy is now the healthiest food in the world for humans to consume. However, mega corps purchase the rights to selling it, and, aware of the levels of demand, boost the price to unreasonable levels. Finally united against the greed of mega corps around the world, every country fights to destroy all mega corps. Country leaders, backed by the mega corps, step down honorably. Power returns to the people. Chaos ensues. Walmart shelves are empty. Toilet paper castles appear in backyards. Best Buy goes completely unaffected. Nintendo still hasn't revealed the N64 2. But, in the end, your food becomes affordable, so congratulations."
		40:
			return "Your muscles no longer decay over time. Instead, they decay by 5% every day you use Head & Shoulders 2 in 1 shampoo/conditioner."
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
			return "Halo Infinite never happened."
		31:
			return "Causes every LORED to become a Super Sonic Racer. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. EVERYBODY."
		30:
			return "Jeremy Soule creates a 30-hour soundtrack for a little game called LORED."
		1:
			return "This upgrade could do ANYTHING. It could unlock the WIN command. You don't know."
		2:
			var mant: float = rand_range(1,9)
			var expo: float = rand_range(1000, 100000)
			return "LORED haste x" + Big.new(mant, expo).toString() + "."
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
			return "The game can now run on Game Boy Color."
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

func flash():
	cost.flash()
