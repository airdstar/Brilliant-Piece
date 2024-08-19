extends MoveablePiece
class_name PlayerPiece

@export var classType : ClassResource
@export var type : String

var level : int = 1
var maxHealth : int 
var health : int 
var maxSoul : int 
var soul : int 


func _ready():
	maxHealth = classType.maxHealth
	health = maxHealth
	maxSoul = classType.maxSoul
	soul = maxSoul
	
	var s = ResourceLoader.load(classType.associatedScene)
	s = s.instantiate()
	add_child(s)
