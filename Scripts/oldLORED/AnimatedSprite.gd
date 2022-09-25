extends AnimatedSprite



var type: int
var key: String
var animationless := false
var long_anim := false
var first_loop: bool

onready var timer = get_node("Timer")


func init(_type: int) -> void:
	
	type = _type
	key = lv.lored[type].shorthandKey
	
	if key in ["irono", "copo", "iron", "jo", "liq"]:
		flip_h = true
	
	if key in gv.anim.keys():
		frames = gv.anim[key]
	
	if key in gv.animationless:
		animationless = true
	
	if key in ["water", "seed"]:
		long_anim = true
		first_loop = true
	
	animation = "ww"
	frame = 0
	playing = false
	

func start(threshold: float, start_time: int):
	
	stop()
	
	if animationless or (not gv.option["animations"]):
		if not animation == "ww":
			animation = "ww"
		return
	
	animation = "ff"
	
	if lv.lored[type].hasteBaseRatio < 0.15 or lv.lored[type].haste < 0.15:
		playing = true
		return
	
	playing = false
	
	threshold *= 1000
	
	if long_anim:
		if first_loop:
			first_loop = false
		else:
			first_loop = true
			start_time -= threshold
	
	var i = get_i(start_time)
	
	while i < threshold:
		
		frame = int(i / threshold * gv.max_frame[key])
		
		timer.start(gv.fps)
		yield(timer, "timeout")
		
		i = get_i(start_time)

func stop():
	timer.stop()

func get_i(start_time: int) -> int:
	if long_anim:
		return (OS.get_ticks_msec() - start_time) / 2
	return OS.get_ticks_msec() - start_time
