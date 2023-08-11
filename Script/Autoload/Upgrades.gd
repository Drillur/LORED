extends Node



var upgrade_container: UpgradeContainer:
	set(val):
		upgrade_container = val
		for upgrade in upgrades.values():
			if upgrade.type > Upgrade.Type.RED_GOOPY_BOY:
				break
			upgrade_container.set_vico(upgrade)

signal all_upgrades_initialized
signal menu_unlocked(menu)
signal upgrade_purchased(type)

var upgrades := {}
var upgrade_menus := {}

const RANDOM_UPGRADE_DESCRIPTION := [
	"Black mold is now properly digested once entering the human body. Inhaled spores come back out as a booger instead of 6 months of bronchitis. Isn't that gonna be nice?",
	"Square Enix is no longer \"disappointed with the sales\" of any of their games!",
	"Puts a tire swing (and a tree if necessary) in your (imported if necessary) front yard!",
	"Your mom calls you to remind you she loves you!",
	"Pheremones are still secreted and detected by our bodies, but our brains ignore their pungency. Result? Armpits. No more stinky.",
	"The YouTube app no longer arbitrarily charges $14/mo for playing videos while the screen is off. Their statement: \"We aren't sure what we were thinking with that one!\"",
	"TikTok headquarters explodes, taking their servers and money with it. Miraculously, no one dies.",
	"Money is deleted. Star Trek becomes reality. You may now enjoy your life, working towards your own goals.",
	"Diablo 4 is deleted.",
	"Reminds you to drink water!",
	"peepee vagina",
	"poopy fart doodoo",
	"Texas Roadhouse announces the Wholly Honest Organization, a world-wide collaboration and agreement by every restaurant which states that excessive customer service is forthwith banned. If a customer wants a refund for their half-eaten sandwich, the restaurant will now have the right to ask the customer if \"their mother ever loved them.\" If a party of 6 or more arrive without a reservation, the restaurant shall owe it to the world to tell the party to \"get bent.\" If a customer states that he or she is going to be \"posting this on Yelp,\" the premises reserves the right to ask them if they \"have any friends in real life\". This plan is expected to arrive at every restaurant by 2025.",
	"Kentaro Miura returns to our mortal plane in the form of Skull Knight until his life's work is completed.",
	"Removes your enthusiasm ceiling. You can now enjoy things like you did when you were 13.",
	"Makes the development and sale of Battle Passes punishable by death.",
	"Sends curry chicken ramen directly to your door, for free!",
	"Nintendo accepts their fans for who they are and release all of their first party games on PC with Steam Workshop and mod support.",
	"Your favorite candy is now the healthiest food in the world for humans to consume. However, mega corps purchase the rights to selling it, and, aware of the levels of demand, boost the price to unreasonable levels. Finally united against the greed of mega corps around the world, every country fights to destroy all mega corps. Country leaders, backed by the mega corps, step down honorably. Power returns to the people. Chaos ensues. Walmart shelves are empty. Toilet paper castles appear in backyards. Best Buy goes completely unaffected. Nintendo still hasn't revealed the N64 2. But, in the end, your favorite candy becomes affordable, so congratulations.",
	"Your muscles no longer decay over time. Instead, they decay by 5% every day you use Head & Shoulders 2 in 1 shampoo/conditioner.",
	"Instantly deletes your sugar and caffeine addictions, and fills your fridge with water bottles.",
	"Stocks your bathroom cabinets with flushable wipes.",
	"When your next Chapstick buff expires, it will have a 50% chance to apply another Chapstick buff automatically.",
	"Uber has 50% better customer service.",
	"[s]Twitter[/s] X deletes all of their servers and shuts down permanently.",
	"Blows the Wind of God™ on Covid-19, destroying it forever and never allowing it to come back.",
	"Cyberpunk 2077 now additionally allows the customization of nipples.",
	"Halo Infinite never happened.",
	"Causes every LORED to become a Super Sonic Racer. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. Everybody. EVERYBODY.",
	"Jeremy Soule creates a 30-hour soundtrack for a little game called LORED.",
	"This upgrade could do ANYTHING. It could unlock the WIN command. You don't know.",
	"Improves the quality of every animation.",
	"LORED dev Haste x2. Next update will come much sooner.",
	"Fuel is cancelled.",
	"Unlocks the MINE feature. Enter the mine, deal damage to ores, and collect your loot!",
	"Unlocks the REALISTIC feature. The game ends.",
	"Unlocks the EARTH feature. All resources bored from the ground are now limited. You must move to a new location when you are out.",
	"Has no effect.",
	"Returns and refunds itself.",
	"Deletes your save.",
	"Deletes everyone's save but your own.",
	"Takes back the White House.",
	"Removes microtransactions from every video game.",
	"Delivers a free pizza to your home!",
	"Changes the game name to LORDE. I'm gonna swing from the chandeliiiiieeerrr.",
	"Manipulates real time to become December 24, current year, 8am.",
	"You restart your entire life, but bring your memories with you. A real-life prestige.",
	"The game can now run on Game Boy Color.",
	"Combines the power of every piece of feedback ever received into an awful abomination of mostly-decent ideas.",
	"Cures cancer.",
	"Deletes the most regrettable decision in your life from time, but not your memory.",
	"Developing free-to-play games with forced, skippable ads is now punishable by up to ten years in maximum-security prison.",
	"Causes $1 to appear on your head. Time limit: N/A.",
	"Deletes your insecurities.",
	"Game of Thrones season 8 is deleted.",
	"LORED output x0. Game over.",
	"LOREDs will now dance instead of sleep when idle. (Just kidding but I wish I hadn't just thought of that because now I want to do it but it would take 25 years)",
	"You have now spent 10x the amount of time with your parents and grandparents, for free.",
	"Who the frick knows what this does?",
]



