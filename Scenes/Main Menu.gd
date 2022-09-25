extends MarginContainer


onready var color_picker := get_node("color/m")
onready var all_saves_container := get_node("all saves/sc/v/v")
onready var importDialog = get_node("FileDialog")

onready var all_saves := get_node("all saves")
onready var importWindow := get_node("import")
onready var importByStringWindow = get_node("import/byString")
onready var importByStringFailureWindow = get_node("import/byString failure")
onready var importByFileWindow = get_node("import/byFile failure")
onready var exitConfirm = get_node("exitConfirm")
onready var newGameWindow = get_node("new game")

onready var diffDropdown = get_node("new game/m/v/diff/m/v/v/presets/m/v/select")
onready var diffDesc = get_node("new game/m/v/diff/m/v/v/presets/m/v/desc")
onready var diffValues = get_node("new game/m/v/diff/m/v/v/values")
onready var diffCustom = get_node("new game/m/v/diff/m/v/v/custom")

onready var customize_Output_text = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/Output/TextEdit")
onready var customize_Output_slider = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/Output/h/HSlider")
onready var customize_Input_text = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/Input/TextEdit")
onready var customize_Input_slider = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/Input/h/HSlider")
onready var customize_Haste_text = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/Haste/TextEdit")
onready var customize_Haste_slider = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/Haste/h/HSlider")
onready var customize_Crit_text = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/Crit/TextEdit")
onready var customize_Crit_slider = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/Crit/h/HSlider")
onready var customize_FuelStorage_text = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/FuelStorage/TextEdit")
onready var customize_FuelStorage_slider = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/FuelStorage/h/HSlider")
onready var customize_FuelConsumption_text = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/FuelConsumption/TextEdit")
onready var customize_FuelConsumption_slider = get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/FuelConsumption/h/HSlider")


onready var _Output = get_node("new game/m/v/diff/m/v/v/values/m/v/lored/m/v/Output/text")
onready var _Input = get_node("new game/m/v/diff/m/v/v/values/m/v/lored/m/v/Input/text")
onready var _Haste = get_node("new game/m/v/diff/m/v/v/values/m/v/lored/m/v/Haste/text")
onready var _Crit = get_node("new game/m/v/diff/m/v/v/values/m/v/lored/m/v/Crit/text")
onready var _FuelStorage = get_node("new game/m/v/diff/m/v/v/values/m/v/lored/m/v/FuelStorage/text")
onready var _FuelConsumption = get_node("new game/m/v/diff/m/v/v/values/m/v/lored/m/v/FuelConsumption/text")

var no_saves_found := false

var coloring_node = 0

var save_blocks := {}
var mostRecentSave: String

const DEFAULT_VALUES := {
	"Output": 1.0,
	"Input": 1.0,
	"Haste": 1.0,
	"Crit": 0.0,
	"FuelStorage": 1.0,
	"FuelConsumption": 1.0,
}
const MAX_VALUES := {
	"Output": 10.0,
	"Input": 10.0,
	"Haste": 10.0,
	"Crit": 100.0,
	"FuelStorage": 10.0,
	"FuelConsumption": 10.0,
}
const MIN_VALUES := {
	"Output": 0.1,
	"Input": 0.1,
	"Haste": 0.1,
	"Crit": -100.0,
	"FuelStorage": 0.1,
	"FuelConsumption": 0.1,
}
const COLORS := {
	"hardest": Color(1, 0, 0),
	"hard": Color(1, 1, 0),
	"normal": Color(0, 1, 0),
	"easy": Color(0, 0.756863, 1),
}


