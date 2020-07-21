extends MarginContainer


var key = "coal"

var fps = 0.0


func _physics_process(delta: float) -> void:
	
	if fps > 0:
		fps -= delta
		return
	fps = 0.01
	ref()

func ref():
	
	get_node("v/h/amount").text = gv.g[key].r.toString()
	
	var task_percent = min(gv.g[key].progress.f.percent(gv.g[key].progress.t), 1.0)  * get_node("v/h/task").rect_size.x
	get_node("v/h/task/f").rect_size.x = task_percent
	
	var fuel_percent = min(gv.g[key].f.f.percent(gv.g[key].f.t), 1.0) * get_node("v/h/fuel").rect_size.y
	get_node("v/h/fuel/f").rect_size.y = fuel_percent
	get_node("v/h/fuel/f").rect_position.y = get_node("v/h/fuel").rect_size.y - fuel_percent
	
	
	pass
