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
	
	manager = UnitManager.new()
	gv.add_child(manager)
	manager.setup(self)
	initialized.emit()



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




# - Get


func get_ability(ability_type: UnitAbility.Type) -> UnitAbility:
	return abilities[ability_type]


func is_alive() -> bool:
	return health.get_value() > 0


func can_cast() -> bool:
	if not is_alive():
		return false
	if cooldown.is_active():
		return false
	return true
