extends Node

func lookForTile(pos : Vector3):
	if GameState.tileDict["TilePos"].has(pos):
		return GameState.tileDict["Tiles"][GameState.tileDict["TilePos"].find(pos)]
	return null

func setTilePattern():
	var allTiles = GameState.tileDict["Tiles"]
	for n in range(allTiles.size()):
		allTiles[n].highlight.visible = false
		if GameState.tileDict["hTile"] != allTiles[n] and !GameState.tileDict["iTiles"].has(allTiles[n]):
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor(Global.colorDict["Black"])
			else:
				allTiles[n].setColor(Global.colorDict["White"])
		if GameState.tileDict["iTiles"].has(allTiles[n]):
			if GameState.action:
				allTiles[n].setColor(Global.colorDict["Orange"])
			elif GameState.moving:
				allTiles[n].setColor(Global.colorDict["Blue"])

func show(type : String):
	GameState.currentFloor.Pointer.visible = true
	var possibleTiles
	match type:
		"Movement":
			possibleTiles = MovementHandler.findMoveableTiles(GameState.moving)
		"Action":
			possibleTiles = ActionHandler.findActionTiles(GameState.pieceDict["Player"]["Position"])
		"Item":
			possibleTiles = ItemHandler.findItemTiles(GameState.pieceDict["Player"]["Position"])
	GameState.tileDict["iTiles"] = possibleTiles
	setTilePattern()


func stopShowing():
	GameState.tileDict["iTiles"].clear()
	GameState.action = null
	GameState.moving = null
	GameState.item = null
	setTilePattern()
