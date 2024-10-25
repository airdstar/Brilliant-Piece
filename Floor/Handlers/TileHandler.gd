extends Handler

var highlightedTile : tile
var iTiles : Array[tile]
var aoeTiles : Array[tile]

func setTilePattern():
	var relevantTiles : Array[tile]
	if mH.SH.interactable:
		relevantTiles = mH.SH.interactable.get_relevant_tiles(PlayerData.playerInfo.rc,1)
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
					FloorData.tiles[n][m].interactable.visible = false
				else:
					cTile.interactable.visible = true
					if mH.SH.moving:
						cTile.interactable.modulate = Global.colorDict["White"]
					elif mH.SH.interactable:
						match mH.SH.interactable.type:
							"Damage":
								cTile.interactable.modulate = Global.colorDict["Orange"]
							"Healing":
								cTile.interactable.modulate = Global.colorDict["Green"]
							"Defensive":
								cTile.interactable.modulate = Global.colorDict["Blue"]
							"Status":
								cTile.interactable.modulate = Global.colorDict["Green"]
							"Hazard":
								cTile.interactable.modulate = Global.colorDict["Green"]
						if !relevantTiles.has(cTile):
							cTile.interactable.modulate -= Color(0,0,0,0.5)
	if mH.SH.interactable:
		if mH.SH.interactable.AOE and iTiles.has(highlightedTile):
			showAOE()

func showAOE():
	aoeTiles = mH.SH.interactable.AOE.getAOE(highlightedTile.rc, mH.DH.getClosestDirection(PlayerData.playerPiece.rc, highlightedTile.rc))
	for n in range(aoeTiles.size()):
		aoeTiles[n].interactable.visible = true
		var isRelevant : bool = false
		match mH.SH.interactable.type:
			"Damage":
				aoeTiles[n].interactable.modulate = Global.colorDict["Orange"]
				if aoeTiles[n].get_contain() == 2 or aoeTiles[n].obstructed:
					isRelevant = true
			"Healing":
				aoeTiles[n].interactable.modulate = Global.colorDict["Green"]
				if aoeTiles[n].get_contain() == 1:
					isRelevant = true
			"Defensive":
				aoeTiles[n].interactable.modulate = Global.colorDict["Blue"]
				if aoeTiles[n].get_contain() == 1:
					isRelevant = true
			"Status":
				aoeTiles[n].interactable.modulate = Global.colorDict["Green"]
				if mH.SH.interactable.status.statusType == "Buff":
					if aoeTiles[n].get_contain() == 1:
						isRelevant = true
				else:
					if aoeTiles[n].get_contain() == 2:
						isRelevant = true
		
		aoeTiles[n].interactable.modulate -= Color(0,0,0,0.1)
		if !isRelevant:
			aoeTiles[n].interactable.modulate -= Color(0,0,0,0.5)

func show():
	if mH.SH.moving:
		iTiles = PlayerData.playerInfo.pieceType.getMoveableTiles(PlayerData.playerInfo.rc)
	elif mH.SH.interactable:
		iTiles = mH.SH.interactable.getTiles(PlayerData.playerInfo.rc)
	setTilePattern()

func stopShowing():
	mH.SH.interactable = null
	mH.SH.moving = false
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

func get_relevant_tiles(startTile : tile, iTiles : Array[tile], pieceType : int):
	var iRange = mH.SH.interactable.getTiles(startTile)
	var possibleTiles : Array[bool]
	var aoeRange : Array[tile]
	var aoeTiles : Array[tile]
	for n in range(iRange.size()):
		possibleTiles.append(false)
		match mH.SH.interactable.type:
			"Damage":
				if (iRange[n].get_contain() != pieceType and iRange[n].get_contain() != 0) or iRange[n].obstructed:
					possibleTiles[n] = true
				elif mH.SH.interactable.AOE != null:
					aoeRange = AOE.getAOE(actionRange[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(_iStart, actionRange[n].rc))
					for m in range(aoeRange.size()):
						if (aoeRange[m].get_contain() != pieceType and aoeRange[m].get_contain() != 0) or aoeRange[m].obstructed:
							possibleTiles.append(actionRange[n])
			"Healing":
				if actionRange[n].get_contain() == pieceType:
					possibleTiles.append(actionRange[n])
				elif AOE != null:
					aoeRange = AOE.getAOE(actionRange[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(_iStart, actionRange[n].rc))
					for m in range(aoeRange.size()):
						if aoeRange[m].get_contain() == pieceType:
							possibleTiles.append(actionRange[n])

			"Defensive":
				if actionRange[n].get_contain() == pieceType:
					possibleTiles.append(actionRange[n])
				elif AOE != null:
					aoeRange = AOE.getAOE(actionRange[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(_iStart, actionRange[n].rc))
					for m in range(aoeRange.size()):
						if aoeRange[m].get_contain() == pieceType:
							possibleTiles.append(actionRange[n])
			"Status":
				var isBuff : bool = false
				if status.statusType == "Buff":
					isBuff = true
				
				if (actionRange[n].get_contain() == pieceType) == isBuff:
					possibleTiles.append(actionRange[n])
				elif AOE != null:
					aoeRange = AOE.getAOE(actionRange[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(_iStart, actionRange[n].rc))
					for m in range(aoeRange.size()):
						if (aoeRange[m].get_contain() == pieceType) == isBuff:
							possibleTiles.append(actionRange[n])
			"Hazard":
				var isObstruction : bool = false
				if hazard.blockade:
					isObstruction = true
				
				if isObstruction:
					if actionRange[n].get_contain() == 0:
						possibleTiles.append(actionRange[n])
				else:
					possibleTiles.append(actionRange[n])
					
	return possibleTiles
