extends Node

var area

var controllable : Array[EnemyPiece]
var controllableBehavior : Array[String]
var targets : Array[Piece]

func _ready():
	area = get_parent()

func makeDecision():
	if !area.moveUsed:
		var bestMovement
		for n in range(controllable.size()):
			var possibleTiles = area.findMoveableTiles(controllable[n], true)
			findBestMovement(targets[0], possibleTiles, controllable[n], controllableBehavior[n])

func findBestMovement(target : MoveablePiece, possibleMovement, piece : EnemyPiece, behavior : String):
	match behavior:
		"Approach":
			var closestTileDirection = Directions.getClosestDirection(piece.currentTile.global_position, target.currentTile.global_position)
			var closestExists := false
			for n in range(possibleMovement.size()):
				if possibleMovement[n] == area.lookForTile(piece.currentTile.global_position + Directions.getDirection(closestTileDirection)):
					area.moving = piece
					var closestTile = area.findClosestTileToTarget(target.currentTile.position, Directions.getDirection(closestTileDirection))
					area.movePiece(closestTile)
					area.usedMove()
					closestExists = true
			if !closestExists:
				for n in range(possibleMovement.size()):
					if possibleMovement[n] == area.lookForTile(piece.currentTile.global_position + Directions.getSides(Directions.getDirection(closestTileDirection))[0]):
						area.moving = piece
						area.movePiece(possibleMovement[n])
						area.usedMove()
					elif possibleMovement[n] == area.lookForTile(piece.currentTile.global_position + Directions.getSides(Directions.getDirection(closestTileDirection))[1]):
						area.moving = piece
						area.movePiece(possibleMovement[n])
						area.usedMove()


func setEnemies(enemy):
	controllable.append(enemy)
	controllableBehavior.append("Approach")

func setTargets(target):
	targets.append(target)
