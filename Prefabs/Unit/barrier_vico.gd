extends Panel



var unit: Unit



func setup(_unit: Unit) -> void:
	unit = _unit
	unit.barrier.assign_vico(self)


func unassign_vico() -> void:
	unit.barrier.unassign_vico()



func update() -> void:
	var barrier_percent = unit.barrier.get_current().percent(unit.health.get_total())
	rect_size.x = barrier_percent * get_owner().rect_size.x
