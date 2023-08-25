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
	SOIL,
	AXES,
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
var added_current_rate := false
var added_total_rate := false
var working := false
var added_rate_based_on_inhand: bool

var has_sufficient_fuel := true
var has_produced_currencies := false
var produced_currencies := {}
var produced_rates := {}
var in_hand_output := {}
var has_required_currencies := false
var in_hand_input := {}
var required_currencies: Cost
var required_rates := {}

var timer: Timer

var last_production := {}

var duration: Value
var fuel_cost: Value



func _init(_type: int) -> void:
	type = _type
	key = Type.keys()[type]
	
	call("init_" + key)
	
	fuel_cost = Value.new(duration.get_as_float())
	
	has_required_currencies = required_currencies != null
	has_produced_currencies = not produced_currencies.is_empty()
	
	unlocked_changed.connect(became_unlocked)
	
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


func assign_lored(_lored: int) -> void:
	lored = _lored
	crit = lv.get_lored(lored).crit
	lv.get_lored(lored).fuel.connect("increased", fuel_increased)
	lv.get_lored(lored).fuel.connect("decreased", fuel_decreased)
	if type == Type.REFUEL:
		var half = Big.new(lv.get_lored(lored).fuel.get_total()).do_not_emit().d(2).toFloat()
		has_required_currencies = true
		required_currencies = Cost.new({
			lv.get_lored(lored).fuel_currency: Value.new(half)
		})
		hookup_required_currencies()
		animation_key = "refuel"
	else:
		animation_key = lv.get_lored(lored).key
	
	lv.get_lored(lored).connect("job_started", another_job_started)
	lv.get_lored(lored).connect("stopped_working", subtract_current_rate)



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
		required_currencies.connect("became_affordable", emit_workable)
		required_currencies.use_allowed_changed.connect(required_currency_use_allowed_changed)


func add_produced_currency(currency: int, amount: float) -> void:
	produced_currencies[currency] = Value.new(amount)



# - Signal

func lored_output_changed() -> void:
	subtract_rates()
	for x in produced_currencies.values():
		x.set_m_from_lored(lv.get_lored(lored).get_output())
	add_rates()


func lored_input_changed() -> void:
	subtract_rates()
	required_currencies.increase_m_from_lored(lv.get_lored(lored).get_input())
	add_rates()


func lored_haste_changed() -> void:
	subtract_rates()
	duration.set_d_from_lored(lv.get_lored(lored).get_haste())
	fuel_cost.set_d_from_lored(lv.get_lored(lored).get_haste())
	add_rates()


func lored_fuel_cost_changed() -> void:
	fuel_cost.set_m_from_lored(lv.get_lored(lored).get_fuel_cost())
	has_sufficient_fuel = lv.get_lored(lored).fuel.get_current().greater_equal(fuel_cost.get_value())


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
				and required_currencies.affordable
			)
		)
	):
		became_workable.emit()


func fuel_increased() -> void:
	if has_sufficient_fuel:
		return
	if lv.get_lored(lored).fuel.get_current().greater_equal(fuel_cost.get_value()):
		has_sufficient_fuel = true


func fuel_decreased() -> void:
	if not has_sufficient_fuel:
		return
	if lv.get_lored(lored).fuel.get_current().less(fuel_cost.get_value()):
		has_sufficient_fuel = false


func another_job_started(job: Job) -> void:
	if job != self:
		subtract_current_rate()



# - Actions


func can_start() -> bool:
	if not unlocked:
		return false
	if lv.get_lored(lored).fuel.get_current_percent() <= lv.FUEL_DANGER and type != Type.REFUEL:
		return false
	if has_method("can_start_job_special_requirements_" + key):
		if not call("can_start_job_special_requirements_" + key):
			return false
	if has_required_currencies:
		if (
			not required_currencies.use_allowed
			or not required_currencies.affordable
		):
			return false
	return has_sufficient_fuel


func can_start_job_special_requirements_REFUEL() -> bool:
	var _lored = lv.get_lored(lored)
	if _lored.fuel.get_current_percent() > lv.FUEL_WARNING:
		return false
	if (
		_lored.fuel_currency == Currency.Type.COAL
		and _lored.type != LORED.Type.COAL
		and lv.get_lored(LORED.Type.COAL).fuel.get_current_percent() <= lv.FUEL_WARNING
	):
		return false
	return true



func subtract_rates() -> void:
	subtract_current_rate()
	subtract_total_rate()


func add_rates() -> void:
	if not lv.get_lored(lored).purchased:
		return
	add_current_rate()
	add_total_rate()



