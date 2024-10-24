extends Resource
class_name Interactable

@export_category("General")
@export var name : String = "Placeholder"
@export var desc : String = "Placeholder"
@export_enum("Damage", "Healing", "Defensive", "Hazard", "Status", "Movement", "Creation") var type : String = "Damage"
@export var AOE : AOEResource = null
@export_flags("Self", "Others", "Tile") var usableOn : int = 2

@export_category("Basic Stats")
@export var damage : int
@export var healing : int
@export var armor : int
@export var status : StatusResource
@export var hazard : HazardResource
@export var effect : EffectResource

func getTiles(_iStart : Vector2i):
	pass

func getUsable():
	pass

func get_relevant_tiles(_aStart : Vector2i, pieceType : int):
	pass

func has_target(_actionRange : Array[tile], _iStart : Vector2i):
	pass
