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
	
	generatePlayer()
	generateEnemies()
	placePieces()

func generatePlayer():
	GameState.currentFloor.add_child(PlayerData.playerPiece)
	PlayerData.playerInfo.currentPos = PlayerData.playerPiece.global_position

func generateEnemies():
	var enemyArray = []
	var enemyPositions : Array[Vector3]
	var behaviorArray : Array[String]
	for n in range(1):
		enemyArray.append(preload("res://Piece/EnemyPiece.tscn").instantiate())
		var piece = enemyArray[n]
		piece.enemyType = ResourceLoader.load("res://Resources/Enemy Resources/Goblin.tres")
		GameState.currentFloor.add_child(piece)
		behaviorArray.append("Approach")
		enemyPositions.append(piece.global_position)
		piece.death.connect(GameState.currentFloor.pieceDeath)
	
	var enemyDict : Dictionary = {"Piece" : enemyArray,
								"Position" : enemyPositions,
								"Behavior" : behaviorArray}
	GameState.pieceDict["Enemy"] = enemyDict

func placePieces():
	var piece
	var pieceCount : int
	var amountPlaced : int
	for n in range(3):
		amountPlaced = 0
		match n:
			0:
				piece = PlayerData.playerPiece
				pieceCount = 1
			1:
				#piece = GameState.pieceDict["Neutral"]["Piece"]
				pieceCount = 0
			2:
				piece = GameState.pieceDict["Enemy"]["Piece"]
				pieceCount = piece.size()
		
		if pieceCount != 0:
			while (pieceCount != amountPlaced):
				var piecePos = GameState.tileDict["Tiles"][randi_range(0, GameState.tileDict["Tiles"].size() - 1)]
				if !piecePos.contains:
					if n != 0:
						piecePos.setPiece(piece[amountPlaced], DirectionHandler.dirArray[2])
						amountPlaced += 1
					else:
						piecePos.setPiece(piece, DirectionHandler.dirArray[2])
						HighlightHandler.highlightTile(piecePos)
						amountPlaced += 1
