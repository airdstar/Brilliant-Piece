extends Handler

func generateFloor():
	var playerStarts = []
	var enemyStarts = []
	var hazardLocations = []
	var possibleEnds = []
	
	if FloorData.floorInfo.isNew:
		
		var heightMap : Image = FloorData.floorInfo.layerData.possibleLayouts[randi_range(0, FloorData.floorInfo.layerData.possibleLayouts.size() - 1)].get_image()
		
		
		
		
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
					FloorData.tiles[n][m].position = Vector2i(-((heightMap.get_size().x * 32) / 2) + (32 * n) + 16, -((heightMap.get_size().y * 32) / 2) + (32 * m) + 16)
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
					FloorData.tiles[n][m].position = Vector2i(-((FloorData.floorInfo.rc.x * 32) / 2) + (32 * n) + 16, -((FloorData.floorInfo.rc.y * 32) / 2) + (32 * m) + 16)
					FloorData.tiles[n][m].rc = Vector2i(n,m)
	
	mH.TH.setTilePattern()
	
	generatePieces(playerStarts, enemyStarts)
	placeHazards(hazardLocations, possibleEnds)
	
	create_outlines()
	
	mH.EH.movement.set_tile_map()
	FloorData.updateData()
	

func generatePieces(playerStarts, enemyStarts):
	FloorData.floor.add_child(PlayerData.playerPiece)
	
	if FloorData.floorInfo.isNew:
		if playerStarts.size() != 0:
			playerStarts[randi_range(0, playerStarts.size() - 1)].setPiece(PlayerData.playerPiece)
		
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
					enemyStart.setPiece(FloorData.floor.enemies[n])
			
		
	else:
		
		FloorData.tiles[PlayerData.playerInfo.rc.x][PlayerData.playerInfo.rc.y].setPiece(PlayerData.playerPiece)
		
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

func create_outlines():
	for n in range(FloorData.floorInfo.rc.x):
		for m in range(FloorData.floorInfo.rc.y):
			if FloorData.tiles[n][m] == null:
				var direction = FloorData.floor.Handlers.DH.posDict["Straight"]
				var connectedTiles = []
				for o in range(4):
					var holder = Vector2i(n,m) + direction[o]
					if holder.x < FloorData.floorInfo.rc.x and holder.y < FloorData.floorInfo.rc.y and holder.x >= 0 and holder.y >= 0:
						if FloorData.tiles[holder.x][holder.y] != null:
							connectedTiles.append(o)
				

				if connectedTiles.size() != 0:
					var spriteHolder = Sprite2D.new()
					spriteHolder.position = Vector2i(-((FloorData.floorInfo.rc.x * 32) / 2) + (32 * n) + 16, -((FloorData.floorInfo.rc.y * 32) / 2) + (32 * m) + 16)
					FloorData.floor.add_child(spriteHolder)
					match connectedTiles.size():
						1:
							spriteHolder.set_texture(load("res://Floor/Tile/OneSideOutline.png"))
							match connectedTiles[0]:
								0:
									spriteHolder.set_rotation_degrees(180)
								1:
									spriteHolder.set_rotation_degrees(90)
								3:
									spriteHolder.set_rotation_degrees(270)
						2:
							if (connectedTiles[0] + 1 != connectedTiles[1]) and (connectedTiles[0] != 0 or connectedTiles[1] != 3):
								spriteHolder.set_texture(load("res://Floor/Tile/TopBottomOutline.png"))
								if connectedTiles[0] != 0:
									spriteHolder.set_rotation_degrees(90)
							else:
								spriteHolder.set_texture(load("res://Floor/Tile/CornerOutline.png"))
								
								match connectedTiles[0]:
									0:
										spriteHolder.set_rotation_degrees(180)
										if connectedTiles[1] == 3:
											spriteHolder.set_rotation_degrees(270)
									1:
										spriteHolder.set_rotation_degrees(90)

						3:
							spriteHolder.set_texture(load("res://Floor/Tile/ThreeSideOutline.png"))
							if !connectedTiles.has(0):
								spriteHolder.set_rotation_degrees(180)
							elif !connectedTiles.has(3):
								spriteHolder.set_rotation_degrees(90)
							elif !connectedTiles.has(1):
								spriteHolder.set_rotation_degrees(270)
							
						4:
							pass
					
				
				
