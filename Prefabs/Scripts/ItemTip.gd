extends MarginContainer


func init(key):
	
	var text = get_node("v/description")
	var source = get_node("v/source/source")
	
	match key:
		"defiled dead":
			text.text = "Sanctity of life, indeed."
			source.text = "Unholy Body"
		"nearly dead":
			text.text = "The pitiable incapacitated may be of use to those most wicked."
			source.text = "Demons"
		"flesh":
			text.text = "The unholy's favored delicacy."
			source.text = "Demons"
		"corpse":
			text.text = "Avert not your gaze, for surely you are to share its fate."
			source.text = "Demons"
		"flayed corpse":
			text.text = "Avert your gaze."
			source.text = "Necro LORED"
		"meat":
			text.text = "Red."
			source.text = "Hunt LORED"
		"fur":
			text.text = "Soft."
			source.text = "Hunt LORED"
		"beast body":
			text.text = "Be grateful for its bits."
			source.text = "Hunt LORED"
		"exsanguinated beast":
			text.text = "Only one thing left to take."
			source.text = "Necro LORED"
		"wax":
			text.text = "Curls and pools."
			source.text = "Witch LORED"
