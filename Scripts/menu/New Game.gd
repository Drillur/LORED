extends MarginContainer



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

onready var _filename = get_node("sc/m/v/v/save info/m/v/filename/TextEdit")

onready var values = get_node("sc/m/v/v/difficulty/m/v/v/values")
onready var custom = get_node("sc/m/v/v/difficulty/m/v/v/custom")

onready var desc = get_node("sc/m/v/v/difficulty/m/v/v/presets/m/v/desc")


onready var customize_Output_text = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/Output/TextEdit")
onready var customize_Output_slider = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/Output/h/HSlider")
onready var customize_Input_text = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/Input/TextEdit")
onready var customize_Input_slider = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/Input/h/HSlider")
onready var customize_Haste_text = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/Haste/TextEdit")
onready var customize_Haste_slider = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/Haste/h/HSlider")
onready var customize_CritAdd_text = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/CritAdd/TextEdit")
onready var customize_CritAdd_slider = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/CritAdd/h/HSlider")
onready var customize_Crit_text = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/Crit/TextEdit")
onready var customize_Crit_slider = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/Crit/h/HSlider")
onready var customize_FuelStorage_text = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/FuelStorage/TextEdit")
onready var customize_FuelStorage_slider = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/FuelStorage/h/HSlider")
onready var customize_FuelConsumption_text = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/FuelConsumption/TextEdit")
onready var customize_FuelConsumption_slider = get_node("sc/m/v/v/difficulty/m/v/v/custom/m/v/lored/m/v/FuelConsumption/h/HSlider")


onready var _Output = get_node("sc/m/v/v/difficulty/m/v/v/values/m/v/lored/m/v/Output/text")
onready var _Input = get_node("sc/m/v/v/difficulty/m/v/v/values/m/v/lored/m/v/Input/text")
onready var _Haste = get_node("sc/m/v/v/difficulty/m/v/v/values/m/v/lored/m/v/Haste/text")
onready var _CritAdd = get_node("sc/m/v/v/difficulty/m/v/v/values/m/v/lored/m/v/CritAdd/text")
onready var _Crit = get_node("sc/m/v/v/difficulty/m/v/v/values/m/v/lored/m/v/Crit/text")
onready var _FuelStorage = get_node("sc/m/v/v/difficulty/m/v/v/values/m/v/lored/m/v/FuelStorage/text")
onready var _FuelConsumption = get_node("sc/m/v/v/difficulty/m/v/v/values/m/v/lored/m/v/FuelConsumption/text")


onready var select_difficulty = get_node("sc/m/v/v/difficulty/m/v/v/presets/m/v/select")


func _ready():
	
	for difficulty in diff.Difficulty:
		select_difficulty.add_item(str(difficulty).capitalize())
	
	resetShit()

func resetShit():
	
	for x in DEFAULT_VALUES:
		resetOption(x)
	
	values.show()
	custom.hide()
	
	select_difficulty.select(3)
	_on_difficulty_selected(3)
	
	for x in DEFAULT_VALUES:
		setOptionValue(x, diff.call("get" + x))
	
	setDifficultyDescriptionText()
	
	_on_confirm_difficulty_pressed()
	
	_filename.text = SaveManager.getRandomSaveFileName()
	
	var randomSaveFileColor = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1))
	
	get_node("sc/m/v/v/save info/m/v/color/m/ColorRect").self_modulate = randomSaveFileColor

#requirements:
#	available filename
#		auto-fill filename text edit node with text that isnt used by another file
#	difficulty
#		default: Normal
#optional:
#	save color
#	make this save the main save



func _on_back_pressed() -> void:
	hide()
	resetShit()




func _on_difficulty_selected(index: int) -> void:
	
	diff.changeDifficulty(index)
	
	setDifficultyDescriptionText()
	
	if index == diff.Difficulty.CUSTOM:
		values.hide()
		custom.show()
		return
	else:
		custom.hide()
		values.show()
	
	updateOptionValues()

func setDifficultyDescriptionText():
	desc.text = diff.DifficultyDescription[diff.active_difficulty]

func updateOptionValues():
	for x in DEFAULT_VALUES:
		setOptionValue(x, diff.call("get" + x))



func setOptionValue(option: String, val: float):
	
	var node_var = "_" + option
	
	if option == "CritAdd":
		get(node_var).text = "+" + str(val)
	else:
		get(node_var).text = str(val) + "x"
	
	get(node_var).self_modulate = getOptionColor(option, val)

