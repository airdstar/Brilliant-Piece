extends Node
class_name PlayableArea

var mouse_sensitivity := 0.0005
var twist : float


var inMenu : bool = false
var menu : BasicMenu

@onready var player : PlayerPiece = $PlayerPiece
var playerTile : tile

@onready var enemies : EnemyPiece = $EnemyPiece

var playerTurn : bool = true
var actionUsed : bool = false
var moveUsed : bool = false


var viewing : bool = false
var item : ItemResource
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
	
	if playerTurn:
		
		if !menu and !action and !moving and !viewing and !item:
			openMenu()
		
		if Input.is_action_just_pressed("Select"):
			if moving and highlightedTile.moveable:
				Pointer.visible = false
				stopShowingOptions()
				movePiece(highlightedTile)
				usedMove()
			elif action and highlightedTile.hittable:
				stopShowingOptions()
				useAction(highlightedTile)
				usedAction()
			elif item and highlightedTile.hittable:
				stopShowingOptions()
				#useItem(highlightedTile)
				#usedItem()
			if viewing:
				viewing = false
				openMenu()
		
		if Input.is_action_just_pressed("Cancel"):
			if moving:
				stopShowingOptions()
				moving = null
				openMenu()
			if action:
				stopShowingOptions()
				action = null
				openMenu()
			if viewing:
				viewing = false
				openMenu()
			if item:
				stopShowingOptions()
				item = null
				openMenu()
	else:
		$EnemyController.makeDecision()
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
		if allTiles[n].hittable or (allTiles[n].moveable and allTiles[n].contains is EnemyPiece):
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
			highlightedTile.setColor("Red")
			Pointer.setColor("Red")
		else:
			highlightedTile.setColor("Blue")
			Pointer.setColor("Blue")
	elif highlightedTile.hittable:
		highlightedTile.setColor("Red")
		Pointer.setColor("Red")
		if action:
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
		$StaticHUD/Status.visible = true
		var portraitPic = highlightedTile.contains.duplicate()
		$StaticHUD/SubViewport/Portrait.add_child(portraitPic)
		portraitPic.global_position = $StaticHUD/SubViewport/Portrait.global_position
		portraitPic.global_rotation.y = deg_to_rad(-90)
		if portraitPic is PlayerPiece:
			$StaticHUD/SubViewport/Portrait/Camera3D/MeshInstance3D.mesh.material.set_albedo(Color(0.63,0.72,0.86))
		elif portraitPic is EnemyPiece:
			$StaticHUD/SubViewport/Portrait/Camera3D/MeshInstance3D.mesh.material.set_albedo(Color(0.86,0.63,0.72))
		$StaticHUD/PortraitBackground.texture = $StaticHUD/SubViewport.get_texture()
		$StaticHUD/PortraitBackground.visible = true
		if highlightedTile.contains is MoveablePiece:
			$StaticHUD/Status/NameLabel.text = highlightedTile.contains.pieceName
			$StaticHUD/Status/TypeLabel.text = highlightedTile.contains.type.typeName
			$StaticHUD/Status/LevelLabel.text = "Enemy lvl " + str(highlightedTile.contains.level)
			$StaticHUD/Status/HealthLabel.text = "[img]res://HUD/Heart.png[/img] " + str(highlightedTile.contains.health) + "/" + str(highlightedTile.contains.maxHealth)
			$StaticHUD/Status/SoulLabel.text = ""
			if highlightedTile.contains.armor > 0:
				$StaticHUD/Status/HealthLabel.text += "   [img]res://HUD/Armor.png[/img] " + str(highlightedTile.contains.armor)
			if highlightedTile.contains is PlayerPiece:
				$StaticHUD/Status/LevelLabel.text = str(highlightedTile.contains.classType.className) + " lvl " + str(highlightedTile.contains.level) 
				$StaticHUD/Status/SoulLabel.text = "[img]res://HUD/Soul.png[/img] " + str(highlightedTile.contains.soul) + "/" + str(highlightedTile.contains.maxSoul)
	else:
		$StaticHUD/PortraitBackground.visible = false
		$StaticHUD/Portrait.visible = false
		$StaticHUD/Status.visible = false

func usedMove():
	$StaticHUD/TurnHUD/MoveOutline/Move.modulate = Color(0.5,0.5,0.5)
	moveUsed = true

func usedAction():
	$StaticHUD/TurnHUD/ActionOutline/Action.modulate = Color(0.5,0.5,0.5)
	actionUsed = true

