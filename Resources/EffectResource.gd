extends Resource
class_name EffectResource

@export_category("General")
@export var name : String
@export_enum("Damage", "Health", "Change", "Displacement", "Misc") var type : String
##Affects the strength of anything that has a numerical value to it
@export var effectStrength : int = 0
##Multiplied by the strength. Make negative to grant opposite effect
@export var effectPercent : float = 1.00

## Only 1 change can happen per effect
@export_category("Change")
@export var adjustMaxHealth : bool
@export var pieceType : PieceTypeResource
@export var giveItem : ItemResource

@export_category("Displacement")
@export var stopMovement : bool
@export_enum("Toward", "Opposite", "Set") var disDirection : String

@export_category("Misc")
@export var nextFloor : bool
@export var delete : bool
