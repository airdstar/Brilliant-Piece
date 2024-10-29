extends enemyExtension

func get_possible_actions():
	var toReturn : Array
	for n in range(FloorData.floorInfo.enemies.size()):
		for m in range(FloorData.floorInfo.enemies[n].actions.size()):
			var allTiles = FloorData.floorInfo.enemies[n].actions[m].getTiles(FloorData.floorInfo.enemies[n].rc)
			var possibleTiles : Array[bool] = FloorData.floor.Handlers.TH.get_relevant_tiles(FloorData.tiles[FloorData.floorInfo.enemies[n].rc.x][FloorData.floorInfo.enemies[n].rc.y], allTiles, 2, FloorData.floorInfo.enemies[n].actions[m].type, FloorData.floorInfo.enemies[n].actions[m].AOE)
			for o in range(allTiles.size()):
				if possibleTiles[o]:
					toReturn.append(FloorData.floor.enemies[n])
					toReturn.append(FloorData.floorInfo.enemies[n].actions[m])
					toReturn.append(allTiles[o])

	return toReturn
