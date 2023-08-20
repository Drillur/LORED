class_name Stage
extends RefCounted



var saved_vars := [
	"unlocked",
	"times_reset",
]


enum Type {
	NO_STAGE,
	STAGE1,
	STAGE2,
	STAGE3,
	STAGE4,
}

signal stage_unlocked_changed(unlocked)
signal just_reset

var type: int
var key: String

var name: String
var icon: Texture
var icon_text: String
var color: Color
var color_text: String
var icon_and_name_text: String

var times_reset := 0
var unlocked := false:
	set(val):
		if unlocked != val:
			unlocked = val
			emit_signal("stage_unlocked_changed", val)

 # types only, no references
var loreds := []
var upgrades := []
var currencies := []



func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	call(key)
	icon_text = "[img=<15>]" + icon.get_path() + "[/img]"
	color_text = "[color=#" + color.to_html() + "]%s[/color]"
	icon_and_name_text = icon_text + " " + name



func NO_STAGE():
	name = "No Stage"
	color = gv.game_color
	icon = load("res://Sprites/Hud/savedelete.png")
func STAGE1():
	name = "Stage 1"
	color = Color(0.878431, 0.121569, 0.34902)
	icon = load("res://Sprites/Hud/Tab/t0.png")
func STAGE2(): 
	name = "Stage 2"
	color = Color(1, 0.541176, 0.541176)
	icon = load("res://Sprites/Hud/Tab/s2.png")
func STAGE3(): 
	name = "Stage 3"
	color = Color(0.8, 0.8, 0.8)
	icon = load("res://Sprites/Upgrades/thewitchofloredelith.png")
func STAGE4(): 
	name = "Stage 4"
	color = Color(0.8, 0.8, 0.8)
	icon = load("res://Sprites/Currency/Grief.png")



# - Signal



# - Actions

func add_lored(lored: int) -> void:
	if not lored in loreds:
		loreds.append(lored)


func add_upgrade(upgrade: int) -> void:
	if not upgrade in upgrades:
		upgrades.append(upgrade)


func add_currency(currency: int) -> void:
	if not currency in currencies:
		currencies.append(currency)


func unlock() -> void:
	unlocked = true



# - Get
