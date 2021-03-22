extends AnimatedSprite



var key: String
var animationless := false


func init(_key: String) -> void:
	
	key = _key
	
	if key in gv.anim.keys():
		frames = gv.anim[key]
	
	if key in gv.animationless:
		animationless = true
	
	animation = "ww"
	frame = 0
	playing = false
	

func start(threshold: float, start_time: int):
	
	if animationless or (not gv.menu.option["animations"]):
		if not animation == "ww":
			animation = "ww"
		return
	
	animation = "ff"
	
	if gv.g[key].speed.t / gv.g[key].speed.b < 0.15 or gv.g[key].speed.t < 0.15:
		playing = true
		return
	
	playing = false
	
	threshold *= 1000
	
	var i = get_i(start_time)
	r_update(i, threshold)
	
	while i < threshold:
		
		var t = Timer.new()
		add_child(t)
		t.start(gv.fps)
		yield(t, "timeout")
		t.queue_free()
		
		i = get_i(start_time)
		
		r_update(i, threshold)


func get_i(start_time: int) -> int:
	if key in ["water", "seeds"]:
		return (OS.get_ticks_msec() - start_time) * 2
	return OS.get_ticks_msec() - start_time

func r_update(i, threshold):
	
	frame = int(i / threshold * gv.max_frame[key])
