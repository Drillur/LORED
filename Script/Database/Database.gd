class_name Database
extends Node



var upgrade: Dictionary



func _ready():
	var file = FileAccess.open("res://Script/Database/LORED Database.json", FileAccess.READ)
	var text = file.get_as_text()
	var json = JSON.new()
	var err = json.parse(text)
	if err != OK:
		printerr("Database load failure. Report it to Drillur. He will cry for a bit about it and then fix it later. Error code: ", err)
		return
	
	var data = json.data
	
	upgrade = data.Upgrade
