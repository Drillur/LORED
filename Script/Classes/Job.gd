class_name Job
extends RefCounted



enum Type {
	REFUEL, 
	
	STONE, # 0
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
	
	WATER, # 12
	HUMUS,
	SEEDS,
	TREES,
	TREES2,
	SOIL,
	AXES,
	AXES2,
	WOOD,
	HARDWOOD,
	LIQUID_IRON, # 20
	STEEL,
	SAND,
	GLASS,
	DRAW_PLATE,
	WIRE,
	GALENA,
	LEAD,
	PETROLEUM,
	WOOD_PULP,
	PAPER, # 30
	PLASTIC,
	TOBACCO,
	CIGARETTES,
	CARCINOGENS,
	TUMORS,
	
	# WITCH
	PLANT_SEED,
	SIFT_SEEDS,
}

signal became_workable
signal began_working
signal stopped_working
signal completed
signal cut_short
signal unlocked_changed(unlocked)
signal currency_produced(amount)

var type: int
var lored: int

var crit: Value

var clock_in_time: float

var key: String
var name := ""
var status_text := ""

var animation: SpriteFrames
var animation_key: String
var two_part_animation := false
var part_one_played := false

var unlocked_by_default := false
var unlocked := false:
	set(val):
		if unlocked != val:
			unlocked = val
			if val:
				append_producer_and_user()
			else:
				erase_producer_and_user()
			unlocked_changed.emit(val)
var starting := false
var added_rate := false
var working := false
var added_rate_based_on_inhand: bool
var do_not_alter_rates := false

var has_sufficient_fuel := true
var has_produced_currencies := false
var produced_currencies := {}
var bonus_production := {}
var produced_rates := {}
var in_hand_output := {}
var has_required_currencies := false
var in_hand_input := {}
var required_currencies: Cost
var required_rates := {}

var timer: Timer

var last_production := {}
var last_used_curs := {}

var duration: Value
var fuel_cost: Value



func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	
	call("init_" + key)
	
	fuel_cost = Value.new(duration.get_as_float())
	
	has_required_currencies = required_currencies != null
	has_produced_currencies = not produced_currencies.is_empty()
	
	if has_required_currencies:
		for cur in required_currencies.cost:
			required_currencies.cost[cur].changed.connect(refresh_required_rate)
	
	unlocked_changed.connect(became_unlocked)
	
	if type != Type.REFUEL:
		hookup_required_currencies()



func init_REFUEL() -> void:
	name = "Refuel"
	duration = Value.new(4)
	status_text = "Refueling!"
	animation = preload("res://Sprites/animations/Refuel.tres")


func init_STONE() -> void:
	name = "Pick Up"
	duration = Value.new(2.5)
	animation = preload("res://Sprites/animations/stone.tres")
	add_produced_currency(Currency.Type.STONE, 1)


func init_COAL() -> void:
	name = "Dig"
	duration = Value.new(3.25)
	animation = preload("res://Sprites/animations/coal.tres")
	add_produced_currency(Currency.Type.COAL, 1)


func init_IRON_ORE() -> void:
	name = "Murder"
	duration = Value.new(4)
	animation = preload("res://Sprites/animations/irono.tres")
	add_produced_currency(Currency.Type.IRON_ORE, 1)


func init_COPPER_ORE() -> void:
	name = "Mine"
	duration = Value.new(4)
	animation = preload("res://Sprites/animations/copo.tres")
	add_produced_currency(Currency.Type.COPPER_ORE, 1)


func init_IRON() -> void:
	name = "Toast"
	duration = Value.new(5)
	animation = preload("res://Sprites/animations/iron.tres")
	add_produced_currency(Currency.Type.IRON, 1)
	required_currencies = Cost.new({
		Currency.Type.IRON_ORE: Value.new(1)
	})


func init_COPPER() -> void:
	name = "Cook"
	duration = Value.new(5)
	animation = preload("res://Sprites/animations/cop.tres")
	add_produced_currency(Currency.Type.COPPER, 1)
	required_currencies = Cost.new({
		Currency.Type.COPPER_ORE: Value.new(1)
	})


