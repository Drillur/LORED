extends MarginContainer


onready var color_picker := get_node("color/m")
onready var all_saves_container := get_node("all saves/sc/v/v")
onready var save_hint = get_node("sc/h/all saves/Node2D/hint")
onready var importDialog = get_node("FileDialog")

onready var all_saves := get_node("all saves")
onready var importWindow := get_node("import")
onready var new_game_window = get_node("sc/h/New Game")
onready var importByStringWindow = get_node("import/byString")
onready var importByStringFailureWindow = get_node("import/byString failure")
onready var importByFileWindow = get_node("import/byFile failure")
onready var exitConfirm = get_node("exitConfirm")

var no_saves_found := false

var coloring_node = 0

var save_blocks := {}
var mostRecentSave: String


func _ready():
	
	gv.connect("hideAllActions", self, "_on_color_cancel_pressed")
	
	get_tree().get_root().connect("size_changed", self, "windowSizeChanged")
	
	gv.active_scene = gv.Scene.MAIN_MENU
	
	gv.connect("edit_save_color", self, "setColoringNode")
	
	all_saves.hide()
	save_hint.hide()
	color_picker.hide()
	new_game_window.hide()
	all_saves.hide()
	importWindow.hide()
	importByStringWindow.hide()
	get_node("import/byString/m/v/manual save name/h2").hide()
	importByStringFailureWindow.hide()
	importByFileWindow.hide()
	importDialog.set_access(2)
	importDialog.set_mode(0)
	exitConfirm.hide()
	get_node("h").show()
	
	setupAllSaves()
	
	hideMouseoverFlairs()
	
	windowSizeChanged()

func hideMouseoverFlairs():
	
	get_node("h/v/continue/flair/Sprite").hide()
	get_node("h/v/new/flair/Sprite").hide()
	get_node("h/v/load/flair/Sprite").hide()
	get_node("all saves/top/h/v/v/back/flair/Sprite").hide()
	get_node("all saves/top/h/v/v/import/flair/Sprite").hide()
	get_node("all saves/top/h/v/v/refresh/flair/Sprite").hide()
	get_node("import/top/h/v/v/back/flair/Sprite").hide()



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
		
		exitConfirm.visible = not exitConfirm.visible

func clearMouseoverEffects():
	hideMouseoverFlairs()
	get_node("all saves/top/h/v/v/back/m/text").add_font_override("font", gv.font.buttonNormal)
	get_node("all saves/top/h/v/v/refresh/m/text").add_font_override("font", gv.font.buttonNormal)
	get_node("all saves/top/h/v/v/import/m/text").add_font_override("font", gv.font.buttonNormal)
	get_node("import/top/h/v/v/back/m/text").add_font_override("font", gv.font.buttonNormal)
	get_node("import/m/h/byString/v/h/text").add_font_override("font", gv.font.buttonNormal)
	get_node("import/m/h/byFile/v/h/text").add_font_override("font", gv.font.buttonNormal)
	

func windowSizeChanged() -> void:
	
	var win: Vector2 = get_viewport_rect().size
	var node = 0
	
	if win.y == -INF:
		return
	
	rect_size = Vector2(win.x, win.y)


func _on_all_saves_pressed() -> void:
	
	if all_saves.visible:
		all_saves.hide()
		save_hint.hide()
		return
	
	all_saves.show()


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
			print("file appended ", file)
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


func _on_save_hint_mouse_entered() -> void:
	save_hint.show()
func _on_save_hint_mouse_exited() -> void:
	save_hint.hide()


func _on_continue_pressed() -> void:
	var saveName = save_blocks["mostRecentSave"].saveName
	var saveColor = save_blocks["mostRecentSave"].color
	SaveManager.loadGame(saveName, saveColor)
func _on_new_game_pressed() -> void:
	if new_game_window.visible:
		new_game_window._on_back_pressed()
	else:
		new_game_window.show()

func _on_load_pressed() -> void:
	all_saves.show()
	get_node("h").visible = not all_saves.visible
	_on_load_mouse_exited()
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
	get_node("import/byString/m/v/manual save name/h2/m/ColorRect").setSaveColor(gv.getRandomColor())
	get_node("import/byString/m/v/manual save name/h2/TextEdit").text = SaveManager.getRandomSaveFileName()
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


func _on_oopsie_pressed() -> void:
	get_node("filename error").hide()
