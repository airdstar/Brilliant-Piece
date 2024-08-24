extends PlayableArea
class_name Floor

var soulUsed : bool = false
@export var tileAmount : int

func secondaryReady():
	generateTiles()
	player = $PlayerPiece
	openMenu()

func secondaryProcess(_delta):
	if Input.is_action_just_pressed("Test"):
		endTurn()
		changeTurn()

func generateTiles():
	var playerPos = randi_range(0, tileAmount - 1)
	var enemyPos = randi_range(0, tileAmount - 1)
	for n in range(tileAmount):
		var cantPlace = true
		var tileToAdd = preload("res://Tile/Tile.tscn").instantiate()
		var allTiles = $Tiles.get_children()
		if allTiles.size() == 0:
			$Tiles.add_child(tileToAdd)
			
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
				$Tiles.add_child(tileToAdd)
				if n == playerPos:
					tileToAdd.setPiece($PlayerPiece)
					highlightTile(tileToAdd)
					playerTile = highlightedTile
				elif n == enemyPos:
					tileToAdd.setPiece($EnemyPiece)
