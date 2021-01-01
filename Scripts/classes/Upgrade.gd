class_name Upgrade
extends "res://Scripts/classes/Purchasable.gd"



var desc := Description.new("description")

var effects := []

var other = 0


var requires := []
var required_by := []
var requirements_met := true

var refundable := false
var icon: String # used to be mlt (main lored target)
var color: Color
var unlocked := false
var times_purchased := 0



var have := false
var active := true
var applied := false

var persist := 0
# if 1, persist will save this upgrade from being reset on a reset_type 1 reset
# but if s2 reset, while persist == 1, this upgrade WILL be reset

var stage: int
var normal: bool





func _init(
		_name: String,
		_type,
		_desc,
		_icon := "s1"
	) -> void:
	
	name = _name
	desc.base = _desc
	
	type = _type
	
	stage = int(type[1])
	normal = true if "n" == type[2] else false
	
	icon = _icon


func purchased():
	
	# for sXn upgrades. not sXm
	
	have = true
	active = true
	times_purchased += 1
	
	takeaway_price()
	apply()

func apply():
	
	for e in effects:
		e.apply(name)
	applied = true

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
		gv.emit_signal("lored_updated", c, "amount")

func sync():
	
	for e in effects:
		e.sync()
	
	sync_cost()
	sync_desc()

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
	
	have = false
	active = true
	
	return true

func partial_reset():
	
	# for upgrades like IT'S GROWIN ON ME which needs to have its effect values reset
	
	for e in effects:
		e.effect.reset()
