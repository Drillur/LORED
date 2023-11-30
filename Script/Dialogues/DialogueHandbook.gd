extends Node



const saved_vars := [
	"read_sections",
]

func load_finished() -> void:
	for title in read_sections:
		if not does_section_exist(title):
			read_sections.erase(title)
	if gv.dev_mode:
		print("Read sections: ", read_sections)

var section_titles := []
var read_sections := []
var current_section: String



func _ready() -> void:
	SaveManager.loading.became_false.connect(load_finished)
	DialogueManager.passed_title.connect(passed_title)
	for chat in res.chats.values():
		for section_title in chat.get_titles():
			if not section_title in section_titles:
				section_titles.append(section_title)


func passed_title(title: String) -> void:
	if current_section != "":
		mark_section_read(current_section)
	current_section = title



# - Action


func mark_section_read(section_title: String = current_section) -> String:
	# Only used in Dialogue scripts!
	if gv.dev_mode:
		if not section_titles.has(section_title):
			printerr("Section does not exist!")
		print("Section \"", section_title, "\" marked as read!")
	if not section_title in read_sections:
		read_sections.append(section_title)
	return ""



# - Get


func does_section_exist(section_title: String) -> bool:
	return section_title in section_titles


func get_coal_fuel() -> String:
	return lv.get_lored(LORED.Type.COAL).fuel_cost.get_text()


func is_section_read(section_title: String) -> bool:
	return section_title in read_sections


func is_iron_or_copper_unlocked() -> bool:
	return lv.is_lored_unlocked(LORED.Type.IRON) or lv.is_lored_unlocked(LORED.Type.COPPER)


func get_currency(currency_key: String) -> String:
	return wa.get_icon_and_name_text(Currency.Type[currency_key])


func get_lored(lored_key: String) -> String:
	return lv.get_colored_name(LORED.Type[lored_key])


func sections_read() -> int:
	return read_sections.size()


func get_current_year_text() -> String:
	return str(Time.get_datetime_dict_from_system().year)
