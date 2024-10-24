extends enemyExtension

func get_possible_actions():
	var toReturn : Array
	
	for n in range(FloorData.floorInfo.enemies.size()):
		for m in range(FloorData.floorInfo.enemies[n].actions.size()):
			var possibleTiles : Array[tile] = FloorData.floorInfo.enemies[n].actions[m].get_relevant_tiles(FloorData.floorInfo.enemies[n].rc,2)
			for o in range(possibleTiles.size()):
				toReturn.append(FloorData.floor.enemies[n])
				toReturn.append(FloorData.floorInfo.enemies[n].actions[m])
				toReturn.append(possibleTiles[o])

	return toReturn
