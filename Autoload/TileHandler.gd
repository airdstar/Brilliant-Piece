extends Node

func lookForTile(pos : Vector3):
	var allTiles = GameState.allFloorTiles
	for n in range(allTiles.size()):
		if allTiles[n].global_position == pos:
			return allTiles[n]
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
	var possibleTile = GameState.action.getActionRange(GameState.playerPiece.currentTile.global_position)
	for n in range(possibleTile.size()):
		if lookForTile(possibleTile[n]):
			lookForTile(possibleTile[n]).hittable = true
			lookForTile(possibleTile[n]).setColor("Orange")

func showMovement():
	var possibleMovement = MovementHandler.findMoveableTiles(GameState.moving)
	for n in range(possibleMovement.size()):
		if possibleMovement[n].contains is EnemyPiece:
			possibleMovement[n].setColor("Orange")
		else:
			possibleMovement[n].setColor("Blue")

func stopShowing():
	var allTiles = GameState.allFloorTiles
	for n in range(allTiles.size()):
		allTiles[n].hittable = false
		allTiles[n].moveable = false
		if allTiles[n] == GameState.highlightedTile:
			allTiles[n].setColor("Gray")
		else:
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor("Black")
			else:
				allTiles[n].setColor("White")
