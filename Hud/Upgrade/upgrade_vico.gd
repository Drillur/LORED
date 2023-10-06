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
	
	upgrade.cost.affordable.changed.connect(cost_update)
	upgrade.vico = self
	button.set_icon(upgrade.details.icon)
	button.remove_check()
	button.set_button_color(upgrade.details.color)
	bg.self_modulate = upgrade.details.color
	check.self_modulate = upgrade.details.color
	lock.modulate = upgrade.details.color
	button.autobuyer.modulate = upgrade.details.color
	
	button.mouse_entered.connect(show_tooltip)
	button.mouse_exited.connect(gv.clear_tooltip)
	button.pressed.connect(purchase)
	
	upgrade.purchased.connect_and_call("changed", purchased_changed)
	upgrade.unlocked.connect_and_call("changed", unlocked_changed)
	upgrade.autobuy_changed.connect(autobuyer_display)
	
	check.hide()
	
	cost_update()



# - Signals


func show_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.UPGRADE, tooltip_parent, {"upgrade": upgrade})


func cost_update() -> void:
	var val = upgrade.cost.affordable.get_value()
	if (
		val
		and upgrade.autobuy
		or upgrade.purchased.is_true()
		or upgrade.unlocked.is_false()
	):
		check.hide()
		return
	check.visible = val
	if val:
		gv.flash(check, Color(0, 1, 0))


func purchased_changed() -> void:
	var val = upgrade.purchased.get_value()
	bg.visible = val
	autobuyer_display()
	if val:
		button.button.mouse_default_cursor_shape = Control.CURSOR_ARROW
		button.set_theme_invis()
		check.hide()
	else:
		button.button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.set_theme_standard()


func unlocked_changed() -> void:
	var val = upgrade.unlocked.get_value()
	autobuyer_display()
	if val:
		button.modulate.a = 1
		lock.hide()
		button.texture_rect.show()
	else:
		button.modulate.a = 0.5
		lock.show()
		button.texture_rect.hide()
		check.hide()


func autobuyer_display() -> void:
	button.autobuyer.visible = (
		upgrade.autobuy
		and upgrade.unlocked.is_true()
		and upgrade.purchased.is_false()
	)
	if button.autobuyer.visible:
		button.autobuyer.play()
	else:
		button.autobuyer.stop()



# - Actions

func purchase() -> void:
	if upgrade.purchased.is_false():
		if upgrade.unlocked.is_true() and (upgrade.cost.affordable.is_true() or gv.dev_mode):
			upgrade.purchase()
			upgrade.cost.throw_texts(center)
		elif upgrade.unlocked.is_true():
			gv.get_tooltip().get_price_node().flash()
		else:
			up.get_vico(upgrade.required_upgrade).flash()


func flash() -> void:
	gv.flash(self, upgrade.details.color)




# - DEV

func _on_button_right_mouse_pressed():
	if gv.dev_mode:
		upgrade.refund()
