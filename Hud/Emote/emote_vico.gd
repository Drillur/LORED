class_name EmoteVico
extends MarginContainer



@onready var bg = $bg
@onready var flocket = $Flocket
@onready var pose = %Pose
@onready var pose_shadow = %"Pose Shadow"
@onready var dialogue_text = %"Dialogue Text"
@onready var timer = $Timer
@onready var pose_only_bg = %"pose bg"
@onready var display_text_timer = $display_text_timer

var emote: Emote

var standard_interval := 0.05
var punctuation_interval := 0.25



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
		var text_length = dialogue_text.get_parsed_text().length()
		dialogue_text.custom_minimum_size.x = min(180, 30 + (text_length * 3))
		dialogue_text.show()
		await dialogue_text.finished
		var line_count = dialogue_text.get_line_count()
		dialogue_text.custom_minimum_size.y = min(45, line_count * 15)
		#printt(line_count, dialogue_text.custom_minimum_size, emote.dialogue)
		custom_minimum_size.y = max(52, dialogue_text.custom_minimum_size.y + 20)
	else:
		dialogue_text.hide()
	
	start()



func start() -> void:
	if not emote.has_dialogue():
		display_text_timer.queue_free()
	else:
		display_text()
		await emote.text_display_finished
	timer.start(emote.duration)
	await timer.timeout
	emote.emit_signal("finished_emoting")
	queue_free()



func display_text() -> void:
	if not emote.has_dialogue():
		return
	
	dialogue_text.visible_characters = 0
	var parsed_text: String = dialogue_text.get_parsed_text()
	
	while not is_queued_for_deletion():
		dialogue_text.visible_characters += 1
		if dialogue_text.visible_ratio == 1:
			break
		#if emote.speaker.key == "COPPER_ORE":
		
		if parsed_text[dialogue_text.visible_characters - 1] in ["!", ",", ".", "?"]:
			display_text_timer.start(punctuation_interval)
		else:
			display_text_timer.start(standard_interval)
		
		await display_text_timer.timeout
	
	display_text_timer.queue_free()
	emote.emit_signal("text_display_finished")
