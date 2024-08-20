extends Control

var highlightedOption = 0
var attacks 
@onready var options = $Options

func _ready():
	attacks = get_parent().get_parent().get_parent().player.attacks
	$Options/Label.text = attacks[0].name
	$Options/Label2.text = attacks[1].name
	$Options/Label3.text = attacks[2].name
	$Options/Label4.text = attacks[3].name
	$Options/Label5.text = attacks[4].name


func _process(_delta):
	if Input.is_action_just_pressed("Cancel"):
		queue_free()
	
	if Input.is_action_just_pressed("Forward"):
		if highlightedOption < 5:
			highlightedOption += 1
		else:
			highlightedOption = 0

	elif Input.is_action_just_pressed("Backward"):
		if highlightedOption > 0:
			highlightedOption -= 1
		else:
			highlightedOption = 4
	
	if Input.is_action_just_pressed("Select"):
		get_parent().get_parent().get_parent().inMenu = false
		get_parent().queue_free()
