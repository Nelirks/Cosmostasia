extends RefCounted
class_name Player

var is_host : bool

var _characters : Array[Character]
var _hand : Array[Card]
var _draw_pile : Array[Card]
var _discard : Array[Card]

var max_energy : int = 5
var current_energy : int = 0 :
	set(value) :
		current_energy = clamp(value, 0, max_energy)
var energy_regen : int = 3

func _init(is_host : bool) -> void :
	self.is_host = is_host
	_characters.append(Character.new(load("res://resources/game_data/character_data/dyssebia.tres"), self))
	_characters.append(Character.new(load("res://resources/game_data/character_data/lisirmee.tres"), self))
	_characters.append(Character.new(load("res://resources/game_data/character_data/thimothy_laveak.tres"), self))
	for char_index in range(3) :
		for card_index in range(5) :
			_draw_pile.append(Card.new(_characters[char_index].template.character_cards[0], _characters[char_index]))
		for card_index in range(3) :
			_draw_pile.append(Card.new(_characters[char_index].template.character_cards[1], _characters[char_index]))
		for card_index in range(2) :
			_draw_pile.append(Card.new(_characters[char_index].template.character_cards[2], _characters[char_index]))

func on_turn_start(is_active_player : bool) -> void :
	if is_active_player : 
		current_energy += energy_regen
	for character in _characters :
		character.on_turn_start(is_active_player)

func shuffle_draw_pile() -> void :
	for cur_index in range (_draw_pile.size()) :
		var swap_index = GameManager.rng.randi_range(0, _draw_pile.size() - 1)
		var temp : Card = _draw_pile[cur_index]
		_draw_pile[cur_index] = _draw_pile[swap_index]
		_draw_pile[swap_index] = temp

func refill_hand() -> void :
	for i in range (_hand.size(), 3) :
		_hand.append(_draw_pile.pop_back())

func can_play_card(index : int) -> bool :
	return _hand[index].cost <= current_energy

func play_card(index : int, target : Character) -> void :
	current_energy -= _hand[index].cost
	_hand[index].apply_effects(target)
	_hand.remove_at(index)
	refill_hand()

func get_character(index : int) -> Character :
	return _characters[index]

func get_card_in_hand(index : int) -> Card :
	return _hand[index]
