extends Node

func generateFloor():
	
	if !FloorData.floorInfo.isNew:
		pass
	
	var layerDataHolder = GameState.currentFloor.layerData
	var imagePath : String = layerDataHolder.possibleLayouts[randi_range(0, layerDataHolder.possibleLayouts.size() - 1)]
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
				GameState.currentFloor.add_child(tileToAdd)
				tileToAdd.global_position = Vector3(n - int(heightMap.get_size().x / 2), tileToAdd.global_position.y, m - int(heightMap.get_size().y / 2))
				totalTiles.append(tileToAdd)
				totalTilesPos.append(tileToAdd.global_position)
				if heightMap.get_pixel(n,m) == Color8(100,150,200):
					playerStarts.append(tileToAdd)
				elif heightMap.get_pixel(n,m) == Color8(200,100,100):
					enemyStarts.append(tileToAdd)
	
	GameState.tileDict = {"Tiles" : totalTiles, "iTiles" : [], "TilePos" : totalTilesPos, "hTile" : []}
	
	GameState.currentFloor.add_child(PlayerData.playerPiece)
	
	
	
	generateEnemies()
	placePieces(playerStarts, enemyStarts)

func generateEnemies():
	
	if FloorData.floorInfo.isNew:
		var enemyArray = []
		var enemyPositions : Array[Vector3]
		var behaviorArray : Array[String]
		for n in randi_range(GameState.currentFloor.layerData.minPossibleEnemies, GameState.currentFloor.layerData.maxPossibleEnemies):
			enemyArray.append(preload("res://Piece/EnemyPiece.tscn").instantiate())
			enemyArray[n].enemyType = GameState.currentFloor.layerData.possibleEnemies[
									  randi_range(0, GameState.currentFloor.layerData.possibleEnemies.size() - 1)]
			GameState.currentFloor.add_child(enemyArray[n])
			behaviorArray.append("Approach")
			enemyPositions.append(enemyArray[n].global_position)
			enemyArray[n].death.connect(GameState.currentFloor.pieceDeath)
		
		var enemyDict : Dictionary = {"Piece" : enemyArray,
									"Position" : enemyPositions,
									"Behavior" : behaviorArray}
		GameState.pieceDict["Enemy"] = enemyDict
	else:
		pass

func placePieces(playerStarts, enemyStarts):
	
	if !FloorData.floorInfo.isNew:
		TileHandler.lookForTile(PlayerData.playerInfo.currentPos).setPiece(PlayerData.playerPiece, 2)
		HighlightHandler.highlightTile(PlayerData.playerPiece.currentTile)
		
		
	else:
		playerStarts[randi_range(0, playerStarts.size() - 1)].setPiece(PlayerData.playerPiece, 2)
		HighlightHandler.highlightTile(PlayerData.playerPiece.currentTile)
		
		for n in range(GameState.pieceDict["Enemy"]["Piece"].size()):
			var tileEmpty = false
			while !tileEmpty:
				var enemyStart = enemyStarts[randi_range(0, enemyStarts.size() - 1)]
				if !enemyStart.contains:
					tileEmpty = true
					enemyStart.setPiece(GameState.pieceDict["Enemy"]["Piece"][n], 2)
	
	
					
