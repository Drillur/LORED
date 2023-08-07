extends Node



var currency := {}



func _ready():
	for cur in Currency.Type.values():
		currency[cur] = Currency.new(cur)





# - Action

func add(cur: int, amount) -> void:
	currency[cur].add(amount)


func subtract(cur: int, amount) -> void:
	currency[cur].subtract(amount)


func add_pending(cur: int, amount) -> void:
	currency[cur].add_pending(amount)


func subtract_pending(cur: int, amount) -> void:
	currency[cur].subtract_pending(amount)


func add_producer(cur: int, lored: LORED) -> void:
	currency[cur].add_producer(lored)


func add_from_lored(cur: int, amount) -> void:
	currency[cur].add_from_lored(amount)


func subtract_from_lored(cur: int, amount) -> void:
	currency[cur].subtract_from_lored(amount)


func subtract_from_player(cur: int, amount) -> void:
	currency[cur].subtract_from_player(amount)



# - Get

func get_count(cur: int) -> Big:
	return currency[cur].get_count()


func get_pending(cur: int) -> Big:
	return currency[cur].get_pending()


func get_count_text(cur: int) -> String:
	return currency[cur].get_count_text()


func get_pending_text(cur: int) -> String:
	return currency[cur].get_pending_text()


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


func get_icon_and_name_text(cur: int) -> String:
	return currency[cur].icon_and_name_text



