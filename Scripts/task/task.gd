extends MarginContainer

onready var rt = get_node("/root/Root")

onready var gn_done = get_node("done")
onready var gn_button = get_node("Button")
onready var gn_icon = get_node("m/h/icon/icon")
onready var gn_progress = get_node("progress")
onready var gn_progress_f = get_node("progress/f")
onready var gn_progress_flair = get_node("progress/f/flair")
onready var gn_quest_name = get_node("m/h/quest_name")

var task: Task

func _ready():
	set_physics_process(false)

func _on_Button_pressed(manual: bool) -> void:
	task.attempt_turn_in(manual)

func _on_Button_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")
func _on_Button_mouse_entered() -> void:
	if task.random:
		rt.get_node("global_tip")._call("taq ", {"task": task})
	else:
		rt.get_node("global_tip")._call("taq quest " + str(taq.quest.key))#"quest " + taq.quest.name)

func init(_task: Task) -> void:
	
	task = _task
	task.manager = self
	
	gn_progress_f.modulate = task.color
	gn_done.self_modulate = task.color
	
	gn_icon.set_texture(task.icon)
	
	if not task.random:
		rect_min_size.x = 170
		gn_quest_name.text = task.name
		gn_quest_name.show()
		gn_quest_name.modulate = task.color
	
	var t = Timer.new()
	add_child(t)
	t.start(0.01)
	yield(t, "timeout")
	t.queue_free()
	
	r_update()

func ready():
	gn_done.show()
	gn_button.show()
	gn_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	gn_progress_f.rect_size.x = gn_progress.rect_size.x
	gn_progress_flair.hide()
	if task.random:
		taq.task_manager.ready_task_count += 1

func r_update():
	
	if task.ready:
		return
	
	gn_progress_f.rect_size.x = task.points.percent(task.total_points) * gn_progress.rect_size.x


func _on_button_down():
	rt.get_node("map").status = "no"

func _on_done_pressed():
	b_end_task()

func b_end_task() -> void:
	
	rt.quests[taq.quest.name].complete = true
	
	get_parent().quest_ended()
	
	queue_free()




