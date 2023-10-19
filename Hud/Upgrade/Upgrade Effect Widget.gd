class_name UpgradeEffectWidget
extends MarginContainer



@onready var name_label = %Name
@onready var bar = %Bar as Bar
@onready var effect = %Effect
@onready var xp = %xp
@onready var max_xp = %"max xp"
@onready var limit_break = %LimitBreak
@onready var button = $Button

@export var upgrade_type: Upgrade.Type
@export var tooltip_parent: Control

signal pressed

var upgrade: Upgrade



func _ready():
	hide()
	upgrade = up.get_upgrade(upgrade_type) as Upgrade
	name_label.text = upgrade.details.name
	
	upgrade.purchased.became_true.connect(show_self)
	upgrade.purchased.became_false.connect(hide)
	upgrade.effect.is_overwritten.became_true.connect(hide)
	upgrade.effect.is_overwritten.became_false.connect(show_self)
	
	button.modulate = upgrade.details.color
	button.mouse_entered.connect(show_tooltip)
	button.mouse_exited.connect(gv.clear_tooltip)
	
	if upgrade_type != Upgrade.Type.LIMIT_BREAK:
		name_label.modulate = upgrade.details.color
	
	match upgrade_type:
		Upgrade.Type.LIMIT_BREAK:
			up.limit_break.xp.current.changed.connect(update_lb_xp_cur)
			up.limit_break.xp.total.changed.connect(update_lb_xp_max)
			up.limit_break.level.changed.connect(update_effect_text)
			up.limit_break.level.changed.connect(update_lb_colors)
			update_lb_xp_cur()
			update_lb_xp_max()
			bar.attach_attribute(up.limit_break.xp)
			update_lb_colors()
		_:
			limit_break.queue_free()
			upgrade.effect.effect.changed.connect(update_effect_text)
			if upgrade.effect.effect2 != null:
				upgrade.effect.effect2.changed.connect(update_effect_text)
	
	update_effect_text()



func update_effect_text() -> void:
	effect.text = upgrade.get_dynamic_text().split("[center]")[1]


func update_lb_xp_cur() -> void:
	xp.text = up.limit_break.xp.get_current_text()


func update_lb_xp_max() -> void:
	max_xp.text = up.limit_break.xp.get_total_text()


func update_lb_colors() -> void:
	bar.color = up.limit_break.color
	xp.modulate = up.limit_break.color
	max_xp.modulate = up.limit_break.next_color


func show_self() -> void:
	if upgrade.purchased.is_true() and upgrade.effect.is_overwritten.is_false():
		show()



# - Signal


func show_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.UPGRADE_TOOLTIP, tooltip_parent, {"upgrade": upgrade})


func _on_button_pressed():
	pressed.emit()
