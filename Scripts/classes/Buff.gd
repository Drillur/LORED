class_name Buff
extends Reference



var type: int
var lored: int

var ticks: int
var max_ticks: int
var instances_of_buff := 1
var last_tick: int

var base_tick_rate: float
var tick_rate: float

var name: String
var description: String
var key: String

var color: Color

var affected_by_haste := false
var queued_for_removal := false



func _init(_type: int, _lored: int) -> void:
	
	type = _type
	lored = _lored
	key = BuffManager.Type.keys()[type]
	
	call(key)
	
	last_tick = OS.get_ticks_msec()
	
	if tick_rate == 0.0:
		sync_tick_rate()


func unique_init_command(commands: Dictionary):
	if "max_ticks" in commands:
		max_ticks = commands["max_ticks"]


func WITCH():
	
	name = "Touch of LOREDELITH"
	description = "Every [color=#00ff00]{tick_rate}[/color] seconds, gain 5 seconds' worth of resources that this LORED produces."
	
	base_tick_rate = 5
	max_ticks = 3
	
	color = gv.COLORS["witch"]
	
	affected_by_haste = true
	
	update_WITCH()



func sync_tick_rate():
	if affected_by_haste:
		tick_rate = base_tick_rate / lv.lored[lored].haste
	else:
		tick_rate = base_tick_rate



func add_instance():
	
	instances_of_buff += 1
	
	match type:
		BuffManager.Type.WITCH:
			update_WITCH()



func reset_ticks():
	ticks = 0



func tick():
	ticks += 1
	last_tick = OS.get_ticks_msec()
	call("tick_" + key)



var witch: Dictionary


func tick_WITCH():
	
	if witch.empty():
		return
	
	for resource in witch:
		var amount = witch[resource]
		gv.addToResource(resource, amount)
		gv.increase_lb_xp(amount)
		taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, str(resource), amount)


func update_WITCH():
	
	witch.clear()
	
	sync_tick_rate()
	
	for job in lv.lored[lored].jobs.values():
		
		var net_gain = job.getGain()
		for resource in net_gain:
			if queued_for_removal:
				witch[resource] = Big.new(0)
			else:
				witch[resource] = Big.new(net_gain[resource]).m(5).power(instances_of_buff)
			
			if gv.up["GRIMOIRE"].active():
				witch[resource].m(log(gv.run1))
			
			lv.gainBits[resource].bits[lv.Num.ADD]["witch"] = Big.new(witch[resource]).d(tick_rate)
			lv.gainUpdated[resource] = true
			lv.drainOrGainUpdated[resource] = true
	
	BuffManager.emit_signal("update_description", lored, type)



func queue_removal():
	
	queued_for_removal = true
	
	if has_method("prepare_for_removal_" + key):
		call("prepare_for_removal_" + key)