func add_current_rate() -> void:
	if not starting and not working:
		return
	if added_current_rate:
		return
	added_current_rate = true
	
	if not has_produced_currencies and not has_required_currencies:
		return
	
	added_rate_based_on_inhand = not working
	
	var _duration = duration.get_as_float()
	if has_produced_currencies:
		for cur in produced_currencies:
			var currency = wa.get_currency(cur) as Currency
			if added_rate_based_on_inhand:
				currency.add_current_gain_rate(Big.new(in_hand_output[cur]).d(_duration))
			else:
				currency.add_current_gain_rate(Big.new(produced_currencies[cur].get_value()).d(_duration))
	if has_required_currencies and type != Type.REFUEL:
		for cur in required_currencies.cost:
			var currency = wa.get_currency(cur) as Currency
			if added_rate_based_on_inhand:
				currency.add_current_loss_rate(Big.new(in_hand_input[cur]).d(_duration))
			else:
				currency.add_current_loss_rate(Big.new(required_currencies.cost[cur].get_value()).d(_duration))


func add_total_rate() -> void:
	if not has_produced_currencies and not has_required_currencies:
		return
	if added_total_rate:
		return
	added_total_rate = true
	
	var _duration = duration.get_as_float()
	if has_produced_currencies:
		produced_rates.clear()
		for cur in produced_currencies:
			var currency = wa.get_currency(cur) as Currency
			var rate = Big.new(produced_currencies[cur].get_value()).d(_duration)
			
			currency.add_total_gain_rate(rate)
			produced_rates[cur] = rate
	
	if has_required_currencies and type != Type.REFUEL:
		required_rates.clear()
		for cur in required_currencies.cost:
			var currency = wa.get_currency(cur) as Currency
			var rate = Big.new(required_currencies.cost[cur].get_value()).d(_duration)
			
			currency.add_total_loss_rate(rate)
			required_rates[cur] = rate


func subtract_current_rate() -> void:
	if not added_current_rate:
		return
	added_current_rate = false
	
	if not has_produced_currencies and not has_required_currencies:
		return
	
	var _duration = duration.get_as_float()
	if has_produced_currencies:
		for cur in produced_currencies:
			var currency = wa.get_currency(cur) as Currency
			if added_rate_based_on_inhand:
				currency.subtract_current_gain_rate(Big.new(in_hand_output[cur]).d(_duration))
			else:
				currency.subtract_current_gain_rate(Big.new(produced_currencies[cur].get_value()).d(_duration))
	if has_required_currencies and type != Type.REFUEL:
		for cur in required_currencies.cost:
			var currency = wa.get_currency(cur) as Currency
			if added_rate_based_on_inhand:
				currency.subtract_current_loss_rate(Big.new(in_hand_input[cur]).d(_duration))
			else:
				currency.subtract_current_loss_rate(Big.new(required_currencies.cost[cur].get_value()).d(_duration))


func subtract_total_rate() -> void:
	if not added_total_rate:
		return
	if not has_produced_currencies and not has_required_currencies:
		return
	added_total_rate = false
	
	var _duration = duration.get_as_float()
	if has_produced_currencies:
		for cur in produced_currencies:
			var currency = wa.get_currency(cur) as Currency
			currency.subtract_total_gain_rate(Big.new(produced_currencies[cur].get_value()).d(_duration))
	if has_required_currencies and type != Type.REFUEL:
		for cur in required_currencies.cost:
			var currency = wa.get_currency(cur) as Currency
			currency.subtract_total_loss_rate(Big.new(required_currencies.cost[cur].get_value()).d(_duration))



func start() -> void:
	starting = true
	if has_produced_currencies:
		in_hand_output.clear()
		for cur in produced_currencies:
			in_hand_output[cur] = produced_currencies[cur].get_value()
			wa.add_pending(cur, in_hand_output[cur])
	elif type == Type.REFUEL:
		in_hand_output["REFUEL"] = lv.get_lored(lored).fuel.get_x_percent(0.5)
		lv.get_lored(lored).fuel.add_pending(in_hand_output["REFUEL"])
	if has_required_currencies:
		required_currencies.spend(false)
		in_hand_input.clear()
		for cur in required_currencies.cost:
			in_hand_input[cur] = required_currencies.cost[cur].get_value()
	
	add_current_rate()
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


func complete() -> void:
	no_longer_working()
	if has_produced_currencies:
		var multiplier := 1.0
		if randf_range(0, 100) < crit.get_as_float():
			multiplier = randf_range(7.5, 12.5)
		for cur in produced_currencies:
			last_production[cur] = in_hand_output[cur].m(multiplier)
			wa.add_from_lored(cur, last_production[cur])
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


func get_required_currency(_currency: int) -> Attribute:
	return required_currencies.cost[_currency]


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
	return cur in produced_currencies.keys()


func uses_currency(cur: int) -> bool:
	if not unlocked:
		return false
	if not has_required_currencies:
		return false
	return cur in required_currencies.cost.keys()

