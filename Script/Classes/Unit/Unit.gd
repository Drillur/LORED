class_name Unit
extends Resource



enum Type {
	GARDEN,
	WITCH,
}

signal initialized


var type: Type
var key: String

var lored: LORED

var health: UnitResource
var stamina: UnitResource
var mana: UnitResource
var blood: UnitResource
var unit_resources: Dictionary # specific use-case

var abilities := {}
var hotbar_currencies := []



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
	initialized.emit()


func setup_unit_resource(resource_type: UnitResource.Type, base_value: float) -> void:
	match resource_type:
		UnitResource.Type.HEALTH:
			health = UnitResource.new(resource_type, base_value)
			unit_resources[resource_type] = health
		UnitResource.Type.STAMINA:
			stamina = UnitResource.new(resource_type, base_value)
			unit_resources[resource_type] = stamina
		UnitResource.Type.MANA:
			mana = UnitResource.new(resource_type, base_value)
			unit_resources[resource_type] = mana
		UnitResource.Type.BLOOD:
			blood = UnitResource.new(resource_type, base_value)
			unit_resources[resource_type] = blood
	


func set_lored() -> void:
	match type:
		Type.GARDEN, Type.WITCH:
			lored = lv.get_lored(LORED.Type.WITCH)


func add_ability(ability_type: UnitAbility.Type) -> void:
	abilities[ability_type] = UnitAbility.new(ability_type, self)



# - Get


func get_ability(ability_type: UnitAbility.Type) -> UnitAbility:
	return abilities[ability_type]


#func get_resource(resource_type: UnitResource) -> UnitResource:
#	match resource_type:
#		UnitResource.Type.HEALTH:
#			return health
#		UnitResource.Type.BLOOD:
#			return blood
#		UnitResource.Type.STAMINA:
#			return stamina
#		UnitResource.Type.MANA:
#			return mana
#	return stamina
