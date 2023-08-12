extends MarginContainer

var life := 50
var death := 0
var alpha := 1.25
var alpha_decay := 0.99
var direction :float= (randf_range(0,201) - 100) * 0.005

func _ready():
	set_physics_process(false)


func init(data: Dictionary = {}):
	if "text" in data.keys():
		get_node("%amount").text = data["text"]
		get_node("%amount").self_modulate = data["color"]
	
	if get_node("%amount").text == "":
		get_node("bg").hide()
	
	if "resource name" in data.keys():
		get_node("%resource name").show()
		get_node("%resource name").text = data["resource name"]
	else:
		get_node("%resource name").queue_free()
	if "icon" in data.keys():
		%Icon.show()
		get_node("%Icon").texture = data["icon"]
		get_node("%Icon Shadow").texture = data["icon"]
		if "icon modulate" in data.keys():
			%Icon.modulate = data["icon modulate"]
	else:
		get_node("%Icon").queue_free()
	
	var dkeys = data.keys()
	
	if "direction" in dkeys:
		direction = data["direction"] * 0.005
	
	if "life" in dkeys:
		life = data["life"] * randf_range(0.9, 1.1)
	
	if "texture modulate" in dkeys:
		get_node("%icon").modulate = data["texture modulate"]
	
	if "position" in dkeys:
		position = data["position"]


func _on_Timer_timeout() -> void:
	
	position.y -= 0.013 * (life / 1)
	position.x += direction
	
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
