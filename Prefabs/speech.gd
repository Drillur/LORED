extends Sprite

onready var rt = @"/Root"

var life = 100
var sideways_motion : float
var alpha := 1.0
var my_color : Color
var rotated_left := true

func init(sprite : Texture, color : Color) -> void:

	randomize()

	texture = sprite
	modulate = color
	my_color = color
	var roll = rand_range(0,41)
	roll -= 20
	sideways_motion = roll * 0.01
	rotation_degrees = -2

func _physics_process(_delta):

	life -= 1

	position.y -= life * 0.01
	position.x += sideways_motion

	if life % 12 == 0:
		if rotated_left:
			rotated_left = false
			rotation_degrees = 2
		else:
			rotated_left = true
			rotation_degrees = -2

	if life >= 10: return

	if life < 10: alpha *= 0.9

	modulate = Color(my_color.r, my_color.g, my_color.b, alpha)

	if life > 0: return

	queue_free()
