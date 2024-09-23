extends Handler

func generateFloor():
	var totalTiles = []
	var totalTilesPos = []
	var playerStarts = []
	var enemyStarts = []
	var hazardLocations = []
	if FloorData.floorInfo.isNew:
		var imagePath : String = FloorData.floorInfo.layerData.possibleLayouts[randi_range(0, FloorData.floorInfo.layerData.possibleLayouts.size() - 1)]
		var heightMap = Image.load_from_file(imagePath)
		var tileToAdd
		for n in range(heightMap.get_size().x):
			for m in range(heightMap.get_size().y):
				if heightMap.get_pixel(n,m) != Color8(0,0,0):
					FloorData.floorInfo.tiles.append(null)
					FloorData.floorInfo.tiles[FloorData.floorInfo.tiles.size() - 1] = TileInfo.new()
					tileToAdd = preload("res://Floor/Tile/Tile.tscn").instantiate()
					FloorData.floor.add_child(tileToAdd)
					tileToAdd.global_position = Vector3(n - int(heightMap.get_size().x / 2), tileToAdd.global_position.y, m - int(heightMap.get_size().y / 2))
					FloorData.floorInfo.tiles[FloorData.floorInfo.tiles.size() - 1].pos = tileToAdd.global_position
					totalTiles.append(tileToAdd)
					totalTilesPos.append(tileToAdd.global_position)
					if heightMap.get_pixel(n,m) == Color8(100,150,200):
						playerStarts.append(tileToAdd)
					elif heightMap.get_pixel(n,m) == Color8(200,100,100):
						enemyStarts.append(tileToAdd)
					elif heightMap.get_pixel(n,m) == Color8(100,100,100):
						hazardLocations.append(tileToAdd)
	else:
		for n in range(FloorData.floorInfo.tiles.size()):
			var tileToAdd = preload("res://Floor/Tile/Tile.tscn").instantiate()
			FloorData.floor.add_child(tileToAdd)
			tileToAdd.global_position = FloorData.floorInfo.tiles[n].pos
			totalTiles.append(tileToAdd)
			totalTilesPos.append(tileToAdd.global_position)
		
	mH.TH.tileDict = {"Tiles" : totalTiles, "iTiles" : [], "TilePos" : totalTilesPos, "hTile" : []}
	
	FloorData.floor.add_child(PlayerData.playerPiece)
	generateEnemies()
	placePieces(playerStarts, enemyStarts)
	placeHazards(hazardLocations)

func generateEnemies():
	if FloorData.floorInfo.isNew:
		for n in randi_range(FloorData.floorInfo.layerData.minPossibleEnemies, FloorData.floorInfo.layerData.maxPossibleEnemies):
			FloorData.floor.enemies.append(preload("res://Piece/EnemyPiece.tscn").instantiate())
			FloorData.floor.enemies[n].enemyType = FloorData.floorInfo.layerData.possibleEnemies[
									  randi_range(0, FloorData.floorInfo.layerData.possibleEnemies.size() - 1)]
			FloorData.floor.add_child(FloorData.floor.enemies[n])
			FloorData.floor.enemies[n].setData(n)
			FloorData.floor.enemies[n].death.connect(FloorData.floor.pieceDeath)
	else:
		for n in range(FloorData.floorInfo.enemies.size()):
			FloorData.floor.enemies.append(preload("res://Piece/EnemyPiece.tscn").instantiate())
			FloorData.floor.add_child(FloorData.floor.enemies[n])
			FloorData.floor.enemies[n].loadData(n)
			FloorData.floor.enemies[n].death.connect(FloorData.floor.pieceDeath)
			

func placePieces(playerStarts, enemyStarts):
	
	if FloorData.floorInfo.isNew:
		playerStarts[randi_range(0, playerStarts.size() - 1)].setPiece(PlayerData.playerPiece, 2)
		mH.HH.highlightTile(PlayerData.playerPiece.currentTile)
		
		for n in range(FloorData.floorInfo.enemies.size()):
			var tileEmpty = false
			while !tileEmpty:
				var enemyStart = enemyStarts[randi_range(0, enemyStarts.size() - 1)]
				if !enemyStart.contains:
					tileEmpty = true
					enemyStart.setPiece(FloorData.floor.enemies[n], 2)
	else:

		mH.TH.lookForTile(PlayerData.playerInfo.currentPos).setPiece(PlayerData.playerPiece, 2)
		mH.HH.highlightTile(PlayerData.playerPiece.currentTile)
		
		for n in range(FloorData.floorInfo.enemies.size()):
			mH.TH.lookForTile(FloorData.floorInfo.enemies[n].currentPos).setPiece(FloorData.floor.enemies[n], 2)

func placeHazards(hazardLocations):
	if FloorData.floorInfo.isNew:
		for n in range(hazardLocations.size()):
			if randi_range(0,3) == 3:
				hazardLocations[n].setHazard(FloorData.floorInfo.layerData.possibleHazards[
										 	randi_range(0, FloorData.floorInfo.layerData.possibleHazards.size() - 1)])
	else:
		for n in range(FloorData.floorInfo.tiles.size()):
			if FloorData.floorInfo.tiles[n].hazard:
				FloorData.floor.Handlers.TH.tileDict["Tiles"][n].setHazard(FloorData.floorInfo.tiles[n].hazard)
