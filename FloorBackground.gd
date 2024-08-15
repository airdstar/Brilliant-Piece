extends Node3D

var isRotating : bool = true

func _process(delta):
	if isRotating:
		rotate_y(deg_to_rad(0.02))

func toggleRotate():
	isRotating = !isRotating
