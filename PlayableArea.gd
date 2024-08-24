extends Node
class_name PlayableArea

var mouse_sensitivity := 0.0005
var twist : float


var inMenu : bool = false
var menu : BasicMenu

var player : PlayerPiece
var playerTile : tile

var turn : String = "Player"
var prevTurn : String = "None"

var viewing : bool = false
var moving : MoveablePiece
var action : ActionResource

var highlightedTile : tile

@onready var Pointer = $Pointer
@onready var camera = $Twist/Camera3D

func _ready():
	secondaryReady()
	player.death.connect(self.playerDeath)
	setTilePattern()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func secondaryReady():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
	
	if turn == "Player":
		
		if !menu and !action and !moving:
			openMenu()
		
		if Input.is_action_just_pressed("Select"):
			if moving and highlightedTile.moveable:
				Pointer.visible = false
				stopShowingMovement()
				endTurn()
				movePiece(moving, highlightedTile)
				moving = null
			elif action and highlightedTile.hittable:
				endTurn()
				highlightedTile.actionUsed(action)
				# Move AOE to its own function
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
				
		
		if Input.is_action_just_pressed("Cancel"):
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
		allTiles[n].highlight.visible = false
		if highlightedTile != allTiles[n] and !allTiles[n].moveable and !allTiles[n].hittable:
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor("Black")
			else:
				allTiles[n].setColor("White")
		if allTiles[n].hittable:
			allTiles[n].setColor("Orange")

func highlightTile(tileToSelect : tile):
	highlightedTile = tileToSelect
	setTilePattern()
	highlightedTile.highlight.visible = true
	Pointer.position.x = highlightedTile.position.x
	Pointer.position.z = highlightedTile.position.z
	Pointer.height = highlightedTile.getPointerPos()
	$Twist.position.x = Pointer.position.x
	$Twist.position.z = Pointer.position.z
	if highlightedTile.moveable:
		if highlightedTile.contains is EnemyPiece:
			highlightedTile.setColor("Orange")
			Pointer.setColor("Orange")
		else:
			highlightedTile.setColor("Blue")
			Pointer.setColor("Blue")
	elif highlightedTile.hittable:
		highlightedTile.setColor("Red")
		Pointer.setColor("Red")
		if action.AOE != 0:
			var pos = Directions.getAllDirections()
			for n in range(8):
				var currentTile = highlightedTile.global_position
				for m in range(action.AOE):
					currentTile += Directions.getDirection(pos[n])
					if lookForTile(currentTile):
						lookForTile(currentTile).highlight.visible = true
						lookForTile(currentTile).setColor("Red")
			
	else:
		highlightedTile.setColor("Gray")
		Pointer.setColor("Gray")
	
	displayInfo()

func displayInfo():
	if $StaticHUD/SubViewport/Portrait.get_child_count() == 2:
		$StaticHUD/SubViewport/Portrait.remove_child($StaticHUD/SubViewport/Portrait.get_child(1))
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
			$StaticHUD/Portrait/Status/PointLabel.text = "[img]res://HUD/Heart.png[/img]" + str(highlightedTile.contains.health) + "/" + str(highlightedTile.contains.maxHealth)
			if highlightedTile.contains is PlayerPiece:
				$StaticHUD/Portrait/Status/LevelLabel.text = str(highlightedTile.contains.classType.className) + " lvl " + str(highlightedTile.contains.level)
				$StaticHUD/Portrait/Status/PointLabel.text = "HP: " + str(highlightedTile.contains.health) + "/" + str(highlightedTile.contains.maxHealth) + "        SP: " + str(highlightedTile.contains.soul) + "/" + str(highlightedTile.contains.maxSoul)
	else:
		$StaticHUD/PortraitBackground.visible = false
		$StaticHUD/Portrait.visible = false

func changeTurn():
	if prevTurn == "Player":
		turn = "Enemy"
		Pointer.visible = true
	else:
		turn = "Player"
	print(turn)
	if turn == "Player":
		$StaticHUD/Turn.set_texture(load("res://HUD/PlayerTurn.png"))
	else:
		$StaticHUD/Turn.set_texture(load("res://HUD/EnemyTurn.png"))

