class_name LOREDVico
extends MarginContainer



@onready var fuel_bar = %"Fuel Bar" as Bar
@onready var info = %Info as IconButton
@onready var jobs = %Jobs as IconButton
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

var level_icon = preload("res://Sprites/Hud/Level.png")

var prefer_left_down: bool
var has_lored := false
var lored: LORED
var current_job: Job

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
	status.hide()
	progress_bar.hide()
	progress_bar.remove_markers()
	fuel_bar.size.x = size.x
	fuel_bar.delta_bar.hide()
	fuel_bar.animate_changes()
	fuel_bar.hide_background()
	set_icons()
	remove_checks()
	
	active_buffs.hide()
	view_special.hide()
	
	sleep_text_timer.connect("timeout", spew_sleep_text)
	sleep_text_timer.connect("timeout", start_spewing_sleep_text)
	sleep_timer.connect("timeout", spent_one_second_asleep)
	sleep_timer.connect("timeout", start_sleep_timer)
	
	SaveManager.connect("load_finished", load_finished)
	SaveManager.connect("load_started", load_started)
	
	lv.connect("sleep_just_unlocked", sleep_lock)
	lv.connect("advanced_details_just_unlocked", advanced_details_lock)
	sleep_lock(false)
	advanced_details_lock(false)



func set_icons() -> void:
	info.set_icon(load("res://Sprites/Hud/Info.png"))
	jobs.set_icon(load("res://Sprites/Hud/Jobs.png"))
	active_buffs.set_icon(load("res://Sprites/Hud/activeBuffs.png"))
	sleep.set_icon(gv.icon_asleep)
	view_special.set_icon(load("res://Sprites/Hud/View.png"))
	level_up.set_icon(load("res://Sprites/Hud/Level.png"))


func remove_checks() -> void:
	info.remove_check().remove_autobuyer()
	jobs.remove_check().remove_autobuyer()
	active_buffs.remove_check().remove_autobuyer()
	sleep.remove_check().remove_autobuyer()
	view_special.remove_check().remove_autobuyer()



func attach_lored(_lored: LORED) -> void:
	lored = _lored
	has_lored = true
	
	# signals
	lored.connect("leveled_up", lored_leveled_up)
	lored.cost.connect("affordable_changed", cost_update)
	cost_update(lored.cost.affordable)
	level_up.button.connect("pressed", purchase_level_up)
	sleep.button.connect("pressed", sleep_clicked)
	lored.connect("asleep_changed", sleep_changed)
	fuel_bar.attach_attribute(lored.fuel)
	lored.connect("became_unable_to_work", start_idle)
	lored.connect("went_to_sleep", go_to_sleep)
	lored.connect("woke_up", wake_up)
	lored.cost.connect("became_affordable", flash_level_up_button)
	lored.connect("leveled_up", flash_on_level_up)
	lored.unlocked.became_true.connect(show)
	lored.unlocked.became_false.connect(hide)
	lored.purchased.changed.connect(purchased_changed)
	lored.autobuy.changed.connect(autobuy_changed)
	
	info.button.connect("mouse_entered", show_info_tooltip)
	info.button.connect("mouse_exited", gv.clear_tooltip)
	level_up.button.connect("mouse_entered", show_level_up_tooltip)
	level_up.button.connect("mouse_exited", gv.clear_tooltip)
	sleep.button.connect("mouse_entered", show_sleep_tooltip)
	sleep.button.connect("mouse_exited", gv.clear_tooltip)
	jobs.button.connect("mouse_entered", show_jobs_tooltip)
	jobs.button.connect("mouse_exited", gv.clear_tooltip)
	
	for job in lored.jobs:
		lored.jobs[job].connect("cut_short", job_cut_short)
	
	# ref
	$bg.self_modulate = lored.color
	progress_bar.color = lored.color
	progress_bar.modulate.a = 0.25
	fuel_bar.color = wa.get_color(lored.fuel_currency)
	fuel_bar.modulate = Color(0.75, 0.75, 0.75)
	lored_name.modulate = lored.color
	info.color = lored.faded_color
	jobs.color = lored.faded_color
	active_buffs.color = lored.faded_color
	sleep.color = lored.faded_color
	view_special.color = lored.faded_color
	level_up.color = lored.faded_color
	
	info.button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	jobs.button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	active_buffs.button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	animation.setup(lored)
	animation.modulate = lored.faded_color
	level_up.show_check() if lored.cost.affordable else level_up.hide_check()
	currency.hide_threshold()
	lored_name.text = lored.name + ", " + lored.title
	lored_icon.texture = lored.icon
	
	hide()



func cost_update(affordable: bool) -> void:
	level_up.check.visible = affordable



# - Tooltip


