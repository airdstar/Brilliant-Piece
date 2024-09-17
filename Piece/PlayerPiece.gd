extends MoveablePiece
class_name PlayerPiece

@export var classType : ClassResource


func _ready():
	#Items must be loaded in through ready
	
	PlayerData.items.append(ResourceLoader.load("res://Resources/Item Resources/Bomb.tres"))
	PlayerData.items.append(ResourceLoader.load("res://Resources/Item Resources/Cone.tres"))
	PlayerData.items.append(ResourceLoader.load("res://Resources/Item Resources/IceCube.tres"))
	PlayerData.items.append(ResourceLoader.load("res://Resources/Item Resources/RegenOrb.tres"))
	setData()

func loadData():
	pass

func setData():
	level = 1
	maxHealth = classType.startingHealth
	health = maxHealth
	PlayerData.actions = classType.startingActions
	PlayerData.maxHealth = maxHealth
	PlayerData.health = health
	
	
	var s = ResourceLoader.load(classType.associatedModel)
	s = s.instantiate()
	modelHolder.add_child(s)

func updateData():
	level = PlayerData.level
	
