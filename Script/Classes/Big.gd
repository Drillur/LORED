class_name Big
extends Resource


var mantissa: float = 0.0
var exponent: int = 1

const MAX_MANTISSA = 1209600

# for example: if two exponents are more than 17 apart, consider adding them together pointless, just return the larger one
const MAX_SIG_DIGITS: int = 17

func _init(_m = 1.0, _e = 0):
	
	match typeof(_m):
		
		TYPE_STRING:
			
			parse(_m)
		
		TYPE_OBJECT:
			
			mantissa = _m.mantissa
			exponent = _m.exponent
		
		_:
			
			mantissa = _m
			exponent = _e
	
	calc(self)


func parse(n, return_dict = false):
	
	if "e" in n:
		
		var parts = n.split("e")
		
		var _m = float(parts[0].replace(",", ""))
		var _e = int(parts[1])
		
		if return_dict:
			return {"mantissa": _m, "exponent": _e}
		
		mantissa = _m
		exponent = _e
		
		return
	
	
	var _m = float(n)
	var _e = 0
	
	if return_dict:
		return {"mantissa": _m, "exponent": _e}
	
	mantissa = _m
	exponent = _e


func type_check(n):
	match typeof(n):
		TYPE_INT, TYPE_FLOAT:
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
	
	var temp_exponent = floor(log(big.mantissa) / log(10))
	
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
		n = int(n)
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
	if n is int:
		if n == 0:
			return exponent == 0 and is_zero_approx(mantissa)
	
	n = type_check(n)
	calc(n)
	return n.exponent == exponent and is_equal_approx(n.mantissa, mantissa)

func equal(n):
	return nearly(n)

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
		if is_equal_approx(n.mantissa, mantissa):
			return false
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
		if is_equal_approx(n.mantissa, mantissa):
			return false
		return mantissa < n.mantissa
	
	return false

func less_equal(n):
	if equal(n):
		return true
	return less(n)

static func _min(_m, _n):
	if _m.less(_n):
		return _m
	return _n

static func _max(_m, _n):
	if _m.greater(_n):
		return _m
	return _n


func capMax(_n):
	if greater(_n):
		mantissa = _n.mantissa
		exponent = _n.exponent
	return self
func capMin(n):
	n = type_check(n)
	if less(n):
		mantissa = n.mantissa
		exponent = n.exponent
	return self

func _round():
	if exponent <= 0:
		mantissa = round(mantissa)
	elif exponent == 1:
		mantissa = snapped(mantissa, 0.1)
	elif exponent == 2:
		mantissa = snapped(mantissa, 0.01)
	elif exponent == 3:
		mantissa = snapped(mantissa, 0.001)
	else:
		mantissa = snapped(mantissa, 0.0001)
	return self

func roundDown():
	if exponent <= 0:
		mantissa = floor(mantissa)
	elif exponent == 1:
		mantissa = snapped(mantissa, 0.1)
	elif exponent == 2:
		mantissa = snapped(mantissa, 0.01)
	elif exponent == 3:
		mantissa = snapped(mantissa, 0.001)
	else:
		mantissa = snapped(mantissa, 0.0001)
	return self

func read() -> String:
	return toString()

func toString() -> String:
	
	calc(self)
	
	if exponent < 6:
		return format_val_hub(toFloat())
	
	if 1 == 1:
		return toLog()
#	match gv.option["notation_type"]:
#		0:
#			return toScientific()
#		1:
#			return toEngineering()
#		2:
#			return toLog()
	
	return "oops"

func format_val_hub(value: float) -> String:
	
	if is_zero_approx(value):
		return "0"
	
	if value < 100.0:
		return format_val_small(value) # 10.0
	if value < 1000.0:
		return str(round(value)) # 100
	return format_val_medium(value) # 100,000


func format_val_small(value: float) -> String:
	# for numbers less than 100
	if value < 1:
		return str(snapped(value, 0.001)) # 0.059
	if value < 10:
		return str(snapped(value, 0.01)) # 5.43
	return str(snapped(value, .1)) # 22.8


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
	var exponent_text = "e" + format_exponent(exponent)
	
	if exponent >= 1000:
		return exponent_text
	
	var dec := "."
	var altered_mantissa := log(mantissa) / log(10) * 10
	var padded_zeroes: int
	
	if exponent >= 100:
		padded_zeroes = 1
	else:
		padded_zeroes = 2
		altered_mantissa *= 10
	
	dec += str(floor(altered_mantissa)).pad_zeros(padded_zeroes)
	return exponent_text + dec


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

func _load(in_scientific: String):
	parse(in_scientific)
