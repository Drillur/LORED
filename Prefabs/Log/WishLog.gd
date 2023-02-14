extends MarginContainer

onready var rt = get_node("/root/Root")
onready var currentMain = get_node("%currentMain")
onready var currentRandom = get_node("%currentRandom")
onready var grantedMain = get_node("%grantedMain")
onready var grantedRandom = get_node("%grantedRandom")


func log(wish: Wish):
	
	var vico = gv.SRC["wish vico"].instance()
	vico.setup(wish)
	
	if wish.complete:
		if wish.random:
			grantedRandom.add_child(vico)
		else:
			grantedMain.add_child(vico)
	else:
		if wish.random:
			currentRandom.add_child(vico)
		else:
			currentMain.add_child(vico)



func _on_visibility_changed() -> void:
	if visible:
		rt.clearWishNotice()
