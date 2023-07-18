class_name UnitAbility
extends Reference



enum Type {
	MEND,
	
	CURE,
	REGENERATE,
	CLEANSE,
	HEAL,
	REJUVENATE,
	SHIELD,
}

const WILL_NOT_USE_CURRENT := false

var type: int
var school: int

var vico_assigned := false
var vico: MarginContainer setget set_vico
func set_vico(_vico: MarginContainer) -> void:
	vico = _vico
	vico_assigned = true

var key: String
var name: String
var cost_text: String
var description: String
var school_text: String

var blood_taken_from_pool: Big
var blood_taken_from_target: Big
var blood_taken_from_healer: Big

var cast_time: Attribute
var has_cast_time: bool

var mana_cost: Attribute
var has_mana_cost: bool

var flower_cost := -1
var has_flower_cost: bool

var blood_cost: Attribute
var has_blood_cost: bool

var initial_heal: Attribute
var has_initial_heal: bool

var barrier: Attribute
var has_barrier: bool

var is_on_cooldown: bool
var time_cooldown_began: int
var cooldown: Attribute
var has_cooldown: bool

var applied_buffs := []
var applies_buffs: bool

var dispells_buffs := false
var dispells_debuffs := false

var just_cast := false

var icon: Texture



func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	name = key.capitalize()
	
	var init_method = "init_" + key
	call(init_method)
	
	has_cast_time = cast_time != null
	has_mana_cost = mana_cost != null
	has_flower_cost = flower_cost > -1
	has_blood_cost = blood_cost != null
	has_initial_heal = initial_heal != null
	has_cooldown = cooldown != null
	applies_buffs = not applied_buffs.empty()
	has_barrier = barrier != null
	
	init_school_text()


func init_MEND():
	cast_time = Attribute.new(3, WILL_NOT_USE_CURRENT)
	initial_heal = Attribute.new(1, WILL_NOT_USE_CURRENT)
	school = gv.AbilitySchool.HIEROMANCY
	mana_cost = Attribute.new(4, WILL_NOT_USE_CURRENT)
	icon = preload("res://Sprites/flowers/082.png")
	description = "Restores {initial_heal} to a single target. Gets the job done."
	cost_text = "Costs {mana_cost}."


func init_CURE():
	cast_time = Attribute.new(2.5, WILL_NOT_USE_CURRENT)
	initial_heal = Attribute.new(5, WILL_NOT_USE_CURRENT)
	flower_cost = Flower.Type.MORNING_GLORY
	school = gv.AbilitySchool.ANTHOMANCY
	icon = preload("res://Sprites/flowers/006.png")
	description = "Restores {initial_heal} to a single target."
	cost_text = "Costs {flower_cost}."


func init_REGENERATE():
	flower_cost = Flower.Type.YARROW
	school = gv.AbilitySchool.ANTHOMANCY
	icon = preload("res://Sprites/flowers/007.png")
	description = "Applies [i]Regenerating[/i] to a single target.{applied_buffs}"
	cost_text = "Costs {flower_cost}."
	applied_buffs.append(UnitStatusEffect.new(UnitStatusEffect.Type.REGENERATING))


func init_CLEANSE():
	flower_cost = Flower.Type.GINGER_ROOT
	school = gv.AbilitySchool.ANTHOMANCY
	cooldown = Attribute.new(8, WILL_NOT_USE_CURRENT)
	icon = preload("res://Sprites/flowers/008.png")
	description = "Dispells one harmful effect from a target."
	cost_text = "Costs {flower_cost}."
	dispells_debuffs = true


func init_HEAL():
	cast_time = Attribute.new(2.5, WILL_NOT_USE_CURRENT)
	initial_heal = Attribute.new(15, WILL_NOT_USE_CURRENT)
	flower_cost = Flower.Type.DAISY
	school = gv.AbilitySchool.ANTHOMANCY
	icon = preload("res://Sprites/flowers/043.png")
	description = "Restores {initial_heal} to a single target."
	cost_text = "Costs {flower_cost}."


func init_REJUVENATE():
	flower_cost = Flower.Type.LAVENDER
	school = gv.AbilitySchool.ANTHOMANCY
	icon = preload("res://Sprites/flowers/021.png")
	description = "Applies [i]Rejuvenating[/i] to a single target.{applied_buffs}"
	cost_text = "Costs {flower_cost}."
	applied_buffs.append(UnitStatusEffect.new(UnitStatusEffect.Type.REJUVENATING))


func init_SHIELD():
	flower_cost = Flower.Type.CARNATION
	cooldown = Attribute.new(15, WILL_NOT_USE_CURRENT)
	barrier = Attribute.new(30, WILL_NOT_USE_CURRENT)
	school = gv.AbilitySchool.ANTHOMANCY
	icon = preload("res://Sprites/flowers/090.png")
	description = "Adds {barrier} to a single target."
	cost_text = "Costs {flower_cost}."



func init_school_text() -> void:
	var color: Color
	match school:
		gv.AbilitySchool.HIEROMANCY:
			color = Color(1, 0.917647, 0)
		gv.AbilitySchool.ANTHOMANCY:
			color = gv.COLORS["ANTHOMANCY"]
		gv.AbilitySchool.HEMOMANCY:
			color = gv.COLORS["BLOOD"]
	school_text = "[center][color=#" + color.to_html() + "]" + gv.AbilitySchool.keys()[school].capitalize()




# - Get

