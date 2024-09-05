extends Node

func _process(_delta):
	if GameState.currentMenu:
		if Input.is_action_just_pressed("Select"):
			pass
		elif Input.is_action_just_pressed("Cancel"):
			pass


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
	pass
