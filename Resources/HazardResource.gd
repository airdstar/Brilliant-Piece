extends Resource
class_name HazardResource

@export var name : String
@export var visible : bool
@export var associatedModel : String

@export var blockade : bool
@export_enum("None", "OnTouch", "OnRest") var effectType : String

@export var AOE : AOEResource
@export var status : StatusResource
