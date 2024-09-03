extends Node

var area

var controllableNum : int
var controllable : Array[EnemyPiece]
var targets : Array[Piece]

func _ready():
	area = get_parent()
	#controllable[0] = area.enemies
	#targets[0] = area.player

func setEnemies():
	pass

func setTargets():
	pass
