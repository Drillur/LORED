extends Node



const saved_vars := [
	"read_sections",
]

func load_finished() -> void:
	for title in read_sections:
		if not does_section_exist(title):
			read_sections.erase(title)

var section_titles := []
var read_sections := []



func _ready() -> void:
	SaveManager.loading.became_false.connect(load_finished)
	for chat in res.chats.values():
		print("TITLES: ", chat.titles)
		print("LINES: ", chat.lines)
		var sorted_titles: Array
		var raw_titles = chat.titles.duplicate()
		
		var sorted_lines: Array
		
		for section_title in chat.get_titles():
			if not section_title in section_titles:
				section_titles.append(section_title)
		var most_recent_title: String
		#print(chat.lines)
#		for line_id in chat.lines:
#			var line = chat.lines[line_id]
#			if line.type == chat._DialogueManager.DialogueConstants.TYPE_DIALOGUE:
#				#most_recent_title = line.text
#				#print("Title: ", most_recent_title)



# - Action


func mark_section_read(section_title: String) -> String:
	# Only used in Dialogue scripts!
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
