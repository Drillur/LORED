class_name BuffManager
extends Node


var timers := {}

func applyBuff(buff_index: int, caster: Unit, target: Unit):
	
	var data: Dictionary = caster.getData()
	
	if buff_index in target.buffs.keys():
		
		target.buffs[buff_index].increaseStacks(1) # increases stacks and damage
		target.buffs[buff_index].setViaData(data) # adjusts all other stats based on current caster data
		target.buffs[buff_index].refresh()
		
		if target == gv.warlock:
			var duration: float = target.buffs[buff_index].getDumbDuration() + timers[target.buffs[buff_index]].time_left
			gv.emit_signal("buff_renewed", target.buffs[buff_index].type, duration)
			
	
	else:
		
		var buff = Buff.new(buff_index, data)
		
		target.takeBuff(buff)
		
		if target == gv.warlock:
			var _data := {
				"type": buff.type,
				"icon": buff.getIcon(),
				"border color": buff.getBorderColor(),
				"duration": buff.getDuration(),
			}
			gv.emit_signal("buff_applied", _data)
			print("applied")
		
		processBuff(buff, target)

func processBuff(buff: Buff, target: Unit):
	
	timers[buff] = Timer.new()
	add_child(timers[buff])
	
	while buff.ticks > 0 and not buff.debuffed:
		
		timers[buff].start(buff.tick_rate)
		yield(timers[buff], "timeout")
		
		for x in buff.order:
			match x:
				Cav.AbilityAction.DEAL_DAMAGE:
					target.takeDamage(buff.damage.dmg, buff.damage.type, buff.triggers_nr)
				Cav.AbilityAction.RESTORE_MANA:
					target.takeManaRestoration(buff.getRestoreMana())
		
		buff.ticks -= 1
	
	timers[buff].queue_free()
	timers.erase(buff)
	print("buff faded")
	removeBuff(buff, target)

func removeBuff(buff: Buff, target: Unit):
	target.loseBuff(buff)
