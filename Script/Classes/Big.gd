class_name Big
extends RefCounted
# Big number class for use in idle / incremental games and other games that needs very large numbers
# Can format large numbers using a variety of notation methods:
# AA notation like AA, AB, AC etc.
# Metric symbol notation k, m, G, T etc.
# Metric name notation kilo, mega, giga, tera etc.
# Long names like octo-vigin-tillion or millia-nongen-quin-vigin-tillion (based on work by Landon Curt Noll)
# Scientic notation like 13e37 or 42e42
# Long strings like 4200000000 or 13370000000000000000000000000000
# Please note that this class has limited precision and does not fully support negative exponents
# Integer division warnings should be disabled in Project Settings

var mantissa: float = 0.0
var exponent: int = 1

const postfixes_metric_symbol = {"0":"", "1":"k", "2":"M", "3":"G", "4":"T", "5":"P", "6":"E", "7":"Z", "8":"Y", "9":"R", "10":"Q"}
const postfixes_metric_name = {"0":"", "1":"kilo", "2":"mega", "3":"giga", "4":"tera", "5":"peta", "6":"exa", "7":"zetta", "8":"yotta", "9":"ronna", "10":"quetta"}
static var postfixes_aa = {"0":"", "1":"k", "2":"m", "3":"b", "4":"t", "5":"aa", "6":"ab", "7":"ac", "8":"ad", "9":"ae", "10":"af", "11":"ag", "12":"ah", "13":"ai", "14":"aj", "15":"ak", "16":"al", "17":"am", "18":"an", "19":"ao", "20":"ap", "21":"aq", "22":"ar", "23":"as", "24":"at", "25":"au", "26":"av", "27":"aw", "28":"ax", "29":"ay", "30":"az", "31":"ba", "32":"bb", "33":"bc", "34":"bd", "35":"be", "36":"bf", "37":"bg", "38":"bh", "39":"bi", "40":"bj", "41":"bk", "42":"bl", "43":"bm", "44":"bn", "45":"bo", "46":"bp", "47":"bq", "48":"br", "49":"bs", "50":"bt", "51":"bu", "52":"bv", "53":"bw", "54":"bx", "55":"by", "56":"bz", "57":"ca"}
const alphabet_aa: Array[String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

const latin_ones: Array[String] = ["", "un", "duo", "tre", "quattuor", "quin", "sex", "septen", "octo", "novem"]
const latin_tens: Array[String] = ["", "dec", "vigin", "trigin", "quadragin", "quinquagin", "sexagin", "septuagin", "octogin", "nonagin"]
const latin_hundreds: Array[String] = ["", "cen", "duocen", "trecen", "quadringen", "quingen", "sescen", "septingen", "octingen", "nongen"]
const latin_special: Array[String] = ["", "mi", "bi", "tri", "quadri", "quin", "sex", "sept", "oct", "non"]

static var other = {"dynamic_decimals":true, "dynamic_numbers":4, "small_decimals":2, "thousand_decimals":2, "big_decimals":2, "scientific_decimals": 2, "logarithmic_decimals":2, "thousand_separator":".", "decimal_separator":",", "postfix_separator":"", "reading_separator":"", "thousand_name":"thousand"}

const MAX_MANTISSA = 1209600.0
const MANTISSA_PRECISSION = 0.0000001

const MIN_INTEGER: int = -9223372036854775807
const MAX_INTEGER: int = 9223372036854775806

func _init(m = 1.0, e := 0):
	if m is String:
		var scientific = m.split("e")
		mantissa = float(scientific[0])
		if scientific.size() > 1:
			exponent = int(scientific[1])
		else:
			exponent = 0
	elif m is Big:
		mantissa = m.mantissa
		exponent = m.exponent
	else:
		_sizeCheck(m)
		mantissa = m
		exponent = e
	calculate(self)
	pass


func _sizeCheck(m):
	if m > MAX_MANTISSA:
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


static func setDynamicDecimals(d):
	other.dynamic_decimals = bool(d)
	pass


static func setDynamicNumbers(d):
	other.dynamic_numbers = int(d)
	pass


static func setSmallDecimals(d):
	other.small_decimals = int(d)
	pass


static func setThousandDecimals(d):
	other.thousand_decimals = int(d)
	pass


static func setBigDecimals(d):
	other.big_decimals = int(d)
	pass


static func setScientificDecimals(d):
	other.scientific_decimals = int(d)
	pass


static func setLogarithmicDecimals(d):
	other.logarithmic_decimals = int(d)
	pass



func toFloat() -> float:
	return snappedf(float(str(mantissa) + "e" + str(exponent)),0.01)


func toInt() -> int:
	return int(round(mantissa * pow(10, exponent)))



func toString() -> String:
	if exponent < 6:
		return get_float_text(toFloat())
	return toLog()


func get_float_text(value: float) -> String:
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


func get_big_float_text(value: float) -> String:
	
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
	return get_float_text(mantissa) + "e" + get_float_text(exponent)

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
