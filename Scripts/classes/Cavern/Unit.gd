class_name Unit
extends Reference



var type: int # like Class in an RPG

var vc: MarginContainer
var vc_set := false

var name: String
var desc: String

var level: Big

var casting := false
var dead := false

var health: Cav.UnitResource
var barrier: Cav.UnitResource
var stamina: Cav.UnitResource
var mana: Cav.UnitResource

var intellect: Cav.UnitAttribute

var haste := 1.0
var haste_multiplier := 1.0

var resist: Cav.UnitResistances = Cav.UnitResistances.new()

var outgoing_damage_multiplier := 1.0

var damage_dealt: Big # used by Core Crystal unit


var buffs := {}

var nat_types: Array # current active natural reaction damage type
var nat_buffs: Array




func _init(_type: int) -> void:
	
	type = _type
	call("construct_" + Cav.UnitClass.keys()[type])
	
	setRegenReset()

func setRegenReset():
	
	if type == Cav.UnitClass.CORE_CRYSTAL:
		return
	
	health.regen_rest = 1.0
	barrier.regen_rest = 3.0
	stamina.regen_rest = 0.5
	mana.regen_rest = 2.0

func construct_WARLOCK():
	
	name = "Warlock"
	desc = "Suddenly is very cool."
	
	health = Cav.UnitResource.new(30)
	barrier = Cav.UnitResource.new(70)
	stamina = Cav.UnitResource.new(25)
	mana = Cav.UnitResource.new(10)
	
	health.setRegen(0.001)
	barrier.setRegen(0.01)
	stamina.setRegen(0.1)
	mana.setRegen(0.01)
	
	intellect = Cav.UnitAttribute.new(2)

func construct_ARCANE_LORED():
	
	name = "Arcane"
	desc = "Is a nerd. Likes reading books."
	
	health = Cav.UnitResource.new(10)
	barrier = Cav.UnitResource.new(0)
	stamina = Cav.UnitResource.new(10)
	mana = Cav.UnitResource.new(0)
	
	mana.regen_rest = 2.0
	
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


























func sync():
	mana.add_from_intellect = Big.new(intellect.total)
	mana.sync()









func setVC(_vc: MarginContainer):
	vc = _vc
	vc_set = true

func getDamageMultiplier() -> Big:
	return Big.new(intellect.total.m(outgoing_damage_multiplier))

func getIntellect() -> Big:
	return Big.new(intellect.total)

func getHaste() -> float:
	return haste * haste_multiplier




func takeBuff(_buff: Buff):
	
	buffs[_buff.type] = _buff
	
	if _buff.affects_target_damage_dealt:
		outgoing_damage_multiplier *= _buff.target_damage_dealt_multiplier

func takeHealing(val: Big):
	health.current = Big.new(health.current).a(val)
func takeManaRestoration(val: Big):
	mana.current = Big.new(mana.current).a(val)

func takeDamage(vals: Array, types: Array, triggers_nr := true):
	
	if self == gv.warlock:
		triggers_nr = false
	
	if triggers_nr:
		react_naturally(types)
	
	interpretIncomingDamage(vals, types)
	
	var damage = getMergedValues(vals)
	
	if type == Cav.UnitClass.CORE_CRYSTAL:
		damage_dealt.a(damage)
	else:
		
		if barrierPresent():
			takeBarrierDamage(damage)
		else:
			takeHealthDamage(damage)

func getMergedValues(vals: Array) -> Big:
	var poop = Big.new(0)
	for v in vals:
		poop.a(v)
	return poop

func barrierPresent() -> bool:
	return barrier.current.greater(0)
func takeBarrierDamage(damage: Big):
	if barrier.current.greater_equal(damage):
		barrier.current = Big.new(barrier.current).s(damage)
	else:
		damage.s(barrier.current)
		barrier.current = Big.new(0)
		takeHealthDamage(damage)
	
	vc.barrierDamaged()
func takeHealthDamage(damage: Big):
	health.current = Big.new(health.current).s(damage)
	if health.current.equal(0):
		die()
		return
	vc.lostHealth()

func react_naturally(types: Array):
	
	# apply new buffs
	for t in types:
		bm.applyBuff(gv.damageTypeToNR(t), gv.warlock, self)
	
	return
	# remove old buffs, clear trackers
	for b in nat_types.size():
		nat_buffs[b].debuff()
	nat_types.clear()
	nat_buffs.clear()
	
	# set up trackers
	for t in types:
		nat_types.append(t)
		nat_buffs.append(buffs[gv.damageTypeToNR(t)])
	
	if nat_types.size() == 0:
		
		return
	return
	var nr := []
	var culm := []
	
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




func loseBuff(_buff: Buff):
	
	if _buff.affects_target_damage_dealt:
		outgoing_damage_multiplier /= _buff.target_damage_dealt_multiplier
		if gv.xIsNearlyY(outgoing_damage_multiplier, 1.0):
			outgoing_damage_multiplier = 1.0
	
	buffs.erase(_buff.type)



func interpretIncomingDamage(_dmg: Array, _type: Array):
	for d in _dmg.size():
		_dmg[d] = resist.interpretIncomingDamage(_dmg[d], _type[d])




func cast(_spell: int, target: Unit):
	
	var spell = Cav.spell[_spell]
	
	if not spell.canCast(self):
		return
	
	spell.cast(self, target)
	
	
	if not vc_set:
		return
	
	if spell.costs_mana:
		vc.spentMana()
	if spell.costs_stamina:
		vc.spentStamina()




func die():
	
	vc_set = false
	dead = true
	vc.die()