func init_GROWTH() -> void:
	name = "Pop"
	duration = Value.new(6.5)
	animation = preload("res://Sprites/animations/growth.tres")
	add_produced_currency(Currency.Type.GROWTH, 1)
	required_currencies = Cost.new({
		Currency.Type.IRON: Value.new(1),
		Currency.Type.COPPER: Value.new(1),
	})


func init_JOULES() -> void:
	name = "Redirect"
	duration = Value.new(8.25)
	animation = preload("res://Sprites/animations/jo.tres")
	add_produced_currency(Currency.Type.JOULES, 1)
	required_currencies = Cost.new({
		Currency.Type.COAL: Value.new(1),
	})


func init_CONCRETE() -> void:
	name = "Mash"
	duration = Value.new(10)
	animation = preload("res://Sprites/animations/conc.tres")
	add_produced_currency(Currency.Type.CONCRETE, 1)
	required_currencies = Cost.new({
		Currency.Type.STONE: Value.new(1)
	})


func init_OIL() -> void:
	name = "Succ"
	duration = Value.new(0.5)
	animation = preload("res://Sprites/animations/oil.tres")
	add_produced_currency(Currency.Type.OIL, 0.075)


func init_TARBALLS() -> void:
	name = "Mutate"
	duration = Value.new(4)
	animation = preload("res://Sprites/animations/tar.tres")
	add_produced_currency(Currency.Type.TARBALLS, 1)
	required_currencies = Cost.new({
		Currency.Type.OIL: Value.new(1)
	})


func init_MALIGNANCY() -> void:
	name = "Manifest"
	duration = Value.new(5)
	animation = preload("res://Sprites/animations/malig.tres")
	add_produced_currency(Currency.Type.MALIGNANCY, 1)
	required_currencies = Cost.new({
		Currency.Type.TARBALLS: Value.new(1),
		Currency.Type.GROWTH: Value.new(1),
	})


func init_WATER() -> void:
	name = "Splish-Splash"
	duration = Value.new(3.25)
	animation = preload("res://Sprites/animations/water.tres")
	two_part_animation = true
	add_produced_currency(Currency.Type.WATER, 1)


func init_HUMUS() -> void:
	name = "Shit"
	duration = Value.new(4.575)
	animation = preload("res://Sprites/animations/humus.tres")
	add_produced_currency(Currency.Type.HUMUS, 1)
	required_currencies = Cost.new({
		Currency.Type.GROWTH: Value.new(0.5),
		Currency.Type.WATER: Value.new(1),
	})


func init_TREES() -> void:
	name = "Grow"
	duration = Value.new(20)
	animation = preload("res://Sprites/animations/tree.tres")
	add_produced_currency(Currency.Type.TREES, 1)
	required_currencies = Cost.new({
		Currency.Type.WATER: Value.new(6),
		Currency.Type.SEEDS: Value.new(1),
	})


func init_TREES2() -> void:
	name = "Photosynthesate"
	duration = Value.new(60)
	animation = preload("res://Sprites/animations/tree.tres")
	add_produced_currency(Currency.Type.TREES, 0.5)
	required_currencies = Cost.new({
		Currency.Type.WATER: Value.new(30),
	})
	do_not_alter_rates = true


func init_SEEDS() -> void:
	name = "Pollenate"
	duration = Value.new(5)
	animation = preload("res://Sprites/animations/seed.tres")
	two_part_animation = true
	add_produced_currency(Currency.Type.SEEDS, 1)
	required_currencies = Cost.new({
		Currency.Type.WATER: Value.new(1.5),
	})


func init_SOIL() -> void:
	name = "Scrape"
	duration = Value.new(5)
	animation = preload("res://Sprites/animations/soil.tres")
	add_produced_currency(Currency.Type.SOIL, 1)
	required_currencies = Cost.new({
		Currency.Type.HUMUS: Value.new(1.5),
	})


