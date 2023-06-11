extends MarginContainer



onready var net = get_node("%net")
onready var lock: Panel = $"%Unlock"
onready var rt = get_node("/root/Root")
onready var amount = get_node("%amount")
onready var negative_net = get_node("%negative net")

var resource: int



func _on_mouse_entered() -> void:
	rt.get_node("global_tip")._call("wallet resource", {"resource": resource})

func _on_Export_mouse_entered() -> void:
	rt.get_node("global_tip")._call("resource export", {"resource": resource})

func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")


func _on_Export_pressed() -> void:
	gv.swap_locked_resource(resource)
	if gv.resource_is_locked(resource):
		lock.set_icon(gv.sprite["Lock"])
	else:
		lock.set_icon(gv.sprite["Unlock"])
	rt.get_node("global_tip").refresh()



func connect_net_updated(tab: int):
	if resource in gv.list["stage " + str(tab) + " resources"]:
		lv.connect("net_updated", self, "update_net_text")
		update_net_text(resource)


func disconnect_net_updated():
	if lv.is_connected("net_updated", self, "update_net_text"):
		lv.disconnect("net_updated", self, "update_net_text")


func connect_resourceChanged(tab: int):
	if resource in gv.list["stage " + str(tab) + " resources"]:
		gv.connect("resourceChanged", self, "update_amount_text")
		update_amount_text()


func disconnect_resourceChanged():
	if gv.is_connected("resourceChanged", self, "update_amount_text"):
		gv.disconnect("resourceChanged", self, "update_amount_text")



func setup(_resource: int):
	
	resource = _resource
	
	name = gv.resourceName[resource]
	
	set_icon()
	set_colors()
	set_resource_name()
	
	add_to_group("Resources")



func set_icon():
	get_node("%Resource Icon").set_icon(gv.sprite[gv.shorthandByResource[resource]])


func set_colors():
	
	var color = gv.COLORS[gv.shorthandByResource[resource]]
	
	get_node("%Export").modulate = color
	get_node("%Select").self_modulate = color
	get_node("%negative net").modulate = color
	get_node("%resource name").self_modulate = color


func set_resource_name():
	get_node("%resource name").text = gv.resourceName[resource]



func update_net_text(_resource: int):
	if not _resource == resource:
		return
	net.text = lv.netText(resource) + "/s"
	display_negative_net_alert(net.text)


func update_amount_text(_resource: int = resource):
	if not _resource == resource:
		return
	amount.text = gv.resource[resource].toString()


func display_negative_net_alert(net_text: String):
	if net_text.begins_with("-"):
		negative_net.show()
	else:
		negative_net.hide()


