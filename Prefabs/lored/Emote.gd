extends MarginContainer

var manager: MarginContainer
var next_wobble := randi() % 2

onready var move = get_node("move")
onready var wobble = get_node("wobble")

func init(_manager: MarginContainer, _color_key: String, _text: String, _size: Vector2):
	
	manager = _manager
	get_node("m/Label").text = _text
	get_node("m/Label").modulate = gv.COLORS[_color_key]
	rect_size = _size
	rect_pivot_offset = Vector2(rect_size.x / 2, rect_size.y / 2)
	
	yield(self, "ready")
	
	move()
	wobble()

func wobble():
	
	var rotation_amount = 2.5
	
	while true:
		
		match next_wobble:
			0:
				rect_rotation = -rotation_amount
				next_wobble = 1
				rotation_amount *= 0.9
			1:
				rect_rotation = rotation_amount
				next_wobble = 0
		
		wobble.start(1.25)
		yield(wobble, "timeout")

func move():
	
	var move_time = 0.25
	
	while true:
		
		move.start(move_time)
		yield(move, "timeout")
		
		rect_position.y -= 1
		move_time *= 1.25


func _on_Button_pressed() -> void:
	die()

func die():
	manager.emoting = false
	queue_free()
