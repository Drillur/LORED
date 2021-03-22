extends MarginContainer

onready var rt = get_node("/root/Root")

var lored_key: String

var src := {
	tip_lored_b = preload("res://Prefabs/tooltip/tip_lored_b.tscn"),
}
var cont := {}


func setup(_key):
	
	lored_key = _key
	
	used_by()
	
	r_update()

func used_by():
	
	if gv.g[lored_key].used_by.size() == 0:
		return
	
	$v/used_by.show()
	$v/used_by/bg.self_modulate = gv.g[lored_key].color
	
	var i = 0
	for x in gv.g[lored_key].used_by:
		
		if not gv.g[x].active:
			continue
		
		var per_sec = Big.new(gv.g[x].d.t).d(gv.g[x].speed.t)
		
		cont[x] = src.tip_lored_b.instance()
		cont[x].setup_used_by(lored_key, x, per_sec, gv.g[x].color)
		$v/used_by/v.add_child(cont[x])
		
		if i % 2 == 0:
			cont[x].get_node("bg").hide()
		
		i += 1
	
	if cont.size() == 0:
		$v/used_by.hide()



func _process(delta: float) -> void:
	
	rect_size = Vector2(0, 0)
	set_process(false)
	
	get_parent().r_tip(true)


func r_update():
	
	set_process(true)
	
	$v/hold.visible = gv.g[lored_key].hold
