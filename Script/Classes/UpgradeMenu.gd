class_name UpgradeMenu
extends RefCounted



var saved_vars := [
	"unlocked",
	"times_prestiged",
]


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

signal purchasable_upgrade_count_increased
signal purchasable_upgrade_count_decreased
signal unlocked_changed(unlocked)

var type: int
var key: String

var prestige_name: String
var noun: String
var present_verb: String
var past_verb: String
var details := Details.new()

var times_prestiged := 0
var unlocked := false:
	set(val):
		if unlocked != val:
			unlocked = val
			unlocked_changed.emit(val)
			up.menu_unlocked_changed.emit(type, val)
			if val:
				for x in upgrades:
					var upgrade = up.get_upgrade(x) as Upgrade
					if upgrade.cost.affordable.is_true():
						upgrade.affordable_changed()

var upgrades := []
var purchased_upgrades := []
var affordable_and_unpurchased_upgrades := []



func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	details.name = key.capitalize().replace("_", " ") + " Upgrades"
	call(key)



func NORMAL():
	details.color = Color(0.733333, 0.458824, 0.031373)
	details.icon = load("res://Sprites/Hud/Tab/s1n.png")
func MALIGNANT(): 
	details.color = Color(0.878431, 0.121569, 0.34902)
	details.icon = load("res://Sprites/Hud/Tab/s1m.png")
	prestige_name = "Metastasize"
	noun = "Metastasis"
	past_verb = "Metastasized"
	present_verb = prestige_name
func EXTRA_NORMAL(): 
	details.color = Color(0.47451, 0.870588, 0.694118)
	details.icon = load("res://Sprites/Hud/Tab/s2n.png")
func RADIATIVE(): 
	details.color = Color(1, 0.541176, 0.541176)
	details.icon = load("res://Sprites/Hud/Tab/s2m.png")
	prestige_name = "Chemotherapy"
	noun = "Chemotherapy"
	past_verb = "taken Chemotherapy"
	present_verb = "undergo Chemotherapy"
func RUNED_DIAL(): 
	details.color = Color(1, 0.541176, 0.541176)
func SPIRIT(): 
	details.color = Color(1, 0.541176, 0.541176)
	prestige_name = "Don't know don't care"
func S4N(): 
	details.color = Color(1, 0.541176, 0.541176)
func S4M(): 
	details.color = Color(1, 0.541176, 0.541176)
	prestige_name = "Never gonna happen"



# - Signal

func add_purchased_upgrade(upgrade_type: int) -> void:
	var upgrade = up.get_upgrade(upgrade_type) as Upgrade
	if upgrade.upgrade_menu == type:
		if upgrade.purchased.is_true():
			if not upgrade_type in purchased_upgrades:
				purchased_upgrades.append(upgrade_type)
		else:
			if upgrade_type in purchased_upgrades:
				purchased_upgrades.erase(upgrade_type)



# - Actions

func add_upgrade(upgrade: int) -> void:
	if not upgrade in upgrades:
		upgrades.append(upgrade)



func unlock() -> void:
	unlocked = true



func set_affordable_and_unpurchased(upgrade: int, affordable_and_unpurchased: bool) -> void:
	if affordable_and_unpurchased:
		if not upgrade in affordable_and_unpurchased_upgrades:
			affordable_and_unpurchased_upgrades.append(upgrade)
			purchasable_upgrade_count_increased.emit()
	else:
		if upgrade in affordable_and_unpurchased_upgrades:
			affordable_and_unpurchased_upgrades.erase(upgrade)
			purchasable_upgrade_count_decreased.emit()




# - Get

func get_total_upgrade_count() -> int:
	return upgrades.size()


func get_current_upgrade_count() -> int:
	return purchased_upgrades.size()
