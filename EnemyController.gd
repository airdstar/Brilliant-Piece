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
	if area.moveUsed:
		area.endTurn()

func findBestMovement(target : MoveablePiece, possibleMovement, piece : EnemyPiece, behavior : String):
	match behavior:
		"Approach":
			var closestTile = Directions.getClosestDirection(piece.currentTile.global_position, target.global_position)
			if area.lookForTile(closestTile):
				pass


func setEnemies(enemy):
	controllable.append(enemy)
	controllableBehavior.append("Approach")

func setTargets(target):
	targets.append(target)
