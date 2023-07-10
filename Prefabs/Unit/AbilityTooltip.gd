extends MarginContainer



onready var icon: Panel = $"%icon"
onready var _name: Label = $"%name"
onready var school: RichTextLabel = $"%school"
onready var description: RichTextLabel = $"%description"
onready var cost: RichTextLabel = $"%cost"
onready var cast_time: Label = $"%cast_time"

var ability: UnitAbility



func setup(_ability: UnitAbility) -> void:
	ability = _ability
	
	yield(self, "ready")
	
	icon.set_icon(ability.icon)
	_name.text = ability.name
	school.bbcode_text = ability.school_text
	description.bbcode_text = ability.get_description()
	cost.bbcode_text = ability.get_cost_text()
	if ability.has_cast_time:
		cast_time.text = "Cast time: " + ability.get_cast_time_text()
	else:
		cast_time.text = "Instant cast"
