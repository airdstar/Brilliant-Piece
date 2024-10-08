extends Handler

@onready var movement = $MovementNode
@onready var action = $ActionNode

func _ready():
	mH = get_parent()


func makeDecision():
	if !FloorData.floorInfo.moveUsed:
		var bestMovements = movement.getBestMovements()
		var currentNum = randi_range(0, FloorData.floor.enemies.size() - 1)
		mH.SH.actingPiece = FloorData.floor.enemies[currentNum]
		mH.IH.movePiece(bestMovements[currentNum])
