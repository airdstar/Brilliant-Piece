extends Node

func generateFloor():
	var totalTiles
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
	var player = GameState.playerPiece
	player = preload("res://Piece/PlayerPiece.tscn").instantiate()
	player.classType = ResourceLoader.load("res://Resources/Class Resources/CrystalSage.tres")
	player.type = ResourceLoader.load("res://Resources/PieceType Resources/Queen.tres")
	GameState.currentFloor.add_child(player)

func generateEnemies():
	var enemyArray
	for n in range(1):
		enemyArray.append(preload("res://Piece/EnemyPiece.tscn").instantiate())
		enemyArray[n].enemyType = ResourceLoader.load("res://Resources/Enemy Resources/Goblin.tres")
		GameState.currentFloor.add_child(enemyArray[n])

func placePieces():
	pass
