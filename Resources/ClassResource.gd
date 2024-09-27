extends Resource
class_name ClassResource

@export_category("General")
@export var className : String
@export var associatedModel : String

@export_category("Starting")
@export var startingHealth : int
@export var startingActions : Array[ActionResource]
@export var startingItems : Array[ItemResource]

@export_category("Leveling")
@export var levelingHealthIncrease : Array[int]
@export var levelingActions : Array[ActionResource]
