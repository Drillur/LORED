extends MarginContainer



@onready var label = %Label



var count: int = 0:
	set(val):
		if count != val:
			if count < val:
				show()
			count = val
			if val == 0:
				hide()
			else:
				text = str(count)

var text: String:
	set(val):
		if text != val:
			text = val
			label.text = text



func _ready():
	label.finished.connect(label_finished)


func label_finished():
	size = Vector2.ZERO
