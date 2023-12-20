extends Node



var saved_vars := [
	"run_duration",
	"total_duration_played",
	"current_clock",
	"session_duration",
	"stage0",
	"stage1",
	"stage2",
	"stage3",
	"stage4",
	"dialogue",
]


func load_finished():
	current_clock = Time.get_unix_time_from_system()
	session_duration.reset()



enum Platform {PC, HTML,}

var dev_mode := true#false
const PLATFORM := Platform.PC
const game_color := Color(1, 0, 0.235)
const ONE_FRAME = 1.0/60

var theme_standard := preload("res://Theme/Standard.tres")
var theme_invis := preload("res://Theme/Invis.tres")
var theme_text_button := preload("res://Theme/TextButton.tres")
var theme_text_button_alternate := preload("res://Theme/TextButtonAlternate.tres")


var texts_parent: Control
var menu_container_size: float

func _ready() -> void:
	randomize()
	SaveManager.load_finished.connect(load_finished)
	SaveManager.load_finished.connect(get_offline_earnings)
	get_tree().root.size_changed.connect(update_menu_container_size)
	call_deferred("update_menu_container_size")
	session_tracker()
	for i in range(0, 5):
		set("stage" + str(i), Stage.new(i))
		get("stage" + str(i)).stage_unlocked_changed.connect(emit_stage_unlocked)
	init_dialogues()
	
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



func update_menu_container_size() -> void:
	menu_container_size = get_viewport().size.y - 88 - 26



# - Clock

signal one_second

var last_clock: float
var current_clock: float = Time.get_unix_time_from_system()
var session_duration := LoudInt.new(0)
var total_duration_played: int
var run_duration := LoudInt.new(0)

func _notification(what) -> void:
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		last_clock = Time.get_unix_time_from_system()
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		var time := Time.get_unix_time_from_system()
		if time - current_clock > 1:
			var time_delta := time - last_clock
			if time_delta > 1:
				get_offline_earnings(last_clock)


func session_tracker() -> void:
	await root_ready.became_true
	var t = Timer.new()
	t.one_shot = false
	t.wait_time = 1
	add_child(t)
	t.timeout.connect(second_passed)
	t.start()


func second_passed() -> void:
	current_clock = Time.get_unix_time_from_system()
	session_duration.add(1)
	total_duration_played += 1
	run_duration.add(1)
	if SaveManager.get_time_since_last_save() >= 30:
		SaveManager.save_game()
	one_second.emit()



# - Handy


const CHAT_INTERVAL_STANDARD := 0.035
const CHAT_INTERVAL_PUNCTUATION := 0.25
const PUNCTUATION_MARKS := ["!", ",", ".", "?"]

signal opened
var root_ready := LoudBool.new(false)
var closed := true


func close_all() -> void:
	em.close()
	wi.close()
	#up.close() doesnt exist
	lv.close()
	wa.close()
	close()


func open_all() -> void:
	open()
	#wa.open() doesnt exist
	#lv.open() same
	#up.open() yup
	#wi.open()
#	em.open()


func close() -> void:
	closed = true


func open() -> void:
	closed = false
	opened.emit()



func node_has_point(node: Node, point: Vector2) -> bool:
	if not node.is_visible_in_tree():
		return false
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


var flying_texts := []

func flash(parent: Node, color = Color(1, 0, 0)) -> void:
	if Engine.get_frames_per_second() < 60:
		return
	var _flash = res.get_resource("flash").instantiate()
	parent.add_child(_flash)
	_flash.flash(color)



func update_discord_details(text: String) -> void:
	discord_sdk.details = text
	discord_sdk.refresh()


func update_discord_state(text: String) -> void:
	discord_sdk.state = text
	discord_sdk.refresh()


func get_random_color() -> Color:
	return Color(
		randf(),
		randf(),
		randf(),
		1
	)


func color_text(color: Color, text: String) -> String:
	return "[color=#" + color.to_html() + "]" + text + "[/color]"


func get_script_variables(script: Script) -> Array:
	var variable_names := []
	for property in script.get_script_property_list():
		if property.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
			variable_names.append(property.name)
	return variable_names



# - Tooltip

enum Tooltip {
	LORED_INFO,
	LORED_FUEL,
	LORED_LEVEL_UP,
	LORED_SLEEP,
	LORED_JOBS,
	UPGRADE_TOOLTIP,
	WISH_TOOLTIP,
	JUST_TEXT,
	WALLET_CURRENCY_TOOLTIP,
	PRESTIGE_TOOLTIP,
	LORED_BUFFS,
}

var TOOLTIP_KEYS := Tooltip.keys()

var tooltip: Node
var tooltip_content: Node
var tooltip_parent: MarginContainer
var tip_filled := false


