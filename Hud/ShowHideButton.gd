class_name ShowHideButton
extends TextureRect



@export var node: Node



func _ready():
	modulate = Color(1,1,1,0.5)
	$Button.pressed.connect(flip_flop)



func flip_flop() -> void:
	node.visible = not node.visible
	if node.visible:
		texture = gv.icon_view
	else:
		texture = gv.icon_hide
