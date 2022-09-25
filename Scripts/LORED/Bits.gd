class_name Bits
extends Reference



var bits := {}

var base: Big
var total: Big setget , getTotal

var totalText: String setget , getTotalText

var totalUpdated := false



func _init(_bits: Dictionary):
	if lv.Num.BASE in _bits:
		base = Big.new(_bits[lv.Num.BASE])
		_bits.erase(lv.Num.BASE)
	else:
		base = Big.new(0)
	bits = _bits



func getTotal() -> Big:
	total = Big.new(base)
	for f in bits:
		if f == lv.Num.ADD or f == lv.Num.ADD_FUEL:
			for g in bits[f]:
				total.a(bits[f][g])
		elif f == lv.Num.DIVIDE:
			for g in bits[f]:
				total.d(bits[f][g])
		elif f == lv.Num.MULTIPLY:
			for g in bits[f]:
				total.m(bits[f][g])
	totalUpdated = true
	return total


func getTotalText() -> String:
	if totalUpdated:
		totalUpdated = false
		totalText = total.toString()
	return totalText



func multiplyValue(folder: int, item: int, amount):
	# folder example: MULTIPLIER
	# item example: FROM_LEVELS
	bits[folder][item].m(amount)


func setValue(folder: int, item: int, amount):
	bits[folder][item] = Big.new(amount)

func changeBase(val: Big):
	base = val

func report():
	for folder in bits:
		for item in bits[folder]:
			print(lv.Num.keys()[folder], "//", lv.Type.keys()[item], ": ", bits[folder][item].toString())
