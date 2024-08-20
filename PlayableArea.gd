extends Node
class_name PlayableArea

var mouse_sensitivity := 0.0005
var twist : float
var inMenu : bool = false
var menu
var moving = [false,MoveablePiece]
var highlightedTile : tile
@onready var Pointer = $Pointer
@onready var camera = $Twist/Camera3D

func _ready():
	secondaryReady()
	setTilePattern()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func secondaryReady():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
	
	secondaryProcess(_delta)
	cameraControls()

func secondaryProcess(_delta):
	pass

func cameraControls():
	$Twist.rotate_y(twist)
	twist = 0

func setTilePattern():
	var allTiles = $Tiles.get_children()
	for n in range(allTiles.size()):
		if highlightedTile != allTiles[n] and !allTiles[n].moveable:
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor("Black")
			else:
				allTiles[n].setColor("White")

func highlightTile(tileToSelect : tile):
	highlightedTile = tileToSelect
	setTilePattern()
	Pointer.position.x = highlightedTile.position.x
	Pointer.position.z = highlightedTile.position.z
	Pointer.height = highlightedTile.getPointerPos()
	$Twist.position.x = Pointer.position.x
	$Twist.position.z = Pointer.position.z
	if highlightedTile.moveable:
		if highlightedTile.contains is EnemyPiece:
			highlightedTile.setColor("Red")
			Pointer.setColor("Red")
		else:
			highlightedTile.setColor("Green")
			Pointer.setColor("Green")
	else:
		highlightedTile.setColor("Blue")
		Pointer.setColor("Blue")
	
	displayInfo()

func displayInfo():
	if highlightedTile.contains:
		$StaticHUD/Portrait.visible = true
		var portraitPic = highlightedTile.contains.duplicate()
		$StaticHUD/SubViewport/Portrait.add_child(portraitPic)
		portraitPic.global_position = $StaticHUD/SubViewport/Portrait.global_position
		portraitPic.global_rotation.y = deg_to_rad(-90)
		$StaticHUD/PortraitBackground.texture = $StaticHUD/SubViewport.get_texture()
		$StaticHUD/PortraitBackground.visible = true
		if highlightedTile.contains is MoveablePiece:
			$StaticHUD/Portrait/Status/NameLabel.text = highlightedTile.contains.pieceName
			$StaticHUD/Portrait/Status/TypeLabel.text = highlightedTile.contains.type
			$StaticHUD/Portrait/Status/LevelLabel.text = "Enemy lvl " + str(highlightedTile.contains.level)
			$StaticHUD/Portrait/Status/PointLabel.text = "HP: " + str(highlightedTile.contains.health) + "/" + str(highlightedTile.contains.maxHealth)
			if highlightedTile.contains is PlayerPiece:
				$StaticHUD/Portrait/Status/LevelLabel.text = str(highlightedTile.contains.classType.className) + " lvl " + str(highlightedTile.contains.level)
				$StaticHUD/Portrait/Status/PointLabel.text = "HP: " + str(highlightedTile.contains.health) + "/" + str(highlightedTile.contains.maxHealth) + "        SP: " + str(highlightedTile.contains.soul) + "/" + str(highlightedTile.contains.maxSoul)
	else:
		if $StaticHUD/SubViewport/Portrait.get_child_count() == 2:
			$StaticHUD/SubViewport/Portrait.remove_child($StaticHUD/SubViewport/Portrait.get_child(1))
		$StaticHUD/PortraitBackground.visible = false
		$StaticHUD/Portrait.visible = false

func stopShowingMovement():
	var allTiles = $Tiles.get_children()
	for n in range(allTiles.size()):
		allTiles[n].moveable = false
		if allTiles[n] == highlightedTile:
			allTiles[n].setColor("Blue")
			Pointer.setColor("Blue")
		else:
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor("Black")
			else:
				allTiles[n].setColor("White")

func setMoveable(moveableTile : tile):
	moveableTile.moveable = true
	if moveableTile.contains is EnemyPiece:
		moveableTile.setColor("Red")
	else:
		moveableTile.setColor("Green")

func lookForTile(pos : Vector3):
	var toReturn = [null, false]
	var allTiles = $Tiles.get_children()
	for n in range(allTiles.size()):
		if allTiles[n].global_position == pos:
			toReturn[0] = allTiles[n]
			toReturn[1] = true
	return toReturn

