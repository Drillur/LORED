extends MarginContainer


const main := "v/m/v/"
const buff := "v/buff/v/"

const costs := "v/m/v/m/m/v/costs"
const stamina := "v/m/v/m/m/v/costs/stamina"
const mana := "v/m/v/m/m/v/costs/mana"
const cast := "v/m/v/m/m/v/cast"
const cd := "v/m/v/m/m/v/cd"


func init(_spell: int, caster: Unit):
	
	var spell: Spell = Cav.spell[_spell]
	
	get_node(main + "name").text = spell.name
	get_node(main + "desc").bbcode_text = spell.getDesc(caster)
	
	if spell.applies_buff:
		var data = caster.getData()
		get_node("v/buff").show()
		get_node(buff + "name").text = gv.getBuffName(spell.applied_buff)
		get_node(buff + "desc").bbcode_text = Buff.new(spell.applied_buff, data).getDesc()
		
	else:
		get_node("v/buff").hide()
	
	
	if spell.costs_stamina:
		get_node(stamina).show()
		get_node(stamina).text = spell.getStaminaCost(caster).toString() + " Stamina"
	else:
		get_node(stamina).hide()
	
	if spell.costs_mana:
		get_node(mana).show()
		get_node(mana).text = spell.getManaCost(caster).toString() + " Mana"
	else:
		get_node(mana).hide()
	
	if not spell.costs_stamina and not spell.costs_mana and not spell.costs_health:
		get_node(costs).hide()
	else:
		get_node(costs).show()
	
	
	if spell.is_channeled:
		get_node(cast).text = "Channeled"
	elif spell.has_cast_time:
		get_node(cast).text = fval.f(spell.getCastTime(caster)) + " Sec Cast"
	else:
		get_node(cast).text = "Instant Cast"
	
	
	if spell.has_cd:
		get_node(cd).show()
		get_node(cd).text = fval.f(spell.getCooldown(caster)) + " Sec Cooldown"
	else:
		get_node(cd).hide()
