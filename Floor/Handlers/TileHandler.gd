extends Handler

var highlightedTile : tile
var iTiles : Array[tile]
var aoeTiles : Array[tile]

func setTilePattern():
	var relevantTiles : Array[tile]
	if mH.SH.interactable:
		relevantTiles = mH.SH.interactable.get_relevant_tiles(PlayerData.playerInfo.rc,1)
		if mH.SH.interactable.AOE and iTiles.has(highlightedTile):
			showAOE()
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

func showAOE():
	aoeTiles = mH.SH.interactable.AOE.getAOE(highlightedTile.rc, mH.DH.getClosestDirection(PlayerData.playerPiece.rc, highlightedTile.rc))
	for o in range(aoeTiles.size()):
		aoeTiles[o].interactable.visible = true
		if !aoeTiles[o].has_target():
			aoeTiles[o].interactable.modulate = Color(0.86,0.72,0.63,0.5)

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
