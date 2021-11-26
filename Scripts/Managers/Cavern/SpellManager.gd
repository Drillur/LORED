class_name SpellManager
extends Node



var castbar: VBoxContainer # set in Scenes/Cavern
var hotbar: MarginContainer # set in Scenes/Cavern



func cast(caster: Unit, target: Unit, spell: Spell):
	
	if spell.has_cast_time:
		
		caster.casting = true
		
		castbar.cast(spell.type)
		
		var t = Timer.new()
		add_child(t)
		t.start(spell.getCastTime(caster))
		yield(t, "timeout")
		t.queue_free()
		
		if not caster.casting:
			# spell cast was cancelled
			return
		
		if spell.has_cd:
			startCooldown(caster, spell)
		
		caster.casting = false
	
	elif spell.is_channeled:
		
		channel(caster, target, spell)
		
		return
	
	spell.castFin(caster, target)

func channel(caster: Unit, target: Unit, spell: Spell):
	
	caster.channeling = true
	
	var i: float = spell.getChannelDuration(caster)
	var tick_rate: float = spell.getChannelTickRate(caster)
	
	var t = Timer.new()
	add_child(t)
	
	castbar.cast(spell.type)
	
	t.start(tick_rate)
	yield(t, "timeout")
	
	while caster.channeling and i > 0.0:
		
		if caster.new_cast:
			break
		
		i -= tick_rate
		
		spell.channelTick(caster, target)
		
		t.start(tick_rate)
		yield(t, "timeout")
	
	if not caster.new_cast:
		caster.channeling = false
	else:
		caster.new_cast = false
	
	t.queue_free()

func startCooldown(caster: Unit, spell: Spell):
	
	spell.cd.spellCast()
	
	var cd = spell.getCooldown(caster)
	
	hotbar.spellCast(spell.type, cd)
	
	var t = Timer.new()
	add_child(t)
	t.start(cd)
	yield(t, "timeout")
	t.queue_free()
	
	spell.cd.setAvailable()
