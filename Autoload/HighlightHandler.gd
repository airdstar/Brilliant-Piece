extends Node

func handleMovement():
	var rotation = rad_to_deg($Twist.rotation.y)
	var direction = null
	
	if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
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
		
		if Input.is_action_just_pressed("Right"):
			direction = DirectionHandler.getOppDirection(direction)
			
	elif Input.is_action_just_pressed("Backward") or Input.is_action_just_pressed("Forward"):
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
		
		if Input.is_action_just_pressed("Forward"):
			direction = DirectionHandler.getOppDirection(direction)
			
	findClosestTile(direction)

func findClosestTile(direction : String):
	var foundTile : tile
	var searcher : Vector3 = highlightedTile.global_position
	var toAdd = DirectionHandler.getPos(direction)
	var left = DirectionHandler.getPos(DirectionHandler.getSides(direction)[0])
	var right = DirectionHandler.getPos(DirectionHandler.getSides(direction)[1])
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
				var pos = DirectionHandler.getAll("Both")
				for n in range(8):
					var currentTile = highlightedTile.global_position
					for m in range(action.AOE):
						currentTile += DirectionHandler.getPos(pos[n])
						if lookForTile(currentTile):
							lookForTile(currentTile).highlight.visible = true
							lookForTile(currentTile).setColor("Red")
			
	else:
		highlightedTile.setColor("Gray")
		Pointer.setColor("Gray")
	
	displayInfo()
