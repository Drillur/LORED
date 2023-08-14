class_name WalletVico
extends MarginContainer



@onready var title_bg = %"title bg"
@onready var bg = $bg

@onready var stage_1_container = %"Stage 1 Container"
@onready var stage_2_container = %"Stage 2 Container"
@onready var stage_3_container = %"Stage 3 Container"
@onready var stage_4_container = %"Stage 4 Container"

var wallet_currency_node = preload("res://Hud/Wallet/wallet_currency.tscn")

var content := {}



func _ready():
	for stage in range(1, 5):
		add_stage_currencies(stage)

func _on_tab_changed(tab):
	var color = gv.get_stage_color(tab + 1)
	title_bg.modulate = color
	bg.modulate = color



func add_stage_currencies(stage: int) -> void:
	for currency in wa.get_currencies_in_stage(stage):
		var cur = currency.type
		content[cur] = wallet_currency_node.instantiate()
		content[cur].setup(cur)
		get("stage_" + str(stage) + "_container").add_child(content[cur])

