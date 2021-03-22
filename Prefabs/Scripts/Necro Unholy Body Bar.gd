extends Panel

onready var gn := {
	bar = get_node("f"),
}

var init_complete := false
var unit: Unholy_Body

func _ready() -> void:
	
	_update()

func init(_unit: Unholy_Body):
	
	unit = _unit
	init_complete = true

func _update():
	
	if not init_complete:
		return
	
	while true:
		
		if not rect_size.x == 2:
			gn.bar.rect_size.x = min(unit.life / 60 * rect_size.x, rect_size.x)
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()

func _on_resized() -> void:
	
	if not init_complete:
		return
	
	gn.bar.rect_size.x = min(unit.life / 60 * rect_size.x, rect_size.x)
