extends MarginContainer


onready var bg = get_node("v/m/bg")
onready var actions = get_node("v/actions")
onready var mainMenu = get_node("/root/Main Menu")
onready var text_edit = get_node("v/actions/m/v/TextEdit")
onready var gn_file_name = get_node("v/m/m/v/name/v/text")

var main_save := false
var most_recent := false

var last_clock: int

var file_name: String

var clock: int


func _ready() -> void:
	get_node("v/m/select").show()
	actions.hide()
	text_edit.hide()
	setMainSave(false)
	#setMainSave(true)

func setup(_file_name: String):
	
	file_name = _file_name
	
	yield(self, "ready")
	
	gn_file_name.text = file_name
	
	
	var file = File.new()
	file.open("user://" + file_name, File.READ)
	
	var raw_data = Marshalls.base64_to_variant(file.get_line())
	
	file.close()
	
	var data = str2var(raw_data)
	var stats_data = str2var(data["stats"])
	
	var time_played = str2var(stats_data["time_played"])
	clock = str2var(stats_data["cur_clock"])
	var _last_clock = OS.get_datetime_from_unix_time(clock)
	last_clock = OS.get_unix_time_from_datetime(_last_clock)
	var difficulty = str2var(stats_data["difficulty"]) if "difficulty" in stats_data.keys() else diff.Difficulty.NORMAL
	
	var file_data = str2var(data["file"])
	bg.self_modulate = str2var(file_data["save_file_color"]) if "save_file_color" in file_data.keys() else Color(1, 0, 0)
	
	get_node("v/m/m/v/v/time played/text").text = fval.time_accurate(time_played)
	get_node("v/m/m/v/v/date/text").text = str(_last_clock["month"]) + "/" + str(_last_clock["day"]) + "/" + str(_last_clock["year"]) + ", " + "%02d:%02d" % [_last_clock["hour"], _last_clock["minute"]]
	get_node("v/m/m/v/v/difficulty/text").text = diff.Difficulty.keys()[difficulty].capitalize()

func setMainSave(val: bool):
	main_save = val
	if val:
		get_node("v/m/m/v/name/v/main").show()
		get_node("v/m/m/v/name/v/flair").text = "Main Save"
		get_node("v/m/m/v/name/v/flair").show()
		get_node("v/actions/m/v/h/delete").hide()
	else:
		get_node("v/m/m/v/name/v/main").hide()
		get_node("v/m/m/v/name/v/flair").hide()
		get_node("v/actions/m/v/h/delete").show()
		


func showActions():
	actions.show()
	mainMenu._on_color_cancel_pressed()

func hideActions():
	actions.hide()
	hideAndCleanTextEdit()
	mainMenu._on_color_cancel_pressed()
	get_node("v/m/confirm deny").hide()


func _on_select_pressed() -> void:
	if actions.visible:
		hideActions()
		return
	gv.emit_signal("save_block_opened")
	showActions()

func _on_TextEdit_visibility_changed() -> void:
	if text_edit.visible:
		text_edit.text = gn_file_name.text
		text_edit.select_all()

func _on_edit_name_pressed() -> void:
	if text_edit.visible:
		text_edit.hide()
		return
	text_edit.show()
	text_edit.grab_focus()

func _on_TextEdit_text_changed() -> void:
	if "\n" in text_edit.text:
		hideAndCleanTextEdit()
		SaveManager.renameFile(file_name, SaveManager.LOREDifyFilename(text_edit.text))
		file_name = text_edit.text
		if most_recent:
			mainMenu.get_node("sc/h/continue/m/v/v/last played").get_child(1).setFilename(file_name)
		mainMenu.refreshAllSaves()

func _on_edit_color_pressed() -> void:
	gv.emit_signal("edit_save_color", self)

func _on_dupe_pressed() -> void:
	
	SaveManager.duplicateSave(file_name)
	mainMenu.refreshAllSaves()
	mainMenu.setupMostRecentSave()

func hideAndCleanTextEdit():
	text_edit.text = text_edit.text.replace("\n", "")
	text_edit.hide()

func setSaveColor(color: Color):
	bg.self_modulate = color
func getSaveColor() -> Color:
	return bg.self_modulate
func saveColor():
	
	var file = File.new()
	file.open("user://" + file_name, File.READ)
	
	var raw_data = Marshalls.base64_to_variant(file.get_line())
	
	file.close()
	
	var data = str2var(raw_data)
	var file_data = str2var(data["file"])
	
	file_data["save_file_color"] = var2str(bg.self_modulate)
	
	data["file"] = var2str(file_data)
	var updated_save_text = var2str(data)
	
	file = File.new()
	file.open("user://" + file_name, File.WRITE)
	
	file.store_line(Marshalls.variant_to_base64(updated_save_text))
	
	file.close()




func setMostRecent():
	yield(self, "ready")
	most_recent = true
	showActions()
	get_node("v/m/select").hide()
	get_node("v/actions/m/v/h/edit name").hide()
	get_node("v/actions/m/v/h/edit color").hide()
	get_node("v/actions/m/v/h/dupe").hide()
	get_node("v/actions/m/v/h/delete").hide()

func isMostRecent():
	return most_recent


func _on_play_pressed() -> void:
	SaveManager.loadGame(file_name, bg.self_modulate)


func _on_duplicate_pressed() -> void:
	SaveManager.duplicateSave(file_name)
	mainMenu.refreshAllSaves()
	mainMenu.setupMostRecentSave()


func _on_delete_pressed() -> void:
	
	if get_node("v/m/confirm deny").visible:
		var dir = Directory.new()
		dir.remove(SaveManager.getFormattedPath(file_name))
		mainMenu.refreshAllSaves()
		return
	
	get_node("v/m/confirm deny").show()
	
	var t = Timer.new()
	add_child(t)
	t.start(2)
	yield(t, "timeout")
	t.queue_free()
	
	get_node("v/m/confirm deny").hide()

func setFilename(_filename: String):
	file_name = _filename
	gn_file_name.text = file_name


