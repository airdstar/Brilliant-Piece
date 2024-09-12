extends Node

func lookForTile(pos : Vector3):
	if GameState.allFloorTileLocations.has(pos):
		return GameState.allFloorTiles[GameState.allFloorTileLocations.find(pos)]
	return null

func setTilePattern():
	var allTiles = GameState.allFloorTiles
	for n in range(allTiles.size()):
		allTiles[n].highlight.visible = false
		if GameState.highlightedTile != allTiles[n] and !allTiles[n].moveable and !allTiles[n].hittable:
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor("Black")
			else:
				allTiles[n].setColor("White")
		if allTiles[n].hittable or (allTiles[n].moveable and allTiles[n].contains is EnemyPiece):
			allTiles[n].setColor("Orange")

func showAction():
	var possibleTiles = GameState.action.getActionRange(GameState.playerPiece.currentTile.global_position)
	for n in range(possibleTiles.size()):
		if lookForTile(possibleTiles[n]):
			lookForTile(possibleTiles[n]).hittable = true
			lookForTile(possibleTiles[n]).setColor("Orange")

func showMovement():
	GameState.moving = GameState.playerPiece
	GameState.currentFloor.Pointer.visible = true
	var possibleMovement = MovementHandler.findMoveableTiles(GameState.moving)
	for n in range(possibleMovement.size()):
		if possibleMovement[n].contains is EnemyPiece:
			possibleMovement[n].setColor("Orange")
		else:
			possibleMovement[n].setColor("Blue")

func showItem():
	var possibleTiles = GameState.item.getItemRange(GameState.playerPiece.currentTile.global_position)
	for n in range(possibleTiles.size()):
		if lookForTile(possibleTiles[n]):
			lookForTile(possibleTiles[n]).setColor("Orange")

func stopShowing():
	var allTiles = GameState.allFloorTiles
	for n in range(allTiles.size()):
		allTiles[n].hittable = false
		allTiles[n].moveable = false
	setTilePattern()
