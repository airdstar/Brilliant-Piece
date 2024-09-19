extends Node

var currentFloor : Floor

var tileDict : Dictionary

var pieceDict : Dictionary

var playerTurn : bool = true
var actionUsed : bool = false
var moveUsed : bool = false

var currentMenu = null
var actingPiece : Piece
var item : ItemResource = null
var moving : MoveablePiece = null
var action : ActionResource = null

func _ready():
	pieceDict = {"Neutral" : 2,
				"Enemy" : 2}

func endTurn():
	playerTurn = !playerTurn
	actionUsed = false
	moveUsed = false
	InterfaceHandler.endedTurn()
	if playerTurn:
		InterfaceHandler.openMenu()
	else:
		currentFloor.Pointer.visible = true
		currentFloor.enemyController.makeDecision()

func saveState():
	FloorData.saveInfo()
	PlayerData.saveInfo()

func loadState():
	pass
