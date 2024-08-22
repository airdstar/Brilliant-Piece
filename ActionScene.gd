extends PlayableArea

var enemy : EnemyPiece

func secondaryReady():
	inMenu = true
	enemy.death.connect(self.enemyDeath)
	player.death.connect(self.playerDeath)
	makeArena(9,9)

func secondaryProcess(_delta):
	if Input.is_action_just_pressed("Cancel"):
		if moving:
			stopShowingMovement()
			moving = null
			inMenu = true
			Pointer.visible = false
			highlightTile(playerTile)
			openMenu()
			camera.position = Vector3(-0.5,1,2)
			camera.rotation = Vector3(0,0,0)
		elif action:
			stopShowingAction()
			action = null
			inMenu = true
			Pointer.visible = false
			openMenu()
			highlightTile(playerTile)
			camera.position = Vector3(-0.5,1,2)
			camera.rotation = Vector3(0,0,0)
	
	if Input.is_action_just_pressed("Select"):
		if highlightedTile.moveable:
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
			Pointer.height = highlightedTile.getPointerPos()
			action = null
			inMenu = true
			Pointer.visible = false
			openMenu()
			camera.position = Vector3(-0.5,1,2)
			camera.rotation = Vector3(0,0,0)
			get_parent().get_parent().updateHUD(player, enemy)
		elif highlightedTile.hittable:
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
			Pointer.visible = false
			openMenu()
			highlightTile(playerTile)
			camera.position = Vector3(-0.5,1,2)
			camera.rotation = Vector3(0,0,0)
			get_parent().get_parent().updateHUD(player, enemy)
	
	if !inMenu:
		if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right") or Input.is_action_just_pressed("Forward") or Input.is_action_just_pressed("Backward"):
			handleMovement()

func displayInfo():
	pass


func makeArena(x : int, z : int):
	var playerPos = randi_range(1,z - 2)
	var enemyPos = randi_range(1,z - 2)
	for n in range(x):
		for m in range(z):
			var tileToAdd = preload("res://Tile/Tile.tscn").instantiate()
			$Tiles.add_child(tileToAdd)
			tileToAdd.position = Vector3(x/2 - n, 0, z/2 - m)
			if n == 1:
				if m == playerPos:
					tileToAdd.setPiece(player)
					playerTile = tileToAdd
					highlightTile(tileToAdd)
					
			elif n == x - 2:
				if m == enemyPos:
					tileToAdd.setPiece(enemy)

func enemyDeath():
	enemy.queue_free()
	get_parent().get_parent().get_parent().get_parent().inCombat = false
	get_parent().get_parent().queue_free()
