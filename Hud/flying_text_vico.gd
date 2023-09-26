@icon("res://Sprites/Currency/liq.png")
class_name FlyingTextVico
extends RigidBody2D



@onready var label = %Label
@onready var collision = %CollisionShape2D
@onready var margin_container = $MarginContainer
@onready var background = %Background
@onready var timer = %Timer

var velocity := Vector2(
	randf_range(-0.1, 0.1),
	randf_range(-0.13, -0.18)
)
var crit: bool
var gravity := 0.25
var use_move_slide := true



func _ready():
	set_process(false)
	label.finished.connect(fix_body)
	timer.timeout.connect(queue_free)
	if get_parent() == gv.texts_parent:
		use_move_slide = false


func _process(delta):
	if use_move_slide:
		velocity.x *= (1 - (0.1 * delta))
		velocity.y += gravity * delta
		var collision = move_and_collide(velocity)
		if collision:
			velocity = velocity.bounce(collision.get_normal())
	
	if not timer.is_stopped():
		if timer.time_left <= 0.15:
			if collision_layer == 2:
				collision_layer = 0
				collision_mask = 0
			margin_container.modulate = Color(1, 1, 1, margin_container.modulate.a * 0.95)



func fix_body() -> void:
	collision.shape.height = margin_container.size.x - 10



func setup(layer: int, mask: int) -> void:
	if layer > 0:
		set_collision_layer_value(layer, true)
	if mask > 0:
		set_collision_mask_value(layer, true)


func setup_currency(data: Dictionary) -> void:
	crit = data.crit
	var currency = wa.get_currency(data.cur) as Currency
	background.modulate = currency.details.color
	var _text = "[i]" + data.text + "[/i]"
	var text = currency.details.color_text % _text
	var img_text = currency.details.icon_text + " "
	
	if crit:
		text = "[font_size=14]" + text
	
	label.text = img_text + text



func go(
	_duration: float,
	velocity_range: Array
) -> void:
	show()
	if _duration > 0:
		timer.start(_duration)
	if use_move_slide:
		velocity = Vector2(velocity_range[0], velocity_range[1])
	else:
		var dir = Vector2(
			randf_range(-25, 25), 
			randf_range(-85,-75)
		)
		apply_impulse(dir)
	
	if timer.is_stopped() and not use_move_slide:
		set_process(false)
	
	animate() if not crit else animate_crit()
	set_process(true)


func animate() -> void:
	pass


func animate_crit() -> void:
	pass


