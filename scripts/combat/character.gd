extends RefCounted
class_name Character

var player : Player

var template : CharacterInfo

var char_name : String
var quote : String
var sprite : Sprite2D

var max_health : int
var current_health : int

func _init(template : CharacterInfo, player : Player) :
	self.template = template
	char_name = template.character_name
	quote = template.character_quote
	sprite = template.character_sprite
	
	max_health = template.max_health
	current_health = max_health
	
	self.player = player

func on_turn_start(is_active_player : bool) -> void :
	pass
