extends Node
class_name PlayableArea

var mouse_sensitivity := 0.0005
var twist : float
var inMenu : bool = false
var menu
var moving = [false,PlayablePiece]
var highlightedTile : tile
@onready var Pointer = $Pointer

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
		if highlightedTile.contains is PlayablePiece:
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
		$StaticHUD/PortraitBackground.texture = $StaticHUD/SubViewport.get_texture()
		$StaticHUD/PortraitBackground.visible = true
		if highlightedTile.contains is PlayablePiece:
			$StaticHUD/Portrait/Status/NameLabel.text = highlightedTile.contains.pieceName
			$StaticHUD/Portrait/Status/TypeLabel.text = highlightedTile.contains.type
			$StaticHUD/Portrait/Status/LevelLabel.text = "Enemy lvl " + str(highlightedTile.contains.level)
			$StaticHUD/Portrait/Status/PointLabel.text = "HP: " + str(highlightedTile.contains.health) + "/" + str(highlightedTile.contains.maxHealth)
			if highlightedTile.contains is PlayerPiece:
				$StaticHUD/Portrait/Status/LevelLabel.text = str(highlightedTile.contains.classType) + " lvl " + str(highlightedTile.contains.level)
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
	if moveableTile.contains is PlayablePiece:
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

func findMoveableTiles():
	match highlightedTile.contains.type:
		"Pawn":
			for n in range(4):
				if highlightedTile.closeTiles[n]:
					setMoveable(highlightedTile.closeTiles[n])
		"Rook":
			for n in range(4):
				var CheckTile = highlightedTile
				var canContinue = true
				for m in range(3):
					if CheckTile.closeTiles[n] and canContinue:
						CheckTile = CheckTile.closeTiles[n]
						if CheckTile:
							setMoveable(CheckTile)
							if CheckTile.contains is PlayablePiece:
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
						if tileData[0].contains is PlayablePiece:
							canContinue = false
#Fix this later
func handleMovement():
	var rotation = rad_to_deg($Twist.rotation.y)
	if rotation > -180 and rotation <= -90:
		if Input.is_action_just_pressed("Forward"):
			if highlightedTile.closeTiles[0]:
				highlightTile(highlightedTile.closeTiles[0])
		elif Input.is_action_just_pressed("Backward"):
			if highlightedTile.closeTiles[2]:
				highlightTile(highlightedTile.closeTiles[2])
		elif Input.is_action_just_pressed("Left"):
			if highlightedTile.closeTiles[3]:
				highlightTile(highlightedTile.closeTiles[3])
		elif Input.is_action_just_pressed("Right"):
			if highlightedTile.closeTiles[1]:
				highlightTile(highlightedTile.closeTiles[1])
	elif rotation > -90 and rotation <= 0:
		if Input.is_action_just_pressed("Forward"):
			if highlightedTile.closeTiles[3]:
				highlightTile(highlightedTile.closeTiles[3])
		elif Input.is_action_just_pressed("Backward"):
			if highlightedTile.closeTiles[1]:
				highlightTile(highlightedTile.closeTiles[1])
		elif Input.is_action_just_pressed("Left"):
			if highlightedTile.closeTiles[2]:
				highlightTile(highlightedTile.closeTiles[2])
		elif Input.is_action_just_pressed("Right"):
			if highlightedTile.closeTiles[0]:
				highlightTile(highlightedTile.closeTiles[0])
	elif rotation > 0 and rotation <= 90:
		if Input.is_action_just_pressed("Forward"):
			if highlightedTile.closeTiles[2]:
				highlightTile(highlightedTile.closeTiles[2])
		elif Input.is_action_just_pressed("Backward"):
			if highlightedTile.closeTiles[0]:
				highlightTile(highlightedTile.closeTiles[0])
		elif Input.is_action_just_pressed("Left"):
			if highlightedTile.closeTiles[1]:
				highlightTile(highlightedTile.closeTiles[1])
		elif Input.is_action_just_pressed("Right"):
			if highlightedTile.closeTiles[3]:
				highlightTile(highlightedTile.closeTiles[3])
	elif rotation > 90 and rotation <= 180:
		if Input.is_action_just_pressed("Forward"):
			if highlightedTile.closeTiles[1]:
				highlightTile(highlightedTile.closeTiles[1])
		elif Input.is_action_just_pressed("Backward"):
			if highlightedTile.closeTiles[3]:
				highlightTile(highlightedTile.closeTiles[3])
		elif Input.is_action_just_pressed("Left"):
			if highlightedTile.closeTiles[0]:
				highlightTile(highlightedTile.closeTiles[0])
		elif Input.is_action_just_pressed("Right"):
			if highlightedTile.closeTiles[2]:
				highlightTile(highlightedTile.closeTiles[2])

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion:
		twist = -event.relative.x *  mouse_sensitivity
