extends Resource
class_name ClassResource

#CLASSES
## CrystalSage Pyromancer Speedster Gunslinger Brawler

@export var className : String
@export var actions : ActionSetResource
@export var maxHealth : int
@export var maxSoul : int
@export var associatedScene : String

func _ready():
	if maxHealth:
		print("hi")
