extends Control

var tabAmount := 2
var currentTab := 0

var optionCount : int
var highlightedOption := 0
var options : Array
var optionLabels : Array[RichTextLabel]

func _ready():
	await get_tree().create_timer(0.5).timeout
	setOptions()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Left"):
		if currentTab > 0:
			currentTab -= 1
		else:
			currentTab = tabAmount - 1
		setOptions()
	elif Input.is_action_just_pressed("Right"):
		if currentTab < tabAmount - 1:
			currentTab += 1
		else:
			currentTab = 0
		setOptions()
	elif Input.is_action_just_pressed("Forward"):
		if highlightedOption > 0:
			highlightedOption -= 1
		else:
			highlightedOption = optionCount - 1
		$Pointer.position = Vector2(-10, 120 + 30 * highlightedOption)
	elif Input.is_action_just_pressed("Backward"):
		if highlightedOption < optionCount - 1:
			highlightedOption += 1
		else:
			highlightedOption = 0
		
		$Pointer.position = Vector2(-10, 120 + 30 * highlightedOption)

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
				$Pointer.position = Vector2(-10, 120)
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
				optionLabels[n].bbcode_text = options[n].name + " x" + str(options[n].amount)
				$Pointer.position = Vector2(-10, 120)
	add_icons()

func updateOptions():
	for n in range(optionLabels.size()):
		remove_child(optionLabels[n])
	optionLabels.clear()
	match currentTab:
		0:
			optionCount = 5
			options = PlayerData.playerInfo.actions
			for n in range(optionCount):
				var newLabel = RichTextLabel.new()
				add_child(newLabel)
				optionLabels.append(newLabel)
				optionLabels[n].theme = ResourceLoader.load("res://UI/InteractableTheme.tres")
				optionLabels[n].bbcode_enabled = true
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
				optionLabels[n].bbcode_text = options[n].name + " x" + str(options[n].amount)
	add_icons()

func add_icons():
	for n in range(optionCount):
		if options[n] != null:
			match options[n].type:
				"Damage":
					optionLabels[n].append_text(" [img]res://UI/Coin.png[/img]")
				"Healing":
					optionLabels[n].append_text(" [img]res://UI/Coin.png[/img]")
				"Defensive":
					optionLabels[n].append_text(" [img]res://UI/Defense.png[/img]")
				"Hazard":
					pass
				"Status":
					pass
				"Movement":
					pass
				"Creation":
					optionLabels[n].append_text(" [img]res://UI/Creation.png[/img]")

func selectOption():
	if optionCount != 0:
		FloorData.floor.Handlers.SH.interactable = options[highlightedOption]
		FloorData.floor.Handlers.SH.actingPiece = PlayerData.playerPiece
		FloorData.floor.Handlers.TH.show()
