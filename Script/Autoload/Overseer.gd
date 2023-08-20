extends Node



var saved_vars := [
	"current_clock",
	"session_duration",
	"total_duration_played",
	"stage0",
	"stage1",
	"stage2",
	"stage3",
	"stage4",
]



enum Platform {PC, HTML,}

var dev_mode := true#false
const PLATFORM := Platform.PC

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

const game_color := Color(1, 0, 0.235)

var texts_parent: Control



func _ready() -> void:
	open()
	for i in range(0, 5):
		set("stage" + str(i), Stage.new(i))
	
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

signal session_incremented(session)

var last_clock: float
var current_clock: float
var session_duration: int:
	set(val):
		session_duration = val
		session_incremented.emit(session_duration)
var total_duration_played: int

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
		t.start(1)
		await t.timeout
		session_duration += 1
		total_duration_played += 1
	t.queue_free()



# - Handy

var password := 0.0

signal root_ready_finished
var root_ready := false:
	set(val):
		root_ready = val
		if val:
			emit_signal("root_ready_finished")


func reload_scene() -> void:
	root_ready = false
	close_all()
	get_tree().reload_current_scene()
	open_all()


func close_all() -> void:
	password = 0.0
	em.close()
	#wi.close()
	#up.close()
	lv.close()
	wa.close()
	close()


func open_all() -> void:
	open()
#	wa.open()
#	lv.open()
#	up.open()
#	wi.open()
	em.open()


func close() -> void:
	password = 0.0


func open() -> void:
	password = Time.get_unix_time_from_system()
	session_tracker()



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
			"text": prepended_text + _data[cur].text,
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
			"text": prepended_text + _data[cur].text,
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



## - Update Queue
#
#var update_queue := []
#var update_cooldown := []
#
#
#func update(method: Callable) -> void:
#	var my_pass := gv.password
#
#	if method in update_cooldown:
#		if not method in update_queue:
#			update_queue.append(method)
#		return
#
#	if not method.is_valid():
#		return
#
#	update_cooldown.append(method)
#
#	var obj := method.get_object()
#	if obj.has_signal("visibility_changed"):
#		if not method.get_object().visible:
#			await method.get_object().showed_or_removed
#
#			if my_pass != gv.password:
#				return
#
#			if not method.is_valid():
#				if method in update_queue:
#					update_queue.erase(method)
#				return
#
#	if method in update_queue:
#		update_queue.erase(method)
#
#	if my_pass != gv.password:
#		return
#
#	method.call()
#	await get_tree().create_timer(0.016).timeout
#
#	if my_pass != gv.password:
#		return
#
#	update_cooldown.erase(method)
#	if method in update_queue:
#		update(method)



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
	tooltip.parent = parent
	tooltip.tooltip_parent = tooltip_parent
	tooltip.setup(type)
	tooltip_parent.add_child(tooltip)
	tooltip.grow_vertical = Control.GROW_DIRECTION_BEGIN
	
	
	tooltip_content = SRC[TOOLTIP_KEYS[type]].instantiate()
	tooltip_content.setup(info)
	tooltip.content.add_child(tooltip_content)
	tooltip.get_node("bg").self_modulate = tooltip_content.color
	
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



func get_timer(duration: float) -> SceneTreeTimer:
	return get_tree().create_timer(duration)



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
		return amount.roundDown().text + " " + unit_text(type, amount)
	
	static func unit_text(type: int, amount: Big) -> String:
		if amount.equal(1):
			return WORD[type]["SINGULAR"]
		return WORD[type]["PLURAL"]

func parse_time(big: Big) -> String:
	if big.less(0):
		big.set_to(0)
	
	if big.less(1) or big.text[0] == "-":
		if big.equal(0):
			return ""
		return "!"
	
	return TimeUnit.get_text(big)



# - Stage and - Reset

var stage0: Stage
var stage1: Stage
var stage2: Stage
var stage3: Stage
var stage4: Stage

signal just_reset
signal just_complete_reset
signal stage_changed(stage)

var selected_stage := 1:
	set(val):
		if selected_stage != val:
			selected_stage = val
			emit_signal("stage_changed", selected_stage)
var last_reset_stage := 1



func reset(stage: int) -> void:
	for i in range(stage, 0, -1):
		get("stage" + str(i)).reset()
	emit_signal("just_reset")


func add_currency_to_stage(stage: int, currency: int) -> void:
	get("stage" + str(stage)).add_currency(currency)


func add_upgrade_to_stage(stage: int, upgrade: int) -> void:
	get("stage" + str(stage)).add_upgrade(upgrade)


func add_lored_to_stage(stage: int, lored: int) -> void:
	get("stage" + str(stage)).add_lored(lored)



func get_stage_color(stage: int) -> Color:
	return get("stage" + str(stage)).color


func get_currencies_in_stage(stage: int) -> Array:
	return get("stage" + str(stage)).currencies


func get_loreds_in_stage(stage: int) -> Array:
	return get("stage" + str(stage)).loreds




