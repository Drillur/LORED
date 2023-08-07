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

var prefer_left_down: bool
var spewing_sleep_text := false
var has_lored := false
var lored: LORED
var current_job: Job

const sleep_text_pool := [
	"[i]Z", "[i]z", "[i]Zz", "[i]zZ", "[i]Zzz", "[i]zzZ", "[i]zZz", "[i]ZzZ",
	"Memememe...",
]



signal showed_or_removed
func _on_visibility_changed():
	if visible:
		emit_signal("showed_or_removed")
func _on_tree_exited():
	emit_signal("showed_or_removed")



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
	progress_bar.do_not_animate_changes()
	progress_bar.remove_markers()
	#fuel_bar.show_background()
	fuel_bar.size.x = size.x
	fuel_bar.delta_bar.hide()
	set_icons()
	remove_checks()
	
	jobs.hide()
	active_buffs.hide()
	sleep.hide()
	view_special.hide()


func set_icons() -> void:
	info.set_icon(load("res://Sprites/Hud/Info.png"))
	jobs.set_icon(load("res://Sprites/Hud/Jobs.png"))
	active_buffs.set_icon(load("res://Sprites/Hud/activeBuffs.png"))
	sleep.set_icon(gv.icon_asleep)
	view_special.set_icon(load("res://Sprites/Hud/View.png"))
	level_up.set_icon(load("res://Sprites/Hud/Level.png"))


func remove_checks() -> void:
	info.remove_check()
	jobs.remove_check()
	active_buffs.remove_check()
	sleep.remove_check()
	view_special.remove_check()



func attach_lored(_lored: LORED) -> void:
	lored = _lored
	has_lored = true
	
	# signals
	lored.level.add_notify_change_method(adjust_if_not_purchased)
	lored.cost.add_cost_vico(self)
	level_up.button.connect("pressed", purchase_level_up)
	sleep.button.connect("pressed", sleep_clicked)
	fuel_bar.attach_attribute(lored.fuel)
	lored.connect("became_unable_to_work", start_idle)
	lored.connect("went_to_sleep", go_to_sleep)
	lored.cost.connect("became_affordable", flash_level_up_button)
	lored.connect("leveled_up", flash_on_level_up)
	
	info.button.connect("mouse_entered", show_info_tooltip)
	info.button.connect("mouse_exited", clear_tooltip)
	fuel_bar.connect("mouse_entered", show_fuel_tooltip)
	fuel_bar.connect("mouse_exited", clear_tooltip)
	level_up.button.connect("mouse_entered", show_level_up_tooltip)
	level_up.button.connect("mouse_exited", clear_tooltip)
	sleep.button.connect("mouse_entered", show_sleep_tooltip)
	sleep.button.connect("mouse_exited", clear_tooltip)
	jobs.button.connect("mouse_entered", show_jobs_tooltip)
	jobs.button.connect("mouse_exited", clear_tooltip)
	
	for job in lored.jobs:
		lored.jobs[job].connect("cut_short", job_cut_short)
	
	# ref
	$bg.self_modulate = lored.color
	progress_bar.color = lored.color
	progress_bar.modulate.a = 0.25
	fuel_bar.color = lored.fuel_currency.color
	fuel_bar.modulate = Color(0.75, 0.75, 0.75)
	lored_name.modulate = lored.color
	info.color = lored.faded_color
	jobs.color = lored.faded_color
	active_buffs.color = lored.faded_color
	sleep.color = lored.faded_color
	view_special.color = lored.faded_color
	level_up.color = lored.faded_color
	
	info.button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	animation.setup(lored)
	animation.modulate = lored.faded_color
	level_up.show_check() if lored.cost.affordable else level_up.hide_check()
	currency.hide_threshold()
	lored_name.text = lored.name
	lored_icon.texture = lored.icon
	
	if not lored.unlocked:
		hide()
		await lored.became_unlocked
		show()



func cost_update(affordable: bool) -> void:
	level_up.check.visible = affordable



