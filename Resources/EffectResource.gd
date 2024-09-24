extends Resource
class_name EffectResource

@export_category("General")
@export var name : String
@export_enum("Damage", "Health", "Other") var type : String
@export var effectStrength : int = 0  #Additive to normal
@export var effectPercent : float = 1.00 #Negative for opposite value

@export_category("Displacement")
@export var stopMovement : bool
@export_enum("Forward", "Left", "Right", "Backward") var disDirection : String

@export_category("Misc")
@export var nextFloor : bool
@export var delete : bool
