extends MarginContainer


onready var rt = get_node("/root/Root")
onready var text = get_node("m/h/text")
onready var count = get_node("m/h/count")
onready var current = get_node("bar/f")
onready var flair = get_node("bar/f/flair")
onready var required = get_node("bar")
onready var bg2 = get_node("bg2")
onready var button = get_node("Button")
onready var output = get_node("output")

var wish: Wish
var type: int
var key: String

var ready := false

var update_queued := false
var recently_updated := false

func setup(wish: Wish, vico: MarginContainer):
	
	type = wish.obj.type
	key = wish.obj.key
	wish.setVico(vico)
	
	flair.modulate = wish.color
	bg2.modulate = wish.color
	
	match type:
		gv.Objective.RESOURCES_PRODUCED:
			if gv.isStage1Or2LORED(key):
				text.text = "Collect " + gv.g[key].name
			else:
				text.text = "Collect " + gv.r_name[key]
		gv.Objective.LORED_UPGRADED:
			text.text = "Upgrade " + gv.g[key].name
		gv.Objective.UPGRADE_PURCHASED: #note limit of 25 characters
			text.text = "Purchase " + gv.up[key].name
		gv.Objective.MAXED_FUEL_STORAGE:
			text.text = gv.g[key].name + " max fuel"
		gv.Objective.BREAK:
			text.text = "Relax"
		gv.Objective.HOARD:
			text.text = "Hoard!"
	
	reset()
	
	if not wish.obj.complete:
		update()
	
	show()
	
	wish.checkIfReady()

func reset():
	ready = false
	button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	current.rect_size.x = 0
	bg2.hide()
	show_behind_parent = true

func update():
	
	if ready:
		return
	
	if recently_updated:
		update_queued = true
		return
	
	recently_updated = true
	update_queued = false
	
	current.rect_size.x = min(wish.obj.current_count.percent(wish.obj.required_count) * required.rect_size.x, required.rect_size.x)
	count.text = wish.obj.parse()
	
	var t = Timer.new()
	add_child(t)
	t.start(gv.fps)
	yield(t, "timeout")
	t.queue_free()
	
	recently_updated = false
	if update_queued:
		update()

func ready():
	ready = true
	current.rect_size.x = required.rect_size.x
	count.text = wish.obj.parse()
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	show_behind_parent = false
	bg2.show()
	# start SPARKLE timer. every 5 sec, sparkle/flash/glow etc



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



func _on_Button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				print(wish.obj.key)
				turnIn()
			BUTTON_RIGHT:
				discard()

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

func _on_Button_mouse_exited() -> void:
	wish.clearTooltip()
	rt.get_node("global_tip")._call("no")

func _on_Button_mouse_entered() -> void:
	rt.get_node("global_tip")._call("wish tooltip", {"wish": wish})

