extends Node

func _process(_delta):
	if GameState.currentMenu != null:
		if Input.is_action_just_pressed("Select"):
			GameState.currentMenu.selectOption()
		elif Input.is_action_just_pressed("Cancel"):
			if GameState.currentMenu is BasicMenu:
				if GameState.currentMenu.hasSelectedOption:
					GameState.currentMenu.options[GameState.currentMenu.highlightedOption - 1].selectToggle()
					GameState.currentMenu.hasSelectedOption = false
				else:
					closeMenu()
			else:
				closeMenu()
	elif Input.is_action_just_pressed("Cancel"):
		if GameState.playerTurn:
			TileHandler.stopShowing()
			openMenu()

func openMenu():
	if GameState.currentMenu == null:
		GameState.currentMenu = preload("res://UI/Menu/BasicMenu.tscn").instantiate()
		GameState.currentFloor.menuHolder.add_child(GameState.currentMenu)
		GameState.currentFloor.Pointer.visible = false
		HighlightHandler.highlightTile(GameState.playerFloorTile)

func closeMenu():
	GameState.currentMenu.animation.play("CloseMenu")
	await get_tree().create_timer(0.2).timeout
	var holder = GameState.currentMenu
	if holder != null:
		if GameState.currentMenu.get_parent() is Menu:
			GameState.currentMenu = GameState.currentMenu.get_parent()
			GameState.currentMenu.hasSelectedOption = false
			GameState.currentMenu.options[GameState.currentMenu.highlightedOption].selectToggle()
		else:
			GameState.currentFloor.Pointer.visible = true
		holder.queue_free()

func fullyCloseMenu():
	while GameState.currentMenu != null:
		if !GameState.currentMenu.get_parent() is Menu:
			GameState.currentMenu.animation.play("SelectCloseMenu")
			await get_tree().create_timer(0.1).timeout
			if GameState.currentMenu != null:
				GameState.currentMenu.queue_free()
				GameState.currentMenu = null
		else:
			GameState.currentMenu = GameState.currentMenu.get_parent()
	GameState.currentFloor.Pointer.visible = true

func unselect():
	var currentMenu = GameState.currentMenu
	if currentMenu is BasicMenu:
		if currentMenu.hasSelectedOption:
			currentMenu.hasSelectedOption = false
			currentMenu.options[currentMenu.highlightedOption].selectToggle()
		currentMenu.selectedOption()
