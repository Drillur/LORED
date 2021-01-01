extends HBoxContainer



var key: String



func setup(_key: String):
	
	key = _key
	
	get_node("icon/Sprite").texture = gv.sprite[key]
	if key in gv.g.keys():
		get_node("text").self_modulate = gv.g[key].color


func r_amount():
	
	get_node("text").text = gv.r[key].toString()

func r_net(net: Big):
	
	get_node("text").text = "-" + net.toString() + "/s"
