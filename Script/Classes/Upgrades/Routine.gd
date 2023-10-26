class_name RoutineUpgrade
extends Resource



var enabled := Bool.new(false)

var routine: Upgrade
var capital_punishment: Upgrade

var tumors: LORED

var output: Big
var cost: Big

var routine_cost: Big
var current_malignancy: Big

var timer := Timer.new()



func _init():
	timer.one_shot = true
	timer.wait_time = 1
	timer.timeout.connect(timer_timeout)
	
	output = Big.new(0, true)
	cost = Big.new(0, true)
	gv.root_ready.became_true.connect(root_ready)


func root_ready() -> void:
	up.add_child(timer)
	
	routine = up.get_upgrade(Upgrade.Type.ROUTINE)
	capital_punishment = up.get_upgrade(Upgrade.Type.CAPITAL_PUNISHMENT)
	
	tumors = lv.get_lored(LORED.Type.TUMORS)
	
	routine_cost = routine.cost.cost[Currency.Type.MALIGNANCY].get_value()
	current_malignancy = wa.get_currency(Currency.Type.MALIGNANCY).count
	
	gv.prestiged.connect(go)



# - Signal Receivers


func go() -> void:
	if (
		routine.purchased.is_false()
		or tumors.purchased.is_false()
	):
		return
	
	var base := Big.new(tumors.output.get_value()).m(1000)
	if capital_punishment.purchased.is_true():
		base.m(max(1, gv.stage1.times_reset))
	
	output.set_to(base)
	cost.set_to(0)
	
	if current_malignancy.greater_equal(routine_cost):
		cost.a(Big.new(current_malignancy).d(routine_cost).roundDown().m(routine_cost))
		output.a(Big.new(cost).d(routine_cost).roundDown().m(base))
	
	wa.add(Currency.Type.TUMORS, output)
	wa.subtract(Currency.Type.MALIGNANCY, cost)
	
	timer.start()


func timer_timeout() -> void:
	routine.remove()



func test():
	if tumors.purchased.is_false():
		tumors.purchase()
	routine.purchase()

#func routine_shit() -> void:
#
#	routine = get_routine_info()
#
#	gv.resource[gv.Resource.TUMORS].a(routine[0]) # d
#	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.TUMORS), routine[0])
#	gv.resource[gv.Resource.MALIGNANCY].s(routine[1]) # c
#
#
#func get_routine_info() -> Array:
#
#	var base = Big.new(lv.lored[lv.Type.TUMORS].output).m(1000)
#	if gv.up["CAPITAL PUNISHMENT"].active():
#		base.m(gv.run1)
#	var routine_d: Big = Big.new(base)
#	var routine_c: Big = Big.new(gv.up["ROUTINE"].cost[gv.Resource.MALIGNANCY].t)
#
#	if gv.resource[gv.Resource.MALIGNANCY].greater(Big.new(routine_c).m(2)):
#
#		var _c: Big = Big.new(gv.resource[gv.Resource.MALIGNANCY]).d(
#			gv.up["ROUTINE"].cost[gv.Resource.MALIGNANCY].t
#		).roundDown().s(1)
#		_c.m(routine_c)
#		routine_c.a(_c)
#
#		var relative: Big = Big.new(routine_c).d(gv.up["ROUTINE"].cost[gv.Resource.MALIGNANCY].t).roundDown().s(1)
#		relative.m(base)
#		routine_d.a(relative)
#
#	return [routine_d, routine_c]
