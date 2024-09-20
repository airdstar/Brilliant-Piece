extends Handler

var playerTurn : bool = true
var actionUsed : bool = false
var moveUsed : bool = false

var actingPiece : MoveablePiece
var moving : bool = false
var item : ItemResource = null
var action : ActionResource = null

func endTurn():
	playerTurn = !playerTurn
	actionUsed = false
	moveUsed = false
	mH.UH.endedTurn()
	if playerTurn:
		mH.UH.openMenu()
	else:
		FloorData.floor.Pointer.visible = true
		FloorData.floor.enemyController.makeDecision()

func saveState():
	FloorData.saveInfo()
	PlayerData.saveInfo()

func loadState():
	FloorData.loadInfo()