func _ready():
	
	
	gv.active_scene = gv.Scene.MAIN_MENU
	
	gv.connect("hideAllActions", self, "_on_color_cancel_pressed")
	
	get_tree().get_root().connect("size_changed", self, "windowSizeChanged")
	
	gv.connect("edit_save_color", self, "setColoringNode")
	
	all_saves.hide()
	color_picker.hide()
	all_saves.hide()
	importWindow.hide()
	importByStringWindow.hide()
	get_node("import/byString/m/v/manual save name/h2").hide()
	get_node("new game/m/v/save info").hide()
	importByStringFailureWindow.hide()
	importByFileWindow.hide()
	importDialog.set_access(2)
	importDialog.set_mode(0)
	exitConfirm.hide()
	newGameWindow.hide()
	get_node("h").show()
	
	for difficulty in diff.Difficulty:
		diffDropdown.add_item(difficulty.capitalize())
	
	diffDropdown.select(4)
	_on_difficulty_selected(4)
	
	setupAllSaves()
	
	hideMouseoverFlairs()
	
	windowSizeChanged()
	
	_on_randomize_pressed()
	
	for x in DEFAULT_VALUES:
		resetDiffOption(x)

func hideMouseoverFlairs():
	
	get_node("h/v/continue/flair/Sprite").hide()
	get_node("h/v/new/flair/Sprite").hide()
	get_node("h/v/load/flair/Sprite").hide()
	get_node("all saves/top/h/v/v/back/flair/Sprite").hide()
	get_node("all saves/top/h/v/v/import/flair/Sprite").hide()
	get_node("all saves/top/h/v/v/refresh/flair/Sprite").hide()
	get_node("import/top/h/v/v/back/flair/Sprite").hide()
	get_node("new game/top/h/v/v/back/flair/Sprite").hide()
	get_node("new game/top/h/v/v/begin/flair/Sprite").hide()



func _input(ev: InputEvent) -> void:
	
	if ev.is_action_pressed("ui_cancel"):
		
		if importDialog.visible:
			importDialog.hide()
			return
		
		if importByStringFailureWindow.visible:
			importByStringFailureWindow.hide()
			importByStringWindow.show()
			return
		
		if importByStringWindow.visible:
			importByStringWindow.hide()
			return
		
		if importWindow.visible:
			clearMouseoverEffects()
			importWindow.hide()
			all_saves.show()
			return
		
		if all_saves.visible:
			clearMouseoverEffects()
			all_saves.hide()
			get_node("h").show()
			return
		
		if newGameWindow.visible:
			clearMouseoverEffects()
			_on_newgame_back_pressed()
			return
		
		exitConfirm.visible = not exitConfirm.visible

func clearMouseoverEffects():
	hideMouseoverFlairs()
	get_node("all saves/top/h/v/v/back/m/text").add_font_override("font", gv.font.buttonNormal)
	get_node("all saves/top/h/v/v/refresh/m/text").add_font_override("font", gv.font.buttonNormal)
	get_node("all saves/top/h/v/v/import/m/text").add_font_override("font", gv.font.buttonNormal)
	get_node("import/top/h/v/v/back/m/text").add_font_override("font", gv.font.buttonNormal)
	get_node("import/m/h/byString/v/h/text").add_font_override("font", gv.font.buttonNormal)
	get_node("import/m/h/byFile/v/h/text").add_font_override("font", gv.font.buttonNormal)
	get_node("new game/top/h/v/v/back/m/text").add_font_override("font", gv.font.buttonNormal)
	

func windowSizeChanged() -> void:
	
	var win: Vector2 = get_viewport_rect().size
	var node = 0
	
	if win.y == -INF:
		return
	
	rect_size = Vector2(win.x, win.y)


func setDifficultyDescriptionText():
	diffDesc.text = diff.DifficultyDescription[diff.active_difficulty]

func resetDiff():
	
	for x in DEFAULT_VALUES:
		resetDiffOption(x)
	
	diffValues.show()
	diffCustom.hide()
	
	diffDropdown.select(5)
	_on_difficulty_selected(5)
	
	for x in DEFAULT_VALUES:
		setOptionValue(x, diff.call("get" + x))
	
	setDifficultyDescriptionText()
	
	
	var randomSaveFileColor = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1))
	
	get_node("sc/m/v/v/save info/m/v/color/m/ColorRect").self_modulate = randomSaveFileColor

