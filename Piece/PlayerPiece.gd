extends MoveablePiece
class_name PlayerPiece

@export var classType : ClassResource
@export var type : String

var level : int = 1
var maxSoul : int 
var soul : int 
var actions : Array[ActionResource]

func _ready():
	#Add check for saves
	setData()

func setData():
	maxHealth = classType.maxHealth
	health = maxHealth
	maxSoul = classType.maxSoul
	soul = maxSoul
	for n in range(5):
		actions.append(classType.actions.actions[n])
	
	var s = ResourceLoader.load(classType.associatedScene)
	s = s.instantiate()
	add_child(s)

func levelUp():
	pass
