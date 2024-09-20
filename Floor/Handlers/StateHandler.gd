extends Handler

var actingPiece : MoveablePiece
var moving : bool = false
var item : ItemResource = null
var action : ActionResource = null

func endTurn():
	FloorData.floorInfo.playerTurn = !FloorData.floorInfo.playerTurn
	FloorData.floorInfo.actionUsed = false
	FloorData.floorInfo.moveUsed = false
	mH.UH.setTurnColors()
	if FloorData.floorInfo.playerTurn:
		mH.UH.openMenu()
	else:
		FloorData.floor.Pointer.visible = true
		FloorData.floor.enemyController.makeDecision()

func saveState():
	FloorData.saveInfo()
	PlayerData.saveInfo()

func loadState():
	FloorData.loadInfo()

func resetState():
	FloorData.resetInfo()
	PlayerData.resetInfo()