func endTurn():
	prevTurn = turn
	turn = "None"
	$StaticHUD/Turn.set_texture(load("res://HUD/NoTurn.png"))

func openMenu():
	inMenu = true
	menu = preload("res://Menu/BasicMenu.tscn").instantiate()
	$Menu.add_child(menu)
	menu.addPlayerOptions()
	menu.position = Vector2(360,313)
	menu.showMenu(true)
	Pointer.visible = false
	highlightTile(playerTile)

func stopShowingMovement():
	var allTiles = $Tiles.get_children()
	for n in range(allTiles.size()):
		allTiles[n].moveable = false
		if allTiles[n] == highlightedTile:
			allTiles[n].setColor("Grey")
		else:
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor("Black")
			else:
				allTiles[n].setColor("White")

func setMoveable(moveableTile : tile):
	moveableTile.moveable = true
	if moveableTile.contains is EnemyPiece:
		moveableTile.setColor("Orange")
	else:
		moveableTile.setColor("Blue")

#Need to make blockable stuff
func showAction():
	var tileData = action.getActionRange(playerTile.global_position)
	for n in range(tileData.size()):
		if lookForTile(tileData[n]):
			setHittable(lookForTile(tileData[n]))

func stopShowingAction():
	var allTiles = $Tiles.get_children()
	for n in range(allTiles.size()):
		allTiles[n].hittable = false
		if allTiles[n] == highlightedTile:
			allTiles[n].setColor("Gray")
		else:
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor("Black")
			else:
				allTiles[n].setColor("White")

func setHittable(possibleTile : tile):
	possibleTile.hittable = true
	possibleTile.setColor("Orange")

func lookForTile(pos : Vector3):
	var toReturn
	var allTiles = $Tiles.get_children()
	for n in range(allTiles.size()):
		if allTiles[n].global_position == pos:
			toReturn = allTiles[n]
	return toReturn

func movePiece(piece : MoveablePiece, destination : tile):
	var destinationReached : bool = false
	var startingPos = piece.currentTile
	var counter : int = 0
	while(!destinationReached):
		var allDirections = Directions.getAllStraight()
		var closestDirection
		var smallestVariation
		for n in range(allDirections.size()):
			var xVar = abs(destination.global_position.x - (piece.currentTile.global_position + Directions.getDirection(allDirections[n])).x)
			var zVar = abs(destination.global_position.z - (piece.currentTile.global_position + Directions.getDirection(allDirections[n])).z)
			if closestDirection:
				if smallestVariation > xVar + zVar:
					closestDirection = allDirections[n]
					smallestVariation = xVar + zVar
				elif smallestVariation == xVar + zVar:
					if (closestDirection == "North" or allDirections[n] == "North"):
						if (closestDirection == "West" or allDirections[n] == "West"):
							if lookForTile(piece.currentTile.global_position + Directions.getDirection("NorthWest")):
								closestDirection = "NorthWest"
						elif (closestDirection == "East" or allDirections[n] == "East"):
							if lookForTile(piece.currentTile.global_position + Directions.getDirection("NorthEast")):
								closestDirection = "NorthEast"
					elif (closestDirection == "South" or allDirections[n] == "South"):
						if (closestDirection == "West" or allDirections[n] == "West"):
							if lookForTile(piece.currentTile.global_position + Directions.getDirection("SouthWest")):
								closestDirection = "SouthWest"
						elif (closestDirection == "East" or allDirections[n] == "East"):
							if lookForTile(piece.currentTile.global_position + Directions.getDirection("SouthEast")):
								closestDirection = "SouthEast"
			else:
				closestDirection = allDirections[n]
				smallestVariation = xVar + zVar
		
		piece.previousTile = piece.currentTile
		piece.previousTile.contains = null
		lookForTile(piece.currentTile.global_position + Directions.getDirection(closestDirection)).setPiece(piece)
		setPieceOrientation(piece, closestDirection)
		if piece is PlayerPiece:
			highlightTile(piece.currentTile)
		if piece.currentTile == destination:
			destinationReached = true
			print(closestDirection)
			changeTurn()
			if piece is PlayerPiece:
				playerTile = piece.currentTile
				displayInfo()
				Pointer.height = highlightedTile.getPointerPos()
		else:
			await get_tree().create_timer(0.3).timeout
		
		counter += 1
		if counter == 10:
			destinationReached = true
			startingPos.setPiece(piece)
			print("ERROR")
			changeTurn()