func new_tooltip(type: int, parent: Node, info: Dictionary) -> void:
	clear_tooltip()
	
	tooltip = res.get_resource("tooltip").instantiate()
	tooltip.parent = parent
	tooltip.tooltip_parent = tooltip_parent
	tooltip.setup(type)
	tooltip_parent.add_child(tooltip)
	tooltip.grow_vertical = Control.GROW_DIRECTION_BEGIN
	
	var key = TOOLTIP_KEYS[type].to_lower()
	tooltip_content = res.get_resource(key).instantiate()
	tooltip_content.setup(info)
	tooltip.content.add_child(tooltip_content)
	tooltip.color = tooltip_content.color
	
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


func scroll_tooltip(direction: int) -> void:
	if (
		tip_filled
		and is_instance_valid(tooltip_content)
		and tooltip_content.has_method("scroll")
	):
		tooltip_content.scroll(direction)


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
			type = Type.values()[type + 1]
		return amount.roundDown().text + " " + unit_text(type, amount)
	
	static func unit_text(type: int, amount: Big) -> String:
		if amount.equal(1):
			return WORD[type]["SINGULAR"]
		return WORD[type]["PLURAL"]


func get_time_dict(time: int) -> Dictionary:
	var dict := {"days": 0, "years": 0, "hours": 0, "minutes": 0, "seconds": 0}
	if time >= 31536000:
		dict["years"] = time / 31536000
		time = time % 31536000
	if time >= 86400:
		dict["days"] = time / 86400
		time = time % 86400
	if time >= 3600:
		dict["hours"] = time / 3600
		time = time % 3600
	if time >= 60:
		dict["minutes"] = time / 60
		time = time % 60
	dict["seconds"] = time
	return dict


func get_time_text_from_dict(dict: Dictionary) -> String:
	var years = dict["years"]
	var days = dict["days"]
	var hours = dict["hours"]
	var minutes = dict["minutes"]
	var seconds = dict["seconds"]
	
	var number_of_above_zero_elements := 0
	if years > 0:
		number_of_above_zero_elements += 1
	if days > 0:
		number_of_above_zero_elements += 1
	if hours > 0:
		number_of_above_zero_elements += 1
	if minutes > 0:
		number_of_above_zero_elements += 1
	if seconds > 0:
		number_of_above_zero_elements += 1
	
	var a: String
	var b: String
	var c: String
	var d: String
	
	match number_of_above_zero_elements:
		5:
			return str(years) + " years, " + str(days) + " days, " + str(hours) + " hours, " + str(minutes) + " minutes, and " + str(seconds) + " seconds"
		4:
			if years > 0:
				a = str(years) + " years"
				if days > 0:
					b = str(days) + " days"
					if hours > 0:
						c = str(hours) + " hours"
						if minutes > 0:
							d = str(minutes) + " minutes"
						else:
							d = str(seconds) + " seconds"
					else:
						c = str(minutes) + " minutes"
						d = str(seconds) + " seconds"
				else:
					b = str(hours) + " hours"
					c = str(minutes) + " minutes"
					d = str(seconds) + " seconds"
			else:
				a = str(days) + " days"
				b = str(hours) + " hours"
				c = str(minutes) + " minutes"
				d = str(seconds) + " seconds"
			return "%s, %s, %s, and %s" % [a, b, c, d]
		3:
			if years > 0:
				a = str(years) + " years"
				if days > 0:
					b = str(days) + " days"
					if hours > 0:
						c = str(hours) + " hours"
					elif minutes > 0:
						c = str(minutes) + " minutes"
					else:
						c = str(seconds) + " seconds"
				elif hours > 0:
					b = str(hours) + " hours"
					if minutes > 0:
						c = str(minutes) + " minutes"
					else:
						c = str(seconds) + " seconds"
				else:
					b = str(minutes) + " minutes"
					c = str(seconds) + " seconds"
			elif days > 0:
				a = str(days) + " days"
				if hours > 0:
					b = str(hours) + " hours"
					if minutes > 0:
						c = str(minutes) + " minutes"
					else:
						c = str(seconds) + " seconds"
				else:
					b = str(minutes) + " minutes"
					c = str(seconds) + " seconds"
			else:
				a = str(hours) + " hours"
				b = str(minutes) + " minutes"
				c = str(seconds) + " seconds"
			return "%s, %s, and %s" % [a, b, c]
		2:
			if years > 0:
				a = str(years) + " years"
				if days > 0:
					b = str(days) + " days"
				elif hours > 0:
					b = str(hours) + " hours"
				elif minutes > 0:
					b = str(minutes) + " minutes"
				else:
					b = str(seconds) + " seconds"
			elif days > 0:
				a = str(days) + " days"
				if hours > 0:
					b = str(hours) + " hours"
				elif minutes > 0:
					b = str(minutes) + " minutes"
				else:
					b = str(seconds) + " seconds"
			elif hours > 0:
				a = str(hours) + " hours"
				if minutes > 0:
					b = str(minutes) + " minutes"
				else:
					b = str(seconds) + " seconds"
			else:
				a = str(minutes) + " minutes"
				b = str(seconds) + " seconds"
			return "%s and %s" % [a, b]
		1:
			if years > 0:
				return str(years) + " years"
			elif days > 0:
				return str(days) + " days"
			elif hours > 0:
				return str(hours) + " hours"
			elif minutes > 0:
				return str(minutes) + " minutes"
	return str(seconds) + " seconds"


