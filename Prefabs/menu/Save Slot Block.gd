extends MarginContainer


onready var actions = get_node("v/actions")

func _ready() -> void:
	get_node("v/m/select").show()



func hideActions():
	actions.hide()

func _on_select_pressed() -> void:
	if actions.visible:
		hideActions()
		return
	
	actions.show()
