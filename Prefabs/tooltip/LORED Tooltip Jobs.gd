extends MarginContainer



onready var jobParent = get_node("%jobs")
onready var scroll_container: ScrollContainer = $m/v/bot/ScrollContainer

var lored: int
var jobs: Dictionary



func setup(_lored: int):
	
	lored = _lored
	get_node("%icon").modulate = lv.getFadedColor(lored)#lv.lored[lored].color
	
	yield(self, "ready")
	
	for job_key in lv.lored[lored].sorted_jobs:
		var job = lv.lored[lored].lored.jobs[job_key] as Job
		jobs[job.type] = gv.SRC["tooltip/lored job"].instance()
		jobs[job.type].setup(job)
		jobParent.add_child(jobs[job.type])
	
	if lv.lored[lored].lored.lastJob != -1:
		if lv.lored[lored].lored.lastJob == lv.Job.REFUEL:
			highlightJob(lv.lored[lored].get_refuel_job())
		else:
			highlightJob(lv.lored[lored].lored.jobs[lv.lored[lored].lored.lastJob])

func highlightJob(job: Job):
	jobs[job.type].glow()

func stopHighlightJob(job: Job):
	jobs[job.type].stopGlow()


func scroll(direction: int):
	scroll_container.scroll_vertical += direction * 30
