class_name Details
extends RefCounted



var name: String:
	set(val):
		if name != val:
			name = val
			if name.ends_with("y"):
				plural_name = name.rsplit("y")[0] + "ies"
			else:
				plural_name = name + "s"
			colored_plural_name = plural_name
var alt_name: String
var description: String

var plural_name: String
var colored_plural_name: String

var color: Color:
	set(val):
		color = val
		color_text = "[color=#" + val.to_html() + "]%s[/color]"
		colored_name = color_text % name
		colored_plural_name = color_text % plural_name
		if icon_text != "":
			icon_and_colored_name = icon_text + " " + colored_name
			icon_and_colored_plural_name = icon_text + " " + colored_plural_name
		alt_color = color
var color_text: String
var colored_name: String
var colored_alt_name: String

var alt_color: Color:
	set(val):
		alt_color = val
		alt_color_text = "[color=#" + val.to_html() + "]%s[/color]"
		alt_colored_name = alt_color_text % name
		if icon_text != "":
			icon_and_alt_colored_name = icon_text + " " + alt_colored_name
var alt_color_text: String
var alt_colored_name: String


var icon: Texture:
	set(val):
		icon = val
		icon_text = "[img=<15>]" + val.get_path() + "[/img]"
		icon_and_name_text = icon_text + " " + name
		if colored_name != "":
			icon_and_colored_name = icon_text + " " + colored_name
			if plural_name != "":
				icon_and_colored_plural_name = icon_text + " " + plural_name
		if alt_colored_name != "":
			icon_and_alt_colored_name = icon_text + " " + alt_colored_name
var icon_text: String
var icon_and_name_text: String

var icon_and_colored_name: String
var icon_and_alt_colored_name: String
var icon_and_colored_plural_name: String



# - Actions

func set_title(val: String) -> void:
	alt_name = val
	colored_alt_name = color_text % alt_name


func set_nickname(val: String) -> void:
	set_title(val)



# - Get

func get_title() -> String:
	return alt_name


func get_nickname() -> String:
	return alt_name


func get_name(count = 1) -> String:
	if count_equals_one(count):
		return name
	return plural_name


func get_colored_name(count = 1) -> String:
	if color == Color.BLACK:
		return get_name(count)
	if count_equals_one(count):
		return colored_name
	return colored_plural_name


func get_icon_and_name(count = 1) -> String:
	if count_equals_one(count):
		return icon_text + " " + name
	return icon_text + " " + plural_name


func get_icon_and_colored_name(count = 1) -> String:
	if color == Color.BLACK:
		return get_icon_and_name(count)
	if count_equals_one(count):
		return icon_text + " " + colored_name
	return icon_text + " " + colored_plural_name


func count_equals_one(count) -> bool:
	if count is Big:
		return count.equal(1)
	return is_equal_approx(count, 1)
