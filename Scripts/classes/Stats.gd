class_name Statistics
extends Reference


var run := []
var time_played := 0
var tasks_completed := 0
var r_gained := {}
var last_run_dur := []
var last_reset_clock := [] # for each stage, saves the date/time
var most_resources_gained := Big.new(0)
var highest_run = 1
var up_list := {
	"s1": [],
	"s2": [],
	"s3": [],
	"s4": [],
	"s1n": [],
	"s1m": [],
	"s2n": [],
	"s2m": [],
	"s3n": [],
	"s3m": [],
	"s4n": [],
	"s4m": [],
	"unowned s1n": [],
	"unowned s2n": [],
	"unowned s3n": [],
	"unowned s4n": [],
}
var upgrades_owned := {}
var tabs_unlocked := {
	"1": true,
	"2": false,
	"3": false,
	"4": false,
}
var g_list := {
	"s1": [],
	"s2": [],
	"s3": [],
	"s4": [],
	"active": ["stone"],
	"active s1": ["stone"],
	"active s2": [],
	"active s3": [],
	"active s4": [],
	"rare quest whitelist": [],
}

func _init(g : Array):
	
	for x in 4:
		run.append(1.0)
		last_run_dur.append(0)
		last_reset_clock.append(OS.get_unix_time())
	
	for x in g:
		# an array of all the keys in gv.g
		r_gained[x] = Big.new(0)