func resetDiffOption(attribute: String):
	
	if attribute == "Crit":
		get("customize_" + attribute + "_text").text = str(DEFAULT_VALUES[attribute])
	else:
		get("customize_" + attribute + "_text").text = addDecimalToAttributeValueIfNeeded(DEFAULT_VALUES[attribute])
	get("customize_" + attribute + "_slider").value = DEFAULT_VALUES[attribute]
	get("customize_" + attribute + "_text").cursor_set_column(100)

func setOptionValue(option: String, val: float):
	
	var node_var = "_" + option
	
	if option == "Crit":
		if val >= 0:
			get(node_var).text = "+" + str(val)
		else:
			get(node_var).text = str(val)
	else:
		get(node_var).text = str(val) + "x"
	
	get(node_var).self_modulate = getOptionColor(option, val)

func getOptionColor(option: String, val: float) -> Color:
	match option:
		"Output", "Haste":
			if val >= 2.0:
				return COLORS["easy"]
			if val <= 0.25:
				return COLORS["hardest"]
			if val <= 0.5:
				return COLORS["hard"]
		"Input", "FuelStorage", "FuelConsumption":
			if val <= 0.5:
				return COLORS["easy"]
			if val >= 4:
				return COLORS["hardest"]
			if val >= 2:
				return COLORS["hard"]
		"Crit":
			if val > 0:
				return COLORS["easy"]
			elif val < -10:
				return COLORS["hardest"]
			elif val < 0:
				return COLORS["hard"]
	
	
	return COLORS["normal"]

func addDecimalToAttributeValueIfNeeded(val: float) -> String:
	return str(val) if "." in str(val) else str(val) + ".0"


var old_color: Color
func setColoringNode(node):
	color_picker.show()
	coloring_node = node
	old_color = coloring_node.color
func _on_ColorPicker_color_changed(color: Color) -> void:
	if coloring_node.has_method("getMostRecent"):
		if coloring_node.mostRecent:
			save_blocks[mostRecentSave].color = color
			save_blocks["mostRecentSave"].color = color
		else:
			coloring_node.color = color
	else:
		coloring_node.color = color

func _on_color_cancel_pressed() -> void:
	
	if old_color == null:
		return
	
	if not color_picker.visible:
		return
	
	if coloring_node.has_method("getMostRecent"):
		if coloring_node.mostRecent:
			save_blocks[mostRecentSave].color = old_color
			save_blocks["mostRecentSave"].color = old_color
	
	coloring_node.color = old_color
	color_picker.hide()

func _on_accept_color_edit_pressed() -> void:
	color_picker.hide()
	coloring_node.saveColor()



func getSavesInDirectory(path: String) -> Array:
	
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if not file.ends_with(".lored"):
			continue
		
		var fileText = SaveManager.getSaveText(file)
		
		if fileText == null:
			continue
		
		if SaveManager.textIsConvertibleToSave(fileText):
			files.append(file)
	
	dir.list_dir_end()
	
	return files

func setupAllSaves():
	
	var files: Array = getSavesInDirectory("user://")
	
	if files.size() == 0:
		noSavesFound()
		return
	
	for f in files:
		
		save_blocks[f] = gv.SRC["save block"].instance()
		save_blocks[f].setup(f)
		all_saves_container.add_child(save_blocks[f])
	
	determineMostRecentSave()
	
	save_blocks[mostRecentSave].mostRecent = true
	
	setupMostRecentSave()

func refreshAllSaves():
	
	for x in save_blocks:
		save_blocks[x].queue_free()
	save_blocks.clear()
	
	setupAllSaves()

func noSavesFound():
	no_saves_found = true
	get_node("h/v/continue").hide()


