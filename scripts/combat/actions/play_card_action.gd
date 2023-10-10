extends Action
class_name PlayCardAction

var _card_is_host : bool
var _card_index : int
var _target_is_host : bool
var _target_index : int

func _init(card_is_host : bool, card_index : int, target_is_host : bool, target_index : int) -> void:
	_card_is_host = card_is_host
	_card_index = card_index
	_target_is_host = target_is_host
	_target_index = target_index

func apply() -> void :
	GameManager.get_player(_card_is_host).play_card(_card_index, GameManager.get_player(_target_is_host).get_character(_target_index))
