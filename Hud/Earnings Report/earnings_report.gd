extends MarginContainer



@onready var title_bg = %"title bg"
@onready var hamburger = %Hamburger
@onready var pose = %Pose
@onready var dialogue_time_offline = %"dialogue time offline"
@onready var dialogue_negative_fuel = %"dialogue negative fuel"
@onready var dialogue_lost_resources = %"dialogue lost resources"
@onready var loss_parent = %"Loss Parent"
@onready var dialogue_gained_resources = %"dialogue gained resources"
@onready var gain_parent = %"Gain Parent"
@onready var dialogue_closing = %"dialogue closing"

var speaker: LORED



func _ready():
	gv.offline_report_ready.connect(go)



func go() -> void:
	set_speaker()
	time_offline()
	show()



func set_speaker() -> void:
	speaker = lv.get_lored(LORED.Type.CONCRETE)#lv.get_random_unlocked_lored())



func time_offline() -> void:
	var speech = {
		LORED.Type.COAL: "Welcome back! You were offline for %s!",
		LORED.Type.STONE: "Hey!! You were gone for %s!",
		LORED.Type.IRON_ORE: "Ugh, you. You were only gone for %s. If that was multiplied by a zillion, it'd still be too soon.",
		LORED.Type.COPPER_ORE: "Welcome back, there, boss! Long time no see, see? It's been %s!",
		LORED.Type.IRON: "Hey, buddy! You were away for %s!",
		LORED.Type.COPPER: "There you are! I missed you, man! You've been gone for %s!",
		LORED.Type.GROWTH: "I've been in perpetual turmoil for %s. Will it ever end?",
		LORED.Type.JOULES: "You haven't changed your oil in %s?! Are you out of your mind?!",
		LORED.Type.CONCRETE: "Bienvenido, primo! Te been gone por %s.",
		LORED.Type.CONCRETE: "Bienvenido, primo! Te been gone por %s.",
	}
	var date_text = gv.get_time_text_from_dict(gv.time_offline_dict)
	if speaker.type == LORED.Type.CONCRETE:
		date_text = date_text.replace("year", "año").replace("day", "dia").replace("hour", "hora").replace("minute", "minuto").replace("second", "segundo").replace("and", "y")
	
	
