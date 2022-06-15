class_name LOREDnewest
extends Node


# -


var working := false
var syncQueued := false
var halt: bool setget setHalt, getHalt
var hold: bool setget setHold, getHold
var active: bool setget setActive, getActive
var unlocked: bool setget setUnlocked, getUnlocked

var type: int

var loredName: String

var jobList := {}


# -


func setActive(val: bool):
	active = val
func setUnlocked(val: bool):
	unlocked = val
func setHalt(val: bool):
	halt = val
func setHold(val: bool):
	hold = val



func getActive() -> bool:
	return active
func getUnlocked() -> bool:
	return unlocked
func getHalt() -> bool:
	return halt
func getHold() -> bool:
	return hold



func isAvailable() -> bool:
	
	if not unlocked:
		return false
	
	if not active:
		return false
	
	return halt


# -


func start():
	
	while isAvailable():
		
		if syncQueued:
			lored.sync()
		
		if not working:
			for j in jobList:
				if j.try():
					break
		
		
		if not working:
			break
		
		#tell_children_the_news()
		
		var t = Timer.new()
		add_child(t)
		t.start(lored.current_job.duration)
		yield(t, "timeout")
		t.queue_free()
		
		lored.current_job.complete()
	
	# after 1 second, will restart the func
	
	#gn_frames.animation = "ww"
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
