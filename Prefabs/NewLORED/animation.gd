extends AnimatedSprite



var type: int
var two_part_animation := false
var part_one_played := false
var key: String
var previous_animation: String



func init(_type: int) -> void:
	
	type = _type
	key = lv.Type.keys()[type]
	
	reset()
	
	if key in ["WATER", "SEEDS"]:
		two_part_animation = true
	
	play("ww")


func reset():
	
	if key in ["IRON_ORE", "COPPER_ORE", "IRON", "JOULES", "LIQUID_IRON", "HARDWOOD"]:
		flip_h = true
	
	if key in gv.anim.keys():
		frames = gv.anim[key]
	
	if type in lv.smallerAnimationList:
		scale = Vector2(2, 2)
	else:
		scale = Vector2(0.5, 0.5)


func play_animation(duration: float, animation: String) -> void:
	
	if animation == previous_animation:
		pass
	
	if not frames == gv.anim[key]:
		frames = gv.anim[key]
	
	if key in gv.animationless:
		#animationless - remove this section when done animating
		return
	
	previous_animation = animation
	
	var animation_length = gv.max_frame[animation]
	speed_scale = min(25, animation_length / duration)
	
	if two_part_animation:
		if part_one_played:
			play(animation + "2")
			part_one_played = false
			return
		else:
			part_one_played = true
	
	play(animation)


func sleep() -> void:
	speed_scale = 1
	play("ww")


func pick_a_refuel_animation(duration: float):
	
	flip_h = false
	scale = Vector2(0.5, 0.5)
	
	frames = gv.anim["refuel"]
	
	var animation = str(int(rand_range(0, 2)))
	var _animation_length = gv.max_frame["refuel" + animation]
	
	speed_scale = _animation_length / duration
	
	previous_animation = "refuel" + animation
	
	play(animation)
	
	yield(self, "animation_finished")
	
	reset()
