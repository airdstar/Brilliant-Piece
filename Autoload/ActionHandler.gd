extends Node

func _process(_delta: float):
	if GameState.action != null:
		if Input.is_action_just_pressed("Select"):
			if GameState.tileDict["iTiles"].has(GameState.tileDict["hTile"]):
				useAction(GameState.tileDict["hTile"])

func useAction(destination : tile):
	destination.actionUsed(GameState.action)
	TileHandler.stopShowing()

	TileHandler.setTilePattern()
	GameState.action = null
	InterfaceHandler.usedAction()
	if GameState.playerTurn:
		MenuHandler.openMenu()

func findActionTiles(piecePos : Vector3):
	var possibleTiles = GameState.action.getActionRange(piecePos)
	var toReturn = []
	for n in range(possibleTiles.size()):
		if TileHandler.lookForTile(possibleTiles[n]):
			toReturn.append(TileHandler.lookForTile(possibleTiles[n]))
	return toReturn
