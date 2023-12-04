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
var energy_regen : int :
	set(value) :
		energy_regen = clamp(value, 0, max_energy)
var last_turn_energy_regen : int


func _init(is_host : bool) -> void :
	self.is_host = is_host
	_characters.append(preload("res://resources/game_data/character_data/ciol.tres").instantiate())
	_characters.append(preload("res://resources/game_data/character_data/4N-70N.tres").instantiate())
	_characters.append(preload("res://resources/game_data/character_data/freyja.tres").instantiate())
	energy_regen = base_energy_regen
	for character in _characters :
		character.player = self
		_draw_pile.append_array(character.deck)
	for card in _draw_pile : card.position = Card.Position.DRAW_PILE
	_hand.resize(3)

func shuffle_draw_pile(use_discard : bool = false) -> void :
	if use_discard :
		for card in _discard :
			card.position = Card.Position.DRAW_PILE
		_draw_pile.append_array(_discard)
		_discard = []
	for cur_index in range (_draw_pile.size()) :
		var swap_index = GameManager.rng.randi_range(0, _draw_pile.size() - 1)
		var temp : Card = _draw_pile[cur_index]
		_draw_pile[cur_index] = _draw_pile[swap_index]
		_draw_pile[swap_index] = temp

## Removes empty slots and appends a new card to the player's hand until no slot is empty.
## Can call shuffle_draw_pile if necessary
func refill_hand() -> void :
	##Removes empty slots and draw cards to reach hand size
	var iteration : int = 0
	var index : int = 0
	while iteration < _hand.size() :
		if _hand[index] == null : 
			_hand.remove_at(index)
			_hand.append(_draw_pile.pop_back())
			if _draw_pile.size() == 0 :
				shuffle_draw_pile(true)
		else :
			index += 1
		iteration += 1
	
	##Sets cards positions
	for card_index in range(_hand.size()) :
		if _hand[card_index] != null :
			_hand[card_index].position = card_index + 1

func can_play_card(card : Card, target : Character) -> bool :
	if card.cost > current_energy : return false
	if !card.can_target(target) : return false
	return true

func play_card(card : Card, target : Character) -> void :
	if !can_play_card(card, target) : return
	current_energy -= card.cost
	card.apply_effects(target)
	discard_card(_hand.find(card))

func discard_card(index : int) -> void :
	if index < 0 or index >= _hand.size() or _hand[index] == null : return
	_hand[index].position = Card.Position.DISCARD_PILE
	_discard.append(_hand[index])
	_hand[index] = null

func remove_cards(character : Character) -> void :
	for card in _hand :
		if card != null and card.character == character :
			_hand[_hand.find(card)] = null
	var search_index = 0
	while search_index < _discard.size() :
		if _discard[search_index] != null and _discard[search_index].character == character :
			_discard.remove_at(search_index)
		else : search_index += 1
	search_index = 0
	while search_index < _draw_pile.size() :
		if _draw_pile[search_index] != null and _draw_pile[search_index].character == character :
			_draw_pile.remove_at(search_index)
		else : search_index += 1

func start_turn() -> void :
	last_turn_energy_regen = energy_regen
	current_energy += energy_regen
	energy_regen = base_energy_regen
	for character in _characters :
		character.start_turn()
	GameManager.combat.add_effect(StartTurnNotifierEffect.new(self))

func end_turn() -> void :
	for character in _characters :
		character.end_turn()

func get_character(index : int) -> Character :
	if index < 0 or index > _characters.size() : return null
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