func show_info_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_INFO, get_preferred_side(), {"lored": lored.type})


func show_level_up_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_LEVEL_UP, get_preferred_side(), {"lored": lored.type})


func show_sleep_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_SLEEP, get_preferred_side(), {"lored": lored.type})


func show_jobs_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_JOBS, get_preferred_side(), {"lored": lored.type})


func get_preferred_side() -> Node:
	return left_down if prefer_left_down else right_down



# - Ref Shit

func load_finished() -> void:
	visible = lored.unlocked.get_value()
	lored_leveled_up(lored.level)


func load_started() -> void:
	stop_progress_bar()


func purchased_changed(purchased: bool) -> void:
	if not purchased:
		stop_progress_bar()
		active_buffs.hide()
		view_special.hide()
		currency.hide()
		name_and_icon.show()
	else:
		name_and_icon.hide()
		currency.show()
		if lv.sleep_unlocked:
			sleep.show()
		if lv.advanced_details_unlocked:
			jobs.show()


func lored_leveled_up(_level: int) -> void:
	if not lored.last_purchase_forced:
		gv.throw_text_from_parent(
			level_up_texts, 
			{
				"text": lored.get_level_text(),
				"color": lored.color,
				"icon": level_icon,
				"icon modulate": lored.color,
			}
		)


func job_completed() -> void:
	if current_job.has_produced_currencies:
		gv.throw_texts_by_dictionary(output_texts, current_job.last_production)
	stop_progress_bar()


func job_cut_short() -> void:
	stop_progress_bar()


func flash_level_up_button() -> void:
	gv.flash(level_up, Color(0, 1, 0))


func flash_on_level_up(_level: int) -> void:
	gv.flash(self, lored.color)


func sleep_lock(unlocked: bool) -> void:
	sleep.visible = (unlocked and lored.unlocked)# or gv.dev_mode
	if sleep.visible:
		gv.flash(sleep, lored.color)


func advanced_details_lock(unlocked: bool) -> void:
	jobs.visible = (unlocked and lored.unlocked)# or gv.dev_mode
	if jobs.visible:
		gv.flash(jobs, lored.color)


func autobuy_changed(autobuy: bool) -> void:
	level_up.autobuyer.visible = autobuy
	if autobuy:
		level_up.autobuyer.play()



# - Actions

func purchase_level_up() -> void:
	if lored.cost.affordable or gv.dev_mode:
		lored.manual_purchase()
	else:
		gv.get_tooltip().get_price_node().flash()


func start_job(_job: Job) -> void:
	current_job = _job as Job
	progress_bar.start(current_job.duration.get_as_float())
	set_status_and_currency(current_job.status_text, current_job.get_primary_currency())
	animation.play_job_animation(current_job)


func stop_progress_bar() -> void:
	progress_bar.stop()
	animation.sleep()


func set_status_and_currency(_status: String, _currency: int) -> void:
	if _status == "":
		status.hide()
	else:
		status.show()
		status.text = "[i]" + _status
	
	currency.show()
	currency.setup(_currency)


func sleep_clicked() -> void:
	if lored.will_go_to_sleep():
		lored.dequeue_sleep()
		sleep_changed(false)
	else:
		lored.enqueue_sleep()
		sleep_changed(true)


func sleep_changed(asleep: bool) -> void:
	if asleep:
		sleep.set_icon(gv.icon_awake)
	else:
		sleep.set_icon(gv.icon_asleep)


func start_idle() -> void:
	if lored.reason_cannot_work == LORED.ReasonCannotWork.UNKNOWN:
		set_status_and_currency("", lored.primary_currency)
	animation.sleep()


func wake_up() -> void:
	sleep_text_timer.stop()
	sleep_timer.stop()


func go_to_sleep() -> void:
	set_status_and_currency("[wave amp=20 freq=1]Sleeping.", lored.primary_currency)
	animation.sleep()
	start_spewing_sleep_text()
	start_sleep_timer()


func start_sleep_timer() -> void:
	if lored.asleep and sleep_timer.is_stopped():
		sleep_timer.start(1)


func spent_one_second_asleep() -> void:
	lored.emit_signal("spent_one_second_asleep")


func start_spewing_sleep_text() -> void:
	if lored.asleep and sleep_text_timer.is_stopped():
		sleep_text_timer.start(randf_range(3, 6))


func spew_sleep_text() -> void:
	gv.throw_text_from_parent(
		output_texts, 
		{
			"text": sleep_text_pool[randi() % sleep_text_pool.size()],
			"color": lored.color,
		}
	)



func emote(_emote: Emote) -> void:
	var emote_vico = em.emote_vico.instantiate() as EmoteVico
	emote_vico.setup(_emote)
	emote_container.add_child(emote_vico)



