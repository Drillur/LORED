extends Node



var saved_vars := [
	"completed_emotes",
	"random_emotes_allowed",
]

var emote_vico := preload("res://Hud/Emote/emote_vico.tscn")

var emote_cooldown_timer: Timer
var emotes := []

var completed_emotes := []
var random_emotes_allowed := false:
	set(val):
		if random_emotes_allowed != val:
			random_emotes_allowed = val
			if val:
				new_random_emote()
			else:
				if emote_cooldown_timer.is_connected("timeout", new_random_emote):
					emote_cooldown_timer.disconnect("timeout", new_random_emote)



func _ready():
	wi.connect("wish_completed", unlock_random_emotes)


func open():
	emote_cooldown_timer = Timer.new()
	emote_cooldown_timer.one_shot = true
	add_child(emote_cooldown_timer)


func close():
	if is_instance_valid(emote_cooldown_timer):
		emote_cooldown_timer.queue_free()
	emotes.clear()



# - Start

func new_game_start() -> void:
	
	start()


func loaded_game_start() -> void:
	
	start()



func start() -> void:
	open()
	start_all_main_emotes()



func start_all_main_emotes() -> void:
	emote_when_ready(Emote.Type.COAL_GREET)
	emote_when_ready(Emote.Type.COAL_WHOA)
	emote_when_ready(Emote.Type.STONE_HAPPY)



# - Signal




# - Actions

func new_random_emote() -> void:
	var lored := lv.get_random_awake_lored()
	var emote_key = "RANDOM_" + lv.get_key(lored)
	var emote_type = Emote.Type.get(emote_key)
	if emote_type:
		emote_now(Emote.new(emote_type))
	else:
		print_debug(lv.get_key(lored), " cannot random emote. emote_key: ", emote_key)


func emote_now(emote: Emote) -> void:
	if emote.is_connected("just_ready", emote_now):
		emote.disconnect("just_ready", emote_now)
	if emote in emotes:
		emotes.erase(emote)
	
	if emote.is_random():
		keep_emote(emote)
		emote.connect("finished", start_emote_cooldown)
	
	var speaker = lv.get_lored(emote.speaker)
	if speaker.emoting:
		speaker.enqueue_emote(emote)
	else:
		speaker.emote_now(emote)
		if emote.has_reply():
			if emote.has_dialogue():
				emote.connect("text_display_finished", reply_now)
			else:
				emote.connect("finished", reply_now)
			keep_emote(emote)


func reply_now(emote: Emote) -> void:
	if emote.is_connected("text_display_finished", reply_now):
		emote.disconnect("text_display_finished", reply_now)
	if emote.is_connected("finished", reply_now):
		emote.disconnect("finished", reply_now)
	emote_now(Emote.new(emote.reply))


func start_emote_cooldown(emote: Emote) -> void:
	emotes.erase(emote)
	if emote_cooldown_timer.is_stopped():
		var cooldown := randi() % 20 + 20
		emote_cooldown_timer.start(cooldown)
		emote_cooldown_timer.connect("timeout", new_random_emote)


func keep_emote(emote: Emote) -> void:
	if not emote in emotes:
		emotes.append(emote)


func unlock_random_emotes(wish_type: int) -> void:
	if wish_type == Wish.Type.COLLECTION:
		random_emotes_allowed = true



func emote_when_ready(type: int) -> void:
	if not type in completed_emotes:
		var emote = Emote.new(type)
		emote.connect("just_ready", emote_now)
		keep_emote(emote)



# - Get

func is_emote_completed(emote_type: int) -> bool:
	return emote_type in completed_emotes
