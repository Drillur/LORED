class_name LimitBreak
extends Resource



const saved_vars := [
	"total_xp",
	"level",
	"affected_stages",
]

func load_finished() -> void:
	up.get_upgrade(Upgrade.Type.LIMIT_BREAK).update_effected_loreds_text()
	if enabled.is_true():
		apply()

const COLORS := {
	0: Color(0.121569, 0.819608, 0.376471),
	1: Color(0.156433, 0.910156, 0.85716),
	2: Color(0.020966, 0.607893, 0.894531),
	3: Color(0.398941, 0.569263, 0.972656),
	4: Color(0.374929, 0.340576, 0.96875),
	5: Color(0.449463, 0.199219, 1),
	6: Color(0.54937, 0.123367, 0.902344),
	7: Color(0.828125, 0, 1),
	8: Color(1, 0, 0),
	9: Color(1, 0.375, 0),
	10: Color(0.824219, 0.579529, 0),
	11: Color(1, 0.855957, 0.078125),
	12: Color(1, 1, 0.372549),
	13: Color(0.812012, 1, 0.140625),
	14: Color(0, 1, 0),
}

var cached_xp_required := {}

var stupid_msg_printed := false
var applied := false
var enabled := LoudBool.new(false)
var total_xp := ValuePair.new(1)
var xp := ValuePair.new(1)
var level := LoudInt.new(1)
var affected_stages := [1, 2,]
var color: Color
var next_color: Color



func _init() -> void:
	set_colors()
	
	#var d = Time.get_unix_time_from_system()
	var total_xp_so_far = Big.new(0)
	for i in range(1, 3001): # 0.234 seconds
		total_xp_so_far.a(calculate_required_xp(i))
		cached_xp_required[i] = Big.new(total_xp_so_far)
	
	#print("XP Cached in %s secs" % str(Time.get_unix_time_from_system() - d))
	
	total_xp.total.set_to(get_required_xp(1))
	total_xp.set_to(0)
	total_xp.do_not_cap_current()
	total_xp.current.increased.connect(level_up_check)
	total_xp.total.changed.connect(update_visual_xp)
	
	xp.total.set_to(total_xp.get_total())
	xp.set_to(0)
	xp.do_not_cap_current()
	
	level.changed.connect(level_up)
	
	enabled.became_true.connect(connect_calls)
	enabled.became_false.connect(disconnect_calls)
	
	SaveManager.load_finished.connect(load_finished)
	SaveManager.load_started.connect(disable)



# - Action


func enable() -> void:
	if enabled.is_false():
		apply()
		enabled.set_to(true)


func disable() -> void:
	if enabled.is_true():
		remove()
		enabled.set_to(false)


func apply() -> void:
	applied = true
	for stage in affected_stages:
		for lored_type in gv.get_loreds_in_stage(stage):
			var lored = lv.get_lored(lored_type) as LORED
			lored.output.enable_limit_break()
			lored.input.enable_limit_break()


func remove() -> void:
	applied = false
	for stage in affected_stages:
		for lored_type in gv.get_loreds_in_stage(stage):
			var lored = lv.get_lored(lored_type) as LORED
			lored.output.disable_limit_break()
			lored.input.disable_limit_break()


func connect_calls() -> void:
	for currency in wa.currency.values():
		if currency.increased_by_lored.is_connected(add_xp):
			printerr("Limit Break was already connected!")
			return
		currency.increased_by_lored.connect(add_xp)
		currency.increased_by_buff.connect(add_xp)


func disconnect_calls() -> void:
	for currency in wa.currency.values():
		if not currency.increased_by_lored.is_connected(add_xp):
			printerr("Limit Break wasn't connected!")
			return
		currency.increased_by_lored.disconnect(add_xp)
		currency.increased_by_buff.disconnect(add_xp)


func add_xp(amount: Big) -> void:
	xp.add(amount)
	total_xp.add(amount)


func level_up_check() -> void:
	if total_xp.is_not_full():
		return
	
	var left := level.get_value()
	var mid := 0
	var right := 3000
	while left < right:
		mid = left + (right - left) / 2
		if get_required_xp(mid).less_equal(total_xp.get_value()):
			left = mid + 1
		else:
			right = mid
	
	var gained_levels = left - level.get_value()
	if gained_levels > 0:
		level.add(gained_levels)
		total_xp.total.set_to(
			get_required_xp(level.get_value())
		)


func update_visual_xp() -> void:
	var new_total_xp = Big.new(get_required_xp(level.get_value()))
	var new_xp = Big.new(total_xp.get_current())
	if level.greater(1):
		new_total_xp.s(get_required_xp(level.get_value() - 1))
		new_xp.s(get_required_xp(level.get_value() - 1))
	new_total_xp.round_up_tens()
	xp.total.set_to(new_total_xp)
	xp.set_to(new_xp)


func level_up() -> void:
	set_colors()


func set_colors() -> void:
	color = COLORS[level.get_value() % 15]
	next_color = COLORS[(level.get_value() + 1) % 15]


func apply_to_stage_3() -> void:
	affected_stages.append(3)
	up.get_upgrade(Upgrade.Type.LIMIT_BREAK).update_effected_loreds_text()


func apply_to_stage_4() -> void:
	affected_stages.append(4)
	up.get_upgrade(Upgrade.Type.LIMIT_BREAK).update_effected_loreds_text()


func reset() -> void:
	level.reset()
	xp.set_to(0)
	total_xp.set_to(0)
	total_xp.total.set_from_level(
		calculate_required_xp(level.get_value())
	)
	xp.total.set_to(total_xp.get_total())



# - Get


func get_required_xp(_level: int) -> Big:
	if _level in cached_xp_required.keys():
		return cached_xp_required[_level]
	if not stupid_msg_printed:
		printerr("Drillur only cached 3,000 Limit Break levels. You surpassed that! Screenshot this and post it on the Discord to bully him!")
		stupid_msg_printed = true
	return calculate_required_xp(_level)


func calculate_required_xp(_level: int) -> Big:
	var x = Big.new(3).power(_level - 1).round_up_tens().m(100)
	if x.exponent < 3:
		x.set_to(1000)
	return x


func applies_to_stage_3() -> bool:
	return 3 in affected_stages


func applies_to_stage_4() -> bool:
	return 4 in affected_stages


