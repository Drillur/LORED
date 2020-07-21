class_name BigFloat
extends Reference



const EPSILON := 0.00001

const TOLERANCE: float = 1e-18

# for example: if two exponents are more than 17 apart, consider adding them together pointless, just return the larger one
const MAX_SIG_DIGITS: int = 17

const EXPONENT_LIMIT: int = 9223372036854775807

# the largest exponent that can appear in a float, though not all mantissas are valid here.
const EXPONENT_MAX = 308;

# The smallest exponent that can appear in a float, though not all mantissas are valid here.
const EXPONENT_MIN = -324;


var mantissa: float
var exponent: int

var zero: BigFloat = BigFloat.new(0, 0)
var one: BigFloat = BigFloat.new(1, 0)
#var NaN: BigFloat = BigFloat.new(, 0)



func _init(_parameter = 1.0, _exponent := 0) -> void:
	
	# _parameter may be a string, an int, a float, or another BigFloat
	
	match typeof(_parameter):
		
		TYPE_STRING:
			
			var scientific = _parameter.split("e")
			
			mantissa = float(scientific[0].replace(",", ""))
			
			if scientific.size() > 1:
				exponent = int(scientific[1])
			else:
				exponent = 0
		
		TYPE_OBJECT:
			
			# _parameter is a BigFloat
			
			mantissa = _parameter.mantissa
			exponent = _parameter.exponent
		
		_:
			
			# _parameter is a float or int
			
			if is_zero(_parameter):
				
				mantissa = zero.mantissa
				exponent = zero.exponent
			
			elif exponent != 0:
				
				mantissa = _parameter
				exponent = _exponent
			
			else:
				
				var normalized_bigfloat = normalize(_parameter, 0)
				
				mantissa = normalized_bigfloat.mantissa
				exponent = normalized_bigfloat.exponent


func normalize(_mantissa: float, _exponent: int):
	
	if _mantissa >= 1 and _mantissa < 10 or is_finite(_mantissa):
		return BigFloat.new(_mantissa, _exponent)
	
	if is_zero(_mantissa):
		return zero
	
	
	var temp_exponent = floor(abs(log(_mantissa) / log(10)))
	
	if temp_exponent == EXPONENT_MIN:
		
		_mantissa = _mantissa * 10 / 1e-323
	
	else:
		
		_mantissa /= pow(10, temp_exponent)
	
	
	return BigFloat.new(_mantissa, _exponent + temp_exponent)


func is_zero(value) -> bool:
	
	return abs(value) < EPSILON

func _is_nan(value: BigFloat) -> bool:
	
	return is_nan(value.mantissa)

func is_finite(value) -> bool:
	
	return not is_nan(value) and not is_inf(value)

func is_infinity(value: BigFloat) -> bool:
	
	return is_inf(value.mantissa)
