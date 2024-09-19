extends Node

var save_path := "res://Run Info/FloorData.tres"

var floorInfo : FloorInfo = FloorInfo.new()

var justCreated : bool = true

func loadInfo():
	if ResourceLoader.exists(save_path):
		floorInfo = load(save_path)
		if !floorInfo.isNew:
			print("Loaded info")
			#playerPiece.loadData()
		else:
			print("No info found")
			setData()
	else:
		setData()

func saveInfo():
	print("Saved info")
	ResourceSaver.save(floorInfo, save_path)
	

func resetInfo():
	print("Reset info")
	ResourceSaver.save(FloorInfo.new(), save_path)

func setData():
	GenerationHandler.generateFloor()
