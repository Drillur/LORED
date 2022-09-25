extends MarginContainer

var lored: int

onready var costContainer = get_node("%CostContainer")


func setup(_lored: int):
	
	#top and bottom bars shouldnt be the darker ones. also, make each row alternating bg. then add some color, maybe to the x2 texts
	
	lored = _lored
	
	if lv.lored[lored].purchased:
		get_node("m/v/bot").show()
		
		setTexts()
		setColors()
	else:
		preFirstPurchase()
	
	yield(self, "ready")
	setupCost()

func preFirstPurchase():
	
	get_node("m/v/v/top/v/m").hide()
	get_node("m/v/v/top/v/first").show()
	get_node("m/v/bot").hide()
	get_node("m/v/v/top/v/first/v/text").text = "Ask " + lv.lored[lored].name + " to join you!"
	
	var goof = randi()% 100 < 10
	if goof:
		get_node("m/v/v/top/v/first/v/net").show()
		get_node("m/v/v/top/v/first/v/net").text = [
			"(With a bribe.)",
			"(But not for free.)",
			"(Very nicely.)",
			"(Threatening didn't work. You ought to have tried this first.)",
			"(As if they had a choice.)",
		][randi()% 5]
	else:
		get_node("m/v/v/top/v/first/v/net").hide()



func setTexts():
	
	var loredLevel = lv.lored[lored].level
	get_node("m/v/bot/h/current/Label").text = str(loredLevel)
	get_node("m/v/bot/h/result/Label").text = str(loredLevel + 1)
	
	var loredOutput = Big.new(lv.lored[lored].output)
	get_node("m/v/bot/h/current/Label2").text = loredOutput.toString()
	get_node("m/v/bot/h/result/Label2").text = loredOutput.m(2).toString()
	
	var loredInput = Big.new(lv.lored[lored].input)
	get_node("m/v/bot/h/current/Label3").text = loredInput.toString()
	get_node("m/v/bot/h/result/Label3").text = loredInput.m(2).toString()
	
	var loredFuelCost = Big.new(lv.lored[lored].fuelCost)
	get_node("m/v/bot/h/current/Label4").text = loredFuelCost.toString()
	get_node("m/v/bot/h/result/Label4").text = loredFuelCost.m(2).toString()
	
	var loredFuelStorage = Big.new(lv.lored[lored].fuelStorage)
	get_node("m/v/bot/h/current/Label5").text = loredFuelStorage.toString()
	get_node("m/v/bot/h/result/Label5").text = loredFuelStorage.m(2).toString()
	
	get_node("m/v/bot/h/increase/Label6").text = "x" + lv.lored[lored].costModifierText

func setupCost():
	
	costContainer.setup(lored, lv.lored[lored].cost)

func setColors():
	
	var loredColor = lv.lored[lored].color
	
	get_node("m/v/v/top/v/m/h/icon").modulate = loredColor
	get_node("m/v/bot/h/increase").modulate = loredColor


func flash():
	costContainer.flash()
