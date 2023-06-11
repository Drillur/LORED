class_name Icon
extends Panel



var shadow = preload("res://Styles/Panels/new_styleboxtexture.tres")



export var icon: Texture setget set_icon


func set_icon(texture: Texture):
	
	$TextureRect.texture = texture
	var icon_size = $TextureRect.texture.get_size()
	
	var shadow_new = shadow.duplicate()
	shadow_new.texture = texture
	shadow_new.region_rect = Rect2(-1, -1, icon_size.x, icon_size.y)
	set("custom_styles/panel", shadow_new)


func _ready() -> void:
	
	rect_min_size = Vector2(rect_size.y, rect_size.y)
	
	var _name: String = name.rstrip("0123456789")
	if _name in gv.sprite.keys():
		set_icon(gv.sprite[_name])
	
	_on_Icon_resized()


func _on_Icon_resized() -> void:
	$TextureRect.rect_size = rect_size
