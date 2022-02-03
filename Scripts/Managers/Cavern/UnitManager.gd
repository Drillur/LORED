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
	var gcd_begun = setGCDBegun()
	
	var t = Timer.new()
	add_child(t)
	t.start(duration)
	yield(t, "timeout")
	t.queue_free()
	
	if unit.gcd.stopped:
		unit.gcd.stopped = false
		return
	
	if not gv.warlock.GCDMatch(gcd_begun):
		print_debug("gcd_begun mis-match: ", gv.warlock.gcd_begun, "; expected ", gcd_begun)
		return
	
	unit.gcd.setAvailable()
	gv.emit_signal("gcd_stopped")

func getGCDRemaining() -> float:
	var in_msec := OS.get_ticks_msec() - gv.warlock.gcd_begun
	var in_sec := float(in_msec) / 1000
	return max(1.5 - in_sec, 0)

func setGCDBegun() -> int:
	gv.warlock.gcd_begun = OS.get_ticks_msec()
	return gv.warlock.gcd_begun







