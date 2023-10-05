@icon("res://Sprites/Currency/liq.png")
class_name FlyingTextVico
extends RigidBody2D



@onready var label = %Label
@onready var collision = %CollisionShape2D
@onready var margin_container = $MarginContainer
@onready var background = %Background
@onready var timer = %Timer
@onready var icon = %Icon

var initial_direction := Vector2(
	randf_range(-25, 25), 
	randf_range(-85,-75)
)
var crit: bool



func _ready():
	set_process(false)
	label.finished.connect(fix_body)
	timer.timeout.connect(queue_free)


func _physics_process(_delta):
#	if use_move_slide:
#		velocity.x *= (1 - (0.1 * delta))
#		velocity.y += gravity * delta
#		var collision = move_and_collide(velocity)
#		if collision:
#			velocity = velocity.bounce(collision.get_normal())
	
	if not timer.is_stopped():
		if timer.time_left <= 0.15:
			margin_container.modulate = Color(1, 1, 1, margin_container.modulate.a * 0.95)



func fix_body() -> void:
	collision.shape.height = margin_container.size.x - 6
	label.finished.disconnect(fix_body)



func setup(layer: int, mask: int) -> void:
	if layer > 0:
		set_collision_layer_value(layer, true)
	if mask > 0:
		set_collision_mask_value(layer, true)


func setup_currency(data: Dictionary) -> void:
	crit = data.crit
	var currency = wa.get_currency(data.cur) as Currency
	icon.texture = currency.details.icon
	background.modulate = currency.details.color
	var _text = "[i]" + data.text + "[/i]"
	var text = currency.details.color_text % _text
	#var img_text = currency.details.icon_text + " "
	if crit:
		text = "[font_size=14]" + text
	label.text = text
	


func setup_level_up(data: Dictionary) -> void:
	icon.texture = gv.TEXTURES.Level
	var lored = lv.get_lored(data.lored) as LORED
	icon.modulate = lored.details.color
	background.modulate = lored.details.color
	var _text = "[i]%s[/i]" % lored.get_level_text()
	var text = lored.details.color_text % _text
	text = "[font_size=14]" + text
	label.text = text
	
	initial_direction = Vector2(
		randf_range(-25, 25), 
		randf_range(-45,-55)
	)
	gravity_scale = 0.25


func setup_sleep(data: Dictionary) -> void:
	icon.queue_free()
	label.text = data.text
	label.modulate = data.color



func go(_duration: float, _velocity_range: Array) -> void:
	show()
	if _duration > 0:
		timer.start(_duration)
	apply_impulse(initial_direction)
	
	animate() if not crit else animate_crit()
	set_process(true)


func animate() -> void:
	pass


func animate_crit() -> void:
	pass

