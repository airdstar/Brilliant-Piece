extends Node

func generateFloor():
	var imagePath : String = "res://Tile/Generation attempt.png"
	var heightMap = Image.load_from_file(imagePath)
	var totalTiles = []
	var totalTilesPos = []
	var tileToAdd
	
	for n in range(heightMap.get_size().x):
		for m in range(heightMap.get_size().y):
			if heightMap.get_pixel(n,m) != Color(0,0,0,1):
				tileToAdd = preload("res://Tile/Tile.tscn").instantiate()
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
	var player
	player = preload("res://Piece/PlayerPiece.tscn").instantiate()
	player.classType = ResourceLoader.load("res://Resources/Class Resources/CrystalSage.tres")
	player.type = ResourceLoader.load("res://Resources/PieceType Resources/Queen.tres")
	GameState.currentFloor.add_child(player)
	GameState.playerPiece = player

func generateEnemies():
	var enemyArray = GameState.enemyPieces
	for n in range(1):
		enemyArray.append(preload("res://Piece/EnemyPiece.tscn").instantiate())
		enemyArray[n].enemyType = ResourceLoader.load("res://Resources/Enemy Resources/Goblin.tres")
		GameState.currentFloor.add_child(enemyArray[n])

func placePieces():
	var piece
	var pieceCount : int
	var amountPlaced : int
	for n in range(3):
		amountPlaced = 0
		match n:
			0:
				piece = GameState.playerPiece
				pieceCount = 1
			1:
				piece = GameState.neutralPieces
				pieceCount = piece.size()
			2:
				piece = GameState.enemyPieces
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
