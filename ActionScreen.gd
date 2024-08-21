extends Node

func _ready():
	pass

func setEnemy(enemy : EnemyPiece):
	$SubViewport/ActionBase.enemy = enemy
	$SubViewport/ActionBase.add_child(enemy)

func setPlayer(player : PlayerPiece):
	$SubViewport/ActionBase.player = player
	$SubViewport/ActionBase.add_child(player)

func cameraControls(twistAmount : float):
	$SubViewport/ActionBase.twist = twistAmount

func _process(delta):
	var texture = $SubViewport.get_texture()
	$Screen.texture = texture