func determineMostRecentSave():
	
	var most_recent_clock := 0
	
	for f in save_blocks:
		var clock = save_blocks[f].clock
		if clock > most_recent_clock:
			most_recent_clock = clock
			mostRecentSave = f

func setupMostRecentSave():
	
	if no_saves_found:
		return
	
	wipePreviousMostRecentSave()
	
	save_blocks["mostRecentSave"] = gv.SRC["save block"].instance()
	save_blocks["mostRecentSave"].setup(mostRecentSave)
	save_blocks["mostRecentSave"].mostRecent = true
	get_node("tip").add_child(save_blocks["mostRecentSave"])
	save_blocks["mostRecentSave"].rect_position = Vector2(108, 153)
	save_blocks["mostRecentSave"].hide()

func wipePreviousMostRecentSave():
	if not "mostRecentSave" in save_blocks.keys():
		return
	save_blocks["mostRecentSave"].queue_free()




func _on_continue_pressed() -> void:
	var saveName = save_blocks["mostRecentSave"].saveName
	var saveColor = save_blocks["mostRecentSave"].color
	SaveManager.loadGame(saveName, saveColor)

func _on_load_pressed() -> void:
	all_saves.show()
	get_node("h").visible = not all_saves.visible
	_on_load_mouse_exited()
	exitConfirm.hide()
func _on_all_saves_back_pressed() -> void:
	all_saves.hide()
	get_node("h").visible = not all_saves.visible
	_on_all_saves_back_mouse_exited()
	gv.emit_signal("hideAllActions")
	_on_color_cancel_pressed()

func _on_refresh_pressed() -> void:
	refreshAllSaves()

func _on_import_pressed() -> void:
	all_saves.hide()
	importWindow.show()
	_on_all_saves_import_mouse_exited()
	exitConfirm.hide()
func _on_import_back_pressed() -> void:
	importWindow.hide()
	all_saves.show()
	_on_import_back_mouse_exited()
	_on_import_byString_cancel_pressed()


func _on_import_byString_pressed() -> void:
	importByStringWindow.show()
	get_node("import/byString/m/v/TextEdit").grab_focus()
	get_node("import/byString/m/v/TextEdit").select_all()
	_on_import_byString_mouse_exited()
func _on_import_byString_cancel_pressed() -> void:
	importByStringWindow.hide()
	if get_node("import/byString/m/v/manual save name/h/check").pressed:
		get_node("import/byString/m/v/manual save name/h/check").pressed = false
		_on_byString_manual_save_name_pressed()
func _on_byString_manual_save_name_pressed() -> void:
	randomizeSaveNameAndColor(get_node("import/byString/m/v/manual save name/h2/TextEdit"), get_node("import/byString/m/v/manual save name/h2/m/ColorRect"))
	get_node("import/byString/m/v/manual save name/h2").visible = get_node("import/byString/m/v/manual save name/h/check").pressed
	get_node("import/byString/m/v/manual save name/h2/TextEdit").grab_focus()
	get_node("import/byString/m/v/manual save name/h2/TextEdit").select_all()
func _on_importByString_color_pressed() -> void:
	gv.emit_signal("edit_save_color", get_node("import/byString/m/v/manual save name/h2/m/ColorRect"))

func _on_import_byString_savename_text_changed() -> void:
	if "\n" in get_node("import/byString/m/v/manual save name/h2/TextEdit").text:
		get_node("import/byString/m/v/manual save name/h2/TextEdit").text = get_node("import/byString/m/v/manual save name/h2/TextEdit").text.split("\n")[0]
		_on_import_byString_go_pressed()

