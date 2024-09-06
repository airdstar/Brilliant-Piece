extends Control
class_name BasicMenu

var hasSelectedOption : bool = false
var optionCount : int
var highlightedOption : int = 0
var options = []
@onready var optionHolder = $Options

func _ready():
	pass

func _process(_delta):
	
	if Input.is_action_just_pressed("Cancel") and hasSelectedOption:
		options.get_child(highlightedOption).selectToggle()
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
		options.append(toAdd)
		optionHolder.add_child(toAdd)
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
	match options[highlightedOption].type:
		"Move":
			$AnimationPlayer.play("SelectCloseMenu")
			await get_tree().create_timer(0.1).timeout
			GameState.moving = GameState.playerPiece
			GameState.currentFloor.Pointer.visible = true
			get_parent().get_parent().findMoveableTiles(GameState.moving, false)
			queue_free()
		"Action":
			$MenuSelect.play()
			var toAdd = preload("res://UI/Menu/ActionMenu.tscn").instantiate()
			GameState.currentMenu = toAdd
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
