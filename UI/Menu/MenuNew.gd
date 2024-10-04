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

func setOptions():
	highlightedOption = 0
	optionLabels.clear()
	if currentTab == 0:
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
			
			
			
