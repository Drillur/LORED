extends MarginContainer

var manager: MarginContainer
var next_wobble := randi() % 2

onready var move_timer = get_node("move")
onready var wobble_timer = get_node("wobble")

func init(_manager: MarginContainer, _color_key: String, _text: String):
	
	manager = _manager
	get_node("m/Label").text = _text
	get_node("bg").self_modulate = gv.COLORS[_color_key]
	
	yield(self, "ready")
	
	rect_size = automaticSize(_text.length())
	rect_pivot_offset = Vector2(rect_size.x / 2, rect_size.y / 2)
	
	move()
	wobble()

func automaticSize(text_length: int):
	
	var x := text_length * 2.25
	
	return Vector2(x, 1)

func wobble():
	
	var rotation_amount = 2.0
	
	while true:
		
		match next_wobble:
			0:
				rect_rotation = -rotation_amount
				next_wobble = 1
				rotation_amount *= 0.9
			1:
				rect_rotation = rotation_amount
				next_wobble = 0
		
		wobble_timer.start(1.25)
		yield(wobble_timer, "timeout")

func move():
	
	var move_time = 0.25
	
	while true:
		
		move_timer.start(move_time)
		yield(move_timer, "timeout")
		
		rect_position.y -= 1
		move_time *= 1.25


func _on_Button_pressed() -> void:
	die()

func die():
	manager.emoting = false
	queue_free()
