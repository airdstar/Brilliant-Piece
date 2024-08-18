extends Node3D

var bob = true
var up = true
var height : float
var bobAmount : float

func _process(delta):
	if bob:
		match up:
			true:
				bobAmount += 0.1
			false:
				bobAmount -= 0.1
	position.y = height
	position.y += bobAmount * delta

func setColor(color : String):
	match color:
		"Blue":
			$Top.mesh.material.set_albedo(Color(0.569,0.71,1))
			$Bottom.mesh.material.set_albedo(Color(0.569,0.71,1))
		"Green":
			$Top.mesh.material.set_albedo(Color(0.569,1,0.71))
			$Bottom.mesh.material.set_albedo(Color(0.569,1,0.71))
		"Red":
			$Top.mesh.material.set_albedo(Color(1,0.569,0.71))
			$Bottom.mesh.material.set_albedo(Color(1,0.569,0.71))

func StartBob():
	up = !up
	bob = true
	$StartTimer.stop()
	$StopTimer.start()

func StopBob():
	bob = false
	$StartTimer.start()
	$StopTimer.stop()
