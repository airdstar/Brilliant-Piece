extends PlayableArea
class_name Floor

var inCombat : bool = false
@export var tileAmount : int

func secondaryReady():
	generateTiles()

func secondaryProcess(_delta):
	if Input.is_action_just_pressed("Select") and !inCombat:
		if highlightedTile.contains is Piece and !inMenu and !moving[0]:
			inMenu = true
			menu = preload("res://Menu/BasicMenu.tscn").instantiate()
			menu.position = Vector2(360,313)
			$Menu.add_child(menu)
			if highlightedTile.contains is PlayerPiece:
				menu.addPlayerOptions()
			menu.showMenu(true)
		if moving[0] and highlightedTile.moveable:
			if highlightedTile.contains is PlayablePiece:
				var actionScene = preload("res://ActionScene.tscn").instantiate()
				remove_child($PlayablePiece)
				actionScene.setEnemy(highlightedTile.contains)
				$StaticHUD/Portrait.visible = false
				$StaticHUD/PortraitBackground.visible = false
				$Action.add_child(actionScene)
				inCombat = true
			else:
				moving[1].previousTile = moving[1].currentTile
				moving[1].previousTile.contains = null
				highlightedTile.setPiece(moving[1])
				stopShowingMovement()
				moving[0] = false
				moving[1] = null
		if moving[0] and highlightedTile.contains == moving[1]:
			stopShowingMovement()
			moving[0] = false
			moving[1] = null
	
	if Input.is_action_just_pressed("Cancel") and !inCombat:
		if inMenu and !menu.hasSelectedOption:
			$Menu.get_child(0).closeMenu()
		if moving[0]:
			stopShowingMovement()
			moving[0] = false
			moving[1] = null
	
	if !inMenu and !inCombat:
		if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right") or Input.is_action_just_pressed("Forward") or Input.is_action_just_pressed("Backward"):
			handleMovement()

func generateTiles():
	var playerPos = randi_range(0, tileAmount - 1)
	var enemyPos = randi_range(0, tileAmount - 1)
	for n in range(tileAmount):
		var cantPlace = true
		var tileToAdd = preload("res://Tile.tscn").instantiate()
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
				elif n == enemyPos:
					tileToAdd.setPiece($PlayablePiece)

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion:
		if !inCombat:
			twist = -event.relative.x *  mouse_sensitivity
		else:
			$Action.get_child(0).cameraControls(-event.relative.x *  mouse_sensitivity)
