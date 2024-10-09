extends Handler

func generateFloor():
	var playerStarts = []
	var enemyStarts = []
	var hazardLocations = []
	var possibleEnds = []
	
	if FloorData.floorInfo.isNew:
		var heightMap = Image.load_from_file(FloorData.floorInfo.layerData.possibleLayouts[randi_range(0, FloorData.floorInfo.layerData.possibleLayouts.size() - 1)])
		
		FloorData.floorInfo.rc = Vector2i(heightMap.get_size().x, heightMap.get_size().y)
		
		for n in range(heightMap.get_size().x):
			FloorData.floorInfo.tileInfo.append([])
			FloorData.tiles.append([])
			for m in range(heightMap.get_size().y):
				FloorData.floorInfo.tileInfo[n].append(null)
				FloorData.tiles[n].append(null)
				
				if heightMap.get_pixel(n,m) != Color8(0,0,0):
					
					FloorData.floorInfo.tileInfo[n][m] = TileInfo.new()
				
					FloorData.tiles[n][m] = preload("res://Floor/Tile/Tile.tscn").instantiate()
					FloorData.floor.add_child(FloorData.tiles[n][m])
					var scalar = 1
					FloorData.tiles[n][m].set_scale(Vector2(scalar, scalar))
					FloorData.tiles[n][m].position = Vector2i(200 + (32 * scalar) * n, (32 * scalar) * m)
					FloorData.tiles[n][m].rc = Vector2i(n,m)
					
					if heightMap.get_pixel(n,m) != Color8(255,255,255):
						match heightMap.get_pixel(n,m):
							Color8(100,150,200):
								playerStarts.append(FloorData.tiles[n][m])
							Color8(200,100,100):
								enemyStarts.append(FloorData.tiles[n][m])
							Color8(100,100,100):
								hazardLocations.append(FloorData.tiles[n][m])
							Color8(200,200,200):
								possibleEnds.append(FloorData.tiles[n][m])
	else:
		for n in range(FloorData.floorInfo.rc.x):
			FloorData.tiles.append([])
			for m in range(FloorData.floorInfo.rc.y):
				FloorData.tiles[n].append(null)
				if FloorData.floorInfo.tileInfo[n][m] != null:
					FloorData.tiles[n][m] = preload("res://Floor/Tile/Tile.tscn").instantiate()
					FloorData.floor.add_child(FloorData.tiles[n][m])
					FloorData.tiles[n][m].position = Vector2i(200 + 32 * n, 32 * m)
					FloorData.tiles[n][m].rc = Vector2i(n,m)
	
	mH.TH.setTilePattern()
	
	generatePieces(playerStarts, enemyStarts)
	placeHazards(hazardLocations, possibleEnds)
	mH.EH.movement.set_tile_map()
	FloorData.updateData()
	

func generatePieces(playerStarts, enemyStarts):
	FloorData.floor.add_child(PlayerData.playerPiece)
	
	if FloorData.floorInfo.isNew:
		
		playerStarts[randi_range(0, playerStarts.size() - 1)].setPiece(PlayerData.playerPiece, 2)
		
		for n in randi_range(FloorData.floorInfo.layerData.minPossibleEnemies, FloorData.floorInfo.layerData.maxPossibleEnemies):
			FloorData.floor.enemies.append(preload("res://Piece/EnemyPiece.tscn").instantiate())
			FloorData.floor.enemies[n].enemyType = FloorData.floorInfo.layerData.possibleEnemies[
									  randi_range(0, FloorData.floorInfo.layerData.possibleEnemies.size() - 1)]
			FloorData.floor.add_child(FloorData.floor.enemies[n])
			FloorData.floor.enemies[n].setData(n)
			
			var tileEmpty = false
			while !tileEmpty:
				var enemyStart = enemyStarts[randi_range(0, enemyStarts.size() - 1)]
				if !enemyStart.contains:
					tileEmpty = true
					enemyStart.setPiece(FloorData.floor.enemies[n], 2)
			
		
	else:
		
		FloorData.tiles[PlayerData.playerInfo.rc.x][PlayerData.playerInfo.rc.y].setPiece(PlayerData.playerPiece, 2)
		
		for n in range(FloorData.floorInfo.enemies.size()):
			FloorData.floor.enemies.append(preload("res://Piece/EnemyPiece.tscn").instantiate())
			FloorData.floor.add_child(FloorData.floor.enemies[n])
			FloorData.floor.enemies[n].loadData(n)
			FloorData.tiles[FloorData.floorInfo.enemies[n].rc.x][FloorData.floorInfo.enemies[n].rc.y].setPiece(FloorData.floor.enemies[n], 2)
		
		

func placeHazards(hazardLocations, endLocations):
	if FloorData.floorInfo.isNew:
		for n in range(hazardLocations.size()):
			if randi_range(0,3) == 3:
				hazardLocations[n].setHazard(FloorData.floorInfo.layerData.possibleHazards[
										 	randi_range(0, FloorData.floorInfo.layerData.possibleHazards.size() - 1)])
		endLocations[0].setHazard(ResourceLoader.load("res://Resources/Hazard Resources/FloorEnd.tres"))
	else:
		for n in range(FloorData.floorInfo.rc.x):
			for m in range(FloorData.floorInfo.rc.y):
				if FloorData.floorInfo.tileInfo[n][m] != null:
					if FloorData.floorInfo.tileInfo[n][m].hazard:
						FloorData.tiles[n][m].setHazard(FloorData.floorInfo.tileInfo[n][m].hazard)
