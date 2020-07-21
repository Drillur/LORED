extends Reference

class_name Big

var mantissa:float = 0.0
var exponent:int = 1

const MAX_MANTISSA = 1209600

func _init(m = 1.0,e=0):
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
		mantissa = m
		exponent = e
	calc(self)

func type_check(n):
	if typeof(n) == TYPE_INT or typeof(n) == TYPE_REAL:
		return {"mantissa":float(n), "exponent":0}
	elif typeof(n) == TYPE_STRING:
		if not "e" in n:
			return {"mantissa":float(n), "exponent":0}
		return {"mantissa":float(n.split("e")[0]), "exponent":int(n.split("e")[1])}
	else:
		return n

func calc(big = self):
	
	if big.mantissa >= 1 and big.mantissa < 10:
		return
	
	if big.mantissa == 0.0:
		big.exponent = 0
		return
	
	var temp_exponent := floor(log(big.mantissa) / log(10))
	
	if temp_exponent < -10:
		big.exponent = 0
		big.mantissa = 0.0
		return
	
	big.exponent += temp_exponent
	big.mantissa /= pow(10, temp_exponent)

func percent(n):
	
	# gets self's percent of n
	
	n = type_check(n)
	
	if n.mantissa == 0.0:
		return 0.0
	
	var bla = {"mantissa": float(mantissa), "exponent": int(exponent)}
	
	bla.mantissa /= n.mantissa
	bla.exponent -= n.exponent
	
	calc(bla)
	
	return max(0.0, bla.mantissa * pow(10, bla.exponent))

func m(n):
	
	# multiplies self by n
	
	n = type_check(n)
	
	mantissa *= n.mantissa
	exponent += n.exponent
	
	calc()
	
	return self

func d(n):
	
	# divides self by n
	
	n = type_check(n)
	
	if n.mantissa == 0:
		return self
	
	mantissa /= n.mantissa
	exponent -= n.exponent
	
	calc()
	
	return self

func a(n):
	
	# adds n to self
	
	n = type_check(n)
	
	var exp_diff = n.exponent - exponent
	var scaled_mantissa = n.mantissa * pow(10, exp_diff)
	mantissa += scaled_mantissa
	
	calc()
	
	return self

func s(n):
	
	# subtracts n from self
	
	n = type_check(n)
	
	var exp_diff = n.exponent - exponent
	var scaled_mantissa = n.mantissa * pow(10, exp_diff)
	mantissa -= scaled_mantissa
	
	calc()
	
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
	calc(self)
	return self

func square():
	if exponent % 2 == 0:
		mantissa = sqrt(mantissa)
		exponent = exponent/2
	else:
		mantissa = sqrt(mantissa*10)
		exponent = (exponent-1)/2
	calc(self)
	return self


func isEqualTo(n):
	n = type_check(n)
	calc(n)
	return n.mantissa == mantissa and n.exponent == exponent

func isLargerThan(n):
	
	n = type_check(n)
	calc(n)
	
	if mantissa == 0.0:
		return false
	elif n.mantissa == 0.0 and mantissa > 0:
		return true
	
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
	if isEqualTo(n):
		return true
	return isLargerThan(n)

func isNegative() -> bool:
	return mantissa < 0

func isLessThan(n):
	
	n = type_check(n)
	calc(n)
	
	if mantissa > 0 and n.mantissa == 0:
		return false
	if mantissa == 0.0 and n.mantissa > 0.0:
		return true
	
	if exponent < n.exponent:
		return true
	elif exponent == n.exponent:
		return mantissa < n.mantissa
	else:
		return false

func isLessThanOrEqualTo(n):
	
	if isEqualTo(n):
		return true
	
	return isLessThan(n)

static func min(m, n):
	
	if m.isLessThan(n):
		return m
	
	return n

static func max(m, n):
	
	if m.isLargerThan(n):
		return m
	
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
	
	var mod = exponent % 3
	return fval.f(mantissa * pow(10, mod)) + "e" + fval.f(exponent - mod)

func toLog():
	
	var dec = "." + str(floor(abs(log(mantissa) / log(10) * 100))).pad_zeros(2)
	if dec == ".00":
		dec = ""
	return "e" + format_exponent(exponent) + dec

func format_exponent(value) -> String:
	
	if value < 1000:
		return str(value) # 100
	
	# above: for numbers < 1000
	# below: for numbers >= 1,000 and < 1,000,000
	
	var string = str(value)
	var mod = string.length() % 3
	var output = ""
	
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			output += ","
		output += string[i]
	
	return output # 342,945



func toFloat():
	return mantissa * pow(10, exponent)
