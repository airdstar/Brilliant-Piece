extends MoveablePiece
class_name PlayerPiece

@export var classType : ClassResource
@export var type : String

var level : int = 1
var maxHealth : int 
var health : int 
var maxSoul : int 
var soul : int 
var attacks : Array[AttackResource]

func _ready():
	#Add check for saves
	setData()

func setData():
	maxHealth = classType.maxHealth
	health = maxHealth
	maxSoul = classType.maxSoul
	soul = maxSoul
	for n in range(5):
		attacks.append(classType.attacks.attacks[n])
	
	var s = ResourceLoader.load(classType.associatedScene)
	s = s.instantiate()
	add_child(s)

func levelUp():
	pass
