class_name UpgradeContainer
extends MarginContainer



@onready var right_down = %Right
@onready var tabs = %Tabs
@onready var bg = $bg
@onready var title_bg = %"title bg"
@onready var title = %Title
@onready var count = %Count
@onready var s1n = %S1N
@onready var s1m = %S1M

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
	up.menu_unlocked_changed.connect(menu_unlocked_changed)
	
	for i in UpgradeMenu.Type.size():
		menu_unlocked_changed(i, false)
	
	s1n.connect("mouse_entered", show_s1n_avatar_tooltip)
	s1n.connect("mouse_exited", gv.clear_tooltip)
	
	s1m.connect("mouse_entered", show_s1m_avatar_tooltip)
	s1m.connect("mouse_exited", gv.clear_tooltip)


func menu_unlocked_changed(menu: int, unlocked: bool) -> void:
	if menu == UpgradeMenu.Type.MALIGNANT:
		tabs.tabs_visible = unlocked
	tabs.set_tab_hidden(menu, not unlocked)


func _on_tab_changed(tab):
	color = up.get_menu_color(tab)
	gv.clear_tooltip()
	set_count_text()
	if not up.is_upgrade_menu_unlocked(UpgradeMenu.Type.MALIGNANT):
		title.text = "Upgrades"
	else:
		title.text = up.get_menu_name(tab) + " Upgrades"
	emit_signal("upgrade_menu_tab_changed", tab)


func _on_resized():
	if not is_node_ready():
		await ready
	right_down.position = Vector2(size.x + 10, -10)


func _on_visibility_changed():
	if visible:
		gv.clear_tooltip()



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


func show_s1m_avatar_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.JUST_TEXT, right_down, {
		"text": [
			"Malignancy is supposed to look evil. Do I look that evil to you?",
			"Back in the earliest version of LORED, these Malignant upgrades were scattered all around the game screen! You had to drag the screen way off to the right to find them! I put signs directing players where to go. Once you reached the group of Malignant upgrades, it unlocked the hotkey which would take you there immediately. From then on, it was as if you were just opening an upgrade menu like this one you have open right now, except it wasn't in a \"menu\". It's nostalgic to think about, but it wasn't a good idea.",
			"People used to--and still do!--complain about [b]IT'S GROWIN ON ME[/b] favoring either Iron or Copper because it seemed to be the case on the particular run they were on. It is a little known fact that it actually [i]does[/i] favor one or the other! Bwa-haha!\n\nJust kiddin. Here is the code for it: ", #gayfuck,
			"Although my strategies and techniques for animation my have changed (for the better), I will never re-do these older animations. Coal's was the first that was created, followed by Stone's!",
			"At first, and for a good long while, the LOREDs had [b]no progress bar[/b]! I intended for the [i]animations[/i] to [i]replace[/i] them! Overall, it is best to have both.",
		][randi() % 5],
		"color": color,
	})


# - Get

func set_vico(upgrade: Upgrade) -> void:
	if not has_node("%" + upgrade.key):
		return
	get_node("%" + upgrade.key).setup(upgrade)
	get_node("%" + upgrade.key).tooltip_parent = right_down


