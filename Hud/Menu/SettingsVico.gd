extends MarginContainer



# VIDEO

@onready var fullscreen = %Fullscreen



func load_finished() -> void:
	# VIDEO
	fullscreen.button_pressed = Settings.fullscreen.get_value()



func _ready():
	SaveManager.load_finished.connect(load_finished)


func _input(_event):
	if Input.is_action_just_pressed("Fullscreen"):
		fullscreen.button_pressed = not fullscreen.button_pressed


# - Signals


func _on_fullscreen_toggled(button_pressed):
	Settings.fullscreen.set_to(button_pressed)
