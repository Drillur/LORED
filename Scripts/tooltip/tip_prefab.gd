extends Panel

func _ready():
	
	if true: # ref
		
		if true: # init
			
			rect_size.y = 108
			rect_size.x = 205
			get_node("desc").rect_position = Vector2(0,36)
			get_node("desc").rect_size.y = 72
			get_node("shoo").rect_size = Vector2(90, 51)
			get_node("shoo").rect_position = Vector2(rect_size.x / 2 - get_node("shoo").rect_size.x / 2, rect_size.y + 4)
			get_node("subject").rect_position.x = int(rect_size.x / 2 - get_node("subject").rect_size.x / 2)
		
		if true: # visible
			
			visible = false
			
			match get_index():
				3, 4, 5, 6, 7:
					get_node("shoo").clicked = true
					visible = true