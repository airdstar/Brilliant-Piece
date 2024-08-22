extends Control
class_name BasicMenu

var hasSelectedOption : bool = false
var optionCount : int
var highlightedOption : int = 1
@onready var options = $Options

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("Forward") and !hasSelectedOption:
		options.get_child(highlightedOption - 1).hoverToggle()
		if highlightedOption < optionCount:
			highlightedOption += 1
		else:
			highlightedOption = 1
		options.get_child(highlightedOption - 1).hoverToggle()

	elif Input.is_action_just_pressed("Backward") and !hasSelectedOption:
		options.get_child(highlightedOption - 1).hoverToggle()
		if highlightedOption > 1:
			highlightedOption -= 1
		else:
			highlightedOption = optionCount
		options.get_child(highlightedOption - 1).hoverToggle()

	if Input.is_action_just_pressed("Select") and !hasSelectedOption:
		options.get_child(highlightedOption - 1).selectToggle()
		hasSelectedOption = true
		selectedOption()
	
	if Input.is_action_just_pressed("Cancel") and hasSelectedOption:
		options.get_child(highlightedOption - 1).selectToggle()
		hasSelectedOption = false

func showMenu(sound : bool):
	visible = true
	if sound:
		$AnimationPlayer.play("OpenMenuSound")
	else:
		$AnimationPlayer.play("OpenMenu")

func addPlayerOptions():
	optionCount = 4
	for n in range(optionCount):
		var toAdd = preload("res://Menu/BasicMenuOption.tscn").instantiate()
		options.add_child(toAdd)
		match n:
			0:
				toAdd.SetSprite(1)
				toAdd.setOptionType("Action")
				toAdd.hoverToggle()
			1:
				toAdd.SetSprite(3)
				toAdd.setOptionType("Items")
				toAdd.position = Vector2(0,-31)
			2:
				toAdd.SetSprite(3)
				toAdd.setOptionType("Move")
				toAdd.position = Vector2(0,-60)
			3:
				toAdd.SetSprite(2)
				toAdd.setOptionType("View")
				toAdd.position = Vector2(0,-91)


func selectedOption():
	match options.get_child(highlightedOption - 1).type:
		"Move":
			$AnimationPlayer.play("SelectCloseMenu")
			await get_tree().create_timer(0.1).timeout
			get_parent().get_parent().moving = get_parent().get_parent().player
			get_parent().get_parent().inMenu = false
			get_parent().get_parent().Pointer.visible = true
			get_parent().get_parent().findMoveableTiles()
			get_parent().get_parent().camera.position = Vector3(5,5,5)
			get_parent().get_parent().camera.rotation = Vector3(deg_to_rad(-40),deg_to_rad(40),0)
			queue_free()
		"Action":
			$MenuSelect.play()
			var toAdd = preload("res://Menu/ActionMenu.tscn").instantiate()
			add_child(toAdd)

func closeMenu():
	$AnimationPlayer.play("CloseMenu")
	await get_tree().create_timer(0.2).timeout
	if get_parent().get_parent() is PlayableArea:
		get_parent().get_parent().inMenu = false
	queue_free()
