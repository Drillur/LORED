extends Node



enum Type {
	WITCH,
}

var queued_buffs: Array

signal update_description(lored, buff_type)



func apply_buff(buff_type: int, target_lored: int, optional_commands := {}):
	
	if not lv.lored[target_lored].purchased:
		return
	
	var new_buff = Buff.new(buff_type, target_lored)
	
	new_buff.unique_init_command(optional_commands)
	
#	if has_method("setup_buff_" + new_buff.key):
#		call("setup_buff_" + new_buff.key)
	
	lv.lored[target_lored].apply_buff(new_buff)



func queue_apply_buff(buff_type: int, target_lored: int, optional_commands := {}):
	queued_buffs.append({"buff_type": buff_type, "target_lored": target_lored, "optional_commands": optional_commands})


func apply_queued_buffs():
	for queued_buff in queued_buffs:
		apply_buff(queued_buff["buff_type"], queued_buff["target_lored"], queued_buff["optional_commands"])
	clear_queued_buffs()


func clear_queued_buffs():
	queued_buffs.clear()
