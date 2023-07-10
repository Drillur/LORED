class_name Save
extends Resource

export var loreds: Dictionary = bag_lored.lored

func save_now() -> void:
	ResourceSaver.save("user://ResourceSaver Test.tres", self)
