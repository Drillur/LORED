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

signal stage_unlocked_changed(stage, unlocked)
signal prestiged

var type: int
var key: String

var details := Details.new()

var times_reset := 0
var unlocked := false:
	set(val):
		if unlocked != val:
			unlocked = val
			emit_signal("stage_unlocked_changed", type, val)

var loreds := []
var upgrades := []
var currencies := []



func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	call(key)



func NO_STAGE():
	details.name = "No Stage"
	details.color = gv.game_color
	details.icon = load("res://Sprites/Hud/savedelete.png")
func STAGE1():
	details.name = "Stage 1"
	details.color = Color(0.878431, 0.121569, 0.34902)
	details.icon = load("res://Sprites/Hud/Tab/t0.png")
func STAGE2(): 
	details.name = "Stage 2"
	details.color = Color(1, 0.541176, 0.541176)
	details.icon = load("res://Sprites/Hud/Tab/s2.png")
func STAGE3(): 
	details.name = "Stage 3"
	details.color = Color(0.8, 0.8, 0.8)
	details.icon = load("res://Sprites/Upgrades/thewitchofloredelith.png")
func STAGE4(): 
	details.name = "Stage 4"
	details.color = Color(0.8, 0.8, 0.8)
	details.icon = load("res://Sprites/Currency/Grief.png")



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
