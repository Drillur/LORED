class_name UnitStatusEffect
extends Reference



enum Type {
	COMMON_COLD,
	
	REGENERATING, # REGENERATE
}

var type: int
var key: String
var name: String

var has_vico := false
var vico: MarginContainer setget assign_vico
func assign_vico(_vico: MarginContainer) -> void:
	has_vico = true
	vico = _vico
	if unlimited_ticks:
		return
	ticks.assign_vico(_vico)
func unassign_vico() -> void:
	has_vico = false
	if unlimited_ticks:
		return
	ticks.unassign_vico()

var school: int
var starting_stacks := 1
var inactive_description := ""
var active_description := ""

var deals_damage: bool
var damage: Attribute # deals dmg to unit's health

var deals_blood_loss: bool
var blood_loss: Attribute # deals dmg to unit's blood

var has_heal: bool
var heal: Attribute

var last_tick_time: int
var unlimited_ticks: bool
var tick_duration: Attribute
var ticks: Attribute

var stacks: Attribute

var dispellable := true

var marked_for_removal := false

var vico_color: Color

var target: Reference




func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	name = key.replace("_", " ").capitalize()
	
	var init_method = "init_" + key
	call(init_method)
	
	deals_damage = damage != null
	deals_blood_loss = blood_loss != null
	unlimited_ticks = ticks == null
	has_heal = heal != null
	
	if deals_damage or deals_blood_loss:
		vico_color = Color(1, 0, 0)
	elif has_heal:
		vico_color = Color(0, 1, 0)
	
	stacks.set_to(starting_stacks)
	
	last_tick_time = OS.get_ticks_msec()
	
	if not dispellable:
		inactive_description += " Not dispellable."
		active_description += " Not dispellable."


func init_COMMON_COLD():
	tick_duration = Attribute.new(5, false)
	stacks = Attribute.new(1)
	starting_stacks = 1
	damage = Attribute.new(3, false)
	active_description = "Taking {damage} every {tick_duration}."


func init_REGENERATING():
	school = gv.AbilitySchool.ANTHOMANCY
	tick_duration = Attribute.new(3, false)
	ticks = Attribute.new(7)
	stacks = Attribute.new(1)
	heal = Attribute.new(1, false)
	inactive_description = "Recovers {heal} every {tick_duration} for {ticks}."
	active_description = "Recovering {heal} every {tick_duration} for {ticks}."



func get_active_description() -> String:
	return format_text(active_description)


func get_inactive_description() -> String:
	return format_text(inactive_description)


func format_text(text: String) -> String:
	
	if "{damage}" in text:
		text = text.format({"damage": gv.wrap_text_by_type(damage.get_total().toString(), "damage")})
	if "{tick_duration}" in text:
		text = text.format({"tick_duration": tick_duration.get_total_text() + " sec"})
	if "{heal}" in text:
		text = text.format({"heal": gv.wrap_text_by_type(heal.get_total_text(), "health")})
	if "{ticks}" in text:
		text = text.format({"ticks": fval.f(tick_duration.get_as_float() * ticks.get_as_float()) + " sec"})
	return text



func renew() -> void:
	if unlimited_ticks:
		return
	ticks.reset()
	ticks.current.add(1) # after it gets reset to 6 (for example), it gets increased to 7 for free.
	ticks.update_vico()
	
	target.vico.buff_vicos[type].update_text()


func add_stack() -> void:
	if stacks.get_current().greater_equal(stacks.get_total()):
		return
	stacks.add(1)



func remove_from_unit():
	marked_for_removal = true
	if has_vico:
		vico.kill()



func tick() -> void:
	if has_heal:
		healer.heal(target, heal.get_randomized_total())
	if deals_damage:
		target.take_damage(damage.get_randomized_total())
	if deals_blood_loss:
		target.take_blood_loss(blood_loss.get_randomized_total())
	
	last_tick_time = OS.get_ticks_msec()
	
	if not unlimited_ticks:
		ticks.subtract(1)
		if ticks.get_current().equal(0):
			remove_from_unit()
		target.vico.buff_vicos[type].update_text()



func get_tick_percent() -> float:
	return get_tick_remaining() / tick_duration.get_as_float()


func get_tick_remaining() -> float:
	var tick_duration_in_msec = tick_duration.get_as_float() * 1000
	var current_time = OS.get_ticks_msec()
	return (tick_duration_in_msec - (current_time - last_tick_time)) / 1000
