class_name Big
extends Resource




signal save_finished
signal load_finished


func save() -> String:
	var data := {}
	data["mantissa"] = var_to_str(mantissa)
	data["exponent"] = var_to_str(exponent)
	emit_signal("save_finished")
	return var_to_str(data)


func load_data(data_str: String) -> void:
	var data: Dictionary = str_to_var(data_str)
	mantissa = str_to_var(data["mantissa"])
	exponent = str_to_var(data["exponent"])
	emit_signal("load_finished")



var mantissa: float = 0.0
var exponent: int = 1

static var other = {"dynamic_decimals":true, "dynamic_numbers":4, "small_decimals":2, "thousand_decimals":2, "big_decimals":2, "scientific_decimals": 2, "logarithmic_decimals":2, "thousand_separator":".", "decimal_separator":",", "postfix_separator":"", "reading_separator":"", "thousand_name":"thousand"}

const MAX_MANTISSA = 1209600.0
const MANTISSA_PRECISSION = 0.0000001

const MIN_INTEGER: int = -9223372036854775807
const MAX_INTEGER: int = 9223372036854775806


func _init(mant = 1.0, e := 0):
	if mant is String:
		var scientific = mant.split("e")
		mantissa = float(scientific[0])
		if scientific.size() > 1:
			exponent = int(scientific[1])
		else:
			exponent = 0
	elif mant is Big:
		mantissa = mant.mantissa
		exponent = mant.exponent
	else:
		_sizeCheck(mant)
		mantissa = mant
		exponent = e
	calculate(self)
	pass


func _sizeCheck(mant):
	if mant > MAX_MANTISSA:
		printerr("BIG ERROR: MANTISSA TOO LARGE, PLEASE USE EXPONENT OR SCIENTIFIC NOTATION")


func _typeCheck(n):
	if typeof(n) == TYPE_INT or typeof(n) == TYPE_FLOAT:
		return {"mantissa":float(n), "exponent":int(0)}
	elif typeof(n) == TYPE_STRING:
		var split = n.split("e")
		return {"mantissa":float(split[0]), "exponent":int(0 if split.size() == 1 else split[1])}
	else:
		return n


func a(n) -> Big:
	n = _typeCheck(n)
	_sizeCheck(n.mantissa)
	var exp_diff = n.exponent - exponent
	if exp_diff < 248:
		var scaled_mantissa = n.mantissa * pow(10, exp_diff)
		mantissa += scaled_mantissa
	elif less(n):
		mantissa = n.mantissa #when difference between values is big, throw away small number
		exponent = n.exponent
	calculate(self)
	return self


func s(n) -> Big:
	n = _typeCheck(n)
	_sizeCheck(n.mantissa)
	var exp_diff = n.exponent - exponent #abs?
	if exp_diff < 248:
		var scaled_mantissa = n.mantissa * pow(10, exp_diff)
		mantissa -= scaled_mantissa
	elif less(n):
		mantissa = -MANTISSA_PRECISSION
		exponent = n.exponent
	calculate(self)
	return self


func m(n) -> Big:
	n = _typeCheck(n)
	_sizeCheck(n.mantissa)
	var new_exponent = n.exponent + exponent
	var new_mantissa = n.mantissa * mantissa
	while new_mantissa >= 10.0:
		new_mantissa /= 10.0
		new_exponent += 1
	mantissa = new_mantissa
	exponent = new_exponent
	calculate(self)
	return self


func d(n) -> Big:
	n = _typeCheck(n)
	_sizeCheck(n.mantissa)
	if n.mantissa == 0:
		printerr("BIG ERROR: d BY ZERO OR LESS THAN " + str(MANTISSA_PRECISSION))
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


func percent(n):
	
	# gets self's percent of n
	
	n = _typeCheck(n)
	
	if is_zero_approx(n.mantissa):
		# prevents division of 0
		return 0.0
	
	var bla = {"mantissa": float(mantissa), "exponent": int(exponent)}
	
	bla.mantissa /= n.mantissa
	bla.exponent -= n.exponent
	
	calculate(bla)
	
	return max(0.0, bla.mantissa * pow(10, bla.exponent))


func powerInt(n: int):
	if n < 0:
		printerr("BIG ERROR: NEGATIVE EXPONENTS NOT SUPPORTED!")
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
		calculate(self)
		if n % 2 == 0: #n is even
			exponent = exponent + exponent
			mantissa = mantissa * mantissa
			n = n / 2  # warning-ignore:integer_division
		else:
			y_mantissa = mantissa * y_mantissa
			y_exponent = exponent + y_exponent
			exponent = exponent + exponent
			mantissa = mantissa * mantissa
			n = (n-1) / 2  # warning-ignore:integer_division

	exponent = y_exponent + exponent
	mantissa = y_mantissa * mantissa
	calculate(self)
	return self