# - Tooltip

func clear_tooltip() -> void:
	gv.clear_tooltip()


func show_info_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_INFO, get_preferred_side(), {"lored": lored.type})


func show_fuel_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_FUEL, get_preferred_side(), {"lored": lored.type})


func show_level_up_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_LEVEL_UP, get_preferred_side(), {"lored": lored.type})


func show_sleep_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_SLEEP, get_preferred_side(), {"lored": lored.type})


func show_jobs_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_JOBS, get_preferred_side(), {"lored": lored.type})


func get_preferred_side() -> Node:
	return left_down if prefer_left_down else right_down



# - Ref Shit

func adjust_if_not_purchased() -> void:
	if not lored.purchased:
		jobs.hide()
		active_buffs.hide()
		sleep.hide()
		view_special.hide()
	else:
		name_and_icon.hide()
		currency.show()
		
		jobs.show()
		active_buffs.show()
		if lv.sleep_unlocked:
			sleep.show()
		else:
			lv.connect("sleep_became_unlocked", sleep_became_unlocked)
		view_special.show()
		lored.level.remove_notify_method(adjust_if_not_purchased)


func setup_currency(cur: int) -> void:
	currency.setup(cur)


func job_completed() -> void:
	if current_job.has_produced_currencies:
		gv.throw_texts_by_dictionary(output_texts, current_job.last_production)
	stop_progress_bar()


func job_cut_short() -> void:
	stop_progress_bar()


func flash_level_up_button() -> void:
	gv.flash(level_up, Color(0, 1, 0))


func flash_on_level_up() -> void:
	gv.flash(self, lored.color)


func sleep_became_unlocked() -> void:
	lv.disconnect("sleep_became_unlocked", sleep_became_unlocked)
	sleep.show()
	gv.flash(sleep, lored.color)



# - Actions

func purchase_level_up() -> void:
	if lored.cost.affordable or gv.dev_mode:
		lored.purchase()
	else:
		gv.get_tooltip().get_price_node().flash()


func start_job(_job: Job) -> void:
	current_job = _job as Job
	progress_bar.start(current_job.duration.get_as_float())
	set_status_and_currency(current_job.status_text, current_job.get_primary_currency())
	animation.play_job_animation(current_job)


func stop_progress_bar() -> void:
	if not lored.working:
		progress_bar.stop()


func set_status_and_currency(_status: String, _currency: int = -1) -> void:
	if _status == "":
		status.hide()
	else:
		status.show()
		status.text = "[i]" + _status
	if _currency != -1:
		currency.setup(_currency)
		currency.show()
	else:
		currency.hide()


func sleep_clicked() -> void:
	if lored.asleep or lored.will_go_to_sleep:
		lored.wake_up()
		sleep.set_icon(gv.icon_asleep)
	else:
		lored.go_to_sleep()
		sleep.set_icon(gv.icon_awake)
		gv.get_tooltip().wake_up()


func start_idle() -> void:
	if lored.reason_cannot_work == LORED.ReasonCannotWork.UNKNOWN:
		set_status_and_currency("", lored.primary_currency)
	animation.sleep()


func go_to_sleep() -> void:
	set_status_and_currency("[wave amp=20 freq=1]Sleeping.", lored.primary_currency)
	animation.sleep()
	if spewing_sleep_text:
		return
	spewing_sleep_text = true
	await get_tree().create_timer(randf_range(3, 6)).timeout
	while lored.asleep:
		gv.throw_text(
			output_texts, 
			{
				"text": sleep_text_pool[randi() % len(sleep_text_pool)],
				"color": lored.color,
			}
		)
		await get_tree().create_timer(randf_range(3, 6)).timeout
	spewing_sleep_text = false


func emote(_emote: Emote) -> void:
	var emote_vico = em.emote_vico.instantiate() as EmoteVico
	emote_vico.setup(_emote)
	emote_container.add_child(emote_vico)