func getOptionColor(option: String, val: float) -> Color:
	match option:
		"Output", "Haste", "Crit":
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
		"CritAdd":
			if val > 0:
				return COLORS["easy"]
	
	
	return COLORS["normal"]




# Note, for when adding new attribute modifiers.
# The node needs to have an onready var defined above
# The signal should have an extra argument (see: attribute argument in the method below)
# The extra argument should match its name. i.e. Haste, Input, Output


func resetOption(attribute: String):
	
	if attribute == "CritAdd":
		get("customize_" + attribute + "_text").text = str(DEFAULT_VALUES[attribute])
	else:
		get("customize_" + attribute + "_text").text = addDecimalToAttributeValueIfNeeded(DEFAULT_VALUES[attribute])
	get("customize_" + attribute + "_slider").value = DEFAULT_VALUES[attribute]
	get("customize_" + attribute + "_text").cursor_set_column(100)

func correctAttributeValueIfNeeded(attribute: String, val: float) -> float:
	val = matchAttributeStep(attribute, val)
	val = clampAttributeValue(attribute, val)
	return val
func matchAttributeStep(attribute: String, val: float) -> float:
	return stepify(val, get("customize_" + attribute + "_slider").step)
func clampAttributeValue(attribute: String, val: float) -> float:
	return clamp(val, MIN_VALUES[attribute], MAX_VALUES[attribute])


func _on_TextEdit_text_changed(attribute: String) -> void:
	
	var val = get("customize_" + attribute + "_text").text
	
	if val == "":
		return
	
	if "\n" in val:
		get("customize_" + attribute + "_text").text = val.replace("\n", "")
		val = get("customize_" + attribute + "_text").text
		get("customize_" + attribute + "_text").focus_next.grab_focus()
		#get("customize_" + attribute + "_text").cursor_set_column(20)
	
	if val.ends_with("."):
		return
	
	if not val.is_valid_float():
		resetOption(attribute)
		return
	
	val = correctAttributeValueIfNeeded(attribute, float(val))
	get("customize_" + attribute + "_slider").value = val

func _on_TextEdit_focus_exited(attribute: String) -> void:
	if attribute == "CritAdd":
		get("customize_" + attribute + "_text").text = str(get("customize_" + attribute + "_slider").value)
	else:
		get("customize_" + attribute + "_text").text = addDecimalToAttributeValueIfNeeded(get("customize_" + attribute + "_slider").value)
	get("customize_" + attribute + "_text").cursor_set_column(2)

func addDecimalToAttributeValueIfNeeded(val: float) -> String:
	return str(val) if "." in str(val) else str(val) + ".0"

func _on_HSlider_value_changed(value: float, attribute: String) -> void:
	
	if get("customize_" + attribute + "_text").has_focus():
		return
	
	if attribute == "CritAdd":
		get("customize_" + attribute + "_text").text = str(value)
	else:
		get("customize_" + attribute + "_text").text = addDecimalToAttributeValueIfNeeded(value)
	get("customize_" + attribute + "_text").cursor_set_column(100)


func _on_color_pressed() -> void:
	gv.emit_signal("edit_save_color", get_node("sc/m/v/v/save info/m/v/color/m/ColorRect"))

func _on_confirm_difficulty_pressed() -> void:
	get_node("sc/m/v/v/difficulty/m/v/v").hide()
	get_node("sc/m/v/v/difficulty/m/v/flair").hide()
	get_node("sc/m/v/v/difficulty/m/v/confirm difficulty").hide()
	get_node("sc/m/v/v/difficulty/m/v/edit difficulty").show()
	get_node("sc/m/v/v/difficulty/m/v/text").text = "Difficulty: " + diff.getDifficultyText()

func _on_edit_difficulty_pressed() -> void:
	get_node("sc/m/v/v/difficulty/m/v/v").show()
	get_node("sc/m/v/v/difficulty/m/v/flair").show()
	get_node("sc/m/v/v/difficulty/m/v/confirm difficulty").show()
	get_node("sc/m/v/v/difficulty/m/v/edit difficulty").hide()
	get_node("sc/m/v/v/difficulty/m/v/text").text = "Difficulty"








func _on_begin_game_pressed() -> void:
	
	SaveManager.createSaveFile(_filename.text)
	
	var saveFileColor = get_node("sc/m/v/v/save info/m/v/color/m/ColorRect").self_modulate
	
	SaveManager.loadGame(_filename.text, saveFileColor)




