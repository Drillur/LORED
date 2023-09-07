class_name EmoteVico
extends MarginContainer



@onready var bg = $bg
@onready var bg2 = $bg2
@onready var flocket = $Flocket
@onready var pose = %Pose
@onready var pose_shadow = %"Pose Shadow"
@onready var dialogue_text = %"Dialogue Text"
@onready var timer = $Timer
@onready var pose_only_bg = %"pose bg"
@onready var display_text_timer = $display_text_timer
@onready var dialogue_container = %"Dialogue Container"

var emote: Emote

const standard_interval := 0.035
const punctuation_interval := 0.25
const PUNCTUATION_MARKS := ["!", ",", ".", "?"]



func _ready() -> void:
	timer.connect("timeout", timer_finished)
	var scroll_bar = dialogue_text.get_v_scroll_bar() as VScrollBar
	scroll_bar.theme = gv.theme_standard
	gv.prestige.connect(prestige)
	gv.hard_reset.connect(reset)



func setup(_emote: Emote) -> void:
	emote = _emote
	
	if not is_node_ready():
		await ready
	
	bg.modulate = emote.color
	bg2.modulate = emote.color
	flocket.modulate = emote.color
	dialogue_text.get_v_scroll_bar().modulate = emote.color
	
	if emote.posing:
		pose.show()
		pose.modulate = emote.color
		pose.texture = emote.pose_texture
		pose_shadow.texture = pose.texture
	else:
		pose.hide()
	
	if emote.has_dialogue():
		dialogue_container.show()
		dialogue_text.text = "[i]" + emote.dialogue #[center]
		var text_length = dialogue_text.get_parsed_text().length()
		dialogue_text.custom_minimum_size.x = min(180, 30 + (text_length * 3))
		dialogue_text.show()
		await dialogue_text.finished
		var line_count = dialogue_text.get_line_count()
		dialogue_text.custom_minimum_size.y = min(45, line_count * 15)
		#printt(line_count, dialogue_text.custom_minimum_size, emote.dialogue)
		custom_minimum_size.y = max(52, dialogue_text.custom_minimum_size.y + 20)
	else:
		dialogue_container.hide()
	
	
	if emote.has_dialogue():
		emote.connect("text_display_finished", start_timer)
		display_text()
	else:
		display_text_timer.queue_free()
		start_timer(emote)


func start_timer(_emote: Emote) -> void:
	timer.start(emote.duration)


func timer_finished() -> void:
	if visible:
		hide()
		timer.start(1)
	else:
		emote.finish()
		queue_free()



func display_text() -> void:
	dialogue_text.visible_characters = 0
	var parsed_text: String = dialogue_text.get_parsed_text()
	
	while not is_queued_for_deletion():
		dialogue_text.visible_characters += 1
		if dialogue_text.visible_ratio == 1:
			break
		
		if parsed_text[dialogue_text.visible_characters - 1] in PUNCTUATION_MARKS:
			display_text_timer.start(punctuation_interval)
		else:
			display_text_timer.start(standard_interval)
		
		await display_text_timer.timeout
	
	display_text_timer.queue_free()
	await get_tree().create_timer(1).timeout
	emote.finished_displaying_text()



func prestige(stage: int) -> void:
	if stage >= lv.get_lored(emote.speaker).stage:
		reset()


func reset():
	if emote in em.emotes:
		em.emotes.erase(emote)
	queue_free()
