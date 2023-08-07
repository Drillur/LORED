extends MarginContainer



@onready var rewards_title_bg = %"rewards title bg"
@onready var face = %face
@onready var giver = %giver
@onready var text = %text
@onready var rewards = %Rewards
@onready var reward_details = %RewardDetails

var label := preload("res://Hud/rich_text_label.tscn")

signal showed_or_removed
func _on_visibility_changed():
	if visible:
		emit_signal("showed_or_removed")
func _on_tree_exited():
	emit_signal("showed_or_removed")

var color: Color:
	set(val):
		color = val
		if wish.has_rewards():
			rewards_title_bg.modulate = val

var wish: Wish



func setup(data: Dictionary) -> void:
	wish = data["wish"]
	if not is_node_ready():
		await ready
	
	color = wish.get_color()
	giver.text = wish.giver.colored_name
	face.modulate = wish.giver.color
	
	set_text(wish.help_text)
	setup_reward_text()
	
	set_to_thank_text_when_ready()


func set_to_thank_text_when_ready() -> void:
	if not wish.ready_to_turn_in:
		await wish.became_ready_to_turn_in
	set_text(wish.thank_text)


func setup_reward_text() -> void:
	if not wish.has_rewards():
		rewards.queue_free()
		return
	for _text in wish.get_reward_texts():
		var x = label.instantiate()
		x.text = _text
		reward_details.add_child(x)


func set_text(_text: String) -> void:
	text.text = "[i]" + _text
	text.custom_minimum_size.x = max(_text.length() * 0.75, 95)
