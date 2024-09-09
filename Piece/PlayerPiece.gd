extends MoveablePiece
class_name PlayerPiece

@export var classType : ClassResource

var level : int = 1
var maxSoul : int 
var soul : int 
var actions : Array[ActionResource]
var items : Array[ItemResource]

func _ready():
	#Items must be loaded in through ready
	items.append(ResourceLoader.load("res://Resources/Item Resources/Bomb.tres"))
	items.append(ResourceLoader.load("res://Resources/Item Resources/Cone.tres"))
	setData()

func setData():
	maxHealth = classType.startingHealth
	health = maxHealth
	maxSoul = classType.startingSoul
	soul = maxSoul
	actions = classType.startingActions
	
	var s = ResourceLoader.load(classType.associatedModel)
	s = s.instantiate()
	modelHolder.add_child(s)

func levelUp():
	pass
