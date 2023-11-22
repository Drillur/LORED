class_name Cost
extends RefCounted



const saved_vars := [
	"times_purchased"
]

signal became_safe

const CACHE_SIZE := 50

var cost := {}
var cache := {}

var produced_by := []

var affordable := Bool.new(false)
var use_allowed := Bool.new(true) # set by player in Wallet
var purchased := false:
	set(val):
		if purchased != val:
			times_purchased.add(1)
			if repeatable:
				return
			purchased = val
			if val:
				disconnect_calls()
			else:
				connect_calls()
var currencies_are_unlocked := false
var has_stage1_currency := false
var cached := false
var repeatable := false

var times_purchased := Int.new(0)

var stage: int
var longest_eta_cur: int = -1




func _init(_cost: Dictionary) -> void:
	cost = _cost
	longest_eta_cur = cost.keys()[0]
	SaveManager.load_finished.connect(recheck)
	lv.loreds_initialized.became_true.connect(loreds_initialized)
	for cur in cost:
		wa.get_currency(cur).safe.became_true.connect(currency_became_safe)
	connect_calls()
	recheck()


func connect_calls() -> void:
	for cur in cost:
		if not wa.currency[cur].count.increased.is_connected(currency_increased):
			wa.currency[cur].count.increased.connect(currency_increased)
			wa.currency[cur].count.decreased.connect(currency_decreased)


func disconnect_calls() -> void:
	for cur in cost:
		if wa.currency[cur].count.increased.is_connected(currency_increased):
			wa.currency[cur].count.increased.disconnect(currency_increased)
			wa.currency[cur].count.decreased.disconnect(currency_decreased)


func loreds_initialized() -> void:
	for cur in cost:
		var currency = wa.get_currency(cur) as Currency
		for x in currency.produced_by:
			if not x in produced_by:
				produced_by.append(x)
				var lored = lv.get_lored(x)
				if lored.stage == 1:
					if not lored.became_an_adult.is_connected(baby_became_adult):
						lored.became_an_adult.connect(baby_became_adult)
		if currency.stage == 1:
			has_stage1_currency = true
		currency.use_allowed.changed.connect(currency_use_allowed_changed)
		currency.unlocked.changed.connect(currency_unlocked_changed)


func currency_use_allowed_changed() -> void:
	for cur in cost:
		if not wa.is_use_allowed(cur):
			use_allowed.set_to(false)
			return
	use_allowed.set_to(true)


func currency_unlocked_changed() -> void:
	currencies_are_unlocked = wa.currencies_in_list_are_unlocked(cost.keys())


func currency_became_safe() -> void:
	for cur in cost:
		if not wa.is_currency_safe_to_spend(cur):
			return
	became_safe.emit()



# - Notify

func currency_increased() -> void:
	if affordable.is_false() and can_afford():
		affordable.set_to(true)


func currency_decreased() -> void:
	if affordable.is_true() and cannot_afford():
		affordable.set_to(false)



# - Action


func recheck() -> void:
	affordable.set_to(can_afford())


func buy_up_to_x_times(from_player: bool, level: int, x := CACHE_SIZE) -> int:
	var left := level
	var mid := 0
	var right := clampi(x, 0, CACHE_SIZE)
	while left < right:
		mid = left + (right - left) / 2
		if can_afford_at_level(mid):
			left = mid + 1
		else:
			right = mid
	var gained_levels: int = left - level
	times_purchased.add(gained_levels)
	if from_player:
		for cur in cost:
			wa.subtract_from_player(cur, cache[gained_levels][cur])
	else:
		for cur in cost:
			wa.subtract_from_lored(cur, cache[gained_levels][cur])
	return gained_levels


func can_afford_at_level(level: int) -> bool:
	for cur in cost:
		if cache[level][cur].greater(wa.get_count(cur)):
			return false
	return true


func purchase(from_player: bool) -> void:
	if from_player:
		for cur in cost:
			wa.subtract_from_player(cur, Big.new(cost[cur].get_value()))
	else:
		for cur in cost:
			wa.subtract_from_lored(cur, Big.new(cost[cur].get_value()))
	purchased = true


func refund() -> void:
	for cur in cost:
		wa.add(cur, Big.new(cost[cur].get_value()))
	purchased = false
	recheck()
	affordable.changed.emit()


