extends MarginContainer



signal showed_or_removed
func _on_visibility_changed():
	if visible:
		emit_signal("showed_or_removed")
func _on_tree_exited():
	emit_signal("showed_or_removed")


@onready var title = %Title
@onready var title_bg = %"title bg"
@onready var description = %Description

var lored: LORED

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val




func setup(data: Dictionary) -> void:
	lored = lv.get_lored(data["lored"])
	await ready
	color = lored.color
	lored.connect("woke_up", sleep)
	if lored.asleep:
		wake_up()
	else:
		sleep()
	var text_length = description.text.length()
	description.custom_minimum_size.x = min(250, 50 + (text_length * 2))
	#print(description.custom_minimum_size.x)


func wake_up() -> void:
	var pool := [
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
	title.text = "Wake"
	description.text = pool[randi() % len(pool)]


func sleep() -> void:
	var pool := [
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
	title.text = "Sleep"
	description.text = pool[randi() % len(pool)]
