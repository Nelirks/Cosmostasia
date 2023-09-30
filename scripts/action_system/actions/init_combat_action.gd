extends Action
class_name InitCombatAction

func apply() -> void :
	GameManager.start_game()
	ShuffleDrawPileEffect.new(true).apply()
	GameManager.get_player(true).refill_hand()
	ShuffleDrawPileEffect.new(false).apply()
	GameManager.get_player(false).refill_hand()
