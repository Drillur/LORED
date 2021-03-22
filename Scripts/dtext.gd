extends Label

var life := 50
var death := 0
var alpha := 1.25
var alpha_decay := 0.99
var direction :float= (rand_range(0,201) - 100) * 0.005

var go_behind := true



func init(gobehind := true, set_unique_death := 0, _text := "", icon = gv.sprite["unknown"], color := Color(1,1,1)):
	
	set_physics_process(false)
	
	text = _text
	if icon == gv.sprite["unknown"]:
		$icon.hide()
	else:
		$icon.texture = icon
	self_modulate = color
	
	go_behind = gobehind
	death = set_unique_death


func _on_Timer_timeout() -> void:
	
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
