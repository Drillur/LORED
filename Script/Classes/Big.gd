class_name Big
extends Resource



var saved_vars := [
	"mantissa",
	"exponent",
]

signal increased
signal decreased

signal change_cooldown_finished
signal increase_cooldown_finished
signal decrease_cooldown_finished

var increase_on_cooldown := false:
	set(val):
		increase_on_cooldown = val
		if val:
			if not gv.root_ready:
				await gv.root_ready_finished
			await gv.get_tree().physics_frame
			increase_on_cooldown = false
			emit_signal("increase_cooldown_finished")
var increase_queued := false

var decrease_on_cooldown := false:
	set(val):
		decrease_on_cooldown = val
		if val:
			if not gv.root_ready:
				await gv.root_ready_finished
			await gv.get_tree().physics_frame
			decrease_on_cooldown = false
			emit_signal("decrease_cooldown_finished")
var decrease_queued := false

var change_on_cooldown := false:
	set(val):
		change_on_cooldown = val
		if val:
			if not gv.root_ready:
				await gv.root_ready_finished
			await gv.get_tree().physics_frame
			change_on_cooldown = false
			emit_signal("change_cooldown_finished")
var change_queued := false

var mantissa: float = 0.0:
	set(val):
		if mantissa != val:
			mantissa = val
			text_requires_update = true
var exponent: int = 1:
	set(val):
		if exponent != val:
			exponent = val
			text_requires_update = true
var text: String:
	set(val):
		text = val
		text_requires_update = false
	get:
		if text_requires_update:
			if exponent < 6:
				text = Big.get_float_text(toFloat())
			else:
				text = toLog()
		return text
var text_requires_update := true

static var other = {"dynamic_decimals":true, "dynamic_numbers":4, "small_decimals":2, "thousand_decimals":2, "big_decimals":2, "scientific_decimals": 2, "logarithmic_decimals":2, "thousand_separator":".", "decimal_separator":",", "postfix_separator":"", "reading_separator":"", "thousand_name":"thousand"}

const MAX_MANTISSA = 1209600.0
const MANTISSA_PRECISSION = 0.0000001

const MIN_INTEGER: int = -9223372036854775807
const MAX_INTEGER: int = 9223372036854775806

var base := {"mantissa": 1.0, "exponent": 0}
var pending := {"mantissa": 1.0, "exponent": 0}
var emit_changes := true


func _init(mant = 1.0, e := 0):
	if mant is String:
		var scientific = mant.split("e")
		mantissa = float(scientific[0])
		if scientific.size() > 1:
			exponent = int(scientific[1])
		else:
			exponent = 0
	elif mant is Big or mant is Dictionary:
		mantissa = mant.mantissa
		exponent = mant.exponent
	else:
		_sizeCheck(mant)
		mantissa = mant
		exponent = e
	
	base.mantissa = mantissa
	base.exponent = exponent
	
	calculate(base)
	calculate(self)



func reset() -> void:
	mantissa = base.mantissa
	exponent = base.exponent
	pending.mantissa = 0.0
	pending.exponent = 0
	emit_decrease()
	calculate(self)


func do_not_emit() -> Big:
	emit_changes = false
	return self


func change_base(new_base: float) -> void:
	base.mantissa = new_base
	base.exponent = 0
	calculate(base)


func emit_change() -> void:
	if change_queued or not emit_changes:
		return
	if change_on_cooldown:
		change_queued = true
		await change_cooldown_finished
		change_queued = false
	emit_changed()
	change_on_cooldown = true


func emit_increase() -> void:
	if increase_queued or not emit_changes:
		return
	if increase_on_cooldown:
		increase_queued = true
		await increase_cooldown_finished
		increase_queued = false
	emit_signal("increased")
	increase_on_cooldown = true


func emit_decrease() -> void:
	if decrease_queued or not emit_changes:
		return
	if decrease_on_cooldown:
		decrease_queued = true
		await decrease_cooldown_finished
		decrease_queued = false
	emit_signal("decreased")
	decrease_on_cooldown = true



func _sizeCheck(mant):
	if mant > MAX_MANTISSA:
		printerr("BIG ERROR: MANTISSA TOO LARGE, PLEASE USE EXPONENT OR SCIENTIFIC NOTATION")


func type_check(n):
	if n is int or n is float:
		return {"mantissa":float(n), "exponent":int(0)}
	elif n is String:
		var split = n.split("e")
		return {"mantissa":float(split[0]), "exponent":int(0 if split.size() == 1 else split[1])}
	return n


func a(n) -> Big:
	n = type_check(n)
	if n.mantissa == 0.0 and n.exponent == 0:
		return self
	_sizeCheck(n.mantissa)
	var exp_diff = n.exponent - exponent
	if exp_diff < 248:
		var scaled_mantissa = n.mantissa * pow(10, exp_diff)
		mantissa += scaled_mantissa
	elif less(n):
		mantissa = n.mantissa #when difference between values is big, throw away small number
		exponent = n.exponent
	calculate(self)
	emit_increase()
	return self


