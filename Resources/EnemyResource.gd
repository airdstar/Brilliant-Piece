extends Resource
class_name EnemyResource

@export var name : String
@export var type : Array[String]
@export var maxHealth : int

@export var maxLevel : int
@export var minLevel : int
@export var minFloor : int
@export var maxFloor : int

@export var attacks : AttacksetResource

func _ready():
	if maxHealth:
		print("hi")
