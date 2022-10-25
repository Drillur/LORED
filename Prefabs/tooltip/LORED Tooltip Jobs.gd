extends MarginContainer

onready var jobParent = get_node("%jobs")


func setup(lored: int):
	
	get_node("%icon").modulate = lv.getFadedColor(lored)#lv.lored[lored].color
	
	yield(self, "ready")
	
	for job in lv.lored[lored].lored.jobs.values():
		var jobUI = gv.SRC["tooltip/lored job"].instance()
		jobUI.setup(job)
		jobParent.add_child(jobUI)
	
	var refuelJobUI = gv.SRC["tooltip/lored job"].instance()
	refuelJobUI.setup(lv.lored[lored].lored.refuelJob)
	jobParent.add_child(refuelJobUI)
