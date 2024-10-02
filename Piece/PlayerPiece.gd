extends MoveablePiece
class_name PlayerPiece

var classType : ClassResource

func _ready():
	PlayerData.loadInfo()
	self.death.connect(FloorData.floor.pieceDeath)

func loadData():
	type = PlayerData.playerInfo.pieceType
	classType = PlayerData.playerInfo.classType
	pieceName = classType.className
	
	level = PlayerData.playerInfo.level
	
	health = PlayerData.playerInfo.health
	maxHealth = PlayerData.playerInfo.maxHealth
	armor = PlayerData.playerInfo.armor
	

func setData():
	PlayerData.playerInfo.isNew = false
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
	PlayerData.playerInfo.classType = classType
	PlayerData.playerInfo.pieceType = type
	
	$TextureRect.set_texture(ResourceLoader.load(classType.associatedSprite))
	

func updateData():
	level = PlayerData.playerInfo.level
	health = PlayerData.playerInfo.health
	maxHealth = PlayerData.playerInfo.maxHealth
	armor = PlayerData.playerInfo.armor
	
