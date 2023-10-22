extends MarginContainer



@onready var bar = %Bar
@onready var name_label = %Name
@onready var level = %Level
@onready var xp = %xp
@onready var max_xp = %"max xp"
@onready var background = $Background
@onready var texts = %Texts
@onready var tooltip_parent = %LeftDown
@onready var button = $Button



func _ready():
	hide()
	name_label.text = up.get_upgrade_name(Upgrade.Type.LIMIT_BREAK)
	update_level()
	update_lb_xp_cur()
	update_lb_xp_max()
	update_lb_colors()
	up.get_upgrade(Upgrade.Type.LIMIT_BREAK).purchase_finalized.became_true.connect(show)
	up.get_upgrade(Upgrade.Type.LIMIT_BREAK).purchase_finalized.became_false.connect(hide)
	bar.attach_attribute(up.limit_break.xp)
	button.mouse_entered.connect(show_tooltip)
	button.mouse_exited.connect(gv.clear_tooltip)


func update_level() -> void:
	level.text = "[b]x%s[/b]" % up.limit_break.level.text


func update_lb_xp_cur() -> void:
	xp.text = up.limit_break.xp.get_current_text()


func update_lb_xp_max() -> void:
	max_xp.text = up.limit_break.xp.get_total_text()


func update_lb_colors() -> void:
	level.modulate = up.limit_break.color
	bar.color = up.limit_break.color
	xp.modulate = up.limit_break.color
	background.modulate = up.limit_break.color
	max_xp.modulate = up.limit_break.next_color


func level_up() -> void:
	gv.flash(self, up.limit_break.color)
	
	if Engine.get_frames_per_second() >= 60:
		var text = FlyingText.new(
			FlyingText.Type.JUST_TEXT,
			texts,
			texts,
			[0, 0],
		)
		text.add({
			"color": up.limit_break.color,
			"text": "[b]x%s[/b]" % up.limit_break.level.text,
		})
		text.go()


func connect_calls() -> void:
	up.limit_break.xp.current.changed.connect(update_lb_xp_cur)
	up.limit_break.xp.total.changed.connect(update_lb_xp_max)
	up.limit_break.level.changed.connect(update_level)
	up.limit_break.level.changed.connect(update_lb_colors)
	up.limit_break.level.changed.connect(level_up)


func disconnect_calls() -> void:
	up.limit_break.xp.current.changed.disconnect(update_lb_xp_cur)
	up.limit_break.xp.total.changed.disconnect(update_lb_xp_max)
	up.limit_break.level.changed.disconnect(update_level)
	up.limit_break.level.changed.disconnect(update_lb_colors)
	up.limit_break.level.changed.disconnect(level_up)



# - Signal


func _on_button_pressed():
	gv.clear_tooltip()
	hide()


func show_tooltip() -> void:
	gv.new_tooltip(gv.Tooltip.UPGRADE_TOOLTIP, tooltip_parent, {"upgrade": up.get_upgrade(Upgrade.Type.LIMIT_BREAK)})


func _on_visibility_changed():
	if visible:
		connect_calls()
	else:
		disconnect_calls()

