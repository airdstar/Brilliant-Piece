extends Handler

@onready var movement = $MovementNode
@onready var action = $ActionNode

func _ready():
	mH = get_parent()


func makeDecision():
	if !FloorData.floorInfo.moveUsed:
		var bestMovements = movement.getBestMovements()
		var currentNum = randi_range(0, bestMovements.size() - 1)
		var counter := 0
		var canMove := true
		while bestMovements[currentNum] == null:
			currentNum = randi_range(0, bestMovements.size() - 1)
			counter += 1
			if counter == 5:
				canMove = false
				break
		if canMove:
			mH.SH.actingPiece = FloorData.floor.enemies[currentNum]
			mH.IH.movePiece(bestMovements[currentNum])
