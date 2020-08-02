extends Label

var life := 50
var death := 0
var alpha := 1.25
var alpha_decay := 0.99
var direction :float= rand_range(0,201)

var go_behind : bool = true



func init(gobehind := true, set_unique_death := 0, _text := "", icon = gv.sprite["unknown"], color := Color(1,1,1)):
	
	text = _text
	$icon.texture = icon
	self_modulate = color
	
	go_behind = gobehind
	death = set_unique_death


func _ready():
	direction = (direction - 100) * 0.005


func _physics_process(_delta):
	
	rect_position.y -= 0.013 * life
	rect_position.x += direction
	
	# color
	if true:
		alpha *= alpha_decay
		if alpha < 0.02:
			visible = false
		modulate = Color(1,1,1,alpha)
	
	if go_behind and 0.013 * life <= 0 and not show_behind_parent:
		show_behind_parent = true
	
	life -= 1
	
	if (death - death) + (life - death) < 20:
		alpha_decay = 0.9
	
	if life > death:
		return
	
	queue_free()
	set_physics_process(false)
