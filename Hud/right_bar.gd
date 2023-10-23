class_name RightBar
extends MarginContainer



enum Tabs { LORED, }

@onready var background = %Background
@onready var title_button = %"Title Button"
@onready var title_background = %"Title Background"
@onready var scroll = %Scroll
@onready var tabs = %Tabs

# - LORED

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

@onready var fuel = %Fuel
@onready var current_fuel_text = %"Current Fuel Text"
@onready var total_fuel_text = %"Total Fuel Text"
@onready var fuel_bar = %"Fuel Bar"

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



func _ready():
	set_process(false)
	hide()
	visibility_changed.connect(_on_visibility_changed)
	title_button.pressed.connect(clear)
	lored_primary_currency_button.pressed.connect(lored_primary_currency_pressed)
	lored_fuel_currency_button.pressed.connect(lored_fuel_currency_pressed)



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
	lored.became_unable_to_work.connect(lored_became_unable_to_work)


func disconnect_calls_lored() -> void:
	lored.status.changed.disconnect(lored_status_changed)
	lored.job_started.disconnect(lored_job_changed)
	lored.fuel.current.changed.disconnect(lored_current_fuel_changed)
	lored.fuel.total.changed.disconnect(lored_total_fuel_changed)
	lored.fuel.changed.disconnect(lored_fuel_changed)
	lored.vico.animation.frame_changed.disconnect(lored_frame_changed)
	lored.vico.animation.sprite_frames_changed.disconnect(lored_frames_changed)
	lored.vico.animation.animation_changed.disconnect(lored_animation_changed)
	lored.became_unable_to_work.disconnect(lored_became_unable_to_work)


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
		wa.get_currency(lored.fuel_currency).details.colored_name,
		str(round(lored.fuel.get_current_percent()) * 100).pad_zeros(1) + "%"
	]


func lored_became_unable_to_work() -> void:
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



# - Signals


func _on_visibility_changed():
	if visible:
		scroll.scroll_vertical = 0

