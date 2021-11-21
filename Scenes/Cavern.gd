extends Node2D




onready var hotbar = get_node("m/bot/v/hotbar")



func save() -> String:
	
	var data := {}
	
	data["hotbar"] = hotbar.save()
	
	return var2str(data)

func load(raw_data: String):
	
	var data = str2var(raw_data)
	
	if "hotbar" in data.keys():
		hotbar.load(data["hotbar"])



func setup():
	hotbar.setup()


find a way to attach the Unit.gd script to this node. health bars should be set as gv.warlock's health.vc

func _on_Button_pressed() -> void:
	pass # Replace with function body.
