extends TextureProgress



onready var deficit: Label = $deficit

var buff: UnitStatusEffect



func setup(_buff: UnitStatusEffect) -> void:
	buff = _buff
	yield(self, "ready")
	update()
	update_loop()
	set_colors()
	if buff.unlimited_ticks:
		deficit.hide()
		return


func set_colors() -> void:
	var color = buff.vico_color
	self_modulate = color




func update_loop() -> void:
	var t = Timer.new()
	add_child(t)
	while not is_queued_for_deletion():
		if buff.marked_for_removal:
			break
		t.start(gv.fps)
		yield(t, "timeout")
		
		update_progress()
	
	t.queue_free()
	kill()


func update() -> void:
	update_progress()
	update_text()


func update_progress() -> void:
	value = (1 - buff.get_tick_percent()) * 100


func update_text() -> void:
	if buff.unlimited_ticks:
		return
	deficit.text = Big.new(buff.ticks.get_current_text()).s(1).toString()
	if deficit.text == "0":
		deficit.hide()
	else:
		deficit.show()



func kill() -> void:
	if get_parent().get_child_count() == 1:
		get_parent().hide()
	queue_free()
