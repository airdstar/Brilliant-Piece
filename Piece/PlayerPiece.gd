extends MoveablePiece
class_name PlayerPiece

@export var classType : ClassResource

var level : int = 1
var maxSoul : int 
var soul : int 
var actions : Array[ActionResource]
@export var items : Array[ItemResource]

func _ready():
	setData()

func setData():
	maxHealth = classType.startingHealth
	health = maxHealth
	maxSoul = classType.startingSoul
	soul = maxSoul
	actions = classType.startingActions
	
	var s = ResourceLoader.load(classType.associatedModel)
	s = s.instantiate()
	add_child(s)

func levelUp():
	pass
