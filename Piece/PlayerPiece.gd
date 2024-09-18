extends MoveablePiece
class_name PlayerPiece

var classType : ClassResource
var dataLoad = true

func _ready():
	if dataLoad:
		PlayerData.loadInfo()
	else:
		setData()

func loadData():
	type = PlayerData.playerInfo.pieceType
	classType = PlayerData.playerInfo.classType
	
	level = PlayerData.playerInfo.level
	
	health = PlayerData.playerInfo.health
	maxHealth = PlayerData.playerInfo.maxHealth
	armor = PlayerData.playerInfo.armor
	
	loadModel()

func setData():
	PlayerData.playerInfo = PlayerInfo.new()
	classType = ResourceLoader.load("res://Resources/Class Resources/CrystalSage.tres")
	pieceName = classType.className
	type = ResourceLoader.load("res://Resources/PieceType Resources/Queen.tres")
	level = 1
	maxHealth = classType.startingHealth
	health = maxHealth
	
	PlayerData.playerInfo.actions = classType.startingActions
	PlayerData.playerInfo.items.clear()
	PlayerData.playerInfo.maxHealth = maxHealth
	PlayerData.playerInfo.health = health
	
	
	loadModel()

func loadModel():
	var s = ResourceLoader.load(classType.associatedModel)
	s = s.instantiate()
	modelHolder.add_child(s)

func updateData():
	level = PlayerData.playerInfo.level
	
