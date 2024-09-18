extends PlayableArea
class_name Floor

var floorNum : int = 0
var layerData : LayerResource

func _ready():
	getLayerData()
	GameState.currentFloor = self
	InterfaceHandler.HUD = $Menu/HUD
	GenerationHandler.generateFloor()
	MenuHandler.openMenu()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta : float):
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("Test"):
		PlayerData.saveInfo()
	
	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()

	cameraControls()

func getLayerData():
	if floorNum == 0:
		layerData = ResourceLoader.load("res://Resources/Layer Resources/TestLayer.tres")
	elif floorNum <= 5:
		layerData = ResourceLoader.load("res://Resources/Layer Resources/StartingLayer.tres")

func pieceDeath(piece : MoveablePiece):
	if piece is EnemyPiece:
		PlayerData.gainExp(piece.enemyType.expAmount)
		PlayerData.playerInfo.items.append(piece.enemyType.itemPool.items[randi_range(0, piece.enemyType.itemPool.items.size() - 1)])
