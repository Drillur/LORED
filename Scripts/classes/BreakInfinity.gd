#class_name BreakInfinity
#extends Reference
#
#
#
#const EPSILON := 0.00001
#
#const TOLERANCE: float = 1e-18
#
#
#const EXPONENT_LIMIT: int = 9223372036854775807
#
## the largest exponent that can appear in a float, though not all mantissas are valid here.
#const EXPONENT_MAX = 308;
#
## The smallest exponent that can appear in a float, though not all mantissas are valid here.
#const EXPONENT_MIN = -324;
#
#
#class PowersOf10:
#
#	var index_of_0: int = (EXPONENT_MIN * -1) - 1
#	var powers := []
#
#	func _init():
#
#		for x in EXPONENT_MAX - EXPONENT_MIN:
#			powers.append(parse("1e" + str(x - index_of_0)))
#
#	func lookup(power: int):
#
#		return powers[index_of_0 + power]
#
#
#func parse(value: String) -> BigFloat:
#
#	if "e" in value:
#

#
#		return normalize(_mantissa, _exponent)
#
#	return BigFloat.new(parse_type_real(value) + "e0")
#
#func parse_type_real(value) -> String:
#
#	return value.replace(",", "")
#
#func normalize(_mantissa: float, _exponent: int):
#
#	if _mantissa >= 1 and _mantissa < 10 or is_finite(_mantissa):
#		return BigFloat.new(_mantissa, _exponent)
#
#	if is_zero(_mantissa):
#		return zero
#
#
#	var temp_exponent = floor(abs(log(_mantissa) / log(10)))
#
#	if temp_exponent == EXPONENT_MIN:
#
#		_mantissa = _mantissa * 10 / 1e-323
#
#	else:
#
#		_mantissa /= pow(10, temp_exponent)
#
#
#	return BigFloat.new(_mantissa, _exponent + temp_exponent)
