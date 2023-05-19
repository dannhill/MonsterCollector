extends Node

class_name SaveData

static func load_team(path : String = "res://SaveData/team.json") -> Array[Monster]:# returns monster array
	var monsters : Array[Monster] = []
	var json : JSON = JSON.new()
	
	var file_team : FileAccess = FileAccess.open(path, FileAccess.READ)
	json.parse(file_team.get_as_text())
	print(json.get_error_message())
	var team_info : Variant = json.data
	file_team.close()

	var i : int = 0
	for monster_info in team_info:
		if "species" in monster_info:
			monsters.append(Monster.new("Goblin", Typ.e.GOBLIN, Typ.e.GOBLIN, 0.5))
			monsters[i].species = monster_info.species
			monsters[i].type_first = monster_info.type_first
			monsters[i].type_second = monster_info.type_second
			monsters[i].nickname = monster_info.nickname
			monsters[i].level = monster_info.level
			monsters[i].hp = monster_info.hp
			monsters[i].hp_max = monster_info.hp_max
			monsters[i].attack = monster_info.attack
			monsters[i].defense = monster_info.defense
			monsters[i].sp_attack = monster_info.sp_attack
			monsters[i].sp_defense = monster_info.sp_defense
			monsters[i].speed = monster_info.speed
		else:
			monsters.append(null)
		i += 1
	
	return monsters
