class_name RoutineUpgrade
extends Resource



var enabled := Bool.new(false)

var upgrade: Upgrade



func _init():
	upgrade = up.get_upgrade(Upgrade.Type.ROUTINE)
	gv.prestiged.connect(go)



# - Signal Receivers


func go() -> void:
	if upgrade.purchased.is_false():
		return
	
	upgrade.remove()
	pass
			gv.up[key].have = false
			gv.list.upgrade["owned " + str(tab)].erase(key)
			
			routine.clear()
			routine_shit()
			
			rt.reset(gv.Tab.S1, false)

func routine_shit() -> void:
	
	routine = get_routine_info()
	
	gv.resource[gv.Resource.TUMORS].a(routine[0]) # d
	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.TUMORS), routine[0])
	gv.resource[gv.Resource.MALIGNANCY].s(routine[1]) # c
	

func get_routine_info() -> Array:
	
	var base = Big.new(lv.lored[lv.Type.TUMORS].output).m(1000)
	if gv.up["CAPITAL PUNISHMENT"].active():
		base.m(gv.run1)
	var routine_d: Big = Big.new(base)
	var routine_c: Big = Big.new(gv.up["ROUTINE"].cost[gv.Resource.MALIGNANCY].t)
	
	if gv.resource[gv.Resource.MALIGNANCY].greater(Big.new(routine_c).m(2)):
		
		var _c: Big = Big.new(gv.resource[gv.Resource.MALIGNANCY]).d(gv.up["ROUTINE"].cost[gv.Resource.MALIGNANCY].t).roundDown().s(1)
		_c.m(routine_c)
		routine_c.a(_c)
		
		var relative: Big = Big.new(routine_c).d(gv.up["ROUTINE"].cost[gv.Resource.MALIGNANCY].t).roundDown().s(1)
		relative.m(base)
		routine_d.a(relative)
	
	return [routine_d, routine_c]