func init_AXES() -> void:
	name = "Assemble"
	duration = Value.new(7)
	animation = preload("res://Sprites/animations/axe.tres")
	add_produced_currency(Currency.Type.AXES, 1)
	required_currencies = Cost.new({
		Currency.Type.HARDWOOD: Value.new(0.8),
		Currency.Type.STEEL: Value.new(0.25),
	})


func init_AXES2() -> void:
	name = "Emergency Routine A"
	duration = Value.new(15)
	animation = preload("res://Sprites/animations/axe.tres")
	add_produced_currency(Currency.Type.AXES, 1)
	required_currencies = Cost.new({
		Currency.Type.STEEL: Value.new(2.5),
	})
	do_not_alter_rates = true


func init_WOOD() -> void:
	name = "Obliterate"
	duration = Value.new(5)
	animation = preload("res://Sprites/animations/wood.tres")
	add_produced_currency(Currency.Type.WOOD, 25)
	required_currencies = Cost.new({
		Currency.Type.AXES: Value.new(5),
		Currency.Type.TREES: Value.new(1),
	})


func init_HARDWOOD() -> void:
	name = "Seduce"
	duration = Value.new(4.58333)
	animation = preload("res://Sprites/animations/hard.tres")
	add_produced_currency(Currency.Type.HARDWOOD, 1)
	required_currencies = Cost.new({
		Currency.Type.WOOD: Value.new(2),
		Currency.Type.CONCRETE: Value.new(1),
	})


func init_LIQUID_IRON() -> void:
	name = "Stew"
	duration = Value.new(4)
	animation = preload("res://Sprites/animations/liq.tres")
	add_produced_currency(Currency.Type.LIQUID_IRON, 1)
	required_currencies = Cost.new({
		Currency.Type.IRON: Value.new(10),
	})


func init_STEEL() -> void:
	name = "Slam"
	duration = Value.new(13 + (1.0/3))
	animation = preload("res://Sprites/animations/steel.tres")
	add_produced_currency(Currency.Type.STEEL, 1)
	required_currencies = Cost.new({
		Currency.Type.LIQUID_IRON: Value.new(8),
	})


func init_SAND() -> void:
	name = "Levitate"
	duration = Value.new(4)
	animation = preload("res://Sprites/animations/sand.tres")
	add_produced_currency(Currency.Type.SAND, 2.5)
	required_currencies = Cost.new({
		Currency.Type.HUMUS: Value.new(1.5),
	})


func init_GLASS() -> void:
	name = "Glass"
	duration = Value.new(5.825)
	animation = preload("res://Sprites/animations/glass.tres")
	add_produced_currency(Currency.Type.GLASS, 1)
	required_currencies = Cost.new({
		Currency.Type.SAND: Value.new(6),
	})


func init_DRAW_PLATE() -> void:
	name = "Doodle"
	duration = Value.new(10)
	animation = preload("res://Sprites/animations/draw.tres")
	add_produced_currency(Currency.Type.DRAW_PLATE, 1)
	required_currencies = Cost.new({
		Currency.Type.STEEL: Value.new(0.5),
	})


func init_WIRE() -> void:
	name = "Sew"
	duration = Value.new(5)
	animation = preload("res://Sprites/animations/wire.tres")
	add_produced_currency(Currency.Type.WIRE, 1)
	required_currencies = Cost.new({
		Currency.Type.COPPER: Value.new(5),
		Currency.Type.DRAW_PLATE: Value.new(0.4),
	})


func init_GALENA() -> void:
	name = "Jackhammer"
	duration = Value.new(4)
	animation = preload("res://Sprites/animations/gale.tres")
	add_produced_currency(Currency.Type.GALENA, 1)


func init_LEAD() -> void:
	name = "Filter"
	duration = Value.new(5)
	animation = preload("res://Sprites/animations/lead.tres")
	add_produced_currency(Currency.Type.LEAD, 1)
	required_currencies = Cost.new({
		Currency.Type.GALENA: Value.new(1),
	})


