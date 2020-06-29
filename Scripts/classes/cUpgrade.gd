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
var d := 1.0
var base_d : float
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
	
	d = _base_d
	base_d = _base_d
	set_d = Num.new(_set_d)
	
	type = _type
	path = type.split(" ")[0] + type.split(" ")[1].split(" ")[0]
	
	desc.base = _desc
	
	main_lored_target = _mlt

#func init_desc_brief() -> String:


func active() -> bool:
	# returns true if the upgrade is owned and active
	if not have: return false
	if not active: return false
	return true

func sync_self():
	
	set_d.t = set_d.b * mod_add() * mod_setd()
	for v in cost:
		cost[v].t = cost[v].b# * w_aa_d("up cost", f.name, v)
	#if "add" in f.type or "haste" in f.type:
	
	desc.f = desc.base
	
	if not "benefactor" in type and "%s" in desc.base:
		desc.f = desc.base % fval.f(set_d.t)
	if "{crit}" in desc.base:
		desc.f = desc.base.format({"crit": fval.f(set_d.t)})
	match name:
		"PROCEDURE":
			desc.f = desc.base % fval.f(set_d.t)
		"THE WITCH OF LOREDELITH":
			desc.f = desc.base % get_witch_percent()

func get_witch_percent() -> String:
	
	if gv.up["GRIMOIRE"].active():
		return fval.f(log(gv.stats.run[0])) + "%"
	
	return "1%"

func mod_add() -> float:
	
	var d := 1.0
	
	if "add buff" in type:
		for x in gv.stats.up_list["benefactor add"]:
			d += gv.up[x].d
	
	return d

func mod_setd() -> float:
	
	var d := 1.0
	
	if "haste buff" in type:
		for x in gv.stats.up_list["benefactor haste"]:
			d *= gv.up[x].d
	
	if "crit buff" in type:
		for x in gv.stats.up_list["benefactor crit"]:
			d += gv.up[x].d
	
	match name:
		"CAPITAL PUNISHMENT":
			d *= gv.stats.run[0]
		"PROCEDURE":
			d *= gv.up["Hey, that's pretty good!"].d * gv.up["Power Schlonks"].d * gv.up["Mega Wonks"].d * gv.up["CAPITAL PUNISHMENT"].d
	
	return d

func set_d(set_to_base := false) -> void:
	
	if set_to_base:
		d = base_d
		return
	if "benefactor" in type:
		d = set_d.t
		return
	if "haste" in type:
		d = 1 / set_d.t
		return
	
	d = set_d.t
