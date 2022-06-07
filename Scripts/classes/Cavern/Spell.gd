class_name Spell
extends Ability



var has_cd := false
var cd: Cav.Cooldown

var costs_mana := false
var mana_cost: Cav.UnitAttribute

var costs_stamina := false
var stamina_cost: Cav.UnitAttribute

var costs_health := false
var health_cost: Cav.UnitAttribute

var has_cast_time := false
var cast_time: float

var is_channeled := false
var channel_duration: float
var channel_tick_rate: float

var applies_buff := false
var applied_buff := -1

var restores_health := false
var restore_health: Cav.UnitAttribute

var has_special_effects := false

var requires_target := true

var special_req_type := []
var special_req := []
var special_action_type := []
var special_action := []

var splash := false





func _init(_type: int).(_type):
	
	name = gv.getSpellName(type)
	
	call("construct_" + Cav.eSpell.keys()[type])
	
	has_cd = cd != null
	costs_mana = mana_cost != null
	costs_stamina = stamina_cost != null
	costs_health = health_cost != null
	restores_health = restore_health != null
	has_cast_time = cast_time > 0
	applies_buff = applied_buff >= 0
	is_channeled = channel_duration > 0
	
	has_special_effects = special_req_type.size() > 0
	
	constructFin() # in Ability.gd
	
	assumeOrder()




func construct_ARCANE_FOCUS():
	
	channel_duration = 10.0
	channel_tick_rate = 0.1
	
	restore_mana = Cav.UnitAttribute.new(0.01)
	
	requires_target = false

func construct_CORE_RIFT():
	
	mana_cost = Cav.UnitAttribute.new(1)
	
	applied_buff = Cav.Buff.RIFT
	
	requires_target = false

func construct_VITALIZE():
	
	cast_time = 3.0
	
	cd = Cav.Cooldown.new(3)
	
	restore_mana = Cav.UnitAttribute.new(5)

func construct_ARCANE_FLOW():
	
	mana_cost = Cav.UnitAttribute.new(5)
	
	cd = Cav.Cooldown.new(6)
	
	applied_buff = Cav.Buff.ARCANE_FLOW
	
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
		Cav.eSpell.SCORCH:
			order.append(Cav.AbilityAction.APPLY_BUFF)
			applied_buff = Cav.Buff.SCORCHING
	orderAdjusted()

func orderAdjusted():
	refreshDesc()


















func refreshDesc():
	gv.setSpellDesc(self)




func canCast(caster: Unit) -> bool:
	if not isAvailable():
		return false
	if costs_mana:
		if caster.mana.current.less(mana_cost.total):
			return false
	if costs_stamina:
		if caster.stamina.current.less(stamina_cost.total):
			return false
	return true

func channelTick(caster: Unit, target: Unit):
	
	processOrder(caster, target)

func cast(caster: Unit, target: Unit) -> void:
	
	sm.cast(caster,target,self)

func castFin(caster: Unit, target: Unit):
	
	# called by SpellManager
	
	if costs_mana:
		caster.mana.current = Big.new(caster.mana.current).s(mana_cost.total)
	
	if costs_stamina:
		caster.stamina.current = Big.new(caster.stamina.current).s(stamina_cost.total)
	
	if has_cd:
		cd.spellCast()
	
	processOrder(caster, target)

func processOrder(caster: Unit, target: Unit):
	
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
											bm.spellCast(caster, target, special_action[i])
			Cav.AbilityAction.DEAL_DAMAGE:
				target.takeDamage(getDamage(caster), damage.type, triggers_nr)
			Cav.AbilityAction.APPLY_BUFF:
				bm.spellCast(caster, target, applied_buff)
			Cav.AbilityAction.RESTORE_MANA:
				target.takeManaRestoration(getManaRestore(caster))



func getIcon() -> Texture:
	return gv.spell_sprite[type]

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

func getManaCost(caster: Unit) -> Big:
	return mana_cost.total
func getStaminaCost(caster: Unit) -> Big:
	return stamina_cost.total
func getCastTime(caster: Unit) -> float:
	return cast_time / caster.getHaste()
func getCooldown(caster: Unit) -> float:
	if not has_cd:
		return 0.0
	return cd.total
func isAvailable() -> bool:
	if not has_cd:
		return true
	return cd.isAvailable()
func getChannelDuration(caster: Unit) -> float:
	return channel_duration / caster.getHaste()
func getChannelTickRate(caster: Unit) -> float:
	return channel_tick_rate / caster.getHaste()


func getDesc(caster: Unit) -> String:
	
	var text := desc
	
	if deals_damage:
		text = getDesc_damage(text, getDamage(caster))
	text = getDesc_other(text)
	
	if "{restore_health per sec}" in text:
		var health_per_sec = Big.new(1 / getChannelTickRate(caster)).m(getHealthRestore(caster))
		text = text.format({"restore_health per sec":  "[color=#" + gv.COLORS["health"].to_html() + "]" + health_per_sec.toString() + " Health[/color]"})
	if "{restore_health}" in text:
		text = text.format({"restore_health": "[color=#" + gv.COLORS["health"].to_html() + "]" + getHealthRestore(caster).toString() + " Health[/color]"})
	
	if "{restore_mana per sec}" in text:
		var mana_per_sec = Big.new(1 / getChannelTickRate(caster)).m(getManaRestore(caster)).toString()
		var color = "[color=#" + gv.COLORS["mana"].to_html() + "]"
		text = text.format({"restore_mana per sec": color + mana_per_sec + " Mana[/color]"})
	if "{restore_mana}" in text:
		text = text.format({"restore_mana": "[color=#" + gv.COLORS["mana"].to_html() + "]" + getManaRestore(caster).toString() + " Mana[/color]"})
	
	return text