func cache_costs() -> void:
	for i in range(0, CACHE_SIZE + 1):
		var cost_at_i := {}
		for cur in cost:
			cost_at_i[cur] = Big.new(3).power(i).m(cost[cur].get_value())
		cache[i] = cost_at_i
	cached = true


func reset() -> void:
	times_purchased.reset()
	for cur in cost:
		cost[cur].reset()
	recheck()


func increase(level: int) -> void:
	for cur in cost:
		cost[cur].set_to(cache[level][cur])
	recheck()


func increase_m_from_lored(amount) -> void:
	for cur in cost:
		cost[cur].set_m_from_lored(amount)
	recheck()



func throw_texts(parent_node: Node, bought: bool) -> void:
	if Engine.get_frames_per_second() >= 60:
		var text = FlyingText.new(
			FlyingText.Type.CURRENCY,
			parent_node, # node used to determine text locations
			parent_node, # node that will hold texts
			[2, 2], # collision
		)
		for cur in cost:
			text.add({
				"cur": cur,
				"text": ("-" if bought else "+") + cost[cur].get_text(),
				"crit": false,
			})
		text.go()



# - Get


func can_afford() -> bool:
	for cur in cost:
		if wa.get_count(cur).less(cost[cur].get_value()):
			return false
	return true


func cannot_afford() -> bool:
	return not can_afford()


func is_safe_to_purchase() -> bool:
	for cur in cost:
		if not wa.is_currency_safe_to_spend(cur):
			return false
	return true


func get_text() -> Array:
	var text := []
	for cur in cost:
		text.append(cost[cur].get_total_text())
	return text


func get_insufficient_currency_types() -> Array:
	if affordable.is_true():
		return []
	var array := []
	for cur in cost:
		if wa.get_count(cur).less(cost[cur].get_value()):
			array.append(cur)
	return array


func get_eta() -> Big:
	if currencies_are_unlocked:
		longest_eta_cur = cost.keys()[0]
		
		var eta: Big = wa.get_currency(longest_eta_cur).get_eta(cost.values()[0].get_value())
		for i in cost.size():
			var cur = wa.get_currency(cost.keys()[i]) as Currency
			
			if cur.net_rate.positive.is_false():
				longest_eta_cur = -1
				return Big.new(0)
			
			var i_eta = cur.get_eta(cost.values()[i].get_value())
			if i_eta.greater(eta):
				eta = i_eta
				longest_eta_cur = cur.type
		
		return Big.new(eta)
	
	return Big.new(0)


func get_progress_percent() -> float:
	if (
		currencies_are_unlocked
		and not lv.any_loreds_in_list_are_inactive(produced_by)
		and not longest_eta_cur == -1
	):
		var count = wa.get_count(longest_eta_cur)
		var _cost = cost[longest_eta_cur].get_value()
		return count.percent(_cost)
	
	var total_percent = cost.size()
	var percent := 0.0
	for cur in cost:
		var currency = wa.get_currency(cur)
		var _cost = cost[cur].get_value()
		percent += currency.count.percent(_cost)
	return percent / total_percent



func can_take_candy_from_a_baby() -> bool:
	if (
		stage > 1
		and has_stage1_currency
		and up.is_upgrade_purchased(Upgrade.Type.DONT_TAKE_CANDY_FROM_BABIES)
	):
		for cur in cost:
			var currency = wa.get_currency(cur)
			if currency.stage == 1:
				for lored_type in currency.produced_by:
					var lored = lv.get_lored(lored_type)
					if lored.stage != 1:
						continue
					if lored.level.greater_equal(5):
						return true
				return false
	return true


func baby_became_adult() -> void:
	if can_take_candy_from_a_baby() and affordable.is_true():
		affordable.became_true.emit()
	else:
		recheck()



# - Debug


func report() -> void:
	print("---Cost Report (", self, ")---")
	print("Cost (Affordable: ", affordable.get_value(), "):")
	for cur in cost:
		var currency = wa.get_currency(cur)
		printt(" ", currency.key, cost[cur].get_text())
	printt("Use allowed:", use_allowed.get_value())
	printt("Can take candy from a baby:", can_take_candy_from_a_baby())
