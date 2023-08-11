class_name UpgradeContainer
extends MarginContainer



@onready var right_down = %RightDown
@onready var tabs = %Tabs
@onready var bg = $bg
@onready var title_bg = %"title bg"
@onready var title = %Title
@onready var count = %Count
@onready var s1n = %S1N

signal upgrade_menu_tab_changed(tab)

var color: Color:
	set(val):
		color = val
		bg.self_modulate = val
		tabs.add_theme_color_override("font_selected_color", color)
		title_bg.modulate = color
		count.modulate = color



func _ready():
	right_down.position.x = size.x + 10
	_on_tab_changed(0)
	
	up.connect("upgrade_purchased", update_count)
	s1n.connect("mouse_entered", show_s1n_avatar_tooltip)
	s1n.connect("mouse_exited", gv.clear_tooltip)


func _on_tab_changed(tab):
	color = up.get_menu_color(tab)
	gv.clear_tooltip()
	set_count_text()
	title.text = up.get_menu_name(tab) + " Upgrades"
	emit_signal("upgrade_menu_tab_changed", tab)


func _on_resized():
	if not is_node_ready():
		await ready
	right_down.position.x = size.x + 10



# - Signal

func update_count(type: int) -> void:
	if up.get_upgrade(type).upgrade_menu == tabs.current_tab:
		set_count_text()




# - Actions

func select_tab(tab: int) -> void:
	tabs.current_tab = tab


func set_count_text() -> void:
	var cur_menu = tabs.current_tab
	var cur_upgrades = up.get_current_upgrade_count_in_menu_text(cur_menu)
	var total_upgrades = up.get_upgrade_total_in_menu_text(cur_menu)
	count.text = "[i][b]" + cur_upgrades + "[/b]/" + total_upgrades



func show_s1n_avatar_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.JUST_TEXT, right_down, {
		"text": [
			"Hee hee! Don't mind me! I'm just hangin around!",
			"I'm one of the oldest pieces of art in the whole freakin game!",
			"I'm a remnant of an era long past. ... [i]the [b]Kongregate era!",
			"This huge arrow is supposed to represent Upgrades!",
			"This isn't as heavy as you might think because I don't really exist so I'm not holding anything!",
		][randi() % 5],
		"color": color,
	})


# - Get

func set_vico(upgrade: Upgrade) -> void:
	if not has_node("%" + upgrade.key):
		return
	get_node("%" + upgrade.key).setup(upgrade)
	get_node("%" + upgrade.key).tooltip_parent = right_down


