class_name Unit
extends Reference



var type: int # like Class in an RPG

var node: MarginContainer
var node_set := false

var name: String
var desc: String

var level: Big

var gcd: Cav.Cooldown = Cav.Cooldown.new(1.5)
var new_cast := false

var channeling := false
var casting := false
var dead := false

var health: Cav.UnitResource
var barrier: Cav.UnitResource
var stamina: Cav.UnitResource
var mana: Cav.UnitResource
var overwhelming_power: Cav.UnitResource

var intellect: Cav.UnitAttribute

var haste := 1.0
var haste_multiplier := 1.0

var resist: Cav.UnitResistances = Cav.UnitResistances.new()

var outgoing_damage_multiplier := 1.0

var damage_dealt: Big # used by Core Crystal unit


var active_buffs := {}

var nat_types: Array # current active natural reaction damage type
var nat_buffs: Array




func _init(_type: int) -> void:
	
	type = _type
	call("construct_" + Cav.UnitClass.keys()[type])
	
	setRegenReset()
	
	sync()

func setRegenReset():
	
	if type == Cav.UnitClass.CORE_CRYSTAL:
		return
	
	health.regen_rest = 1.0
	barrier.regen_rest = 3.0
	stamina.regen_rest = 0.5
	mana.regen_rest = 1.5

func construct_WARLOCK():
	
	name = "Warlock"
	desc = "Is mega awesome."
	
	health = Cav.UnitResource.new(30)
	barrier = Cav.UnitResource.new(70)
	stamina = Cav.UnitResource.new(25)
	mana = Cav.UnitResource.new(10)
	overwhelming_power = Cav.UnitResource.new(100)
	
	health.setBaseRegen(0.001)
	barrier.setBaseRegen(0.01)
	stamina.setBaseRegen(0.1)
	mana.setBaseRegen(0.01)
	
	intellect = Cav.UnitAttribute.new(2)

func construct_ARCANE_LORED():
	
	name = "Arcane"
	desc = "Is a nerd. Reads books."
	
	health = Cav.UnitResource.new(10)
	barrier = Cav.UnitResource.new(0)
	stamina = Cav.UnitResource.new(10)
	mana = Cav.UnitResource.new(0)
	
	intellect = Cav.UnitAttribute.new(1)

func construct_WISP():
	
	name = "Wisp"
	desc = "Whisp's."
	
	health = Cav.UnitResource.new(3)
	barrier = Cav.UnitResource.new(40)
	stamina = Cav.UnitResource.new(25)
	mana = Cav.UnitResource.new(10)
	
	health.setRegen(0.0001)
	barrier.setRegen(0.01)
	stamina.setRegen(0.1)
	mana.setRegen(0.01)
	
	intellect = Cav.UnitAttribute.new(1)

func construct_CORE_CRYSTAL():
	name = "Core Crystal"
	desc = "The core Mana Crystal that sustains the entire Void."
	damage_dealt = Big.new(0)
	intellect = Cav.UnitAttribute.new(1)


























func sync():
	
	if type == Cav.UnitClass.CORE_CRYSTAL:
		return
	
	intellect.sync()
	
	mana.add_from_intellect = Big.new(intellect.total)
	mana.sync()
	
	gcd.m_from_haste = getHaste()
	gcd.sync()







func updateVisualComponents():
	health.update()
	barrier.update()
	stamina.update()
	mana.update()








func setNode(_node: MarginContainer):
	node = _node
	node_set = true

func getDamageMultiplier() -> Big:
	return Big.new(intellect.total.m(outgoing_damage_multiplier))

func getIntellect() -> Big:
	return Big.new(intellect.total)

func getHaste() -> float:
	return haste * haste_multiplier


func getData() -> Dictionary:
	
	var data := {}
	
	data["intellect"] = intellect.total
	data["haste"] = getHaste()
	data["damage multiplier"] = getDamageMultiplier()
	
	return data



func stopCast():
	casting = false
	channeling = false


#func takeBuff(_buff: Buff):
#
#	buffs[_buff.type] = _buff
#
#	if _buff.affects_target_damage_dealt: #note outgoing dmg mult no longer works
#		outgoing_damage_multiplier *= _buff.target_damage_dealt_multiplier
#
#	if self == gv.warlock:
#		gv.emit_signal("buff_applied", _buff)

