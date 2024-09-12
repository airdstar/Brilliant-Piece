extends Node3D

var bob = true
var up = true
var height : float
var bobAmount : float

@onready var top = $Top
@onready var bottom = $Bottom

func _ready():
	pass

func _process(delta):
	if bob:
		match up:
			true:
				bobAmount += 0.1
			false:
				bobAmount -= 0.1
	position.y = height
	position.y += bobAmount * delta

func setColor(color : Color):
	top.mesh.material.set_albedo(color)
	bottom.mesh.material.set_albedo(color)

func StartBob():
	up = !up
	bob = true
	$StartTimer.stop()
	$StopTimer.start()

func StopBob():
	bob = false
	$StartTimer.start()
	$StopTimer.stop()
