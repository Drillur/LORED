class_name UnitAbility
extends Resource



enum Type {
	MEND,
	
	CURE,
	REGENERATE,
	CLEANSE,
	HEAL,
	REJUVENATE,
	SHIELD,
}

enum School {
	HIEROMANCY,
	ANTHOMANCY,
	HEMOMANCY,
}

var type: Type
var school: School

var key: String

var details := Details.new()

var mana_cost: Float
var blood_cost: Float
var cast_time: Float
var initial_heal: Float
var initial_barrier: Float
var cooldown: Float

var applied_buffs := []

var dispells_buffs := false
var dispells_debuffs := false

var cost_text: String



func _init(_type: Type) -> void:
	type = _type
	key = Type.keys()[type]
	match type:
		Type.MEND:
			school = School.HIEROMANCY
			details.name = "Mend"
			details.description = "Restores {initial_heal} to a single target. Gets the job done."
			details.icon = res.get_resource("082")
			cost_text = "Costs {mana_cost}."
			cast_time = Float.new(3)
			initial_heal = Float.new(1)



# - Get


#func get_description() -> String:
#	var text := details.description
#	if "{applied_buffs}" in text:
#		var applied_buff_text := ""
#		for x in applied_buffs:
#			x = x as UnitStatusEffect
#			applied_buff_text += "\n[i]" + x.name + "[/i] - " + x.get_inactive_description()
#		text = text.format({"applied_buffs": applied_buff_text})
#	if "{initial_heal}" in text:
#		text = text.format({"initial_heal": gv.wrap_text_by_type(initial_heal.get_total_text(), "health")})
#	if "{barrier}" in text:
#		text = text.format({"barrier": gv.wrap_text_by_type(barrier.get_total_text(), "barrier")})
#	return "[center]" + text


func get_cost_text() -> String:
	var text := cost_text
	if "{mana_cost}" in text:
		text = text.format({"mana_cost": gv.wrap_text_by_type(mana_cost.get_total_text(), "mana")})
	if "{flower_cost}" in text:
		text = text.format({
			"flower_cost":
				"1 [img=<16>]" + Flower.get_flower_icon(flower_cost).get_path() + "[/img] " + Flower.get_flower_name(flower_cost)
		})
	return "[center]" + text