func parse_time_int(val: int) -> String:
	return get_time_text_from_dict(get_time_dict(val))


func parse_time(big: Big) -> String:
	if big.less(0):
		big.set_to(0)
	
	if big.less(1) or big.text[0] == "-":
		return "" if big.equal(0) else "!"
	
	return TimeUnit.get_text(big)



# - Offline Earnings Shit

signal offline_report_ready

var time_offline: float
var time_offline_dict := {"days": 0, "years": 0,"hours": 0, "minutes":0, "seconds":0}
var offline_earnings: Dictionary


func get_offline_earnings(_last_clock: float = SaveManager.loaded_data["Overseer"]["current_clock"]) -> void:
	await get_tree().physics_frame
	time_offline = Time.get_unix_time_from_system() - _last_clock
	#time_offline = 10000 * randf_range(1,5)
	time_offline_dict = get_time_dict(int(time_offline))
	if time_offline < 30:
		return
	
	var eligible_currencies := []
	
	for c in wa.get_all_currencies():
		c = c as Currency
		
		if not c.eligible_for_offline_earnings():
			continue
		eligible_currencies.append(c)
		
		c.set_gain_over_loss()
	
	if eligible_currencies.is_empty():
		return
	
	for c in eligible_currencies:
		offline_earnings[c.type] = {}
		offline_earnings[c.type]["rate"] = c.get_offline_production(time_offline)
		offline_earnings[c.type]["positive"] = c.positive_offline_rate
		if c.positive_offline_rate:
			c.add_from_lored(offline_earnings[c.type]["rate"])
			#print(c.details.name, " increased by ", offline_earnings[c.type]["rate"].text)
		else:
			c.subtract_from_lored(offline_earnings[c.type]["rate"])
			#print(c.details.name, " decreased by ", offline_earnings[c.type]["rate"].text)
	
	offline_report_ready.emit()




# - Stage

var stage0: Stage
var stage1: Stage
var stage2: Stage
var stage3: Stage
var stage4: Stage

signal stage_unlocked(stage, unlocked)
signal stage_changed(stage)

var selected_stage := 1:
	set(val):
		if selected_stage != val:
			selected_stage = val
			emit_signal("stage_changed", selected_stage)


func unlock_stage(stage: int) -> void:
	var _stage = get_stage(stage)
	if gv.dev_mode and _stage.unlocked:
		printerr("Stage was already unlocked.")
	else:
		_stage.unlock()


func add_currency_to_stage(stage: int, currency: int) -> void:
	get_stage(stage).add_currency(currency)


func add_upgrade_to_stage(stage: int, upgrade: int) -> void:
	get_stage(stage).add_upgrade(upgrade)


func add_lored_to_stage(stage: int, lored: int) -> void:
	get_stage(stage).add_lored(lored)



func get_stage(stage: int) -> Stage:
	return get("stage" + str(stage))


func get_stage_color(stage: int) -> Color:
	return get_stage(stage).details.color


func get_stage_icon(stage: int) -> Texture:
	return get_stage(stage).details.icon



# - Reset

signal hard_reset
signal prestige(stage)
signal prestiged
signal about_to_prestige
var last_reset_stage := 1

func prestige_now(stage: Stage.Type) -> void:
	about_to_prestige.emit()
	run_duration.reset()
	prestige.emit(stage)
	get_stage(stage).prestige()
	prestiged.emit()


func hard_reset_now() -> void:
	hard_reset.emit()


func get_currencies_in_stage(stage: int) -> Array:
	return get_stage(stage).currencies


func get_loreds_in_stage(stage: int) -> Array[LORED.Type]:
	return get_stage(stage).loreds


func emit_stage_unlocked(stage: int, unlocked: bool) -> void:
	stage_unlocked.emit(stage, unlocked)



# - Dialogues


var dialogue_initialized := LoudBool.new(false)
var dialogue := {}


func init_dialogues() -> void:
	await root_ready.became_true
	for d in Dialogue.Type.values():
		dialogue[d] = Dialogue.new(d)
	dialogue_initialized.set_to(true)


func is_dialogue_read(type: Dialogue.Type) -> bool:
	return dialogue[type].read.get_value()
