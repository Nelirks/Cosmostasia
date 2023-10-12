extends RefCounted
class_name Character

var player : Player

var template : CharacterInfo

var char_name : String
var quote : String
var sprite : Sprite2D

var max_health : int
var current_health : int

var _armor : int

var is_dead : bool = false

func _init(template : CharacterInfo, player : Player) :
	self.template = template
	char_name = template.character_name
	quote = template.character_quote
	sprite = template.character_sprite
	
	max_health = template.max_health
	current_health = max_health
	
	self.player = player

func start_turn() -> void :
	_armor = 0

func deal_damage(target : Character, amount : int) -> void :
	target.take_damage(self, amount)

func take_damage(source : Character, amount : int) -> void :
	var remaining_amount = amount
	if _armor > 0 :
		if _armor > remaining_amount :
			_armor -= remaining_amount
			remaining_amount = 0
		else : 
			remaining_amount -= _armor
			_armor = 0
	current_health -= remaining_amount
	GameManager.combat.events.on_damage_dealt(source, self, remaining_amount)
	if current_health <= 0 :
		is_dead = true
		GameManager.combat.events.on_character_death(source, self)

func apply_armor(amount : int) -> void :
	_armor += amount

func on_damage_dealt(source : Character, target : Character, amount : int) -> void :
	pass

func on_character_death(source : Character, target : Character) -> void :
	pass

func on_turn_start(is_active_player : bool) -> void :
	pass
