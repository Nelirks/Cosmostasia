extends Node
class_name Character

var player : Player

var char_name : String

var max_health : int
var current_health : int

func _init(char_name : String, player : Player) :
	self.char_name = char_name
	self.player = player
