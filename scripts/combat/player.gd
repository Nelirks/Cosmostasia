extends Node
class_name Player

var is_host : bool

var _characters : Array[Character]
var _hand : Array[Card]
var _draw_pile : Array[Card]
var _discard : Array[Card]

var _max_energy : int
var _current_energy : int

func _init(is_host : bool) -> void :
	self.is_host = is_host
	for i in range(3) :
		_characters.append(Character.new(("HOST_" if is_host else "CLIENT_") + "CHAR" + str(i), self))
	for i in range(30) : 
		_draw_pile.append(Card.new("CARD" + str(i), 0, _characters[i/10]))
	

func shuffle_draw_pile() -> void :
	for cur_index in range (_draw_pile.size()) :
		var swap_index = GameManager.rng.randi_range(0, _draw_pile.size() - 1)
		var temp : Card = _draw_pile[cur_index]
		_draw_pile[cur_index] = _draw_pile[swap_index]
		_draw_pile[swap_index] = temp

func refill_hand() -> void :
	for i in range (_hand.size(), 3) :
		_hand.append(_draw_pile.pop_back())

func play_card(index : int, target : Character) -> void :
	_hand[index].play(target)
	_hand.remove_at(index)
	refill_hand()

func get_character(index : int) -> Character :
	return _characters[index]

func get_card_in_hand(index : int) -> Card :
	return _hand[index]
