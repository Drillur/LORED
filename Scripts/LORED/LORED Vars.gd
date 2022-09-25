class_name LOREDVars # lv
extends Node


enum Type {
	# New LOREDs must be added at the bottom.
	# When adding a new LORED, go to GlobalVars and in Icon, add a new 
	STONE,
	COAL,
	IRON_ORE,
	COPPER_ORE,
	IRON,
	COPPER,
	GROWTH,
	JOULES,
	CONCRETE,
	MALIGNANCY,
	TARBALLS,
	OIL,
	
	WATER,
	HUMUS,
	SEEDS,
	TREES,
	SOIL,
	AXES,
	WOOD,
	HARDWOOD,
	LIQUID_IRON,
	STEEL,
	SAND,
	GLASS,
	DRAW_PLATE,
	WIRE,
	GALENA,
	LEAD,
	PETROLEUM,
	WOOD_PULP,
	PAPER,
	PLASTIC,
	TOBACCO,
	CIGARETTES,
	CARCINOGENS,
	TUMORS,
	
}
enum Num {
	BASE,
	TOTAL,
	MULTIPLY,
	DIVIDE,
	ADD,
	ADD_FUEL,
	FROM_LEVELS,
	FROM_UPGRADES,
	BY_LORED_OUTPUT,
	BY_LORED_INPUT,
	BY_LIMIT_BREAK,
	BY_LORED_HASTE,
}

enum Job {
	
	STONE,
	COAL,
	IRON_ORE,
	COPPER_ORE,
	IRON,
	COPPER,
	GROWTH,
	JOULES,
	CONCRETE,
	MALIGNANCY,
	TARBALLS,
	OIL,
	
	WATER,
	HUMUS,
	SEEDS,
	TREES,
	SOIL,
	AXES,
	WOOD,
	HARDWOOD,
	LIQUID_IRON,
	STEEL,
	SAND,
	GLASS,
	DRAW_PLATE,
	WIRE,
	GALENA,
	LEAD,
	PETROLEUM,
	WOOD_PULP,
	PAPER,
	PLASTIC,
	TOBACCO,
	CIGARETTES,
	CARCINOGENS,
	TUMORS,
	
	REFUEL,
}

enum Mode {
	HIDDEN,
	STANDBY,
	ACTIVE,
}

enum Queue {
	OUTPUT,
	INPUT,
	COST,
	FUEL_STORAGE,
	FUEL_COST,
	CRIT,
	HASTE,
	UPDATE_PRODUCTION,
}

enum AlertType {
	LOW_FUEL,
	REQUIRED_RESOURCE_NOT_EXPORTING,
	NEGATIVE_PRODUCTION,
	ASLEEP,
}

enum FuelResourceDrain {
	NONE,
	DRAIN1,
	DRAIN2,
}

enum FuelProduction {
	NONE,
	GAIN,
	STABLE,
	DRAIN,
}

enum ReasonCannotBeginJob {
	LOW_FUEL,
	INSUFFICIENT_FUEL_RESOURCE,
	INSUFFICIENT_RESOURCES,
	LORED_NOT_EXPORTING,
}



var DEFAULT_KEY_LOREDS := [Type.STONE, Type.CONCRETE, Type.MALIGNANCY, Type.WATER, Type.LEAD, Type.TREES, Type.SOIL, Type.STEEL, Type.WIRE, Type.GLASS, Type.TUMORS, Type.WOOD]
var loreds_required_for_s2_autoup_upgrades_to_begin_purchasing := [Type.SEEDS, Type.TREES, Type.WATER, Type.SOIL, Type.HUMUS, Type.SAND, Type.GLASS, Type.LIQUID_IRON, Type.STEEL, Type.HARDWOOD, Type.AXES, Type.WOOD, Type.DRAW_PLATE, Type.WIRE]
var smallerAnimationList := [
	Type.STONE,
	Type.COAL,
	Type.IRON_ORE,
	Type.COPPER_ORE,
	Type.IRON,
	Type.COPPER,
	Type.GROWTH,
	Type.JOULES,
	Type.CONCRETE,
	Type.MALIGNANCY,
	Type.TARBALLS,
	Type.OIL,
	
	Type.WATER,
	Type.HUMUS,
	Type.SEEDS,
	Type.TREES,
	Type.WOOD,
	Type.HARDWOOD,
	Type.LIQUID_IRON,
	Type.SAND,
	Type.GLASS,
	Type.GALENA,
	Type.TOBACCO,
	Type.CIGARETTES,
]

var lored := {}
var loredByShorthand := {}


