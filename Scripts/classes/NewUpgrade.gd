class_name NewUpgrade
extends Reference

var saved_vars = ["refundable", "unlocked", "times_purchased", "have", "active"]

var description := "Hello! I'm a description!" setget setDescription, getDescription





var type: int
var tab: int
var stage: int

var normal: bool

var name: String

var icon: Texture setget , getIcon
var icon_key: String setget setIconKey

const costTemplate := {
	gv.NumType.BASE: Big,
	gv.NumType.TOTAL: Big,
	gv.NumType.MULTIPLY: {
		gv.NumType.FROM_UPGRADES: Big,
	},
}
var cost := {} setget , getCost

var effect := {}


var requiredUpgrades := []


var effects := []

var other = 0


var requires := []
var required_by := []
var requirements_met := true

var refundable := false
var stage_key: int
var color: Color
var unlocked := false
var times_purchased := 0

var manager: MarginContainer
var active_tooltip: MarginContainer
var active_tooltip_exists := false

var have := false
var active := true
var applied := false

var persist := 0
# if 1, persist will save this upgrade from being reset on a reset_type 1 reset
# but if s2 reset, while persist == 1, this upgrade WILL be reset






func _init(_type: int):
	
	type = _type
	
	call("construct_" + gv.Upgrade.keys()[type])
	
	setName()
	setTab()
	setColor()
	automateDescription()


func setName():
	name = gv.Upgrade.keys()[type].replace("_", " ").capitalize()
func setTab():
	match stage:
		1:
			if normal:
				tab = gv.Tab.NORMAL
			else:
				tab = gv.Tab.MALIGNANT
		2:
			if normal:
				tab = gv.Tab.EXTRA_NORMAL
			else:
				tab = gv.Tab.RADIATIVE
		3:
			if normal:
				tab = gv.Tab.RUNED_DIAL
			else:
				tab = gv.Tab.SPIRIT
func setColor():
	color = gv.COLORS[str(icon_key)] if str(icon_key) in gv.COLORS else gv.COLORS[tab]

func construct_GRINDER():
	stage = 1
	normal = true
	#setDescription("Stone haste x{e0}.")
	setIconKey("stone")
	addCost(90, gv.Lored.STONE)
	addEffect(1.25, gv.Effect.HASTE, gv.Lored.STONE)

func construct_UPGRADE_NAME():
	stage = 1
	normal = false
	#setDescription("Reduces the cost increase of every Stage 1 LORED from x3.0 to x2.75; Coal drain for fuel by Stage 1 LOREDs x{e0}")
	setIconKey(str(gv.Tab.S1))
	addCost("25e6", gv.Lored.MALIGNANCY)
	addEffect(10, gv.Effect.FUEL_DRAIN, gv.list.lored[gv.Tab.S1])
	addRequiredUpgrade(gv.Upgrade.ORE_LORED)



func automateDescription():
	if not description == null:
		return
	
	var desc: String
	for e in effect.size():
		desc += getEffectDescription(e)
	setDescription(desc)
func setDescription(text: String):
	description = text
func getDescription() -> String:
	var formattedDescription := description
	return formattedDescription

func setIconKey(_icon_key: String):
	icon_key = _icon_key
func getIcon() -> Texture:
	return gv.sprite[icon_key]

func addCost(amount, key: String):
	cost[key] = costTemplate.duplicate()
	cost[key][gv.NumType.BASE] = Big.new(amount)

func addRequiredUpgrade(key: int):
	requiredUpgrades.append(key)

func addEffect(_value: float, _type: int, _apply_to):
	
	if not _apply_to is Array:
		_apply_to = [_apply_to]
	
	effect[effect.size()] = {
		gv.Effect.VALUE: _value,
		gv.Effect.TYPE: _type,
		gv.Effect.APPLY_TO: _apply_to,
	}

func getEffectDescription(position: int) -> String:
	
	var desc: String
	
	if effect[position][gv.Effect.TYPE] in [gv.Effect.HASTE, gv.Effect.FUEL_DRAIN]:
		desc = "Multiplies the "
	
	desc += gv.Effect.keys()[effect[position][gv.Effect.TYPE]].to_lower()
	
	desc += " of "
	
	if effect[position][gv.Effect.APPLY_TO] == gv.list.lored[gv.Tab.S1]:
		desc += "every Stage 1 LORED"
	elif effect[position][gv.Effect.APPLY_TO] == gv.list.lored[gv.Tab.S2]:
		desc += "every Stage 2 LORED"
	elif effect[position][gv.Effect.APPLY_TO] == gv.list.lored[gv.Tab.S3]:
		desc += "every Stage 3 LORED"
	elif effect[position][gv.Effect.APPLY_TO] == gv.list.lored[gv.Tab.S4]:
		desc += "every Stage 4 LORED"
	else:
		
		var list = []
		for f in effect[position][gv.Effect.APPLY_TO]:
			list.append(gv.Lored.keys()[f].capitalize())
		desc += gv.commaifyAnArrayOfStrings(list)
	
	desc += " by "
	
	desc += str(effect[position][gv.Effect.VALUE])
	
	desc += "."
	
	return desc


