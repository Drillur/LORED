class_name LimitBreak
extends Resource



const saved_vars := [
	"xp",
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

var applied := false
var enabled := Bool.new(false)
var xp := ValuePair.new(1)
var level := Int.new(1)
var affected_stages := [1, 2,]
var color: Color
var next_color: Color



func _init() -> void:
	set_colors()
	
	xp.total.set_from_level(get_required_xp(1))
	xp.set_to(0)
	xp.do_not_cap_current()
	xp.current_increased.connect(level_up_check)
	
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


func disconnect_calls() -> void:
	for currency in wa.currency.values():
		if not currency.increased_by_lored.is_connected(add_xp):
			printerr("Limit Break wasn't connected!")
			return
		currency.increased_by_lored.disconnect(add_xp)


func add_xp(amount: Big) -> void:
	xp.add(amount)


func level_up_check() -> void:
	var gained_levels := 0
	while xp.is_full():
		gained_levels += 1
		xp.subtract(xp.get_total())
		xp.total.set_from_level(
			get_required_xp(level.get_value() + gained_levels)
		)
	
	if gained_levels > 0:
		level.add(gained_levels)


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
	xp.total.set_from_level(
		get_required_xp(level.get_value())
	)



# - Get


func get_required_xp(_level: int) -> Big:
	var x = Big.new(2).power(_level - 1).round_up_tens().m(100)
	if x.exponent < 3:
		x.set_to(1000)
	#print("XP: ", x.text)
	return x


func applies_to_stage_3() -> bool:
	return 3 in affected_stages


func applies_to_stage_4() -> bool:
	return 4 in affected_stages

