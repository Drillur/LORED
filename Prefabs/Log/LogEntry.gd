extends MarginContainer


onready var rt = get_node("/root/Root")

var type: int
var info: String
var data: Dictionary
var color: Color

func setup(_type: int, _info: String):
	type = _type
	info = _info
	data = str2var(_info)
	call(LogManager.Type.keys()[type])

func LEVEL_UP():
	
	get_node("%" + LogManager.Type.keys()[type]).show()
	get_node("%" + LogManager.Type.keys()[type]).self_modulate = data["color"]
	
	get_node("%icon").texture = data["icon"]
	get_node("%icon/shadow").texture = get_node("%icon").texture
	get_node("%border").self_modulate = data["color"]

func OFFLINE_EARNINGS():
	
	get_node("%" + LogManager.Type.keys()[type]).show()
	get_node("%main").hide()
	color = Color(0.341176, 0.619608, 0.980392)
	get_node("%border").self_modulate = color


func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")
func _on_mouse_entered() -> void:
	get_node("%border").hide()
	rt.get_node("global_tip")._call("tooltip/log", {"type": type, "info": info, "color": color})
