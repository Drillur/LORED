extends MarginContainer



onready var mana: AttributeVico = $"%mana"
onready var blood: AttributeVico = $"%blood"
onready var border: Panel = $border
onready var ability_1: MarginContainer = $"%1"
onready var ability_2: MarginContainer = $"%2"
onready var ability_3: MarginContainer = $"%3"
onready var ability_4: MarginContainer = $"%4"
onready var ability_R: MarginContainer = $"%R"
onready var ability_F: MarginContainer = $"%F"



func setup() -> void:
	mana.setup(AttributeVico.Type.MANA, healer.mana)
	blood.setup(AttributeVico.Type.BLOOD, healer.blood)
	border.self_modulate = gv.COLORS["MANA ALT"]
	setup_starter_abilities()


func setup_starter_abilities() -> void:
	ability_1.setup(healer.abilities[UnitAbility.Type.SHIELD])
	ability_2.setup(healer.abilities[UnitAbility.Type.HEAL])
	ability_3.setup(healer.abilities[UnitAbility.Type.REJUVENATE])
	ability_R.setup(healer.abilities[UnitAbility.Type.CLEANSE])



func cast_ability_by_hotkey(key: int, target_vico: UnitVico) -> void:
	if target_vico == null:
		# NO TARGET
		lv.lored[lv.Type.BLOOD].cannot_cast_ability(lv.ReasonCannotBeginJob.NO_TARGET)
		return
	var ability_vico = "ability_" + OS.get_scancode_string(key)
	get(ability_vico).call("cast", target_vico.unit)

