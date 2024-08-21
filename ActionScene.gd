extends PlayableArea

var player : PlayerPiece
var playerTile : tile
var enemy : EnemyPiece
var attack : AttackResource

func secondaryReady():
	inMenu = true
	makeArena(9,9)

func secondaryProcess(_delta):
	if Input.is_action_just_pressed("Cancel"):
		if moving[0]:
			stopShowingMovement()
			moving[0] = false
			moving[1] = null
			inMenu = true
			Pointer.visible = false
			highlightTile(playerTile)
			openMenu()
			camera.position = Vector3(-0.5,1,2)
			camera.rotation = Vector3(0,0,0)
		elif attack:
			stopShowingAttack()
			attack = null
			inMenu = true
			Pointer.visible = false
			openMenu()
			highlightTile(playerTile)
			camera.position = Vector3(-0.5,1,2)
			camera.rotation = Vector3(0,0,0)
	
	if Input.is_action_just_pressed("Select"):
		if highlightedTile.moveable:
			moving[1].previousTile = moving[1].currentTile
			moving[1].previousTile.contains = null
			highlightedTile.setPiece(moving[1])
			playerTile = highlightedTile
			stopShowingMovement()
			var x = moving[1].currentTile.position.x - moving[1].previousTile.position.x
			var z = moving[1].currentTile.position.z - moving[1].previousTile.position.z
			if x > z and x > 0:
				#West
				moving[1].global_rotation.y = deg_to_rad(0)
			elif x < z and x < 0:
				#East
				moving[1].global_rotation.y = deg_to_rad(180)
			elif z > x and z > 0:
				#North
				moving[1].global_rotation.y = deg_to_rad(-90)
			elif z < x and z < 0:
				#South
				moving[1].global_rotation.y = deg_to_rad(90)
			moving[0] = false
			moving[1] = null
			Pointer.height = highlightedTile.getPointerPos()
			attack = null
			inMenu = true
			Pointer.visible = false
			openMenu()
			camera.position = Vector3(-0.5,1,2)
			camera.rotation = Vector3(0,0,0)
		elif highlightedTile.attackable:
			highlightedTile.attack(attack)
			stopShowingAttack()
			attack = null
			inMenu = true
			Pointer.visible = false
			openMenu()
			highlightTile(playerTile)
			camera.position = Vector3(-0.5,1,2)
			camera.rotation = Vector3(0,0,0)
	
	if !inMenu:
		if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right") or Input.is_action_just_pressed("Forward") or Input.is_action_just_pressed("Backward"):
			handleMovement()

func displayInfo():
	pass

func openMenu():
	menu = preload("res://Menu/BasicMenu.tscn").instantiate()
	menu.scale = Vector2(1.8,1.8)
	$Menu.add_child(menu)
	menu.addActionOptions()
	menu.position = Vector2(0, 400)
	menu.showMenu(false)

func showAttack():
	var directions
	var pos
	if attack.attackDirection == "Straight":
		directions = 4
		pos = Directions.getAllStraight()
	elif attack.attackDirection == "Diagonal":
		directions = 4
		pos = Directions.getAllDiagonal()
	elif attack.attackDirection == "Both":
		directions = 8
		pos = Directions.getAllDirections()
	for n in range(directions):
		var tileData : Vector3 = playerTile.global_position
		var blocked = false
		for m in range(attack.attackRange):
			tileData += Directions.getDirection(pos[n])
			if attack.rangeExclusive and m != attack.attackRange - 1:
				pass
			else:
				if lookForTile(tileData):
					setAttackable(lookForTile(tileData))

func stopShowingAttack():
	var allTiles = $Tiles.get_children()
	for n in range(allTiles.size()):
		allTiles[n].attackable = false
		if allTiles[n] == highlightedTile:
			allTiles[n].setColor("Blue")
			
		else:
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor("Black")
			else:
				allTiles[n].setColor("White")

func setAttackable(attackableTile : tile):
	attackableTile.attackable = true
	attackableTile.setColor("Red")

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
