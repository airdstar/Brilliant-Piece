extends Node

func findItemTiles(piecePos : Vector3):
	var possibleTiles = GameState.item.getItemRange(piecePos)
	var toReturn = []
	for n in range(possibleTiles.size()):
		if TileHandler.lookForTile(possibleTiles[n]):
			toReturn.append(TileHandler.lookForTile(possibleTiles[n]))
		
	return toReturn
