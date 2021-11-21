class_name BuffManager
extends Node



func applyBuff(buff_index: int, caster: Unit, target: Unit):
	
	var data := {}
	
	data["haste"] = caster.getHaste()
	data["damage multiplier"] = caster.getDamageMultiplier()
	
	if buff_index in target.buffs.keys():
		
		target.buffs[buff_index].increaseStacks(1) # increases stacks and damage
		target.buffs[buff_index].refresh()
		target.buffs[buff_index].setViaData(data) # adjusts all other stats based on current caster data
	
	else:
		
		var buff = Buff.new(buff_index, data)
		
		target.takeBuff(buff)
		
		processBuff(buff, target)

func processBuff(buff: Buff, target: Unit):
	
	var t = Timer.new()
	add_child(t)
	
	while buff.ticks > 0 and not buff.debuffed:
		t.start(buff.tick_rate)
		yield(t, "timeout")
		
		for x in buff.order:
			match x:
				Cav.AbilityAction.DEAL_DAMAGE:
					target.takeDamage(buff.damage.dmg, buff.damage.type, buff.triggers_nr)
		
		buff.ticks -= 1
	
	t.queue_free()
	removeBuff(buff, target)

func removeBuff(buff: Buff, target: Unit):
	target.loseBuff(buff)
