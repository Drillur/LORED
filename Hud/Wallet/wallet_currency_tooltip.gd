extends MarginContainer



@onready var bg = $bg
@onready var title = %Title
@onready var title_bg = %"title bg"
@onready var producers_title_bg = %"producers title bg"
@onready var users_title_bg = %"users title bg"
@onready var total_income = %"Total Income"
@onready var producers = %Producers
@onready var producers_container = %"Producers Container"
@onready var users = %Users
@onready var users_container = %"Users Container"
@onready var users_scroll_container = %UsersScrollContainer
@onready var use_allowed = %useAllowed
@onready var scroll_hint = %"scroll hint"
@onready var breaker = %breaker
@onready var description = %description



var currency: Currency

var color: Color:
	set(val):
		color = val
		bg.modulate = val
		title_bg.modulate = val
		producers_title_bg.modulate = val
		users_title_bg.modulate = val
		breaker.modulate = val
		users_scroll_container.get_v_scroll_bar().modulate = val



func setup(data: Dictionary) -> void:
	currency = wa.get_currency(data["currency"]) as Currency
	
	if not is_node_ready():
		await ready
	
	color = currency.details.color
	
	currency.use_allowed.connect_and_call("changed", use_allowed_changed)
	
	title.text = currency.details.name
	if currency.details.description == "":
		description.hide()
	else:
		description.text = currency.details.description
		description.show()
	total_income.text = "Total: [b]" + currency.net_rate.get_text() + "/s"
	
	for lored_type in currency.produced_by:
		var lored := lv.get_lored(lored_type) as LORED
		if lored.unlocked.is_false():
			continue
		var rate = lored.get_produced_currency_rate(currency.type)
		var label = bag.get_resource("rich_text_label").instantiate() as RichTextLabel
		label.text = lored.details.icon_and_name_text + "    [b]" + rate.text + "/s"
		producers_container.add_child(label)
	producers.visible = producers_container.get_child_count() != 0
	
	for lored_type in currency.used_by:
		var lored := lv.get_lored(lored_type) as LORED
		if lored.unlocked.is_false():
			continue
		var rate = lored.get_used_currency_rate(currency.type)
		var label = bag.get_resource("rich_text_label").instantiate() as RichTextLabel
		label.name = lored.details.name
		label.text = lored.details.icon_and_name_text + "    [b]-" + rate.text + "/s"
		label.temp = rate
		users_container.add_child(label)
	users_scroll_container.custom_minimum_size.y = (
		min(5, users_container.get_child_count()) * 15 + (
		(min(4, users_container.get_child_count() - 1)) * 8)
	)
	users.visible = users_container.get_child_count() != 0
	if users.visible and users_container.get_child_count() > 1:
		sort_users()
	
	scroll_hint.visible = users_container.get_child_count() >= 5
	breaker.visible = scroll_hint.visible



func use_allowed_changed() -> void:
	use_allowed.visible = currency.use_allowed.get_value()


func sort_users() -> void:
	var container = users_container
	var sorted_nodes: Array = container.get_children()
	sorted_nodes.sort_custom(
		func sort(a: Node, b: Node):
			if a.temp.equal(b.temp):
				return a.name.naturalnocasecmp_to(b.name) < 0
			return a.temp.greater(b.temp)
	)
	for node in container.get_children():
		container.remove_child(node)
	for node in sorted_nodes:
		container.add_child(node)



func scroll(direction: int) -> void:
	users_scroll_container.scroll_vertical += 30 * direction
