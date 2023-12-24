@icon("res://Sprites/reactions/STONE_HAPPY_STONE0.png")
class_name LOREDVico
extends MarginContainer




func load_finished() -> void:
	visible = lored.unlocked.get_value()


func load_started() -> void:
	stop_progress_bar()



@onready var fuel_bar = %"Fuel Bar" as Bar
@onready var sleep = %Sleep as IconButton
@onready var progress_bar = %"Progress Bar" as Bar
@onready var level_up = %"Level Up" as IconButton
@onready var active_buffs = %"Active Buffs" as IconButton
@onready var view_special = %"View Special" as IconButton
@onready var left_down = %LeftDown
@onready var right_down = %RightDown
@onready var output_texts = %"Output Texts"
@onready var currency = %Currency as CurrencyVico
@onready var status = %Status
@onready var name_and_icon = %"Name and Icon"
@onready var lored_icon = %"LORED Icon"
@onready var lored_name = %"LORED Name"
@onready var animation = %AnimatedSprite2D as LOREDAnimation
@onready var emote_container = %"Emote Container"
@onready var sleep_text_timer = $"Sleep Text Timer"
@onready var sleep_timer = $"Sleep Timer"
@onready var level_up_texts = %"Level Up Texts"
@onready var fuel_background = %"Fuel Background"
@onready var details = %Details
@onready var level = %Level

signal lored_details_requested(lored)

var prefer_left_down: bool
var has_lored := false
var lored: LORED
var current_job: Job
var pending_outputs := {}
var last_text_clock := Time.get_unix_time_from_system()

const sleep_text_pool := [
	"[i]Z", "[i]z", "[i]Zz", "[i]zZ", "[i]Zzz", "[i]zzZ", "[i]zZz", "[i]ZzZ",
	"Memememe...",
]


func _on_item_rect_changed():
	if not is_node_ready():
		await ready
	right_down.position.x = size.x + 10
	
	var center_node = size.x / 2
	if global_position.x + center_node <= get_viewport_rect().size.x / 2:
		prefer_left_down = false
	else:
		prefer_left_down = true



func _ready():
	# ref
	progress_bar.hide()
	fuel_bar.size.x = size.x
	
	active_buffs.hide()
	view_special.hide()
	sleep.hide()
	level.hide()
	
	sleep_text_timer.connect("timeout", spew_sleep_text)
	sleep_text_timer.connect("timeout", start_spewing_sleep_text)
	sleep_timer.connect("timeout", spent_one_second_asleep)
	sleep_timer.connect("timeout", start_sleep_timer)
	details.pressed.connect(emit_details)
	
	SaveManager.connect("load_finished", load_finished)
	SaveManager.connect("load_started", load_started)
	
	lv.sleep_unlocked.changed.connect(sleep_lock)



func attach_lored(_lored: LORED) -> void:
	lored = _lored
	has_lored = true
	
	# signals
	gv.prestige.connect(prestige)
	lored.level.changed.connect(level_changed)
	lored.level.increased.connect(level_increased)
	lored.cost.affordable.connect_and_call("changed", cost_update)
	level_up.button.connect("pressed", purchase_level_up)
	sleep.button.connect("pressed", sleep_clicked)
	lored.asleep.changed.connect(sleep_changed)
	fuel_bar.attach_attribute(lored.fuel)
	fuel_background.self_modulate = wa.get_color(lored.fuel_currency)
	lored.connect("became_unable_to_work", start_idle)
	lored.unlocked.became_true.connect(show)
	lored.unlocked.became_true.connect(display_all_parent_nodes)
	lored.unlocked.became_false.connect(hide)
	lored.purchased.changed.connect(purchased_changed)
	lored.autobuy.changed.connect(autobuy_changed)
	lored.received_buff.connect(buffs_lock)
	lored.purchased.connect_and_call("changed", buffs_lock)
	lored.purchased.changed.connect(sleep_lock)
	lored.unlocked.changed.connect(sleep_lock)
	lored.status.changed.connect(status_changed)
	lored.unlocked.connect_and_call("changed", unlocked_changed)
	
	sleep_lock()
	
	level_up.button.connect("mouse_entered", show_level_up_tooltip)
	level_up.button.connect("mouse_exited", gv.clear_tooltip)
	sleep.button.connect("mouse_entered", show_sleep_tooltip)
	sleep.button.connect("mouse_exited", gv.clear_tooltip)
	active_buffs.mouse_entered.connect(show_lored_buffs_tooltip)
	active_buffs.mouse_exited.connect(gv.clear_tooltip)
	
	for job in lored.jobs:
		lored.jobs[job].connect("cut_short", job_cut_short)
	
	# ref
	$bg.self_modulate = lored.details.color
	progress_bar.color = lored.details.color
	progress_bar.modulate.a = 0.1
	fuel_bar.color = wa.get_color(lored.fuel_currency)
	#fuel_bar.modulate = Color(0.75, 0.75, 0.75)
	lored_name.modulate = lored.details.color
	active_buffs.color = lored.details.alt_color
	sleep.color = lored.details.alt_color
	view_special.color = lored.details.alt_color
	level_up.color = lored.details.alt_color
	details.modulate = lored.details.color
	level.modulate = lored.details.color
	
	active_buffs.button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	animation.setup(lored)
	level_up.show_check() if lored.cost.affordable.is_true() else level_up.hide_check()
	currency.hide_threshold()
	lored_name.text = lored.details.name + ", " + lored.details.get_title()
	lored_icon.texture = lored.details.icon
	
	currency.attach_lored(lored)
	
	hide()


