extends Node



const saved_vars := [
	"read_sections",
]

enum Section {
	what_is_fuel,
	why_is_fuel,
}


var read_sections := []



# - Action


func mark_section_read(section_key: String) -> void:
	var section: Section = Section[section_key]
	if not section in read_sections:
		read_sections.append(section)



# - Get


func get_coal_fuel() -> String:
	return lv.get_lored(LORED.Type.COAL).fuel_cost.get_text()


func is_section_read(section_key: String) -> bool:
	var section: Section = Section[section_key]
	return section in read_sections


func is_iron_or_copper_unlocked() -> bool:
	return lv.is_lored_unlocked(LORED.Type.IRON) or lv.is_lored_unlocked(LORED.Type.COPPER)
