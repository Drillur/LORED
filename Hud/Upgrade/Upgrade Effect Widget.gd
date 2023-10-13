class_name UpgradeEffectWidget
extends MarginContainer



@onready var name_label = %Name
@onready var bar = %Bar as Bar
@onready var effect = %Effect
@onready var xp = %xp

@export var upgrade_type: Upgrade.Type

var upgrade: Upgrade



func _ready():
	upgrade = up.get_upgrade(upgrade_type) as Upgrade
	name_label.text = upgrade.details.name
	if upgrade_type != Upgrade.Type.LIMIT_BREAK:
		name_label.modulate = upgrade.details.color
	
	match upgrade_type:
		Upgrade.Type.LIMIT_BREAK:
			up.limit_break.xp.changed.connect(update_lb_xp)
			up.limit_break.level.changed.connect(update_effect_text)
			up.limit_break.level.changed.connect(update_lb_colors)
			update_lb_xp()
			bar.attach_attribute(up.limit_break.xp)
			update_lb_colors()
		_:
			xp.queue_free()
			bar.queue_free()
			upgrade.effect.effect.changed.connect(update_effect_text)
			if upgrade.effect.effect2 != null:
				upgrade.effect.effect2.changed.connect(update_effect_text)
	
	update_effect_text()



func update_effect_text() -> void:
	effect.text = upgrade.get_dynamic_text().split("[center]")[1]


func update_lb_xp() -> void:
	xp.text = gv.color_text(up.limit_break.color, up.limit_break.xp.get_current_text() + "/") + "\t" + gv.color_text(up.limit_break.next_color, up.limit_break.xp.get_total_text())


func update_lb_colors() -> void:
	bar.color = up.limit_break.color
