class_name Statistics
extends Reference


var run := []
var time_played := 0
var tasks_completed := 0
var last_run_dur := []
var last_reset_clock := [] # for each stage, saves the date/time
var most_resources_gained := Big.new(0)
var highest_run = 1


func _init(g : Array):
	
	for x in 4:
		run.append(1.0)
		last_run_dur.append(0)
		last_reset_clock.append(OS.get_unix_time())