func init_PETROLEUM() -> void:
	name = "Process"
	duration = Value.new(5)
	animation = preload("res://Sprites/animations/pet.tres")
	add_produced_currency(Currency.Type.PETROLEUM, 1)
	required_currencies = Cost.new({
		Currency.Type.OIL: Value.new(3),
	})


func init_WOOD_PULP() -> void:
	name = "Strip"
	duration = Value.new(6 + (2.0/3))
	animation = preload("res://Sprites/animations/pulp.tres")
	add_produced_currency(Currency.Type.WOOD_PULP, 5)
	required_currencies = Cost.new({
		Currency.Type.STONE: Value.new(10),
		Currency.Type.WOOD: Value.new(5),
	})


func init_PAPER() -> void:
	name = "Paperify"
	duration = Value.new(5 + (1.0/3))
	animation = preload("res://Sprites/animations/paper.tres")
	add_produced_currency(Currency.Type.PAPER, 1)
	required_currencies = Cost.new({
		Currency.Type.WOOD_PULP: Value.new(0.6),
	})


func init_PLASTIC() -> void:
	name = "Pollute"
	duration = Value.new(6.25)
	animation = preload("res://Sprites/animations/plast.tres")
	add_produced_currency(Currency.Type.PLASTIC, 1)
	required_currencies = Cost.new({
		Currency.Type.COAL: Value.new(5),
		Currency.Type.PETROLEUM: Value.new(1),
	})


func init_TOBACCO() -> void:
	name = "Smoke"
	duration = Value.new(8 + (1.0/3))
	animation = preload("res://Sprites/animations/toba.tres")
	add_produced_currency(Currency.Type.TOBACCO, 1)
	required_currencies = Cost.new({
		Currency.Type.WATER: Value.new(2),
		Currency.Type.SEEDS: Value.new(1),
	})


func init_CIGARETTES() -> void:
	name = "Smoke"
	duration = Value.new(2.583333)
	animation = preload("res://Sprites/animations/ciga.tres")
	add_produced_currency(Currency.Type.CIGARETTES, 1)
	required_currencies = Cost.new({
		Currency.Type.TARBALLS: Value.new(4),
		Currency.Type.TOBACCO: Value.new(1),
		Currency.Type.PAPER: Value.new(0.25),
	})


func init_CARCINOGENS() -> void:
	name = "#note"
	duration = Value.new(7.5)
	animation = preload("res://Sprites/animations/carc.tres")
	add_produced_currency(Currency.Type.CARCINOGENS, 1)
	required_currencies = Cost.new({
		Currency.Type.MALIGNANCY: Value.new(3),
		Currency.Type.CIGARETTES: Value.new(6),
		Currency.Type.PLASTIC: Value.new(5),
	})


func init_TUMORS() -> void:
	name = "Grow"
	duration = Value.new(16 + (2.0/3))
	animation = preload("res://Sprites/animations/tum.tres")
	add_produced_currency(Currency.Type.TUMORS, 1)
	required_currencies = Cost.new({
		Currency.Type.GROWTH: Value.new(10),
		Currency.Type.MALIGNANCY: Value.new(5),
		Currency.Type.CARCINOGENS: Value.new(3),
	})


func assign_lored(lored_type: int) -> void:
	lored = lored_type
	var _lored: LORED = lv.get_lored(lored) as LORED
	crit = _lored.crit
	_lored.fuel.current_increased.connect(fuel_increased)
	_lored.fuel.current_decreased.connect(fuel_decreased)
	if type == Type.REFUEL:
		_lored.fuel.total_changed.connect(lored_fuel_total_changed)
		var half = Big.new(_lored.fuel.get_total()).d(2)
		has_required_currencies = true
		required_currencies = Cost.new({
			_lored.fuel_currency: Value.new(half)
		})
		hookup_required_currencies()
		animation_key = "refuel"
		if lored != LORED.Type.COAL and _lored.fuel_currency == Currency.Type.COAL:
			# whenever coal refuels, check if should emit workable!
			lv.get_lored(LORED.Type.COAL).get_job(type).completed.connect(emit_workable)
	else:
		animation_key = _lored.key
	
	if has_required_currencies:
		required_currencies.stage = _lored.stage
	
	_lored.connect("job_started", another_job_started)
	_lored.purchased.changed.connect(lored_purchased_changed)



