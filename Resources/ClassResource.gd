extends Resource
class_name ClassResource

@export_category("General")
@export var className : String
@export var actions : ActionSetResource
@export var associatedModel : String

@export_category("Starting")
@export var startingHealth : int
@export var startingActions : Array[ActionResource]
