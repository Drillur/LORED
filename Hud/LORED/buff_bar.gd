extends MarginContainer



@onready var bar = %Bar
@onready var name_label = %Name
@onready var description = %Description
@onready var texts = %Texts
@onready var duration = %Duration

var buff: Buff



func _ready():
	set_process(false)



func setup(_buff: Buff) -> void:
	buff = _buff
	if not is_node_ready():
		await ready
	name_label.text = "[b]" + buff.details.name
	description.text = "[i]" + buff.details.description
	bar.color = buff.details.color
	bar.modulate = Color(1,1,1, 0.25)
	buff.ticked.connect(flash)
	buff.ticked.connect(throw_texts)
	set_process(true)



func _process(_delta):
	update_bar_and_duration()


func update_bar_and_duration() -> void:
	bar.progress = buff.get_progress()
	duration.text = str(buff.get_time_left()).pad_decimals(1) + "s"


func flash() -> void:
	gv.flash(self, buff.details.color)


func throw_texts() -> void:
	if Engine.get_frames_per_second() >= 60:
		var text = FlyingText.new(
			FlyingText.Type.CURRENCY,
			texts, # node used to determine text locations
			texts, # node that will hold texts
			[1, 1], # collision
		)
		if buff is LOREDBuff:
			match buff.type:
				LOREDBuff.Type.WITCH:
					text.add({
						"cur": buff.object.primary_currency,
						"text": "+" + buff.witch_output.text,
						"crit": false,
					})
		text.go()
