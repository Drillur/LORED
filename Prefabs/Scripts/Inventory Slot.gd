extends MarginContainer

onready var rt = get_node("/root/Root")
var key: String

onready var gn_count = get_node("h/count")

func init(_key: String):
	
	key = _key
	
	# get_node("h/icon/Sprite").texture = 
	
	match key:
		"nearly dead":
			get_node("h/name").text = "Nearly-dead"
		_:
			get_node("h/name").text = key.capitalize()
	
	gn_count.text = "0"
	
	hide()


func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")

func _on_mask_mouse_entered() -> void:
	rt.get_node("global_tip")._call("item:" + key)


