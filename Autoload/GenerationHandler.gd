extends Node

func generateFloor():
	var layerDataHolder = GameState.currentFloor.layerData
	var imagePath : String = layerDataHolder.possibleLayouts[randi_range(0, layerDataHolder.possibleLayouts.size() - 1)]
	var heightMap = Image.load_from_file(imagePath)
	var totalTiles = []
	var totalTilesPos = []
	var tileToAdd
	
	for n in range(heightMap.get_size().x):
		for m in range(heightMap.get_size().y):
			if heightMap.get_pixel(n,m) != Color(0,0,0,1):
				tileToAdd = preload("res://Floor/Tile/Tile.tscn").instantiate()
				GameState.currentFloor.add_child(tileToAdd)
				tileToAdd.global_position = Vector3(n - int(heightMap.get_size().x / 2), tileToAdd.global_position.y, m - int(heightMap.get_size().y / 2))
				totalTiles.append(tileToAdd)
				totalTilesPos.append(tileToAdd.global_position)
	
	var blankArray = []
	var blankValue
	
	GameState.tileDict = {"Tiles" : totalTiles, "iTiles" : blankArray, "TilePos" : totalTilesPos, "hTile" : blankValue}
	
	GameState.currentFloor.add_child(PlayerData.playerPiece)

	generateEnemies()
	placePieces()

func generateEnemies():
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

func placePieces():
	var piece
	var pieceCount : int
	var amountPlaced : int
	for n in range(2):
		amountPlaced = 0
		match n:
			0:
				#piece = GameState.pieceDict["Neutral"]["Piece"]
				pieceCount = 0
			1:
				piece = GameState.pieceDict["Enemy"]["Piece"]
				pieceCount = piece.size()
		
		if pieceCount != 0:
			while (pieceCount != amountPlaced):
				var piecePos = GameState.tileDict["Tiles"][randi_range(0, GameState.tileDict["Tiles"].size() - 1)]
				if !piecePos.contains:
					piecePos.setPiece(piece[amountPlaced], DirectionHandler.dirArray[2])
					amountPlaced += 1
	
