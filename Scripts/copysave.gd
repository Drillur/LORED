extends Button

onready var rt = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
var confirm = 0

func _pressed():
	
	match self.name:
		"copy":
			rt.e_save(true)
		"paste":
			rt.e_load(true)
		"delete":
			if confirm == 0:
				confirm = 25
				get_parent().get_node("t").text = "CONFIRM"
			else:
				confirm = 75
				var save_file = File.new()
				if save_file.file_exists(rt.SAVE_LOC):
					var dir = Directory.new()
					dir.remove(rt.SAVE_LOC)
					return
				get_parent().get_node("t").text = "Save deleted! Game reset!"
				rt.reset(0)
				rt.get_node("misc/task").w_complete_reset()
				rt.b_tabkey(KEY_ESCAPE)
				for x in gv.g:
					if x in ["coal", "stone"]:
						continue
					rt.get_node(rt.gnLOREDs).cont[x].hide()

func _on_copy_button_down():
	rt.get_node("map").status = "no"
