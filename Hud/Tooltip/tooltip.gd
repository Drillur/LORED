extends MarginContainer



@onready var content = $"Tooltip Content"
@onready var bg = $bg

var tooltip_parent: MarginContainer
var parent: Node

var will_adjust_position := false

var type: int



func setup(_type: int) -> void:
	type = _type



func _on_tooltip_content_item_rect_changed():
	if will_adjust_position:
		return
	if not is_node_ready():
		will_adjust_position = true
		await ready
	will_adjust_position = false
	if not is_instance_valid(parent):
		return
	if "Right" in parent.name:
		size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		tooltip_parent.position.x = parent.global_position.x
	elif "Left" in parent.name:
		size_flags_horizontal = Control.SIZE_SHRINK_END
		tooltip_parent.position.x = parent.global_position.x - tooltip_parent.size.x
	if "Up" in parent.name:
		size_flags_vertical = Control.SIZE_SHRINK_END
		tooltip_parent.position.y = parent.global_position.y - tooltip_parent.size.y
		tooltip_parent.position.y = clamp(tooltip_parent.position.y, -get_viewport().size.y, get_viewport().size.y - tooltip_parent.size.y - 10)
	elif "Down" in parent.name:
		size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		tooltip_parent.position.y = parent.global_position.y
		tooltip_parent.position.y = clamp(tooltip_parent.position.y, 10, get_viewport().size.y - size.y - 10)
	else:
		tooltip_parent.position.y = parent.global_position.y
