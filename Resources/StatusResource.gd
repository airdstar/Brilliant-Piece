extends Resource
class_name StatusResource

@export var statusName : String
@export var buff : bool = true
@export var duration : int
var timePassed : int = 0

@export_enum("onEnd", "everyTurn", "allTimes") var statusEffect : String
@export var effect : EffectResource

func flatValue():
	if buff:
		return effect.effectStrength
	return -effect.effectStrength

func percentValue():
	return effect.effectPercent
