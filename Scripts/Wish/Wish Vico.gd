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
var inLog: bool

func _ready():
	set_physics_process(false)
	hide()

func setup(_wish: Wish, _inLog := true) -> void:
	
	yield(self, "ready")
	
	wish = _wish
	
	wish.setVico(self)
	
	if wish.complete:
		gn_progress.hide()
	else:
		gn_progress_f.modulate = wish.color
	gn_done.self_modulate = wish.color
	
	gn_obj.text = wish.obj.parseObjective()
	if wish.key == "stuff":
		gn_obj.text = "Get Coal on the team! We need his stuff!"
	
	gn_icon.set_texture(gv.sprite[wish.obj.icon_key])
	gn_icon.get_node("shadow").texture = gn_icon.texture
	
	reset()
	
	if wish.obj.type == gv.Objective.LIMIT_BREAK_LEVEL:
		gv.connect("limit_break_leveled_up", self, "update_LIMIT_BREAK_LEVEL")
		update_LIMIT_BREAK_LEVEL()
	
	if not wish.obj.complete:
		update()
	
	wish.checkIfReady()
	
	if not wish.random:
		gn_main_wish.show()
		rect_min_size.x = 100
	
	if wish.complete:
		get_node("Button").mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	inLog = _inLog
	
	if not inLog:
		size_flags_horizontal = 0
	
	show()

func reset():
	complete = false
	gn_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	gn_done.hide()
	gn_progress_f.rect_size.x = 0
	gn_progress_flair.show()

func _on_Button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				if ready:
					turnIn()
				else:
					flashRequirements()
			BUTTON_RIGHT:
				if discard_prompted:
					discard()
				else:
					confirmDiscard()

func _on_Button_mouse_exited() -> void:
	wish.clearTooltip()
	rt.get_node("global_tip")._call("no")

func _on_Button_mouse_entered() -> void:
	rt.get_node("global_tip")._call("wish tooltip", {"wish": wish, "inLog": inLog})


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
	
	gv.addToResource(gv.Resource.GRIEF, 1)
	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.GRIEF))
	
	gv.stats["WishDenied"] += 1
	gv.emit_signal("statChanged", "WishDenied")
	
	var _stat: String = taq.getWishStat(wish.obj.type, wish.obj.key)
	gv.stats["WishStats"][_stat]["denied"] += 1
	gv.emit_signal("statChanged2", _stat, "denied")
	
	gv.stats["LOREDDenied"][int(wish.giver)] += 1
	gv.emit_signal("LOREDDenied", int(wish.giver))

func turnedInOrDiscarded():
	complete = true
	ready = false
	hide()

func flyingTextIfComplete():
	
	if not gv.option["flying_numbers"]:
		return
	
	var texts := []
	
	var mpos = get_global_mouse_position()
	var flyingTextPosition = Vector2(mpos.x + 5, mpos.y - 5)
	
	for r in wish.rew:
		
		if r.type != gv.WishReward.RESOURCE:
			continue
		
		var details := {}
		var shorthand = gv.shorthandByResource[int(r.key)]
		
		details["text"] = "+" + r.amount.toString()
		details["icon"] = gv.sprite[shorthand]
		details["color"] = gv.COLORS[shorthand]
		details["position"] = flyingTextPosition
		
		texts.append(details)
	
	texts.append({ # joy
		"text": "+1",
		"icon": gv.sprite["JOY"],
		"color": gv.COLORS["JOY"],
		"position": flyingTextPosition
	})
	
	rt.throwTexts(texts)

func flyingTextIfDiscarded():
	
	if not gv.option["flying_numbers"]:
		return
	var mpos = get_global_mouse_position()
	var flyingTextPosition = Vector2(mpos.x + 5, mpos.y - 5)
	
	rt.throwText({
		"text": "+1",
		"icon": gv.sprite["GRIEF"],
		"color": gv.COLORS["GRIEF"],
		"position": flyingTextPosition
	})



func ready():
	
	if ready:
		return
	
	if taq.automatedCompletion:
		if wish.random:
			turnIn()
			return
	
	if inLog:
		rt.wishNotice()
	
	ready = true
	show_behind_parent = false
	
	gn_progress_f.hide()
	#gn_progress_f.rect_size.x = gn_progress.rect_size.x
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
	
	updateProgress()
	
	gn_count.text = wish.obj.parseCount()
	
	var t = Timer.new()
	add_child(t)
	t.start(gv.fps)
	yield(t, "timeout")
	t.queue_free()
	
	recently_updated = false
	if update_queued:
		update()

func updateProgress():
	gn_progress_f.rect_size.x = min(wish.obj.current_count.percent(wish.obj.required_count) * gn_progress.rect_size.x, gn_progress.rect_size.x)



func flashRequirements():
	if wish.obj.type == gv.Objective.BREAK:
		var lored = wish.objKey()
		lv.lored[lored].flashSleep()


func _on_Wish_Vico_item_rect_changed() -> void:
	#updateProgress() doesnt work because who knows, life is unfair
	update()


func update_LIMIT_BREAK_LEVEL():
	wish.setCount(gv.up["Limit Break"].effects[0].effect.t)

