extends Label

var life := 50
var death := 0
var alpha := 1.25
var alpha_decay := 0.99
var direction :float= (rand_range(0,201) - 100) * 0.005

func _ready():
	
	set_physics_process(false)


func init(data: Dictionary = {}):
	
	text = data["text"]
	self_modulate = data["color"]
	get_node("icon").texture = data["icon"]
	
	var dkeys = data.keys()
	
	if "direction" in dkeys:
		direction = data["direction"] * 0.005
	
	if "life" in dkeys:
		life = randi() % data["life"] + 50 - (data["life"] / 2)


func _on_Timer_timeout() -> void:
	
	rect_position.y -= 0.013 * life
	rect_position.x += direction
	
	# color
	if true:
		alpha *= alpha_decay
		if alpha < 0.02:
			visible = false
		modulate = Color(1,1,1,alpha)
	
	if 0.013 * life <= 0 and not show_behind_parent:
		show_behind_parent = true
	
	life -= 1
	
	if (death - death) + (life - death) < 20:
		alpha_decay = 0.9
	
	if life > death:
		return
	
	queue_free()
