class_name UpgradeMenu
extends Resource



var saved_vars := [
	"unlocked",
	"times_reset",
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

signal just_unlocked

var type: int
var key: String

var name: String
var icon: Texture
var icon_text: String
var color: Color
var color_text: String

var times_reset := 0
var unlocked := false

var upgrades := []
var purchased_upgrades := []



func _init(_type: int) -> void:
	type = _type
	key = TYPE_KEYS[type]
	name = key.capitalize().replace("_", " ")
	call(key)
	if icon != null:
		icon_text = "[img=<15>]" + icon.get_path() + "[/img]"
	if color != null:
		color_text = "[color=#" + color.to_html() + "]%s[/color]"



func NORMAL():
	color = Color(0.733333, 0.458824, 0.031373)
	icon = load("res://Sprites/Hud/Tab/s1n.png")
func MALIGNANT(): 
	color = Color(0.878431, 0.121569, 0.34902)
	icon = load("res://Sprites/Hud/Tab/s1m.png")
func EXTRA_NORMAL(): 
	color = Color(0.47451, 0.870588, 0.694118)
	icon = load("res://Sprites/Hud/Tab/s2n.png")
func RADIATIVE(): 
	color = Color(1, 0.541176, 0.541176)
	icon = load("res://Sprites/Hud/Tab/s2m.png")
func RUNED_DIAL(): 
	color = Color(1, 0.541176, 0.541176)
func SPIRIT(): 
	color = Color(1, 0.541176, 0.541176)
func S4N(): 
	color = Color(1, 0.541176, 0.541176)
func S4M(): 
	color = Color(1, 0.541176, 0.541176)



# - Signal

func add_purchased_upgrade(upgrade_type: int) -> void:
	var upgrade = up.get_upgrade(upgrade_type)
	if upgrade.upgrade_menu == type:
		if not upgrade in purchased_upgrades:
			purchased_upgrades.append(upgrade)



# - Actions

func reset() -> void:
	times_reset += 1
	for upgrade in purchased_upgrades:
		print("resetting ", upgrade.key, "...")



func add_upgrade(upgrade: Upgrade) -> void:
	if not upgrade in upgrades:
		upgrades.append(upgrade)



func unlock() -> void:
	unlocked = true
	emit_signal("just_unlocked")


# - Get

func get_total_upgrade_count() -> int:
	return upgrades.size()


func get_current_upgrade_count() -> int:
	return purchased_upgrades.size()


func icon_and_name_text() -> String:
	return icon_text + " " + name
