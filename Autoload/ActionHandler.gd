extends Node

func _process(_delta: float):
	if GameState.action != null:
		if Input.is_action_just_pressed("Select"):
			if GameState.highlightedTile.hittable:
				useAction(GameState.highlightedTile)
				MenuHandler.openMenu()

func useAction(destination : tile):
	TileHandler.stopShowing()
	destination.actionUsed(GameState.action)
	#AOE function
	if GameState.action.AOE != 0:
		var pos = DirectionHandler.getAll("Both")
		for n in range(8):
			var currentTile = destination.global_position
			for m in range(GameState.action.AOE):
				currentTile += DirectionHandler.getPos(pos[n])
				if TileHandler.lookForTile(currentTile):
					TileHandler.lookForTile(currentTile).actionUsed(GameState.action)
	TileHandler.setTilePattern()
	GameState.action = null
	InterfaceHandler.usedAction()
