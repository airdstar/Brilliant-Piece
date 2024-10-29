extends Handler

func _process(_delta: float):
	if mH.SH.moving == true or mH.SH.interactable != null:
		if Input.is_action_just_pressed("Select"):
			if mH.TH.iTiles.has(mH.TH.highlightedTile):
				interact(mH.TH.highlightedTile)
			elif mH.SH.moving == true and mH.TH.highlightedTile.contains is PlayerPiece:
				mH.TH.stopShowing()
	else:
		if Input.is_action_just_pressed("Select"):
			if !FloorData.floorInfo.moveUsed:
				if mH.TH.highlightedTile != null:
					if mH.TH.highlightedTile.contains is PlayerPiece:
						mH.SH.actingPiece = mH.TH.highlightedTile.contains
						mH.SH.moving = true
						mH.TH.show()
		

func movePiece(destination : tile):
	var piece = mH.SH.actingPiece
	if piece is PlayerPiece:
		mH.TH.stopShowing()
	
	var closestDirection = mH.DH.getClosestDirection(piece.rc, destination.rc)
	var posData = mH.DH.dirDict["PosData"][closestDirection]
	var currentTile : tile = FloorData.tiles[piece.rc.x][piece.rc.y]
	
	if !piece.type.skip:
		while currentTile != destination:
			
			currentTile = FloorData.tiles[currentTile.rc.x + posData.x][currentTile.rc.y + posData.y]
			
			if currentTile.hazard:
				if currentTile.hazard.effectType == "OnTouch":
					if currentTile.hazard.effect.stopMovement:
						destination = currentTile
	
	if destination.contains:
		if destination.contains is MoveablePiece:
			pushPiece(destination.contains, closestDirection)
	
	destination.setPiece(piece, 1)
	mH.UH.usedMovement()
	if piece is PlayerPiece:
		mH.UH.displayInfo()
			
	mH.SH.actingPiece = null
	mH.SH.moving = false
	FloorData.updateData()

func pushPiece(piece : MoveablePiece, direction : int):
	var dirVect : Vector2 = mH.DH.dirDict["PosData"][direction]
	var pieceHealth := piece.health
	if piece.rc.x + dirVect.x >= 0 and piece.rc.y + dirVect.y >= 0 and piece.rc.x + dirVect.x < FloorData.floorInfo.rc.x and piece.rc.y + dirVect.y < FloorData.floorInfo.rc.y:
		var currentTile = FloorData.tiles[piece.rc.x + mH.DH.dirDict["PosData"][direction].x][piece.rc.y + mH.DH.dirDict["PosData"][direction].y]
		if currentTile:
			if currentTile.hazard:
				if currentTile.hazard.effectType == "OnTouch":
					print("hi")
					
			if currentTile.contains or currentTile.obstructed:
				if currentTile.obstructed:
					currentTile.remove_hazard()
				elif currentTile.contains:
					pushPiece(currentTile.contains, direction)
				
				piece.damage(2)
				if pieceHealth > 2:
					currentTile.setPiece(piece, 2)
			else:
				piece.damage(1)
				if pieceHealth > 1:
					currentTile.setPiece(piece, 2)
			
			
		else:
			piece.damage(2)
			if pieceHealth > 2:
				var tween = create_tween()
				tween.tween_property(piece, "position", piece.position + (dirVect * 32), 0.15
									).set_trans(Tween.TRANS_QUART)
				
				await get_tree().create_timer(0.15).timeout
				
				
				mH.TH.getEmptyTile().setPiece(piece,3)
			
	else:
		piece.damage(2)
		if pieceHealth > 2:
			var tween = create_tween()
			tween.tween_property(piece, "position", piece.position + (dirVect * 32), 0.15
									).set_trans(Tween.TRANS_QUART)
				
			await get_tree().create_timer(0.15).timeout
			
			mH.TH.getEmptyTile().setPiece(piece,3)

func interact(destination : tile):
	if mH.SH.moving == true:
		movePiece(destination)
	else:
		destination.interact()
		if mH.SH.interactable.AOE:
			mH.TH.aoeTiles = mH.SH.interactable.AOE.getAOE(destination.rc, mH.DH.getClosestDirection(mH.SH.actingPiece.rc, destination.rc))
			
			for n in range(mH.TH.aoeTiles.size()):
				mH.TH.aoeTiles[n].interact()
	
	
	mH.TH.stopShowing()
	if mH.TH.highlightedTile != null:
		mH.HH.highlightTile(mH.TH.highlightedTile.rc)
	else:
		mH.TH.setTilePattern()
	
