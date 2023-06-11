extends MarginContainer


var saved_vars := ["fps", "notation", "animations", "loredOutputNumbers", "loredChitChat", "loredFuel", "tipSleep", "loredCritsOnly", "autosave", "flying_numbers",
"levelUpDetails", "wishVicosOnMainScreen"]

onready var tab_container = $MarginContainer/TabContainer

var animations := true
var loredOutputNumbers := true
var loredChitChat := true
var loredFuel := true
var tipSleep := true
var loredCritsOnly := false
var autosave := true
var flying_numbers := true
var levelUpDetails := true
var wishVicosOnMainScreen := true


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
	var _fps = get_node("%fps dropdown")
	_fps.add_item("15")
	_fps.add_item("30")
	_fps.add_item("60")
func selectFPS(index: int) -> void:
	fps = index
	get_node("%fps dropdown").select(index)
	gv.option["FPS"] = index
	gv.fps = [0.0666, 0.0333, 0.0166][index] # 15, 30, 60

var notation := 0
func setupNotation():
	var _notation = get_node("%notationDropdown")
	_notation.add_item("Scientific")
	_notation.add_item("Engineering")
	_notation.add_item("Logarithmic")
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
		"wishVicosOnMainScreen":
			if gv.option[option]:
				taq.populateMainScreenVicos()
			else:
				taq.deleteMainScreenVicos()
				get_node("/root/Root").clearWishNotice()




# - - - Buttons

func select_tab(tab: int):
	tab_container.current_tab = tab


func _on_fps_dropdown_item_selected(index: int) -> void:
	selectFPS(index)

func _on_notationDropdown_item_selected(index: int) -> void:
	selectNotation(index)

