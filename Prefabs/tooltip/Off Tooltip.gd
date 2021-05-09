extends MarginContainer



func init() -> void:
	
	$"v/header/v/time offline".text = $"v/header/v/time offline".text % gv.parse_time(gv.offline_time)
	
	if gv.off_locked:
		$"v/logic/lock".show()
		$"v/logic/haste".hide()
		$"v/logic/output".hide()
		$"v/logic/time extension".hide()
		$"v/pausable".hide()
		
		yield(self, "ready")
		
		var t = $Timer
		t.start(0.01)
		yield(t, "timeout")
		t.queue_free()
		
		rect_size = Vector2.ZERO
		return
	
	$"v/logic/output/ingredient net/flair".text = $"v/logic/output/ingredient net/flair".text % fval.f(gv.off_d)
	if gv.off_boost_time <= 3600:
		$"v/logic/time extension/ingredient net/flair".text = "Time Extension"
	else:
		$"v/logic/time extension/ingredient net/flair".text = $"v/logic/time extension/ingredient net/flair".text % gv.parse_time(gv.off_boost_time - 3600)
	
	$v/logic/output/dot.self_modulate = Color(0, 1, 0) if gv.off_d > 1.0 else Color(1, 0, 0)
	$"v/logic/time extension/dot".self_modulate = Color(0, 1, 0) if gv.off_d >= 10 else Color(1, 0, 0)
