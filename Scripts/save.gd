extends Resource
class_name Save



export var lored_data: Dictionary



func write_savegame(save_path, type := "normal") -> void:
	
	save_path = getFormattedPath(save_path)
	
	var error = ResourceSaver.save(save_path, self)


func getFormattedPath(path: String) -> String:
	return path if "user://" in path else "user://" + path



static func load_savegame(path: String) -> Resource:
	return ResourceLoader.load(path, "", true)
