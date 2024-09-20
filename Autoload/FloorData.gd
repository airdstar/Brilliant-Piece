extends Node

var save_path := "res://Run Info/FloorData.tres"

var floorInfo : FloorInfo = FloorInfo.new()

var floor : Floor

func _ready():
	pass

func loadInfo():
	if ResourceLoader.exists(save_path):
		floorInfo = load(save_path)
		if !floorInfo.isNew:
			print("Loaded info")
			floor.Handlers.GH.generateFloor()
			floor.Handlers.UH.setTurnColors()
		else:
			print("No info found")
			setData()
	else:
		print("Path not found")
		setData()

func saveInfo():
	print("Saved info")
	ResourceSaver.save(floorInfo, save_path)


func updateData():
	for n in range(floorInfo.enemies.size()):
		floorInfo.enemies[n].maxHealth = floor.enemies[n].maxHealth
		floorInfo.enemies[n].health = floor.enemies[n].health
		floorInfo.enemies[n].armor = floor.enemies[n].armor


func resetInfo():
	print("Reset info")
	ResourceSaver.save(FloorInfo.new(), save_path)

func setData():
	floor.Handlers.GH.generateFloor()
	floorInfo.isNew = false
