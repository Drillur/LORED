extends Node



var saved_vars := [
	"completed_emotes",
	"random_emotes_allowed",
]



func load_finished() -> void:
	start_all_main_emotes()
	if random_emotes_allowed:
		print("random emotes allowed")
		emote_cooldown_timer.start(randi() % 5 + 5) # 5-10



var emote_cooldown_timer := Timer.new()
var coal_hum_timer := Timer.new()
var emotes := []

var completed_emotes := []
var random_emotes_allowed := false:
	set(val):
		if random_emotes_allowed != val:
			random_emotes_allowed = val
			emote_cooldown_timer.stop()

var coal_hum := 0



func _ready():
	wi.connect("wish_completed", unlock_random_emotes)
	emote_cooldown_timer.one_shot = true
	add_child(emote_cooldown_timer)
	emote_cooldown_timer.timeout.connect(new_random_emote)
	
	lv.get_lored(LORED.Type.COAL).purchased.became_true.connect(coal_purchased)
	coal_hum_timer.one_shot = true
	add_child(coal_hum_timer)
	coal_hum_timer.timeout.connect(coal_hum_timeout)
	
	SaveManager.load_finished.connect(load_finished)
	gv.hard_reset.connect(reset)



func close():
	emote_cooldown_timer.stop()
	emotes.clear()


func reset() -> void:
	close()
	start()



# - Start


func start() -> void:
	start_all_main_emotes()



func start_all_main_emotes() -> void:
	if not lv.is_lored_purchased(LORED.Type.COAL):
		coal_hum_timer.start(3)
	emote_when_ready(Emote.Type.COAL_GREET)
	emote_when_ready(Emote.Type.COAL_WHOA)
	emote_when_ready(Emote.Type.STONE_HAPPY)



# - Signal


func coal_hum_timeout() -> void:
	emote_now(Emote.new(Emote.Type.COAL_HUM))
	coal_hum_timer.start(10)


func coal_purchased() -> void:
	coal_hum_timer.stop()



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
	
	var speaker = lv.get_lored(emote.speaker)
	if speaker.emoting.is_true():
		speaker.enqueue_emote(emote)
	else:
		speaker.emote_now(emote)
		if emote.is_random():
			keep_emote(emote)
			emote.connect("finished", start_emote_cooldown)
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


func keep_emote(emote: Emote) -> void:
	if not emote in emotes:
		emotes.append(emote)


func unlock_random_emotes(wish_type: int) -> void:
	if wish_type == Wish.Type.COLLECTION:
		random_emotes_allowed = true
		emote_cooldown_timer.start(randi() % 5 + 5) # 5-10



func emote_when_ready(type: int) -> void:
	if not type in completed_emotes:
		var emote = Emote.new(type)
		emote.connect("just_ready", emote_now)
		keep_emote(emote)



func refresh_emote_timer() -> void:
	emote_cooldown_timer.stop()
	var cooldown := randi() % 20 + 20
	emote_cooldown_timer.start(cooldown)



# - Get

func is_emote_completed(emote_type: int) -> bool:
	return emote_type in completed_emotes
