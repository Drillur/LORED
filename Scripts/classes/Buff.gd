class_name Buff
extends "res://Scripts/classes/Object.gd"


var key: int
var target: LORED

var time_of_last_tick := 0
var duration: int
var duration_elapsed := 0.0

var constant_tick

var tick_count := 0
var ticks_max := 0 # leave at 0 if no ticks

var effect: Big
var effect2: Big


func _init(_key: int, _target: LORED) -> void:
	
	key = _key
	target = _target
	
	match key:
		gv.Buff.HEX:
			duration = 60
			effect = Big.new(1.5)
			effect2 = Big.new(target.d.t).m(0.01).m(target.speed.b / target.speed.t).m(60)
	
	apply()

func apply() -> void:
	
	target.manager.manage_buff(self)

func remove() -> void:
	
	target.buffs.erase(self)
	if target.buff_keys[key] > 1:
		target.buff_keys[key] -= 1
	else:
		target.buff_keys.erase(key)
	
	gv.active_buffs.erase(self)

func tick() -> void:
	
	var delta := 0.0
	delta += (OS.get_ticks_msec() - time_of_last_tick)
	delta /= 1000
	
	time_of_last_tick = OS.get_ticks_msec()
	
	if tick_count > 0:
		duration_elapsed += delta
	else:
		delta = 1.0
	
	tick_count += 1
	
	#rint("duration_elapsed: ", duration_elapsed)
	
	match key:
		
		gv.Buff.HEX:
			
			var val: Big = work()
			
			val.m(delta)
			
			gv.r[target.key].a(val)
			gv.increase_lb_xp(val)

func work():
	
	match key:
		gv.Buff.HEX:
			var val: Big
			var times = 0
			
			if target.witch.greater(0):
				times += 1
			times += target.buff_keys[key] - 1
			
			val = Big.new(effect2)
			for x in times:
				val.shitty_pow(effect)
			
			return val

func get_net() -> Big:
	
	match key:
		gv.Buff.HEX:
			return work()
	
	return Big.new(0)
