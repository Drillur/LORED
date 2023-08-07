extends MarginContainer



@onready var bg = %bg
@onready var button = $Button as IconButton
@onready var check = %CheckBox
@onready var center = %Center

var tooltip_parent: Control

var upgrade: Upgrade
var container: UpgradeContainer



func _ready() -> void:
	button.set_icon_min_size(Vector2(24, 24))
	pass



func setup(_upgrade: Upgrade):
	upgrade = _upgrade
	if not is_node_ready():
		await ready
	button.set_icon(upgrade.icon)
	button.remove_check()
	button.set_button_color(upgrade.color)
	bg.self_modulate = upgrade.color
	check.self_modulate = upgrade.color
	
	button.button.connect("mouse_entered", show_tooltip)
	button.button.connect("mouse_exited", clear_tooltip)
	button.connect("clicked", purchase)
	
	upgrade.connect("purchased_changed", purchased_changed)
	purchased_changed()
	upgrade.cost.add_cost_vico(self)



# - Signals


func clear_tooltip() -> void:
	gv.clear_tooltip()


func show_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.UPGRADE, tooltip_parent, {"upgrade": upgrade})


func cost_update(affordable: bool) -> void:
	check.visible = affordable
	if affordable:
		gv.flash(check, Color(0, 1, 0))


func purchased_changed() -> void:
	bg.visible = upgrade.purchased
	if upgrade.purchased:
		button.button.mouse_default_cursor_shape = Control.CURSOR_ARROW
		button.set_theme_invis()
	else:
		button.button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.set_theme_standard()


# - Actions

func purchase() -> void:
	if not upgrade.purchased:
		if upgrade.cost.affordable or gv.dev_mode:
			upgrade.purchase()
			upgrade.cost.throw_texts(center)
		else:
			gv.get_tooltip().get_price_node().flash()


func show_check() -> void:
	check.show()


func hide_check() -> void:
	check.hide()
