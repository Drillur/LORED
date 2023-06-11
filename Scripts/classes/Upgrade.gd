class_name Upgrade
extends "res://Scripts/classes/Purchasable.gd"



var saved_vars = ["refundable", "unlocked", "have", "active"]

var desc := Description.new("description")

var effects := []

var other = 0


var requires := []
var required_by := []
var requirements_met := true

var refundable := false
var icon: String = "" # same as icon_key
var stage_key: int
var tab: int
var color: Color
var unlocked := false

var manager: UpgradeBlock
var active_tooltip: MarginContainer
var active_tooltip_exists := false

var have := false
var active := true
var applied := false

var persist := 0
# if 1, persist will save this upgrade from being reset on a reset_type 1 reset
# but if s2 reset, while persist == 1, this upgrade WILL be reset

var normal: bool





func _init(
		_name: String,
		_type,
		_desc,
		_icon = str(gv.Tab.NORMAL)
	) -> void:
	
	name = _name
	key = _name
	desc.base = _desc
	
	type = _type
	
	stage = type[1]
	stage_key = int(type[1]) - 1 + gv.Tab.S1
	normal = true if "n" == type[2] else false
	
	match stage_key:
		gv.Tab.S1:
			if normal:
				tab = gv.Tab.NORMAL
			else:
				tab = gv.Tab.MALIGNANT
		gv.Tab.S2:
			if normal:
				tab = gv.Tab.EXTRA_NORMAL
			else:
				tab = gv.Tab.RADIATIVE
		gv.Tab.S3:
			if normal:
				tab = gv.Tab.RUNED_DIAL
			else:
				tab = gv.Tab.SPIRIT
	
	icon = str(_icon)
	color = gv.COLORS[str(icon)] if str(icon) in gv.COLORS else gv.COLORS[tab]


func purchased():
	
	# for sXn upgrades. not sXm
	
	have = true
	active = true
	
	gv.stats["UpgradesPurchased"][tab] += 1
	gv.emit_signal("UpgradesPurchased", tab)
	
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
	
	if key in ["upgrade_name", "upgrade_description"]:
		lv.syncStage1and2_costModifier()
	
	if key == "THE WITCH OF LOREDELITH":
		for lored in gv.list.lored[gv.Tab.S1]:
			BuffManager.queue_apply_buff(BuffManager.Type.WITCH, lored, {"max_ticks": -1})
	
	applied = true

func refund():
	
	if not refundable:
		return
	refundable = false
	sync_cost()
	for c in cost:
		gv.resource[c].a(cost[c].t)

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
		
		gv.subtractFromResource(c, cost[c].t)
		
		gv.stats["ResourceStats"]["spent"][c].a(cost[c].t)
		gv.emit_signal("ResourceSpent", c)

func sync():
	
	sync_effects()
	sync_cost()
	sync_desc()

func sync_effects():
	
	for e in effects:
		e.sync()

func refresh():
	
	if applied:
		remove()
	sync()
	if active:
		apply()


func active_or_refundable() -> bool:
	return active(true)
func active(include_refundable := false) -> bool:
	if include_refundable:
		if refundable:
			return true
	return have and active

func sync_desc():
	
	desc.f = desc.base
	
	
	
	if "{other}" in desc.f:
		desc.f = desc.f.format({"other": other.read()})
	
	if effects.size() == 0:
		return
	
	while "{e" in desc.f:
		var i := int(desc.f.split("{e")[1][0])
		desc.f = desc.f.format({"e" + str(i): effects[i].effect.read()})

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
		var time_to_c = gv.timeUntil(c, cost[c].t)
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
	
	manager.connect_resource_signal()
	
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



func alter_Limit_Break():
	if applied:
		print(gv.up["Limit Break"].effects)
		remove()
	
	gv.up["Limit Break"].effects.clear()
	gv.up["Limit Break"].effects.append(Effect.new("haste", gv.list.lored[gv.Tab.S1] + gv.list.lored[gv.Tab.S2]))
	gv.up["Limit Break"].effects[0].dynamic = true
	sync_effects()
	apply()
	print(gv.up["Limit Break"].effects)