func cost_update() -> void: 
	var val = lored.cost.affordable.get_value()
	level_up.check.visible = val
	if val:
		flash_level_up_button()


func prestige(stage: int) -> void:
	if stage >= lored.stage:
		animation.capped_anim.set_to(false)



# - Tooltip


func show_info_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_INFO, get_preferred_side(), {"lored": lored.type})


func show_level_up_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_LEVEL_UP, get_preferred_side(), {"lored": lored.type})


func show_sleep_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_SLEEP, get_preferred_side(), {"lored": lored.type})


func show_jobs_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_JOBS, get_preferred_side(), {"lored": lored.type})


func show_lored_buffs_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_BUFFS, get_preferred_side(), {"lored": lored.type})


func get_preferred_side() -> Node:
	return left_down if prefer_left_down else right_down



# - Ref Shit


func unlocked_changed() -> void:
	if lored.unlocked.is_false():
		currency.hide()
		name_and_icon.show()
	else:
		name_and_icon.hide()
		currency.show()


func purchased_changed() -> void:
	if lored.purchased.is_true():
		name_and_icon.hide()
		currency.show()
		if lv.sleep_unlocked.is_true():
			sleep.show()
		level.show()
	else:
		stop_progress_bar()
		active_buffs.hide()
		view_special.hide()
		level.hide()


func level_changed() -> void:
	level.text = "[font_size=8]LV [font_size=12]%s" % lored.level.get_text()


func level_increased() -> void:
	if Engine.get_frames_per_second() >= 60:
		gv.flash(self, lored.details.color)
		if not lored.last_purchase_forced:
			var text = FlyingText.new(
				FlyingText.Type.LEVEL_UP,
				level_up_texts,
				level_up_texts,
				[0, 0],
			)
			text.add({
				"lored": lored.type,
			})
			text.go()


func job_completed() -> void:
	if Engine.get_frames_per_second() < 60:
		pending_outputs.clear()
	elif current_job.has_produced_currencies:
		
		if animation.capped_anim.is_true():
			for cur in current_job.last_production:
				if not cur in pending_outputs:
					pending_outputs[cur] = Big.new(current_job.last_production[cur])
				else:
					pending_outputs[cur].a(current_job.last_production[cur])
			
			if Time.get_unix_time_from_system() - last_text_clock > 1.0:
				var text = FlyingText.new(
					FlyingText.Type.CURRENCY,
					output_texts,
					output_texts,
					[0, 0],
				)
				for cur in pending_outputs:
					text.add({
						"cur": cur,
						"text": "+" + pending_outputs[cur].text,
						"crit": false,
					})
				text.go()
				pending_outputs.clear()
				last_text_clock = Time.get_unix_time_from_system()
		
		else:
			var text = FlyingText.new(
				FlyingText.Type.CURRENCY,
				output_texts,
				output_texts,
				[0, 0],
			)
			for cur in current_job.last_production:
				text.add({
					"cur": cur,
					"text": "+" + current_job.last_production[cur].text,
					"crit": false,
				})
			text.go()
			last_text_clock = Time.get_unix_time_from_system()
	progress_bar.stop()


