class_name RichTextLabelPrefab
extends RichTextLabel



@export var _text: String:
	set(val):
		text = val

var temp = 0



func h_shrink_begin() -> void:
	size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	
