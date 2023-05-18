extends Node

class_name MonsterBase

func _init(species : String, type_first : Typ.e, type_second : Typ.e, gender_prob : float):
	self.species = species
	self.type_first = type_first
	self.type_second = type_second
	self.gender_prob = gender_prob
	#generic base stats to change later
	self.hp_base = 70
	self.attack_base = 70
	self.defense_base = 70
	self.speed_base = 70
	self.spatk_base = 70
	self.spdef_base = 70

var species : String
var type_first : Typ.e
var type_second : Typ.e
var gender_prob : float

var hp_base : int
var attack_base : int
var defense_base : int
var speed_base : int
var spatk_base : int
var spdef_base : int

# var ability_first : Ability
# var ability_second : Ability

