class_name Upgrade
extends "res://Scripts/classes/Purchasable.gd"



var desc := Description.new("description")

var effects := []
var chain_key := ""
var chain_length := 0

var other = 0


var requires := []
var required_by := []
var requirements_met := true

var refundable := false
var icon: String # used to be mlt (main lored target)
var stage_key: String
var color: Color
var unlocked := false
var times_purchased := 0

var manager: MarginContainer
var active_tooltip: MarginContainer

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
		_icon := "s1"
	) -> void:
	
	name = _name
	key = _name
	desc.base = _desc
	
	type = _type
	
	stage = type[1]
	stage_key = type.split(" ")[0]
	normal = true if "n" == type[2] else false
	
	icon = _icon


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
		gv.stats.up_list["unowned s" + type[1] + "n"].erase(key)
	
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
		return fval.f(log(gv.stats.run[0])) + "%"
	
	return "1%"

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
		gv.stats.up_list["unowned s" + type[1] + "n"].append(key)
	
	refund()
	have = false
	active = true
	
	return true

func partial_reset():
	
	# for upgrades like IT'S GROWIN ON ME which needs to have its effect values reset
	for e in effects:
		e.effect.reset()
