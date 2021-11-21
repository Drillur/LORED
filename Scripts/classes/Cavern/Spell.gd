class_name Spell
extends Ability



var has_cd := false
var cd: Cav.Cooldown

var costs_mana := false
var mana_cost: Cav.UnitAttribute

var costs_stamina := false
var stamina_cost: Cav.UnitAttribute

var has_cast_time := false
var cast_time: float

var is_channeled := false
var channel_duration: float
var channel_tick_rate: float

var applies_buff := false
var applied_buff := -1

var restores_health := false
var restore_health: Cav.UnitAttribute
var restores_mana := false
var restore_mana: Cav.UnitAttribute

var has_special_effects := false

var requires_target := true

var special_req_type := []
var special_req := []
var special_action_type := []
var special_action := []

var splash := false





func _init(_type: int).(_type):
	
	name = gv.getSpellName(type)
	
	call("construct_" + Cav.Spell.keys()[type])
	
	has_cd = cd != null
	costs_mana = mana_cost != null
	costs_stamina = stamina_cost != null
	restores_health = restore_health != null
	restores_mana = restore_mana != null
	has_cast_time = cast_time > 0
	applies_buff = applied_buff >= 0
	is_channeled = channel_duration > 0
	
	has_special_effects = special_req_type.size() > 0
	
	constructFin() # in Ability.gd
	
	assumeOrder()

func construct_ARCANE_FOCUS():
	
	channel_duration = 10.0
	channel_tick_rate = 0.1
	
	restore_mana = Cav.UnitAttribute.new(0.1)
	
	requires_target = false

func construct_SCORCH():
	
	applied_buff = Cav.Buff.SCORCHING#note remove. this is an unlocked buff. see unlockBuff
	
	mana_cost = Cav.UnitAttribute.new(2)
	
	damage = Cav.Damage.new(Cav.DamagePreset.MEDIUM, Cav.DamageType.FIRE)

func construct_EXPLODE():
	
	damage = Cav.Damage.new(Cav.DamagePreset.MEDIUM, Cav.DamageType.FIRE)
	
	triggers_nr = false
	
	addSpecialEffect(
		Cav.SpecialEffectRequirement.STACK_LIMIT,
		Cav.Buff.BURNING,
		Cav.SpecialEffect.BECOME_SPLASH
	)

func construct_BUCKLE():
	
	damage = Cav.Damage.new(Cav.DamagePreset.MEDIUM, Cav.DamageType.EARTH)
	
	triggers_nr = false
	
	addSpecialEffect(
		Cav.SpecialEffectRequirement.STACK_LIMIT,
		Cav.Buff.BURNING,
		Cav.SpecialEffect.APPLY_BUFF,
		Cav.Buff.BUCKLED
	)

func construct_FANNED_FLAME():
	
	applied_buff = Cav.Buff.FANNED_FLAME
	
	triggers_nr = false
































func assumeOrder():
	
	if order.size() != 0:
		return
	
	var bla = []
	
	if has_special_effects:
		bla.append(Cav.AbilityAction.CONSIDER_SPECIAL_EFFECTS)
	if deals_damage:
		bla.append(Cav.AbilityAction.DEAL_DAMAGE)
	if applies_buff: 
		bla.append(Cav.AbilityAction.APPLY_BUFF)
	if restores_mana:
		bla.append(Cav.AbilityAction.RESTORE_MANA)
	
	setOrder(bla)

func addSpecialEffect(req_type: int, req: int, action_type: int, action := -1):
	
	special_req_type.append(req_type)
	special_req.append(req)
	special_action_type.append(action_type)
	special_action.append(action)

func unlockBuff():
	match type:
		Cav.Spell.SCORCH:
			order.append(Cav.AbilityAction.APPLY_BUFF)
			applied_buff = Cav.Buff.SCORCHING
	orderAdjusted()

func orderAdjusted():
	refreshDesc()


















func refreshDesc():
	gv.setSpellDesc(self)




func canCast(caster: Unit) -> bool:
	if has_cd:
		if cd.remaining > 0:
			return false
	if costs_mana:
		if caster.mana.current.less(mana_cost.total):
			return false
	if costs_stamina:
		if caster.stamina.current.less(stamina_cost.total):
			return false
	return true

