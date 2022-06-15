extends ColorRect



func getSaveColor() -> Color:
	return color
func setSaveColor(_color: Color):
	color = _color


func saveColor():
	SaveManager.save_file_color = color
