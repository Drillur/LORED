extends MarginContainer



onready var title = get_node("%title")
onready var description = get_node("%description")
onready var duration = get_node("%duration")

onready var progress = get_node("%current")

var buff: Buff



func _ready() -> void:
	BuffManager.connect("update_description", self, "update_description")



func _on_resized() -> void:
	progress.rect_size.y = rect_size.y



func setup(_buff: Buff):
	
	buff = _buff
	
	yield(self, "ready")
	
	title.text = buff.name
	description.bbcode_text = format_description(buff)
	duration.text = "Infinite duration" if buff.max_ticks == -1 else fval.f(buff.tick_rate * buff.max_ticks) + " sec"
	
	progress.modulate = buff.color
	
	loop(buff)


func update_description(lored: int, buff_type: int):
	
	if buff.lored != lored:
		return
	if buff.type != buff_type:
		return
	
	description.bbcode_text = format_description(buff)


func format_description(buff: Buff) -> String:
	
	var description = "[fill]" + buff.description.format({"tick_rate": fval.f(buff.tick_rate)})
	
	return description



func loop(buff: Buff):
	
	var timer = Timer.new()
	add_child(timer)
	
	while not is_queued_for_deletion():
		
		set_progress(buff)
		
		timer.start(gv.fps)
		yield(timer, "timeout")
		
		if buff.queued_for_removal:
			hide()
			queue_free()
			return
	
	timer.queue_free()


func set_progress(buff: Buff):
	
	var i = OS.get_ticks_msec() - buff.last_tick
	
	progress.rect_size.x = min(i / (buff.tick_rate * 1000) * rect_size.x, rect_size.x)






