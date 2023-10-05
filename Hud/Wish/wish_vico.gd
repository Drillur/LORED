class_name WishVico
extends MarginContainer



@onready var bar = %Bar as Bar
@onready var objective_text = %"Objective Text"
@onready var progress_text = %"Progress Text"
@onready var icon = %Icon
@onready var icon_shadow = %"Icon Shadow"
@onready var ready_border = $ready
@onready var button = %Button
@onready var right = %RightUp
@onready var dismiss_node = %Dismiss
@onready var ready_flash_timer = $"Ready Flash Timer"
@onready var right_down = $Control/RightDown
@onready var texts = %Texts
@onready var collision = %Collision

signal ended(wish, successful_completion)

var wish: Wish



func _ready() -> void:
	_on_resized()
	dismiss_node.hide()
	ready_flash_timer.timeout.connect(ready_flash)
	tree_exited.connect(die)


func _on_resized() -> void:
	if not is_node_ready():
		await ready
	right.position.x = size.x + 10
	collision.position.x = size.x / 2
	collision.shape.size.x = size.x



func setup(_wish: Wish) -> void:
	wish = _wish as Wish
	if not is_node_ready():
		await ready
	
	bar.attach_attribute(wish.objective.progress)
	
	icon.texture = wish.get_icon()
	icon_shadow.texture = icon.texture
	
	var color = wish.get_color()
	bar.color = color
	objective_text.modulate = color
	ready_border.modulate = color
	
	
	update_objective_text()
	wish.objective.progress.connect("changed", update_progress_text)
	button.connect("mouse_entered", show_tooltip)
	button.connect("mouse_exited", gv.clear_tooltip)
	button.connect("gui_input", button_input)
	
	update_progress_text()
	
	wish.vico = self
	
	gv.flash(self, wish.objective.color)
	
	if not wish.ready_to_turn_in:
		wish.became_ready_to_turn_in.connect(wish_is_ready)
	else:
		wish_is_ready()
	
	if gv.node_has_point(self, get_global_mouse_position()):
		show_tooltip()



# - Signal Shit


func show_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.WISH, right, {"wish": wish})


func update_objective_text() -> void:
	objective_text.text = wish.objective.text


func update_progress_text() -> void:
	progress_text.text = wish.objective.progress.get_text()


func wish_is_ready() -> void:
	ready_border.show()
	wish.objective.progress.disconnect("changed", update_progress_text)
	progress_text.text = "Complete!"
	ready_flash_timer.start()
	ready_flash()


func ready_flash() -> void:
	gv.flash(self, wish.objective.color)



# - Actions

func button_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			turn_in()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			dismiss()


func turn_in() -> void:
	if wish.ready_to_turn_in or gv.dev_mode:
		gv.clear_tooltip()
		
		var cur_rew = wish.get_currency_rewards()
		var text = FlyingText.new(
			FlyingText.Type.CURRENCY,
			texts, # node used to determine text locations
			gv.texts_parent, # node that will hold texts
			[1, 1], # collision
			[randf_range(-0.1, 0.1), -0.08, -0.12]
		)
		for cur in cur_rew:
			text.add({
				"cur": cur,
				"text": "+" + cur_rew[cur].text,
				"crit": false,
			})
		text.go(10)
		
		wish.turn_in()
		queue_free()
	else:
		wish.flash_something()


func dismiss() -> void:
	if wish.is_main_wish():
		return
	if wish.ready_to_turn_in:
		return
	
	if dismiss_node.visible:
		gv.clear_tooltip()
		var cur_rew = wish.get_dismissal_currencies()
		var text = FlyingText.new(
			FlyingText.Type.CURRENCY,
			texts, # node used to determine text locations
			gv.texts_parent, # node that will hold texts
			[1, 1], # collision
		)
		for cur in cur_rew:
			text.add({
				"cur": cur,
				"text": "-" + cur_rew[cur].text,
				"crit": false,
			})
		text.go(10)
		
		wish.dismiss()
		queue_free()
	else:
		dismiss_node.show()
		await get_tree().create_timer(2).timeout
		dismiss_node.hide()


func die() -> void:
	ended.emit(wish)
