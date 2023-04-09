extends MarginContainer


func _ready() -> void:
	SaveManager.connect("gameSaved", self, "update")
	if gv.PLATFORM == gv.Platform.PC:
		get_node("%browser").hide()


func loop():
	
	var t = Timer.new()
	add_child(t)
	
	while visible:
		update()
		t.start(1)
		yield(t,"timeout")
	
	t.queue_free()

func update():
	get_node("%lastSave").text = "Time since last save: " + str(OS.get_unix_time() - gv.lastSaveClock) + " sec"


func _on_SaveMenu_visibility_changed() -> void:
	if visible:
		loop()


func _on_saveNow_pressed() -> void:
	SaveManager.save()
	update()

func autosaveOptionChanged():
	get_node("%autosaveWheel").visible = gv.option["autosave"]
	get_node("%autosaveLabel").visible = gv.option["autosave"]


func _on_displayHelp_pressed() -> void:
	get_node("%help").visible = not get_node("%help").visible
	get_node("%helpIcon").texture = gv.sprite["view"] if get_node("%help").visible else gv.sprite["viewHide"]
	get_node("%helpIcon/shadow").texture = get_node("%helpIcon").texture


func _on_saveOptions_pressed() -> void:
	hide()
	get_node("/root/Root/%OptionsMenu").show()
	get_node("/root/Root/%OptionsMenu").select_tab(2)