func travelTo(destination : tile):
	pass

func findMoveableTiles():
	match highlightedTile.contains.type:
		"Pawn":
			for n in range(4):
				var tileData
				match n:
					0:
						tileData = lookForTile(highlightedTile.global_position + Vector3(1,0,0))
					1:
						tileData = lookForTile(highlightedTile.global_position + Vector3(-1,0,0))
					2:
						tileData = lookForTile(highlightedTile.global_position + Vector3(0,0,1))
					3:
						tileData = lookForTile(highlightedTile.global_position + Vector3(0,0,-1))
				
				if tileData[1]:
					setMoveable(tileData[0])
		"Rook":
			for n in range(4):
				var CheckTile = highlightedTile
				var canContinue = true
				var pos : Vector3
				match n:
					0:
						pos = Vector3(1,0,0)
					1:
						pos = Vector3(-1,0,0)
					2:
						pos = Vector3(0,0,1)
					3:
						pos = Vector3(0,0,-1)
				for m in range(3):
					var tileData = lookForTile(CheckTile.global_position + pos)
					if tileData[1] and canContinue:
						setMoveable(tileData[0])
						CheckTile = tileData[0]
						if tileData[0].contains is MoveablePiece:
							canContinue = false
		"Bishop":
			for n in range(4):
				var CheckTile = highlightedTile
				var canContinue = true
				var pos : Vector3
				match n:
					0:
						pos = Vector3(1,0,1)
					1:
						pos = Vector3(-1,0,1)
					2:
						pos = Vector3(1,0,-1)
					3:
						pos = Vector3(-1,0,-1)
				for m in range(3):
					var tileData = lookForTile(CheckTile.global_position + pos)
					if tileData[1] and canContinue:
						setMoveable(tileData[0])
						CheckTile = tileData[0]
						if tileData[0].contains is MoveablePiece:
							canContinue = false
		"Knight":
			for n in range(4):
				var CheckTile = highlightedTile.global_position
				var pos : Vector3
				var tileData
				match n:
					0:
						pos = Vector3(1,0,0)
					1:
						pos = Vector3(-1,0,0)
					2:
						pos = Vector3(0,0,1)
					3:
						pos = Vector3(0,0,-1)
				CheckTile += pos
				if pos.x == 0:
					tileData = lookForTile(CheckTile + pos + Vector3(1,0,0))
					if tileData[1]:
						setMoveable(tileData[0])
					tileData = lookForTile(CheckTile + pos + Vector3(-1,0,0))
					if tileData[1]:
						setMoveable(tileData[0])
				else:
					tileData = lookForTile(CheckTile + pos + Vector3(0,0,1))
					if tileData[1]:
						setMoveable(tileData[0])
					tileData = lookForTile(CheckTile + pos + Vector3(0,0,-1))
					if tileData[1]:
						setMoveable(tileData[0])
		"Queen":
			for n in range(8):
				var CheckTile = highlightedTile
				var canContinue = true
				var pos : Vector3
				match n:
					0:
						pos = Vector3(1,0,0)
					1:
						pos = Vector3(-1,0,0)
					2:
						pos = Vector3(0,0,1)
					3:
						pos = Vector3(0,0,-1)
					4:
						pos = Vector3(1,0,1)
					5:
						pos = Vector3(-1,0,1)
					6:
						pos = Vector3(1,0,-1)
					7:
						pos = Vector3(-1,0,-1)
				
				for m in range(3):
					var tileData = lookForTile(CheckTile.global_position + pos)
					if tileData[1] and canContinue:
						setMoveable(tileData[0])
						CheckTile = tileData[0]
						if tileData[0].contains is MoveablePiece:
							canContinue = false
		"King":
			for n in range(8):
				var tileData
				match n:
					0:
						tileData = lookForTile(highlightedTile.global_position + Vector3(1,0,0))
					1:
						tileData = lookForTile(highlightedTile.global_position + Vector3(-1,0,0))
					2:
						tileData = lookForTile(highlightedTile.global_position + Vector3(0,0,1))
					3:
						tileData = lookForTile(highlightedTile.global_position + Vector3(0,0,-1))
					4:
						tileData = lookForTile(highlightedTile.global_position + Vector3(1,0,1))
					5:
						tileData = lookForTile(highlightedTile.global_position + Vector3(-1,0,1))
					6:
						tileData = lookForTile(highlightedTile.global_position + Vector3(1,0,-1))
					7:
						tileData = lookForTile(highlightedTile.global_position + Vector3(-1,0,-1))
						
				if tileData[1]:
					setMoveable(tileData[0])

