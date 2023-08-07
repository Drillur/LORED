class_name UpgradeContainer
extends MarginContainer



@onready var right_down = %RightDown
@onready var tabs = %Tabs
@onready var bg = $bg
@onready var title_bg = %"title bg"
@onready var title = %Title
@onready var count = %Count

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


func _on_tab_changed(tab):
	color = up.get_menu_color(tab)
	gv.clear_tooltip()
	set_count_text()
	title.text = up.get_menu_name(tab) + " Upgrades"


func _on_resized():
	if not is_node_ready():
		await ready
	right_down.position.x = size.x + 10



# - Signal

func update_count(type: int) -> void:
	if up.get_upgrade(type).upgrade_tab == tabs.current_tab:
		set_count_text()




# - Actions

func select_tab(tab: int) -> void:
	show()
	tabs.current_tab = tab


func set_count_text() -> void:
	var cur_tab = tabs.current_tab
	count.text = "[i][b]" + str(up.get_upgrade_count(cur_tab)) + "[/b]/" + str(up.get_upgrade_total(cur_tab))



# - Get

func set_vico(upgrade: Upgrade) -> void:
	if not has_node("%" + upgrade.key):
		return
	get_node("%" + upgrade.key).setup(upgrade)
	get_node("%" + upgrade.key).tooltip_parent = right_down

