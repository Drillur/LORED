extends Node



var dev_mode := true # false


var icon_awake := preload("res://Sprites/Hud/awake.png")
var icon_asleep := preload("res://Sprites/Hud/Halt.png")

var theme_standard := preload("res://Theme/Standard.tres")
var theme_invis := preload("res://Theme/Invis.tres")

const SRC := {
	"dtext": preload("res://Hud/dtext.tscn"),
	"price_and_currency": preload("res://Hud/price_and_currency.tscn"),
	"flash": preload("res://Hud/Flash.tscn"),
	
	"tooltip": preload("res://Hud/tooltip.tscn"),
	"LORED_INFO": preload("res://Hud/LORED/Tooltip/lored_info.tscn"),
	"LORED_FUEL": preload("res://Hud/LORED/Tooltip/lored_fuel.tscn"),
	"LORED_LEVEL_UP": preload("res://Hud/LORED/Tooltip/lored_level_up.tscn"),
	"LORED_SLEEP": preload("res://Hud/LORED/Tooltip/lored_sleep.tscn"),
	"LORED_JOBS": preload("res://Hud/LORED/Tooltip/lored_jobs.tscn"),
	"UPGRADE": preload("res://Hud/Upgrade/Tooltip/upgrade_tooltip.tscn"),
	"WISH": preload("res://Hud/Wish/Tooltip/wish_tooltip.tscn"),
}

const TEXTURES := {
	"Level": preload("res://Sprites/Hud/Level.png"),
}

const STAGE_COLORS := {
	1: Color(0.878431, 0.121569, 0.34902),
	2: Color(1, 0.541176, 0.541176),
	3: Color(0.8, 0.8, 0.8),
	4: Color(0.8, 0.8, 0.8),
}


var stage_1_icon_and_name := "[img=<15>]" + preload("res://Sprites/Hud/Tab/t0.png").get_path() + "[/img][color=#" + STAGE_COLORS[1].to_html() + "] Stage 1"
var stage_2_icon_and_name := "[img=<15>]" + preload("res://Sprites/Hud/Tab/s2.png").get_path() + "[/img][color=#" + STAGE_COLORS[2].to_html() + "] Stage 2"

var selected_stage := 1

var texts_parent: Control



# - Handy

func is_mouse_outside_node(mouse_position: Vector2, node: Node) -> bool:
	var size = node.size
	var position = node.position
	return (
		(
			mouse_position.x > position.x + size.x or
			mouse_position.x < position.x
		) or (
			mouse_position.y < position.y or
			mouse_position.y > position.y + size.y
		)
	)


func get_list_text_from_array(arr: Array) -> String:
	var text := ""
	var size = arr.size()
	var i = 0
	while size >= 1:
		text += arr[i]
		if size >= 3:
			text += ", "
		elif size >= 2 and arr.size() >= 3:
			text += ", and "
		elif size >= 2:
			text += " and "
		size -= 1
		i += 1
	return text


func getRandomColor() -> Color:
	var r = randf_range(0, 1)
	var g = randf_range(0, 1)
	var b = randf_range(0, 1)
	return Color(r, g, b, 1.0)


func throw_texts_by_dictionary(parent: Node, _data: Dictionary, prepended_text := "+") -> void:
	var texts := []
	for cur in _data:
		var currency := wa.get_currency(cur) as Currency
		var data = {
			"text": prepended_text + _data[cur].toString(),
			"color": currency.color,
			"icon": currency.icon,
		}
		for text in texts:
			text.position.y -= 13
		var dtext = SRC["dtext"].instantiate()
		dtext.init(data)
		parent.add_child(dtext)
		texts.append(dtext)
		await get_tree().create_timer(0.05).timeout


func throw_texts(parent: Node, _data: Dictionary, prepended_text := "+") -> void:
	var parent_position = parent.global_position
	var texts := []
	for cur in _data:
		var currency := wa.get_currency(cur) as Currency
		var data = {
			"text": prepended_text + _data[cur].toString(),
			"color": currency.color,
			"icon": currency.icon,
		}
		for text in texts:
			text.position.y -= 13
		var dtext = SRC["dtext"].instantiate()
		dtext.init(data)
		texts_parent.add_child(dtext)
		dtext.position = parent_position
		texts.append(dtext)
		await get_tree().create_timer(0.1).timeout