func get_description() -> String:
	var text := description
	if "{applied_buffs}" in description:
		var applied_buff_text := ""
		for x in applied_buffs:
			x = x as UnitStatusEffect
			applied_buff_text += "\n[i]" + x.name + "[/i] - " + x.get_inactive_description()
		text = text.format({"applied_buffs": applied_buff_text})
	if "{initial_heal}" in text:
		text = text.format({"initial_heal": gv.wrap_text_by_type(initial_heal.get_total_text(), "health")})
	if "{barrier}" in text:
		text = text.format({"barrier": gv.wrap_text_by_type(barrier.get_total_text(), "barrier")})
	return "[center]" + text


func get_cost_text() -> String:
	var text := cost_text
	if "{mana_cost}" in text:
		text = text.format({"mana_cost": gv.wrap_text_by_type(mana_cost.get_total_text(), "mana")})
	if "{flower_cost}" in text:
		text = text.format({
			"flower_cost":
				"1 " + "[img=<16>]" + Flower.get_flower_icon(flower_cost).get_path() + "[/img] " + Flower.get_flower_name(flower_cost)
		})
	return "[center]" + text


func get_cast_time_as_float() -> float:
	if has_cast_time:
		return cast_time.get_total().toFloat()
	return 0.0


func get_cast_time_text() -> String:
	return fval.f(get_cast_time_as_float())


func is_instant_cast() -> bool:
	return not has_cast_time



# - Action

func is_on_cooldown() -> bool:
	if gv.get_gcd_remaining() > 0.0:
		return true
	if not has_cooldown:
		return false
	return is_on_cooldown


func get_cooldown_percent() -> float:
	if is_on_cooldown:
		if gv.get_gcd_remaining() < get_cooldown_remaining():
			return get_cooldown_remaining() / cooldown.get_as_float()
	return gv.get_gcd_percent()


func get_cooldown_remaining() -> float:
	if is_on_cooldown:
		var cooldown_in_msec = cooldown.get_as_float() * 1000
		var current_time = OS.get_ticks_msec()
		return max((cooldown_in_msec - (current_time - time_cooldown_began)) / 1000, gv.get_gcd_remaining())
	return gv.get_gcd_remaining()


func start_cooldown() -> void:
	if not has_cooldown:
		return
	time_cooldown_began = OS.get_ticks_msec()
	is_on_cooldown = true
	vico.process_cooldown()


func stop_cooldown() -> void:
	is_on_cooldown = false



func can_afford_to_cast(target: Unit) -> bool:
	if has_mana_cost:
		if healer.mana.get_current().less(mana_cost.get_total()):
			lv.lored[lv.Type.BLOOD].cannot_cast_ability(lv.ReasonCannotBeginJob.INSUFFICIENT_MANA, self)
			return false
	
	if has_blood_cost:
		var combined_blood = Big.new(gv.resource[gv.Resource.BLOOD]).a(healer.blood.get_current()).a(target.blood.get_current())
		if combined_blood.less(blood_cost.get_total()):
			lv.lored[lv.Type.BLOOD].cannot_cast_ability(lv.ReasonCannotBeginJob.INSUFFICIENT_BLOOD, self)
			return false
	
	if has_flower_cost and not gv.dev_mode:
		if Flower.get_flower_count(flower_cost) < 1:
			lv.lored[lv.Type.BLOOD].cannot_cast_ability(lv.ReasonCannotBeginJob.INSUFFICIENT_FLOWERS, self)
			return false
	
	return true


func takeaway_costs(target: Unit) -> void:
	if has_mana_cost:
		healer.mana.subtract(mana_cost.get_total())
	
	if has_blood_cost:
		var remaining_cost = Big.new(blood_cost.get_total())
		if gv.resource[gv.Resource.BLOOD].greater_equal(remaining_cost):
			gv.subtractFromResource(gv.Resource.BLOOD, remaining_cost)
			blood_taken_from_pool = Big.new(remaining_cost)
		else:
			remaining_cost.s(gv.resource[gv.Resource.BLOOD])
			blood_taken_from_pool = Big.new(gv.resource[gv.Resource.BLOOD])
			gv.setResource(gv.Resource.BLOOD, 0)
			if target.blood.get_current().greater(healer.blood.get_current()):
				if target.blood.get_current().greater(remaining_cost):
					target.blood.subtract(remaining_cost)
					blood_taken_from_target = Big.new(remaining_cost)
				else:
					remaining_cost.s(target.blood.get_current())
					blood_taken_from_target = Big.new(target.blood.get_current())
					target.blood.set_to(0)
					healer.blood.subtract(remaining_cost)
					blood_taken_from_healer = Big.new(remaining_cost)
			else:
				if healer.blood.get_current().greater(remaining_cost):
					healer.blood.subtract(remaining_cost)
					blood_taken_from_healer = remaining_cost
				else:
					remaining_cost.s(healer.blood.get_current())
					blood_taken_from_healer = healer.blood.get_current()
					healer.blood.set_to(0)
					target.blood.subtract(remaining_cost)
					blood_taken_from_target = remaining_cost
	
	if has_flower_cost and not gv.dev_mode:
		Flower.subtract_flower(flower_cost, 1)


func apply_effects(target: Unit) -> void:
	if has_initial_heal:
		healer.heal(target, initial_heal.get_randomized_total())
	if applies_buffs:
		for buff in applied_buffs:
			target.take_status_effect(buff.type)
	if dispells_debuffs:
		target.dispell_status_effect()
	if has_barrier:
		target.take_barrier(barrier.get_total())

