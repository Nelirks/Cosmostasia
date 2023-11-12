extends Action
class_name PlayCardAction

var _card : Card
var _target : Character

func _init(card : Card, target : Character) -> void:
	_card = card
	_target = target

func apply() -> void :
	_card.character.player.play_card(_card, _target)
