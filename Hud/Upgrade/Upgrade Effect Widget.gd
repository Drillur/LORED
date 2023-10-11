class_name UpgradeEffectWidget
extends MarginContainer



@onready var title_bg = %"title bg"
@onready var name_label = %Name
@onready var bar = %Bar
@onready var effect = %Effect

@export var use_bar := false
@export var upgrade_type: Upgrade.Type

var upgrade: Upgrade



func _ready():
	if not use_bar:
		bar.queue_free()
	
	upgrade = up.get_upgrade(upgrade_type) as Upgrade
	title_bg.modulate = upgrade.details.color
	name_label.text = upgrade.details.name
	
	match upgrade_type:
		_:
			upgrade.effect.effect.changed.connect(update_effect_text)
			if upgrade.effect.effect2 != null:
				upgrade.effect.effect2.changed.connect(update_effect_text)
	
	update_effect_text()



func update_effect_text() -> void:
	effect.text = upgrade.effect.get_dynamic_text()
