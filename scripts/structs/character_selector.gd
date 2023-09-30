extends RefCounted
class_name CharacterSelector

var player_is_host : bool
var index : int

func _init(player_is_host : bool = false, index : int = 0) -> void:
	self.player_is_host = player_is_host
	self.index = index
