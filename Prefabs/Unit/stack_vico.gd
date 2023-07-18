extends Label



var stacks: Attribute



func setup(_stacks: Attribute) -> void:
	stacks = _stacks
	stacks.assign_vico(self)


func unassign_vico() -> void:
	stacks.unassign_vico()



func update() -> void:
	if stacks.get_current().greater(1):
		show()
		text = stacks.get_current_text() + "x"
	else:
		hide()
