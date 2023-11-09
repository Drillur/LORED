class_name DialogueBalloon
extends CanvasLayer


@onready var balloon: MarginContainer = %Balloon
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel as DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

@onready var text_background = %TextBackground
@onready var skip_typing = %SkipTyping
@onready var pose = %pose
@onready var scroll = %scroll
@onready var response_section = %ResponseSection

@onready var content = $MarginContainer

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

var color: Color:
	set(val):
		if color != val:
			color = val
			text_background.modulate = val
			skip_typing.modulate = val
			pose.modulate = val
			for response_button in responses_menu.get_children():
				response_button.color = val

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		
		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			hide()
			return
		
		dialogue_line = next_dialogue_line
		
		character_label.visible = not dialogue_line.character.is_empty()
		
		if dialogue_line.character in LORED.Type.keys() or "]" in dialogue_line.character:
			var character: String
			if "]" in dialogue_line.character:
				character = dialogue_line.character.split("]")[1].split("[")[0]
			else:
				character = dialogue_line.character
			character_label.text = dialogue_line.character.replace(character, lv.get_colored_name(LORED.Type[character]))
			color = lv.get_color(LORED.Type[character])
		else:
			character_label.text = dialogue_line.character
		
		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line
		
		#response_section.hide()
		if dialogue_line.has_responses():
			response_section.show()
			responses_menu.set_responses(dialogue_line.responses, color)
		else:
			response_section.hide()
		
		# Show our balloon
		show()
		will_hide_balloon = false
		
		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing
		
		# Wait for input
		if dialogue_line.has_responses():
			balloon.focus_mode = Control.FOCUS_NONE
			responses_menu.show()
		elif dialogue_line.time != null:
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line


func _ready() -> void:
	hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			hide()
	)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# If the user clicks on the balloon while it's typing then skip typing
	if dialogue_label.is_typing and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		dialogue_label.skip_typing()
		return
	
	if not is_waiting_for_input: return
	if dialogue_line.has_responses(): return
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.next_id)
	elif event.is_action_pressed("ui_accept") and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	if not dialogue_label.is_typing:
		next(response.next_id)


func _on_dialogue_label_finished_typing():
	pass
