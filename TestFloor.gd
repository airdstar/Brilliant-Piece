extends PlayableArea
class_name Floor

func _ready():
	GameState.currentFloor = self
	InterfaceHandler.HUD = $Menu/HUD
	GenerationHandler.generateFloor()
	GenerationHandler.generatePlayer()
	GenerationHandler.generateEnemies()
	GenerationHandler.placePieces()
	MenuHandler.openMenu()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta : float):
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("Test"):
		GameState.endTurn()
	
	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()

	cameraControls()
