class_name Cacodemon
extends "res://Scripts/classes/cPurchasable.gd"



var level := Big.new(1)

var d := Num.new(1)
var output_mod := Big.new(1)
var inhand := Big.new(1)
var xp := Num.new(4)
var xp_gain := Num.new(1)

var progress := Float.new(500) # increments in terms of delta * 100

var active := false



func _init(_key: int) -> void:
	
	key = _key
	
	setup()


func setup():
	
	inhand = Big.new(d.t)
	
	pass


func sync():
	
	d.sync()
	progress.sync()
	xp.sync()
	xp_gain.sync()



func work():
	
	if progress.f >= progress.t:
		
		progress.f = 0.0
		
		xp()
		
		gv.r[gv.R.consumed_spirit].a(consumed_spirit_gain(inhand))
		
		inhand = Big.new(d.t)
		
	
	
func consumed_spirit_gain(base: Big) -> Big:
	
	var gain: Big = Big.new(log(base.mantissa) / log(10))#Big.new(base).d(100)
	
	gain.a(max(base.exponent + 1, 1))
	gain.m(output_mod)
	gain.d(100)
	
	return gain

func xp():
	
	xp.f.a(xp_gain.t)
	gv.emit_signal("cac_xp_gained", key)
	
	if xp.f.isLessThan(xp.t):
		return
	
	level_up()

func level_up():
	
	level.a(1)
	
	xp.f.s(xp.t)
	xp.m.m(1.25)
	
	d.m.m(2)
	output_mod.m(1.1)
	
	progress.m *= 1.03
	
	sync()
	
	gv.emit_signal("cac_leveled_up", key)


