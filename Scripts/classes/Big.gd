class_name Big
extends Reference


export var mantissa:float = 0.0
export var exponent:int = 1

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

func reset():
	mantissa = 0.0
	exponent = 0

func resetToZero_ifNegative() -> void:
	if mantissa < 0:
		reset()

func calc(big = self):
	
	if big.exponent < -9:
		big.exponent = 0
		big.mantissa = 0.0
		return
	
	if big.mantissa >= 1 and big.mantissa < 10:
		return
	
	if is_zero_approx(big.mantissa):
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
	
	if is_zero_approx(n.mantissa):
		# prevents division of 0
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
	
	if is_zero_approx(n.mantissa):
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

func power(n):
	
	if n <= 0:
		mantissa = 1.0
		exponent = 0
		return self
	
	var y_mantissa = 1
	var y_exponent = 0
	
	
	# n is a floating point bullshit dick
	if "." in str(n):
		
		var dec = float(str(n).split(".")[1])
		
		mantissa = (log(dec) / log(10)) * 10
		
		n = int(floor(n))
		
		while n > 1:
			if n % 2 == 0: #n is even
				exponent *= 2
				mantissa *= mantissa
				n /= 2
			else:
				y_mantissa = mantissa * y_mantissa
				y_exponent = exponent + y_exponent
				exponent *= 2
				mantissa *= mantissa
				n = (n-1) / 2
		
		exponent = y_exponent + exponent
		mantissa = y_mantissa * mantissa
		
		calc()
		return self
	
	else:
		while n > 1:
			if n % 2 == 0: #n is even
				exponent = exponent + exponent
				mantissa = mantissa * mantissa
				n /= 2
			else:
				y_mantissa = mantissa * y_mantissa
				y_exponent = exponent + y_exponent
				exponent = exponent + exponent
				mantissa = mantissa * mantissa
				n = (n-1) / 2
	
	exponent = y_exponent + exponent
	mantissa = y_mantissa * mantissa
	
	calc()
	return self

func shitty_pow(n):
	
	# only works in intervals of 0.5.
	# will work with 1.5, 2, 2.5
	if typeof(n) == TYPE_OBJECT:
		n = n.toFloat()
	
	exponent *= n
	
	calc()
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


func nearly(n) -> bool:
	# if n is ~= self, return true
	# useful for checking quest progress. if close enough, just be done with it
	# useful for finishing off monsters with very nearly 0 hp
	n = type_check(n)
	calc(n)
	if is_zero_approx(n.mantissa) and exponent < 0:
		# example: exponent = -2, meaning 0.04
		return true
	return n.exponent == exponent and (n.mantissa > mantissa * 0.98 and n.mantissa < mantissa * 1.02)

func equal(n):
	n = type_check(n)
	calc(n)
	return n.mantissa == mantissa and n.exponent == exponent

func greater(n):
	
	n = type_check(n)
	calc(n)
	
	if is_zero_approx(mantissa):
		return false
	elif is_zero_approx(n.mantissa) and mantissa > 0:
		return true
	
	if exponent > n.exponent:
		return true
	elif exponent == n.exponent:
		return mantissa > n.mantissa
	
	return false

func greater_equal(n):
	if equal(n):
		return true
	return greater(n)

func isNegative() -> bool:
	return mantissa < 0

func less(n):
	
	n = type_check(n)
	calc(n)
	
	if mantissa > 0 and is_zero_approx(n.mantissa):
		return false
	if is_zero_approx(mantissa) and n.mantissa > 0.0:
		return true
	
	if exponent < n.exponent:
		return true
	elif exponent == n.exponent:
		return mantissa < n.mantissa
	
	return false

func less_equal(n):
	
	if equal(n):
		return true
	
	return less(n)

static func min(m, n):
	
	if m.less(n):
		return m
	
	return n

static func max(m, n):
	
	if m.greater(n):
		return m
	
	return n

func cap(_min, _max):
	capMin(_min)
	capMax(_max)
func capMax(n):
	if greater(n):
		mantissa = n.mantissa
		exponent = n.exponent
func capMin(n):
	if less(n):
		mantissa = n.mantissa
		exponent = n.exponent

func _round():
	if exponent <= 0:
		mantissa = round(mantissa)
	elif exponent == 1:
		mantissa = stepify(mantissa, 0.1)
	elif exponent == 2:
		mantissa = stepify(mantissa, 0.01)
	elif exponent == 3:
		mantissa = stepify(mantissa, 0.001)
	else:
		mantissa = stepify(mantissa, 0.0001)
	return self

func roundDown():
	if exponent <= 0:
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

func read() -> String:
	return toString()

func toString() -> String:
	
	if exponent < 6:
		return format_val_hub(toFloat())
	
	match gv.option["notation_type"]:
		0:
			return toScientific()
		1:
			return toEngineering()
		2:
			return toLog()
	
	return "oops"

func format_val_hub(value: float) -> String:
	
	if is_zero_approx(value):
		return "0"
	
	if value < 100.0:
		return format_val_small(value) # 10.0
	if value < 1000.0:
		return String(round(value)) # 100
	return format_val_medium(value) # 100,000
func format_val_small(value: float) -> String:
	
	# for numbers less than 100
	
	if value < 1:
		return String(stepify(value, 0.001)) # 0.059
	if value < 10:
		return String(stepify(value, 0.01)) # 5.43
	return String(stepify(value, .1)) # 22.8
func format_val_medium(value: float) -> String:
	
	# for numbers > 1,000 and < 1,000,000
	
	var string = str(round(value))
	var mod = string.length() % 3
	var output = ""
	
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			output += ","
		output += string[i]
	
	return output # 342,945

func toScientific():
	return format_val_hub(mantissa) + "e" + format_val_hub(exponent)

func toEngineering():
	
	var mod = exponent % 3
	return format_val_hub(mantissa * pow(10, mod)) + "e" + format_val_hub(exponent - mod)

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

func toInt() -> int:
	return int(mantissa * pow(10, exponent))


func save() -> String:
	return toScientific()

func load(in_scientific: String):
	parse(in_scientific)
