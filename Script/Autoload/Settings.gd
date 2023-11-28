extends Node



const saved_vars := [
	"fullscreen",
]

var fullscreen := LoudBool.new(false)



func _ready() -> void:
	for variable in gv.get_script_variables(get_script()):
		get(variable).changed.connect(get(variable + "_changed"))



func fullscreen_changed() -> void:
	if fullscreen.is_true():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
