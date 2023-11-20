extends Node



var buffs := {} # object: {buff_type: Buff}



func _ready():
	SaveManager.loading.became_true.connect(free_all_buffs) # cannot be buffs.clear



# - Action


func apply_buff_on_lored(lored: LORED, buff_type: int) -> void:
	if object_has_specific_buff(lored, buff_type):
		var buff = get_buff(lored, buff_type)
		if buff.stacks.equal(buff.get_stack_limit()):
			buff.refresh()
		else:
			buff.add_stacks(1)
	else:
		store_buff(lored, LOREDBuff.new(buff_type, lored))


func remove_buff_from_lored(lored: LORED, buff_type: int) -> void:
	if object_has_specific_buff(lored, buff_type):
		get_buff(lored, buff_type).remove()


func apply_buff_on_unit(unit: Unit, buff_type: UnitBuff.Type) -> void:
	if object_has_specific_buff(unit, buff_type):
		var buff = get_buff(unit, buff_type)
		if buff.stacks.equal(buff.get_stack_limit()):
			buff.refresh()
		else:
			buff.add_stacks(1)
	else:
		store_buff(unit, UnitBuff.new(buff_type, unit))


func remove_buff_from_unit(unit: Unit, buff_type: int) -> void:
	if object_has_specific_buff(unit, buff_type):
		get_buff(unit, buff_type).remove()


func store_buff(object, buff: Buff) -> void:
	if not object in buffs:
		buffs[object] = {}
	buffs[object][buff.type] = buff
	if object is LORED:
		object.receive_buff()
		if object.purchased.is_true():
			buff.start()
	elif object is Unit:
		buff.start()
		object.received_buff.emit(buff)
	else:
		buff.start()


func free_buff(_buff: Buff) -> void:
	buffs[_buff.object].erase(_buff.type)
	if buffs[_buff.object].is_empty():
		buffs.erase(_buff.object)


func free_all_buffs() -> void:
	buffs.clear()



# - Get


func get_buff(object, buff_type: int) -> Buff:
	return buffs[object][buff_type]


func get_buffs(object) -> Array:
	return buffs[object].values()


func object_has_specific_buff(object, buff_type: int) -> bool:
	if not object_has_buff(object):
		return false
	return buff_type in buffs[object].keys()


func object_has_buff(object) -> bool:
	return object in buffs.keys()
