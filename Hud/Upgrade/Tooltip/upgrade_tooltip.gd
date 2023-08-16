extends MarginContainer



signal showed_or_removed
func _on_visibility_changed():
	if visible:
		emit_signal("showed_or_removed")
func _on_tree_exited():
	emit_signal("showed_or_removed")

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
	price.setup(upgrade.cost)
	price.color = upgrade.color
	purchased_changed()
	
	if upgrade.has_required_upgrade:
		required_upgrade.text = "[b][i]" + up.get_icon_and_name_text(upgrade.required_upgrade)
		required_upgrade_title_bg.modulate = up.get_color(upgrade.required_upgrade)
	
	show_locked_or_unlocked()
	
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
		upgrade.effect.effect.add_notify_change_method(update_effect_text, true) 
		recipients.show()
		effect.show()


func update_effect_text() -> void:
	effect.text = upgrade.get_effect_text()


func purchased_changed() -> void:
	price.visible = not upgrade.purchased



func show_locked_or_unlocked() -> void:
	while not is_queued_for_deletion():
		if upgrade.unlocked:
			unlocked.show()
			locked.hide()
			await upgrade.just_locked
		else:
			unlocked.hide()
			locked.show()
			set_random_upgrade_description()
			await upgrade.just_unlocked


func set_random_upgrade_description() -> void:
	random_upgrade_description.text = up.get_random_upgrade_description()
	var text_length = random_upgrade_description.text.length()
	random_upgrade_description.custom_minimum_size.x = min(280, max(50 + text_length * 2, custom_minimum_size.x))


func get_price_node() -> Node:
	return price
