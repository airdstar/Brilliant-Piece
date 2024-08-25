extends Control

var highlightedOption = 0
var actions
var growing := true
var lowestOpacity := 0.1
var additionalOpacity : float
@onready var options = $Options

func _ready():
	actions = get_parent().get_parent().get_parent().player.actions
	$Options/Label.text = actions[0].name
	$Options/Label2.text = actions[1].name
	$Options/Label3.text = actions[2].name
	$Options/Label4.text = actions[3].name
	$Options/Label5.text = actions[4].name


func _process(_delta):
	if growing:
		additionalOpacity += 0.001
	else:
		additionalOpacity -= 0.001
	
	$TextureRect/Highlight.modulate = Color(1,1,1,lowestOpacity + additionalOpacity)
	
	if Input.is_action_just_pressed("Cancel"):
		queue_free()
	
	if Input.is_action_just_pressed("Forward"):
		if highlightedOption == 0:
			highlightedOption = 4
		else:
			highlightedOption -= 1
		$TextureRect/Highlight.position = Vector2(4,4 + (24 * highlightedOption))

	elif Input.is_action_just_pressed("Backward"):
		if highlightedOption == 4:
			highlightedOption = 0
		else:
			highlightedOption += 1
		$TextureRect/Highlight.position = Vector2(4,4 + (24 * highlightedOption))
	
	if Input.is_action_just_pressed("Select"):
		get_parent().get_parent().get_parent().inMenu = false
		get_parent().get_parent().get_parent().action = actions[highlightedOption]
		get_parent().get_parent().get_parent().showAction()
		get_parent().get_parent().get_parent().Pointer.visible = true
		get_parent().get_parent().get_parent().camera.position = Vector3(5,5,5)
		get_parent().get_parent().get_parent().camera.rotation = Vector3(deg_to_rad(-40),deg_to_rad(40),0)
		get_parent().queue_free()


func ToggleGrow():
	growing = !growing
