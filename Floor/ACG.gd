extends RefCounted
class_name ACG

var grid : AStar2D = AStar2D.new()
var size : Vector2i = Vector2i.ZERO
var point_ids : Array
var pref_direction : String = "Straight"

func create_new_grid(gridSize : Vector2i):
	grid = AStar2D.new()
	size = gridSize
	var currentId : int = 0
	for n in range(size.x):
		point_ids.append([])
		for m in range(size.y):
			currentId += 1
			point_ids[n].append(currentId)
			grid.add_point(point_ids[n][m], Vector2(n,m))
			if FloorData.tiles[n][m] == null:
				grid.set_point_disabled(point_ids[n][m])

func set_info(piece : MoveablePiece):
	pref_direction = piece.type.movementAngle
	remove_connections()
	configure_points()
	create_connections()

func create_connections():
	var posData = FloorData.floor.Handlers.DH.posDict[pref_direction]

	for n in range(size.x):
		for m in range(size.y):
			if point_ids[n][m] != null:
				for o in range(posData.size()):
					var current_point = Vector2i(n,m) + posData[o]
					if is_in_range(current_point):
						if point_ids[current_point.x][current_point.y] != null:
							if !grid.are_points_connected(point_ids[current_point.x][current_point.y], point_ids[n][m]):
								grid.connect_points(point_ids[n][m], point_ids[current_point.x][current_point.y])

func remove_connections():
	for n in range(size.x):
		for m in range(size.y):
			if point_ids[n][m] != null:
				var toRemove = grid.get_point_connections(point_ids[n][m])
				for o in range(toRemove.size()):
					grid.disconnect_points(point_ids[n][m], toRemove[o])

func configure_points():
	for n in range(size.x):
		for m in range(size.y):
			if FloorData.tiles[n][m] != null:
				if FloorData.tiles[n][m].obstructed or FloorData.tiles[n][m].contains is EnemyPiece:
					grid.set_point_disabled(point_ids[n][m])
				else:
					grid.set_point_disabled(point_ids[n][m], false)

func get_vector_path(start: Vector2, end : Vector2):
	return grid.get_point_path(point_ids[start.x][start.y], point_ids[end.x][end.y], true)

func get_path_length(start: Vector2, end : Vector2):
	return grid.get_id_path(point_ids[start.x][start.y], point_ids[end.x][end.y], true).size()

func is_in_range(check : Vector2):
	if check.x < 0 or check.y < 0 or check.x >= size.x or check.y >= size.y:
		return false
	else:
		return true
