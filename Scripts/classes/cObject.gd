class_name Ob
extends Reference



class Num:
	
	var f := Big.new(0) # current value
	
	var a := Big.new(0)
	var m := Big.new()
	
	var b: Big # base
	var t: Big # total after upgrades/buffs
	
	func _init(base = 1.0):
		b = Big.new(base)
		sync()
	
	func sync():
		
		t = Big.new(b)
		t.a(a)
		t.m(m)
		
		if f.isLessThan(0):
			f = Big.new(0)
		#f = Big.new(Big.min(f, t))

class Float:
	
	var f := 0.0 # current value
	
	var a := 0.0
	var m := 1.0
	
	var b: float # base
	var t: float # total after upgrades/buffs
	
	func _init(base = 1.0):
		b = base
		sync()
	
	func sync():
		
		t = b
		t += a
		t *= m
		
		if f < 0:
			f = 0.0