func s(n) -> Big:
	n = type_check(n)
	if n.mantissa == 0.0 and n.exponent == 0:
		return self
	_sizeCheck(n.mantissa)
	var exp_diff = n.exponent - exponent
	if exp_diff < 248:
		var scaled_mantissa = n.mantissa * pow(10, exp_diff)
		mantissa -= scaled_mantissa
	elif less(n):
		mantissa = -MANTISSA_PRECISSION
		exponent = n.exponent
	calculate(self)
	emit_decrease()
	return self


func m(n) -> Big:
	n = type_check(n)
	if n.mantissa == 1.0 and n.exponent == 0:
		return self
	_sizeCheck(n.mantissa)
	var new_exponent = n.exponent + exponent
	var new_mantissa = n.mantissa * mantissa
	while new_mantissa >= 10.0:
		new_mantissa /= 10.0
		new_exponent += 1
	mantissa = new_mantissa
	exponent = new_exponent
	calculate(self)
	if n.mantissa > 1 or n.exponent > 0:
		emit_increase()
	elif n.exponent < 0:
		emit_decrease()
	return self


func d(n) -> Big:
	n = type_check(n)
	if n.mantissa == 1.0 and n.exponent == 0:
		return self
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
	emit_decrease()
	return self


func set_to(n) -> Big:
	n = type_check(n)
	_sizeCheck(n.mantissa)
	var new_exponent = n.exponent
	var new_mantissa = n.mantissa
	if new_exponent == exponent and new_mantissa == mantissa:
		return self
	var bigger: bool = (
		new_exponent > exponent
		or (new_exponent == exponent and new_mantissa > mantissa)
	)
	var smaller := false
	if not bigger:
		smaller = (
			new_exponent < exponent
			or (new_exponent == exponent and new_mantissa < mantissa)
		)
	mantissa = n.mantissa
	exponent = n.exponent
	
	calculate(self)
	if bigger:
		emit_increase()
	elif smaller:
		emit_decrease()
	return self


func add_pending(n) -> void:
	n = type_check(n)
	_sizeCheck(n.mantissa)
	var exp_diff = n.exponent - exponent
	if exp_diff < 248:
		var scaled_mantissa = n.mantissa * pow(10, exp_diff)
		pending.mantissa += scaled_mantissa
	elif less(n):
		pending.mantissa = n.mantissa #when difference between values is big, throw away small number
		pending.exponent = n.exponent
	calculate(pending)


func subtract_pending(n) -> void:
	n = type_check(n)
	_sizeCheck(n.mantissa)
	var exp_diff = n.exponent - exponent #abs?
	if exp_diff < 248:
		var scaled_mantissa = n.mantissa * pow(10, exp_diff)
		pending.mantissa -= scaled_mantissa
	elif less(n):
		pending.mantissa = -MANTISSA_PRECISSION
		pending.exponent = n.exponent
	calculate(pending)


func percent(n) -> float:
	n = type_check(n)
	if is_zero_approx(n.mantissa):
		printerr("Don't divide by 0 you fucking stupid bastard")
		return 0.0
	
	if exponent > n.exponent:
		return 1.0
	
	var exp_diff = n.exponent - exponent
	if exp_diff > 9:
		return 0.0
	
	var bla = {"mantissa": float(mantissa), "exponent": int(exponent)}
	
	bla.mantissa /= n.mantissa
	bla.exponent -= n.exponent
	
	calculate(bla)
	
	return clampf(bla.mantissa * pow(10, bla.exponent), 0.0, 1.0)


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
		if n % 2 == 0:
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
	emit_increase()
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
			emit_increase()
			return self
	
	# a bit slower, still supports floats
	var newExponent:int = int(temp)
	var residue:float = temp - newExponent
	var newMantissa = pow(10, n * log10(mantissa) + residue)
	if newMantissa != INF and newMantissa != -INF:
		mantissa = newMantissa
		exponent = newExponent
		calculate(self)
		emit_increase()
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
	n = type_check(n)
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
	if big.mantissa < 0:
		big.mantissa = 0.0
		big.exponent = 0
	if big is Big and big == self:
		emit_change() 


func equal(n) -> bool:
	n = type_check(n)
	calculate(n)
	return n.exponent == exponent and is_equal_approx(n.mantissa, mantissa)


func greater(n) -> bool:
	return not less_equal(n)


func greater_equal(n) -> bool:
	return not less(n)


func less(n) -> bool:
	n = type_check(n)
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
	n = type_check(n)
	calculate(n)
	if less(n):
		return true
	if n.exponent == exponent and is_equal_approx(n.mantissa, mantissa):
		return true
	return false



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


func logN(n):
	return (2.302585092994046 / log(n)) * (exponent + log10(mantissa))


func pow10(value:int):
	mantissa = pow(10, value % 1)
	exponent = int(value)


func toFloat() -> float:
	return snappedf(float(str(mantissa) + "e" + str(exponent)),0.01)


func toInt() -> int:
	return int(round(mantissa * pow(10, exponent)))




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
	return Big.get_float_text(mantissa) + "e" + format_exponent(exponent)

func toEngineering():
	var mod = exponent % 3
	return Big.get_float_text(mantissa * pow(10, mod)) + "e" + Big.get_float_text(exponent - mod)

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
