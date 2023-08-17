extends Node



var saved_vars := [
	"wallet_unlocked",
	"currency_by_key",
]


signal currency_just_unlocked(cur)
signal wallet_unlocked_changed(unlocked)

var currency := {}
var currency_by_key := {}

var unlocked_currencies := []
var total_weight := 0
var wallet_unlocked := false:
	set(val):
		if wallet_unlocked != val:
			wallet_unlocked = val
			emit_signal("wallet_unlocked_changed", val)



func _ready():
	for cur in Currency.Type.values():
		currency[cur] = Currency.new(cur)
		currency_by_key[currency[cur].key] = currency[cur]
	for cur in currency.keys():
		gv.add_currency_to_stage(get_currency_stage(cur), cur)



func close() -> void:
	unlocked_currencies.clear()
	total_weight = 0



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
	get_currency(cur).add_current_loss_rate(amount)


func subtract_current_loss_rate(cur: int, amount) -> void:
	get_currency(cur).subtract_current_loss_rate(amount)


func add_total_loss_rate(cur: int, amount) -> void:
	get_currency(cur).add_total_loss_rate(amount)


func subtract_total_loss_rate(cur: int, amount) -> void:
	get_currency(cur).subtract_total_loss_rate(amount)




# - Get

func get_count(cur: int) -> Big:
	return currency[cur].count


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
