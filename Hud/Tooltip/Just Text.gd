extends MarginContainer



@onready var label = $RichTextLabel

var color: Color:
	set(val):
		color = val
		#title_bg.modulate = val



func setup(data: Dictionary) -> void:
	color = data["color"]
	if not is_node_ready():
		await ready
	label.text = data["text"]
	var text_length = label.text.length()
	label.custom_minimum_size.x = min(180, max(50 + text_length * 2, custom_minimum_size.x))
	#label.custom_minimum_size.y = snapped(max(32, min(48, text_length * 2)), 16) + 20
