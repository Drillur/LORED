class_name Upgrade
extends "res://Scripts/classes/cPurchasable.gd"



var c_score := 0.0 # cost score; used to sort upgrades by type/cost

class Description:
	
	var f: String
	var base: String
	
	func _init(_desc: String) -> void:
		base = _desc
		f = _desc
var desc := Description.new("gay")


var path : String
var requires := ""
var required_by := []
var requirements_met : bool = true
var icon_set : bool = false
var benefactor_of := []
var d := Num.new()
var set_d : Num
var have := false
var active := true
var refundable := false
var main_lored_target : String # rename to icon tbh - but do not make a Texture var, will break some things
var color: Color
var unlocked := false
var times_purchased := 0



func _init(
		_name: String,
		_type,
		_desc,
		_set_d: float,
		_mlt := "s1",
		_base_d := 1.0
	) -> void:
	
	name = _name
	
	d.b = Big.new(_base_d)
	set_d = Num.new(_set_d)
	
	type = _type
	path = type.split(" ")[0] + type.split(" ")[1].split(" ")[0]
	
	if " crit" in type or " add" in type:
		d.b = Big.new(0)
	
	desc.base = _desc
	
	main_lored_target = _mlt


func sync():
	
	sync_set_d()
	sync_d()
	sync_cost()
	sync_desc()

func sync_set_d():
	
	set_d.a = Big.new(0)
	set_d.m = Big.new()
	
	# a
	if "add buff" in type:
		for x in gv.stats.up_list["benefactor add"]:
			var gay = Big.new(Big.max(gv.up[x].d.t, 0))
			set_d.a.plus(gay)
	if "crit buff" in type:
		for x in gv.stats.up_list["benefactor crit"]:
			set_d.a.plus(gv.up[x].d.t)
	
	# m
	if "haste buff" in type:
		for x in gv.stats.up_list["benefactor haste"]:
			set_d.m.multiply(gv.up[x].d.t)
	match name:
		"CAPITAL PUNISHMENT":
			set_d.m.multiply(gv.stats.run[0])
		"PROCEDURE":
			set_d.m.multiply(gv.up["Hey, that's pretty good!"].d.t)
			set_d.m.multiply(gv.up["Power Schlonks"].d.t)
			set_d.m.multiply(gv.up["Mega Wonks"].d.t)
			set_d.m.multiply(gv.up["CAPITAL PUNISHMENT"].d.t)
	
	
	set_d.sync()

func sync_d():
	
	d.a = Big.new(0)
	d.m = Big.new()
	
	if not active():
		
		if " crit" in type or " add" in type:
			d.m.minus(1) # must be 0 for these
		
		d.sync()
		return
	
	
	if " crit" in type or " add" in type:
		d.a = Big.new(set_d.t)
	else:
		d.m = Big.new(set_d.t)
	
	
	d.sync()

func sync_cost():
	
	for c in cost:
		
		#cost[c].a = Big.new(0)
		#cost[c].m = Big.new()
		
		
		cost[c].sync()

func sync_desc():
	
	desc.f = desc.base
	
	if not "benefactor" in type and "%s" in desc.base:
		desc.f = desc.base % set_d.t.toString()
	if "{crit}" in desc.base:
		desc.f = desc.base.format({"crit": set_d.t.toString()})
	
	match name:
		"PROCEDURE":
			desc.f = desc.base % set_d.t.toString()
		"THE WITCH OF LOREDELITH":
			desc.f = desc.base % get_witch_percent()

func get_witch_percent() -> String:
	
	if gv.up["GRIMOIRE"].active():
		return fval.f(log(gv.stats.run[0])) + "%"
	
	return "1%"


func active() -> bool:
	# returns true if the upgrade is owned and active
	return have and active


