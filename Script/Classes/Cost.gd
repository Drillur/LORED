class_name Cost
extends RefCounted



signal became_affordable
signal became_unaffordable
signal affordable_changed(affordable)
signal use_allowed_changed(allowed)

var cost := {}
var base_cost := {}
var affordable := false:
	set(val):
		if affordable != val:
			affordable = val
			if val:
				emit_signal("became_affordable")
			else:
				emit_signal("became_unaffordable")
			emit_signal("affordable_changed", affordable)
var use_allowed := true:
	set(val):
		if use_allowed != val:
			use_allowed = val
			use_allowed_changed.emit(val)
var purchased := false:
	set(val):
		if purchased != val:
			purchased = val
			if val:
				disconnect_calls()
			else:
				connect_calls()
var currencies_are_unlocked := false:
	set(val):
		if not currencies_are_unlocked == val:
			currencies_are_unlocked = val


var has_stage1_currency := false

var stage: int
var longest_eta_cur: int = -1




func _init(_cost: Dictionary) -> void:
	cost = _cost
	base_cost = cost
	longest_eta_cur = cost.keys()[0]
	SaveManager.connect("load_finished", recheck)
	for cur in cost:
		var currency = wa.get_currency(cur) as Currency
		if currency.stage == 1:
			has_stage1_currency = true
		currency.use_allowed_changed.connect(currency_use_allowed_changed)
		currency.unlocked_changed.connect(currency_unlocked_changed)
	connect_calls()
	recheck()


func connect_calls() -> void:
	for cur in cost:
		if not wa.currency[cur].count.is_connected("increased", currency_increased):
			wa.currency[cur].count.connect("increased", currency_increased)
			wa.currency[cur].count.connect("decreased", currency_decreased)


func disconnect_calls() -> void:
	for cur in cost:
		if wa.currency[cur].count.is_connected("increased", currency_increased):
			wa.currency[cur].count.disconnect("increased", currency_increased)
			wa.currency[cur].count.disconnect("decreased", currency_decreased)



func currency_use_allowed_changed(allowed: bool) -> void:
	if not allowed:
		use_allowed = false
	else:
		for cur in cost:
			if not wa.is_use_allowed(cur):
				return
		use_allowed = true


func currency_unlocked_changed(unlocked: bool) -> void:
	if unlocked:
		if currencies_are_unlocked:
			return
		if wa.currencies_in_list_are_unlocked(cost.keys()):
			currencies_are_unlocked = true
	else:
		currencies_are_unlocked = false



# - Notify

func currency_increased() -> void:
	if affordable:
		return
	if can_afford():
		affordable = true


func currency_decreased() -> void:
	if not affordable:
		return
	if not can_afford():
		affordable = false



# - Action

func recheck() -> void:
	affordable = can_afford()


func spend(from_player: bool) -> void:
	if from_player:
		for cur in cost:
			wa.subtract_from_player(cur, cost[cur].get_value())
	else:
		for cur in cost:
			wa.subtract_from_lored(cur, cost[cur].get_value())


func purchase(from_player: bool) -> void:
	spend(from_player)
	purchased = true


func refund() -> void:
	for cur in cost:
		wa.add(cur, cost[cur].get_value())
	purchased = false


func reset() -> void:
	for cur in cost:
		cost[cur].reset()
	recheck()


func increase(times_purchased: int, cost_increase: float) -> void:
	for cur in cost:
		var new_val = Big.new(cost_increase).power(times_purchased)
		cost[cur].set_from_level(new_val)
	recheck()


func increase_m_from_lored(amount) -> void:
	for cur in cost:
		cost[cur].set_m_from_lored(amount)
	recheck()


func erase_currency_from_cost(cur: int) -> void:
	if cur in cost.keys():
		if not purchased:
			cost[cur].disconnect("increased", currency_increased)
		cost.erase(cur)
		recheck()


func add_currency_to_cost(cur: int) -> void:
	if not cur in base_cost.keys():
		cost[cur] = Value.new(base_cost[cur].get_value())
		if not purchased:
			cost[cur].increased.connect(currency_increased)
		connect_calls()



func throw_texts(parent_node: Node) -> void:
	var data := {}
	for cur in cost:
		data[cur] = cost[cur].get_value()
	gv.throw_texts_by_dictionary(parent_node, data, "-")



# - Get

func can_afford() -> bool:
	for cur in cost:
		if wa.get_count(cur).less(cost[cur].get_value()):
			return false
	return true


func get_text() -> Array:
	var text := []
	for cur in cost:
		text.append(cost[cur].get_total_text())
	return text


func get_insufficient_currency_types() -> Array:
	if affordable:
		return []
	var array := []
	for cur in cost:
		if wa.get_count(cur).less(cost[cur].get_value()):
			array.append(cur)
	return array


func get_eta() -> Big:
	if currencies_are_unlocked:
		var cur: Currency = wa.get_currency(cost.keys()[0])
		var eta: Big = cur.get_eta(cost.values()[0].get_value())
		longest_eta_cur = cur.type
		for i in range(1, cost.size()):
			cur = wa.get_currency(cost.keys()[i])
			var i_eta = cur.get_eta(cost.values()[i].get_value())
			if i_eta.greater(eta):
				eta = i_eta
				longest_eta_cur = cur.type
		return eta
	return Big.new(0)


func get_progress_percent() -> float:
	if currencies_are_unlocked:
		var count = wa.get_count(longest_eta_cur)
		var _cost = cost[longest_eta_cur].get_value()
		return count.percent(_cost)
	
	var total_percent = cost.size()
	var percent := 0.0
	for cur in cost:
		var currency = wa.get_currency(cur) 
		var count = currency.count
		var _cost = cost[cur].get_value()
		percent += count.percent(_cost)
	return percent / total_percent



func can_take_candy_from_a_baby() -> bool:
	if has_stage1_currency:
		if up.is_upgrade_purchased(Upgrade.Type.DONT_TAKE_CANDY_FROM_BABIES):
			for cur in cost:
				var currency = wa.get_currency(cur)
				if currency.stage == 1:
					var lored = lv.get_lored(currency.produced_by[0])
					if lored.level < 5:
						return false
	return true
