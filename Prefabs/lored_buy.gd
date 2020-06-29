extends Label

var life : int = 81
var color := Color(0.764706, 0.733333, 0.603922)
var alpha : float = 1

func _ready():
	
	var pos := rect_position
	var size := rect_size * rect_scale
	
	rect_scale = Vector2(1.5, 1.5)
	
	rect_position.x = (pos.x) + (size.x / 2) - (rect_size.x / 2 * rect_scale.x)
	rect_position.y = (pos.y) + (size.y / 2) - (rect_size.y / 2 * rect_scale.y)

func init(type: String, col: Color) -> void:
	
	color = col
	add_color_override("font_color", color)
	if type == "new": return
	
	text = type

func _physics_process(_delta):
	
	life -= 1
	
	if alpha <= 0.03:
		queue_free()
	
	if life <= 0:
		alpha *= 0.9
		modulate = Color(color.r, color.g, color.b, alpha)
	
	if rect_scale.x <= 1.0: return
	
	var pos := rect_position
	var size := rect_size * rect_scale
	
	rect_scale = Vector2(rect_scale.x * 0.94, rect_scale.y * 0.94)
	
	if rect_scale.x < 1.0:
		rect_scale = Vector2(1.0, 1.0)
	
	rect_position.x = (pos.x) + (size.x / 2) - (rect_size.x / 2 * rect_scale.x)
	rect_position.y = (pos.y) + (size.y / 2) - (rect_size.y / 2 * rect_scale.y)
