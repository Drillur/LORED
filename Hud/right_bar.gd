class_name RightBar
extends MarginContainer



enum Tabs { LORED, }

@onready var background = %Background
@onready var title_button = %"Title Button"
@onready var title_background = %"Title Background"
@onready var scroll = %Scroll
@onready var tabs = %Tabs
@onready var tooltip_parent = $Control/LeftDown

# - LORED

@onready var lored_content = %"LORED Content"
@onready var lored_animation = %"LORED Animation"
@onready var status = %Status
@onready var current_progress_text = %"Current Progress Text"
@onready var total_progres_text = %"Total Progres Text"
@onready var progress_bar = %"Progress Bar"
@onready var lored_progress = %Progress
@onready var lored_primary_currency = %"LORED Primary Currency"
@onready var lored_fuel_currency = %"LORED Fuel Currency"
@onready var lored_fuel_currency_container = %"LORED Fuel Currency Container"
@onready var lored_primary_currency_button = %LOREDPrimaryCurrencyButton
@onready var lored_fuel_currency_button = %LOREDFuelCurrencyButton
@onready var lored_jobs = %"LORED Jobs"

@onready var fuel = %Fuel
@onready var current_fuel_text = %"Current Fuel Text"
@onready var total_fuel_text = %"Total Fuel Text"
@onready var fuel_bar = %"Fuel Bar"

@onready var level_up = %"Level Up"
@onready var sleep = %Sleep
@onready var autobuyer = %Autobuyer
@onready var lored_affordable_check = %"LORED Affordable Check"
@onready var lored_level = %"LORED Level"
@onready var lored_level_2 = %"Lored level 2"
@onready var lored_output = %"LORED output"
@onready var lored_input = %"LORED input"
@onready var lored_haste = %"LORED haste"
@onready var lored_crit = %"LORED crit"
@onready var lored_fuel_cost = %"LORED fuel cost"

var lored: LORED

var color: Color:
	set(val):
		color = val
		background.modulate = val
		title_background.modulate = val
		match tabs.current_tab:
			Tabs.LORED:
				progress_bar.color = lored.details.color
				fuel_bar.color = wa.get_color(lored.fuel_currency)
				lored_animation.modulate = lored.details.alt_color
				lored_primary_currency_button.modulate = lored.details.color
				lored_fuel_currency_button.modulate = fuel_bar.color
				scroll.get_v_scroll_bar().modulate = lored.details.color
				level_up.color = lored.details.color
				sleep.color = lored.details.color
				autobuyer.modulate = lored.details.color
				lored_affordable_check.modulate = lored.details.color



func _ready():
	hide()
	get_tree().root.size_changed.connect(window_resized)
	set_process(false)
	
	# - LORED
	autobuyer.play("default")
	visibility_changed.connect(_on_visibility_changed)
	title_button.pressed.connect(clear)
	lored_primary_currency_button.pressed.connect(lored_primary_currency_pressed)
	lored_fuel_currency_button.pressed.connect(lored_fuel_currency_pressed)
	level_up.mouse_entered.connect(show_level_up_tooltip)
	level_up.mouse_exited.connect(gv.clear_tooltip)
	sleep.mouse_entered.connect(show_sleep_tooltip)
	sleep.mouse_exited.connect(gv.clear_tooltip)
	level_up.pressed.connect(purchase_level_up)
	sleep.pressed.connect(sleep_clicked)
	
	call_deferred("window_resized")



func _process(_delta):
	match tabs.current_tab:
		Tabs.LORED:
			if lored.working.is_true():
				current_progress_text.text = str(lored.last_job.timer.wait_time - lored.last_job.timer.time_left).pad_decimals(2)




# - Action


func clear() -> void:
	set_process(false)
	call("clear_" + Tabs.keys()[tabs.current_tab].to_lower())
	hide()


func go() -> void:
	set_process(true)
	show()



# - LORED


func clear_lored() -> void:
	disconnect_calls_lored()
	for node in lored_jobs.get_children():
		node.queue_free()
	lored = null


func setup_lored(_lored: LORED):
	if _lored == lored:
		clear()
		return
	elif lored != null:
		clear_lored()
	tabs.current_tab = Tabs.LORED
	lored = _lored
	
	color = lored.details.color
	title_button.text = "%s\n[i]%s" % [lored.details.name, lored.details.alt_name]
	
	connect_calls_lored()
	
	lored_status_changed()
	if lored.working.is_true():
		lored_job_changed()
		progress_bar.attach_timer(lored.last_job.timer)
	else:
		lored_progress.hide()
	lored_primary_currency.setup(lored.primary_currency)
	if lored.fuel_currency == lored.primary_currency:
		lored_fuel_currency_container.hide()
	else:
		lored_fuel_currency.setup(lored.fuel_currency)
		lored_fuel_currency_container.show()
	
	lored_current_fuel_changed()
	lored_total_fuel_changed()
	lored_fuel_changed()
	fuel_bar.attach_attribute(lored.fuel)
	lored_frames_changed()
	lored_frame_changed()
	lored_animation_changed()
	lored_autobuy_changed()
	lored_affordable_changed()
	lored_level_changed()
	lored_output_changed()
	lored_input_changed()
	lored_haste_changed()
	lored_crit_changed()
	lored_fuel_cost_changed()
	
	for job in lored.sorted_jobs:
		var x = res.get_resource("lored_job").instantiate()
		x.setup(lored.jobs[job])
		lored_jobs.add_child(x)
	
	go()


