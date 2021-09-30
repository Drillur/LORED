extends MarginContainer

onready var rt = get_node("/root/Root")

onready var gn_done = get_node("done")
onready var gn_button = get_node("Button")
onready var gn_icon = get_node("m/h/icon/icon")
onready var gn_progress = get_node("progress")
onready var gn_progress_f = get_node("progress/f")
onready var gn_progress_flair = get_node("progress/f/flair")
onready var gn_quest_name = get_node("m/h/quest_name")

var wish: Wish

func _ready():
	set_physics_process(false)

func _on_Button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				turnIn()
			BUTTON_RIGHT:
				discard()

func _on_Button_mouse_exited() -> void:
	wish.clearTooltip()
	rt.get_node("global_tip")._call("no")

func _on_Button_mouse_entered() -> void:
	rt.get_node("global_tip")._call("wish tooltip", {"wish": wish})


func turnIn():

	if not wish.ready:
		return

	flyingTextIfComplete()

	wish.turnIn()

func discard():

	if not wish.random:
		if not gv.dev_mode:
			return
	if wish.ready:
		if not gv.dev_mode:
			return

	flyingTextIfDiscarded()

	wish.die()

	gv.r["grief"].a(1)
	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, "grief")

func flyingTextIfComplete():

	var amount: Big
	var icon_key: String
	var color_key: String

	var output_node: Node2D = gv.g[wish.giver].manager.get_node("texts")

	for r in wish.rew:

		if r.type != gv.WishReward.RESOURCE:
			continue

		amount = r.amount
		icon_key = r.key
		color_key = r.key

		flyingText(amount.toString(), gv.sprite[icon_key], gv.COLORS[color_key], output_node)

		var t = Timer.new()
		add_child(t)
		t.start(0.3)
		yield(t, "timeout")
		t.queue_free()

	flyingText("1", gv.sprite["joy"], gv.COLORS["joy"], output_node)

func flyingTextIfDiscarded():
	flyingText("1", gv.sprite["grief"], gv.COLORS["grief"], gv.g[wish.giver].manager.get_node("texts"))

func flyingText(amount: String, icon: Texture, color: Color, output_node: Node2D):

	var ft = gv.SRC["flying text"].instance()
	ft.init(true, 0, "+ " + amount, icon, color)

	ft.rect_position = Vector2(rect_size.x / 2, 160)
	output_node.add_child(ft)




func init(_wish: Wish) -> void:
	
	wish = _wish
	
	gn_progress_f.modulate = wish.color
	gn_done.self_modulate = wish.color

	gn_icon.set_texture(quest.icon)

	if not quest.random:
		rect_min_size.x = 170
		gn_quest_name.text = quest.name
		gn_quest_name.show()
		gn_quest_name.modulate = quest.color
		rect_size.y = 50
	else:
		taq.tasks.append(quest)

	var t = Timer.new()
	add_child(t)
	t.start(0.01)
	yield(t, "timeout")
	t.queue_free()

	rUpdate()

	quest.checkIfReady()

func ready():
	rUpdate_ready()
	if quest.random:
		taq.task_manager.ready_task_count += 1

func rUpdate():

	if quest.ready:
		return

	gn_progress_f.rect_size.x = quest.current_progress.percent(quest.total_progress) * gn_progress.rect_size.x

func rUpdate_ready():
	gn_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	gn_done.show()
	gn_button.show()
	gn_progress_f.rect_size.x = gn_progress.rect_size.x
	gn_progress_flair.hide()






