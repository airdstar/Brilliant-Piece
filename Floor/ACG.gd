extends RefCounted
class_name ACG

enum Heuristic {
	EUCLIDEAN,
	MANHATTAN,
	OCTILE,
	CHEBYSHEV
}
enum DirectionMode {
	STRAIGHT,
	DIAGONAL,
	BOTH,
	L
}

var grid : AStar2D = AStar2D.new()
var size : Vector2i = Vector2i.ZERO
var pref_direction : DirectionMode = 0

func createNewGrid(gridSize : Vector2i):
	grid = AStar2D.new()
	size = gridSize

func createPoint(point : Vector2i):
	pass

func removePoint(point : Vector2i):
	pass

func createConnections():
	pass

func removeAllConnections():
	pass

@export var cell_size : Vector2 = Vector2(1, 1)
@export var default_compute_heuristic : Heuristic = 0
@export var default_estimate_heuristic : Heuristic = 0

@export var offset : Vector2 = Vector2(0, 0)
@export var region : Rect2i = Rect2i(0,0,0,0)

func get_id_path(from : Vector2i, to : Vector2i):
	#Will always give the partial path if actual path is unavailable
	pass

func set_point_solid(id : Vector2i, state : bool):
	pass

func is_point_solid(id : Vector2i):
	return !region.has_point(id)

func is_in_bounds(id: Vector2i):
	if region.has_point(id):
		return true
	return false

func update():
	#Assuming this updates all of the nodes to create the paths between them
	pass
