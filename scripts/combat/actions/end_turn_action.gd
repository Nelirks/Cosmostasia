extends Action
class_name EndTurnAction

func apply() -> void :
	GameManager.combat.next_turn()
