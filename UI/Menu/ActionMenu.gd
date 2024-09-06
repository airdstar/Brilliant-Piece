extends Control
class_name ActionMenu

var highlightedOption = 0
var actions
var growing := true
var lowestOpacity : float = 0.1
var additionalOpacity : float = 0.0
var hasSelectedOption := false
@onready var highlight = $TextureRect/Highlight
@onready var options = $Options
@onready var actionLabels : Array[Label] = [$Options/actionLabel1, $Options/actionLabel2, $Options/actionLabel3, $Options/actionLabel4, $Options/actionLabel5]

func _ready():
	actions = GameState.playerPiece.actions
	for n in range(5):
		if actions.size() - 1 >= n:
			actionLabels[n].text = actions[n].name
		else:
			actionLabels[n].text = "- EMPTY -"

func _process(_delta):
	if growing:
		additionalOpacity += 0.001
	else:
		additionalOpacity -= 0.001
	
	$TextureRect/Highlight.modulate = Color(1,1,1,lowestOpacity + additionalOpacity)
	
	if Input.is_action_just_pressed("Cancel"):
		queue_free()
	
	if Input.is_action_just_pressed("Select"):
		if actionLabels[highlightedOption].text != "- EMPTY -":
			get_parent().get_parent().get_parent().inMenu = false
			get_parent().get_parent().get_parent().action = actions[highlightedOption]
			get_parent().get_parent().get_parent().showAction()
			get_parent().get_parent().get_parent().Pointer.visible = true
			get_parent().queue_free()

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
