extends Panel

onready var rt = get_node("/root/Root")

var step := {}
var rr := {}
var r := {}

var fps := 0.0


func init() -> void:
	
	var col = taq.quest.color
	self_modulate = col
	$done/text.add_color_override("font_color", Color(col.r, col.g, col.b, 1.25))
	$bar.modulate = col
	
	$icon.set_texture(taq.quest.icon)

func _physics_process(delta):
	
	if taq.quest.ready:
		if not $done.visible:
			$done.show()
		return
	
	fps += delta
	if fps > gv.fps:
		fps -= gv.fps
		
		get_node("bar").value = taq.quest.points.percent(taq.quest.total_points) * 100
		
		if taq.quest.ready:
			get_node("time").hide()
			get_node("done").show()
			get_node("view").hide()
	
#	# shake if done
#	while $done.visible:
#
#		time_since_last_shake += delta
#		if time_since_last_shake < 5: break
#		time_since_last_shake -= 5
#
#		w_shake_self()
#
#		break




func _on_button_down():
	rt.get_node("map").status = "no"

func _on_done_pressed():
	b_end_task()

func b_end_task() -> void:
	
	rt.save_fps = 0.0
	
	hide()
	
	rt.get_node("global_tip")._call("no")
	
	$done.hide()
	
	rt.quests[taq.quest.name].complete = true
	
	get_parent().quest_ended()
	
	queue_free()

func _on_task_mouse_entered():
	rt.get_node("global_tip")._call("taq quest " + str(taq.quest.key))#"quest " + taq.quest.name)
func _on_task_mouse_exited():
	rt.get_node("global_tip")._call("no")