func takeHealing(val: Big):
	health.current = Big.new(health.current).a(val)

func takeManaRestoration(_val: Big):
	var val = Big.new(_val)
	if self == gv.warlock:
		if true: #note1 replace with bool that shows player has unlocked the Arcane Recall passive
			if Big.new(val).a(mana.current).greater(mana.total):
				if mana.current.equal(mana.total):
					pass
				else:
					val.s(Big.new(mana.total).s(mana.current))
					mana.current = Big.new(mana.total)
					gv.emit_signal("mana_restored", val, false)
				var surplus = Big.new(val).m(0.01)
				gv.emit_signal("mana_restored", surplus, true)
				gv.r["mana"].a(surplus)
				return
	
	mana.current = Big.new(mana.current).a(val)
	if self == gv.warlock:
		gv.emit_signal("mana_restored", val, false)

func takeDamage(vals: Array, types: Array, triggers_nr := true):
	
	if self == gv.warlock:
		triggers_nr = false
	
#	if triggers_nr:
#		react_naturally(types)
	
	interpretIncomingDamage(vals, types)
	
	var damage = getMergedValues(vals)
	
	if type == Cav.UnitClass.CORE_CRYSTAL:
		damage_dealt.a(damage)
	else:
		
		if barrierPresent():
			takeBarrierDamage(damage)
		else:
			takeHealthDamage(damage)

func takeBarrierDamage(damage: Big):
	if barrier.current.greater_equal(damage):
		barrier.current = Big.new(barrier.current).s(damage)
		um.spentResource(barrier)
	else:
		damage.s(barrier.current)
		barrier.current = Big.new(0)
		takeHealthDamage(damage)
func takeHealthDamage(damage: Big):
	health.current = Big.new(health.current).s(damage)
	if health.current.equal(0):
		die()
		return
	um.spentResource(health)

func getMergedValues(vals: Array) -> Big:
	var poop = Big.new(0)
	for v in vals:
		poop.a(v)
	return poop

func barrierPresent() -> bool:
	return barrier.current.greater(0)

#func react_naturally(types: Array):
#
#	# apply new buffs
#	for t in types:
#		bm.spellCast(gv.warlock, self, gv.damageTypeToNR(t))
#
#	return
#	# remove old buffs, clear trackers
#	for b in nat_types.size():
#		nat_buffs[b].debuff()
#	nat_types.clear()
#	nat_buffs.clear()
#
#	# set up trackers
#	for t in types:
#		nat_types.append(t)
#		nat_buffs.append(buffs[gv.damageTypeToNR(t)])
#
#	if nat_types.size() == 0:
#
#		return
#	return
#	var nr := []
#	var culm := []
	
	# first, increase stacks of active NR buffs
	# store 
	
	
#	for t in types:
#		if nat_type == -1:
#			pass
#		if t == nat_type:
#			nat_buff.increaseStacks(1)
#			nat_buff.refresh()
#			bm.processBuff(nat_buff, self)
#		if t != nat_type:
#			culm.append(t)
#			# example: Cav.DamageType.FIRE
	
	
		

func culminate(types: Array):
	pass




func saveBuffReference(buff: Buff):
	active_buffs[buff.type] = buff

func deleteBuffReference(buff_type: int):
	active_buffs.erase(buff_type)


func loseBuff(_buff: Buff):
	
	if _buff.affects_target_damage_dealt:
		outgoing_damage_multiplier /= _buff.target_damage_dealt_multiplier
		if gv.xIsNearlyY(outgoing_damage_multiplier, 1.0):
			outgoing_damage_multiplier = 1.0



func interpretIncomingDamage(_dmg: Array, _type: Array):
	for d in _dmg.size():
		_dmg[d] = resist.interpretIncomingDamage(_dmg[d], _type[d])




func cast(_spell: int, target: Unit):
	
	if not gcd.isAvailable():
		return
	
	var spell = Cav.spell[_spell]
	
	if not spell.canCast(self):
		return
	
	if channeling:
		stopCast()
		new_cast = true
	
	spell.cast(self, target)
	
	um.gcd(self, gcd.total)
	
	if spell.costs_mana:
		um.spentResource(mana)
	if spell.costs_stamina:
		um.spentResource(stamina)




func clearBuffs():
	for b in active_buffs:
		active_buffs[b].stop()

func die():
	
	node_set = false
	dead = true
	node.die()
