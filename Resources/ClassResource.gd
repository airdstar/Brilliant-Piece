extends Resource
class_name ClassResource

#CLASSES
## CrystalSage Pyromancer Speedster Gunslinger

@export var className : String
@export var attacks : AttacksetResource
@export var maxHealth : int
@export var maxSoul : int
@export var associatedScene : String

func _ready():
	if maxHealth:
		print("hi")
