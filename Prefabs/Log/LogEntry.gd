extends MarginContainer



var type: int

func setup(_type: int, _info: String):
	type = _type
	call(LogManager.Type.keys()[type])

func LEVEL_UP():
	print("LEVEL_uP block added!!!!!!!!!!!!!")
	pass
