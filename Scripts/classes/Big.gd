extends Reference

class_name Big

var mantissa:float = 0.0
var exponent:int = 1

const MAX_MANTISSA = 1209600

# for example: if two exponents are more than 17 apart, consider adding them together pointless, just return the larger one
const MAX_SIG_DIGITS: int = 17


func _init(m = 1.0, e = 0):
	
	match typeof(m):
		
		TYPE_STRING:
			
			parse(m)
		
		TYPE_OBJECT:
			
			mantissa = m.mantissa
			exponent = m.exponent
		
		_:
			
			mantissa = m
			exponent = e
	
	calc(self)


func parse(n, return_dict = false):
	
	if "e" in n:
		
		var parts = n.split("e")
		
		var m = float(parts[0].replace(",", ""))
		var e = int(parts[1])
		
		if return_dict:
			return {"mantissa": m, "exponent": e}
		
		mantissa = m
		exponent = e
		
		return
	
	
	var m = float(n)
	var e = 0
	
	if return_dict:
		return {"mantissa": m, "exponent": e}
	
	mantissa = m
	exponent = e


func type_check(n):
	
	match typeof(n):
		
		TYPE_INT, TYPE_REAL:
			
			return {"mantissa":float(n), "exponent":0}
		
		TYPE_STRING:
			
			return parse(n, true)
		
		_:
			
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
		return mantissa > n.mantissa
	
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
	
	return "e" + format_exponent(exponent) + dec

func format_exponent(value: int) -> String:
	
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


