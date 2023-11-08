class_name DialogueVico
extends MarginContainer



@onready var shadow = %Shadow
@onready var text_background = %TextBackground
@onready var speaker_name = %"speaker name"
@onready var pose = %pose
@onready var text = %text
@onready var text_timer = %TextTimer
@onready var replies_container = %Replies
@onready var replies_section = %RepliesSection
@onready var reply_0 = %Reply0
@onready var reply_1 = %Reply1
@onready var reply_2 = %Reply2
@onready var skip_printing_button = %SkipPrinting

var color: Color:
	set(val):
		if color != val:
			color = val
			#shadow.modulate = val
			pose.modulate = val
			text_background.modulate = val
			skip_printing_button.modulate = val

var dialogue: Dialogue
var speaker: LORED.Type
var parsed_text: String
var printing := Bool.new(false)


func _ready():
	text_timer.timeout.connect(text_timer_timeout)
	printing.became_false.connect(text_finished_printing)
	hide()



func setup(_dialogue: Dialogue) -> void:
	if _dialogue.type == Dialogue.Type.END:
		hide()
		return
	dialogue = _dialogue
	
	skip_printing_button.hide()
	
	if dialogue.has_speaker():
		speaker = dialogue.speaker
		speaker_name.text = lv.get_colored_name(speaker)
		color = lv.get_color(speaker)
	
	if dialogue.has_pose():
		pose.texture = dialogue.pose
		pose.show()
	else:
		pose.hide()
	
	text.text = "[i]%s[/i]" % dialogue.text
	
	if dialogue.read.is_false():
		print_text()
	else:
		text.visible_characters = -1
	reset_replies()
	if dialogue.has_valid_replies():
		replies_section.show()
		var i := 0
		for reply in dialogue.replies:
			var reply_d: Dialogue = gv.dialogue[reply]
			if reply_d.is_unlocked():
				var reply_button = get("reply_" + str(i))
				reply_button.name = str(reply)
				reply_button.text = str(i + 1) + ". "
				if printing.is_true():
					reply_button.text += "..."
				else:
					reply_button.text += dialogue.replies[reply]
				reply_button.show()
				i += 1
	else:
		if dialogue.has_chain_parent():
			reply_0.name = str(dialogue.chain_parent)
			if printing.is_true():
				reply_0.text = "1. ..."
			else:
				reply_0.text = "1. (Back)"
			reply_0.show()
		else:
			replies_section.hide()
	
	show()


func _on_visibility_changed():
	if not visible:
		text_timer.stop()
		printing.set_to(false)


func _on_reply_0_pressed():
	if printing.is_false():
		var reply = gv.dialogue[int(str(reply_0.name))]
		setup(reply)


func _on_reply_1_pressed():
	if printing.is_false():
		var reply = gv.dialogue[int(str(reply_1.name))]
		setup(reply)


func _on_reply_2_pressed():
	if printing.is_false():
		var reply = gv.dialogue[int(str(reply_2.name))]
		setup(reply)



func reset_replies() -> void:
	for r in replies_container.get_children():
		r.hide()




func print_text() -> void:
	printing.set_to(true)
	skip_printing_button.show()
	text.visible_characters = 1
	parsed_text = text.get_parsed_text()
	start_text_timer()


func start_text_timer() -> void:
	if parsed_text[text.visible_characters - 1] in gv.PUNCTUATION_MARKS:
		text_timer.start(gv.CHAT_INTERVAL_PUNCTUATION)
	else:
		text_timer.start(gv.CHAT_INTERVAL_STANDARD / 2)


func text_timer_timeout() -> void:
	text.visible_characters += 1
	if text.visible_ratio < 1:
		start_text_timer()
	else:
		printing.set_to(false)


func text_finished_printing() -> void:
	if visible:
		dialogue.read.set_to(true)
		skip_printing_button.hide()
		if dialogue.is_reply_chain_read():
			dialogue.mark_chain_read()
		flash_replies_and_update_text()


func _on_skip_printing_pressed():
	skip_printing()


func skip_printing() -> void:
	text_timer.stop()
	text.visible_ratio = 1
	printing.set_to(false)



func flash_replies_and_update_text() -> void:
	if dialogue.has_valid_replies():
		var i := 0
		for reply in dialogue.replies:
			var reply_d: Dialogue = gv.dialogue[reply]
			if reply_d.is_unlocked():
				var reply_button = get("reply_" + str(i))
				gv.flash(reply_button, color)
				reply_button.text = str(i + 1) + ". " + dialogue.replies[reply]
				i += 1
	else:
		gv.flash(reply_0, color)
		reply_0.text = "1. (Back)"
