extends MoveablePiece
class_name EnemyPiece

var enemyType : EnemyResource

func setData(pieceNum : int):
	FloorData.floorInfo.enemies.append(EnemyInfo.new())
	
	pieceName = enemyType.name
	level = randi_range(enemyType.minLevel,enemyType.maxLevel)
	maxHealth = enemyType.baseHealth + int(enemyType.baseHealth * level * 0.5)
	health = maxHealth
	type = enemyType.getType()
	
	
	FloorData.floorInfo.enemies[pieceNum].pieceType = type
	FloorData.floorInfo.enemies[pieceNum].enemyType = enemyType
	FloorData.floorInfo.enemies[pieceNum].level = level
	
	FloorData.floorInfo.enemies[pieceNum].health = health
	FloorData.floorInfo.enemies[pieceNum].maxHealth = maxHealth
	FloorData.floorInfo.enemies[pieceNum].armor = armor
	
	for n in range(enemyType.actions.actions.size()):
		FloorData.floorInfo.enemies[pieceNum].actions.append(enemyType.actions.actions[n])
	
	$TextureRect.set_texture(enemyType.associatedSprite)
	

func loadData(pieceNum : int):
	type = FloorData.floorInfo.enemies[pieceNum].pieceType
	enemyType = FloorData.floorInfo.enemies[pieceNum].enemyType
	pieceName = enemyType.name
	level = FloorData.floorInfo.enemies[pieceNum].level
	
	health = FloorData.floorInfo.enemies[pieceNum].health
	maxHealth = FloorData.floorInfo.enemies[pieceNum].maxHealth
	armor = FloorData.floorInfo.enemies[pieceNum].armor
	rc = FloorData.floorInfo.enemies[pieceNum].rc
	
	$TextureRect.set_texture(enemyType.associatedSprite)
	

func updateData():
	level = PlayerData.playerInfo.level
	health = PlayerData.playerInfo.health
	maxHealth = PlayerData.playerInfo.maxHealth
	armor = PlayerData.playerInfo.armor
