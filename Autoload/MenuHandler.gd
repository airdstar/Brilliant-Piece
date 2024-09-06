extends Node

func _process(_delta):
	if GameState.currentMenu:
		if Input.is_action_just_pressed("Select"):
			select()
		elif Input.is_action_just_pressed("Cancel"):
			if GameState.currentMenu is BasicMenu:
				if GameState.currentMenu.hasSelectedOption:
					GameState.currentMenu.options[GameState.currentMenu.highlightedOption - 1].selectToggle()
					GameState.currentMenu.hasSelectedOption = false
			closeMenu()
	elif Input.is_action_just_pressed("Cancel"):
		openMenu()


func openMenu():
	GameState.currentMenu = preload("res://UI/Menu/BasicMenu.tscn").instantiate()
	var menu = GameState.currentMenu
	GameState.currentFloor.menuHolder.add_child(menu)
	menu.addOptions(GameState.moveUsed, GameState.actionUsed)
	menu.position = Vector2(360,325)
	menu.showMenu(true)
	GameState.currentFloor.Pointer.visible = false
	HighlightHandler.highlightTile(GameState.playerFloorTile)

func closeMenu():
	if GameState.currentMenu is BasicMenu:
		GameState.currentMenu = null
	else:
		GameState.currentMenu = GameState.currentMenu.get_parent()

func select():
	var currentMenu = GameState.currentMenu
	if currentMenu is BasicMenu:
		currentMenu.hasSelectedOption = true
		currentMenu.options[currentMenu.highlightedOption - 1].selectToggle()
		currentMenu.selectedOption()
	elif currentMenu is ActionMenu:
		pass
		
