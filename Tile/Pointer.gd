extends Node3D

var up : bool = true

@onready var top = $Top
@onready var bottom = $Bottom

func _ready():
	pass

func setColor(color : Color):
	top.mesh.material.set_albedo(color)
	bottom.mesh.material.set_albedo(color)

func SwitchBob():
	var topTween = create_tween()
	var bottomTween = create_tween()
	if up:
		topTween.tween_property(top,"position",Vector3(0,0.1 + 0.165,0),1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
		bottomTween.tween_property(bottom,"position",Vector3(0,0.1 - 0.246,0),1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	else:
		topTween.tween_property(top,"position",Vector3(0,0 + 0.165,0),1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
		bottomTween.tween_property(bottom,"position",Vector3(0,0 - 0.246,0),1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	
	up = !up
