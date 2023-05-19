extends Node
#OPTIMIZE maybe there is too much memory used at the same time cause
# two files are loaded at the same time
class_name SaveData

static func load_team(path : String = "res://SaveData/team.json") -> Array[Monster]:# returns monster array
	var monsters : Array[Monster] = []
	var team_info : Variant = load_team_data(path)
	var moves_info : Variant = load_moves_data()

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
			for move_nickname in monster_info.moves:
				#BUG the fourth move is null and I dont' know why. I'm too tired now and will fix it tomorrow
				var move : Variant = lexographical_binary_search(moves_info, move_nickname)
				if move:
					monsters[i].moves.push_back(Move.new(move.nickname, move.power, move.accuracy, move.power_points, move.type)) #NULL must check if this is null
				else:
					monsters[i].moves.push_back(null)
			print(monsters[i].moves[3])
		else:
			monsters.append(null)
		i += 1
	
	return monsters

static func load_team_data(path : String = "res://SaveData/team.json") -> Variant:
	var json : JSON = JSON.new()
	var file_team : FileAccess = FileAccess.open(path, FileAccess.READ)
	json.parse(file_team.get_as_text())
	print(json.get_error_message())
	var team : Variant = json.data
	file_team.close()
	return team

static func load_moves_data() -> Variant:
	var json : JSON = JSON.new()
	var file_moves : FileAccess = FileAccess.open("res://Data/moves_data.json", FileAccess.READ)
	json.parse(file_moves.get_as_text())
	print(json.get_error_message())
	var moves : Variant = json.data
	file_moves.close()
	return moves

#BUG Moves MUST be an array of moves. I have to check this.
#BUG maybe the problem with the move loading is inside the lexographical_binary_search function
# cause maybe it can't find the last move in the array
static func lexographical_binary_search(moves : Variant, move_nickname : String) -> Variant:
	var low : int = 0
	var high : int = moves.size() - 1
	var mid : int = 0
	while low <= high:
		mid = (low + high) / 2
		if moves[mid].nickname == move_nickname:
			return moves[mid]
		elif moves[mid].nickname < move_nickname:
			low = mid + 1
		else:
			high = mid - 1
	return null
