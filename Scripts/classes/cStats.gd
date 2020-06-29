class_name Statistics
extends Reference


var run := []
var time_played := 0
var tasks_completed := 0
var r_gained := {}
var last_run_dur := []
var last_reset_clock := [] # for each stage, saves the date/time
var most_resources_gained := 0.0
var highest_run = 1
var up_list := {}

func _init(g : Array):
	
	for x in 4:
		run.append(1.0)
		last_run_dur.append(0)
		last_reset_clock.append(OS.get_unix_time())
	
	for x in g:
		# an array of all the keys in gv.g
		r_gained[x] = 0.0
