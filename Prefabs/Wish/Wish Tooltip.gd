extends MarginContainer



var wish: Wish

onready var dialogue   = get_node("m/v/dialogue/h/m/Label")
onready var speaker_name = get_node("m/v/dialogue/h/expression/v/name/m/text")
onready var rewards    = get_node("m/v/rewards")
#onready var count      = get_node("m/v/obj/v/m/h/count")
onready var expression = get_node("m/v/dialogue/h/expression/v/Panel/Sprite")




func init(_wish: Wish):
	
	yield(self, "ready")
	
	wish = _wish
	
	wish.setTooltip(self)
	
	initiateVisualShit()

func initiateVisualShit():
	
	get_node("m/v/rewards/bg").self_modulate = wish.color
	get_node("m/v/random/v/line").self_modulate = wish.color
	expression.modulate = gv.g[wish.giver].color
	speaker_name.self_modulate = gv.g[wish.giver].color
	speaker_name.text = gv.g[wish.giver].name
	#get_node("m/v/dialogue/h/expression/v/name/bg").self_modulate = gv.g[wish.giver].color
	#current.modulate = wish.color
	get_node("m/v/random").visible = wish.random and not wish.ready
	
	updateDialogueAndExpression()
	
	# rewards
	if true:
		
		var s1_used := false
		var s2_used := false
		var s3_used := false
		var r1_used := false
		
		if wish.rewards == 0:
			rewards.hide()
		
		for r in wish.rew:
			
			match r.type:
				
				gv.WishReward.MAX_RANDOM_WISHES:
					
					get_node("m/v/rewards/h/v/max_random_wishes").show()
					get_node("m/v/rewards/h/v/max_random_wishes/h/amount").text = "+" + r.amount.toString()
					get_node("m/v/rewards/h/v/max_random_wishes/h/current").text = "(" + str(taq.max_random_wishes) + ")"
				
				gv.WishReward.TAB:
					if int(r.key) < gv.Tab.S1:
						get_node("m/v/rewards/h/v/upgrade tab").show()
						get_node("m/v/rewards/h/v/upgrade tab/h/icon/Sprite").texture = gv.sprite[r.key]
						
						var bla = {gv.Tab.NORMAL: "Normal", gv.Tab.MALIGNANT: "Malignant",
							gv.Tab.EXTRA_NORMAL: "Extra-normal", gv.Tab.RADIATIVE: "Radiative",
							gv.Tab.RUNED_DIAL: "Runed Dial", "s3m": "Spirit" #s4
						}
						var bla2 = {gv.Tab.NORMAL: "Q", gv.Tab.MALIGNANT: "W",
							gv.Tab.EXTRA_NORMAL: "E", gv.Tab.RADIATIVE: "R",
							gv.Tab.RUNED_DIAL: "A", "s3m": "S" #s4
						}
						
						var menu_name = bla[int(r.key)]
						var hotkey = bla2[int(r.key)]
						
						get_node("m/v/rewards/h/v/upgrade tab/h/flair").text = menu_name + " Upgrade menu - Hotkey: " + hotkey
					else:
						get_node("m/v/rewards/h/v/stage tab").show()
						get_node("m/v/rewards/h/v/stage tab/h/icon/Sprite").texture = gv.sprite[r.key]
						get_node("m/v/rewards/h/v/stage tab/h/stage").text = "Stage " + str(gv.Tab.S1 - int(r.key))
				
				gv.WishReward.NEW_LORED:
					get_node("m/v/rewards/h/v/newcomer").show()
					if not s1_used:
						s1_used = true
						get_node("m/v/rewards/h/v/newcomer/h/h/s1/Sprite").texture = gv.sprite[r.key]
					elif not s2_used:
						s2_used = true
						get_node("m/v/rewards/h/v/newcomer/h/h/s2/Sprite").texture = gv.sprite[r.key]
						get_node("m/v/rewards/h/v/newcomer/h/h/s2").show()
					elif not s3_used:
						s3_used = true
						get_node("m/v/rewards/h/v/newcomer/h/h/s3/Sprite").texture = gv.sprite[r.key]
						get_node("m/v/rewards/h/v/newcomer/h/h/s3").show()
					else:
						get_node("m/v/rewards/h/v/newcomer/h/h/s4/Sprite").texture = gv.sprite[r.key]
						get_node("m/v/rewards/h/v/newcomer/h/h/s4").show()
				
				gv.WishReward.RESOURCE:
					
					if not r1_used:
						r1_used = true
						get_node("m/v/rewards/h/v/r1").show()
						get_node("m/v/rewards/h/v/r1/h/amount").text = "+" + r.amount.toString()
						get_node("m/v/rewards/h/v/r1/h/icon/Sprite").texture = gv.sprite[r.key]
						get_node("m/v/rewards/h/v/r1/h/resource").text = gv.g[r.key].name
						get_node("m/v/rewards/h/v/r1/h/amount").self_modulate = gv.COLORS[r.key]
					else:
						get_node("m/v/rewards/h/v/r2").show()
						get_node("m/v/rewards/h/v/r2/h/amount").text = "+" + r.amount.toString()
						get_node("m/v/rewards/h/v/r2/h/icon/Sprite").texture = gv.sprite[r.key]
						get_node("m/v/rewards/h/v/r2/h/resource").text = gv.g[r.key].name
						get_node("m/v/rewards/h/v/r2/h/amount").self_modulate = gv.COLORS[r.key]
		
		if get_node("m/v/rewards/h/v/newcomer").visible:
			if not get_node("m/v/rewards/h/v/newcomer/h/h/s2").visible:
				get_node("m/v/rewards/h/v/newcomer/h/flair").text = "Newcomer!"
			else:
				get_node("m/v/rewards/h/v/newcomer/h/flair").text = "Newcomers!"



func updateDialogueAndExpression():
	
	if wish.ready:
		dialogue.bbcode_text = wish.thank_text
		expression.texture = gv.sprite[wish.thank_expression]
	else:
		dialogue.bbcode_text = wish.help_text
		expression.texture = gv.sprite[wish.help_expression]
	#leftoff: Test the reset Wish in the current save file. (ignore the position of this message, this code is fine. don't touch it)
	dialogue.rect_min_size.x = max(dialogue.bbcode_text.length() * 0.75, 95)


func updateRandomVisibility():
	if get_node("m/v/random").visible:
		get_node("m/v/random").hide()

