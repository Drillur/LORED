class_name SpellManager
extends Node



var OS_cast_begun: int
var cast_duration: float


var castbar: VBoxContainer # set in Scenes/Cavern
var hotbar: MarginContainer # set in Scenes/Cavern



func cast(caster: Unit, target: Unit, spell: Spell):
	
	if spell.has_cast_time:
		
		caster.casting = true
		
		castbar.cast(spell.type)
		
		cast_duration = spell.getCastTime(caster)
		
		var cast_begun = setCastBegun(caster)
		
		var t = Timer.new()
		add_child(t)
		t.start(cast_duration)
		yield(t, "timeout")
		t.queue_free()
		
		if not caster.casting or not caster.castMatch(cast_begun):
			print_debug("cast_begun mis-match: ", caster.cast_begun, "; expected ", cast_begun)
			# spell cast was cancelled
			return
		
		if spell.has_cd:
			startCooldown(caster, spell)
		
		caster.casting = false
		
		var tt = Timer.new()
		add_child(tt)
		tt.start(0.05)
		yield(tt, "timeout")
		tt.queue_free()
		
		gv.emit_signal("casting_completed")
	
	elif spell.is_channeled:
		
		channel(caster, target, spell)
		
		return
	
	if spell.has_cd:
		startCooldown(caster, spell)
	
	spell.castFin(caster, target)

func channel(caster: Unit, target: Unit, spell: Spell):
	
	caster.channeling = true
	
	var i: float = spell.getChannelDuration(caster)
	var tick_rate: float = spell.getChannelTickRate(caster)
	
	var t = Timer.new()
	add_child(t)
	
	castbar.cast(spell.type)
	
	var cast_begun = setCastBegun(caster)
	
	t.start(tick_rate)
	yield(t, "timeout")
	
	while caster.channeling and i > 0.0:
		
		if not caster.castMatch(cast_begun):
			break
		
		i -= tick_rate
		
		spell.channelTick(caster, target)
		
		t.start(tick_rate)
		yield(t, "timeout")
	
	t.queue_free()
	
	caster.channeling = false

func startCooldown(caster: Unit, spell: Spell):
	
	if not spell.isAvailable():
		return
	
	spell.cd.spellCast()
	
	var cd = spell.getCooldown(caster)
	
	hotbar.spellCast(spell.type, cd)
	
	var t = Timer.new()
	add_child(t)
	t.start(cd)
	yield(t, "timeout")
	t.queue_free()
	
	spell.cd.setAvailable()
	gv.emit_signal("cooldown_completed", spell.type)


func getCastRemaining() -> float:
	var in_msec := OS.get_ticks_msec() - OS_cast_begun
	var in_sec := float(in_msec) / 1000
	return max(cast_duration - in_sec, 0)

func setCastBegun(caster: Unit) -> int:
	caster.cast_begun = OS.get_ticks_msec()
	return caster.cast_begun
