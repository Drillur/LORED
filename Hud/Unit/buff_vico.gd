class_name BuffVico
extends MarginContainer



@onready var icon = %Icon
@onready var cooldown = %Cooldown
@onready var cooldown_label = %"Cooldown Label"
@onready var cooldown_progress = %"Cooldown Progress"
@onready var button = %Button

var buff: UnitBuff
var flash_color: Color



func _ready() -> void:
	set_process(false)



func setup(_buff: UnitBuff) -> void:
	buff = _buff
	if not is_node_ready():
		await ready
	buff.active.became_false.connect(queue_free)
	buff.ticked.connect(buff_tick)
	flash_color = Color(
		buff.details.color.r,
		buff.details.color.g,
		buff.details.color.b,
		0.1
	)
	icon.texture = buff.details.icon
	if buff.endless:
		cooldown.queue_free()
	else:
		set_process(true)



# - Signal


func _process(_delta):
	cooldown_progress.value = buff.get_progress() * 100
	cooldown_label.text = buff.get_time_left_text()


func buff_tick() -> void:
	gv.flash(self, flash_color)
