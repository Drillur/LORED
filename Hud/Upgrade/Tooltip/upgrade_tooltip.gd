extends MarginContainer



var color: Color:
	set(val):
		color = val
		title_bg.modulate = val

@onready var title_bg = %"title bg"
@onready var title = %Title
@onready var effect = %effect
@onready var recipients = %recipients
@onready var description = %description
@onready var price = %Price as PriceVico
@onready var unlocked = %Unlocked

@onready var locked = %Locked
@onready var required_upgrade = %required_upgrade
@onready var required_upgrade_title_bg = %"required upgrade title bg"
@onready var random_upgrade_description = %random_upgrade_description

var upgrade: Upgrade



func setup(data: Dictionary) -> void:
	upgrade = data["upgrade"]
	if not is_node_ready():
		await ready
	title.text = upgrade.name
	color = upgrade.color
	
	upgrade.connect("purchased_changed", purchased_changed)
	upgrade.connect("just_locked", upgrade_just_locked)
	upgrade.connect("just_unlocked", upgrade_just_unlocked)
	
	if upgrade.unlocked:
		upgrade_just_unlocked()
	else:
		upgrade_just_locked()
	
	price.setup(upgrade.cost)
	price.color = upgrade.color
	purchased_changed(upgrade)
	
	if upgrade.has_required_upgrade:
		required_upgrade.text = "[center][b][i]" + up.get_icon_and_name_text(upgrade.required_upgrade)
		required_upgrade_title_bg.modulate = up.get_color(upgrade.required_upgrade)
	
	if upgrade.has_description:
		effect.hide()
		recipients.hide()
		var text_length = upgrade.description.length()
		description.custom_minimum_size.x = min(250, max(50 + text_length * 2, 100))
		description.text = upgrade.description
		description.show()
	else:
		description.hide()
		recipients.text = upgrade.get_effected_loreds_text()
		if upgrade.effect.effect != null:
			upgrade.effect.effect.connect("changed", update_effect_text) 
		update_effect_text()
		recipients.show()
		effect.show()


func update_effect_text() -> void:
	effect.text = upgrade.get_effect_text()


func purchased_changed(_upgrade: Upgrade) -> void:
	price.visible = not upgrade.purchased


func upgrade_just_unlocked() -> void:
	unlocked.show()
	locked.hide()


func upgrade_just_locked() -> void:
	unlocked.hide()
	locked.show()
	set_random_upgrade_description()


func set_random_upgrade_description() -> void:
	random_upgrade_description.text = up.get_random_upgrade_description()
	var text_length = random_upgrade_description.text.length()
	random_upgrade_description.custom_minimum_size.x = min(280, max(50 + text_length * 2, custom_minimum_size.x))


func get_price_node() -> Node:
	return price