func _on_import_byString_go_pressed() -> void:
	
	var saveText = get_node("import/byString/m/v/TextEdit").text
	
	if SaveManager.textIsConvertibleToSave(saveText):
		
		var saveName: String
		
		if get_node("import/byString/m/v/manual save name/h/check").pressed:
			saveName = get_node("import/byString/m/v/manual save name/h2/TextEdit").text
			
			if not saveName.is_valid_filename():
				get_node("filename error").show()
				
				var t = Timer.new()
				add_child(t)
				t.start(5)
				yield(t, "timeout")
				t.queue_free()
				get_node("filename error").hide()
				return
			
			saveName = SaveManager.getUniqueFilename(saveName)
			var saveColor: Color = get_node("import/byString/m/v/manual save name/h2/m/ColorRect").getSaveColor()
			SaveManager.importSave(saveText, saveName, saveColor)
		else:
			saveName = SaveManager.getRandomSaveFileName()
			SaveManager.importSave(saveText, saveName)
		
		_on_import_byString_cancel_pressed()
		
		saveImported(saveName)
	
	else:
		get_node("import/byString failure/m/v/TextEdit").text = saveText
		_on_import_byString_cancel_pressed()
		importByStringFailureWindow.show()

func _on_import_byString_failure_pressed() -> void:
	importByStringFailureWindow.hide()
	_on_import_byString_pressed()


func _on_import_byFile_pressed() -> void:
	var dialogSize = Vector2(450,300)
	var winSize = get_viewport().size
	importDialog.popup(Rect2(winSize.x / 2 - dialogSize.x / 2, winSize.y / 2 - dialogSize.y / 2, dialogSize.x, dialogSize.y))
func _on_import_byFile_failure_pressed() -> void:
	importByFileWindow.hide()

func _on_FileDialog_file_selected(path: String) -> void:
	
	var file = File.new()
	file.open(path, File.READ)
	
	var rawText = file.get_line()
	
	file.close()
	
	if not SaveManager.textIsConvertibleToSave(rawText):
		importByFileWindow.show()
		get_node("import/byFile failure/m/v/TextEdit").text = rawText
		return
	
	var saveName = SaveManager.getRandomSaveFileName()
	SaveManager.importSave(rawText, saveName)
	saveImported(saveName)

func saveImported(saveName: String):
	
	_on_import_back_pressed()
	
	refreshAllSaves()
	
	var flash = gv.SRC["flash"].instance()
	save_blocks[saveName].add_child(flash)
	
	var t = Timer.new()
	add_child(t)
	t.start(0.5)
	yield(t, "timeout")
	t.queue_free()
	
	flash.slowFlash(Color(1,1,1))

func _on_oopsie_pressed() -> void:
	get_node("filename error").hide()



func _on_newgame_pressed() -> void:
	get_node("h").hide()
	newGameWindow.show()
	_on_new_mouse_exited()
	exitConfirm.hide()
func _on_newgame_back_pressed() -> void:
	get_node("new game/m/v/save info").hide()
	get_node("new game/m/v/diff").hide()
	get_node("new game/m/v/prefs").hide()
	newGameWindow.hide()
	get_node("h").show()
	_on_newgame_back_mouse_exited()
	_on_color_cancel_pressed()


func _on_new_safeinfo_pressed() -> void:
	get_node("new game/m/v/save info").visible = not get_node("new game/m/v/save info").visible
	get_node("new game/m/v/diff").hide()
	get_node("new game/m/v/prefs").hide()
	get_node("new game/m/v/save info/m/v/filename/TextEdit").scroll_horizontal = 0
	get_node("new game/m/v/save info/m/v/filename/TextEdit").grab_focus()
	get_node("new game/m/v/save info/m/v/filename/TextEdit").select_all()
func _on_new_diff_pressed() -> void:
	get_node("new game/m/v/diff").visible = not get_node("new game/m/v/diff").visible
	get_node("new game/m/v/save info").hide()
	get_node("new game/m/v/prefs").hide()
func _on_new_prefs_pressed() -> void:
	get_node("new game/m/v/prefs").visible = not get_node("new game/m/v/prefs").visible
	get_node("new game/m/v/save info").hide()
	get_node("new game/m/v/diff").hide()

