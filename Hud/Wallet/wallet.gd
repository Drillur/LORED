class_name WalletVico
extends MarginContainer



@onready var title_bg = %"title bg"
@onready var option_title_bg = %"option title bg"
@onready var bg = $bg
@onready var option_bg = %"option bg"
@onready var hamburger = %Hamburger as IconButton
@onready var hamburger_2 = %Hamburger2 as IconButton
@onready var options = %Options

@onready var stage_1_container = %"Stage 1 Container"
@onready var stage_2_container = %"Stage 2 Container"
@onready var stage_3_container = %"Stage 3 Container"
@onready var stage_4_container = %"Stage 4 Container"
@onready var tabs = %Tabs

@onready var sort_container = %SortContainer
@onready var sort_name = %SortName as SimpleTextIconButton
@onready var sort_count = %SortCount as SimpleTextIconButton
@onready var sort_rate = %SortRate as SimpleTextIconButton

@onready var keep_wallet_sorted = %keep_wallet_sorted

@onready var right_down = $Control/Right

signal color_changed(val)

enum Sort {
	NAME_ASCENDING,
	NAME_DESCENDING,
	COUNT_ASCENDING,
	COUNT_DESCENDING,
	RATE_ASCENDING,
	RATE_DESCENDING,
}

var content := {}
var color: Color:
	set(val):
		if color != val:
			color = val
			title_bg.modulate = color
			option_bg.modulate = color
			bg.modulate = color
			option_title_bg.modulate = color
			color_changed.emit(val)

var sort: int = -1:
	set(val):
		if sort != val:
			sort = val
			disconnect_count()
			disconnect_rate()
			if sort in [Sort.NAME_ASCENDING, Sort.NAME_DESCENDING]:
				sort_all_tabs()
			else:
				sort_tab()
				if wa.keep_wallet_sorted.is_true():
					if sort in [Sort.COUNT_ASCENDING, Sort.COUNT_DESCENDING]:
						connect_count()
					elif sort in [Sort.RATE_ASCENDING, Sort.RATE_DESCENDING]:
						connect_rate()
			adjust_sort_icons()

var opened_to_cur: int

var current_tab_container: VBoxContainer
var timer = Timer.new()




func _ready():
	timer.one_shot = true
	timer.wait_time = 0.5
	add_child(timer)
	timer.timeout.connect(timer_timeout)
	options.hide()
	for stage in range(1, 5):
		add_stage_currencies(stage)
	current_tab_container = stage_1_container
	select_tab(1)
	select_tab(0)
	gv.stage_unlocked.connect(stage_unlocked)
	sort_name.pressed.connect(sort_by_name)
	sort_count.pressed.connect(sort_by_count)
	sort_rate.pressed.connect(sort_by_rate)
	wa.keep_wallet_sorted.changed.connect(check_keep_sorted)
	hamburger.set_icon(bag.get_resource("Menu"))
	hamburger.remove_optionals()
	hamburger.modulate = Color(0, 0, 0)
	hamburger_2.set_icon(bag.get_resource("Menu"))
	hamburger_2.remove_optionals()
	hamburger_2.modulate = Color(0, 0, 0)
	hide_tabs()
	adjust_sort_container_position()
	sort_count.text = "Amount"
	sort_rate.text = "Income"
	sort = Sort.NAME_ASCENDING
	hamburger_2.pressed.connect(options.hide)
	hamburger.pressed.connect(options.show)
	visibility_changed.connect(_on_visibility_changed)
	stage_2_container.get_parent().get_v_scroll_bar().modulate = gv.get_stage_color(Stage.Type.STAGE2)



func _on_tab_changed(tab):
	color = gv.get_stage_color(tab + 1)


func _on_visibility_changed():
	if visible:
		if not sort in [Sort.NAME_ASCENDING, Sort.NAME_DESCENDING]:
			sort_tab()
		if wa.keep_wallet_sorted.is_true():
			if sort in [Sort.COUNT_ASCENDING, Sort.COUNT_DESCENDING]:
				connect_count()
			elif sort in [Sort.RATE_ASCENDING, Sort.RATE_DESCENDING]:
				connect_rate()
	else:
		timer.stop()
		disconnect_count()
		disconnect_rate()
		options.hide()


func _on_keep_wallet_sorted_pressed():
	wa.keep_wallet_sorted.invert()



func _on_fade_gui_input(event):
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		options.hide()



func stage_unlocked(stage: int, unlocked: bool) -> void:
	if stage == 2:
		tabs.tabs_visible = unlocked
		adjust_sort_container_position()
	tabs.set_tab_hidden(stage, not unlocked)


func adjust_sort_container_position() -> void:
	sort_container.position = Vector2(0, -308 if tabs.tabs_visible else -338)


func check_keep_sorted() -> void:
	keep_wallet_sorted.button_pressed = wa.keep_wallet_sorted.get_value()
	if keep_wallet_sorted.button_pressed:
		if sort in [Sort.COUNT_ASCENDING, Sort.COUNT_DESCENDING]:
			connect_count()
		elif sort in [Sort.RATE_ASCENDING, Sort.RATE_DESCENDING]:
			connect_rate()
	else:
		disconnect_count()
		disconnect_rate()



func currency_mouse_entered(cur: int) -> void:
	gv.new_tooltip(gv.Tooltip.WALLET_CURRENCY_TOOLTIP, right_down, {"currency": cur})




# - Actions


func hide_tabs() -> void:
	for i in 4:
		stage_unlocked(i + 1, false)



func add_stage_currencies(stage: int) -> void:
	for cur in wa.get_currencies_in_stage(stage):
		content[cur] = bag.get_resource("wallet_currency").instantiate()
		content[cur].setup(cur)
		get("stage_" + str(stage) + "_container").add_child(content[cur])
		content[cur].mouse_entered_custom.connect(currency_mouse_entered)


