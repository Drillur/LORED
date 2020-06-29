extends Label

func init(font_color : Color, sprite : Texture, name : String):
	add_color_override("font_color", font_color)
	$type.text = name
	$sprite.set_texture(sprite)
