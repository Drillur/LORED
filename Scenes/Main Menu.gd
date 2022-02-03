extends MarginContainer


onready var all_saves := get_node("h/all saves")

var save_blocks := {}


func _ready():
	all_saves.hide()


func hideActions():
	
	for s in save_blocks:
		s.hideActions()


func _on_all_saves_pressed() -> void:
	if all_saves.visible:
		all_saves.hide()
		return
	
	all_saves.show()
