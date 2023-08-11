class_name EmoteVico
extends MarginContainer



@onready var bg = $bg
@onready var flocket = $Flocket
@onready var pose = %Pose
@onready var pose_shadow = %"Pose Shadow"
@onready var dialogue_container = %"Dialogue Container"
@onready var dialogue_text = %"Dialogue Text"
@onready var timer = $Timer
@onready var pose_only_bg = %"pose only bg"
@onready var display_text_timer = $display_text_timer

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
	dialogue_text.custom_minimum_size.x = min(180, max(40 + text_length * 2.1, custom_minimum_size.x))
	custom_minimum_size.y = snapped(max(32, min(48, text_length * 2)), 15) + 20
	
	start()



func start() -> void:
	if not emote.has_dialogue():
		display_text_timer.queue_free()
	else:
		display_text()
		await emote.just_fully_displayed
	timer.start(emote.duration)
	await timer.timeout
	emote.emit_signal("finished_emoting")
	queue_free()



func display_text() -> void:
	if not emote.has_dialogue():
		return
	
	dialogue_text.visible_characters = 0
	
	while not is_queued_for_deletion():
		dialogue_text.visible_characters += 1
		if dialogue_text.visible_ratio == 1:
			display_text_timer.start(1.5)
			await display_text_timer.timeout
			break
		
		if dialogue_text.text[dialogue_text.visible_characters - 1] in ["!", ",", ".", "?"]:
			display_text_timer.start(0.25)
		else:
			display_text_timer.start(0.04)
		
		await display_text_timer.timeout
	
	display_text_timer.queue_free()
	
	emote.emit_signal("just_fully_displayed")
