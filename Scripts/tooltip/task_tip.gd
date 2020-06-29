extends Label

onready var rt = get_parent().rt

var my_task : taq.Task
var step := {}
var rr := {}
var r := {}

func init(task : taq.Task) -> int:
	
	my_task = task
	step.clear()
	rr.clear()
	r.clear()
	
	text = task.name
	$desc.text = task.desc
	
	var point : int = $desc.rect_position.y + 55 + 5 + 15
	
	var i := 0
	for x in task.step:
		#if i > 0: point += 15
		step[x] = get_parent().get_parent().prefab["task step"].instance()
		step[x].text = x + " (" + fval.f(task.step[x].f) + " / " + fval.f(task.step[x].b) + ")"
		step[x].get_node("icon").texture = r_set_icon(x)
		step[x].rect_size.x = 160
		step[x].rect_position = Vector2(5, point)
		add_child(step[x])
		point += 55
		i += 1
	
	point -= 25
	$reward_flair.rect_position.y = point
	point += 24
	
	i = 0
	for x in task.resource_reward:
		rr[x] = get_parent().get_parent().prefab["task rr"].instance()
		rr[x].text = "+" + fval.f(task.resource_reward[x])
		rr[x].add_color_override("font_color", rt.r_lored_color(x))
		rr[x].get_node("icon").set_texture(gv.sprite[x])
		rr[x].get_node("resource").text = gv.g[x].name
		rr[x].rect_size.x = 160#rect_size.x - 20
		rr[x].rect_position = Vector2(5, point)
		if i % 2 == 0: rr[x].get_node("bg").hide()
		i += 1
		add_child(rr[x])
		point += 42
	
	i = 0
	for x in task.reward:
		if i == 0: point += 30
		r[x] = get_parent().get_parent().prefab["task r"].instance()
		r[x].text = x
		r[x].get_node("icon").set_texture(task.reward[x])
		r[x].rect_position = Vector2(5, point)
		add_child(r[x])
		point += 45
		i += 1
	
	if task.reward.size() == 0:
		point += 4
	else:
		point -= 10
	
	return point

func _fuck_off():
	for x in step:
		step[x].free()
	for x in rr:
		rr[x].free()
	for x in r:
		r[x].free()
	hide()
	queue_free()

func r_set_icon(resource : String) -> Texture:
	
	var blah := ""
	for x in gv.g:
		if not gv.g[x].name in resource:
			continue
		
		if "Liquid" in resource and gv.g[x].name == "Iron":
			continue
		if "Pulp" in resource and gv.g[x].name == "Wood":
			continue
		
		blah = x
		break
	
	if "Tasks completed" in resource or "Rare or Spike tasks completed" in resource or "Spike tasks completed" in resource:
		return gv.sprite["copy"]
	
	# upgrade
	if "purchased" in resource:
		return gv.sprite[gv.up[resource.split(" purchased")[0]].main_lored_target]
	
	# buy lored
	if "bought" in resource:
		return gv.sprite[blah]
	
	if "combined resources produced" in resource.to_lower():
		return gv.sprite["s1"]
	
	if "combined stage 2 resources produced" in resource.to_lower():
		return gv.sprite["s2"]
	
	if "produced" in resource:
		return gv.sprite[blah]
	
	if "Have" in resource:
		return gv.sprite[blah]
	
	return gv.sprite["unknown"]
