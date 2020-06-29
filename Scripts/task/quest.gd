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
	
	if taq.quest.name == "Menu!":
		if rt.get_node("misc/menu").visible:
			taq.quest.step["Menu opened"].f = 1.0
		if rt.get_node("misc/menu/ScrollContainer/MarginContainer/VBoxContainer/options").visible:
			taq.quest.step["Options tab opened"].f = 1.0
		if rt.get_node("misc/qol_displays/resource_bar").visible:
			taq.quest.step["Resource bar displayed"].f = 1.0
	
	fps += delta
	if fps > rt.FPS:
		fps -= rt.FPS
		
		var points := 0.0
		for x in taq.quest.step:
			points += taq.quest.step[x].f
		points = min(points, taq.quest.total_points)
		
		get_node("bar").value = points / taq.quest.total_points * 100
		
		if points >= taq.quest.total_points * .9995:
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
	
	if taq.quest.step.size() == 1 and " produced" in taq.quest.step.keys()[0]:
		var remaining_amount : float = taq.quest.step.values()[0].t - taq.quest.step.values()[0].f
		var gg = rt.w_name_to_short(taq.quest.step.keys()[0].split(" produced")[0])
		var per_sec = gv.g[gg].net(true)
		var intermittent := 1.0
		if not gv.g[gg].progress.t == 0.0:
			intermittent = gv.g[gg].d.t * (gv.g[gg].progress.f / gv.g[gg].progress.t)
		var final := 1.0
		if not per_sec == 0.0:
			final = (remaining_amount - intermittent) / per_sec
		else:
			return "!?"
		if final > 3600 * 24 * 365:
			var days:= int(final /60 / 60 / 24 / 365)
			return fval.f(days) + "y"
		if final > 3600 * 24:
			var days:= int(final /60 / 60 / 24)
			return str(days) + "d"
		if final > 3600:
			var hours := int(final / 60 / 60)
			return str(hours) + "h"
		if final > 60:
			var minutes := int(final / 60)
			#var sec := int(final - (minutes * 60))
			return str(minutes) + "m"# " + str(sec) + "s"
		if final >= 1:
			return String(int(final)) + "s"
		if not taq.quest.step.values()[0].f >= taq.quest.step.values()[0].t:
			return "!"
	
	return ""




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
	
	# quest complete
	for x in taq.quest.reward:
		if "free lored lv" in x:
			var f = x.split(" lv ")[1]
			gv.g[f].level += 1
			gv.g[f].output_modifier.b *= 2
			gv.g[f].fc.b *= 2
			gv.g[f].f.b *= 2
			rt.w_aa_lored(gv.g[f])
			match gv.g[f].type[1]:
				"1": gv.g[f].cost_modifier.b *= rt.up["upgrade_name"].d
				"2": gv.g[f].cost_modifier.b *= 3
			if gv.g[f].short == "coal" and gv.g[f].f.f < gv.g[f].speed.t * gv.g[f].fc.t * 2:
				gv.g[f].f.f += gv.g[f].speed.t * gv.g[f].fc.t * 2
			rt.w_aa_lored(gv.g[f])
	
	get_parent().quest_ended()
	
	queue_free()

func _on_task_mouse_entered():
	rt.get_node("global_tip")._call("taq " + taq.quest.name)#"quest " + taq.quest.name)
func _on_task_mouse_exited():
	rt.get_node("global_tip")._call("no")
