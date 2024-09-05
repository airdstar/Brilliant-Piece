extends PlayableArea
class_name Floor

var soulUsed : bool = false
@export var tileAmount : int

func secondaryReady():
	GameState.currentFloor = self
	GenerationHandler.generateFloor()
	GenerationHandler.generatePlayer()
	GenerationHandler.generateEnemies()
	GenerationHandler.placePieces()
	MenuHandler.openMenu()
	openMenu()
	$EnemyController.setEnemies($EnemyPiece)
	$EnemyController.setTargets($PlayerPiece)

func secondaryProcess(_delta):
	if Input.is_action_just_pressed("Test"):
		endTurn()
	
	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()
