extends MarginContainer

onready var rt = get_node("/root/Root")

onready var gn_done = get_node("done")
onready var gn_button = get_node("Button")
onready var gn_icon = get_node("m/h/icon/icon")
onready var gn_progress = get_node("progress")
onready var gn_progress_f = get_node("progress/f")
onready var gn_progress_flair = get_node("progress/f/flair")
onready var gn_obj = get_node("m/h/v/objective")
onready var gn_count = get_node("m/h/v/count")
onready var gn_main_wish = get_node("main_wish")
onready var gn_confirm_deny = get_node("confirm deny")

var wish: Wish
var ready := false
var complete := false

var update_queued := false
var recently_updated := false

var discard_prompted := false

func _ready():
	set_physics_process(false)
	hide()

func setup(_wish: Wish) -> void:
	
	yield(self, "ready")
	
	wish = _wish
	
	wish.setVico(self)
	
	gn_progress_f.modulate = wish.color
	gn_done.self_modulate = wish.color
	
	gn_obj.text = wish.obj.parseObjective()
	
	gn_icon.set_texture(gv.sprite[wish.obj.icon_key])
	
	reset()
	
	if not wish.obj.complete:
		update()
	
	wish.checkIfReady()
	
	if not wish.random:
		gn_main_wish.show()
		rect_min_size.x = 100
	
	show()

func reset():
	complete = false
	gn_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	gn_progress_f.rect_size.x = 0
	gn_done.hide()
	gn_progress_flair.show()

func _on_Button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				turnIn()
			BUTTON_RIGHT:
				if discard_prompted:
					discard()
				else:
					confirmDiscard()

func _on_Button_mouse_exited() -> void:
	wish.clearTooltip()
	rt.get_node("global_tip")._call("no")

func _on_Button_mouse_entered() -> void:
	rt.get_node("global_tip")._call("wish tooltip", {"wish": wish})


func turnIn():
	
	if not ready:
		return
	
	flyingTextIfComplete()
	turnedInOrDiscarded()
	
	wish.turnIn()

func confirmDiscard():
	
	if not wish.random:
		if not gv.dev_mode:
			return
	if ready:
		if not gv.dev_mode:
			return
	
	discard_prompted = true
	gn_confirm_deny.show()
	
	var t = Timer.new()
	add_child(t)
	t.start(2)
	yield(t, "timeout")
	t.queue_free()
	
	discard_prompted = false
	gn_confirm_deny.hide()

func discard():
	
	flyingTextIfDiscarded()
	turnedInOrDiscarded()
	
	wish.die()
	
	gv.r["grief"].a(1)
	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, "grief")

func turnedInOrDiscarded():
	complete = true
	ready = false
	hide()

func flyingTextIfComplete():

	var amount: Big
	var icon_key: String
	var color_key: String

	for r in wish.rew:

		if r.type != gv.WishReward.RESOURCE:
			continue

		amount = r.amount
		icon_key = r.key
		color_key = r.key

		flyingText(amount.toString(), gv.sprite[icon_key], gv.COLORS[color_key])

		var t = Timer.new()
		add_child(t)
		t.start(0.3)
		yield(t, "timeout")
		t.queue_free()

	flyingText("1", gv.sprite["joy"], gv.COLORS["joy"])

func flyingTextIfDiscarded():
	flyingText("1", gv.sprite["grief"], gv.COLORS["grief"])

func flyingText(amount: String, icon: Texture, color: Color):
	
	var ft = gv.SRC["flying text"].instance()
	
	ft.init({"text": "+ " + amount, "icon": icon, "color": color, "life": 10})
	
	ft.rect_position = Vector2(rect_size.x / 2, rect_global_position.y - get_viewport_rect().size.y)
	rt.get_node("WishAnchor").add_child(ft)




func ready():
	
	if ready:
		return
	
	ready = true
	show_behind_parent = false
	
	gn_progress_f.rect_size.x = gn_progress.rect_size.x
	gn_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	gn_count.text = wish.obj.parseCount()
	
	gn_done.show()
	gn_progress_flair.hide()

func update():
	
	if ready:
		return
	
	if recently_updated:
		update_queued = true
		return
	
	recently_updated = true
	update_queued = false
	
	gn_progress_f.rect_size.x = min(wish.obj.current_count.percent(wish.obj.required_count) * gn_progress.rect_size.x, gn_progress.rect_size.x)
	
	gn_count.text = wish.obj.parseCount()
	if gn_count.text == "0/1":
		print("count = 0/1")
	
	var t = Timer.new()
	add_child(t)
	t.start(gv.fps)
	yield(t, "timeout")
	t.queue_free()
	
	recently_updated = false
	if update_queued:
		update()

