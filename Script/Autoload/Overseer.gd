extends Node



var saved_vars := [
	"session_duration",
]

var dev_mode := true # false


var icon_awake := preload("res://Sprites/Hud/awake.png")
var icon_asleep := preload("res://Sprites/Hud/Halt.png")

var theme_standard := preload("res://Theme/Standard.tres")
var theme_invis := preload("res://Theme/Invis.tres")
var theme_text_button := preload("res://Theme/TextButton.tres")
var theme_text_button_alternate := preload("res://Theme/TextButtonAlternate.tres")

var control_node := preload("res://Hud/control.tscn")

const SRC := {
	"dtext": preload("res://Hud/dtext.tscn"),
	"price_and_currency": preload("res://Hud/price_and_currency.tscn"),
	"flash": preload("res://Hud/Flash.tscn"),
	
	"tooltip": preload("res://Hud/Tooltip/tooltip.tscn"),
	"LORED_INFO": preload("res://Hud/LORED/Tooltip/lored_info.tscn"),
	"LORED_LEVEL_UP": preload("res://Hud/LORED/Tooltip/lored_level_up.tscn"),
	"LORED_SLEEP": preload("res://Hud/LORED/Tooltip/lored_sleep.tscn"),
	"LORED_JOBS": preload("res://Hud/LORED/Tooltip/lored_jobs.tscn"),
	"UPGRADE": preload("res://Hud/Upgrade/Tooltip/upgrade_tooltip.tscn"),
	"WISH": preload("res://Hud/Wish/Tooltip/wish_tooltip.tscn"),
	"JUST_TEXT": preload("res://Hud/Tooltip/Just Text.tscn"),
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

var game_color := Color(1, 0, 0.235)


var stage_1_icon_and_name := "[img=<15>]" + preload("res://Sprites/Hud/Tab/t0.png").get_path() + "[/img][color=#" + STAGE_COLORS[1].to_html() + "] Stage 1"
var stage_2_icon_and_name := "[img=<15>]" + preload("res://Sprites/Hud/Tab/s2.png").get_path() + "[/img][color=#" + STAGE_COLORS[2].to_html() + "] Stage 2"

var selected_stage := 1

var texts_parent: Control



func _ready() -> void:
	discord_sdk.app_id = 1139940673747951696
	
	# this is boolean if everything worked
	#print("Discord working: " + str(discord_sdk.get_is_discord_working()))
	
	# Set the first custom text row of the activity here
	#discord_sdk.details = "Playing LORED"
	
	# Set the second custom text row of the activity here
	#discord_sdk.state = "Test"
	
	# Image key for small image from "Art Assets" from the Discord Developer website
	discord_sdk.large_image = "LORED"
	
	# Tooltip text for the large image
	#discord_sdk.large_image_text = "Buhhhh"
	
	# Image key for large image from "Art Assets" from the Discord Developer website
	#discord_sdk.small_image = "boss"
	
	# Tooltip text for the small image
	#discord_sdk.small_image_text = "Fighting the end boss! D:"
	
	# "02:41 elapsed" timestamp for the activity
	discord_sdk.start_timestamp = int(Time.get_unix_time_from_system())
	
	# "59:59 remaining" timestamp for the activity
	#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + 3600
	
	# Always refresh after changing the values!
	discord_sdk.refresh()


# - Clock

signal clock_updated

var last_clock: float
var current_clock: float
var session_duration: int

func _notification(what) -> void:
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		last_clock = Time.get_unix_time_from_system()
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		var time := Time.get_unix_time_from_system()
		if time - current_clock > 1:
			var time_delta := time - last_clock
			if time_delta > 1:
				# get offline earnings(time_delta)
				pass


func session_tracker() -> void:
	var t = Timer.new()
	add_child(t)
	while true:
		current_clock = Time.get_unix_time_from_system()
		emit_signal("clock_updated")
		t.start(1)
		await t.timeout
		session_duration += 1
	t.queue_free()



# - Handy

func node_has_point(node: Node, point: Vector2) -> bool:
	return node.get_global_rect().has_point(point)


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


func throw_text_from_parent(parent: Node, data: Dictionary) -> void:
	var control := control_node.instantiate()
	var dtext = SRC["dtext"].instantiate()
	dtext.init(data)
	parent.add_child(control)
	control.add_child(dtext)
	var parent_center_pos = Vector2(
		parent.global_position.x + (parent.size.x / 2),
		parent.global_position.y + (parent.size.y / 2)
	)
	dtext.global_position = parent_center_pos
	await dtext.tree_exiting
	control.queue_free()


func flash(parent: Node, color = Color(1, 0, 0)) -> void:
	var _flash = gv.SRC["flash"].instantiate()
	parent.add_child(_flash)
	_flash.flash(color)



func update_discord_details(text: String) -> void:
	discord_sdk.details = text
	discord_sdk.refresh()


func update_discord_state(text: String) -> void:
	discord_sdk.state = text
	discord_sdk.refresh()



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
	JUST_TEXT,
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
		tooltip_parent.position.y = clamp(tooltip_parent.position.y, -get_viewport().size.y, get_viewport().size.y - tooltip_parent.size.y - 10)
	elif "Down" in parent.name:
		tooltip.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		tooltip_parent.position.y = parent.global_position.y
		tooltip_parent.position.y = clamp(tooltip_parent.position.y, 10, get_viewport().size.y - tooltip.size.y - 10)
	
	#tooltip_parent.position.y = clamp(tooltip_parent.position.y, 10, get_viewport().size.y - tooltip.size.y - 10)
#	if tooltip_parent.position.y + tooltip.size.y > get_viewport().size.y:
#		tooltip_parent.position.y = get_viewport().size.y - tooltip.size.y - 10
#	elif tooltip_parent.position.y < 10:
#		tooltip_parent.position.y = 10
#	if tooltip_parent.position.x + tooltip.size.x > get_viewport().size.x:
#		tooltip_parent.position.x = get_viewport().size.x - tooltip.size.x - 10
#	elif tooltip_parent.position.x < 10:
#		tooltip_parent.position.x = 10
	
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



# - Time Shit

class TimeUnit:
	enum Type {
		SECOND,
		MINUTE,
		HOUR,
		DAY,
		YEAR,
		DECADE,
		CENTURY,
		MILLENIUM,
		EON,
		EXASECOND,
		QUETTASECOND,
		BLACK_HOLE,
	}
	const DIVISION := {
		Type.SECOND: 60,
		Type.MINUTE: 60,
		Type.HOUR: 24,
		Type.DAY: 365,
		Type.YEAR: 10,
		Type.DECADE: 10,
		Type.CENTURY: 10,
		Type.MILLENIUM: "1e6",
		Type.EON: "1e9",
		Type.EXASECOND: "1e12",
		Type.QUETTASECOND: "6e43",
		Type.BLACK_HOLE: 1,
	}
	const WORD := {
		Type.SECOND: {"SINGULAR": "second", "PLURAL": "seconds", "SHORT": "s"},
		Type.MINUTE: {"SINGULAR": "minute", "PLURAL": "minutes", "SHORT": "m"},
		Type.HOUR: {"SINGULAR": "hour", "PLURAL": "hours", "SHORT": "h"},
		Type.DAY: {"SINGULAR": "day", "PLURAL": "days", "SHORT": "d"},
		Type.YEAR: {"SINGULAR": "year", "PLURAL": "years", "SHORT": "y"},
		Type.DECADE: {"SINGULAR": "decade", "PLURAL": "decades", "SHORT": "dec"},
		Type.CENTURY: {"SINGULAR": "century", "PLURAL": "centuries", "SHORT": "cen"},
		Type.MILLENIUM: {"SINGULAR": "millenium", "PLURAL": "millenia", "SHORT": "mil"},
		Type.EON: {"SINGULAR": "eon", "PLURAL": "eons", "SHORT": "eon"},
		Type.EXASECOND: {"SINGULAR": "exasecond", "PLURAL": "exaseconds", "SHORT": "es"},
		Type.QUETTASECOND: {"SINGULAR": "quettasecond", "PLURAL": "quettaseconds", "SHORT": "qs"},
		Type.BLACK_HOLE: {"SINGULAR": "black hole life span", "PLURAL": "black hole lives", "SHORT": "bh"},
	}
	
	static func get_text(amount: Big) -> String:
		var type = Type.SECOND
		while type < Type.size() - 1:
			var division = Big.new(DIVISION[type])
			if amount.less(division):
				break
			amount.d(division)
			type += 1
		return amount.roundDown().toString() + " " + unit_text(type, amount)
	
	static func unit_text(type: int, amount: Big) -> String:
		if amount.equal(1):
			return WORD[type]["SINGULAR"]
		return WORD[type]["PLURAL"]

func parse_time(big: Big) -> String:
	if big.less(0):
		big = Big.new(0)
	
	if big.less(1) or big.toString()[0] == "-":
		if big.equal(0):
			return ""
		return "!"
	
	return TimeUnit.get_text(big)



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
	emit_signal("game_reset")

