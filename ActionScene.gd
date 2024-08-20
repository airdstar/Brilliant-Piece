extends PlayableArea

@onready var player := $PlayerPiece
var playerTile : tile
var enemy : EnemyPiece
var attacking : bool = false

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
			highlightTile(playerTile)
			openMenu()
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

func showAttacks():
	pass

func makeArena(x : int, z : int):
	var playerPos = randi_range(1,z - 2)
	var enemyPos = randi_range(1,z - 2)
	for n in range(x):
		for m in range(z):
			var tileToAdd = preload("res://Tile.tscn").instantiate()
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