func power(n: float) -> Big:
	if mantissa == 0:
		return self

	# fast track
	var temp:float = exponent * n
	if round(n) == n and temp < MAX_INTEGER and temp > MIN_INTEGER and temp != INF and temp != -INF:
		var newMantissa = pow(mantissa, n)
		if newMantissa != INF and newMantissa != -INF:
			mantissa = newMantissa
			exponent = int(temp)
			calculate(self)
			return self

	# a bit slower, still supports floats
	var newExponent:int = int(temp)
	var residue:float = temp - newExponent
	var newMantissa = pow(10, n * log10(mantissa) + residue)
	if newMantissa != INF and newMantissa != -INF:
		mantissa = newMantissa
		exponent = newExponent
		calculate(self)
		return self

	if round(n) != n:
		printerr("BIG ERROR: POWER FUNCTION DOES NOT SUPPORT LARGE FLOATS, USE INTEGERS!")

	return powerInt(int(n))


func squareRoot() -> Big:
	if exponent % 2 == 0:
		mantissa = sqrt(mantissa)
		exponent = exponent/2
	else:
		mantissa = sqrt(mantissa*10)
		exponent = (exponent-1)/2
	calculate(self)
	return self


func modulo(n) -> Big:
	n = _typeCheck(n)
	_sizeCheck(n.mantissa)
	var big = {"mantissa":mantissa, "exponent":exponent}
	d(n)
	roundDown()
	m(n)
	s(big)
	mantissa = abs(mantissa)
	return self


func calculate(big):
	if big.mantissa >= 10.0 or big.mantissa < 1.0:
		var diff = int(floor(log10(big.mantissa)))
		if diff > -10 and diff < 248:
			var div = pow(10, diff)
			if div > MANTISSA_PRECISSION:
				big.mantissa /= div
				big.exponent += diff
	while big.exponent < 0:
		big.mantissa *= 0.1
		big.exponent += 1
	while big.mantissa >= 10.0:
		big.mantissa *= 0.1
		big.exponent += 1
	if big.mantissa == 0:
		big.mantissa = 0.0
		big.exponent = 0
	big.mantissa = snapped(big.mantissa, MANTISSA_PRECISSION)
	pass


func equal(n) -> bool:
	n = _typeCheck(n)
	calculate(n)
	return n.exponent == exponent and is_equal_approx(n.mantissa, mantissa)


func greater(n) -> bool:
	return not less_equal(n)


func greater_equal(n) -> bool:
	return not less(n)


func less(n) -> bool:
	n = _typeCheck(n)
	calculate(n)
	if mantissa == 0 and (n.mantissa > MANTISSA_PRECISSION or mantissa < MANTISSA_PRECISSION) and n.mantissa == 0:
		return false
	if exponent < n.exponent:
		return true
	elif exponent == n.exponent:
		if mantissa < n.mantissa:
			return true
		else:
			return false
	else:
		return false


func less_equal(n) -> bool:
	n = _typeCheck(n)
	calculate(n)
	if less(n):
		return true
	if n.exponent == exponent and is_equal_approx(n.mantissa, mantissa):
		return true
	return false


static func absValue(n) -> Big:
	n.mantissa = abs(n.mantissa)
	return n


func roundDown() -> Big:
	if exponent == 0:
		mantissa = floor(mantissa)
		return self
	else:
		var precision = 1.0
		for i in range(min(8, exponent)):
			precision /= 10.0
		if precision < MANTISSA_PRECISSION:
			precision = MANTISSA_PRECISSION
		mantissa = snapped(mantissa, precision)
		return self


func log10(x):
	return log(x) * 0.4342944819032518


func absLog10():
	return exponent + log10(abs(mantissa))


func ln():
	return 2.302585092994045 * logN(10)


func logN(base):
	return (2.302585092994046 / log(base)) * (exponent + log10(mantissa))


func pow10(value:int):
	mantissa = pow(10, value % 1)
	exponent = int(value)


static func setThousandName(name):
	other.thousand_name = name
	pass


static func setThousandSeparator(separator):
	other.thousand_separator = separator
	pass


static func setDecimalSeparator(separator):
	other.decimal_separator = separator
	pass


static func setPostfixSeparator(separator):
	other.postfix_separator = separator
	pass


static func setReadingSeparator(separator):
	other.reading_separator = separator
	pass



func toFloat() -> float:
	return snappedf(float(str(mantissa) + "e" + str(exponent)),0.01)


func toInt() -> int:
	return int(round(mantissa * pow(10, exponent)))



func toString() -> String:
	if exponent < 6:
		return get_float_text(toFloat())
	return toLog()


static func get_float_text(value: float) -> String:
	if value >= 1000:
		return get_big_float_text(value)
	if is_zero_approx(value):
		return "0"
	elif value < 1:
		return str(snappedf(value, 0.001))
	if value < 10:
		return str(snappedf(value, 0.01))
	elif value < 100:
		return str(snappedf(value, 0.1))
	return str(round(value))


static func get_big_float_text(value: float) -> String:
	
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
	return get_float_text(mantissa) + "e" + format_exponent(exponent)

func toEngineering():
	var mod = exponent % 3
	return get_float_text(mantissa * pow(10, mod)) + "e" + get_float_text(exponent - mod)

func toLog():
	var exponent_text := "e" + format_exponent(exponent)
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
		return str(value)
	var string = str(value)
	var mod = string.length() % 3
	var output = ""
	
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			output += ","
		output += string[i]
	
	return output