func connect_calls_lored() -> void:
	lored.status.changed.connect(lored_status_changed)
	lored.job_started.connect(lored_job_changed)
	lored.fuel.current.changed.connect(lored_current_fuel_changed)
	lored.fuel.total.changed.connect(lored_total_fuel_changed)
	lored.fuel.changed.connect(lored_fuel_changed)
	lored.vico.animation.frame_changed.connect(lored_frame_changed)
	lored.vico.animation.sprite_frames_changed.connect(lored_frames_changed)
	lored.vico.animation.animation_changed.connect(lored_animation_changed)
	lored.became_unable_to_work.connect(hide_lored_progress)
	lored.asleep.became_true.connect(hide_lored_progress)
	lored.autobuy.changed.connect(lored_autobuy_changed)
	lored.cost.affordable.changed.connect(lored_affordable_changed)
	lored.level.changed.connect(lored_level_changed)
	lored.output.changed.connect(lored_output_changed)
	lored.input.changed.connect(lored_input_changed)
	lored.haste.changed.connect(lored_haste_changed)
	lored.crit.changed.connect(lored_crit_changed)
	lored.fuel_cost.changed.connect(lored_fuel_cost_changed)



func disconnect_calls_lored() -> void:
	lored.status.changed.disconnect(lored_status_changed)
	lored.job_started.disconnect(lored_job_changed)
	lored.fuel.current.changed.disconnect(lored_current_fuel_changed)
	lored.fuel.total.changed.disconnect(lored_total_fuel_changed)
	lored.fuel.changed.disconnect(lored_fuel_changed)
	lored.vico.animation.frame_changed.disconnect(lored_frame_changed)
	lored.vico.animation.sprite_frames_changed.disconnect(lored_frames_changed)
	lored.vico.animation.animation_changed.disconnect(lored_animation_changed)
	lored.became_unable_to_work.disconnect(hide_lored_progress)
	lored.asleep.became_true.disconnect(hide_lored_progress)
	lored.autobuy.changed.disconnect(lored_autobuy_changed)
	lored.cost.affordable.changed.disconnect(lored_affordable_changed)
	lored.level.changed.disconnect(lored_level_changed)
	lored.output.changed.disconnect(lored_output_changed)
	lored.input.changed.disconnect(lored_input_changed)
	lored.haste.changed.disconnect(lored_haste_changed)
	lored.crit.changed.disconnect(lored_crit_changed)
	lored.fuel_cost.changed.disconnect(lored_fuel_cost_changed)


func lored_status_changed() -> void:
	status.text = "[i]%s[/i]" % lored.status.get_value()


func lored_job_changed() -> void:
	lored_progress.show()
	progress_bar.attach_timer(lored.last_job.timer)
	total_progres_text.text = str(lored.last_job.timer.wait_time).pad_decimals(2)


func lored_current_fuel_changed() -> void:
	current_fuel_text.text = lored.fuel.get_current_text()


func lored_total_fuel_changed() -> void:
	total_fuel_text.text = lored.fuel.get_total_text()


func lored_fuel_changed() -> void:
	fuel.text = "Fuel (%s) - %s" % [
		wa.get_currency(lored.fuel_currency).details.icon_and_name_text,
		str(snappedf(lored.fuel.get_current_percent(), 0.01) * 100).pad_zeros(1) + "%"
	]


func hide_lored_progress() -> void:
	lored_progress.hide()


func lored_frames_changed() -> void:
	lored_animation.sprite_frames = lored.vico.animation.sprite_frames
	lored_animation.scale = Vector2i(4, 4) if lored.vico.animation.animation_key in lv.SMALLER_ANIMATIONS else Vector2i(1, 1)


func lored_frame_changed() -> void:
	lored_animation.frame = lored.vico.animation.frame


func lored_animation_changed() -> void:
	lored_animation.animation = lored.vico.animation.animation


func lored_primary_currency_pressed() -> void:
	wa.open_wallet_to_currency(lored.primary_currency)
	clear()


func lored_fuel_currency_pressed() -> void:
	wa.open_wallet_to_currency(lored.fuel_currency)
	clear()


func lored_autobuy_changed() -> void:
	autobuyer.visible = lored.autobuy.get_value()


func lored_affordable_changed() -> void:
	lored_affordable_check.visible = lored.cost.affordable.get_value()


func lored_level_changed() -> void:
	lored_level.text = "Level [b]%s" % lored.get_level_text()
	lored_level_2.text = "[center]" + lored.get_level_text()


func lored_output_changed() -> void:
	lored_output.text = "Output: [b]%s[/b]" % lored.get_output_text()


func lored_input_changed() -> void:
	lored_input.text = "Input: [b]%s[/b]" % lored.get_input_text()


func lored_haste_changed() -> void:
	lored_haste.text = "Haste: [b]%s[/b]" % lored.get_haste_text()


func lored_crit_changed() -> void:
	lored_crit.text = "Crit Chance: [b]%s" % lored.get_crit_text() + "%"


func lored_fuel_cost_changed() -> void:
	lored_fuel_cost.text = "%s cost: [b]%s[/b]" % [
		wa.get_currency(lored.fuel_currency).details.icon_and_name_text,
		lored.fuel_cost.get_text() + "/s"
	]


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


func show_level_up_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_LEVEL_UP, tooltip_parent, {"lored": lored.type})


func show_sleep_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.LORED_SLEEP, tooltip_parent, {"lored": lored.type})



# - Get


func get_content_height() -> int:
	match tabs.current_tab:
		Tabs.LORED:
			return lored_content.size.y
		_:
			return 0


# - Signals


func _on_visibility_changed():
	if visible:
		scroll.scroll_vertical = 0


func window_resized() -> void:
	scroll.custom_minimum_size.y = min(get_content_height(), gv.menu_container_size)
