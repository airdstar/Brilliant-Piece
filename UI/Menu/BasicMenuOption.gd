extends Control

var type : String
var selected := false
var hovered := false
var growing := true
var lowestOpacity := 0.1
var additionalOpacity : float
@onready var outline := $Outline
@onready var label := $Outline/Label
@onready var highlight := $Outline/Highlight

func _ready():
	outline.set_texture(load("res://UI/Menu/MenuFull.png"))
	outline.size = Vector2(96,35)
	outline.position = Vector2(-4,-1)
	label.size = Vector2(86,29)
	label.position = Vector2(4,3)
	highlight.size = Vector2(57,27)
	highlight.position = Vector2(4,4)

func _process(_delta):
	if growing:
		additionalOpacity += 0.001
	else:
		additionalOpacity -= 0.001
	
	if hovered:
		if !selected:
			highlight.modulate = Color(1,1,1,lowestOpacity + additionalOpacity)
		else:
			highlight.modulate = Color(1,1,1,0.4)

func SetSprite(num : int):
	match num:
		1:
			outline.set_texture(load("res://UI/Menu/MenuTop.png"))
			outline.size = Vector2(96,25)
			outline.flip_v = true
			outline.position = Vector2(-4,0)
			label.position = Vector2(5,-4)
			highlight.set_texture(load("res://UI/Menu/MenuTopHighlight.png"))
			highlight.flip_v = true
			highlight.size = Vector2(90,25)
			highlight.position = Vector2(3,0)
		2:
			outline.set_texture(load("res://UI/Menu/MenuTop.png"))
			outline.size = Vector2(96,25)
			outline.position = Vector2(-4,-1)
			label.position = Vector2(5,3)
			highlight.set_texture(load("res://UI/Menu/MenuTopHighlight.png"))
			highlight.size = Vector2(90,25)
			highlight.position = Vector2(3,3)
		3:
			outline.set_texture(load("res://UI/Menu/MenuMiddle.png"))
			outline.size = Vector2(96,21)
			outline.position = Vector2(-4,1)
			label.position = Vector2(5,-4)
			highlight.set_texture(load("res://UI/Menu/MenuHighlight.png"))
			highlight.size = Vector2(90,21)
			highlight.position = Vector2(3,0)

func setOptionType(optionType : String):
	type = optionType
	label.text = optionType

func hoverToggle():
	highlight.visible = !highlight.visible
	hovered = !hovered

func selectToggle():
	selected = !selected

func ToggleGrow():
	growing = !growing
