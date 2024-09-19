extends Node

var tileDict : Dictionary

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
				if allTiles[n].contains is EnemyPiece:
					allTiles[n].setColor(Global.colorDict["Orange"])
			elif GameState.item:
				allTiles[n].setColor(Global.colorDict["Green"])

func show(type : String):
	GameState.currentFloor.Pointer.visible = true
	var possibleTiles
	match type:
		"Movement":
			possibleTiles = InteractionHandler.findMoveableTiles(GameState.moving)
		"Action":
			possibleTiles = InteractionHandler.findActionTiles(PlayerData.playerInfo.currentPos)
		"Item":
			possibleTiles = InteractionHandler.findItemTiles(PlayerData.playerInfo.currentPos)
	GameState.tileDict["iTiles"] = possibleTiles
	setTilePattern()


func stopShowing():
	GameState.tileDict["iTiles"].clear()
	GameState.action = null
	GameState.moving = null
	GameState.item = null
	setTilePattern()
