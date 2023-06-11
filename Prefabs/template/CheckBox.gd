extends Panel



onready var checkmark: Panel = $"%checkmark"

var checked: bool setget set_checked, get_checked
func set_checked(_checked: bool):
	if _checked:
		check()
	else:
		uncheck()
func get_checked() -> bool:
	return checkmark.visible


func check():
	checkmark.show()


func uncheck():
	checkmark.hide()

