extends MarginContainer

onready var list = get_node("%list")

func log(type: int, info: String):
	var entry = gv.SRC["logEntry"].instance()
	entry.setup(type, info)
	list.add_child(entry)
	
	var lastChild = list.get_child_count() - 1
	list.move_child(list.get_child(lastChild), 0)
