extends Reference

class_name Big

var mantissa:float = 0.0
var exponent:int = 1

const MAX_MANTISSA = 1209600

func _init(m = 1,e=0):
	if typeof(m) == TYPE_STRING:
		var scientific = m.split("e")
		var bla = scientific[0].replace(",", "")
		mantissa = float(bla)
		if scientific.size() > 1:
			exponent = int(scientific[1])
		else:
			exponent = 0
	elif typeof(m) == TYPE_OBJECT:
		mantissa = m.mantissa
		exponent = m.exponent
	else:
		size_check(m)
		mantissa = m
		exponent = e
	calculate(self)

func size_check(m):
	return
	if m > MAX_MANTISSA:
		printerr("BIG ERROR: MANTISSA TOO LARGE, PLEASE USE EXPONENT OR SCIENTIFIC NOTATION")
		pass

func type_check(n):
	if typeof(n) == TYPE_INT or typeof(n) == TYPE_REAL:
		return {"mantissa":float(n), "exponent":0}
	elif typeof(n) == TYPE_STRING:
		if not "e" in n:
			return {"mantissa":float(n), "exponent":0}
		return {"mantissa":float(n.split("e")[0]), "exponent":int(n.split("e")[1])}
	else:
		return n

func plus(n):
	n = type_check(n)
	size_check(n.mantissa)
	var exp_diff = n.exponent - exponent
	var scaled_mantissa = n.mantissa * pow(10, exp_diff)
	mantissa += scaled_mantissa
	calculate(self)
	return self

func minus(n):
	n = type_check(n)
	size_check(n.mantissa)
	var exp_diff = n.exponent - exponent
	var scaled_mantissa = n.mantissa * pow(10, exp_diff)
	mantissa -= scaled_mantissa
	calculate(self)
	return self

func multiply(n):
	n = type_check(n)
	size_check(n.mantissa)
	var new_exponent = n.exponent + exponent
	var new_mantissa = n.mantissa * mantissa
	while new_mantissa >= 10.0:
		new_mantissa /= 10.0
		new_exponent += 1
	mantissa = new_mantissa
	exponent = new_exponent
	calculate(self)
	return self
	
func divide(n):
	n = type_check(n)
	size_check(n.mantissa)
	if n.mantissa == 0:
		#printerr("BIG ERROR: DIVIDE BY ZERO")
		return self
	
	var new_exponent = exponent - n.exponent
	var new_mantissa = mantissa / n.mantissa
	while new_mantissa < 1.0 and new_mantissa > 0.0:
		new_mantissa *= 10.0
		new_exponent -= 1
	mantissa = new_mantissa
	exponent = new_exponent
	calculate(self)
	return self

func power(n:int):
	if n < 0:
		#printerr("BIG ERROR: NEGATIVE EXPONENTS NOT SUPPORTED!")
		mantissa = 1.0
		exponent = 0
		return self
	if n == 0:
		mantissa = 1.0
		exponent = 0
		return self
	
	var y_mantissa = 1
	var y_exponent = 0
	
	while n > 1:
		if n % 2 == 0: #n is even
			exponent = exponent + exponent
			mantissa = mantissa * mantissa
			n = n / 2
		else:
			y_mantissa = mantissa * y_mantissa
			y_exponent = exponent + y_exponent
			exponent = exponent + exponent
			mantissa = mantissa * mantissa
			n = (n-1) / 2

	exponent = y_exponent + exponent
	mantissa = y_mantissa * mantissa
	calculate(self)
	return self

func square():
	if exponent % 2 == 0:
		mantissa = sqrt(mantissa)
		exponent = exponent/2
	else:
		mantissa = sqrt(mantissa*10)
		exponent = (exponent-1)/2
	calculate(self)
	return self

func calculate(big):
	if big.mantissa >= 10.0 or big.mantissa < 1.0:
		var diff = int(floor(log10(big.mantissa)))
		var div = pow(10.0, diff)
		if div > 0.0:
			big.mantissa /= div
			big.exponent += diff
	while big.exponent < 0:
		big.mantissa *= 0.1
		big.exponent += 1
	while big.mantissa >= 10.0:
		big.mantissa *= 0.1
		big.exponent += 1
	if big.mantissa == 0.0:
		big.exponent = 0
	pass

func isEqualTo(n):
	n = type_check(n)
	calculate(n)
	return n.mantissa == mantissa and n.exponent == exponent

func isLargerThan(n):
	n = type_check(n)
	calculate(n)
	
	if mantissa == 0.0:
		return false
	
	if exponent > n.exponent:
		return true
	elif exponent == n.exponent:
		if mantissa > n.mantissa:
			return true
		else:
			return false
	else:
		return false

func isLargerThanOrEqualTo(n):
	n = type_check(n)
	calculate(n)
	if isEqualTo(n):
		return true
	return isLargerThan(n)

func isNegative() -> bool:
	if exponent < 0:
		return true
	#elif exponent == 0:
	if mantissa < 0:
		return true
	if toScientific()[0] == "-":
		return true
	return false

func isLessThan(n):
	n = type_check(n)
	calculate(n)
	
	if mantissa == 0.0 and n.mantissa > 0.0:
		return true
	
	if exponent < n.exponent:
		return true
	elif exponent == n.exponent:
		if mantissa < n.mantissa:
			return true
		else:
			return false
	else:
		return false

func isLessThanOrEqualTo(n):
	n = type_check(n)
	calculate(n)
	if isEqualTo(n):
		return true
	return isLessThan(n)

static func min(m, n):
	if m.isLessThan(n):
		return m
	else:
		return n

static func max(m, n):
	if m.isLargerThan(n):
		return m
	else:
		return n

func roundDown():
	if exponent == 0:
		mantissa = floor(mantissa)
	elif exponent == 1:
		mantissa = stepify(mantissa, 0.1)
	elif exponent == 2:
		mantissa = stepify(mantissa, 0.01)
	elif exponent == 3:
		mantissa = stepify(mantissa, 0.001)
	else:
		mantissa = stepify(mantissa, 0.0001)
	return self

func log10(x):
	return log(x) * 0.4342944819032518

func toString():
	
	if exponent < 6:
		return fval.f(mantissa * pow(10, exponent))
	
	match gv.menu.option["notation_type"]:
		0:
			return toEngineering()
		1:
			return toScientific()
		2:
			return toLog()

func toScientific():
	return fval.f(mantissa) + "e" + fval.f(exponent)
func toEngineering():
	if exponent % 3 == 0:
		return toScientific()
	elif exponent % 3 == 1:
		return fval.f(mantissa * 10) + "e" + fval.f(exponent - 1)
	elif exponent % 3 == 2:
		return fval.f(mantissa * 100) + "e" + fval.f(exponent - 2)
func toLog():
	
#	if isLessThan(0):
#		return "-e" + fval.f(exponent)
	
	var dec = str(stepify(abs(log(mantissa) / log(10) * 10), 0.01))
	dec = dec.replace(".", "")
	
	if dec == "10":
		dec = "999"
	
	if dec != "0":
		dec = "." + dec
	else:
		dec = ""
	
	return "e" + fval.f(exponent) + dec


func toFloat():
	while exponent > 0:
		exponent -= 1
		mantissa *= 10
	return mantissa
	#return stepify(float(str(mantissa) + "e" + str(exponent)),0.01)