func append_producer_and_user() -> void:
	if has_produced_currencies:
		for cur in produced_currencies:
			wa.append_producer(cur, lored)
	if has_required_currencies:
		for cur in required_currencies.cost:
			wa.append_user(cur, lored)


func erase_producer_and_user() -> void:
	if has_produced_currencies:
		for cur in produced_currencies:
			wa.erase_producer(cur, lored)
	if has_required_currencies:
		for cur in required_currencies.cost:
			wa.erase_user(cur, lored)



func hookup_required_currencies() -> void:
	if has_required_currencies:
		required_currencies.affordable.became_true.connect(emit_workable)
		required_currencies.use_allowed_changed.connect(required_currency_use_allowed_changed)


func add_produced_currency(currency: int, amount: float) -> void:
	produced_currencies[currency] = Value.new(amount)



# - Signal

func lored_output_changed() -> void:
	for x in produced_currencies.values():
		x.set_m_from_lored(lv.get_lored(lored).get_output())
	refresh_produced_rate()


func lored_input_changed() -> void:
	if type != Type.REFUEL:
		required_currencies.increase_m_from_lored(lv.get_lored(lored).get_input())
		refresh_required_rate()


func lored_haste_changed() -> void:
	duration.set_d_from_lored(lv.get_lored(lored).get_haste())
	fuel_cost.set_d_from_lored(lv.get_lored(lored).get_haste())
	refresh_rate()


func lored_fuel_cost_changed() -> void:
	fuel_cost.set_m_from_lored(lv.get_lored(lored).get_fuel_cost())
	has_sufficient_fuel = lv.get_lored(lored).fuel.get_current().greater_equal(fuel_cost.get_value())


func lored_fuel_total_changed() -> void:
	var _lored = lv.get_lored(lored) as LORED
	var half = Big.new(_lored.fuel.get_total()).d(2)
	required_currencies.cost[_lored.fuel_currency].set_to(half)


func required_currency_use_allowed_changed(allowed: bool) -> void:
	if allowed:
		emit_workable()


func became_unlocked(_unlocked: bool) -> void:
	if _unlocked:
		emit_workable()


func emit_workable() -> void:
	if (
		unlocked
		and (
			not has_required_currencies
			or (
				required_currencies.use_allowed
				and required_currencies.affordable.is_true()
			)
		)
	):
		became_workable.emit()


func fuel_increased() -> void:
	if not has_sufficient_fuel:
		if lv.get_lored(lored).fuel.get_current().greater_equal(fuel_cost.get_value()):
			has_sufficient_fuel = true


func fuel_decreased() -> void:
	if has_sufficient_fuel:
		if lv.get_lored(lored).fuel.get_current().less(fuel_cost.get_value()):
			has_sufficient_fuel = false


func another_job_started(_job: Job) -> void:
	pass # called whenever the lored starts any job i guess


func lored_purchased_changed() -> void:
	var purchased = lv.is_lored_purchased(lored)
	if not purchased:
		subtract_rate()



# - Actions

func add_bonus_production(cur: int, modifier: float) -> void:
	bonus_production[cur] = modifier
	wa.append_producer(cur, lored)
	subtract_rate()
	add_rate()


func remove_bonus_production(cur: int) -> void:
	bonus_production.erase(cur)
	wa.erase_producer(cur, lored)
	if cur in produced_rates:
		produced_rates.erase(cur)



func refresh_rate() -> void:
	if not added_rate:
		add_rate()
		return
	refresh_produced_rate()
	refresh_required_rate()


func refresh_produced_rate() -> void:
	if not added_rate:
		add_rate()
		return
	var _duration = duration.get_as_float()
	for cur in produced_rates:
		var currency = wa.get_currency(cur) as Currency
		var gain_rate = currency.gain_rate
		var new_rate = Big.new(1).d(_duration)
		if cur in produced_currencies.keys():
			new_rate.m(produced_currencies[cur].get_value())
		else:
			new_rate.m(produced_currencies.values()[0].get_value())
		gain_rate.alter_value(
			gain_rate.added,
			produced_rates[cur],
			new_rate
		)
		currency.sync_rate()
		produced_rates[cur] = new_rate