func select_tab(tab: int) -> void:
	disconnect_count()
	disconnect_rate()
	tabs.current_tab = tab
	current_tab_container = get("stage_" + str(tab + 1) + "_container")
	if not sort in [Sort.NAME_ASCENDING, Sort.NAME_DESCENDING]:
		sort_tab()
	if wa.keep_wallet_sorted.is_true():
		if sort in [Sort.COUNT_ASCENDING, Sort.COUNT_DESCENDING]:
			connect_count()
		elif sort in [Sort.RATE_ASCENDING, Sort.RATE_DESCENDING]:
			connect_rate()



func sort_by_name() -> void:
	if sort == Sort.NAME_ASCENDING:
		sort = Sort.NAME_DESCENDING
	else:
		sort = Sort.NAME_ASCENDING


func sort_by_count() -> void:
	if sort == Sort.COUNT_ASCENDING:
		sort = Sort.COUNT_DESCENDING
	else:
		sort = Sort.COUNT_ASCENDING


func sort_by_rate() -> void:
	if sort == Sort.RATE_ASCENDING:
		sort = Sort.RATE_DESCENDING
	else:
		sort = Sort.RATE_ASCENDING


func adjust_sort_icons() -> void:
	match sort:
		Sort.NAME_ASCENDING:
			sort_name.icon = bag.get_resource("arrow-up-s-line")
			sort_count.hide_icon()
			sort_rate.hide_icon()
		Sort.NAME_DESCENDING:
			sort_name.icon = bag.get_resource("arrow-down-s-line")
			sort_count.hide_icon()
			sort_rate.hide_icon()
		Sort.COUNT_ASCENDING:
			sort_name.hide_icon()
			sort_count.icon = bag.get_resource("arrow-up-s-line")
			sort_rate.hide_icon()
		Sort.COUNT_DESCENDING:
			sort_name.hide_icon()
			sort_count.icon = bag.get_resource("arrow-down-s-line")
			sort_rate.hide_icon()
		Sort.RATE_ASCENDING:
			sort_name.hide_icon()
			sort_count.hide_icon()
			sort_rate.icon = bag.get_resource("arrow-up-s-line")
		Sort.RATE_DESCENDING:
			sort_name.hide_icon()
			sort_count.hide_icon()
			sort_rate.icon = bag.get_resource("arrow-down-s-line")


func connect_count() -> void:
	if not current_tab_container.get_child(0).currency.count.changed.is_connected(sort_tab):
		for node in current_tab_container.get_children():
			node.currency.count.changed.connect(sort_tab)


func disconnect_count() -> void:
	if current_tab_container.get_child(0).currency.count.changed.is_connected(sort_tab):
		for node in current_tab_container.get_children():
			node.currency.count.changed.disconnect(sort_tab)


func connect_rate() -> void:
	if not current_tab_container.get_child(0).currency.net_rate.changed.is_connected(sort_tab):
		for node in current_tab_container.get_children():
			node.currency.net_rate.changed.connect(sort_tab)


func disconnect_rate() -> void:
	if current_tab_container.get_child(0).currency.net_rate.changed.is_connected(sort_tab):
		for node in current_tab_container.get_children():
			node.currency.net_rate.changed.disconnect(sort_tab)



func sort_all_tabs() -> void:
	for tab in ["1", "2", "3", "4"]:
		sort_tab(tab)


func sort_tab(tab := str(tabs.current_tab + 1)) -> void:
	var container = get("stage_" + tab + "_container")
	var sorted_nodes: Array = container.get_children()
	sorted_nodes.sort_custom(
		func sort(a: Node, b: Node):
			match sort:
				Sort.NAME_ASCENDING:
					return a.name.naturalnocasecmp_to(b.name) < 0
				Sort.NAME_DESCENDING:
					return a.name.naturalnocasecmp_to(b.name) > 0
				Sort.COUNT_ASCENDING, Sort.COUNT_DESCENDING:
					if a.currency.count.equal(b.currency.count):
						return a.name.naturalnocasecmp_to(b.name) < 0
					if sort == Sort.COUNT_ASCENDING:
						return a.currency.count.greater(b.currency.count)
					return a.currency.count.less(b.currency.count)
				Sort.RATE_ASCENDING, Sort.RATE_DESCENDING:
					if (
						a.currency.net_rate.positive.is_false()
						and b.currency.net_rate.positive.is_false()
					):
						if a.currency.net_rate.equal(b.currency.net_rate):
							return a.name.naturalnocasecmp_to(b.name) < 0
						if sort == Sort.RATE_ASCENDING:
							return a.currency.net_rate.less(b.currency.net_rate)
						else:
							return a.currency.net_rate.greater(b.currency.net_rate)
					elif a.currency.net_rate.positive.is_false():
						return sort == Sort.RATE_DESCENDING
					elif b.currency.net_rate.positive.is_false():
						return sort == Sort.RATE_ASCENDING
					else:
						if a.currency.net_rate.equal(b.currency.net_rate):
							return a.name.naturalnocasecmp_to(b.name) < 0
						if sort == Sort.RATE_ASCENDING:
							return a.currency.net_rate.greater(b.currency.net_rate)
						return a.currency.net_rate.less(b.currency.net_rate)
	)
	for node in container.get_children():
		container.remove_child(node)
	for node in sorted_nodes:
		container.add_child(node)


func open_to_currency(cur: int) -> void:
	select_tab(wa.get_currency_stage(cur) - 1)
	opened_to_cur = cur
	timer.start()
	show()


func timer_timeout() -> void:
	gv.flash(content[opened_to_cur], wa.get_color(opened_to_cur))

