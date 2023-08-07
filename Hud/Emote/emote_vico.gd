class_name EmoteVico
extends MarginContainer



@onready var bg = $bg
@onready var flocket = $Flocket
@onready var pose = %Pose
@onready var pose_shadow = %"Pose Shadow"
@onready var dialogue_container = %"Dialogue Container"
@onready var dialogue_text = %"Dialogue Text"
@onready var timer = $Timer

var emote: Emote




func setup(_emote: Emote) -> void:
	emote = _emote
	
	if not is_node_ready():
		await ready
	
	bg.modulate = emote.color
	flocket.modulate = emote.color
	
	if emote.posing:
		pose.show()
		pose.modulate = emote.color
		pose.texture = emote.pose_texture
		pose_shadow.texture = pose.texture
	else:
		pose.hide()
	
	if emote.has_dialogue():
		dialogue_text.text = "[center][i]" + emote.dialogue
		dialogue_container.show()
	else:
		dialogue_container.hide()
	
	var text_length = emote.dialogue.length()
	dialogue_text.custom_minimum_size.x = min(180, max(50 + text_length * 2, custom_minimum_size.x))
	custom_minimum_size.y = snapped(max(32, min(48, text_length * 2)), 16) + 20
	
	start()



func start() -> void:
	timer.start(emote.duration)
	await timer.timeout
	emote.emit_signal("finished_emoting")
	queue_free()
