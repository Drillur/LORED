extends MarginContainer



@onready var title = %Title
@onready var title_bg = %"title bg"
@onready var description = %Description


var wake_pool := [
	"Get back to work!",
	"Wake up! Grab a brush and put a little make-up!",
	"Rise and shine!",
	"Wakey-wakey!",
	"Up and at 'em!!",
	"Carpe freaking diem, dude!",
]
var sleep_pool := [
	"Go to bed.",
	"You can play more Xbox in the morning.",
	"Hit the hay, José!",
	"Time to catch some Z's.",
	"March up those stairs to bed.",
	"Lunch break, buddy.",
	"Please stop.",
	"You're ruining something.",
	"Get outta here.",
]

var lored: LORED

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val




func setup(data: Dictionary) -> void:
	lored = lv.get_lored(data["lored"])
	wake_pool += [
		"Get out of bed, young " + lored.pronoun_man + "!",
		lored.details.name + ", none of this is real. You are in a dream. Wake up.",
		"Wake up, Mr. " + lored.details.name + ". Wake up and smell the ashes.",
	]
	sleep_pool += [
		"Straight to bed, young " + lored.pronoun_man + ".",
	]
	await ready
	
	color = lored.details.color
	lored.asleep.connect_and_call("changed", sleep_changed)
	var text_length = description.text.length()
	description.custom_minimum_size.x = min(250, 50 + (text_length * 2))


func sleep_changed() -> void:
	if lored.asleep.is_false():
		title.text = "Sleep"
		if randi() % 100 < 10:
			description.text = sleep_pool[randi() % sleep_pool.size()]
		else:
			description.text = "Go to sleep."
	else:
		title.text = "Wake"
		if randi() % 100 < 10:
			description.text = wake_pool[randi() % wake_pool.size()]
		else:
			description.text = "Wake up!"