func _ready() -> void:
	#open()
	pass

func open():
	
	for type in Type.values():
		lored[type] = LOREDManager.new(type)
	
	initGain()
	initDrain()
	setLoredByShorthand()
	
	gv.loreds_required_for_s2_autoup_upgrades_to_begin_purchasing = loreds_required_for_s2_autoup_upgrades_to_begin_purchasing

func close():
	for x in ["lored", "gain", "gainUpdated", "gainBits", "drain", "drainUpdated", "drainBits", "net", "drainOrGainUpdated"]:
		set(x, {})


func save() -> String:
	
	var data := {}
	
	for x in lored:
		data[x] = lored[x].save()
	
	return var2str(data)

func load(data: Dictionary) -> void:
	for x in data:
		lored[x].load(str2var(data[x]))


func syncStage1and2_costModifier():
	for f in gv.list.lored[gv.Tab.S1]:
		lored[f].syncCostModifier()
	for f in gv.list.lored[gv.Tab.S2]:
		lored[f].syncCostModifier()


func syncLOREDs():
	for x in lored:
		lored[x].syncAll()

func setLoredByShorthand():
	for l in lored:
		loredByShorthand[lored[l].shorthandKey] = l




# - - - Production

var gain := {}
var gainUpdated := {}
var gainBits := {}

func initGain():
	for resource in gv.Resource.values():
		gainBits[resource] = Bits.new({
			Num.ADD: {},
		})
		gainUpdated[resource] = true
		drainOrGainUpdated[resource] = true

func updateGain(resource: int, lored: int, val: Big):
	gainBits[resource].setValue(Num.ADD, lored, val)
	gainUpdated[resource] = true
	drainOrGainUpdated[resource] = true

func gainRate(resource: int) -> Big:
	if gainUpdated[resource]:
		gain[resource] = gainBits[resource].total
		gainUpdated[resource] = false
	return gain[resource]

func reportGain(resource: int):
	print("---- ", gv.Resource.keys()[resource], " GAIN REPORT ----")
	print(" * Total: ", gainRate(resource).toString(), " *")
	#this goddamn shit does not work in the slightest. fucking fuck.
	gainBits[resource].report()


var drain := {}
var drainUpdated := {}
var drainBits := {}

func initDrain():
	for resource in gv.Resource.values():
		drainBits[resource] = Bits.new({
			Num.ADD: {}, # typical use goes here
			Num.ADD_FUEL: {}, # fuel use only goes here
		})
		drainUpdated[resource] = true
		drainOrGainUpdated[resource] = true

func updateDrain(resource: int, lored: int, val: Big):
	drainBits[resource].setValue(Num.ADD, lored, val)
	drainUpdated[resource] = true
	drainOrGainUpdated[resource] = true
func updateFuelDrain(resource: int, lored: int, val: Big):
	drainBits[resource].setValue(Num.ADD_FUEL, lored, val)
	drainUpdated[resource] = true
	drainOrGainUpdated[resource] = true

func drainRate(resource: int) -> Big:
	if drainUpdated[resource]:
		drain[resource] = drainBits[resource].total
		drainUpdated[resource] = false
	return drain[resource]

func reportDrain(resource: int):
	print("---- ", gv.Resource.keys()[resource], " DRAIN REPORT ----")
	print(" * Total: ", drainRate(resource).toString(), " *")
	#this goddamn shit does not work in the slightest. fucking fuck.
	drainBits[resource].report()


var net := {} # text only.
var drainOrGainUpdated := {}

func recalculateNet(resource: int):
	
	drainOrGainUpdated[resource] = false
	var gain: Big = Big.new(gainRate(resource))
	var drain: Big = Big.new(drainRate(resource))
	
	if gain.greater_equal(drain):
		net[resource] = gain.s(drain).toString()
	else:
		net[resource] = "-" + drain.s(gain).toString()

func netText(resource: int) -> String:
	if drainOrGainUpdated[resource]:
		recalculateNet(resource)
	return net[resource]

func net(resource: int) -> Array:
	
	var gain: Big = Big.new(gainRate(resource))
	var drain: Big = Big.new(drainRate(resource))
	
	# must return a Big, AND some value indicating if the big represents a positive or negative number
	# since Big class cannot handle negative numbers
	
	if gain.greater(drain):
		return [gain.s(drain), 1]
	if gain.equal(drain):
		return [Big.new(0), 0]
	return [drain.s(gain), -1]

func reportNet(resource: int):
	print(" * Net for ", gv.Resource.keys()[resource], ": ", netText(resource), " *")
	reportGain(resource)
	reportDrain(resource)


