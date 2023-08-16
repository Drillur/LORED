extends Node



signal save_finished
signal load_finished


func save() -> String:
	var data := {}
	data["wallet_unlocked"] = var_to_str(wallet_unlocked)
	for cur in currency:
		var _currency: Currency = currency[cur]
		data[_currency.key] = _currency.save()
	emit_signal("save_finished")
	return var_to_str(data)


func load_data(data_str: String) -> void:
	var data: Dictionary = str_to_var(data_str)
	wallet_unlocked = str_to_var(data["wallet_unlocked"])
	for cur in currency:
		var key = Currency.Type.keys()[cur]
		if key in data.keys():
			currency[cur].load_data(data[key])
	emit_signal("load_finished")



signal currency_just_unlocked(cur)
signal wallet_unlocked_changed(unlocked)

var currency := {}

var unlocked_currencies := []
var total_weight := 0
var wallet_unlocked := false:
	set(val):
		if wallet_unlocked != val:
			wallet_unlocked = val
			emit_signal("wallet_unlocked_changed", val)



func _ready():
	open()
	for cur in currency.keys():
		gv.add_currency_to_stage(get_currency_stage(cur), cur)



func close() -> void:
	currency.clear()
	unlocked_currencies.clear()
	total_weight = 0
	wallet_unlocked = false


func open() -> void:
	for cur in Currency.Type.values():
		currency[cur] = Currency.new(cur)



# - Action

func add(cur: int, amount) -> void:
	currency[cur].add(amount)


func subtract(cur: int, amount) -> void:
	currency[cur].subtract(amount)


func add_pending(cur: int, amount: Big) -> void:
	currency[cur].add_pending(amount)


func subtract_pending(cur: int, amount) -> void:
	currency[cur].subtract_pending(amount)


func add_producer(cur: int, lored: int) -> void:
	currency[cur].add_producer(lored)


func add_from_lored(cur: int, amount) -> void:
	currency[cur].add_from_lored(amount)


func subtract_from_lored(cur: int, amount) -> void:
	currency[cur].subtract_from_lored(amount)


func subtract_from_player(cur: int, amount) -> void:
	currency[cur].subtract_from_player(amount)



func unlock_currency(cur: int) -> void:
	var _currency := get_currency(cur)
	if cur in unlocked_currencies:
		return
	_currency.unlock()
	unlocked_currencies.append(cur)
	total_weight += _currency.weight
	emit_signal("currency_just_unlocked", cur)



func add_current_loss_rate(cur: int, amount) -> void:
	var currency = get_currency(cur)
	currency.add_current_loss_rate(amount)


func subtract_current_loss_rate(cur: int, amount) -> void:
	var currency = get_currency(cur)
	currency.subtract_current_loss_rate(amount)


func add_total_loss_rate(cur: int, amount) -> void:
	var currency = get_currency(cur)
	currency.add_total_loss_rate(amount)


func subtract_total_loss_rate(cur: int, amount) -> void:
	var currency = get_currency(cur)
	currency.subtract_total_loss_rate(amount)




# - Get

func get_count(cur: int) -> Big:
	return currency[cur].get_count()


func get_count_text(cur: int) -> String:
	return currency[cur].get_count_text()


func get_color(cur: int) -> Color:
	return currency[cur].color


func get_icon(cur: int) -> Texture:
	return currency[cur].icon


func get_currency_name(cur: int) -> String:
	return currency[cur].name


func get_colored_currency_name(cur: int) -> String:
	return currency[cur].colored_name


func get_currency(cur: int) -> Currency:
	return currency[cur]


func get_currency_weight(cur: int) -> int:
	return get_currency(cur).weight


func get_currency_stage(cur: int) -> int:
	return currency[cur].stage


func get_random_unlocked_currency() -> int:
	return unlocked_currencies[randi() % unlocked_currencies.size()]


func get_weighted_random_currency() -> int:
	var roll = randi() % total_weight
	var shuffled_pool = unlocked_currencies
	shuffled_pool.shuffle()
	for cur in shuffled_pool:
		var weight = get_currency_weight(cur)
		if roll < weight:
			return cur
		roll -= weight
	print_debug("May be an issue with total_weight (", total_weight, "). pool size: ", shuffled_pool.size())
	return get_random_unlocked_currency()


func get_icon_and_name_text(cur: int) -> String:
	return currency[cur].icon_and_name_text


func is_current_rate_positive(cur: int) -> bool:
	return get_currency(cur).positive_current_rate


func get_currencies_in_stage(stage: int) -> Array:
	return gv.get_currencies_in_stage(stage)
