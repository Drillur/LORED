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
		t.plus(a)
		t.multiply(m)
		
		f = Big.new(Big.max(f, 0))
		#f = Big.new(Big.min(f, t))
