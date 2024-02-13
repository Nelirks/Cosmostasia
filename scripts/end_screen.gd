extends Control

enum ButtonPressed { WAIT, PLAY, QUIT }
var player_choice : ButtonPressed
var opponent_choice : ButtonPressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.post_event_deferred(AK.EVENTS.START_MAINMENUMUSIC, 10.0)
	var is_defeat : bool = GameManager.player.get_characters().size() == 0
	var is_victory : bool = GameManager.opponent.get_characters().size() == 0
	if is_defeat and is_victory : (%Result as RichTextLabel).text = "Égalité"
	elif is_victory : (%Result as Label).text = "Victoire"
	elif is_defeat : (%Result as Label).text = "Défaite"

@rpc("any_peer", "call_remote", "reliable")
func _handle_opponent_button(button : ButtonPressed) -> void :
	opponent_choice = button
	match opponent_choice :
		ButtonPressed.PLAY :
			if player_choice == ButtonPressed.PLAY :
				GameManager.set_game_state(GameManager.GameState.DRAFT)
		ButtonPressed.QUIT :
			%PlayButton.self_modulate = Color.DIM_GRAY
			%PlayButton.disabled = true

func _on_play_button_pressed():
	_handle_opponent_button.rpc(ButtonPressed.PLAY)
	player_choice = ButtonPressed.PLAY
	if opponent_choice == ButtonPressed.PLAY : 
		GameManager.set_game_state(GameManager.GameState.DRAFT)


func _on_quit_button_pressed():
	_handle_opponent_button.rpc(ButtonPressed.QUIT)
	get_tree().quit()
