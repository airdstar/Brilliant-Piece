extends Node

var colorDict : Dictionary = {"White" : Color(1,1,1,1), "Black" : Color(0,0,0,1),
								"Gray" : Color(0.5,0.5,0.5,1), "Blue" : Color(0.63,0.72,0.86,1),
								"Red" : Color(0.86,0.63,0.72,1), "Orange" : Color(0.86,0.72,0.63,1),
								"Green" : Color(0.63,0.86,0.72,1), "Test" : Color(0.2,0.8,0.8,1)}

var tileBlackColor : Array = [Color8(37,24,26)]
var tileWhiteColor : Array = [Color8(214,209,177)]

var levelDict : Dictionary

var posDict : Dictionary

func _ready():
	
	var expArray : Array[int] = [10, 20, 30, 40, 50]
	var healthArray : Array[int] = [2, 2, 2, 1, 2]
	
	levelDict = {"exp" : expArray, "health" : healthArray}

func delete_particles(particles, location):
	location.remove_child(particles)

func create_particles(position : Vector2, rotation : float, type: int, location, delay : float):
	
	## type 0 is pushing/hitting something while moving
	## type 1 is landing after falling
	## type 2 is for a slash type action
	
	var particles : CPUParticles2D = CPUParticles2D.new()
	match type:
		0:
			particles.amount = 18
			particles.lifetime = 0.09
			particles.spread = 65
			particles.gravity = Vector2.ZERO
			particles.initial_velocity_min = 165
			particles.initial_velocity_max = 250
			particles.scale_amount_min = 3
			particles.scale_amount_max = 5
			particles.color = Color(0.7,0.7,0.7)
			
		1:
			particles.amount = 18
			particles.lifetime = 0.1
			particles.spread = 180
			particles.gravity = Vector2.ZERO
			particles.initial_velocity_min = 165
			particles.initial_velocity_max = 250
			particles.scale_amount_min = 3
			particles.scale_amount_max = 5
			particles.color = Color(0.7,0.7,0.7)
	
	
	particles.z_index = 1
	particles.position = position
	particles.set_rotation_degrees(rotation)
	
	particles.one_shot = true
	particles.finished.connect(self.delete_particles.bind(particles, location))
	
	if delay != 0:
		await get_tree().create_timer(delay).timeout
	
	location.add_child(particles)
