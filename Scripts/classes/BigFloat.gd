#class_name BigFloat
#extends "res://Scripts/classes/BreakInfinity.gd"
#
#
#
#
#var mantissa: float
#var exponent: int
#
#
#func _init(_parameter = 1.0, _exponent := 0) -> void:
#
#	# _parameter may be a string, an int, a float, or another BigFloat
#
#	match typeof(_parameter):
#
#		TYPE_STRING:
#
#			var temp_BigFloat = parse(_parameter)
#
#			mantissa = temp_BigFloat.mantissa
#			exponent = temp_BigFloat.exponent
#
#		TYPE_OBJECT:
#
#			# _parameter is a BigFloat
#
#			mantissa = _parameter.mantissa
#			exponent = _parameter.exponent
#
#		_:
#
#			# _parameter is a float or int
#
#			if is_zero(_parameter):
#
#				zero()
#
#			elif exponent != 0:
#
#				mantissa = _parameter
#				exponent = _exponent
#
#			else:
#
#				var normalized_bigfloat = normalize(_parameter, 0)
#
#				mantissa = normalized_bigfloat.mantissa
#				exponent = normalized_bigfloat.exponent
##
##
#
##
##
##func is_zero(value) -> bool:
##	return abs(value) < EPSILON
##
##func _is_nan(value: BigFloat) -> bool:
##	return is_nan(value.mantissa)
##
##func is_positive_infinity(value) -> bool:
##
##	return value.mantissa == INF
##
##func is_negative_infinity(value) -> bool:
##	return value.mantissa == -INF
##
##func is_finite(value) -> bool:
##	return not is_nan(value) and not is_inf(value)
##
##func is_infinity(value: BigFloat) -> bool:
##	return is_inf(value.mantissa)
##
##
#
##
#
##
##
##
##func to_float() -> float:
##
##	if _is_nan(self):
##		return NAN
##
##	if exponent > EXPONENT_MAX:
##		return INF if mantissa > 0 else -INF
##
##	if exponent < EXPONENT_MIN:
##		return 0.0
##
##	if exponent == EXPONENT_MIN:
##		return 5e-324 if mantissa > 0 else -5e324
##
##	var result = mantissa * gv.pwrs.lookup(exponent)
##
##	if is_finite(result) or exponent < 0:
##		return result
##
##	var result_rounded = round(result)
##
##	if abs(result_rounded - result) < 1e-10:
##		return result_rounded
##
##	return result
##
##
##
##func zero():
##	mantissa = 0
##	exponent = 0
##func one():
##	return BigFloat.new(1, 0)
##func NaN():
##	return BigFloat.new(NAN, 0)
##func positive_infinity():
##	return BigFloat.new(INF, 0)
##func negative_infinity():
##	return BigFloat.new(-INF, 0)
