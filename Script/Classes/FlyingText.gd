class_name FlyingText
extends Resource



enum Type { CURRENCY, }
enum CurrencyKeys { collide, cur, text, }



var type: Type
var vicos := []
var rect: Rect2
var parent_node: Node
var duration: float
var collide: bool
var timer := Timer.new()



func _init(_type: Type, _base_node: Node, _parent_node: Node, _collide: bool):
	type = _type
	rect = _base_node.get_global_rect()
	parent_node = _parent_node
	collide = _collide
	match type:
		Type.CURRENCY:
			duration = 1.5
	gv.add_child(timer)
	timer.wait_time = 0.08
	timer.one_shot = false
	timer.timeout.connect(throw_text)
	
	gv.flying_texts.append(self)


func add(data: Dictionary) -> void:
	var vico = gv.flying_text.instantiate() as FlyingTextVico
	vicos.append(vico)
	vico.setup(collide)
	parent_node.add_child(vico)
	vico.global_position = Vector2(
		rect.position.x + randf_range(0, rect.size.x),
		rect.position.y + randf_range(0, rect.size.y)
	)
	vico.hide()
	
	match type:
		Type.CURRENCY:
			vico.setup_currency(data)



func go():
	timer.start()
	throw_text()


func throw_text() -> void:
	var vico = vicos.pop_front()
	vico.go(duration)
	if vicos.size() == 0:
		timer.stop()
		gv.flying_texts.erase(self)
