extends Handler

var cell_size : Vector2i = Vector2i(32,32)

var astar_grid = AStarGrid2D.new()
var grid_size
var start : Vector2i
var end : Vector2i

func setTileMap():
	grid_size = FloorData.floorInfo.rc
	astar_grid.region = Rect2i(Vector2i(0,0),grid_size)
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2 - Vector2i(1,1)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()
	FloorData.floor.line.position = Vector2(200,0)
	setSolidTiles()

func setStartEnd():
	start = FloorData.floorInfo.enemies[0].rc
	end = PlayerData.playerInfo.rc
	update_path()
	print(astar_grid.get_id_path(start,end,true))

func setSolidTiles():
	for n in range(FloorData.floorInfo.rc.x):
		for m in range(FloorData.floorInfo.rc.y):
			var makeSolid := false
			if FloorData.tiles[n][m] == null:
				makeSolid = true
			elif FloorData.tiles[n][m].obstructed:
				makeSolid = true
			
			astar_grid.set_point_solid(Vector2i(n,m), makeSolid)
			

func update_path():
	FloorData.floor.line.points = PackedVector2Array(astar_grid.get_point_path(start, end, true))

func makeDecision():
	if !FloorData.floorInfo.moveUsed:
		var bestMovement : tile
		var possibleMovements = FloorData.floor.enemies[0].type.getMoveableTiles(start)
		for n in range(astar_grid.get_id_path(start,end,true).size()):
			var currentTile = FloorData.tiles[astar_grid.get_id_path(start,end,true)[n].x][astar_grid.get_id_path(start,end,true)[n].y]
			if possibleMovements.has(currentTile):
				bestMovement = currentTile
		mH.SH.actingPiece = FloorData.floor.enemies[0]
		mH.IH.movePiece(bestMovement)
