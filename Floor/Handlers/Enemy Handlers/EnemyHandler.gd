extends Handler

@onready var movement = $MovementNode
@onready var action = $ActionNode
@onready var behavior = $ActionNode

func _ready():
	mH = get_parent()

func makeDecision():
	
	behavior
	
	# Array that stores order of action and movement for a specified piece
	# Array goes first then second, first then second, etc...
	var possibleCombos : Array
	# Stores the piece that correlates with the position of first part of combo
	# 1 = 1, 2 = 3, 3 = 5, 4 = 7, etc...
	var comboPieces : Array[EnemyPiece]
	
	if !FloorData.floorInfo.actionUsed and !FloorData.floorInfo.moveUsed:
		# Determine which should happen first
		mH.UH.usedAction()
		makeDecision()
	elif !FloorData.floorInfo.moveUsed:
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
	elif !FloorData.floorInfo.actionUsed:
		pass
	else:
		FloorData.floorInfo.endTurn()
		
