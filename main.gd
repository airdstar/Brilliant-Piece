extends Node

func _ready():
	FloorData.floor = preload("res://Floor/Floor.tscn").instantiate()
	add_child(FloorData.floor)
	FloorData.loadInfo()
	FloorData.floor.Handlers.UH.openMenu()
