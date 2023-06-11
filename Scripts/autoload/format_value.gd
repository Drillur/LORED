class_name FormatValue
extends Node

# usage: format_val(110230912.1298371)
# outputs "110e6", "1.1e8", or "110m" based on notation option selected by user

# invoke with fval

enum NotationType {ENGINEERING, SCIENTIFIC}


#onready var rt = get_node("/root/Root")


func f(value: float) -> String:
	
	# warnings-disable
	
	# master func; redirects depending on value
	
	if is_zero_approx(value):
		return "0"
	
	var _sign := sign(value)
	value = abs(value)
	
	if value >= 1000000.0:
		match gv.option["notation_type"]:
			NotationType.ENGINEERING:
				return format_val_eng(_sign, value) # 20e6
			_: #NotationType.SCIENTIFIC:
				return format_val_sci(_sign, value) # 2e7
	
	if value < 100.0:
		return format_val_small(_sign, value) # 10.0
	if value < 1000.0:
		return String(round(_sign * value)) # 100
	return format_val_medium(_sign, value) # 100,000


func format_val_small(_sign: int, value: float) -> String:
	
	# for numbers less than 100
	
	if value < 1:
		return String(stepify(_sign * value, 0.001)) # 0.059
	if value < 10:
		return String(stepify(_sign * value, 0.01)) # 5.43
	return String(stepify(_sign * value, .1)) # 22.8


func format_val_medium(_sign: int, value: float) -> String:
	
	# for numbers > 1,000 and < 1,000,000
	
	var output := ""
	var i: int = value
	
	while i > 999:
		output = ",%03d%s" % [i % 1000, output]
		i /= 1000
	
	return "%s%s%s" % ["-" if value < 0 else "", i, output]


func format_val_eng(_sign: int, value: float) -> String:
	
	# engineering notation
	# example: 50e6
	
	var rounded: float = round(value)
	var _exp: float = stepify((String(rounded).length() - 1) - 1, 3)
	var coefficient := rounded / pow(10, _exp)
	
	return String(stepify(_sign * coefficient, step(coefficient))) + "e" + String(_exp)


func format_val_sci(_sign: int, value: float) -> String:
	
	# scientific notation
	# example: 5.0e7
	
	# 123,123,123.00123
	var _exp := String(value).split(".")[0].length() - 1
	var coefficient := value / pow(10, _exp)
	return String(stepify(_sign * coefficient, .01)) + "e" + String(_exp)


func step(coefficient: float) -> float:
	
	if coefficient < 10.0:
		return 0.01
	
	if coefficient < 100.0:
		return 0.1
	
	return 1.0


func time(val: float) -> String:
	
	if val > 3600:
		return str(int(val / 60 / 60)) + "h"
	
	if val > 60:
		return str(int(val / 60)) + "m"
	
	if val > 10:
		return str(round(val))
	
	return "%1.1f" % val

func time_accurate(val: float) -> String:
	
	if val < 10:
		return "%1.1f" % val + "s"
	
	if val < 60:
		return str(round(val)) + "s"
	
	var minutes := 0
	
	if val < 3600:
		
		minutes = int(val) / 60
		return "%00.f" % minutes + "m"
	
	var hours := 0
	
	hours = int(val) / 3600
	minutes = (int(val) % 3600) / 60
	return "%0.f" % hours + "h " + "%00.f" % minutes + "m"
