extends Node

func generateFloor():
	var totalTiles = []
	for n in range(100):
		var cantPlace = true
		var tileToAdd = preload("res://Tile/Tile.tscn").instantiate()
		var allTiles = GameState.currentFloor.tileHolder.get_children()
		if allTiles.size() == 0:
			GameState.currentFloor.tileHolder.add_child(tileToAdd)
			totalTiles.append(tileToAdd)
			cantPlace = false
		while cantPlace:
			tileToAdd.position.x += randi_range(-1,1)
			tileToAdd.position.z += randi_range(-1,1)
			var goodForNow = true
			for m in range(allTiles.size()):
				if tileToAdd.position == allTiles[m].position:
					goodForNow = false
			if goodForNow:
				cantPlace = false
				GameState.currentFloor.tileHolder.add_child(tileToAdd)
				totalTiles.append(tileToAdd)
	GameState.allFloorTiles = totalTiles

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
				var piecePos = GameState.allFloorTiles[randi_range(0, GameState.allFloorTiles.size() - 1)]
				if !piecePos.contains:
					if n != 0:
						piecePos.setPiece(piece[amountPlaced])
						amountPlaced += 1
					else:
						piecePos.setPiece(piece)
						HighlightHandler.highlightTile(piecePos)
						GameState.playerFloorTile = piecePos
						amountPlaced += 1
