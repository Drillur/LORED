extends MarginContainer


const gn_version = "h/version"
onready var changes = get_node("h/changes")


func setup(version: String):
	
	yield(self, "ready")
	
	get_node(gn_version).text = version
	
	for x in gv.PATCH_NOTES[version]:
		
		var poop = gv.SRC["label"].instance()
		poop.text = "- " + x
		changes.add_child(poop)
