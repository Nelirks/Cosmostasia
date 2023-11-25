extends Action
class_name PlayCardAction

var _card : Card
var _target : Character

func _init(card : Card, target : Character) -> void:
	_card = card
	_target = target

func apply() -> void :
	GameManager.combat.add_effect(CardPlayNotifierEffect.new(_card, 0))
	_card.character.player.play_card(_card, _target)
