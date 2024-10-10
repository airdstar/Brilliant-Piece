extends Resource
class_name HazardResource

@export_category("General")
@export var name : String
@export var visible : bool
@export var associatedSprite : Texture2D

@export_category("Stats")
@export var blockade : bool
@export var replaceable : bool = false
@export var destructable : bool = false
@export_enum("OnTouch", "OnRest") var effectType : String

@export var AOE : AOEResource
@export var effect : EffectResource