func endTurn():
	playerTurn = !playerTurn
	actionUsed = false
	moveUsed = false
	if !playerTurn:
		Pointer.visible = true
		$StaticHUD/TurnHUD/MoveOutline/Move.modulate = Color(0.86,0.63,0.72)
		$StaticHUD/TurnHUD/ActionOutline/Action.modulate = Color(0.86,0.63,0.72)
		$StaticHUD/TurnHUD/TurnOutline/Turn.modulate = Color(0.86,0.63,0.72)
	else:
		$StaticHUD/TurnHUD/MoveOutline/Move.modulate = Color(0.63,0.72,0.86)
		$StaticHUD/TurnHUD/ActionOutline/Action.modulate = Color(0.63,0.72,0.86)
		$StaticHUD/TurnHUD/TurnOutline/Turn.modulate = Color(0.63,0.72,0.86)

func openMenu():
	inMenu = true
	menu = preload("res://Menu/BasicMenu.tscn").instantiate()
	$Menu.add_child(menu)
	menu.addOptions(moveUsed, actionUsed)
	menu.position = Vector2(360,325)
	menu.showMenu(true)
	Pointer.visible = false
	highlightTile(playerTile)

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

func stopShowingOptions():
	var allTiles = $Tiles.get_children()
	for n in range(allTiles.size()):
		allTiles[n].hittable = false
		allTiles[n].moveable = false
		if allTiles[n] == highlightedTile:
			allTiles[n].setColor("Gray")
		else:
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor("Black")
			else:
				allTiles[n].setColor("White")

func useAction(destination : tile):
	destination.actionUsed(action)
	#AOE function
	if action.AOE != 0:
		var pos = Directions.getAllDirections()
		for n in range(8):
			var currentTile = destination.global_position
			for m in range(action.AOE):
				currentTile += Directions.getDirection(pos[n])
				if lookForTile(currentTile):
					lookForTile(currentTile).actionUsed(action)
	setTilePattern()
	action = null

func setHittable(possibleTile : tile):
	possibleTile.hittable = true
	possibleTile.setColor("Orange")

func showItem():
	var tileData = item.getItemRange(playerTile.global_position)
	for n in range(tileData.size()):
		if lookForTile(tileData[n]):
			if item.itemType == "Damage":
				if lookForTile(tileData[n]).contains is EnemyPiece:
					setHittable(lookForTile(tileData[n]))

func lookForTile(pos : Vector3):
	var toReturn
	var allTiles = $Tiles.get_children()
	for n in range(allTiles.size()):
		if allTiles[n].global_position == pos:
			toReturn = allTiles[n]
	return toReturn

func movePiece(destination : tile):
	var destinationReached : bool = false
	var startingPos = moving.currentTile
	var counter : int = 0
	while(!destinationReached):
		var closestDirection = Directions.getClosestDirection(moving.currentTile.global_position, destination.global_position)
		
		if lookForTile(moving.currentTile.global_position + Directions.getDirection(closestDirection)).contains:
			if lookForTile(moving.currentTile.global_position + Directions.getDirection(closestDirection)).contains is MoveablePiece:
				pushPiece(lookForTile(moving.currentTile.global_position + Directions.getDirection(closestDirection)).contains, closestDirection)
		moving.previousTile = moving.currentTile
		moving.previousTile.contains = null
		lookForTile(moving.currentTile.global_position + Directions.getDirection(closestDirection)).setPiece(moving)
		setPieceOrientation(moving, closestDirection)
		if moving is PlayerPiece:
			highlightTile(moving.currentTile)
		if moving.currentTile == destination:
			if moving is PlayerPiece:
				playerTile = moving.currentTile
				displayInfo()
				Pointer.height = highlightedTile.getPointerPos()
			moving = null
			destinationReached = true
		else:
			await get_tree().create_timer(0.3).timeout
		
		counter += 1
		if counter == 10:
			destinationReached = true
			startingPos.setPiece(moving)
			print("ERROR")

func pushPiece(piece : MoveablePiece, direction : String):
	if lookForTile(piece.currentTile.global_position + Directions.getDirection(direction)):
		lookForTile(piece.currentTile.global_position + Directions.getDirection(direction)).setPiece(piece)
		@warning_ignore("integer_division")
		if int(piece.maxHealth / 10) < 1:
			piece.damage(1)
		else:
			@warning_ignore("integer_division")
			piece.damage(1 + int(piece.maxHealth / 10))
	else:
		@warning_ignore("integer_division")
		piece.damage(5 + int(piece.maxHealth / 4))
		randPlacePiece(piece)

