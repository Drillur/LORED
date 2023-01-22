extends MarginContainer

onready var jobParent = get_node("%jobs")
var lored: int
var jobs: Dictionary


func setup(_lored: int):
	
	lored = _lored
	get_node("%icon").modulate = lv.getFadedColor(lored)#lv.lored[lored].color
	
	yield(self, "ready")
	
	var i = 0
	for job in lv.lored[lored].lored.jobs.values():
		var jobUI = gv.SRC["tooltip/lored job"].instance()
		jobUI.setup(job)
		jobParent.add_child(jobUI)
		jobs[job.type] = i
	
	var refuelJobUI = gv.SRC["tooltip/lored job"].instance()
	refuelJobUI.setup(lv.lored[lored].lored.refuelJob)
	jobParent.add_child(refuelJobUI)
	
	if lv.lored[lored].lored.lastJob != -1:
		if lv.lored[lored].lored.lastJob == lv.Job.REFUEL:
			highlightJob(lv.lored[lored].lored.refuelJob)
		else:
			highlightJob(lv.lored[lored].lored.jobs[lv.lored[lored].lored.lastJob])

func highlightJob(job: Job):
	if job.type == lv.Job.REFUEL:
		jobParent.get_child(jobParent.get_child_count() - 1).glow()
	else:
		jobParent.get_child(jobs[job.type]).glow()

func stopHighlightJob(job: Job):
	if job.type == lv.Job.REFUEL:
		jobParent.get_child(jobParent.get_child_count() - 1).stopGlow()
	else:
		jobParent.get_child(jobs[job.type]).stopGlow()
