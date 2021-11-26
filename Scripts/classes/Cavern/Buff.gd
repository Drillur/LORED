class_name Buff
extends Ability



var stacks := 1
var stack_limit: int
var base_stack_limit := 1

var ticks: int
var max_ticks: int
var base_max_ticks := 1

var tick_rate: float
var base_tick_rate: float

var affects_target_damage_dealt := false
var target_damage_dealt_multiplier := -1.0

var duration_is_extended_by_damage := false
var duration_extended_by_damage_of_type := -1


var debuffed := false


func _init(_type: int, data: Dictionary).(_type):
	
	name = gv.getBuffName(type)
	
	call("construct_" + Cav.Buff.keys()[type])
	
	setViaData(data)
	
	constructFin() # in Ability.gd
	
	affects_target_damage_dealt = target_damage_dealt_multiplier >= 0
	duration_is_extended_by_damage = duration_extended_by_damage_of_type >= 0
	
	assumeOrder()
	
	sync(data)
	
	setDesc()

func construct_BURNING():
	
	damage = Cav.Damage.new(Cav.DamagePreset.LIGHT, Cav.DamageType.FIRE)
	base_max_ticks = 6
	base_tick_rate = 1
	base_stack_limit = 5
	triggers_nr = false

func construct_CHILLED():
	
	base_tick_rate = 4
	base_stack_limit = 5
	triggers_nr = false

func construct_BATTERED():
	
	base_tick_rate = 6
	base_stack_limit = 5
	triggers_nr = false

func construct_OXIDIZED():
	
	base_tick_rate = 10
	base_stack_limit = 5
	triggers_nr = false




func construct_RIFT():
	
	restore_mana = Cav.UnitAttribute.new(1)
	base_max_ticks = 6
	base_tick_rate = 1




func construct_SCORCHING():
	
	damage = Cav.Damage.new(Cav.DamagePreset.LIGHT, Cav.DamageType.FIRE)
	base_max_ticks = 2
	base_tick_rate = 1.5
	base_stack_limit = 2

func construct_BUCKLED():
	
	base_tick_rate = 6
	
	target_damage_dealt_multiplier = 0.5

func construct_FANNED_FLAME():
	
	base_tick_rate = 1
	base_max_ticks = 4
	
	duration_extended_by_damage_of_type = Cav.DamageType.AIR








func sync(data: Dictionary):
	restore_mana.m_from_intellect = data["intellect"]
	restore_mana.sync()



















func assumeOrder():
	
	if order.size() != 0:
		return
	
	var bla = []
	
	if deals_damage:
		bla.append(Cav.AbilityAction.DEAL_DAMAGE)
	if restores_mana:
		bla.append(Cav.AbilityAction.RESTORE_MANA)
	
	setOrder(bla)




func setViaData(data: Dictionary) -> void:
	
	# keys required in data:
	# haste: caster's haste
	# damage multiplier: caster.getDamageMultiplier()
	
	setStats()
	
	setTicks(data["haste"])
	setTickRate(data["haste"])
	setDamage(data["damage multiplier"])

func setStats():
	
	stack_limit = base_stack_limit
	tick_rate = base_tick_rate
	max_ticks = base_max_ticks

func setTicks(caster_haste: float) -> void:
	if max_ticks == 1:
		return
	max_ticks *= caster_haste
	ticks = max_ticks

func setTickRate(caster_haste: float) -> void:
	tick_rate /= caster_haste

func setDamage(damage_multiplier: Big) -> void:
	
	if damage == null:
		return
	
	for d in damage.types:
		damage.dmg[d].m(damage_multiplier)

func setDesc():
	
	if deals_damage:
		
		desc += "deals "
		
		var ii = 0
		for d in damage.types:
			
			desc += "{damage" + str(ii) + "}"
			
			ii += 1
			
			if damage.types == ii:
				desc += " damage"
				if ii > 1:
					desc += " simultaneously"
			elif damage.types == ii + 1:
				if damage.types > 2:
					desc += ", "
				desc += " and "
			elif damage.types -1 > ii + 1:
				desc += ", "
		
		if max_ticks == 1:
			desc += " after "
		else:
			if tick_rate != 1:
				desc += " every "
			else:
				desc += " per "
		
		if tick_rate != 1:
			desc += str(tick_rate) + " "
		desc += "sec."
		
		if max_ticks > 1:
			desc += " " + str(max_ticks) + " ticks."
	
	
	if restores_mana:
		
		desc += "restores {restore_mana}"
		
		if max_ticks == 1:
			desc += " after "
		else:
			if tick_rate != 1:
				desc += " every "
			else:
				desc += " per "
		
		if tick_rate != 1:
			desc += str(tick_rate) + " "
		desc += "sec for "
		
		
		if max_ticks > 1:
			desc += str(max_ticks * tick_rate) + " seconds."
	
	
	if stack_limit > 1:
		desc += " Limit " + str(stack_limit) + " stacks."
	
	if not triggers_nr:
		desc += " Does not trigger Natural Reaction."
	
	desc[0] = desc[0].to_upper()
	
	if damage != null:
		desc = getDesc_damage(desc, damage.dmg)
	desc = getDesc_other(desc)

func getDesc() -> String:
	
	desc = desc.format({"restore_mana": restore_mana.total.toString() + " Mana"})
	
	return desc


func getBorderColor() -> Color:
	
#	if restores_health:
#		return gv.COLORS["health"]
	if restores_mana:
		return gv.COLORS["mana"]
	return Color(1,1,1)

func getIcon() -> Texture:
	return gv.buff_sprite[type]

func getDuration() -> float:
	return tick_rate * max_ticks

func getDumbDuration() -> float:
	return tick_rate * max_ticks - 1

func getRestoreMana() -> Big:
	return restore_mana.total






func isAtStackLimit() -> bool:
	return stacks == stack_limit



func refresh():
	max_ticks = base_max_ticks + 1
	ticks = max_ticks

func debuff():
	# will no longer tick in buffmanager. will get removed automatically
	debuffed = true







func increaseStacks(x: int):
	
	if stacks == stack_limit:
		return
	
	if stacks > 1:
		if deals_damage:
			for d in damage.dmg:
				d.d(stacks)
	
	stacks += x
	
	if deals_damage:
		for d in damage.dmg:
			d.m(stacks)
	
	if stacks > stack_limit:
		stacks = stack_limit

func increaseTicks(x: int):
	ticks += x
	max_ticks += x

