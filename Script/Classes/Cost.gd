class_name Cost
extends Resource



signal became_affordable
signal became_unaffordable
signal affordable_changed(affordable)

var cost := {}
var affordable := false:
	set(val):
		affordable = val
		if val:
			emit_signal("became_affordable")
		else:
			emit_signal("became_unaffordable")
		emit_signal("affordable_changed", affordable)

var purchased := false:
	set(val):
		if purchased == val:
			return
		purchased = val
		if val:
			for cur in cost:
				wa.currency[cur].count.remove_notify_method(currency_increased)
				wa.currency[cur].count.remove_notify_method(currency_decreased)
		else:
			if can_afford():
				for cur in cost:
					wa.currency[cur].count.add_notify_decreased_method(currency_increased)
			else:
				for cur in cost:
					wa.currency[cur].count.add_notify_increased_method(currency_increased)



func _init(_cost: Dictionary) -> void:
	cost = _cost
	for cur in cost:
		wa.currency[cur].count.add_notify_increased_method(currency_increased)
	SaveManager.connect("load_finished", recheck)


func notify_if_increased() -> void:
	if not purchased:
		for cur in cost:
			wa.currency[cur].count.remove_notify_method(currency_decreased)
			wa.currency[cur].count.add_notify_increased_method(currency_increased)


func notify_if_decreased() -> void:
	if not purchased:
		for cur in cost:
			wa.currency[cur].count.remove_notify_method(currency_increased)
			wa.currency[cur].count.add_notify_decreased_method(currency_decreased)



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
		wa.currency[cur].count.remove_notify_method(currency_decreased)
		wa.currency[cur].count.remove_notify_method(currency_increased)
	if can_afford():
		affordable = true
		notify_if_decreased()
	else:
		affordable = false
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
		cost[currency].remove_notify_method(currency_increased)
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
		text.append(
			cost[cur].get_total_text()
		)
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

