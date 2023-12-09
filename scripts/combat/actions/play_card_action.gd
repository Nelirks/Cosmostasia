extends Action
class_name PlayCardAction

var _card : Card
var _target : Character

func _init(card : Card, target : Character) -> void:
	_card = card
	_target = target

func apply() -> void :
	var card_index = _card.character.player._hand.find(_card)
	_card.character.player.play_card(_card, _target)
	GameManager.combat.add_effect(CardPlayNotifierEffect.new(_card, card_index, _target))
