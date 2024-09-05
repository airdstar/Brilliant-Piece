extends Node

var currentFloor : Floor

var allFloorTiles : Array[tile]
var playerFloorTile : tile
var highlightedTile : tile

var playerPiece : PlayerPiece
var neutralPieces : Array[MoveablePiece]
var enemyPiece : Array[EnemyPiece]
var enemyBehaviors : Array[String]

var playerTurn : bool = true
var actionUsed : bool = false
var moveUsed : bool = false

var viewing : bool = false
var item : ItemResource
var moving : MoveablePiece
var action : ActionResource

func generatePlayer():
	playerPiece = preload("res://Piece/PlayerPiece.tscn").instantiate()
	playerPiece.classType = ResourceLoader.load("res://Resources/Class Resources/CrystalSage.tres")
	playerPiece.type = ResourceLoader.load("res://Resources/PieceType Resources/Queen.tres")
	currentFloor.add_child(playerPiece)
