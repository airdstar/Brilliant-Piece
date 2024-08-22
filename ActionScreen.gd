extends Node

@onready var playerData = $PlayerData/HealthLabel
@onready var enemyData = $EnemyData/HealthLabel

func _ready():
	pass

func setEnemy(enemy : EnemyPiece):
	$SubViewport/ActionBase.enemy = enemy
	$SubViewport/ActionBase.add_child(enemy)

func setPlayer(player : PlayerPiece):
	$SubViewport/ActionBase.player = player
	$SubViewport/ActionBase.add_child(player)

func updateHUD(player : PlayerPiece, enemy):
	enemyData.text = "HP: " + str(enemy.health) + "/" + str(enemy.maxHealth)
	playerData.text = "HP: " + str(player.health) + "/" + str(player.maxHealth)

func cameraControls(twistAmount : float):
	$SubViewport/ActionBase.twist = twistAmount

func _process(delta):
	var texture = $SubViewport.get_texture()
	$Screen.texture = texture
