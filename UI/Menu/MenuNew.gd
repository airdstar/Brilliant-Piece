extends Control

var tabAmount := 2
var currentTab := 0

var optionCount : int
var highlightedOption := 0
var options : Array
var optionLabels : Array[RichTextLabel]

func _ready():
	await get_tree().create_timer(1).timeout
	setOptions()

func _process(delta: float) -> void:
	var inputDirection : String
	if Input.is_action_just_pressed("Left"):
		inputDirection = "Left"
	elif Input.is_action_just_pressed("Right"):
		inputDirection = "Right"
	elif Input.is_action_just_pressed("Forward"):
		inputDirection = "Forward"
	elif Input.is_action_just_pressed("Backward"):
		inputDirection = "Backward"
	
	if inputDirection:
		handleMenuHighlighting(inputDirection)
	
	if Input.is_action_just_pressed("Menu Select") and (!FloorData.floor.Handlers.SH.interactable or !FloorData.floor.Handlers.SH.moving):
		selectOption()

func handleMenuHighlighting(input : String):
	match input:
		"Forward":
			if highlightedOption < optionCount - 1:
				highlightedOption += 1
			else:
				highlightedOption = 0
		"Backward":
			if highlightedOption > 0:
				highlightedOption -= 1
			else:
				highlightedOption = optionCount - 1
		"Right":
			if currentTab < tabAmount - 1:
				currentTab += 1
			else:
				currentTab = 0
		"Left":
			if currentTab > 0:
				currentTab -= 1
			else:
				currentTab = tabAmount - 1
	print(input)
	setOptions()

func setOptions():
	for n in range(optionLabels.size()):
		remove_child(optionLabels[n])
	highlightedOption = 0
	optionLabels.clear()
	match currentTab:
		0:
			optionCount = 5
			options = PlayerData.playerInfo.actions
			for n in range(optionCount):
				var newLabel = RichTextLabel.new()
				add_child(newLabel)
				optionLabels.append(newLabel)
				optionLabels[n].bbcode_enabled = true
				optionLabels[n].theme = ResourceLoader.load("res://UI/InteractableTheme.tres")
				optionLabels[n].position = Vector2(0, 120 + 30 * n)
				optionLabels[n].size = Vector2(200, 30)
				if options.size() - 1 >= n:
					if options[n] != null:
						optionLabels[n].bbcode_text = options[n].name
					else:
						optionLabels[n].text = "- EMPTY -"
				else:
					options.append(null)
					optionLabels[n].text = "- EMPTY -"
		1:
			options = PlayerData.playerInfo.items
			optionCount = options.size()
			if optionCount == 0:
				pass
			for n in range(optionCount):
				var newLabel = RichTextLabel.new()
				add_child(newLabel)
				optionLabels.append(newLabel)
				optionLabels[n].bbcode_enabled = true
				optionLabels[n].theme = ResourceLoader.load("res://UI/InteractableTheme.tres")
				optionLabels[n].position = Vector2(0, 120 + 30 * n)
				optionLabels[n].size = Vector2(200, 30)
				optionLabels[n].bbcode_text = options[n].name
			
			
func selectOption():
	if optionCount != 0:
		FloorData.floor.Handlers.SH.interactable = options[highlightedOption]
		FloorData.floor.Handlers.SH.actingPiece = PlayerData.playerPiece
		FloorData.floor.Handlers.TH.show()
