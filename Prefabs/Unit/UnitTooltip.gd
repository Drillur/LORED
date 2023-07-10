extends MarginContainer



onready var icon: Panel = $"%icon"
onready var _name: Label = $"%name"
onready var key: RichTextLabel = $"%key"
onready var description: Label = $"%description"
onready var status_effects: MarginContainer = $"%status effects"
onready var buff_parent: VBoxContainer = $"%buff parent"

var unit: Unit

var buffs := []



func setup(_unit: Unit) -> void:
	unit = _unit
	
	yield(self, "ready")
	
	_name.text = unit.name
	key.bbcode_text = "[center]" + unit.get_key_text()
	description.text = unit.description
	setup_status_effects()


func setup_status_effects() -> void:
	if unit.status_effects.empty():
		status_effects.hide()
		return
	for buff in unit.status_effects.values():
		add_status_effect_vico(buff)


func add_status_effect_vico(buff: UnitStatusEffect) -> void:
	var buff_vico = gv.SRC["UnitStatusEffectVico"].instance()
	buff_vico.setup(buff)
	buff_parent.add_child(buff_vico)
	buffs.append(buff_vico)
	status_effects.show()



func unassign_vicos() -> void:
	for buff in buffs:
		buff.unassign_vico()
	buffs.clear()


func unassign_vico(buff: MarginContainer) -> void:
	buffs.erase(buff)
	if buffs.empty():
		status_effects.hide()
		rect_size.y = 0
