extends Resource
class_name EffectResource

@export_category("General")
@export var name : String

@export_category("Stats")
@export var damage : int
@export var heal : int

@export_category("Displacement")
@export var stopMovement : bool
@export var disAmount : int
@export_enum("Forward", "Left", "Right", "Backward") var disDirection : String

@export_category("Misc")
@export var nextFloor : bool