func throw_text(parent: Node, data: Dictionary) -> void:
	var dtext = SRC["dtext"].instantiate()
	dtext.init(data)
	texts_parent.add_child(dtext)
	dtext.position = parent.global_position





func parse_time(big: Big) -> String:
	if big.less(0):
		big = Big.new(0)
	
	if big.less(1) or big.toString()[0] == "-":
		if big.equal(0):
			return ""
		return "!"
	
	if big.less(60):
		return big.roundDown().toString() + "s"
	
	big.d(60) # minutes
	
	if big.less(60):
		return big.roundDown().toString() + "m"
	
	big.d(60) # hours
	
	if big.less(24):
		return big.roundDown().toString() + "h"
	
	big.d(24) # days
	
	if big.less(365):
		return big.roundDown().toString() + "d"
	
	big.d(365) # years
	
	if big.less(10):
		return big.roundDown().toString() + "y"
	
	big.d(10) # decades
	
	if big.less(100):
		return big.roundDown().toString() + "dec"
	
	big.d(100) # centuries
	
	if big.less(1000):
		return big.roundDown().toString() + "cen"
	
	return big.roundDown().toString() + "mil"


func flash(parent: Node, color = Color(1, 0, 0), slow_flash := false) -> void:
	var _flash = gv.SRC["flash"].instantiate()
	parent.add_child(_flash)
	if slow_flash:
		_flash.slow_flash(color)
	else:
		_flash.flash(color)



# - Update Queue

var update_queue := []
var update_cooldown := []


func update(method: Callable) -> void:
	# if not updating from a lored, do not pass 2nd var. won't matter.
	
	if method in update_cooldown:
		if not method in update_queue:
			update_queue.append(method)
		return
	
	if not method.is_valid():
		return
	
	update_cooldown.append(method)
	
	#run the game and click SLeep on Stone. then fix
	
	var obj := method.get_object()
	if obj.has_signal("visibility_changed"):
		if not method.get_object().visible:
			await method.get_object().showed_or_removed
			if not method.is_valid():
				if method in update_queue:
					update_queue.erase(method)
				return
	
	if method in update_queue:
		update_queue.erase(method)
	
	method.call()
	await get_tree().create_timer(0.016).timeout
	
	update_cooldown.erase(method)
	if method in update_queue:
		update(method)



# - Tooltip

enum Tooltip {
	LORED_INFO,
	LORED_FUEL,
	LORED_LEVEL_UP,
	LORED_SLEEP,
	LORED_JOBS,
	UPGRADE,
	WISH,
}

var TOOLTIP_KEYS := Tooltip.keys()

var tooltip: Node
var tooltip_content: Node
var tooltip_parent: MarginContainer
var tip_filled := false


func new_tooltip(type: int, parent: Node, info: Dictionary) -> void:
	clear_tooltip()
	
	tooltip = SRC["tooltip"].instantiate()
	tooltip.setup(type)
	tooltip_parent.add_child(tooltip)
	tooltip.grow_vertical = Control.GROW_DIRECTION_BEGIN
	
	tooltip_content = SRC[TOOLTIP_KEYS[type]].instantiate()
	tooltip_content.setup(info)
	tooltip.content.add_child(tooltip_content)
	tooltip.get_node("bg").self_modulate = tooltip_content.color
	
	if "Right" in parent.name:
		tooltip.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		tooltip_parent.position.x = parent.global_position.x
	elif "Left" in parent.name:
		tooltip.size_flags_horizontal = Control.SIZE_SHRINK_END
		tooltip_parent.position.x = parent.global_position.x - tooltip_parent.size.x
	if "Up" in parent.name:
		tooltip.size_flags_vertical = Control.SIZE_SHRINK_END
		tooltip_parent.position.y = parent.global_position.y - tooltip_parent.size.y
	elif "Down" in parent.name:
		tooltip.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		tooltip_parent.position.y = parent.global_position.y
	
	tip_filled = true


func clear_tooltip() -> void:
	if tip_filled:
		tooltip.queue_free()
		tip_filled = false


func get_tooltip() -> Node:
	if tip_filled:
		if is_instance_valid(tooltip_content):
			return tooltip_content
	return null



# - Reset

signal game_reset
signal complete_reset
signal stage_1_reset
signal stage_2_reset
signal stage_3_reset
signal stage_4_reset

var last_reset_stage: int


func reset(stage: int) -> void:
	emit_signal("stage_" + str(stage) + "_reset")
	emit_signal("reset")

