extends Node



class UpgradeMenu:
	extends Resource
	
	var saved_vars := [
		"unlocked",
	]
	
	func save() -> String:
		return SaveManager.save_vars(self)
	
	
	enum Type {
		NORMAL,
		MALIGNANT,
		EXTRA_NORMAL,
		RADIATIVE,
		RUNED_DIAL,
		SPIRIT,
		S4N,
		S4M,
	}
	
	var TYPE_KEYS := Type.keys()
	
	var type: int
	var key: String
	
	var name: String
	var icon: Texture
	var icon_text: String
	var color: Color
	var color_text: String
	
	var unlocked := false
	
	var upgrade_count := 0
	var upgrade_total := 0
	
	func _init(_type: int) -> void:
		type = _type
		key = TYPE_KEYS[type]
		name = key.capitalize().replace("_", " ")
		if icon != null:
			icon_text = "[img=<15>]" + icon.get_path() + "[/img]"
		if color != null:
			color_text = "[color=#" + color.to_html() + "]%s[/color]"
		
		match type:
			Type.NORMAL:
				color = Color(0.733333, 0.458824, 0.031373)
				icon = load("res://Sprites/Hud/Tab/s1n.png")
			Type.MALIGNANT: 
				color = Color(0.878431, 0.121569, 0.34902)
				icon = load("res://Sprites/Hud/Tab/s1m.png")
			Type.EXTRA_NORMAL: 
				color = Color(0.47451, 0.870588, 0.694118)
				icon = load("res://Sprites/Hud/Tab/s2n.png")
			Type.RADIATIVE: 
				color = Color(1, 0.541176, 0.541176)
				icon = load("res://Sprites/Hud/Tab/s2m.png")
			Type.RUNED_DIAL: 
				color = Color(1, 0.541176, 0.541176)
			Type.SPIRIT: 
				color = Color(1, 0.541176, 0.541176)
			Type.S4N: 
				color = Color(1, 0.541176, 0.541176)
			Type.S4M: 
				color = Color(1, 0.541176, 0.541176)


var upgrade_container: UpgradeContainer:
	set(val):
		upgrade_container = val
		for upgrade in upgrades.values():
			if upgrade.type > Upgrade.Type.RED_GOOPY_BOY:
				break
			upgrade_container.set_vico(upgrade)

signal upgrade_purchased(type)

var upgrades := {}
var upgrade_menus := {}



func _ready():
	for type in UpgradeMenu.Type.values():
		upgrade_menus[type] = UpgradeMenu.new(type)
	for type in Upgrade.Type.values():
		upgrades[type] = Upgrade.new(type)



# - Action

func unlock_menu(menu: int) -> void:
	upgrade_menus[menu].unlocked = true


func add_upgrade_total(menu: int) -> void:
	upgrade_menus[menu].upgrade_total += 1


func add_upgrade_count(menu: int) -> void:
	upgrade_menus[menu].upgrade_count += 1



# - Get

func get_upgrade(type: int) -> Upgrade:
	return upgrades[type]


func get_menu_color(menu: int) -> Color:
	return upgrade_menus[menu].color


func get_menu_name(menu: int) -> String:
	return upgrade_menus[menu].name


func get_upgrade_count(menu: int) -> int:
	return upgrade_menus[menu].upgrade_count


func get_upgrade_total(menu: int) -> int:
	return upgrade_menus[menu].upgrade_total
