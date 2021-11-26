class_name UnitManager
extends Node




var resting_resources := []
func spentResource(resource: Cav.UnitResource):
	
	if not resource.has_regen:
		return
	
	resource.stopRegen()
	resting_resources.append(resource)
	
	var t = Timer.new()
	add_child(t)
	t.start(resource.regen_rest)
	yield(t, "timeout")
	t.queue_free()
	
	resting_resources.erase(resource)
	if resting_resources.count(resource) >= 1:
		return
	
	regen(resource)

func regen(resource: Cav.UnitResource):
	
	var t = Timer.new()
	add_child(t)
	
	resource.stop_regen = false
	
	while not resource.stop_regen and resource.current.less(resource.total):
		
		resource.current = Big.new(resource.current).a(resource.regen)
		
		t.start(resource.regen_rate) # 0.1 by default
		yield(t, "timeout")
	
	t.queue_free()

func gcd(unit: Unit, duration: float):
	
	if unit == gv.warlock:
		gv.emit_signal("new_gcd", duration)
	
	unit.gcd.spellCast()
	
	var t = Timer.new()
	add_child(t)
	t.start(duration)
	yield(t, "timeout")
	t.queue_free()
	
	unit.gcd.setAvailable()










