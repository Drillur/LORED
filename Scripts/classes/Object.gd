class_name Ob
extends Reference


# below, you will see poor variable names like a, um, lbm
# a always means add
# m always means multiply
# so in calculations, a adds, m multiplies
# a comes before m because duh
# for example, refer to sync() in class Num


class Num:
	
	var f := Big.new(0) # current value
	
	var a := Big.new(0)
	var m := Big.new()
	
	var ua := Big.new(0) # upgrade a (see top of script for wtf a means)
	var um := Big.new() # upgrade m
	
	var da := Big.new(0) # dynamic a
	var dm := Big.new() # dynamic m
	
	var haxm := 1.0
	
	#var spell_m := Big.new()
	
	var lbm := Big.new() # limit break m
	
	var b: Big # base
	var t: Big # total after upgrades/buffs
	
	func _init(base = 1.0):
		b = Big.new(base)
		sync()
	
	func print(include_f := false) -> String:
		if include_f:
			return f.toString() + "/" + t.toString()
		return t.toString()
	
	func dupe(): # duplicate
		return Big.new(b)
	
	func reset():
		f = Big.new(0)
		a = Big.new(0)
		m = Big.new()
		ua = Big.new(0)
		um = Big.new()
		da = Big.new(0)
		dm = Big.new()
		lbm = Big.new()
		t = Big.new(b)
	
	func sync(cap_f_to_t := false):
		
		# first, set total to base first
		t = Big.new(b)
		
		# then, begin modifying total
		t.a(a)
		t.a(ua)
		t.a(da)
		
		t.m(m)
		t.m(um)
		t.m(dm)
		t.m(lbm)
		
		t.m(haxm)
		
		if f.less(0):
			f = Big.new(0)
		if cap_f_to_t:
			if f.greater(t):
				f = Big.new(t)
	
	func report():
		
		# prints every value;
		# useful in finding errors
		
		print_debug("--REPORT::")
		print_debug("f: ", f.toString())
		print_debug("a: ", a.toString())
		print_debug("m: ", m.toString())
		print_debug("ua: ", ua.toString())
		print_debug("um: ", um.toString())
		print_debug("da: ", da.toString())
		print_debug("dm: ", dm.toString())
		print_debug("lbm: ", lbm.toString())
		print_debug("b: ", b.toString())
		print_debug("t: ", t.toString())

class Float:
	
	var f := 0.0 # current value
	
	var a := 0.0
	var m := 1.0
	
	var ua := 0.0
	var um := 1.0
	
	var haxm := 1.0
	var off_m := 1.0
	
	var b: float # base
	var t: float # total after upgrades/buffs
	
	func _init(base = 1.0):
		b = base
		haxm = gv.hax_pow
		sync()
	
	func print(include_f := false) -> String:
		if include_f:
			return str(f) + "/" + str(t)
		return str(t)
	
	func reset():
		f = 0.0
		a = 0.0
		m = 1.0
		ua = 0.0
		um = 1.0
		t = b
	
	func sync():
		
		t = b
		
		t += a
		t += ua
		
		t *= m
		t *= um
		
		t /= haxm
		t /= off_m
		
		if f < 0:
			f = 0.0

class Description:
	
	var f: String
	var base: String
	
	func _init(_base: String) -> void:
		base = _base
		f = base
