extends MarginContainer



@onready var background = %Background
@onready var icon = %Icon
@onready var label = %Label
@onready var timer = $Timer



func _ready():
	hide()
	SaveManager.save_color_changed.connect(update_colors)
	SaveManager.save_finished.connect(saved)
	gv.one_second.connect(check_if_save_is_imminent)
	timer.timeout.connect(timer_timeout)



func update_colors(val: Color) -> void:
	background.modulate = val
	icon.modulate = val



func check_if_save_is_imminent() -> void:
	if not visible:
		if SaveManager.get_time_since_last_save() >= 27:
			go()



func go() -> void:
	set_process(true)
	show()


func _process(_delta):
	label.text = "[i]Saving in %s..." % Big.get_float_text(ceil(30 - SaveManager.get_time_since_last_save()))


func saved() -> void:
	show()
	set_process(false)
	label.text = "[center][i]Saved!"
	timer.stop()
	timer.start()
	
	if Engine.get_frames_per_second() >= 60:
		var text = FlyingText.new(
			FlyingText.Type.JUST_TEXT,
			self,
			self,
			[0, 0],
		)
		text.add({
			"color": SaveManager.save_file_color,
			"text": "Saved!",
		})
		text.go()


func timer_timeout() -> void:
	hide()

