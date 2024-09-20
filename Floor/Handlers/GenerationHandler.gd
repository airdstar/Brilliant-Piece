extends Handler

func generateFloor():
	if FloorData.floorInfo.isNew:
		var imagePath : String = FloorData.floorInfo.layerData.possibleLayouts[randi_range(0, FloorData.floorInfo.layerData.possibleLayouts.size() - 1)]
		var heightMap = Image.load_from_file(imagePath)
		var totalTiles = []
		var totalTilesPos = []
		var tileToAdd
		var playerStarts = []
		var enemyStarts = []
	
		for n in range(heightMap.get_size().x):
			for m in range(heightMap.get_size().y):
				if heightMap.get_pixel(n,m) != Color8(0,0,0):
					tileToAdd = preload("res://Floor/Tile/Tile.tscn").instantiate()
					FloorData.floor.add_child(tileToAdd)
					tileToAdd.global_position = Vector3(n - int(heightMap.get_size().x / 2), tileToAdd.global_position.y, m - int(heightMap.get_size().y / 2))
					totalTiles.append(tileToAdd)
					totalTilesPos.append(tileToAdd.global_position)
					if heightMap.get_pixel(n,m) == Color8(100,150,200):
						playerStarts.append(tileToAdd)
					elif heightMap.get_pixel(n,m) == Color8(200,100,100):
						enemyStarts.append(tileToAdd)
		
		mH.TH.tileDict = {"Tiles" : totalTiles, "iTiles" : [], "TilePos" : totalTilesPos, "hTile" : []}
		
		FloorData.floor.add_child(PlayerData.playerPiece)

		generateEnemies()
		placePieces(playerStarts, enemyStarts)

func generateEnemies():
	if FloorData.floorInfo.isNew:
		var enemyArray = []
		var enemyPositions : Array[Vector3]
		var behaviorArray : Array[String]
		for n in randi_range(FloorData.floorInfo.layerData.minPossibleEnemies, FloorData.floorInfo.layerData.maxPossibleEnemies):
			enemyArray.append(preload("res://Piece/EnemyPiece.tscn").instantiate())
			enemyArray[n].enemyType = FloorData.floorInfo.layerData.possibleEnemies[
									  randi_range(0, FloorData.floorInfo.layerData.possibleEnemies.size() - 1)]
			FloorData.floor.add_child(enemyArray[n])
			behaviorArray.append("Approach")
			enemyPositions.append(enemyArray[n].global_position)
			enemyArray[n].death.connect(FloorData.floor.pieceDeath)

func placePieces(playerStarts, enemyStarts):
	
	if !FloorData.floorInfo.isNew:
		mH.TH.lookForTile(PlayerData.playerInfo.currentPos).setPiece(PlayerData.playerPiece, 2)
		mH.HH.highlightTile(PlayerData.playerPiece.currentTile)
		
		
	else:
		playerStarts[randi_range(0, playerStarts.size() - 1)].setPiece(PlayerData.playerPiece, 2)
		mH.HH.highlightTile(PlayerData.playerPiece.currentTile)
		
		for n in range(FloorData.floor.enemies.size()):
			var tileEmpty = false
			while !tileEmpty:
				var enemyStart = enemyStarts[randi_range(0, enemyStarts.size() - 1)]
				if !enemyStart.contains:
					tileEmpty = true
					enemyStart.setPiece(FloorData.floor.enemies[n], 2)
