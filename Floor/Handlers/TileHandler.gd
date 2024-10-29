extends Handler

var highlightedTile : tile
var iTiles : Array[tile]
var aoeTiles : Array[tile]

func setTilePattern():
	var relevantTiles : Array[bool]
	if mH.SH.interactable:
		relevantTiles = get_relevant_tiles(FloorData.tiles[PlayerData.playerInfo.rc.x][PlayerData.playerInfo.rc.y], iTiles, 1, mH.SH.interactable.type, mH.SH.interactable)
	for n in range(FloorData.floorInfo.rc.x):
		for m in range(FloorData.floorInfo.rc.y):
			if FloorData.tiles[n][m] != null:
				var cTile = FloorData.tiles[n][m]
				if cTile != highlightedTile:
					if (cTile.rc.x + cTile.rc.y)%2 == 1:
						cTile.tileColor.modulate = Global.tileBlackColor[0]
					else:
						cTile.tileColor.modulate = Global.tileWhiteColor[0]
				if !iTiles.has(cTile):
					cTile.interactable.visible = false
				else:
					cTile.interactable.visible = true
					if mH.SH.moving:
						cTile.set_interactable("Move", true)
					elif mH.SH.interactable:
						cTile.set_interactable(mH.SH.interactable.type, relevantTiles[iTiles.find(cTile)])
	if mH.SH.interactable:
		if mH.SH.interactable.AOE and iTiles.has(highlightedTile):
			showAOE()

func showAOE():
	aoeTiles = mH.SH.interactable.AOE.getAOE(highlightedTile.rc, mH.DH.getClosestDirection(PlayerData.playerPiece.rc, highlightedTile.rc))
	var relevantTiles = get_relevant_tiles(highlightedTile, aoeTiles, 1, mH.SH.interactable.type, null)
	for n in range(aoeTiles.size()):
		aoeTiles[n].set_interactable(mH.SH.interactable.type, relevantTiles[n])
		aoeTiles[n].interactable.modulate -= Color(0,0,0,0.1)

func show():
	if mH.SH.moving:
		iTiles = PlayerData.playerInfo.pieceType.getMoveableTiles(PlayerData.playerInfo.rc)
	elif mH.SH.interactable:
		iTiles = mH.SH.interactable.getTiles(PlayerData.playerInfo.rc)
	setTilePattern()

func stopShowing():
	mH.SH.interactable = null
	mH.SH.moving = false
	mH.SH.actingPiece = null
	iTiles.clear()
	setTilePattern()

func checkHazards():
	if !FloorData.floorInfo.playerTurn:
		var playerTile = FloorData.tiles[PlayerData.playerPiece.rc.x][PlayerData.playerPiece.rc.y]
		if playerTile.hazard:
			if playerTile.hazard.effectType == "OnRest":
				if playerTile.hazard.effect.nextFloor:
					FloorData.nextFloor()

func getEmptyTile():
	var isEmpty := false
	var randX : int
	var randY : int
	while !isEmpty:
		randX = randi_range(0, FloorData.floorInfo.rc.x - 1)
		randY = randi_range(0, FloorData.floorInfo.rc.y - 1)
		if FloorData.tiles[randX][randY] != null:
			if FloorData.tiles[randX][randY].contains == null:
				if FloorData.tiles[randX][randY].obstructed == false:
					isEmpty = true
	return FloorData.tiles[randX][randY]

func get_relevant_tiles(startTile : tile, iTiles : Array[tile], pieceType : int, type : String, interactable : Interactable):
	var possibleTiles : Array[bool]
	var aoeRange : Array[tile]
	var aoeTiles : Array[tile]
	for n in range(iTiles.size()):
		possibleTiles.append(false)
		match type:
			"Damage":
				if (iTiles[n].get_contain() != pieceType and iTiles[n].get_contain() != 0) or iTiles[n].obstructed:
					possibleTiles[n] = true
				elif interactable != null:
					if interactable.AOE != null:
						aoeRange = interactable.AOE.getAOE(iTiles[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(startTile.rc, iTiles[n].rc))
						for m in range(aoeRange.size()):
							if (aoeRange[m].get_contain() != pieceType and aoeRange[m].get_contain() != 0) or aoeRange[m].obstructed:
								possibleTiles[n] = true
			"Healing":
				if iTiles[n].get_contain() == pieceType:
					possibleTiles[n] = true
				elif interactable != null:
					if interactable.AOE != null:
						aoeRange = interactable.AOE.getAOE(iTiles[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(startTile, iTiles[n].rc))
						for m in range(aoeRange.size()):
							if aoeRange[m].get_contain() == pieceType:
								possibleTiles[n] = true

			"Defensive":
				if iTiles[n].get_contain() == pieceType:
					possibleTiles[n] = true
				elif interactable != null:
					if interactable.AOE != null:
						aoeRange = interactable.AOE.getAOE(iTiles[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(startTile, iTiles[n].rc))
						for m in range(aoeRange.size()):
							if aoeRange[m].get_contain() == pieceType:
								possibleTiles[n] = true
			"Status":
				
				if (iTiles[n].get_contain() == pieceType) == interactable.status.buff:
					possibleTiles[n] = true
				elif interactable != null:
					if interactable.AOE != null:
						aoeRange = interactable.AOE.getAOE(iTiles[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(startTile, iTiles[n].rc))
						for m in range(aoeRange.size()):
							if (aoeRange[m].get_contain() == pieceType) == interactable.status.buff:
								possibleTiles[n] = true
			"Hazard":
				
				if interactable.hazard.blockade:
					if iTiles[n].get_contain() == 0:
						possibleTiles[n] = true
				else:
					possibleTiles[n] = true
					
	return possibleTiles