func handleMovement():
	var rotation = rad_to_deg($Twist.rotation.y)
	var direction = null
	
	if Input.is_action_just_pressed("Left"):
		if rotation > -180 and rotation <= -90:
			direction = "South"
		elif rotation > -90 and rotation <= 0:
			direction = "East"
		elif rotation > 0 and rotation <= 90:
			direction = "North"
		elif rotation > 90 and rotation <= 180:
			direction = "West"
	elif Input.is_action_just_pressed("Right"):
		if rotation > -180 and rotation <= -90:
			direction = "North"
		elif rotation > -90 and rotation <= 0:
			direction = "West"
		elif rotation > 0 and rotation <= 90:
			direction = "South"
		elif rotation > 90 and rotation <= 180:
			direction = "East"
	elif Input.is_action_just_pressed("Backward"):
		if rotation > -180 and rotation <= -90:
			direction = "East"
		elif rotation > -90 and rotation <= 0:
			direction = "North"
		elif rotation > 0 and rotation <= 90:
			direction = "West"
		elif rotation > 90 and rotation <= 180:
			direction = "South"
	elif Input.is_action_just_pressed("Forward"):
		if rotation > -180 and rotation <= -90:
			direction = "West"
		elif rotation > -90 and rotation <= 0:
			direction = "South"
		elif rotation > 0 and rotation <= 90:
			direction = "East"
		elif rotation > 90 and rotation <= 180:
			direction = "North"
	findClosestTile(direction)

func findClosestTile(direction : String):
	var foundTile : tile
	var searcher : Vector3 = highlightedTile.position
	match direction:
		"North":
			var toAdd := Vector3(0,0,1)
			for n in range(4):
				if !foundTile:
					searcher += toAdd
					if !lookForTile(searcher)[1]:
						if !lookForTile(searcher + Vector3(-1,0,0))[1]:
							if lookForTile(searcher + Vector3(1,0,0))[1]:
								foundTile = lookForTile(searcher + Vector3(1,0,0))[0]
						else:
							foundTile = lookForTile(searcher + Vector3(-1,0,0))[0]
					else:
						foundTile = lookForTile(searcher)[0]
		"South":
			var toAdd := Vector3(0,0,-1)
			for n in range(4):
				if !foundTile:
					searcher += toAdd
					if !lookForTile(searcher)[1]:
						if !lookForTile(searcher + Vector3(1,0,0))[1]:
							if lookForTile(searcher + Vector3(-1,0,0))[1]:
								foundTile = lookForTile(searcher + Vector3(-1,0,0))[0]
						else:
							foundTile = lookForTile(searcher + Vector3(1,0,0))[0]
					else:
						foundTile = lookForTile(searcher)[0]
		"West":
			var toAdd := Vector3(1,0,0)
			for n in range(4):
				if !foundTile:
					searcher += toAdd
					if !lookForTile(searcher)[1]:
						if !lookForTile(searcher + Vector3(0,0,-1))[1]:
							if lookForTile(searcher + Vector3(0,0,1))[1]:
								foundTile = lookForTile(searcher + Vector3(0,0,1))[0]
						else:
							foundTile = lookForTile(searcher + Vector3(0,0,-1))[0]
					else:
						foundTile = lookForTile(searcher)[0]
		"East":
			var toAdd := Vector3(-1,0,0)
			for n in range(4):
				if !foundTile:
					searcher += toAdd
					if !lookForTile(searcher)[1]:
						if !lookForTile(searcher + Vector3(0,0,1))[1]:
							if lookForTile(searcher + Vector3(0,0,-1))[1]:
								foundTile = lookForTile(searcher + Vector3(0,0,-1))[0]
						else:
							foundTile = lookForTile(searcher + Vector3(0,0,1))[0]
					else:
						foundTile = lookForTile(searcher)[0]
	if foundTile:
		highlightTile(foundTile)

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion:
		twist = -event.relative.x *  mouse_sensitivity
