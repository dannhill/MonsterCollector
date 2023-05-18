extends MonsterBase

class_name Monster

func _init(species : String, type_first : Typ.e, type_second : Typ.e, gender_prob : float, nickname : String = species):
	super._init(species, type_first, type_second, gender_prob)
	
	self.nickname = nickname
	self.moves = Moves.new()
	self.level = 50
	self.hp = (self.hp_base * 2 + 18 + 21 * level) / 100 + level + 10
	# Other stats are different but all the same between them
	self.attack = (2 * self.attack_base + 18 + 21 * level) / 100 + 5
	self.defense = (2 * self.defense_base + 18 + 21 * level) / 100 + 5
	self.sp_attack = (2 * self.spatk_base + 18 + 21 * level) / 100 + 5
	self.sp_defense = (2 * self.spdef_base + 18 + 21 * level) / 100 + 5
	self.speed = (2 * self.speed_base + 18 + 21 * level) / 100 + 5
	
	# Add generic moves 
	self.moves.first = Move.new("Tackle", 40, 100, 40, Typ.e.GOBLIN)
	self.moves.second = Move.new("Scratch", 40, 100, 40, Typ.e.GOBLIN)
	self.moves.third = Move.new("Bite", 60, 100, 25, Typ.e.GOBLIN)
	self.moves.fourth = Move.new("Punch", 40, 100, 40, Typ.e.GOBLIN)

class Moves:
	var first : Move
	var second : Move
	var third : Move
	var fourth : Move

var nickname : String
var level : int

var moves : Moves
var hp : int
var attack : int
var defense : int
var sp_attack : int
var sp_defense : int
var speed : int

