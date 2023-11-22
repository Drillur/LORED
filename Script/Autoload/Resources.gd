extends Node



var bag := ResourcePreloader.new()
var chats := {}



func _ready():
	store_all_resources()



func store_all_resources() -> void:
	dir_contents("res://Hud/")
	dir_contents("res://Sprites/")
	dir_contents("res://Script/Dialogues/")


func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		if file_name in ["animations", "Terrain"]:
			file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				dir_contents(path + "/" + file_name)
			else:
				if (
					file_name.ends_with(".png")
					or file_name.ends_with(".svg")
					or file_name.ends_with(".tscn")
					or file_name.ends_with(".dialogue")
				):
					var _name := file_name.split(".")[0]
					var _path = path + "/" + file_name
					if bag.has_resource(_name):
						printerr(_name, " already in bag! Change resource name!")
					bag.add_resource(_name, load(_path))
					if file_name.ends_with(".dialogue"):
						chats[_name] = get_resource(_name)
			file_name = dir.get_next()



func get_icon_text(_name: String, size := 15) -> String:
	return "[img=<%s>]%s[/img]" % [str(size), get_resource_path(_name)]


func get_resource(_name: String) -> Resource:
	return bag.get_resource(_name)


func get_resource_path(_name: String) -> String:
	return bag.get_resource(_name).get_path()
