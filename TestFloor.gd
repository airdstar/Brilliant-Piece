extends PlayableArea
class_name Floor

var soulUsed : bool = false
@export var tileAmount : int

func secondaryReady():
	generateTiles()
	openMenu()
	$EnemyController.setEnemies($EnemyPiece)
	$EnemyController.setTargets($PlayerPiece)

func secondaryProcess(_delta):
	if Input.is_action_just_pressed("Test"):
		endTurn()
	
	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()

func generateTiles():
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
	randPlacePiece($PlayerPiece)
	randPlacePiece($EnemyPiece)
