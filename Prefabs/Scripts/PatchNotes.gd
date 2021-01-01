extends MarginContainer


const src := {
	version = preload("res://Prefabs/Patch/Patch Version.tscn"),
}
var cont := {}



func _ready() -> void:
	
	get_node("v/m2/Button/Label").text = get_confirm_text()



func setup(version: String):
	
	# version is the version in the save file that is being loaded
	
	# this func will populate display[] with strings that display() will work with
	
	get_node("v/m/v/desc").text = get_node("v/m/v/desc").text % version
	
	var display := []
	
	
	if version.count(".") != 2:
		
		# for versions before 2.0.0 where they had jank versioning like 2.0 BETA (3)
		
		for x in gv.PATCH_NOTES:
			display.append(x)
		
		display(display)
		
		return
	
	
	var versions = version.split(".")
	
	for p in gv.PATCH_NOTES:
		
		# makes sure that this loop doesn't take too much time or performance
		if display.size() == 10:
			break
		
		var p_versions = p.split(".")
		
		# example:
		
		# if the version in the save is 2.0.3
		# and the latest version is 2.1.0
		
		# versions[0] == 2
		# versions[1] == 0
		# versions[2] == 3
		
		# p_versions[0] == 2
		# p_versions[1] == 1
		# p_versions[2] == 0
		
		# DO display patch notes for versions:
		# 2.0.4, 2.1.0
		
		# DO NOT display patch notes for versions:
		# 2.0.0, 2.0.1, 2.0.2, 2.0.3
		
		if versions[0] < p_versions[0]:
			display.append(p)
			continue
		
		if versions[1] < p_versions[1]:
			if versions[0] <= p_versions[0]:
				display.append(p)
				continue
		
		if versions[2] < p_versions[2]:
			if versions[1] <= p_versions[1]:
				if versions[0] <= p_versions[0]:
					display.append(p)
	
	if display.size() == 0:
		hide()
		return
	
	display(display)


func display(display: Array):
	
	# displays every patch in the display array
	# every key in display[] is a key in gv.PATCH_NOTES
	
	var i = 0
	for d in display:
		
		cont[d] = src.version.instance()
		cont[d].setup(d)
		get_node("v/sc/v").add_child(cont[d])
		
		if i % 2 == 0:
			cont[d].get_node("bg").hide()
		
		i += 1


func get_confirm_text() -> String:
	
	var roll = int(rand_range(0,10))
	
	match roll:
		0: return "Cool!"
		1: return "Got it."
		2: return "Yep."
		3: return "Whatever!"
		4: return "Okay, then!"
		5: return "Okie dokie."
		6: return "Coolio."
		7: return "That's great."
		8: return "Let me play."
		_: return "Wow, so interesting."


func _on_Button_pressed() -> void:
	
	hide()
