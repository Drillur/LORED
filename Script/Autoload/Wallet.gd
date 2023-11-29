extends Node



var saved_vars := [
	"wallet_unlocked",
	"currency_by_key",
	"keep_wallet_sorted",
]


signal currency_just_unlocked(cur, unlocked)

var currency := {}
var currency_by_key := {}

var unlocked_currencies := []
var wish_eligible_currencies := []
var total_weight := 0

var wallet_unlocked := LoudBool.new(false)
var keep_wallet_sorted := LoudBool.new(false)

var wallet: WalletVico



func _ready():
	for cur in Currency.Type.values():
		currency[cur] = Currency.new(cur)
		currency_by_key[currency[cur].key] = currency[cur]
	for flower in Flowers.Type.values():
		currency[flower] = Currency.new(flower)
		currency_by_key[currency[flower].key] = currency[flower]
	for cur in currency.keys():
		gv.add_currency_to_stage(get_currency_stage(cur), cur)
	
	print("Currencies without icons: ", curs_without_icons)
	wi.wish_completed.connect(wallet_lock)
	wi.wish_uncompleted.connect(wallet_lock)


func close() -> void:
	wallet_unlocked.set_to(false)
	unlocked_currencies.clear()
	total_weight = 0
	wallet.hide_tabs()



# - Signal

func wallet_lock(wish: int) -> void:
	if wish == Wish.Type.JOBS:
		wallet_unlocked.invert()



# - Action

func add(cur: int, amount) -> void:
	currency[cur].add(amount)


func subtract(cur: int, amount) -> void:
	currency[cur].subtract(amount)


func add_pending(cur: int, amount: Big) -> void:
	currency[cur].add_pending(amount)


func subtract_pending(cur: int, amount) -> void:
	currency[cur].subtract_pending(amount)


func append_producer(cur: int, lored: int) -> void:
	currency[cur].append_producer(lored)


func append_user(cur: int, lored: int) -> void:
	currency[cur].append_user(lored)


func erase_producer(cur: int, lored: int) -> void:
	currency[cur].erase_producer(lored)


func erase_user(cur: int, lored: int) -> void:
	currency[cur].erase_user(lored)


func add_from_lored(cur: int, amount) -> void:
	currency[cur].add_from_lored(amount)


func add_from_player(cur: Currency.Type, amount) -> void:
	currency[cur].add_from_player(amount)


func subtract_from_lored(cur: int, amount) -> void:
	currency[cur].subtract_from_lored(amount)


func subtract_from_player(cur: int, amount) -> void:
	currency[cur].subtract_from_player(amount)



func unlock_currency(cur: int) -> void:
	if cur in unlocked_currencies:
		return
	var _currency := get_currency(cur)
	_currency.unlock()
	unlocked_currencies.append(cur)
	total_weight += _currency.weight
	currency_just_unlocked.emit(cur, true)


func set_wish_eligible_currency(cur: int, eligible: bool) -> void:
	if eligible:
		if not cur in wish_eligible_currencies:
			wish_eligible_currencies.append(cur)
	else:
		wish_eligible_currencies.erase(cur)


func unlock_currencies(curs: Array) -> void:
	for cur in curs:
		unlock_currency(cur)



func add_loss_rate(cur: int, amount) -> void:
	get_currency(cur).add_loss_rate(amount)


func subtract_loss_rate(cur: int, amount) -> void:
	get_currency(cur).subtract_loss_rate(amount)


func set_use_allowed(cur: int, allowed: bool) -> void:
	get_currency(cur).use_allowed.set_to(allowed)


func open_wallet_to_currency(cur: int) -> void:
	wallet.open_to_currency(cur)



# - Get

func get_count(cur: int) -> Big:
	return currency[cur].count


func get_count_text(cur: int) -> String:
	return currency[cur].get_count_text()


func get_color(cur: int) -> Color:
	return currency[cur].details.color


func get_icon(cur: int) -> Texture:
	return currency[cur].details.icon


func get_currency_name(cur: int) -> String:
	return currency[cur].details.name


func get_colored_currency_name(cur: int) -> String:
	return currency[cur].details.colored_name


func get_currency(cur: int) -> Currency:
	return currency[cur]


func get_all_currencies() -> Array:
	return currency.values()


func get_currency_weight(cur: int) -> int:
	return get_currency(cur).weight


func get_currency_stage(cur: int) -> int:
	return currency[cur].stage


func get_random_unlocked_currency() -> int:
	return unlocked_currencies[randi() % unlocked_currencies.size()]


func get_random_wish_eligible_currency() -> int:
	return wish_eligible_currencies[randi() % wish_eligible_currencies.size()]


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


func get_icon_and_name_text(cur: Currency.Type) -> String:
	return currency[cur].details.icon_and_name_text


func get_icon_and_colored_name(cur: int) -> String:
	return currency[cur].details.icon_and_colored_name


func is_rate_positive(cur: int) -> bool:
	return get_currency(cur).net_rate.positive.get_value()


func is_rate_negative(cur: int) -> bool:
	return not is_rate_positive(cur)


func is_use_allowed(cur: int) -> bool:
	return get_currency(cur).use_allowed.get_value()


func get_currencies_in_stage(stage: int) -> Array:
	return gv.get_currencies_in_stage(stage)


func currencies_have_positive_net(currencies: Array) -> bool:
	for cur in currencies:
		if is_rate_negative(cur):
			return false
	return true


func currencies_have_negative_net(currencies: Array) -> bool:
	return not currencies_have_positive_net(currencies)


func is_currency_unlocked(cur: int) -> bool:
	return get_currency(cur).unlocked.get_value()


func currencies_in_list_are_unlocked(list: Array) -> bool:
	for cur in list:
		if not is_currency_unlocked(cur):
			return false
	return true


func is_currency_safe_to_spend(cur: int) -> bool:
	return get_currency(cur).safe.get_value()



# - Debug


var curs_without_icons := []
