extends MarginContainer



@onready var title_bg = %"title bg"
@onready var jobs_parent = %"Jobs Parent"
@onready var scroll_container = %ScrollContainer

var lored_job := preload("res://Hud/LORED/Tooltip/lored_job.tscn")
var lored: LORED

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val



func setup(data: Dictionary) -> void:
	lored = lv.get_lored(data["lored"]) as LORED
	if not is_node_ready():
		await ready
	color = lored.details.color
	for job in lored.sorted_jobs:
		var x = lored_job.instantiate()
		x.setup(lored.jobs[job])
		jobs_parent.add_child(x)
	
	jobs_parent.get_child(0).resized.connect(resize)
	jobs_parent.get_child(1).resized.connect(resize)


func resize() -> void:
	scroll_container.custom_minimum_size.y = (
		jobs_parent.get_child(0).size.y
		+ jobs_parent.get_child(1).size.y
		+ 0
	)
	
