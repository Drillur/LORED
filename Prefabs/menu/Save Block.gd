extends MarginContainer



onready var bg = get_node("v/m/bg")
onready var actions = get_node("v/actions")
onready var mainMenu = get_node("/root/Main Menu")
onready var gnMainSave = get_node("v/m/m/v/h/main save")
onready var saveName = get_node("v/m/m/v/top/h/save name") setget setSaveName, getSaveName
onready var textEdit = get_node("v/actions/textEdit/v/TextEdit")
onready var textEditFolder = get_node("v/actions/textEdit")
onready var actionsFolder = get_node("v/actions/m")
onready var deleteFolder = get_node("v/actions/delete save")

var clock: int

var mostRecent := false setget , getMostRecent
var mainSave: bool setget setMainSave, getMainSave

var color: Color setget setColor, getColor




func _ready() -> void:
	
	get_node("v/m/select").show()
	setMainSave(false)
	
	actions.hide()
	
	gv.connect("hideAllActions", self, "hideActions")
	
	textEditFolder.hide()
	deleteFolder.hide()



func setup(_saveName: String):
	
	yield(self, "ready")
	
	setSaveName(_saveName)
	setupKeySaveData()
func setupKeySaveData():
	
	var data = str2var(SaveManager.deMarshmallowedText(SaveManager.getSaveText(saveName.text)))
	var stats_data = str2var(data["stats"])
	
	var time_played = str2var(stats_data["time_played"])
	clock = str2var(stats_data["cur_clock"])
	var _last_clock = OS.get_datetime_from_unix_time(clock)
	var difficulty = str2var(stats_data["difficulty"]) if "difficulty" in stats_data.keys() else diff.Difficulty.NORMAL
	
	var file_data = str2var(data["file"])
	setColor(str2var(file_data["save_file_color"]) if "save_file_color" in file_data.keys() else Color(1, 0, 0))
	
	get_node("v/m/m/v/h/time played/text").text = fval.time_accurate(time_played)
	get_node("v/m/m/v/top/h/date").text = str(_last_clock["month"]) + "/" + str(_last_clock["day"]) + "/" + str(_last_clock["year"]) + ", " + "%02d:%02d" % [_last_clock["hour"], _last_clock["minute"]]
	get_node("v/m/m/v/h/difficulty/text").text = diff.Difficulty.keys()[difficulty].capitalize()




func setMainSave(val: bool):
	gnMainSave.visible = val

func setSaveName(_saveName: String):
	saveName.text = _saveName

func setColor(_color: Color):
	bg.self_modulate = _color

func setNewSavename():
	hideAndCleanTextEdit()
	SaveManager.renameFile(getSaveName(), SaveManager.LOREDifyFilename(textEdit.text))
	#setSaveName(textEdit.text)
	mainMenu.refreshAllSaves()


func getMainSave() -> bool:
	return gnMainSave.visible

func getSaveName() -> String:
	return saveName.text

func getColor() -> Color:
	return bg.self_modulate

func getMostRecent() -> bool:
	return mostRecent



func _on_select_pressed() -> void:
	if actions.visible:
		gv.emit_signal("hideAllActions")
	else:
		gv.emit_signal("hideAllActions")
		actions.show()

func _on_play_pressed() -> void:
	loadSave()
func _on_rename_pressed() -> void:
	if textEditFolder.visible:
		textEdit.hide()
		return
	textEditFolder.show()
	actionsFolder.hide()
	textEdit.grab_focus()
	textEdit.text = getSaveName()
	textEdit.select_all()
func _on_edit_color_pressed() -> void:
	gv.emit_signal("edit_save_color", self)

func _on_TextEdit_text_changed() -> void:
	if "\n" in textEdit.text:
		setNewSavename()
func _on_accept_new_savename_pressed() -> void:
	setNewSavename()
func _on_savename_edit_cancel_pressed() -> void:
	textEditFolder.hide()
	actionsFolder.show()

func _on_dupe_pressed() -> void:
	
	SaveManager.duplicateSave(getSaveName())
	mainMenu.refreshAllSaves()

func _on_delete_pressed() -> void:
	actionsFolder.hide()
	deleteFolder.show()

func _on_delete_delete_pressed() -> void:
	SaveManager.deleteSave(getSaveName())
	mainMenu.refreshAllSaves()
func _on_cancel_delete_pressed() -> void:
	deleteFolder.hide()
	actionsFolder.show()


func loadSave() -> void:
	SaveManager.loadGame(getSaveName(), getColor())

func saveColor():
	
	var file = File.new()
	file.open("user://" + getSaveName(), File.READ)
	
	var raw_data = Marshalls.base64_to_variant(file.get_line())
	
	file.close()
	
	var data = str2var(raw_data)
	var file_data = str2var(data["file"])
	
	file_data["save_file_color"] = var2str(getColor())
	
	data["file"] = var2str(file_data)
	var updated_save_text = var2str(data)
	
	file = File.new()
	file.open("user://" + getSaveName(), File.WRITE)
	
	file.store_line(Marshalls.variant_to_base64(updated_save_text))
	
	file.close()


func hideActions():
	actions.hide()
	actionsFolder.show()
	deleteFolder.hide()
	textEditFolder.hide()



func hideAndCleanTextEdit():
	textEdit.text = textEdit.text.replace("\n", "")
	textEdit.hide()













