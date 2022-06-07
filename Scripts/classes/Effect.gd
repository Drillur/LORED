class_name Effect
extends "res://Scripts/classes/Object.gd"


var saved_vars := ["effect", ]

var type: String
var other: String # other useful key words. ex: for a cost upgrade, need to know which resource is being reduced

var beneficiaries: Array # will be something like ["coal"] or every single string in list.lored[gv.Tab.S1]

var applied: bool
var dynamic_applied := false
var dynamic: bool # changes over time and will therefore not be applied to a LORED's .um or .ua vars
var multiplicative: bool

var effect: Num



func _init(
		_type: String,
		_beneficiaries: Array,
		_effect := 1.0,
		_other := "",
		_multiplicative := true
	):
	
	type = _type
	if typeof(_beneficiaries) == TYPE_ARRAY:
		for x in _beneficiaries:
			beneficiaries.append(x)
	else:
		beneficiaries = _beneficiaries
	
	effect = Num.new(_effect)
	
	other = _other
	
	multiplicative = _multiplicative

func apply(upgrade_name: String):
	
	# possibly, in the future, add a "sync_lored" parameter that defaults to false
	# if specified as true, then sync each lored in beneficiaries[]
	
	effect.sync()
	applied = true
	
	if dynamic:
		
		# dynamic upgrades' effect variables change over time
		# loreds that benefit from dynamic upgrades will check for the effect variable's new value every sync()
		
		for b in beneficiaries:
			gv.g[b].dynamics.append(upgrade_name)
		
		return
	
	match type:
		
		"task":
			for b in beneficiaries:
				gv.g[b].task_list.append(other)
		"cremover":
			for b in beneficiaries:
				gv.g[b].cost.erase(other)
		"buff haste":
			for x in gv.list.upgrade[type.split(" ")[1] + " buff"]:
				for c in gv.up[x].effects:
					if c.effect.b.less_equal(1.1) and c.type == type.split(" ")[1]:
						if multiplicative:
							c.effect.um.m(effect.t)
						else:
							c.effect.ua.a(effect.t)
						gv.up[x].refresh()
		"buff output":
			for x in gv.list.upgrade[type.split(" ")[1] + " buff"]:
				for c in gv.up[x].effects:
					if c.effect.b.equal(1) and c.type == type.split(" ")[1]:
						if multiplicative:
							c.effect.um.m(effect.t)
						else:
							c.effect.ua.a(effect.t)
						gv.up[x].refresh()
		"buff crit":
			for x in gv.list.upgrade[type.split(" ")[1] + " buff"]:
				for c in gv.up[x].effects:
					if c.effect.b.equal(1) and c.type == type.split(" ")[1]:
						# crit cannot be multiplicative, that's just weird. so don't even account for it
						c.effect.ua.a(effect.t)
						gv.up[x].refresh()
		"crit":
			# crit cannot be multiplicative, that's just weird. so don't even account for it
			for b in beneficiaries:
				gv.g[b].crit.ua.a(effect.t)
				gv.g[b].crit.sync()
		"input":
			for b in beneficiaries:
				if other == "all":
					for x in gv.g[b].b:
						gv.g[b].b[x].um.m(effect.t)
						gv.g[b].b[x].sync()
				else:
					gv.g[b].b[other].um.m(effect.t)
					gv.g[b].b[other].sync()
		"cost":
			for b in beneficiaries:
				if other == "all":
					for c in gv.g[b].cost:
						gv.g[b].cost[c].um.m(effect.t)
						gv.g[b].cost[c].sync()
				else:
					gv.g[b].cost[other].um.m(effect.t)
					gv.g[b].cost[other].sync()
		"drain":
			for b in beneficiaries:
				if multiplicative:
					gv.g[b].fc.um.m(effect.t)
					gv.g[b].fc.sync()
				else:
					gv.g[b].fc.ua.a(effect.t)
					gv.g[b].fc.sync()
		"haste":
			for b in beneficiaries:
				gv.g[b].speed.um /= effect.t.toFloat()
				gv.g[b].speed.sync()
		"output":
			for b in beneficiaries:
				if multiplicative:
					gv.g[b].d.um.m(effect.t)
					gv.g[b].d.sync()
				else:
					gv.g[b].d.ua.a(effect.t)
					gv.g[b].d.sync()
		"autob":
			for b in beneficiaries:
				gv.g[b].autobuy = true
				gv.emit_signal("autobuyer_purchased", b)
		"autoup":
			for b in beneficiaries:
				gv.up[b].autobuy = true
		"saveup":
			for b in beneficiaries:
				gv.up[b].persist = int(effect.b.mantissa)
		"procedure":
			gv.up[beneficiaries[0]].other.um.m(effect.t)
			gv.up[beneficiaries[0]].other.sync()
			gv.up[beneficiaries[0]].sync()