func job_cut_short() -> void:
	if current_job.has_required_currencies and Engine.get_frames_per_second() >= 60:
		var text = FlyingText.new(
			FlyingText.Type.CURRENCY,
			output_texts,
			output_texts,
			[1, 1],
		)
		for cur in current_job.in_hand_input:
			text.add({
				"cur": cur,
				"text": "+" + current_job.in_hand_input[cur].text,
				"crit": false,
			})
		text.go()
		
	stop_progress_bar()


func flash_level_up_button() -> void:
	gv.flash(level_up, Color(0, 1, 0))


func sleep_lock() -> void:
	sleep.visible = (
		lv.sleep_unlocked.is_true()
		and lored.unlocked.is_true()
		and lored.purchased.is_true()
	)# or gv.dev_mode
	if sleep.visible:
		gv.flash(sleep, lored.details.color)


func buffs_lock() -> void:
	active_buffs.visible = (
		Buffs.object_has_buff(lored)
		and lored.unlocked.is_true()
		and lored.purchased.is_true()
	)
	if active_buffs.visible:
		gv.flash(active_buffs, lored.details.color)


func autobuy_changed() -> void:
	var autobuy = lored.autobuy.get_value()
	level_up.autobuyer.visible = autobuy
	if autobuy:
		level_up.autobuyer.play()



# - Actions


func purchase_level_up() -> void:
	if lored.cost.affordable.is_true() or gv.dev_mode:
		lored.manual_purchase()
	else:
		gv.get_tooltip().get_price_node().flash()


func sleep_clicked() -> void:
	if lored.asleep.is_true():
		lored.wake_up()
	else:
		lored.go_to_sleep()


func start_job(_job: Job) -> void:
	current_job = _job as Job
	progress_bar.attach_timer(current_job.timer)
	progress_bar.show()
	animation.play_job_animation(current_job)


func stop_progress_bar() -> void:
	progress_bar.stop()
	animation.sleep()


func status_changed() -> void:
	status.text = "[i]%s[/i]" % lored.status.get_value()


func sleep_changed() -> void:
	if lored.asleep.is_true():
		sleep.set_icon(bag.get_resource("awake"))
		lored.status.set_to("[wave amp=20 freq=1]Sleeping.[/wave]")
		animation.sleep()
		start_spewing_sleep_text()
		start_sleep_timer()
		progress_bar.stop()
	else:
		sleep.set_icon(bag.get_resource("Halt"))
		sleep_text_timer.stop()
		sleep_timer.stop()


func start_idle() -> void:
	if lored.reason_cannot_work.equal(LORED.ReasonCannotWork.UNKNOWN):
		lored.status.set_to("Idle")
	animation.sleep()


func start_sleep_timer() -> void:
	if lored.asleep.is_true() and sleep_timer.is_stopped():
		sleep_timer.start(1)


func spent_one_second_asleep() -> void:
	lored.emit_signal("spent_one_second_asleep")


func start_spewing_sleep_text() -> void:
	if lored.asleep.is_true() and sleep_text_timer.is_stopped():
		sleep_text_timer.start(randf_range(3, 6))


func spew_sleep_text() -> void:
	if Engine.get_frames_per_second() >= 60:
		var text = FlyingText.new(
			FlyingText.Type.SLEEP,
			output_texts,
			output_texts,
			[1, 1],
		)
		text.add({
			"color": lored.details.color,
			"text": sleep_text_pool[randi() % sleep_text_pool.size()],
		})
		text.go()



func emote(_emote: Emote) -> void:
	var emote_vico = bag.get_resource("emote_vico").instantiate() as EmoteVico
	emote_vico.setup(_emote)
	emote_container.add_child(emote_vico)



func display_all_parent_nodes() -> void:
	display_parents(get_parent())


func display_parents(node) -> void:
	if node is MarginContainer:
		return
	if not node.visible:
		node.show()
	display_parents(node.get_parent())


func emit_details() -> void:
	lored_details_requested.emit(lored)