func _ready():
	for type in UpgradeMenu.Type.values():
		upgrade_menus[type] = UpgradeMenu.new(type) as UpgradeMenu
		connect("upgrade_purchased", upgrade_menus[type].add_purchased_upgrade)
	for type in Upgrade.Type.values():
		upgrades[type] = Upgrade.new(type)
	emit_signal("all_upgrades_initialized")



# - Action

func unlock_menu(menu: int) -> void:
	upgrade_menus[menu].unlock()
	emit_signal("menu_unlocked", menu)


func add_upgrade_to_menu(menu: int, upgrade: Upgrade) -> void:
	upgrade_menus[menu].add_upgrade(upgrade)




# - Get

func get_upgrade(type: int) -> Upgrade:
	return upgrades[type]


func get_upgrade_menu(menu: int) -> UpgradeMenu:
	return upgrade_menus[menu]


func get_menu_color(menu: int) -> Color:
	return upgrade_menus[menu].color


func get_menu_color_text(menu: int) -> String:
	return upgrade_menus[menu].color_text


func get_menu_name(menu: int) -> String:
	return upgrade_menus[menu].name


func get_menu_icon_and_name(menu: int) -> String:
	return upgrade_menus[menu].icon_text + " " + get_menu_name(menu)


func get_current_upgrade_count_in_menu_text(menu: int) -> String:
	return str(get_current_upgrade_count_in_menu(menu))


func get_upgrade_total_in_menu_text(menu: int) -> String:
	return str(get_upgrade_total_in_menu(menu))


func get_random_upgrade_description() -> String:
	return RANDOM_UPGRADE_DESCRIPTION[randi() % RANDOM_UPGRADE_DESCRIPTION.size()]


func get_current_upgrade_count_in_menu(menu: int) -> int:
	return upgrade_menus[menu].get_current_upgrade_count()


func get_upgrade_total_in_menu(menu: int) -> int:
	return upgrade_menus[menu].get_total_upgrade_count()


func is_menu_unlocked(menu: int) -> bool:
	return upgrade_menus[menu].unlocked
