extends Node

func lookForTile(pos : Vector3):
	var allTiles = GameState.allFloorTiles
	for n in range(allTiles.size()):
		if allTiles[n].global_position == pos:
			return allTiles[n]
	return null
