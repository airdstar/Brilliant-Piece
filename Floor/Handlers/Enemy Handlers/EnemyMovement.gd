extends enemyExtension

var grid : ACG = ACG.new()

func set_tile_map():
	grid.create_new_grid(FloorData.floorInfo.rc)

func get_best_movements():
	var toReturn : Array[tile]
	for n in range(FloorData.floor.enemies.size()):
		grid.set_info(FloorData.floor.enemies[n])
		var possibleMovements = FloorData.floor.enemies[n].type.getMoveableTiles(FloorData.floor.enemies[n].rc)
		var smallestDistance = grid.get_path_length(FloorData.floor.enemies[n].rc, PlayerData.playerInfo.rc)
		toReturn.append(FloorData.tiles[FloorData.floor.enemies[n].rc.x][FloorData.floor.enemies[n].rc.y])
		for m in range(possibleMovements.size()):
			var currentDistance = grid.get_path_length(possibleMovements[m].rc, PlayerData.playerInfo.rc)
			if smallestDistance > currentDistance:
				smallestDistance = currentDistance
				toReturn[n] = FloorData.tiles[possibleMovements[m].rc.x][possibleMovements[m].rc.y]
	return toReturn
