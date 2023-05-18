extends Node

class_name Move

func _init(nickname : String, power : int, accuracy : float, power_points : int, type : Typ.e):
	self.nickname = nickname
	self.power = power
	self.accuracy = accuracy
	self.power_points = power_points
	self.type = type

var nickname : String
var power : int
var accuracy : float
var power_points : int
var type : Typ.e

