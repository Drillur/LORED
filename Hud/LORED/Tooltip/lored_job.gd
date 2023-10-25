extends MarginContainer



@onready var title = %Title
#@onready var title_bg = %"title bg"
@onready var duration = %Duration
@onready var produced_currencies_parent = %"Produced Currencies Parent"
@onready var required_currencies_parent = %"Required Currencies Parent"
@onready var glow = $glow

var job: Job



func setup(_job: Job) -> void:
	job = _job
	if not is_node_ready():
		await ready
	
	#title_bg.modulate = lv.get_lored(job.lored).details.color
	glow.self_modulate = lv.get_lored(job.lored).details.alt_color
	
	title.text = job.name
	job.duration.connect("changed", update_duration_text)
	update_duration_text()
	prepare_produced_currencies()
	prepare_required_currencies()
	
	job.connect("stopped_working", glow.hide)
	job.connect("began_working", glow.show)
	if job.working:
		glow.show()
	else:
		glow.hide()



func prepare_produced_currencies() -> void:
	if job.has_produced_currencies:
		for cur in job.produced_currencies:
			var x = res.get_resource("lored_job_entry").instantiate()
			x.setup(job.produced_currencies[cur], cur, true)
			produced_currencies_parent.add_child(x)
	else:
		produced_currencies_parent.queue_free()


func prepare_required_currencies() -> void:
	if job.has_required_currencies:
		for cur in job.required_currencies.cost:
			var x = res.get_resource("lored_job_entry").instantiate()
			x.setup(job.required_currencies.cost[cur], cur, false)
			required_currencies_parent.add_child(x)
	else:
		required_currencies_parent.queue_free()


func update_duration_text() -> void:
	duration.text = "[i]" + job.duration.get_text() + " seconds"
