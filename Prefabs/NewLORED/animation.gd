extends AnimatedSprite



var type: int
var key: String # equivalent to frames
var long_anim := false
var first_loop: bool



func init(_type: int) -> void:
	
	type = _type
	key = lv.lored[_type].shorthandKey
	
	reset()
	
	if key in ["water", "seed"]:
		long_anim = true
		first_loop = true
	
	play("ww")


func reset():
	
	if key in ["irono", "copo", "iron", "jo", "liq", "hard"]:
		flip_h = true
	
	if key in gv.anim.keys():
		frames = gv.anim[key]
	
	if type in lv.smallerAnimationList:
		scale = Vector2(2, 2)
	else:
		scale = Vector2(0.5, 0.5)


func job_started(duration: float, animation: String = "ff") -> void:
	
	if not frames == gv.anim[key]:
		frames = gv.anim[key]
	
	if key in gv.animationless:
		return
	
	var animation_length: int
	if animation == "ff":
		animation_length = gv.max_frame[key]
	else:
		animation_length = gv.max_frame[animation]
	
	if key in ["wire"]:
		modulate = Color(1, 1, 1)
	
	speed_scale = min(25, animation_length / duration)
	play(animation)


func sleep() -> void:
	speed_scale = 1
	play("ww")


func refuel(duration: float):
	
	flip_h = false
	scale = Vector2(0.5, 0.5)
	
	frames = gv.anim["refuel"]
	
	var animation = str(int(rand_range(0,2)))
	var _animation_length = gv.max_frame["refuel" + animation]
	
	if key in ["wire"]:
		modulate = lv.lored[type].color
	
	speed_scale = _animation_length / duration
	
	play(animation)
	
	yield(self, "animation_finished")
	
	reset()
