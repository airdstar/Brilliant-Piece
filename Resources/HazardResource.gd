extends Resource
class_name HazardResource

@export_category("General")
@export var name : String
@export var visible : bool
@export var associatedModel : String

@export_category("Stats")
@export var blockade : bool
@export var destructable : bool = false
@export_enum("None", "OnTouch", "OnRest") var effectType : String


@export var AOE : AOEResource
@export var effect : EffectResource
