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
var base_energy_regen : int = 3
var energy_regen : int
var last_turn_energy_regen : int


func _init(is_host : bool) -> void :
	self.is_host = is_host
	_characters.append(preload("res://resources/game_data/character_data/dyssebia.tres").instantiate())
	_characters.append(preload("res://resources/game_data/character_data/lisirmee.tres").instantiate())
	_characters.append(preload("res://resources/game_data/character_data/timothy_laveak.tres").instantiate())
	for character in _characters :
		character.player = self
		_draw_pile.append_array(character.deck)

func shuffle_draw_pile(use_discard : bool = false) -> void :
	if use_discard :
		_draw_pile.append_array(_discard)
		_discard = []
	for cur_index in range (_draw_pile.size()) :
		var swap_index = GameManager.rng.randi_range(0, _draw_pile.size() - 1)
		var temp : Card = _draw_pile[cur_index]
		_draw_pile[cur_index] = _draw_pile[swap_index]
		_draw_pile[swap_index] = temp

func refill_hand() -> void :
	for i in range (_hand.size(), 3) :
		_hand.append(_draw_pile.pop_back())
		if _draw_pile.size() == 0 :
			shuffle_draw_pile(true)

func can_play_card(card : Card, target : Character) -> bool :
	if card.cost > current_energy : return false
	if !card.can_target(target) : return false
	return true

func play_card(card : Card, target : Character) -> void :
	if !can_play_card(card, target) : return
	current_energy -= card.cost
	card.apply_effects(target)
	var card_index = _hand.find(card)
	if card_index != -1 :
		_hand.remove_at(card_index)
		_discard.append(card)
		refill_hand()

func start_turn() -> void :
	last_turn_energy_regen = energy_regen
	current_energy += energy_regen
	energy_regen = base_energy_regen
	for character in _characters :
		character.start_turn()
	GameManager.combat.add_effect(StartTurnNotifierEvent.new(self))

func get_character(index : int) -> Character :
	return _characters[index]

func get_card_in_hand(index : int) -> Card :
	return _hand[index]

func get_opponent() -> Player :
	return GameManager.opponent if GameManager.player == self else GameManager.player

func get_characters(include_dead : bool = false) -> Array[Character] :
	var characters = _characters.duplicate()
	if !include_dead : 
		for i in range (characters.size() - 1, -1, -1) :
			if characters[i].is_dead :
				characters.remove_at(i)
	return characters
