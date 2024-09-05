extends Node

func generateFloor():
	var totalTiles
	for n in range(100):
		var cantPlace = true
		var tileToAdd = preload("res://Tile/Tile.tscn").instantiate()
		var allTiles = GameState.currentFloor.tileHolder.get_children()
		if allTiles.size() == 0:
			GameState.currentFloor.tileHolder.add_child(tileToAdd)
			totalTiles.append(tileToAdd)
			cantPlace = false
		while cantPlace:
			tileToAdd.position.x += randi_range(-1,1)
			tileToAdd.position.z += randi_range(-1,1)
			var goodForNow = true
			for m in range(allTiles.size()):
				if tileToAdd.position == allTiles[m].position:
					goodForNow = false
			if goodForNow:
				cantPlace = false
				GameState.currentFloor.tileHolder.add_child(tileToAdd)
				totalTiles.append(tileToAdd)
	GameState.allFloorTiles = totalTiles

func lookForTile(pos : Vector3):
	var allTiles = GameState.allFloorTiles
	for n in range(allTiles.size()):
		if allTiles[n].global_position == pos:
			return allTiles[n]
	return null
