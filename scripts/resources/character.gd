extends Resource
class_name Character

@export_group("Character Data")
@export var character_name : String
@export var character_quote : String
@export var character_sprite : Sprite2D

@export_group("Gameplay Data")
@export var max_health : int
@export var card_pool : Array[Card]
var player : Player

var deck : Array[Card]

var current_health : int
var _armor : int
var is_dead : bool = false
var _statuses : Array[StatusEffect]

func setup() :
	current_health = max_health
	for i in range(card_pool.size()) : 
		deck.append(card_pool[i].duplicate())
		deck.append(card_pool[i].duplicate())
	for card in deck :
		card.character = self

func start_turn() -> void :
	_armor = 0
	for status in _statuses :
		status.decay()

func take_damage(source : Character, amount : int) -> void :
	var remaining_amount : int = amount
	if _armor > 0 :
		if _armor > remaining_amount :
			_armor -= remaining_amount
			remaining_amount = 0
		else : 
			remaining_amount -= _armor
			_armor = 0
	current_health -= remaining_amount

func heal(amount : int) -> void :
	current_health = clamp(current_health + amount, current_health, max_health)

func check_game_state() -> void:
	if current_health <= 0 :
		is_dead = true
		GameManager.combat.add_effect(CharacterDeathNotifierEffect.new(self))

func apply_armor(amount : int) -> void :
	_armor += amount

func add_status(status : StatusEffect) -> void :
	_statuses.append(status)
	status.owner = self
	status.on_apply()

func remove_status(id : String) -> void :
	var i = 0
	while i < _statuses.size() :
		if _statuses[i].id == id :
			_statuses[i].on_remove()
			_statuses.remove_at(i)
		else : i += 1


func has_status(id : String) -> bool :
	return get_status(id) != null

func get_status(id : String) -> StatusEffect :
	for status in _statuses :
		if id == status.id :
			return status
	return null

func on_effect_resolution(effect : Effect) -> void :
	for status in _statuses :
		status.on_effect_resolution(effect)

func get_allies(include_self : bool = true, include_dead : bool = false) -> Array[Character] :
	if include_self : 
		return player.get_characters(include_dead)
	else :
		var allies : Array[Character] = player.get_characters(include_dead)
		allies.remove_at(allies.find(self))
		return allies

func get_enemies(include_dead : bool = false) -> Array[Character] :
	return player.get_opponent().get_characters(include_dead)

func instantiate() -> Character :
	var copy = self.duplicate(true)
	copy.setup()
	return copy
