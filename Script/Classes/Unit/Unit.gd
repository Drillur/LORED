class_name Unit
extends Resource



enum Type {
	GARDEN,
	WITCH,
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

var abilities := {}
var queued_ability: UnitAbility.Type

var hotbar_currencies: Array



func _init(_type: Type) -> void:
	type = _type
	key = Type.keys()[type]
	set_lored()
	match type:
		Type.GARDEN:
			lored = lv.get_lored(LORED.Type.WITCH)
			setup_unit_resource(UnitResource.Type.STAMINA, 10)
			add_ability(UnitAbility.Type.PICK_FLOWER)
			hotbar_currencies.append(wa.get_currency(Currency.Type.SEEDS))
			hotbar_currencies.append(wa.get_currency(Currency.Type.FLOWER_SEED))
	cooldown.active.became_false.connect(gcd_or_ability_cd_became_inactive)
	
	manager = UnitManager.new()
	gv.add_child(manager)
	manager.setup(self)
	initialized.emit()



# - Signal


func gcd_or_ability_cd_became_inactive() -> void:
	if has_queued_ability():
		if can_cast() and get_ability(queued_ability).can_cast():
			cast(queued_ability)
			# i could see a problem where can_cast() fails because a resource or currency cost is 0.0000001 short
			# and then in the next frame there is enough to cast. time will tell if this
			# happens, and if it does, if it feels bad.
		clear_queued_ability()



# - Internal


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
	abilities[ability_type].just_cast.connect(cooldown.activate)


func clear_queued_ability() -> void:
	var ability := get_ability(queued_ability)
	ability.cooldown.active.became_false.disconnect(gcd_or_ability_cd_became_inactive)
	queued_ability = UnitAbility.Type.NONE




# - Action


func cast(ability_type: UnitAbility.Type) -> void:
	var ability := get_ability(ability_type) as UnitAbility
	if cooldown.is_active() or ability.cooldown.is_active():
		# by this point, both cooldowns are at < 0.5s time_left.
		enqueue_ability(ability_type)
	else:
		ability.cast()


func enqueue_ability(ability_type: UnitAbility.Type) -> void:
	if has_queued_ability():
		clear_queued_ability()
	queued_ability = ability_type
	var ability := get_ability(queued_ability)
	ability.cooldown.active.became_false.connect(gcd_or_ability_cd_became_inactive)




# - Get


func get_ability(ability_type: UnitAbility.Type) -> UnitAbility:
	return abilities[ability_type]


func is_alive() -> bool:
	return health.get_value() > 0


func can_cast() -> bool:
	if not is_alive():
		return false
	return cooldown.is_nearly_or_already_inactive()


func has_queued_ability() -> bool:
	return queued_ability != UnitAbility.Type.NONE
