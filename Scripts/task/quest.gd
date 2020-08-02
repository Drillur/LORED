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
	$time.add_color_override("font_color", col)
	
	$icon.set_texture(taq.quest.icon.texture)
	
	rt.w_task_progress_check()

func _physics_process(delta):
	
	if $bar.value == 100:
		if not $done.visible:
			$done.show()
		return
	
	fps += delta
	if fps > rt.FPS:
		fps -= rt.FPS
		
		var points: Big = Big.new(0)
		
		for x in taq.quest.step:
			if typeof(taq.quest.step[x].f) == TYPE_NIL:
				taq.quest.step[x].f = Big.new(0)
			points.a(taq.quest.step[x].f)
		points = Big.new(Big.min(points, taq.quest.total_points))
		
		get_node("bar").value = points.percent(taq.quest.total_points) * 100
		
		if points.isLargerThanOrEqualTo(Big.new(taq.quest.total_points).m(0.9995)):
			get_node("time").hide()
			get_node("done").show()
			get_node("view").hide()
		
		$time.text = w_get_time_remaining()
	
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

func w_get_time_remaining() -> String:
	
	if "Combined resources produced" in taq.quest.step.keys() or "Combined Stage 2 resources produced" in taq.quest.step.keys():
		return ""
	if not (taq.quest.step.size() == 1 and " produced" in taq.quest.step.keys()[0]):
		return ""
	
	var gg = rt.w_name_to_short(taq.quest.step.keys()[0].split(" produced")[0])
	return gv.time_remaining(gg, taq.quest.step.values()[0].f, taq.quest.step.values()[0].t, true)




func _on_button_down():
	rt.get_node("map").status = "no"

func _on_done_pressed():
	b_end_task()

func b_end_task() -> void:
	
	rt.save_fps = 0.0
	
	hide()
	
	rt.get_node("global_tip")._call("no")
	
	$done.hide()
	rt.tasks[taq.quest.name].complete = true
	
	randomize()
	
	get_parent().quest_ended()
	
	queue_free()

func _on_task_mouse_entered():
	rt.get_node("global_tip")._call("taq " + taq.quest.name)#"quest " + taq.quest.name)
func _on_task_mouse_exited():
	rt.get_node("global_tip")._call("no")
