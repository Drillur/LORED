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
@onready var top_center = %TopCenter

var wish: Wish



func _ready() -> void:
	_on_resized()


func _on_resized() -> void:
	if not is_node_ready():
		await ready
	right.position.x = size.x + 10



func setup(_wish: Wish) -> void:
	wish = _wish as Wish
	if not is_node_ready():
		await ready
	
	bar.remove_markers().remove_texts()
	bar.attach_attribute(wish.objective.progress)
	
	icon.texture = wish.get_icon()
	icon_shadow.texture = icon.texture
	
	var color = wish.get_color()
	bar.color = color
	objective_text.modulate = color
	ready_border.modulate = color
	
	
	update_objective_text()
	wish.objective.progress.add_notify_change_method(update_progress_text)
	button.connect("mouse_entered", show_tooltip)
	button.connect("mouse_exited", clear_tooltip)
	button.connect("pressed", turn_in)
	
	wish.vico = self
	
	await_ready()



# - Signal Shit


func clear_tooltip() -> void:
	gv.clear_tooltip()


func show_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.WISH, right, {"wish": wish})


func update_objective_text() -> void:
	objective_text.text = wish.objective.text


func update_progress_text() -> void:
	progress_text.text = wish.objective.progress.get_text()


func await_ready() -> void:
	if not wish.ready_to_turn_in:
		await wish.became_ready_to_turn_in
	ready_border.show()
	wish.objective.progress.remove_notify_method(update_progress_text)
	progress_text.text = "Complete!"



# - Actions

func turn_in() -> void:
	if wish.ready_to_turn_in or gv.dev_mode:
		gv.clear_tooltip()
		gv.throw_texts(top_center, wish.get_currency_rewards())
		wish.turn_in()
		queue_free()
	else:
		wish.flash_something()
