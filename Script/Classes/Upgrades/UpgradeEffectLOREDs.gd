class_name UpgradeEffectLOREDs
extends RefCounted



var affected_loreds: Array[LORED]
var affected_loreds_text: String
var color: Color
var icon: Texture2D



func _init(_affected_loreds: Array[LORED.Type]):
	for _type in _affected_loreds:
		affected_loreds.append(lv.get_lored(_type))
	set_color_and_icon()
	set_affected_loreds_text()


func set_color_and_icon() -> void:
	var highest_value := 0
	var winner = 0
	var i = 0
	for lored in affected_loreds:
		if lored.type > highest_value:
			highest_value = lored.type
			winner = i
		i += 1
	var lored_details: Details = affected_loreds[winner].details
	color = lored_details.color
	icon = lored_details.icon


func set_affected_loreds_text() -> void:
#	match type:
#		Type.LIMIT_BREAK:
#			var s1 = gv.stage1.details.color_text % "1"
#			var s2 = gv.stage2.details.color_text % "2"
#			if up.limit_break.applies_to_stage_3():
#				if up.limit_break.applies_to_stage_4():
#					affected_loreds_text = "[i]for[/i] All LOREDs"
#					return
#				var s3 = gv.stage3.details.color_text % "3"
#				affected_loreds_text = "[i]for[/i] Stages %s, %s, and %s" % [s1, s2, s3]
#				return
#			affected_loreds_text = "[i]for[/i] Stages %s and %s" % [s1, s2]
#			return
	
	if affected_loreds == lv.get_loreds_in_stage(4):
		var _stage = gv.stage4.details.colored_name
		affected_loreds_text = "[i]for [/i]" + _stage
		return
	elif affected_loreds == lv.get_loreds_in_stage(3):
		var _stage = gv.stage3.details.colored_name
		affected_loreds_text = "[i]for [/i]" + _stage
		return
	elif affected_loreds == lv.get_loreds_in_stage(2):
		var _stage = gv.stage2.details.colored_name
		affected_loreds_text = "[i]for [/i]" + _stage
		return
	elif affected_loreds == lv.get_loreds_in_stage(1):
		var _stage = gv.stage1.details.colored_name
		affected_loreds_text = "[i]for [/i]" + _stage
		return
	
#	if effect != null and effect.type == OldUpgradeEffect.Type.UPGRADE_AUTOBUYER:
#		var upmen = up.get_upgrade_menu(effect.upgrade_menu) as UpgradeMenu
#		affected_loreds_text = "[i]for [/i]" + upmen.details.colored_name
#		return
	var arr := []
	for lored in affected_loreds:
		arr.append(lored.details.colored_name)
	affected_loreds_text = "[i]for [/i]" + gv.get_list_text_from_array(arr).replace("and", "[i]and[/i]")
	return




# - Get


func get_loreds() -> Array[LORED]:
	return affected_loreds
