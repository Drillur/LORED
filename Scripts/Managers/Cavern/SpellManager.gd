class_name SpellManager
extends Node



func cast(caster: Unit, target: Unit, spell: Spell):
	
	# if has cast time, begin casting now
	
	caster.casting = true
	
	var t = Timer.new()
	add_child(t)
	t.start(spell.getCastTime(caster))
	yield(t, "timeout")
	t.queue_free()
	
	if not caster.casting:
		# spell cast was cancelled
		return
	
	caster.casting = false
	
	spell.castFin(caster, target)

func channel(caster: Unit, target: Unit, spell: Spell):
	
	caster.casting = true
	
	var i: float = spell.getChannelDuration(caster)
	var tick_rate: float = spell.getChannelTickRate(caster)
	
	var t = Timer.new()
	add_child(t)
	
	while caster.casting and i > 0.0:
		
		t.start(tick_rate)
		yield(t, "timeout")
		
		i -= tick_rate
		
		spell.channelTick(caster, target)
	
	t.queue_free()
	
	

