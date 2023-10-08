extends Node



var buffs := {} # object: {buff_type: Buff}



# - Action

func apply_buff_on_lored(lored: LORED, buff_type: int) -> void:
	if object_has_buff(lored, buff_type):
		var buff = get_buff(lored, buff_type)
		if buff.stacks.equal(buff.get_stack_limit()):
			buff.refresh()
		else:
			buff.add_stacks(1)
	else:
		store_buff(lored, LOREDBuff.new(buff_type, lored))


func store_buff(object, buff: Buff) -> void:
	if not object in buffs:
		buffs[object] = {}
	buffs[object][buff.type] = buff
	buff.start()


func free_buff(_buff: Buff) -> void:
	buffs[_buff.object].erase(_buff.type)
	if buffs[_buff.object].is_empty():
		buffs.erase(_buff.object)



# - Get


func get_buff(object, buff_type: int) -> Buff:
	return buffs[object][buff_type]


func get_buffs(object) -> Array:
	return buffs[object].values()


func object_has_buff(object, buff_type: int) -> bool:
	if not object in buffs.keys():
		return false
	return buff_type in buffs[object].keys()

