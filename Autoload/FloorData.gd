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
	
	for n in range(floorInfo.tiles.size()):
		floorInfo.tiles[n].hazard = floor.Handlers.TH.tileDict["Tiles"][n].hazard
		#floorInfo.tiles[n].status = floor.Handlers.TH.tileDict["Tiles"][n].status


func resetInfo():
	print("Reset info")
	ResourceSaver.save(FloorInfo.new(), save_path)

func setData():
	floorInfo.setLayerInfo()
	floor.Handlers.GH.generateFloor()
	floorInfo.isNew = false

func nextFloor():
	PlayerData.playerInfo.currentFloorNum += 1
	PlayerData.saveInfo()
	PlayerData.playerPiece = preload("res://Piece/PlayerPiece.tscn").instantiate()
	
	var newFloor = FloorInfo.new()
	newFloor.floorNum = PlayerData.playerInfo.currentFloorNum
	floorInfo = newFloor
	floorInfo.setLayerInfo()
	
	var main = floor.get_parent()
	floor.queue_free()
	floor = preload("res://Floor/Floor.tscn").instantiate()
	main.add_child(floor)
	
	floor.Handlers.GH.generateFloor()
	floorInfo.isNew = false
	saveInfo()
	
