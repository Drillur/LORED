class_name Cost
extends RefCounted



signal became_affordable
signal became_unaffordable
signal affordable_changed(affordable)
signal use_allowed_changed(allowed)

var cost := {}
var affordable := false:
	set(val):
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
		if purchased == val:
			return
		purchased = val
		if val:
			for cur in cost:
				wa.currency[cur].count.disconnect("increased", currency_increased)
				wa.currency[cur].count.disconnect("decreased", currency_decreased)
		else:
			if can_afford():
				for cur in cost:
					wa.currency[cur].count.connect("decreased", currency_increased)
			else:
				for cur in cost:
					wa.currency[cur].count.connect("increased", currency_increased)



func _init(_cost: Dictionary) -> void:
	cost = _cost
	notify_if_increased()
	currency_increased()
	SaveManager.connect("load_finished", recheck)
	for cur in cost:
		wa.get_currency(cur).use_allowed_changed.connect(currency_use_allowed_changed)


func notify_if_increased() -> void:
	if not purchased:
		for cur in cost:
			if wa.currency[cur].count.is_connected("decreased", currency_decreased):
				wa.currency[cur].count.disconnect("decreased", currency_decreased)
			wa.currency[cur].count.connect("increased", currency_increased)


func notify_if_decreased() -> void:
	if not purchased:
		for cur in cost:
			if wa.currency[cur].count.is_connected("increased", currency_increased):
				wa.currency[cur].count.disconnect("increased", currency_increased)
			wa.currency[cur].count.connect("decreased", currency_decreased)



func currency_use_allowed_changed(allowed: bool) -> void:
	if not allowed:
		use_allowed = false
	else:
		for cur in cost:
			if not wa.is_use_allowed(cur):
				return
		use_allowed = true



# - Notify

func currency_increased() -> void:
	if affordable:
		return
	if can_afford():
		affordable = true
		notify_if_decreased()



func currency_decreased() -> void:
	if not affordable:
		return
	if not can_afford():
		affordable = false
		notify_if_increased()



# - Action

func recheck() -> void:
	for cur in cost:
		if wa.currency[cur].count.increased.is_connected(currency_increased):
			wa.currency[cur].count.disconnect("increased", currency_increased)
		if wa.currency[cur].count.decreased.is_connected(currency_decreased):
			wa.currency[cur].count.disconnect("decreased", currency_decreased)
	affordable = can_afford()
	if affordable:
		notify_if_decreased()
	else:
		notify_if_increased()


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


func increase(times_purchased: int, cost_increase: float) -> void:
	for cur in cost:
		var new_val = Big.new(cost_increase).power(times_purchased)
		cost[cur].set_from_level(new_val)


func increase_m_from_lored(amount) -> void:
	for cur in cost:
		cost[cur].set_m_from_lored(amount)


func remove_cost(currency: int) -> void:
	if currency in cost.keys():
		cost[currency].disconnect("increased", currency_increased)
		cost.erase(currency)



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
	var cur: Currency = wa.get_currency(cost.keys()[0])
	var eta: Big = cur.get_eta(cost.values()[0].get_value())
	for i in range(1, cost.size()):
		cur = wa.get_currency(cost.keys()[i])
		var i_eta = cur.get_eta(cost.values()[i].get_value())
		if i_eta.greater(eta):
			eta = i_eta
	return eta


func get_progress_percent() -> float:
	var lowest_percent := 1.0
	for cur in cost:
		var count = wa.get_count(cur)
		var _cost = cost[cur].get_value()
		if count.less(_cost):
			var percent = count.percent(_cost)
			if percent < lowest_percent:
				lowest_percent = percent
	return lowest_percent
