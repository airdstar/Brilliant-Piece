extends MoveablePiece
class_name PlayerPiece

@export var classType : ClassResource

var level : int = 1
var maxSoul : int 
var soul : int 
var actions : Array[ActionResource]
@export var items : Array[ItemResource]

func _ready():
	type = ResourceLoader.load("res://Resources/PieceType Resources/Queen.tres")
	setData()

func setData():
	maxHealth = classType.startingHealth
	health = maxHealth
	maxSoul = classType.startingSoul
	soul = maxSoul
	actions = classType.startingActions
	
	var s = ResourceLoader.load(classType.associatedScene)
	s = s.instantiate()
	add_child(s)

func levelUp():
	pass
