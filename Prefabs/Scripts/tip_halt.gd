extends MarginContainer

var lored_key: String

var src := {
	tip_lored_b = preload("res://Prefabs/tooltip/tip_lored_b.tscn"),
}
var cont := {}


func setup(_key):
	
	lored_key = _key
	
	r_update()


func _process(delta: float) -> void:
	
	rect_size = Vector2(0, 0)
	set_process(false)
	
	get_parent().r_tip(true)


func r_update():
	
	$v/halt.visible = gv.g[lored_key].halt
	
	set_process(true)
