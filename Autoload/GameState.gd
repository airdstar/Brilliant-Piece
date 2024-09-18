extends Node

var currentFloor : Floor

var tileDict : Dictionary

var pieceDict : Dictionary

var playerTurn : bool = true
var actionUsed : bool = false
var moveUsed : bool = false

var currentMenu = null
var item : ItemResource = null
var moving : MoveablePiece = null
var action : ActionResource = null

func _ready():
	var blankVar
	pieceDict = {"Neutral" : blankVar,
				"Enemy" : blankVar}

func endTurn():
	playerTurn = !playerTurn
	actionUsed = false
	moveUsed = false
	InterfaceHandler.endedTurn()
	if playerTurn:
		MenuHandler.openMenu()
	else:
		currentFloor.Pointer.visible = true
		currentFloor.enemyController.makeDecision()
