class_name BitsFloat
extends Reference



var bits := {}

var base: float
var total: float setget , getTotal

var totalText: String setget , getTotalText

var totalUpdated := false



func _init(_bits: Dictionary):
	base = _bits[lv.Num.BASE]
	_bits.erase(lv.Num.BASE)
	bits = _bits


func changeBase(val: float):
	base = val

func getTotal() -> float:
	total = base
	for f in bits:
		if f == lv.Num.ADD:
			for g in bits[f]:
				total += bits[f][g]
		elif f == lv.Num.DIVIDE:
			for g in bits[f]:
				total /= bits[f][g]
		elif f == lv.Num.MULTIPLY:
			for g in bits[f]:
				total *= bits[f][g]
	totalUpdated = true
	return total


func getTotalText() -> String:
	if totalUpdated:
		totalUpdated = false
		totalText = fval.f(total)
	return totalText

func multiplyValue(folder: int, item: int, amount):
	# folder example: MULTIPLIER
	# item example: FROM_LEVELS
	bits[folder][item] *= amount
func divideValue(folder: int, item: int, amount):
	bits[folder][item] /= amount
func addToValue(folder: int, item: int, amount):
	bits[folder][item] += amount
func subtractFromValue(folder: int, item: int, amount):
	bits[folder][item] -= amount

func setValue(folder: int, item: int, amount):
	bits[folder][item] = amount

func reset():
	for f in bits:
		if f in [lv.Num.ADD, lv.Num.ADD_FUEL, lv.Num.SUBTRACT]:
			for g in bits[f]:
				bits[f][g] = 0.0
		else:
			for g in bits[f]:
				bits[f][g] = 1.0
	total = base
	totalUpdated = true
