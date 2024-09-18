extends Node

var save_path := "res://Run Info/PlayerData.tres"

var playerInfo : PlayerInfo = PlayerInfo.new()

var playerPiece : PlayerPiece = preload("res://Piece/PlayerPiece.tscn").instantiate()

func loadInfo():
	if ResourceLoader.exists(save_path):
		playerInfo = load(save_path)
		if !playerInfo.isNew:
			print("Loaded info")
			playerPiece.loadData()
		else:
			print("No info found")
			playerPiece.setData()
	else:
		print("error")
		playerPiece.setData()

func saveInfo():
	print("Saved info")
	ResourceSaver.save(playerInfo, save_path)
	

func resetInfo():
	print("Reset info")
	ResourceSaver.save(PlayerInfo.new(), save_path)

func updateData():
	playerInfo.health = playerPiece.health
	playerInfo.maxHealth = playerPiece.maxHealth
	playerInfo.armor = playerPiece.armor
	
	playerInfo.pieceType = playerPiece.type
	playerInfo.classType = playerPiece.classType

func levelUp():
	playerInfo.level += 1
	print("Leveled up!")
	playerPiece.updateData()
	gainExp(0)

func gainExp(amount : int):
	if amount != 0:
		playerInfo.expAmount += amount
		print("Gained " + str(amount) + " exp!")
	if playerInfo.expAmount >= Global.expArray[playerInfo.level - 1]:
		playerInfo.expAmount -= Global.expArray[playerInfo.level - 1]
		levelUp()
	else:
		if playerInfo.expAmount != 0:
			print(str(Global.expArray[playerInfo.level - 1] - amount) + " exp until next level")
