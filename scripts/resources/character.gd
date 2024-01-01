extends Resource
class_name Character

@export_group("Character Data")
@export var character_name : String
@export var character_quote : String
@export var character_texture : Texture2D

@export_group("Gameplay Data")
@export var max_health : int
@export var card_pool : Array[Card]
@export var passive : StatusEffect
@export var deck_presets : Array[DeckPreset]
var player : Player

var deck : Array[Card]

var current_health : int
var _armor : int
var is_dead : bool = false
var _statuses : Array[StatusEffect]

func setup() :
	current_health = max_health
	if passive != null : add_status(passive)

func use_preset(preset_index : int) -> void :
	if deck_presets.size() == 0 : return
	for card_index in range(card_pool.size()) :
		for i in range(deck_presets[preset_index].content[card_index]) :
			deck.append(card_pool[card_index].duplicate())
	for card in deck : 
		card.character = self

func start_turn() -> void :
	remove_armor()
	for status in _statuses :
		status.start_turn()

func end_turn() -> void :
	for status in _statuses :
		status.end_turn()

func take_damage(source : Character, amount : int, uses_armor : bool) -> void :
	var remaining_amount : int = amount
	if uses_armor and _armor > 0 :
		if _armor > remaining_amount :
			_armor -= remaining_amount
			remaining_amount = 0
		else : 
			remaining_amount -= _armor
			_armor = 0
	current_health -= remaining_amount
	if remaining_amount > 0 :
		for status in _statuses :
			status.on_damage_taken(source, remaining_amount)

func heal(amount : int) -> void :
	current_health = clamp(current_health + amount, current_health, max_health)

func check_game_state() -> void:
	if current_health <= 0 :
		is_dead = true
		player.remove_cards(self)
			

func apply_armor(amount : int) -> void :
	_armor += amount

func remove_armor() -> void :
	_armor = 0

func add_status(status : StatusEffect) -> void :
	_statuses.append(status)
	status.owner = self
	status.on_apply()

func remove_status(status : StatusEffect) -> void :
	var index = _statuses.find(status)
	if index != -1 : 
		_statuses[index].on_remove()
		_statuses.remove_at(index)

func remove_status_by_id(id : String) -> void :
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