func randPlacePiece(piece : MoveablePiece):
	var piecePlaced : bool = false
	while(!piecePlaced):
		var piecePos := randi_range(0, $Tiles.get_child_count() - 1)
		for n in range($Tiles.get_child_count()):
			if n == piecePos:
				if !$Tiles.get_child(n).contains:
					$Tiles.get_child(n).setPiece(piece)
					piecePlaced = true
					if piece is PlayerPiece:
						highlightTile($Tiles.get_child(n))
						playerTile = $Tiles.get_child(n)

func findMoveableTiles(piece : MoveablePiece, check : bool):
	var possibleTiles = piece.type.getMoveableTiles(piece.currentTile.global_position)
	var currentTile
	var toReturn = []
	for n in range(possibleTiles.size()):
		if n%2 == 0:
			if lookForTile(possibleTiles[n]):
				currentTile = lookForTile(possibleTiles[n])
		else:
			if currentTile:
				if (lookForTile(possibleTiles[n]) and lookForTile(possibleTiles[n]).moveable) or possibleTiles[n] == piece.currentTile.global_position:
					if check:
						toReturn.append(currentTile)
					else:
						setMoveable(currentTile)
			currentTile = null
	if check:
		return toReturn

func handleMovement():
	var rotation = rad_to_deg($Twist.rotation.y)
	var direction = null
	
	if Input.is_action_just_pressed("Left"):
		if rotation > -172.5 and rotation < -97.5:
			direction = "South"
		elif rotation >= -97.5 and rotation <= -82.5:
			direction = "SouthEast"
		elif rotation > -82.5 and rotation < -7.5:
			direction = "East"
		elif rotation >= -7.5 and rotation <= 7.5:
			direction = "NorthEast"
		elif rotation > 7.5 and rotation < 82.5:
			direction = "North"
		elif rotation >= 82.5 and rotation <= 97.5:
			direction = "NorthWest"
		elif rotation > 97.5 and rotation < 172.5:
			direction = "West"
		elif (rotation >= 172.5 and rotation <= 180) or (rotation >= -180 and rotation <= -172.5):
			direction = "SouthWest"
	elif Input.is_action_just_pressed("Right"):
		if rotation > -172.5 and rotation < -97.5:
			direction = "North"
		elif rotation >= -97.5 and rotation <= -82.5:
			direction = "NorthWest"
		elif rotation > -82.5 and rotation < -7.5:
			direction = "West"
		elif rotation >= -7.5 and rotation <= 7.5:
			direction = "SouthWest"
		elif rotation > 7.5 and rotation < 82.5:
			direction = "South"
		elif rotation >= 82.5 and rotation <= 97.5:
			direction = "SouthEast"
		elif rotation > 97.5 and rotation < 172.5:
			direction = "East"
		elif (rotation >= 172.5 and rotation <= 180) or (rotation >= -180 and rotation <= -172.5):
			direction = "NorthEast"
	elif Input.is_action_just_pressed("Backward"):
		if rotation > -172.5 and rotation < -97.5:
			direction = "East"
		elif rotation >= -97.5 and rotation <= -82.5:
			direction = "NorthEast"
		elif rotation > -82.5 and rotation < -7.5:
			direction = "North"
		elif rotation >= -7.5 and rotation <= 7.5:
			direction = "NorthWest"
		elif rotation > 7.5 and rotation < 82.5:
			direction = "West"
		elif rotation >= 82.5 and rotation <= 97.5:
			direction = "SouthWest"
		elif rotation > 97.5 and rotation < 172.5:
			direction = "South"
		elif (rotation >= 172.5 and rotation <= 180) or (rotation >= -180 and rotation <= -172.5):
			direction = "SouthEast"
	elif Input.is_action_just_pressed("Forward"):
		if rotation > -172.5 and rotation < -97.5:
			direction = "West"
		elif rotation >= -97.5 and rotation <= -82.5:
			direction = "SouthWest"
		elif rotation > -82.5 and rotation < -7.5:
			direction = "South"
		elif rotation >= -7.5 and rotation <= 7.5:
			direction = "SouthEast"
		elif rotation > 7.5 and rotation < 82.5:
			direction = "East"
		elif rotation >= 82.5 and rotation <= 97.5:
			direction = "NorthEast"
		elif rotation > 97.5 and rotation < 172.5:
			direction = "North"
		elif (rotation >= 172.5 and rotation <= 180) or (rotation >= -180 and rotation <= -172.5):
			direction = "NorthWest"
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

func findClosestTileToTarget(target : Vector3, direction : Vector3):
	var closestTile
	var smallestVariation
	for n in range(moving.type.movementCount):
		var xVar = abs(target.x - (moving.global_position + direction * (n + 1)).x)
		var zVar = abs(target.z - (moving.global_position + direction * (n + 1)).z)
		if smallestVariation:
			pass
		else:
			smallestVariation = xVar + zVar
			
		

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
