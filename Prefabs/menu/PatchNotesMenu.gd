extends MarginContainer


func _ready() -> void:
	for version in gv.PATCH_NOTES:
		var entry = gv.SRC["PatchEntry"].instance()
		entry.setup(version)
		get_node("%entries").add_child(entry)
	
	get_node("%version").text = ProjectSettings.get_setting("application/config/Version")
