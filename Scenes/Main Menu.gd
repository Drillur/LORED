extends MarginContainer


onready var all_saves := get_node("sc/h/all saves")
onready var color_picker := get_node("color")
onready var all_saves_container := get_node("sc/h/all saves/m/v/ScrollContainer/GridContainer")
onready var save_hint = get_node("sc/h/all saves/Node2D/hint")
onready var new_game_window = get_node("sc/h/New Game")



var no_saves_found := false

var coloring_node = 0

var save_blocks := {}
var mostRecentSave: String


func _ready():
	
	gv.active_scene = gv.Scene.MAIN_MENU
	
	gv.connect("edit_save_color", self, "setColoringNode")
	gv.connect("save_block_opened", self, "hideActions")
	
	all_saves.hide()
	save_hint.hide()
	color_picker.hide()
	new_game_window.hide()
	
	setupAllSaves()
	
	if not no_saves_found:
		determineMostRecentSave()
		setupMostRecentSave()


func hideActions():
	
	for s in save_blocks:
		save_blocks[s].hideActions()


func _on_all_saves_pressed() -> void:
	
	if all_saves.visible:
		all_saves.hide()
		save_hint.hide()
		hideActions()
		return
	
	all_saves.show()


var old_color: Color
func setColoringNode(node):
	color_picker.show()
	coloring_node = node
	old_color = coloring_node.getSaveColor()
func _on_ColorPicker_color_changed(color: Color) -> void:
	if coloring_node.has_method("isMostRecent"):
		if coloring_node.isMostRecent():
			save_blocks[mostRecentSave].setSaveColor(color)
			get_node("sc/h/continue/m/v/v/last played").get_child(1).setSaveColor(color)
		else:
			coloring_node.setSaveColor(color)
	else:
		coloring_node.setSaveColor(color)

func _on_color_cancel_pressed() -> void:
	
	if not color_picker.visible:
		return
	
	if coloring_node.has_method("isMostRecent"):
		if coloring_node.isMostRecent():
			save_blocks["mostRecentSave"].setSaveColor(old_color)
	
	coloring_node.setSaveColor(old_color)
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
		files.append(file)
	
	dir.list_dir_end()
	
	return files

func setupAllSaves():
	
	var files: Array = getSavesInDirectory("user://")
	
	if files.size() == 0:
		noSavesFound()
		return
	
	for f in files:
		
		save_blocks[f] = gv.SRC["save slot block"].instance()
		save_blocks[f].setup(f)
		all_saves_container.add_child(save_blocks[f])
	
	
#	var t = Timer.new()
#	add_child(t)
#	t.start(0.1)
#	yield(t, "timeout")
#	t.queue_free()
	
	determineMostRecentSave()
	
	save_blocks[mostRecentSave].most_recent = true

func refreshAllSaves():
	
	for x in save_blocks:
		save_blocks[x].queue_free()
	save_blocks.clear()
	
	setupAllSaves()

func noSavesFound():
	no_saves_found = true
	get_node("sc/h/continue").hide()


func determineMostRecentSave():
	
	var most_recent_clock := 0
	
	for f in save_blocks:
		var clock = save_blocks[f].clock
		if clock > most_recent_clock:
			most_recent_clock = clock
			mostRecentSave = f

func setupMostRecentSave():
	
	wipePreviousMostRecentSave()
	
	save_blocks["mostRecentSave"] = gv.SRC["save slot block"].instance()
	save_blocks["mostRecentSave"].setup(mostRecentSave)
	save_blocks["mostRecentSave"].setMostRecent()
	get_node("sc/h/continue/m/v/v/last played").add_child(save_blocks["mostRecentSave"])

func wipePreviousMostRecentSave():
	if not "mostRecentSave" in save_blocks.keys():
		return
	save_blocks["mostRecentSave"].queue_free()



func _on_save_hint_mouse_entered() -> void:
	save_hint.show()
func _on_save_hint_mouse_exited() -> void:
	save_hint.hide()


func _on_new_game_pressed() -> void:
	if new_game_window.visible:
		new_game_window._on_back_pressed()
	else:
		new_game_window.show()




func _on_refresh_pressed() -> void:
	refreshAllSaves()
