class_name Unit
extends Resource



enum Type {
	GARDEN,
	WITCH,
	ARCANE,
}

enum ErrorType {
	NONE,
	GCD,
	UNIT_IS_DEAD,
	ABILITY_IS_NULL,
	ABILITY_COOLDOWN,
	ABILITY_NOT_AFFORDABLE,
}

signal initialized
signal started_casting
signal stopped_casting

var type: Type
var key: String

var lored: LORED

var manager: UnitManager

var health := UnitResource.new(UnitResource.Type.HEALTH, 10)
var stamina: UnitResource
var mana: UnitResource
var blood: UnitResource
var resources: Dictionary # UnitResources are referenced here so can access with UnitResource.Type as key
var cooldown := Cooldown.new(1.5)

var cast_timer := Timer.new()
var casting_ability: UnitAbility.Type

var abilities := {}
var queued_ability: UnitAbility.Type

var hotbar_currencies: Array

var DEBUG_casting_ability := Int.new(0)
var DEBUG_queued_ability := Int.new(0)



func _init(_type: Type) -> void:
	type = _type
	key = Type.keys()[type]
	if lv.loreds_initialized.is_false():
		await lv.loreds_initialized.became_true
	set_lored()
	match type:
		Type.ARCANE:
			lored = lv.get_lored(LORED.Type.ARCANE)
			setup_unit_resource(UnitResource.Type.MANA, 1)
			add_ability(UnitAbility.Type.CORE_RIFT)
			add_ability(UnitAbility.Type.ARCANE_FOCUS)
			add_ability(UnitAbility.Type.SUPPLEMANCE)
			hotbar_currencies.append(wa.get_currency(Currency.Type.MANA))
		Type.GARDEN:
			lored = lv.get_lored(LORED.Type.WITCH)
			setup_unit_resource(UnitResource.Type.STAMINA, 10)
			add_ability(UnitAbility.Type.PICK_FLOWER)
			add_ability(UnitAbility.Type.SIFT_SEEDS)
			hotbar_currencies.append(wa.get_currency(Currency.Type.SEEDS))
			hotbar_currencies.append(wa.get_currency(Currency.Type.FLOWER_SEED))
	cooldown.active.became_false.connect(check_for_queued_ability)
	
	manager = UnitManager.new()
	gv.add_child(manager)
	manager.setup(self)
	
	cast_timer.one_shot = true
	cast_timer.timeout.connect(cast_timer_timeout)
	cast_timer.timeout.connect(check_for_queued_ability)
	manager.add_child(cast_timer)
	
	initialized.emit()



# - Signal


func check_for_queued_ability() -> void:
	if has_queued_ability():
		if is_casting():
			cast_ability()
			stop_casting()
#		if is_casting_but_not_channeling():
#			cast_ability()
#			stop_casting()
		if can_cast() and get_ability(queued_ability).can_cast():
			print("ABOUT TO CAST")
			cast(queued_ability)
			# i could see a problem where can_cast() fails because a resource or currency cost is 0.0000001 short
			# and then in the next frame there is enough to cast. time will tell if this
			# happens, and if it does, if it feels bad.
		clear_queued_ability()


func cast_timer_timeout() -> void:
	cast_ability()
	stopped_casting.emit()



# - Internal


func cast_ability() -> void:
	if casting_ability != UnitAbility.Type.NONE:
		get_ability(casting_ability).cast()
		casting_ability = UnitAbility.Type.NONE
		DEBUG_casting_ability.set_to(casting_ability)


func setup_unit_resource(resource_type: UnitResource.Type, base_value: float) -> void:
	match resource_type:
		UnitResource.Type.HEALTH:
			health = UnitResource.new(resource_type, base_value)
			resources[resource_type] = health
		UnitResource.Type.STAMINA:
			stamina = UnitResource.new(resource_type, base_value)
			resources[resource_type] = stamina
		UnitResource.Type.MANA:
			mana = UnitResource.new(resource_type, base_value)
			resources[resource_type] = mana
		UnitResource.Type.BLOOD:
			blood = UnitResource.new(resource_type, base_value)
			resources[resource_type] = blood


func set_lored() -> void:
	match type:
		Type.GARDEN, Type.WITCH:
			lored = lv.get_lored(LORED.Type.WITCH)


func add_ability(ability_type: UnitAbility.Type) -> void:
	abilities[ability_type] = UnitAbility.new(ability_type, self)


func clear_queued_ability() -> void:
	var ability := get_ability(queued_ability)
	if ability.has_cooldown():
		ability.cooldown.active.became_false.disconnect(check_for_queued_ability)
	queued_ability = UnitAbility.Type.NONE
	DEBUG_queued_ability.set_to(queued_ability)




# - Action


func cast(ability_type: UnitAbility.Type) -> void:
	var ability := get_ability(ability_type) as UnitAbility
	if cooldown.is_active() or (ability.has_cooldown() and ability.cooldown.is_active()):
		print("WHUAT")
		# by this point, both cooldowns are at < 0.5s time_left.
		enqueue_ability(ability_type)
	else:
		if is_casting():
			stop_casting()
		if ability.has_cast_time():
			casting_ability = ability_type
			DEBUG_casting_ability.set_to(casting_ability)
			cast_timer.start(ability.get_cast_time())
			started_casting.emit()
		else:
			ability.cast()
		cooldown.activate()


func enqueue_ability(ability_type: UnitAbility.Type) -> void:
	if has_queued_ability():
		clear_queued_ability()
	queued_ability = ability_type
	DEBUG_queued_ability.set_to(queued_ability)
	var ability := get_ability(queued_ability)
	if ability.has_cooldown():
		ability.cooldown.active.became_false.connect(check_for_queued_ability)


func add_mana(amount: float) -> void:
	var surplus = mana.value.get_surplus(amount)
	if surplus > 0:
		mana.value.fill()
		wa.add(Currency.Type.MANA, surplus)
	else:
		mana.value.add(amount)


func stop_casting() -> void:
	cast_timer.stop()
	if cooldown.is_active():
		cooldown.stop()
	casting_ability = UnitAbility.Type.NONE
	DEBUG_casting_ability.set_to(casting_ability)
	stopped_casting.emit()




# - Get


func get_ability(ability_type: UnitAbility.Type) -> UnitAbility:
	return abilities[ability_type]


func is_alive() -> bool:
	return health.get_value() > 0


func can_cast() -> bool:
	if not is_alive():
		return false
	if is_casting():
		if not get_ability(casting_ability).channeled:
			if cast_timer.time_left > 0.5:
				return false
	return cooldown.is_nearly_or_already_inactive()


func has_queued_ability() -> bool:
	return queued_ability != UnitAbility.Type.NONE


func is_casting() -> bool:
	return not cast_timer.is_stopped()


func is_channeling() -> bool:
	if is_casting():
		return get_ability(casting_ability).channeled
	return false


func is_casting_but_not_channeling() -> bool:
	if is_casting():
		return not get_ability(casting_ability).channeled
	return false


func has_buff(_type: UnitBuff.Type) -> bool:
	return Buffs.object_has_specific_buff(self, _type)
