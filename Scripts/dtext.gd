extends MarginContainer

var life := 50
var death := 0
var alpha := 1.25
var alpha_decay := 0.99
var direction :float= (rand_range(0,201) - 100) * 0.005

func _ready():
	
	set_physics_process(false)


func init(data: Dictionary = {}):
	
	get_node("%amount").text = data["text"]
	if data["text"] == "":
		get_node("bg").hide()
	get_node("%amount").self_modulate = data["color"]
	if "resource name" in data.keys():
		get_node("%resource name").show()
		get_node("%resource name").text = data["resource name"]
	if "icon" in data.keys():
		get_node("%icon").texture = data["icon"]
		get_node("%icon/shadow").texture = data["icon"]
	else:
		get_node("%icon").hide()
	
	var dkeys = data.keys()
	
	if "direction" in dkeys:
		direction = data["direction"] * 0.005
	
	if "life" in dkeys:
		life = data["life"] * rand_range(0.9, 1.1)
	
	if "texture modulate" in dkeys:
		get_node("%icon").modulate = data["texture modulate"]
	
	if "position" in dkeys:
		rect_position = data["position"]


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
