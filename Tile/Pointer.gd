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
		"Gray":
			$Top.mesh.material.set_albedo(Color(0.5,0.5,0.5))
			$Bottom.mesh.material.set_albedo(Color(0.5,0.5,0.5))
		"Blue":
			$Top.mesh.material.set_albedo(Color(0.63,0.72,0.86))
			$Bottom.mesh.material.set_albedo(Color(0.63,0.72,0.86))
		"Green":
			$Top.mesh.material.set_albedo(Color(0.63,0.86,0.72))
			$Bottom.mesh.material.set_albedo(Color(0.63,0.86,0.72))
		"Red":
			$Top.mesh.material.set_albedo(Color(0.86,0.63,0.72))
			$Bottom.mesh.material.set_albedo(Color(0.86,0.63,0.72))
		"Orange":
			$Top.mesh.material.set_albedo(Color(0.86,0.72,0.63))
			$Bottom.mesh.material.set_albedo(Color(0.86,0.72,0.63))

func StartBob():
	up = !up
	bob = true
	$StartTimer.stop()
	$StopTimer.start()

func StopBob():
	bob = false
	$StartTimer.start()
	$StopTimer.stop()
