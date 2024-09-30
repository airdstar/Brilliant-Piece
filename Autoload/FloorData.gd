extends Node

var save_path := "res://Run Info/FloorData.tres"

var floorInfo : FloorInfo = FloorInfo.new()

var floor : Floor
var tiles : Array

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
	PlayerData.saveInfo()
	ResourceSaver.save(floorInfo, save_path)


func updateData():
	for n in range(floorInfo.enemies.size()):
		floorInfo.enemies[n].maxHealth = floor.enemies[n].maxHealth
		floorInfo.enemies[n].health = floor.enemies[n].health
		floorInfo.enemies[n].armor = floor.enemies[n].armor
	
	for n in range(floorInfo.rc.x):
		for m in range(floorInfo.rc.y):
			if floorInfo.tileInfo[n][m] != null:
				floorInfo.tileInfo[n][m].hazard = tiles[n][m].hazard
				#floorInfo.tiles[n].status = floor.Handlers.TH.tileDict["Tiles"][n].status


func resetInfo():
	print("Reset info")
	ResourceSaver.save(FloorInfo.new(), save_path)

func setData():
	floorInfo.setLayerInfo()
	floor.Handlers.GH.generateFloor()
	FloorData.floor.HUD.updateFloorInfo()
	floorInfo.isNew = false

func nextFloor():
	PlayerData.playerInfo.currentFloorNum += 1
	PlayerData.playerPiece = preload("res://Piece/PlayerPiece.tscn").instantiate()
	
	floorInfo = FloorInfo.new()
	floorInfo.floorNum = PlayerData.playerInfo.currentFloorNum
	
	var main = floor.get_parent()
	floor.queue_free()
	floor = preload("res://Floor/Floor.tscn").instantiate()
	main.add_child(floor)
	
	setData()
	saveInfo()
	