func findMoveableTiles():
	match highlightedTile.contains.type:
		"Pawn":
			for n in range(4):
				var tileData = lookForTile(highlightedTile.global_position + Directions.getDirection(Directions.getAllStraight()[n]))
				if tileData:
					setMoveable(tileData)
		"Rook":
			for n in range(4):
				var CheckTile = highlightedTile
				var canContinue := true
				var pos = Directions.getDirection(Directions.getAllStraight()[n])
				for m in range(3):
					var tileData = lookForTile(CheckTile.global_position + pos)
					if tileData and canContinue:
						setMoveable(tileData)
						CheckTile = tileData
						if tileData.contains is MoveablePiece:
							canContinue = false
		"Bishop":
			for n in range(4):
				var CheckTile = highlightedTile
				var canContinue = true
				var pos = Directions.getDirection(Directions.getAllDiagonal()[n])
				for m in range(3):
					var tileData = lookForTile(CheckTile.global_position + pos)
					if tileData and canContinue:
						setMoveable(tileData)
						CheckTile = tileData
						if tileData.contains is MoveablePiece:
							canContinue = false
		"Knight":
			for n in range(4):
				var CheckTile = highlightedTile.global_position
				var pos = Directions.getDirection(Directions.getAllStraight()[n])
				var tileData
				CheckTile += pos
				for m in range(2):
					tileData = lookForTile(CheckTile + Directions.getDirection(Directions.getDiagonals(Directions.getAllStraight()[n])[m]))
					if tileData:
						setMoveable(tileData)
		"Queen":
			for n in range(8):
				var CheckTile = highlightedTile
				var canContinue = true
				var pos = Directions.getDirection(Directions.getAllDirections()[n])
				for m in range(3):
					var tileData = lookForTile(CheckTile.global_position + pos)
					if tileData and canContinue:
						setMoveable(tileData)
						CheckTile = tileData
						if tileData.contains is MoveablePiece:
							canContinue = false
		"King":
			for n in range(8):
				var tileData = lookForTile(highlightedTile.global_position + Directions.getDirection(Directions.getAllDirections()[n]))
				if tileData:
					setMoveable(tileData)

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
	var searcher : Vector3 = highlightedTile.global_position
	var toAdd = Directions.getDirection(direction)
	var left = Directions.getDirection(Directions.getSides(direction)[0])
	var right = Directions.getDirection(Directions.getSides(direction)[1])
	for n in range(4):
		if !foundTile:
			searcher += toAdd
			if !lookForTile(searcher):
				if !lookForTile(searcher + left):
					if lookForTile(searcher + right):
						foundTile = lookForTile(searcher + right)
				else:
					foundTile = lookForTile(searcher + left)
			else:
				foundTile = lookForTile(searcher)

	if foundTile:
		highlightTile(foundTile)

func setPieceOrientation(piece : MoveablePiece, direction : String):
	match direction:
		"West":
			piece.global_rotation.y = deg_to_rad(0)
		"SouthWest":
			piece.global_rotation.y = deg_to_rad(45)
		"South":
			piece.global_rotation.y = deg_to_rad(90)
		"SouthEast":
			piece.global_rotation.y = deg_to_rad(135)
		"East":
			piece.global_rotation.y = deg_to_rad(180)
		"NorthEast":
			piece.global_rotation.y = deg_to_rad(-135)
		"North":
			piece.global_rotation.y = deg_to_rad(-90)
		"NorthWest":
			piece.global_rotation.y = deg_to_rad(-45)

func playerDeath():
	get_tree().quit()

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion:
		twist = -event.relative.x *  mouse_sensitivity
