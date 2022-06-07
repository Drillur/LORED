extends ColorRect


func getSaveColor() -> Color:
	return self_modulate
func setSaveColor(color: Color):
	self_modulate = color


func saveColor():
	SaveManager.save_file_color = self_modulate