func _on_HSlider_value_changed(value: float, attribute: String) -> void:
	
	if get("customize_" + attribute + "_text").has_focus():
		return
	
	if attribute == "Crit":
		get("customize_" + attribute + "_text").text = str(value)
	else:
		get("customize_" + attribute + "_text").text = addDecimalToAttributeValueIfNeeded(value)
	get("customize_" + attribute + "_text").cursor_set_column(100)

func updateOptionValues():
	for x in DEFAULT_VALUES:
		setOptionValue(x, diff.get(x))

func _on_difficulty_selected(index: int) -> void:
	
	diff.changeDifficulty(index)
	
	setDifficultyDescriptionText()
	
	if index == diff.Difficulty.CUSTOM:
		diffValues.hide()
		diffCustom.show()
		return
	else:
		diffCustom.hide()
		diffValues.show()
	
	updateOptionValues()



func randomizeSaveNameAndColor(saveNameNode, colorNode):
	saveNameNode.text = SaveManager.getRandomSaveFileName()
	colorNode.setSaveColor(gv.getRandomColor())

func _on_randomize_pressed() -> void:
	randomizeSaveNameAndColor(get_node("new game/m/v/save info/m/v/filename/TextEdit"), get_node("new game/m/v/save info/m/v/v2/color/m/ColorRect"))
	color_picker.hide()
func _on_custom_randomize_pressed() -> void:
	for d in DEFAULT_VALUES:
		var _min = MIN_VALUES[d]
		var _max = MAX_VALUES[d]
		var randomVal = stepify(rand_range(_min, _max), 0.1)
		get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/" + d + "/h/HSlider").value = randomVal
		_on_HSlider_value_changed(randomVal, d)

func _on_new_color_pressed() -> void:
	gv.emit_signal("edit_save_color", get_node("new game/m/v/save info/m/v/v2/color/m/ColorRect"))

func _on_newgame_play_pressed() -> void:
	if get_node("new game/m/v/diff/m/v/v/custom").visible:
		for d in DEFAULT_VALUES:
			var val = float(get_node("new game/m/v/diff/m/v/v/custom/m/v/lored/m/v/" + d + "/TextEdit").text)
			diff.call("set" + d, val)
	
	var saveName = get_node("new game/m/v/save info/m/v/filename/TextEdit").text
	
	if not saveName.is_valid_filename():
		get_node("filename error").show()
		
		var t = Timer.new()
		add_child(t)
		t.start(5)
		yield(t, "timeout")
		t.queue_free()
		get_node("filename error").hide()
		return
	
	saveName = SaveManager.getUniqueFilename(saveName)
	
	var saveColor = get_node("new game/m/v/save info/m/v/v2/color/m/ColorRect").color
	
	SaveManager.loadNewGame(saveName, saveColor)

# if adding new main menu buttons, add signals for mouse_entered
# then call buttonEntered and buttonExited with their path (see funcs directly below) to make it all work

func _on_continue_mouse_entered() -> void:
	buttonEntered("h/v/continue")
	if "mostRecentSave" in save_blocks:
		save_blocks["mostRecentSave"].show()
func _on_new_mouse_entered() -> void:
	buttonEntered("h/v/new")
func _on_load_mouse_entered() -> void:
	buttonEntered("h/v/load")
func _on_all_saves_back_mouse_entered() -> void:
	buttonEntered("all saves/top/h/v/v/back")
func _on_all_saves_import_mouse_entered() -> void:
	buttonEntered("all saves/top/h/v/v/import")
func _on_all_saves_refresh_mouse_entered() -> void:
	buttonEntered("all saves/top/h/v/v/refresh")
func _on_import_back_mouse_entered() -> void:
	buttonEntered("import/top/h/v/v/back")
func _on_import_byString_mouse_entered() -> void:
	get_node("import/m/h/byString/v/h/text").add_font_override("font", gv.font.buttonHover)
