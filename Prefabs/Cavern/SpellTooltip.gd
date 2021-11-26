extends MarginContainer




func init(_spell: int, caster: Unit):
	
	var spell: Spell = Cav.spell[_spell]
	
	get_node("m/v/name").text = spell.name
	get_node("m/v/desc").bbcode_text = spell.getDesc(caster)
	
	if spell.applies_buff:
		var data = caster.getData()
		get_node("m/v/buff").show()
		get_node("m/v/buff/name").text = gv.getBuffName(spell.applied_buff)
		get_node("m/v/buff/desc").bbcode_text = Buff.new(spell.applied_buff, data).getDesc()
		
	else:
		get_node("m/v/buff").hide()
	
	
	if spell.costs_stamina:
		get_node("m/v/m/m/v/costs/stamina").show()
		get_node("m/v/m/m/v/costs/stamina").text = spell.getStaminaCost(caster).toString() + " Stamina"
	else:
		get_node("m/v/m/m/v/costs/stamina").hide()
	
	if spell.costs_mana:
		get_node("m/v/m/m/v/costs/mana").show()
		get_node("m/v/m/m/v/costs/mana").text = spell.getManaCost(caster).toString() + " Mana"
	else:
		get_node("m/v/m/m/v/costs/mana").hide()
	
	if not spell.costs_stamina and not spell.costs_mana and not spell.costs_health:
		get_node("m/v/m/m/v/costs").hide()
	else:
		get_node("m/v/m/m/v/costs").show()
	
	
	if spell.is_channeled:
		get_node("m/v/m/m/v/cast").text = "Channeled"
	elif spell.has_cast_time:
		get_node("m/v/m/m/v/cast").text = fval.f(spell.getCastTime(caster)) + " Sec Cast"
	else:
		get_node("m/v/m/m/v/cast").text = "Instant Cast"
	
	
	if spell.has_cd:
		get_node("m/v/m/m/v/cd").show()
		get_node("m/v/m/m/v/cd").text = fval.f(spell.getCooldown(caster)) + " Sec Cooldown"
	else:
		get_node("m/v/m/m/v/cd").hide()
