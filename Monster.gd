extends MonsterBase

class_name Monster

func _init(species : String, type_first : Typ.e, type_second : Typ.e, gender_prob : float, nickname : String = species):
	super._init(species, type_first, type_second, gender_prob)
	
	self.nickname = nickname
	self.level = 50
	self.hp_max = (self.hp_base * 2 + 18 + 21 * level) / 100 + level + 10
	self.hp = self.hp_max
	# Other stats are different but all the same between them
	self.attack = (2 * self.attack_base + 18 + 21 * level) / 100 + 5
	self.defense = (2 * self.defense_base + 18 + 21 * level) / 100 + 5
	self.sp_attack = (2 * self.spatk_base + 18 + 21 * level) / 100 + 5
	self.sp_defense = (2 * self.spdef_base + 18 + 21 * level) / 100 + 5
	self.speed = (2 * self.speed_base + 18 + 21 * level) / 100 + 5
	
	# Add generic moves  "name", power, accuracy, power points, type
#	self.moves[1] = Move.new("Tackle", 40, 100, 40, Typ.e.GOBLIN)

var moves : Array[Move]

var nickname : String
var level : int

var hp : int
var hp_max : int
var attack : int
var defense : int
var sp_attack : int
var sp_defense : int
var speed : int

