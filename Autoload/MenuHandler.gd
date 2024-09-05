extends Node

func openMenu():
	GameState.currentMenu = preload("res://UI/Menu/BasicMenu.tscn").instantiate()
	$Menu.add_child(menu)
	menu.addOptions(moveUsed, actionUsed)
	menu.position = Vector2(360,325)
	menu.showMenu(true)
	Pointer.visible = false
	highlightTile(playerTile)