func channelTick(caster: Unit, target: Unit):
	
	for o in order:
		match o:
			Cav.AbilityAction.CONSIDER_SPECIAL_EFFECTS:
				for i in special_req_type.size():
					match special_req_type[i]:
						Cav.SpecialEffectRequirement.STACK_LIMIT:
							if special_req[i] in target.buffs.keys():
								if target.buffs[special_req[i]].isAtStackLimit():
									match special_action_type[i]:
										Cav.SpecialEffect.BECOME_SPLASH:
											splash = true
										Cav.SpecialEffect.APPLY_BUFF:
											bm.applyBuff(special_action[i], caster, target)
			Cav.AbilityAction.DEAL_DAMAGE:
				target.takeDamage(getDamage(caster), damage.type, triggers_nr)
			Cav.AbilityAction.APPLY_BUFF:
				bm.applyBuff(applied_buff, caster, target)
			Cav.AbilityAction.RESTORE_MANA:
				target.takeManaRestoration(getManaRestore(caster))

func cast(caster: Unit, target: Unit) -> void:
	
	if has_cast_time:
		sm.cast(caster, target, self)
	else:
		castFin(caster, target)

func castFin(caster: Unit, target: Unit):
	
	# called by SpellManager
	
	if costs_mana:
		caster.mana.current = Big.new(caster.mana.current).s(mana_cost.total)
	
	if costs_stamina:
		caster.stamina.current = Big.new(caster.stamina.current).s(stamina_cost.total)
	
	if has_cd:
		cd.spellCast()
	
	for o in order:
		match o:
			Cav.AbilityAction.CONSIDER_SPECIAL_EFFECTS:
				for i in special_req_type.size():
					match special_req_type[i]:
						Cav.SpecialEffectRequirement.STACK_LIMIT:
							if special_req[i] in target.buffs.keys():
								if target.buffs[special_req[i]].isAtStackLimit():
									match special_action_type[i]:
										Cav.SpecialEffect.BECOME_SPLASH:
											splash = true
										Cav.SpecialEffect.APPLY_BUFF:
											bm.applyBuff(special_action[i], caster, target)
			Cav.AbilityAction.DEAL_DAMAGE:
				target.takeDamage(getDamage(caster), damage.type, triggers_nr)
			Cav.AbilityAction.APPLY_BUFF:
				bm.applyBuff(applied_buff, caster, target)
			Cav.AbilityAction.RESTORE_MANA:
				target.takeManaRestoration(getManaRestore(caster))



func getDamage(caster: Unit) -> Array:
	
	# an array of Bigs equal to damage.dmg * caster's dmg multiplier
	
	var damage_array := []
	var damage_multiplier = caster.getDamageMultiplier()
	
	for d in damage.types:
		var dmg := Big.new(damage.dmg[d])
		dmg.m(damage_multiplier)
		damage_array.append(dmg)
	
	return damage_array

func getHealthRestore(caster: Unit) -> Big:
	return Big.new(restore_health.total).m(caster.getIntellect())
func getManaRestore(caster: Unit) -> Big:
	return Big.new(restore_mana.total).m(caster.getIntellect())

func getCastTime(caster: Unit) -> float:
	return cast_time / caster.getHaste()
func getChannelDuration(caster: Unit) -> float:
	return channel_duration / caster.getHaste()
func getChannelTickRate(caster: Unit) -> float:
	return channel_tick_rate / caster.getHaste()


func getDesc(caster: Unit) -> String:
	
	var text := desc
	
	text = getDesc_sharedQualities(text, getDamage(caster))
	
	if "{restore_health per sec}" in text:
		var health_per_sec = Big.new(1 / getChannelTickRate(caster)).m(getHealthRestore(caster))
		text.format({"restore_health per sec": health_per_sec.toString()})
	if "{restore_health}" in text:
		text.format({"restore_health": getHealthRestore(caster).toString()})
	
	if "{restore_mana per sec}" in text:
		var mana_per_sec = Big.new(1 / getChannelTickRate(caster)).m(getManaRestore(caster))
		text.format({"restore_mana per sec": mana_per_sec.toString()})
	if "{restore_mana}" in text:
		text.format({"restore_mana": getManaRestore(caster).toString()})
	
	return text
