extends Handler

@onready var movement = $MovementNode
@onready var action = $ActionNode

func _ready():
	mH = get_parent()

func makeDecision():
	

	var bestMovements = movement.get_best_movements()
	if bestMovements != null:
		var currentNum = randi_range(0, bestMovements.size() - 1)
		var counter := 0
		var canMove := true
		while bestMovements[currentNum].rc == FloorData.floor.enemies[currentNum].rc:
			currentNum = randi_range(0, bestMovements.size() - 1)
			counter += 1
			if counter == 5:
				canMove = false
				break
		if canMove:
			mH.SH.actingPiece = FloorData.floor.enemies[currentNum]
			mH.IH.movePiece(bestMovements[currentNum])
		else:
			print("Unable to move for some reason")
		
		
		var possibleActions = action.get_possible_actions()
		FloorData.floorInfo.endTurn()
		
