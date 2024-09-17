extends Node

func findItemTiles(piecePos : Vector3):
	var possibleTiles = GameState.item.getItemRange(piecePos)
	var toReturn = []
	var usableOn = GameState.item.getUsable()
	for n in range(possibleTiles.size()):
		if TileHandler.lookForTile(possibleTiles[n]):
			if usableOn.has("Self") and TileHandler.lookForTile(possibleTiles[n]).contains is PlayerPiece:
				toReturn.append(TileHandler.lookForTile(possibleTiles[n]))
			elif usableOn.has("Enemy") and TileHandler.lookForTile(possibleTiles[n]).contains is EnemyPiece:
				toReturn.append(TileHandler.lookForTile(possibleTiles[n]))
			elif usableOn.has("Tile") and !TileHandler.lookForTile(possibleTiles[n]).contains:
				toReturn.append(TileHandler.lookForTile(possibleTiles[n]))
		
	return toReturn