func getCost() -> Dictionary:
	var cleanCost := {}
	for c in cost:
		cleanCost[c] = Big.new(cost[c][gv.NumType.TOTAL])
	return cleanCost



func sync():
	syncCost()


func syncCost():
	for c in cost:
		cost[c][gv.NumType.TOTAL] = Big.new(cost[c][gv.NumType.BASE])
		for x in cost[c][gv.NumType.MULTIPLY]:
			cost[c][gv.NumType.TOTAL].m(cost[c][gv.NumType.MULTIPLY][x])



func purchased():
	
	# for sXn upgrades. not sXm
	
	have = true
	active = true
	times_purchased += 1
	
	takeaway_price()
	apply()
	
	if "rebuy" in type:
		have = false

func apply():
	
	if applied:
		return
	
	if normal:
		gv.list.upgrade["unowned " + str(tab)].erase(key)
	
	for e in effects:
		e.apply(name)
	applied = true

func refund():
	
	if not refundable:
		return
	refundable = false
	sync_cost()
	for c in cost:
		gv.r[c].a(cost[c].t)

func remove(reset := false):
	
	for e in effects:
		if reset:
			e.reset(name)
		else:
			e.remove(name)
	
	applied = false



func takeaway_price():
	
	if key in ["ROUTINE"]:
		return
	
	for c in cost:
		gv.r[c].s(cost[c].t)

func sync_effects():
	
	for e in effects:
		e.sync()

func refresh():
	
	if applied:
		remove()
	sync()
	if active:
		apply()


func active(include_refundable := false) -> bool:
	if include_refundable:
		if refundable:
			return true
	return have and active

func sync_desc():
	
	desc.f = desc.base
	
	
	
	if "{other}" in desc.f:
		desc.f = desc.f.format({"other": other.print()})
	
	if effects.size() == 0:
		return
	
	while "{e" in desc.f:
		var i := int(desc.f.split("{e")[1][0])
		desc.f = desc.f.format({"e" + str(i): effects[i].effect.print()})

func get_effect_text(index: int):
	
	match effects[index].keys()[0]:
		"haste":
			return "haste x" + fval.f(effects[index].values()[0])
	
	return "oops"

func get_witch_percent() -> String:
	
	if gv.up["GRIMOIRE"].active():
		return fval.f(log(gv.run1)) + "%"
	
	return "1%"

func time_to_buy():
	
	if cost_check():
		return Big.new(0)
	
	var longest_time = Big.new(0)
	
	for c in cost:
		var time_to_c = gv.time_remaining_including_INF(c, gv.r[c], cost[c].t)
		if typeof(time_to_c) != TYPE_INT:
			return INF
		if time_to_c.greater(longest_time):
			longest_time = Big.new(time_to_c)
	
	return longest_time

func requirements() -> bool:
	
	for x in requires:
		
		if not (gv.up[x].have or gv.up[x].refundable):
			
			return false
	
	return true


func reset(reset_type := 0) -> bool:
	
	if reset_type > 0 and persist >= reset_type:
		return false
	
	remove(true)
	
	if normal:
		gv.list.upgrade["unowned " + str(tab)].append(key)
	
	refund()
	have = false
	active = true
	
	return true

func partial_reset():
	
	# for upgrades like IT'S GROWIN ON ME which needs to have its effect values reset
	for e in effects:
		e.effect.reset()

func saveEffects() -> void:
	if not "effects" in saved_vars:
		saved_vars.append("effects")



func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		if get(x) is Big:
			data[x] = get(x).save()
		elif x == "effects":
			data[x] = {}
			for c in get(x).size():
				data[x][c] = get(x)[c].save()
		else:
			data[x] = var2str(get(x))
	
	return var2str(data)

func load(data: Dictionary):
	
	for x in saved_vars:
		
		if not x in data.keys():
			continue
		
		if get(x) is Big:
			get(x).load(data[x])
		elif x == "effects":
			for c in get(x).size():
				if not c in data[x].keys():
					continue
				get(x)[c].load(str2var(data[x][c]))
		else:
			set(x, str2var(data[x]))


