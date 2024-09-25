extends Handler

var tileDict : Dictionary

func lookForTile(pos : Vector3):
	if tileDict["TilePos"].has(pos):
		return tileDict["Tiles"][tileDict["TilePos"].find(pos)]
	return null

func setTilePattern():
	var allTiles = tileDict["Tiles"]
	for n in range(allTiles.size()):
		allTiles[n].highlight.visible = false
		if tileDict["hTile"] != allTiles[n] and !tileDict["iTiles"].has(allTiles[n]):
			if (int(allTiles[n].position.x + allTiles[n].position.z)%2 == 1 or int(allTiles[n].position.x + allTiles[n].position.z)%2 == -1):
				allTiles[n].setColor(Global.colorDict["Black"])
			else:
				allTiles[n].setColor(Global.colorDict["White"])
		if tileDict["iTiles"].has(allTiles[n]):
			if mH.SH.interactable:
				allTiles[n].setColor(Global.colorDict["Orange"])
				allTiles[n].setColor(Global.colorDict["Green"])
			elif mH.SH.moving:
				allTiles[n].setColor(Global.colorDict["Blue"])
				if allTiles[n].contains is EnemyPiece:
					allTiles[n].setColor(Global.colorDict["Orange"])

func show():
	FloorData.floor.Pointer.visible = true
	if mH.SH.moving:
		tileDict["iTiles"] = PlayerData.playerInfo.pieceType.getMoveableTiles(PlayerData.playerInfo.currentPos)
	elif mH.SH.interactable:
		tileDict["iTiles"] = mH.SH.interactable.getTiles(PlayerData.playerInfo.currentPos)
	setTilePattern()

func stopShowing():
	tileDict["iTiles"].clear()
	mH.SH.moving = false
	setTilePattern()

func checkHazards():
	if !FloorData.floorInfo.playerTurn:
		if PlayerData.playerPiece.currentTile.hazard:
			if PlayerData.playerPiece.currentTile.hazard.effectType == "OnRest":
				if PlayerData.playerPiece.currentTile.hazard.effect.nextFloor:
					FloorData.nextFloor()
