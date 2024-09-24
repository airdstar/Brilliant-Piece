extends Resource
class_name StatusResource

@export var statusName : String
@export_enum("Buff", "Debuff") var statusType : String
@export var duration : int
var timePassed : int = 0

@export_enum("onEnd", "everyTurn") var statusEffect : String
@export var effect : EffectResource
