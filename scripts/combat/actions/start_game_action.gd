extends Action
class_name StartGameAction

func apply() -> void :
	GameManager.get_player(true).start_combat()
	GameManager.get_player(false).start_combat()
	GameManager.combat._set_random_game_turn()
