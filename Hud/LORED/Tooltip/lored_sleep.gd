extends MarginContainer



@onready var title = %Title
@onready var title_bg = %"title bg"
@onready var description = %Description


var wake_pool := []
var sleep_pool := []

var lored: LORED

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val




func setup(data: Dictionary) -> void:
	lored = lv.get_lored(data["lored"])
	wake_pool = [
		"Get back to work!",
		"Wake up! Grab a brush and put a little make-up!",
		"Get out of bed, young " + lored.pronoun_man + "!",
		lored.name + ", none of this is real. You are in a dream. Wake up.",
		"Rise and shine!",
		"Wakey-wakey!",
		"Wake up, Mr. " + lored.name + ". Wake up and smell the ashes.",
		"Up and at 'em!!",
		"Carpe freaking diem, dude!",
	]
	sleep_pool = [
		"Go to bed.",
		"You can play more Xbox in the morning.",
		"Hit the hay, José!",
		"Time to catch some Z's.",
		"March up those stairs to bed.",
		"Lunch break, buddy.",
		"Please stop.",
		"You're ruining something.",
		"Straight to bed, young " + lored.pronoun_man + ".",
		"Get outta here.",
	]
	await ready
	
	color = lored.color
	lored.connect("woke_up", sleep)
	lored.connect("sleep_just_dequeued", sleep)
	lored.connect("sleep_just_enqueued", wake_up)
	if lored.asleep or lored.will_go_to_sleep():
		wake_up()
	else:
		sleep()
	var text_length = description.text.length()
	description.custom_minimum_size.x = min(250, 50 + (text_length * 2))


func wake_up() -> void:
	title.text = "Wake"
	if randi() % 100 < 10:
		description.text = wake_pool[randi() % wake_pool.size()]
	else:
		description.text = "Wake up!"


func sleep() -> void:
	title.text = "Sleep"
	if randi() % 100 < 10:
		description.text = sleep_pool[randi() % sleep_pool.size()]
	else:
		description.text = "Go to sleep."