func remove(upgrade_name: String):
	
	# do not effect.sync() here
	
	applied = false
	dynamic_applied = false
	
	if dynamic:
		
		# dynamic upgrades' effect variables change over time
		# loreds that benefit from dynamic upgrades will check for the effect variable's new value every sync()
		
		for b in beneficiaries:
			if upgrade_name + "," + type in gv.g[b].dynamics:
				gv.g[b].dynamics.erase(upgrade_name + "," + type)
		
		return
	
	match type:
		
		"cremover":
			for b in beneficiaries:
				gv.g[b].cost[other] = Ob.Num.new(effect.t)
		"buff haste":
			for x in gv.list.upgrade[type.split(" ")[1] + " buff"]:
				for c in gv.up[x].effects:
					if c.effect.b.less_equal(1.1) and c.type == type.split(" ")[1]:
						if multiplicative:
							c.effect.um.d(effect.t)
						else:
							c.effect.ua.s(effect.t)
						gv.up[x].refresh()
		"buff output":
			for x in gv.list.upgrade[type.split(" ")[1] + " buff"]:
				for c in gv.up[x].effects:
					if c.effect.b.equal(1) and c.type == type.split(" ")[1]:
						if multiplicative:
							c.effect.um.d(effect.t)
						else:
							c.effect.ua.s(effect.t)
						gv.up[x].refresh()
		"buff crit":
			for x in gv.list.upgrade[type.split(" ")[1] + " buff"]:
				for c in gv.up[x].effects:
					if c.effect.b.equal(1) and c.type == type.split(" ")[1]:
						# crit cannot be multiplicative, that's just weird. so don't even account for it
						c.effect.ua.s(effect.t)
						gv.up[x].refresh()
		"crit":
			# crit cannot be multiplicative, that's just weird. so don't even account for it
			for b in beneficiaries:
				gv.g[b].crit.ua.s(effect.t)
				gv.g[b].crit.sync()
		"input":
			for b in beneficiaries:
				if other == "all":
					for x in gv.g[b].b:
						gv.g[b].b[x].um.d(effect.t)
						gv.g[b].b[x].sync()
				else:
					gv.g[b].b[other].um.d(effect.t)
					gv.g[b].b[other].sync()
		"cost":
			for b in beneficiaries:
				if other == "all":
					for c in gv.g[b].cost:
						gv.g[b].cost[c].um.d(effect.t)
						gv.g[b].cost[c].sync()
				else:
					gv.g[b].cost[other].um.d(effect.t)
					gv.g[b].cost[other].sync()
		"drain":
			for b in beneficiaries:
				if multiplicative:
					gv.g[b].fc.um.d(effect.t)
					gv.g[b].fc.sync()
				else:
					gv.g[b].fc.ua.s(effect.t)
					gv.g[b].fc.sync()
		"haste":
			for b in beneficiaries:
				gv.g[b].speed.um *= effect.t.toFloat()
				gv.g[b].speed.sync()
		"output":
			for b in beneficiaries:
				if multiplicative:
					gv.g[b].d.um.d(effect.t)
					gv.g[b].d.sync()
				else:
					gv.g[b].d.ua.s(effect.t)
					gv.g[b].d.sync()
		"autob":
			for b in beneficiaries:
				gv.g[b].autobuy = false
				gv.emit_signal("autobuyer_purchased", b)
		"autoup":
			for b in beneficiaries:
				gv.up[b].autobuy = false
		"saveup":
			for b in beneficiaries:
				gv.up[b].persist = 0
		"procedure":
			gv.up[beneficiaries[0]].other.um.d(effect.t)
			gv.up[beneficiaries[0]].other.sync()
			gv.up[beneficiaries[0]].sync()

func reset(upgrade_name: String):
	
	remove(upgrade_name)
	
	if dynamic:
		reset_dynamic()

func reset_dynamic():
	
	effect.reset()

func sync():
	effect.sync()


func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		if get(x) is Ob.Num:
			data[x] = get(x).save()
		else:
			data[x] = var2str(get(x))
	
	return var2str(data)

func load(data: Dictionary):
	
	for x in saved_vars:
		
		if not x in data.keys():
			continue
		
		if get(x) is Ob.Num:
			get(x).load(data[x])
		else:
			set(x, str2var(data[x]))
