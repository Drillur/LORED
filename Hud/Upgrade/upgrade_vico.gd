class_name UpgradeVico
extends MarginContainer



@onready var bg = %bg
@onready var button = $Button as IconButton
@onready var check = %CheckBox
@onready var center = %Center
@onready var lock = %Lock

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
	upgrade.vico = self
	button.set_icon(upgrade.icon)
	button.remove_check()
	button.set_button_color(upgrade.color)
	bg.self_modulate = upgrade.color
	check.self_modulate = upgrade.color
	lock.modulate = upgrade.color
	
	button.button.connect("mouse_entered", show_tooltip)
	button.button.connect("mouse_exited", gv.clear_tooltip)
	button.connect("pressed", purchase)
	
	upgrade.connect("purchased_changed", purchased_changed)
	upgrade.connect("unlocked_changed", unlocked_changed)
	purchased_changed(upgrade)
	unlocked_changed()



# - Signals


func show_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.UPGRADE, tooltip_parent, {"upgrade": upgrade})


func cost_update(affordable: bool) -> void:
	check.visible = affordable
	if affordable:
		gv.flash(check, Color(0, 1, 0))


func purchased_changed(_upgrade: Upgrade) -> void:
	bg.visible = upgrade.purchased
	if upgrade.purchased:
		button.button.mouse_default_cursor_shape = Control.CURSOR_ARROW
		button.set_theme_invis()
		check.hide()
	else:
		button.button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.set_theme_standard()


func unlocked_changed() -> void:
	if upgrade.unlocked:
		upgrade.cost.connect("affordable_changed", cost_update)
		cost_update(upgrade.cost.affordable)
		button.modulate.a = 1
		lock.hide()
		button.icon.show()
	else:
		if upgrade.cost.is_connected("affordable_changed", cost_update):
			upgrade.cost.disconnect("affordable_changed", cost_update)
		button.modulate.a = 0.5
		lock.show()
		button.icon.hide()
		check.hide()



# - Actions

func purchase() -> void:
	if not upgrade.purchased:
		if upgrade.unlocked and (upgrade.cost.affordable or gv.dev_mode):
			upgrade.purchase()
			upgrade.cost.throw_texts(center)
		elif upgrade.unlocked:
			gv.get_tooltip().get_price_node().flash()
		else:
			up.get_vico(upgrade.required_upgrade).flash()


func show_check() -> void:
	check.show()


func hide_check() -> void:
	check.hide()


func flash() -> void:
	gv.flash(self, upgrade.color)
