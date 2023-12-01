extends Action
class_name StartGameAction

func apply() -> void :
	GameManager.player = Player.new(NetworkManager.is_host())
	GameManager.opponent = Player.new(!NetworkManager.is_host())
	GameManager.get_player(true).shuffle_draw_pile()
	GameManager.get_player(false).shuffle_draw_pile()
	GameManager.combat._set_random_game_turn()
