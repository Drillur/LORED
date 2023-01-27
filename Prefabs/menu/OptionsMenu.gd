extends MarginContainer


var saved_vars := ["fps", "notation", "animations", "loredOutputNumbers", "loredChitChat", "loredFuel", "tipSleep", "loredCritsOnly", "autosave", "flying_numbers", "contentVisual", "contentLORED", "contentSave"]

var animations := true
var loredOutputNumbers := true
var loredChitChat := true
var loredFuel := true
var tipSleep := true
var loredCritsOnly := false
var autosave := true
var flying_numbers := true

var contentVisual := true
var contentLORED := true
var contentSave := true

func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		data[x] = var2str(get(x))
	
	return var2str(data)

func load(data: Dictionary) -> void:
	
	var saved_vars_dict := {}
	
	for x in saved_vars:
		saved_vars_dict[x] = get(x)
	
	var loadedVars = SaveManager.loadSavedVars(saved_vars_dict, data)
	
	for x in saved_vars:
		if not x in loadedVars:
			continue
		set(x, loadedVars[x])
		if x in ["fps", "notation"]:
			continue
		if "content" in x:
			var split = x.split("content")[1]
			get_node("%content" + split).visible = loadedVars[x]
			get_node("%hideIcon" + split).texture = gv.sprite["view"] if loadedVars[x] else gv.sprite["viewHide"]
			continue
		get_node("%" + x).pressed = loadedVars[x]
		call("selectOption", x)
	
	selectFPS(fps)
	selectNotation(notation)


func _ready() -> void:
	setupFPS()
	setupNotation()
	
	if gv.PLATFORM == gv.Platform.PC:
		selectFPS(2)
	else:
		selectFPS(0)



# - - - Options

var fps := 0
func setupFPS():
	var fps = get_node("%fps dropdown")
	fps.add_item("15")
	fps.add_item("30")
	fps.add_item("60")
func selectFPS(index: int) -> void:
	fps = index
	get_node("%fps dropdown").select(index)
	gv.option["FPS"] = index
	gv.fps = [0.0666, 0.0333, 0.0166][index] # 15, 30, 60

var notation := 0
func setupNotation():
	var notation = get_node("%notationDropdown")
	notation.add_item("Scientific")
	notation.add_item("Engineering")
	notation.add_item("Logarithmic")
func selectNotation(index: int):
	notation = index
	get_node("%notationDropdown").select(index)
	gv.option["notation_type"] = index


func selectOption(option: String):
	set(option, get_node("%" + option).pressed)
	gv.option[option] = get(option)
	match option:
		"loredFuel":
			lv.displayLOREDFuelOnBar()
		"autosave":
			get_node("/root/Root").get_node("%SaveMenu").autosaveOptionChanged()




# - - - Buttons

func switchContent(which: String):
	get_node("%content" + which).visible = not get_node("%content" + which).visible
	get_node("%hideIcon" + which).texture = gv.sprite["view"] if get_node("%content" + which).visible else gv.sprite["viewHide"]
	get_node("%hideIcon" + which + "/shadow").texture = get_node("%hideIcon" + which).texture
	set("content" + which, get_node("%content" + which).visible)

func closeAllContentExcept(which: String):
	for x in ["Visual", "LORED", "Save"]:
		if x == which:
			if not get_node("%content" + x).visible:
				switchContent(x)
			continue
		if get("content" + x):
			switchContent(x)

func _on_visualHide_pressed() -> void:
	switchContent("Visual")

func _on_LOREDHide_pressed() -> void:
	switchContent("LORED")

func _on_saveHide_pressed() -> void:
	switchContent("Save")

func _on_fps_dropdown_item_selected(index: int) -> void:
	selectFPS(index)

func _on_notationDropdown_item_selected(index: int) -> void:
	selectNotation(index)
