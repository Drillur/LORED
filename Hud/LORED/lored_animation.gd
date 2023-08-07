class_name LOREDAnimation
extends AnimatedSprite2D



var lored: LORED
var default_frames: SpriteFrames
var animation_key := ""
var previous_animation := ""



func setup(_lored: LORED) -> void:
	lored = _lored
	default_frames = lored.default_frames
	if lored.key in ["IRON_ORE", "COPPER_ORE", "IRON", "JOULES", "LIQUID_IRON", "HARDWOOD"]:
		flip_h = true
	animation_key = lored.key
	
	sleep()


func resize() -> void:
	if animation_key in lv.SMALLER_ANIMATIONS:
		scale = Vector2(2, 2)
	else:
		scale = Vector2(0.5, 0.5)



func play_job_animation(job: Job) -> void:
	animation_key = job.get_animation_key()
	sprite_frames = job.animation
	resize()
	previous_animation = animation_key
	
	var animation_length = lv.ANIMATION_FRAMES[animation_key]
	speed_scale = min(25, animation_length / job.duration.get_as_float())
	play(animation_key)


func sleep() -> void:
	sprite_frames = default_frames
	resize()
	speed_scale = 1
	play("ww")
