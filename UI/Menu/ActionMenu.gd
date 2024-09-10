extends Menu
class_name ActionMenu

var growing := true
var lowestOpacity : float = 0.1
var additionalOpacity : float = 0.0
@onready var highlight = $TextureRect/Highlight
@onready var actionLabels : Array[Label] = [$Options/actionLabel1, $Options/actionLabel2,
											$Options/actionLabel3, $Options/actionLabel4,
											$Options/actionLabel5]

func addOptions():
	optionCount = 5
	options = GameState.playerPiece.actions
	for n in range(optionCount):
		if options.size() - 1 >= n:
			if options[n] != null:
				actionLabels[n].text = options[n].name
			else:
				actionLabels[n].text = "- EMPTY -"
		else:
			options.append(null)
			actionLabels[n].text = "- EMPTY -"

func _process(_delta):
	if growing:
		additionalOpacity += 0.001
	else:
		additionalOpacity -= 0.001
	
	$TextureRect/Highlight.modulate = Color(1,1,1,lowestOpacity + additionalOpacity)
	

func selectOption():
	if options[highlightedOption] != null:
		GameState.action = options[highlightedOption]
		TileHandler.showAction()
		GameState.currentFloor.Pointer.visible = true
		MenuHandler.fullyCloseMenu()

func hoverToggle():
	match highlightedOption:
		0:
			highlight.flip_v = false
			highlight.texture = load("res://UI/Menu/AttackMenuTopHighlight.png")
			highlight.position = Vector2(3,3)
		1:
			highlight.texture = load("res://UI/Menu/AttackMenuHighlight.png")
			highlight.position = Vector2(3,28)
		2:
			highlight.position = Vector2(3,52)
		3:
			highlight.flip_v = false
			highlight.texture = load("res://UI/Menu/AttackMenuHighlight.png")
			highlight.position = Vector2(3,76)
		4:
			highlight.flip_v = true
			highlight.texture = load("res://UI/Menu/AttackMenuTopHighlight.png")
			highlight.position = Vector2(3,99)

func ToggleGrow():
	growing = !growing