func refresh_required_rate() -> void:
	if not added_rate:
		add_rate()
		return
	var _duration = duration.get_as_float()
	for cur in required_rates:
		var currency = wa.get_currency(cur) as Currency
		var loss_rate = currency.loss_rate
		var new_rate = Big.new(required_currencies.cost[cur].get_value()).d(_duration)
		loss_rate.alter_value(
			loss_rate.added,
			required_rates[cur],
			new_rate
		)
		currency.sync_rate()
		required_rates[cur] = new_rate


func add_rate() -> void:
	if (
		do_not_alter_rates
		or added_rate
		or lv.get_lored(lored).purchased.is_false()
	):
		return
	
	added_rate = true
	
	var _duration = duration.get_as_float()
	if has_produced_currencies:
		produced_rates.clear()
		for cur in produced_currencies:
			var currency = wa.get_currency(cur) as Currency
			var rate = get_gain_rate(cur)
			
			currency.add_gain_rate(rate)
			produced_rates[cur] = rate
		
		if bonus_production.size() > 0:
			for cur in bonus_production:
				var currency = wa.get_currency(cur) as Currency
				var rate = Big.new(produced_currencies.values()[0].get_value())
				rate.m(bonus_production[cur]) # modifier set in Upgrade
				rate.d(_duration)
				
				currency.add_gain_rate(rate)
				produced_rates[cur] = rate
	
	if has_required_currencies and type != Type.REFUEL:
		required_rates.clear()
		for cur in required_currencies.cost:
			var currency = wa.get_currency(cur) as Currency
			var rate = get_loss_rate(cur)
			
			currency.add_loss_rate(rate)
			required_rates[cur] = rate


func subtract_rate() -> void:
	if not added_rate:
		return
	added_rate = false
	
	var _duration = duration.get_as_float()
	if has_produced_currencies:
		for cur in produced_rates:
			var currency = wa.get_currency(cur) as Currency
			currency.subtract_gain_rate(Big.new(produced_rates[cur]))
	if has_required_currencies and type != Type.REFUEL:
		for cur in required_currencies.cost:
			var currency = wa.get_currency(cur) as Currency
			currency.subtract_loss_rate(required_rates[cur])



func start() -> void:
	starting = true
	if has_produced_currencies:
		in_hand_output.clear()
		for cur in produced_currencies:
			in_hand_output[cur] = Big.new(produced_currencies[cur].get_value())
			wa.add_pending(cur, in_hand_output[cur])
		for cur in bonus_production:
			in_hand_output[cur] = Big.new(lv.get_lored(lored).output.get_value()).m(bonus_production[cur])
			wa.add_pending(cur, in_hand_output[cur])
	
	elif type == Type.REFUEL:
		in_hand_output["REFUEL"] = lv.get_lored(lored).fuel.get_x_percent(0.5)
		lv.get_lored(lored).fuel.add_pending(in_hand_output["REFUEL"])
	
	if has_required_currencies:
		required_currencies.spend(false)
		in_hand_input.clear()
		for cur in required_currencies.cost:
			in_hand_input[cur] = Big.new(required_currencies.cost[cur].get_value())
	
	add_rate()
	starting = false
	working = true
	
	lv.get_lored(lored).fuel.subtract(fuel_cost.get_value())
	start_timer()
	emit_signal("began_working")


func start_timer() -> void:
	if not is_instance_valid(timer):
		timer = Timer.new()
		timer.one_shot = true
		lv.add_child(timer)
		timer.timeout.connect(complete)
	timer.start(duration.get_as_float())


func stop() -> void:
	no_longer_working()
	emit_signal("cut_short")
	timer.stop()


func stop_and_refund() -> void:
	if has_required_currencies:
		required_currencies.refund()
	if fuel_cost.greater(0):
		lv.get_lored(lored).fuel.add(fuel_cost.get_value())
	stop()



