extends Node

var MovementThread : Thread
var MovementSemaphore: Semaphore
var MovementMutex : Mutex

var ActionThread : Thread
var ActionSemaphore: Semaphore
var ActionMutex: Mutex

var exit_thread : bool = false

var possibleTiles = []
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


func makeDecision():
	if !GameState.moveUsed:
		possibleTiles = MovementHandler.findMoveableTiles(GameState.pieceDict["Enemy"]["Piece"][0])
		MovementSemaphore.post()

func findBestMovement(target : Vector3, piece : EnemyPiece, behavior : String):
	match behavior:
		"Approach":
			MovementHandler.movePiece(findClosestTileToTarget(target), piece)

func findClosestTileToTarget(target : Vector3):
	for n in range(GameState.tileDict["Tiles"].size()):
		if tileValueHolder.size() != GameState.tileDict["Tiles"].size():
			tileValueHolder.append(200)
		else:
			tileValueHolder[n] = 200
		if TileHandler.lookForTile(target) == GameState.tileDict["Tiles"][n]:
			tileValueHolder[n] = 0
	
	var possibleDirections : Array[Vector3] = []
	print(target)
	for n in range(4):
		if DirectionHandler.dirDict["PosData"].has(target + DirectionHandler.dirDict["PosData"][DirectionHandler.getAll("Straight")[n]]):
			possibleDirections.append(target + DirectionHandler.dirDict["PosData"][DirectionHandler.getAll("Straight")[n]])
	checkNearbyTiles(possibleDirections, 1)
	
	var lowestDistance = 200
	var closestTile
	
	
	return closestTile

func checkNearbyTiles(allTiles : Array[Vector3], currentDistance : int):
	var foundATile : bool = false
	for n in range(allTiles.size()):
		var currentTileNum = GameState.tileDict["Tiles"].find(TileHandler.lookForTile(allTiles[n]))
		if tileValueHolder[currentTileNum] > currentDistance:
			tileValueHolder[currentTileNum] = currentDistance
			foundATile = true
			if GameState.tileDict["Tiles"][currentTileNum].contains != GameState.pieceDict["Enemy"]["Piece"][0]:
				var possibleDirections : Array[Vector3] = []
				for m in range(4):
					if DirectionHandler.dirDict["PosData"].has(allTiles[n] + DirectionHandler.dirDict["PosData"][DirectionHandler.getAll("Straight")[m]]):
						possibleDirections.append(allTiles[n] + DirectionHandler.dirDict["PosData"][DirectionHandler.getAll("Straight")[m]])
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
		for n in range (GameState.pieceDict["Enemy"]["Piece"].size()):
			findBestMovement(GameState.pieceDict["Player"]["Position"], GameState.pieceDict["Enemy"]["Piece"][n], GameState.pieceDict["Enemy"]["Behavior"][n])
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
