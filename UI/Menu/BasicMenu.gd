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
	elif Input.is_action_just_pressed("Cancel") and !hasSelectedOption:
		$AnimationPlayer.play("CloseMenu")
		await get_tree().create_timer(0.2).timeout
		get_parent().get_parent().inMenu = false
		get_parent().get_parent().viewing = true
		get_parent().get_parent().Pointer.visible = true
		queue_free()

func showMenu(sound : bool):
	visible = true
	if sound:
		$AnimationPlayer.play("OpenMenuSound")
	else:
		$AnimationPlayer.play("OpenMenu")

func addOptions(moveCheck : bool, actionCheck : bool):
	optionCount = 2
	if !moveCheck:
		optionCount += 1
	if !actionCheck:
		optionCount += 1
	var prevPos = Vector2(0,0)
	for n in range(optionCount):
		var toAdd = preload("res://UI/Menu/BasicMenuOption.tscn").instantiate()
		options.add_child(toAdd)
		if n != optionCount - 1 and n == 0:
			toAdd.SetSprite(1)
		elif n == optionCount - 1 and n != 0:
			toAdd.SetSprite(2)
			toAdd.setOptionType("End")
		elif optionCount != 1:
			toAdd.SetSprite(3)
		
		if n == optionCount - 2:
			toAdd.setOptionType("Items")
		
		match n:
			0:
				if !actionCheck:
					toAdd.setOptionType("Action")
				elif !moveCheck:
					toAdd.setOptionType("Move")
				toAdd.hoverToggle()
			1:
				if !actionCheck and !moveCheck:
					toAdd.setOptionType("Move")
		
		if n > 0 and n < optionCount - 1:
			if prevPos == Vector2(0,0):
				prevPos = Vector2(0,-22)
			else:
				prevPos += Vector2(0,-21)
		elif n == optionCount - 1:
			if optionCount == 2:
				prevPos += Vector2(0,-1)
			prevPos += Vector2(0,-26)
		toAdd.position = prevPos

func selectedOption():
	match options.get_child(highlightedOption - 1).type:
		"Move":
			$AnimationPlayer.play("SelectCloseMenu")
			await get_tree().create_timer(0.1).timeout
			get_parent().get_parent().moving = get_parent().get_parent().player
			get_parent().get_parent().inMenu = false
			get_parent().get_parent().Pointer.visible = true
			get_parent().get_parent().findMoveableTiles(get_parent().get_parent().moving, false)
			get_parent().get_parent().camera.position = Vector3(5,5,5)
			get_parent().get_parent().camera.rotation = Vector3(deg_to_rad(-40),deg_to_rad(40),0)
			queue_free()
		"Action":
			$MenuSelect.play()
			var toAdd = preload("res://UI/Menu/ActionMenu.tscn").instantiate()
			add_child(toAdd)
			toAdd.position.y += 30
			toAdd.position.x -= 4
		"End":
			$AnimationPlayer.play("SelectCloseMenu")
			await get_tree().create_timer(0.1).timeout
			get_parent().get_parent().inMenu = false
			get_parent().get_parent().endTurn()
			queue_free()
		"Items":
			$MenuSelect.play()
			var toAdd = preload("res://UI/Menu/ItemMenu.tscn").instantiate()
			toAdd.setItems(get_parent().get_parent().player.items)
			add_child(toAdd)
			toAdd.position.y += 30
			toAdd.position.x -= 4

func closeMenu():
	$AnimationPlayer.play("CloseMenu")
	await get_tree().create_timer(0.2).timeout
	if get_parent().get_parent() is PlayableArea:
		get_parent().get_parent().inMenu = false
	queue_free()
