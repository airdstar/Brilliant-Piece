extends Handler

@onready var movement = $MovementNode
@onready var action = $ActionNode

func _ready():
	mH = get_parent()

func makeDecision():
	if FloorData.floor.enemies.size() != 0:
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
			if possibleActions.size() != 0:
				var decidedAction = randi_range(0, possibleActions.size()/3 - 1)
				mH.SH.actingPiece = possibleActions[decidedAction * 3]
				mH.SH.interactable = possibleActions[1 + (decidedAction * 3)]

				mH.IH.interact(possibleActions[2 + (decidedAction * 3)])
			
	FloorData.floorInfo.endTurn()
		
