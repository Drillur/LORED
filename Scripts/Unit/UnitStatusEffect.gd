class_name UnitStatusEffect
extends Reference



enum Type {
	COMMON_COLD,
	UNCOMMON_COLD,
	DISEASED,
	FADING_AWAY, # DISEASED
	OPEN_WOUND,
	COVID_19,
	REGENERATING, # REGENERATE
	REJUVENATING, # REJUVENATE
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

var applied_buff := -1
var applies_buff: bool

var stacks: Attribute
var limited_stacks := true

var dispellable: bool
var harmful: bool
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
	harmful = not has_heal
	applies_buff = applied_buff >= 0
	
	if deals_damage or deals_blood_loss:
		vico_color = Color(1, 0, 0)
	elif has_heal:
		vico_color = Color(0, 1, 0)
	
	stacks.set_to(starting_stacks)
	
	last_tick_time = OS.get_ticks_msec()


func init_COMMON_COLD():
	tick_duration = Attribute.new(5, false)
	stacks = Attribute.new(1)
	starting_stacks = 1
	limited_stacks = false
	damage = Attribute.new(3, false)
	dispellable = true
	active_description = "Taking {damage} every {tick_duration}."


func init_UNCOMMON_COLD():
	tick_duration = Attribute.new(5, false)
	stacks = Attribute.new(6)
	starting_stacks = 6
	damage = Attribute.new(2, false)
	dispellable = true
	active_description = "Taking {damage} every {tick_duration}."


func init_DISEASED():
	tick_duration = Attribute.new(15, false)
	stacks = Attribute.new(1)
	starting_stacks = 1
	add_applied_buff(Type.FADING_AWAY)
	dispellable = false
	active_description = "Applies [i]Fading Away[/i] every {tick_duration}. Non-dispellable.{applied_buffs}"


func init_FADING_AWAY():
	tick_duration = Attribute.new(3, false)
	stacks = Attribute.new(1)
	starting_stacks = 1
	limited_stacks = false
	damage = Attribute.new(3, false)
	dispellable = true
	inactive_description = "Takes {damage} every {tick_duration}."
	active_description = "Taking {damage} every {tick_duration}."


func init_OPEN_WOUND():
	tick_duration = Attribute.new(1, false)
	blood_loss = Attribute.new(1, false)
	stacks = Attribute.new(8)
	starting_stacks = 8
	dispellable = true
	active_description = "Causes {blood_loss} every {tick_duration}."


func init_REGENERATING():
	school = gv.AbilitySchool.ANTHOMANCY
	tick_duration = Attribute.new(3, false)
	ticks = Attribute.new(7)
	stacks = Attribute.new(1)
	heal = Attribute.new(1, false)
	dispellable = false
	inactive_description = "Recovers {heal} every {tick_duration} for {ticks}."
	active_description = "Recovering {heal} every {tick_duration} for {ticks}."


func init_REJUVENATING():
	school = gv.AbilitySchool.ANTHOMANCY
	tick_duration = Attribute.new(3, false)
	ticks = Attribute.new(7)
	stacks = Attribute.new(1)
	heal = Attribute.new(3, false)
	dispellable = false
	inactive_description = "Recovers {heal} every {tick_duration} for {ticks}."
	active_description = "Recovering {heal} every {tick_duration} for {ticks}."



func add_applied_buff(_type: int) -> void:
	gv.temp_store_buff(_type)
	applied_buff = _type



func get_active_description() -> String:
	return format_text(active_description)


func get_inactive_description() -> String:
	return format_text(inactive_description)


func format_text(text: String) -> String:
	
	var stack_text = ""
	if stacks.get_current().greater(1):
		stack_text = " per stack"
	
	if "{damage}" in text:
		text = text.format({"damage": gv.wrap_text_by_type(damage.get_total_text(), "damage") + stack_text})
	if "{blood_loss}" in text:
		text = text.format({"blood_loss": gv.wrap_text_by_type(blood_loss.get_total_text(), "blood loss") + stack_text})
	if "{tick_duration}" in text:
		text = text.format({"tick_duration": tick_duration.get_total_text() + " sec"})
	if "{heal}" in text:
		text = text.format({"heal": gv.wrap_text_by_type(heal.get_total_text(), "health") + stack_text})
	if "{ticks}" in text:
		text = text.format({"ticks": fval.f(tick_duration.get_as_float() * ticks.get_as_float()) + " sec"})
	if "{applied_buffs}" in text:
		var applied_buff_text := ""
		var x = gv.temp_buff as UnitStatusEffect
		applied_buff_text += "\n[i]" + x.name + "[/i] - " + x.get_inactive_description()
		text = text.format({"applied_buffs": applied_buff_text})
	return text



func renew() -> void:
	if unlimited_ticks:
		return
	ticks.reset()
	ticks.current.add(1) # after it gets reset to 6 (for example), it gets increased to 7 for free.
	ticks.update_vico()
	
	target.vico.buff_vicos[type].update_tick_text()


func add_stack() -> void:
	if limited_stacks:
		stacks.add(1)
	else:
		stacks.current.add(1)
		stacks.update_vico()
	target.vico.buff_vicos[type].update_stack_text()



func dispell() -> void:
	stacks.subtract(1)
	if stacks.get_current().equal(0):
		remove_from_unit()
		return
	target.vico.buff_vicos[type].update_stack_text()



func remove_from_unit():
	marked_for_removal = true
	if has_vico:
		vico.kill()
	gv.emit_signal("remove_status_effect", target, self)



func tick() -> void:
	heal()
	deal_damage()
	deal_blood_loss()
	give_status_effect()
	
	last_tick_time = OS.get_ticks_msec()
	
	if not unlimited_ticks:
		ticks.subtract(1)
		if ticks.get_current().equal(0):
			remove_from_unit()
		target.vico.buff_vicos[type].update_tick_text()


func heal() -> void:
	if not has_heal:
		return
	var amount = Big.new(heal.get_randomized_total()).m(stacks.get_current())
	healer.heal(target, amount)


func deal_damage() -> void:
	if not deals_damage:
		return
	var amount = Big.new(damage.get_randomized_total()).m(stacks.get_current())
	target.take_damage(amount)


func deal_blood_loss() -> void:
	if not deals_blood_loss:
		return
	var amount = Big.new(blood_loss.get_randomized_total()).m(stacks.get_current())
	target.take_blood_loss(amount)


func give_status_effect() -> void:
	if not applies_buff:
		return
	target.take_status_effect(applied_buff)





func get_tick_percent() -> float:
	return get_tick_remaining() / tick_duration.get_as_float()


func get_tick_remaining() -> float:
	var tick_duration_in_msec = tick_duration.get_as_float() * 1000
	var current_time = OS.get_ticks_msec()
	return (tick_duration_in_msec - (current_time - last_tick_time)) / 1000
