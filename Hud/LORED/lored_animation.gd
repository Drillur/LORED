class_name LOREDAnimation
extends AnimatedSprite2D



enum DoNotModulateList {
	DRAW_PLATE,
	WIRE,
}



var lored: LORED
var default_frames: SpriteFrames
var animation_key := ""
var previous_animation := ""
#var default_flip_h := false
var capped_anim := LoudBool.new(false)



func setup(_lored: LORED) -> void:
	lored = _lored
	default_frames = lored.default_frames
#	if lored.type in lv.FLIPPED_FRAMES:
#		default_flip_h = true
#		flip_h = default_flip_h
	animation_key = lored.key
	if not lored.key in DoNotModulateList:
		modulate = lored.details.alt_color
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
	speed_scale = animation_length / job.duration.get_as_float()
	if speed_scale > 25:
		capped_anim.set_to(true)
		speed_scale = 8
		if animation != animation_key or not is_playing():
			play(animation_key)
	else:
		capped_anim.set_to(false)
		play(animation_key)


func sleep() -> void:
	animation_key = lored.key
	sprite_frames = default_frames
	resize()
	speed_scale = 1
	play("ww")

