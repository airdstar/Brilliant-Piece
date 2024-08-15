extends PlayableArea

@onready var player := $PlayerPiece
var enemy : PlayablePiece

func secondaryReady():
	inMenu = true
	makeArena(9,9)

func secondaryProcess(_delta):
	if !inMenu:
		if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right") or Input.is_action_just_pressed("Forward") or Input.is_action_just_pressed("Backward"):
			handleMovement()

func cameraControls():
	pass

func displayInfo():
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
					highlightTile(tileToAdd)
			elif n == x - 2:
				if m == enemyPos:
					tileToAdd.setPiece(enemy)

