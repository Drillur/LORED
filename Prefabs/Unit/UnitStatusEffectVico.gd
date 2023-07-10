extends MarginContainer



onready var _name: Label = $"%name"
onready var ticks_remaining: Label = $"%ticks remaining"
onready var total_ticks: Label = $"%total ticks"
onready var progress: Panel = $"%progress"
onready var description: RichTextLabel = $"%description"

var buff: UnitStatusEffect



func setup(_buff: UnitStatusEffect) -> void:
	buff = _buff
	
	yield(self, "ready")
	
	setup_color()
	
	buff.assign_vico(self)
	
	_name.text = buff.name
	description.bbcode_text = buff.get_active_description()
	
	if buff.unlimited_ticks:
		$"%tick text".hide()
		update_progress()
		update_loop()
		return
	
	total_ticks.text = "/" + buff.ticks.get_total_text()
	update_all()
	update_loop()


func setup_color() -> void:
	set_color(buff.vico_color)


func set_color(color: Color) -> void:
	progress.modulate = color
	ticks_remaining.modulate = color



func unassign_vico() -> void:
	buff.unassign_vico()


func kill() -> void:
	get_node("/root/Root/global_tip").tip.cont.unassign_vico(self)
	queue_free()




func update_all() -> void:
	update_progress()
	update_tick_text()


func update_loop() -> void:
	var t = Timer.new()
	add_child(t)
	while not is_queued_for_deletion():
		t.start(gv.fps)
		yield(t, "timeout")
		
		update_progress()
	
	t.queue_free()


func update_progress() -> void:
	progress.rect_size.x = min((1 - buff.get_tick_percent()) * rect_size.x, rect_size.x)


func update() -> void:
	# called by Attribute.gd
	update_tick_text()


func update_tick_text() -> void:
	ticks_remaining.text = buff.ticks.get_deficit_text_plus_one()
