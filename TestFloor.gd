extends PlayableArea
class_name Floor

var soulUsed : bool = false
@export var tileAmount : int

func secondaryReady():
	generateTiles()
	player = $PlayerPiece
	openMenu()

func secondaryProcess(_delta):
	if Input.is_action_just_pressed("Select"):
		if moving and highlightedTile.moveable:
			moving.previousTile = moving.currentTile
			moving.previousTile.contains = null
			highlightedTile.setPiece(moving)
			playerTile = highlightedTile
			stopShowingMovement()
			var x = moving.currentTile.position.x - moving.previousTile.position.x
			var z = moving.currentTile.position.z - moving.previousTile.position.z
			if x > z and x > 0:
				#West
				moving.global_rotation.y = deg_to_rad(0)
			elif x < z and x < 0:
				#East
				moving.global_rotation.y = deg_to_rad(180)
			elif z > x and z > 0:
				#North
				moving.global_rotation.y = deg_to_rad(-90)
			elif z < x and z < 0:
				#South
				moving.global_rotation.y = deg_to_rad(90)
				
			moving = null
			displayInfo()
			openMenu()
			Pointer.height = highlightedTile.getPointerPos()
		elif action and highlightedTile.hittable:
			highlightedTile.actionUsed(action)
			if action.AOE != 0:
				var pos = Directions.getAllDirections()
				for n in range(8):
					var currentTile = highlightedTile.global_position
					for m in range(action.AOE):
						currentTile += Directions.getDirection(pos[n])
						if lookForTile(currentTile):
							lookForTile(currentTile).actionUsed(action)
			stopShowingAction()
			action = null
			inMenu = true
			openMenu()
	
	if Input.is_action_just_pressed("Cancel") and !soulUsed:
		if moving:
			stopShowingMovement()
			moving = null
			openMenu()
		if action:
			stopShowingAction()
			action = null
			openMenu()
	
	if !inMenu:
		if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right") or Input.is_action_just_pressed("Forward") or Input.is_action_just_pressed("Backward"):
			handleMovement()

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