func _on_import_byFile_mouse_entered() -> void:
	get_node("import/m/h/byFile/v/h/text").add_font_override("font", gv.font.buttonHover)
func _on_newgame_back_mouse_entered() -> void:
	buttonEntered("new game/top/h/v/v/back")
func _on_new_saveinfo_mouse_entered() -> void:
	get_node("new game/m/v/v/h/save info/v/h/text").add_font_override("font", gv.font.buttonHover)
func _on_new_diff_entered() -> void:
	get_node("new game/m/v/v/h/diff/v/h/text").add_font_override("font", gv.font.buttonHover)
func _on_new_prefs_mouse_entered() -> void:
	get_node("new game/m/v/v/h/prefs/v/h/text").add_font_override("font", gv.font.buttonHover)
func _on_randomize_mouse_entered() -> void:
	get_node("new game/m/v/save info/m/v/randomize/v/h/text").add_font_override("font", gv.font.buttonHover)
func _on_custom_randomize_mouse_entered() -> void:
	get_node("new game/m/v/diff/m/v/v/custom/m/v/randomize/v/h/text").add_font_override("font", gv.font.buttonHover)
func _on_newgame_play_mouse_entered() -> void:
	buttonEntered("new game/top/h/v/v/begin")






func _on_continue_mouse_exited() -> void:
	buttonExited("h/v/continue")
	if "mostRecentSave" in save_blocks:
		save_blocks["mostRecentSave"].hide()
func _on_new_mouse_exited() -> void:
	buttonExited("h/v/new")
func _on_load_mouse_exited() -> void:
	buttonExited("h/v/load")
func _on_all_saves_back_mouse_exited() -> void:
	buttonExited("all saves/top/h/v/v/back")
func _on_all_saves_import_mouse_exited() -> void:
	buttonExited("all saves/top/h/v/v/import")
func _on_all_saves_refresh_mouse_exited() -> void:
	buttonExited("all saves/top/h/v/v/refresh")
func _on_import_back_mouse_exited() -> void:
	buttonExited("import/top/h/v/v/back")
func _on_import_byString_mouse_exited() -> void:
	get_node("import/m/h/byString/v/h/text").add_font_override("font", gv.font.buttonNormal)
func _on_import_byFile_mouse_exited() -> void:
	get_node("import/m/h/byFile/v/h/text").add_font_override("font", gv.font.buttonNormal)
func _on_newgame_back_mouse_exited() -> void:
	buttonExited("new game/top/h/v/v/back")
func _on_new_saveinfo_mouse_exited() -> void:
	get_node("new game/m/v/v/h/save info/v/h/text").add_font_override("font", gv.font.buttonNormal)
func _on_new_diff_mouse_exited() -> void:
	get_node("new game/m/v/v/h/diff/v/h/text").add_font_override("font", gv.font.buttonNormal)
func _on_new_prefs_mouse_exited() -> void:
	get_node("new game/m/v/v/h/prefs/v/h/text").add_font_override("font", gv.font.buttonNormal)
func _on_randomize_mouse_exited() -> void:
	get_node("new game/m/v/save info/m/v/randomize/v/h/text").add_font_override("font", gv.font.buttonNormal)
func _on_custom_randomize_mouse_exited() -> void:
	get_node("new game/m/v/diff/m/v/v/custom/m/v/randomize/v/h/text").add_font_override("font", gv.font.buttonNormal)
func _on_newgame_play_mouse_exited() -> void:
	buttonExited("new game/top/h/v/v/begin")



func buttonEntered(path: String):
	get_node(path + "/m/text").add_font_override("font", gv.font.buttonHover)
	get_node(path + "/flair/Sprite").show()
func buttonExited(path: String):
	get_node(path + "/m/text").add_font_override("font", gv.font.buttonNormal)
	get_node(path + "/flair/Sprite").hide()



func _on_exit_pressed() -> void:
	get_tree().quit()
func _on_dontExit_pressed() -> void:
	exitConfirm.hide()






