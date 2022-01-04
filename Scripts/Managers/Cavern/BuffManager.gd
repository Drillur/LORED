class_name BuffManager
extends Node

var timers := {}



#1: spell is cast
#2: spell does its own effects
#3: spell applies buff
#	1: create buff using caster attributes
#		1: save reference to buff in dict in BuffManager. the key is an array with 2 values: [target, buff type]. the value is the buff
#			1: to access, use "buffDict[[target, buff_type]]"
#	2: apply to target
#		1: save reference to buff in dict in the targets "active_buffs" var. key: buff type. value: buff
#			1: to access, use "active_buffs[buff_type]"
#	3: create buff vico
#	4: process buff, allow it to tick()
#		1: create timer
#			1: save reference to timer using the same key as the buff
#				1: to access, use "timers[[target, buff_type]]"
#	5: allow easy removal or refresh of buff
#	6: remove from target
#		1: remove reference to buff from BuffManager dict and from targets active_buffs dict.

var active_buffs := {}
var buff_vicos := {}

func spellCast(caster: Unit, target: Unit, buff_type: int):
	
	if buffExists(target, buff_type):
		refreshBuff(caster, target, active_buffs[[target, buff_type]])
	else:
		newBuffApplication(caster, buff_type, target)

func buffExists(target, buff_type) -> bool:
	return [target, buff_type] in active_buffs.keys()


func newBuffApplication(caster: Unit, buff_type: int, target: Unit):
	
	var buff = createBuff(caster, buff_type)
	
	saveBuffReferences(buff, target)
	createBuffVico(target, buff)
	
	processBuff(buff, target)

func createBuff(caster: Unit, type: int) -> Buff:
	var data = caster.getData()
	var buff = Buff.new(type, data)
	return buff

func saveBuffReferences(buff: Buff, target: Unit):
	active_buffs[[target, buff.type]] = buff
	target.saveBuffReference(buff)

func createBuffVico(target: Unit, buff: Buff):
	
	if target != gv.warlock:
		return
	
	var data = getBuffVicoData(buff)
	sendDataToCavernToCreateVico(target, data)

func createBuffVicoReference(target: Unit, type: int, vico: MarginContainer):
	# called from #zBuffApplied
	buff_vicos[[target, type]] = vico
	active_buffs[[target, type]].saveVicoReference(vico)

func getBuffVicoData(buff: Buff) -> Dictionary:
	return {
		"type": buff.type,
		"icon": buff.getIcon(),
		"border color": buff.getBorderColor(),
		"max ticks": buff.getMaxTicks(),
	}

func sendDataToCavernToCreateVico(target: Unit, data: Dictionary):
	# see: #zBuffApplied
	gv.emit_signal("buff_applied", target, data)


func refreshBuff(caster: Unit, target: Unit, buff: Buff):
	buff.refresh(caster.getData())
	buff.increaseStacks(1)
	buff.resetTicks()
	buff_vicos[[target, buff.type]].updateMaxTicks(buff.getMaxTicks())
	updateBuffVico(target, buff)



func processBuff(buff: Buff, target: Unit):
	
	createTimer(target, buff.type)
	var timer = timers[[target, buff.type]]
	
	while buff.ticks > 0:
		
		if buffIsStopped(buff):
			break
		
		timer.start(buff.tick_rate)
		yield(timer, "timeout")
		
		if buffIsStopped(buff):
			break
		
		buffTick(buff, target)
		updateBuffVico(target, buff)
	
	cleanUp(buff, target)

func buffTick(buff: Buff, target: Unit):
	
	for x in buff.order:
		match x:
			Cav.AbilityAction.DEAL_DAMAGE:
				target.takeDamage(buff.damage.dmg, buff.damage.type, buff.triggers_nr)
			Cav.AbilityAction.RESTORE_MANA:
				target.takeManaRestoration(buff.getRestoreMana())
	
	buff.ticks -= 1

func updateBuffVico(target: Unit, buff: Buff):
	if not [target, buff.type] in buff_vicos:
		return
	buff_vicos[[target, buff.type]]._update(buff.ticks)


func createTimer(target: Unit, buff_type: int):
	timers[[target, buff_type]] = Timer.new()
	add_child(timers[[target, buff_type]])

func buffIsStopped(buff: Buff) -> bool:
	return buff.stopped or buff.debuffed


func cleanUp(buff: Buff, target: Unit):
	
	cleanUpBuffVico(target, buff.type)
	killTimer(target, buff.type)
	deleteBuffReferences(target, buff.type)
	
	target.loseBuff(buff)

func killTimer(target: Unit, buff_type: int):
	timers[[target, buff_type]].queue_free()
	timers.erase([target, buff_type])

func deleteBuffReferences(target: Unit, buff_type: int):
	active_buffs.erase([target, buff_type])
	target.deleteBuffReference(buff_type)

func cleanUpBuffVico(target: Unit, type: int):
	if not [target, type] in buff_vicos.keys():
		return
	buff_vicos[[target, type]].clear()
	buff_vicos.erase([target, type])










func removeBuff(buff: Buff, target: Unit):
	target.loseBuff(buff)
