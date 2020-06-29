extends MarginContainer

onready var rt = get_node("/root/Root")

var lored : String

func _ready():
	$HBoxContainer/halt.hide()
	$HBoxContainer/held.hide()

func init(shit:Array, _lored:String):
	
	lored = _lored
	
	# color
	var color = rt.r_lored_color(lored)
	$HBoxContainer/held/content.self_modulate = color
	$HBoxContainer/halt/content.self_modulate = color
	$HBoxContainer/lored_name.self_modulate = color
	
	# text
	$HBoxContainer/lored_name.text = gv.g[lored].name
	
	w_update(shit)

func w_update(shit:Array):
	var node := [$HBoxContainer/halt, $HBoxContainer/held]
	for x in shit.size():
		if shit[x]: node[x].show()
		else: node[x].hide()

func _on_button_down():
	rt.get_node("map").status = "no"

func _on_halt_pressed():
	
#	if gv.g[lored].halt_auto_set:
#		# disable upgrade that set it to halt
#		pass
	
	gv.g[lored].halt = false
	$HBoxContainer/halt.hide()
	
	rt.get_node("map/loreds").lored[lored].r_update_halt(gv.g[lored].halt)
	
	if w_free_check(): queue_free()
func _on_held_pressed():
	
	gv.g[lored].hold = false
	$HBoxContainer/held.hide()
	
	rt.get_node("map/loreds").lored[lored].r_update_hold(gv.g[lored].hold)
	
	if w_free_check(): queue_free()

func w_free_check() -> bool:
	if gv.g[lored].halt: return false
	if gv.g[lored].hold: return false
	rt.instances["qol"]["held"].w_update(lored)
	return true


