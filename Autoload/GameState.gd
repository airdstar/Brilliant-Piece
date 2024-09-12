extends Node

var currentFloor : Floor

var allFloorTiles
var allFloorTileLocations
var playerFloorTile : tile
var highlightedTile : tile

var playerPiece : PlayerPiece
var neutralPieces : Array[MoveablePiece]
var enemyPieces : Array[EnemyPiece]
var enemyBehaviors : Array[String]

var playerTurn : bool = true
var actionUsed : bool = false
var moveUsed : bool = false

var currentMenu = null
var item : ItemResource = null
var moving : MoveablePiece = null
var action : ActionResource = null

func endTurn():
	playerTurn = !playerTurn
	actionUsed = false
	moveUsed = false
	InterfaceHandler.endedTurn()
	if playerTurn:
		MenuHandler.openMenu()
	else:
		currentFloor.Pointer.visible = true
