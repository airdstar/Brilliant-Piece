extends Node

var save_path := "user://PlayerData.save"

var classType : ClassResource
var pieceType : String

var level : int = 1
var expAmount : int

var maxHealth : int
var health : int
var armor : int

var actions : Array[ActionResource]
var items : Array[ItemResource]

var coins : int = 0
var soul : int = 0

func Save():
	pass

func Load():
	pass

func updateData():
	health = GameState.pieceDict["Player"]["Piece"].health
	maxHealth = GameState.pieceDict["Player"]["Piece"].maxHealth
	armor = GameState.pieceDict["Player"]["Piece"].armor
	pieceType = GameState.pieceDict["Player"]["Piece"].pieceType
	classType = GameState.pieceDict["Player"]["Piece"].classType

func levelUp():
	level += 1
	
	GameState.pieceDict["Player"]["Piece"].updateData()
	gainExp(0)

func gainExp(amount : int):
	expAmount += amount
	if expAmount >= Global.expArray[level - 1]:
		expAmount -= Global.expArray[level - 1]
		levelUp()
