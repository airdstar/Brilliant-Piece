extends Node

var MovementThread : Thread
var MovementSemaphore: Semaphore
var MovementMutex : Mutex

var ActionThread : Thread
var ActionSemaphore: Semaphore
var ActionMutex: Mutex

var exit_thread : bool = false

var possibleTiles
var tileValueHolder : Array[int]

func _ready():
	MovementThread = Thread.new()
	MovementSemaphore = Semaphore.new()
	MovementMutex = Mutex.new()
	
	ActionThread = Thread.new()
	ActionSemaphore = Semaphore.new()
	ActionMutex = Mutex.new()
	
	MovementThread.start(getMovementData)
	ActionThread.start(getActionData)

func _process(_delta: float):
	if !GameState.playerTurn:
		makeDecision()

func makeDecision():
	if !GameState.moveUsed:
		for n in range(GameState.enemyPieces.size()):
			possibleTiles = MovementHandler.findMoveableTiles(GameState.enemyPieces[n])
			#MovementThread.start(findBestMovement.bind(GameState.playerPiece, GameState.enemyPieces[n], "Approach"))

func findBestMovement(target : MoveablePiece, piece : EnemyPiece, behavior : String):
	match behavior:
		"Approach":
			#GameState.moving = piece
			call_deferred("findClosestTileToTarget", target.currentTile.global_position)
			#MovementHandler.movePiece(findClosestTileToTarget(target.currentTile.global_position))
			#GameState.endTurn()

func findClosestTileToTarget(target : Vector3):
	for n in range(GameState.allFloorTiles.size()):
		if tileValueHolder.size() != GameState.allFloorTiles.size():
			tileValueHolder.append(200)
		else:
			tileValueHolder[n] = 200
		if TileHandler.lookForTile(target) == GameState.allFloorTiles[n]:
			tileValueHolder[n] = 0
	
	var possibleDirections : Array[Vector3] = []
	for n in range(4):
		if TileHandler.lookForTile(target + DirectionHandler.getPos(DirectionHandler.getAll("Straight")[n])):
			possibleDirections.append(target + DirectionHandler.getPos(DirectionHandler.getAll("Straight")[n]))
	call_deferred_thread_group("checkNearbyTiles", possibleDirections, 1)
	
	var lowestDistance = 200
	var closestTile
	for n in range(possibleTiles.size()):
		var currentTileNum = GameState.allFloorTiles.find(possibleTiles[n])
		if tileValueHolder[currentTileNum] < lowestDistance:
			print("hi")
			lowestDistance = tileValueHolder[currentTileNum]
			closestTile = possibleTiles[n]
	
	return closestTile

func checkNearbyTiles(allTiles : Array[Vector3], currentDistance : int):
	var foundATile : bool = false
	for n in range(allTiles.size()):
		var currentTileNum = GameState.allFloorTiles.find(TileHandler.lookForTile(allTiles[n]))
		if tileValueHolder[currentTileNum] > currentDistance:
			tileValueHolder[currentTileNum] = currentDistance
			foundATile = true
			if !GameState.allFloorTiles[currentTileNum].contains == GameState.enemyPieces[0]:
				var possibleDirections : Array[Vector3] = []
				for m in range(4):
					if TileHandler.lookForTile(allTiles[n] + DirectionHandler.getPos(DirectionHandler.getAll("Straight")[m])):
						possibleDirections.append(allTiles[n] + DirectionHandler.getPos(DirectionHandler.getAll("Straight")[m]))
				checkNearbyTiles(possibleDirections, currentDistance + 1)
	if !foundATile:
		return

func getMovementData():
	while true:
		MovementSemaphore.wait()
		
		MovementMutex.lock()
		var should_exit = exit_thread
		MovementMutex.unlock()

		if should_exit:
			break
		
		MovementMutex.lock()
		for n in range (GameState.enemyPieces.size()):
			findBestMovement(GameState.playerPiece, GameState.enemyPieces[0], "Approach")
		MovementMutex.unlock()

func getActionData():
	while true:
		ActionSemaphore.wait()
		
		ActionMutex.lock()
		var should_exit = exit_thread
		ActionMutex.unlock()

		if should_exit:
			break
		
		ActionMutex.lock()
		pass
		ActionMutex.unlock()

func _exit_tree():
	MovementMutex.lock()
	MovementMutex.unlock()
	ActionMutex.lock()
	ActionMutex.unlock()
	
	exit_thread = true 
	
	MovementSemaphore.post()
	ActionSemaphore.post()
	
	MovementThread.wait_to_finish()
	ActionThread.wait_to_finish()
