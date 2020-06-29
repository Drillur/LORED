extends Panel

onready var rt = get_parent().get_parent().get_owner()
var fps := 0.0

var fuel_source := ""
var gx := ""


func init(_fuel_source : String, _gx: String) -> void:
	
	fuel_source = _fuel_source
	gx = _gx
	
	rect_position.x += 5
	rect_position.y += 10
	
	# color
	if true:
		
		var color : Color = rt.r_lored_color(fuel_source)
		
		$storage.add_color_override("font_color", color)
		$drain.add_color_override("font_color", color)
		
		# fuel wheel color
		color = rt.r_lored_color(fuel_source)
		color = Color(color.r, color.g, color.b, 0.4)
		$storage/bar.tint_progress = color
		$storage/bar/flair.tint_progress = color
		$storage/bar.tint_under = Color(color.r, color.g, color.b, 0.2)
	
	# sprite
	$storage/icon.set_texture(gv.sprite[fuel_source])
	
	# text
	if "coal" in fuel_source:
		$drain/flair.text = "Coal Drain Per Second:"
		$storage/flair.text = "Coal Storage"
	else:
		$drain/flair.text = "Joule Drain Per Second:"
		$storage/flair.text = "Battery"
		$storage/flair.rect_position.x += 10
		$storage/bar.rect_position.x += 10
	
	r_update()


func _physics_process(delta: float) -> void:
	
	fps += delta
	if fps < rt.FPS:
		return
	fps -= rt.FPS
	
	r_update()


func r_update() -> void:
	
	var max_fuel = gv.g[gx].f.t 
	if gv.g[gx].type[1] in gv.overcharge_list:
		max_fuel *= gv.overcharge
	
	# amount text
	$storage.text = fval.f(gv.g[gx].f.f) + " / " + fval.f(max_fuel)
	
	# drain
	if true:
		
		var less = gv.g[gx].fc.t * 4
		var drain = gv.g[gx].fc.t * 60 * gv.g[gx].less_from_full(gv.g[gx].f.f, max_fuel)
		if gv.g[gx].f.f < max_fuel - less:
			drain *= 2
		
		# change to string
		if gv.g[gx].f.f < max_fuel - less:
			drain = fval.f(drain) + "*"
		else:
			drain = fval.f(drain)
		
		$drain.text = drain
	
	# bars
	$storage/bar.value = gv.g[gx].f.f / max_fuel * 100
	$storage/bar/flair.value = $storage/bar.value + 3
