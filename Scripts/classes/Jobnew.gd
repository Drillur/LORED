class_name Jobnew
extends Reference



var type: int
var lored_type: int

var base_duration: float
var speed: Ob.Float # reference to gv.g[lored_type].speed
var duration: float # base_duration * speed

var display_text: String
var can_text: String # Example: "Given 5 Iron Ore, can toast 5 Iron."

var fuel: Ob.Num # reference to gv.g[lored_type].f
var fuel_cost: Ob.Num # reference to gv.g[lored_type].fc
var minimum_fuel: Big

var requires_resource := false
var required_resource: Array # references gv.r[something]s
var required_resource_amount: Array # if Stage 1/2 LORED, references gv.g[lored_type].b's
var required_keys: Array

var output: Ob.Num # reference to gv.g[lored_type].d
var produced_resource: int

var consider_babyhood := false



func _init(_type: int, _lored_type: int) -> void:
	
	type = _type
	lored_type = _lored_type
	
	if gv.g[lored_type].stage == 2:
		consider_babyhood = true
	
	match key:
		gv.Job.BORER_DIG:
			base_duration = 2.5
		gv.Job.FURNACE_COOK:
			base_duration = 2.5
			requires_resource = true
			
			for _b in gv.g[lored_type].b:
				required_resource.append(_b)
				required_resource_amount.append(gv.g[lored_type].b[_b])
				required_keys.append(_b)
	
	if gv.g[lored_type].stage in [1, 2]:
		produced_resource_key = lored_type
	
	fuel = gv.g[lored_type].f
	fuel_cost = gv.g[lored_type].fc
	speed = gv.g[lored_type].speed
	output = gv.g[lored_type].d
	
	match lored_type:
		"coal":
			can_text = "Can dig for "
		"stone":
			can_text = "Can pick up "
		"irono":
			can_text = "Can shoot "
		"copo":
			can_text = "Can mine "
		"iron":
			can_text = " can toast "
		"cop":
			can_text = " can cook "
		"growth":
			can_text = " can pinch off "
		"conc":
			can_text = " can mash "
		"jo":
			can_text = " can redirect "
		"oil":
			can_text = "Can succ "
		"tar":
			can_text = " can mutate "
		"malig":
			can_text = " can manifest "
		
		"water":
			can_text = "Can splish-splash "
		"humus":
			can_text = " can shit "
		"tree":
			can_text = " can grow "
		"seed":
			can_text = " can pollenate "
		"soil":
			can_text = " can scoop "
		"axe":
			can_text = " can construct "
		"wood":
			can_text = " can obliterate "
		"hard":
			can_text = " can seduce "
		"liq":
			can_text = " can melt "
		"steel":
			can_text = " can smelt "
		"sand":
			can_text = " can copyright-risk pull "
		"glass":
			can_text = " can glass "
		"draw":
			can_text = " can doodle "
		"wire":
			can_text = " can sew "
		"gale":
			can_text = "Can jackhammer "
		"lead":
			can_text = " can filter "
		"pet":
			can_text = " can process "
		"pulp":
			can_text = " can strip "
		"paper":
			can_text = " can paperify "
		"plast":
			can_text = " can pollute "
		"toba":
			can_text = " can smoke "
		"ciga":
			can_text = " can smoke "
		"carc":
			can_text = " can somehow make "
		"tum":
			can_text = " can grow "
	
	sync()


func sync():
	duration = base_duration * speed.t
	minimum_fuel = Big.new(duration).m(fuel_cost.t).m(1.1)



func try() -> bool:
	
	# attempts to start the job
	# if can_start() returns TRUE, calls "start" method, then returns TRUE
	# else, returns FALSE
	
	sync()
	
	return can_start()

func can_start() -> bool:
	
	if fuel.f.less(minimum_fuel):
		return false
	
	if requires_resource:
		
		var i = 0
		for r in required_resource:
			if gv.g[r].hold:
				return false
			if gv.r[r].less(Big.new(required_resource_amount[i].t).m(output.t)):
				return false
			i += 1
	
	if consider_babyhood:
		if gv.up["don't take candy from babies"].active():
			for _b in required_keys:
				if gv.g[_b].stage != "1":
					continue
				if gv.g[_b].level <= 4:
					return false
	
	start()
	
	return true


func start() -> void:
	
	gv.g[lored_type].inhand = Big.new(output.t)
	gv.g[lored_type].working = true
	gv.g[lored_type].current_job = self
	
	if requires_resource:
		
		var i = 0
		for r in required_resource:
			gv.r[r].s(Big.new(required_resource_amount[i].t).m(output.t))
			i += 1


func complete() -> void:
	
	gv.g[lored_type].working = false
	
	var crit = crit_roll()
	if crit != 1.0:
		gv.g[lored_type].inhand.m(crit)
	
	gv.r[produced_resource_key].a(gv.g[lored_type].inhand)
	
	gv.g[lored_type].manager.w_bonus_output(produced_resource_key, gv.g[lored_type].inhand)
	gv.increase_lb_xp(gv.g[lored_type].inhand)
	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, produced_resource_key, gv.g[lored_type].inhand)
	gv.g[lored_type].manager.flying_texts()

func crit_roll() -> float:
	
	var f := 1.0
	
	var roll = rand_range(0, 100)
	if gv.g[lored_type].crit.t.greater_equal(roll):
		f *= rand_range(7.5, 12.5)
		gv.g[lored_type].manager.crit = true
	
	if gv.g[lored_type].stage == "1" and gv.up["the athore coments al totol lies!"].active():
		
		roll = rand_range(0,100)
		if roll <= 1:
			f *= rand_range(7.5, 12.5)
			gv.g[lored_type].manager.critcrit = true
	
	return f