func complete() -> void:
	no_longer_working()
	
	if has_produced_currencies:
		var total_produced_amount := Big.new()
		var mult = 1.0 if randf_range(0, 100) > crit.get_as_float() else randf_range(7.5, 12.5)
		for cur in in_hand_output:
			wa.get_currency(cur).last_crit_modifier = mult
			last_production[cur] = in_hand_output[cur].m(mult)
			total_produced_amount.a(last_production[cur])
			wa.add_from_lored(cur, last_production[cur])
		
		currency_produced.emit(total_produced_amount)
	
	if has_method("complete_" + key):
		call("complete_" + key)
	emit_signal("completed")


func no_longer_working() -> void:
	last_production.clear()
	working = false
	if has_produced_currencies:
		for cur in produced_currencies:
			wa.subtract_pending(cur, in_hand_output[cur])
	elif type == Type.REFUEL:
		lv.get_lored(lored).fuel.subtract_pending(in_hand_output["REFUEL"])
	emit_signal("stopped_working")


func complete_REFUEL() -> void:
	lv.get_lored(lored).fuel.add(in_hand_output["REFUEL"])



# - Get


func can_start() -> bool:
	if not unlocked:
		return false
	if type != Type.REFUEL and lv.get_lored(lored).fuel.get_current_percent() <= lv.FUEL_DANGER:
		return false
	
	var special_requirement_method := "can_start_job_special_requirements_" + key
	if has_method(special_requirement_method):
		if not call(special_requirement_method):
			return false
	
	if has_required_currencies:
		if (
			not required_currencies.use_allowed
			or required_currencies.affordable.is_false()
			or not required_currencies.can_take_candy_from_a_baby()
		):
			return false
	
	if type == Type.REFUEL:
		return true
	return has_sufficient_fuel


func can_start_job_special_requirements_REFUEL() -> bool:
	var _lored = lv.get_lored(lored)
	if _lored.fuel.get_current_percent() > lv.FUEL_WARNING:
		return false
	if ( # if coal's fuel < 50%
		_lored.fuel_currency == Currency.Type.COAL
		and _lored.type != LORED.Type.COAL
		and lv.get_lored(LORED.Type.COAL).fuel.get_current_percent() <= lv.FUEL_WARNING
	):
		return false
	return true


func get_produced_currencies() -> Array:
	var arr := []
	if has_produced_currencies:
		for cur in produced_currencies:
			arr.append(cur)
	return arr


func get_required_currency_types() -> Array:
	if not has_required_currencies:
		return []
	return required_currencies.cost.keys()


func get_primary_currency() -> int:
	if has_produced_currencies:
		return produced_currencies.keys()[0]
	elif has_required_currencies:
		return required_currencies.cost.keys()[0]
	return lv.get_lored(lored).primary_currency


func get_fuel_cost() -> Big:
	return fuel_cost.get_value()


func get_animation_key() -> String:
	if two_part_animation:
		if part_one_played:
			return animation_key + "2"
	elif type == Type.REFUEL:
		return animation_key + str(randi_range(0, 1))
	return animation_key


func get_attributes_by_currency(currency: int) -> Array:
	var arr := []
	if has_required_currencies:
		for cur in required_currencies.cost:
			if cur == currency:
				arr.append(required_currencies.cost[cur])
	return arr


func produces_currency(cur: int) -> bool:
	if not unlocked:
		return false
	if not produced_currencies:
		return false
	if cur in bonus_production.keys():
		return true
	return cur in produced_currencies.keys()


func uses_currency(cur: int) -> bool:
	if not unlocked:
		return false
	if not has_required_currencies:
		return false
	return cur in required_currencies.cost.keys()



func get_gain_rate(cur: int) -> Big:
	return Big.new(produced_currencies[cur].get_value()).d(duration.get_as_float())


func get_loss_rate(cur: int) -> Big:
	return Big.new(required_currencies.cost[cur].get_value()).d(duration.get_as_float())
