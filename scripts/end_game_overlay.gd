extends Control

enum ButtonPressed { WAIT, PLAY, QUIT }
var player_choice : ButtonPressed
var opponent_choice : ButtonPressed

signal replay_requested()
signal quit_requested()

@export var win_one_shot_vfx : PackedScene
@export var win_one_shot_duration : float
@export var win_continuous_vfx : PackedScene
@export var win_continuous_delay : float
@export var lose_one_shot_vfx : PackedScene
@export var lose_one_shot_duration : float
@export var lose_continuous_vfx : PackedScene
@export var lose_continuous_delay : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.post_event_deferred(AK.EVENTS.START_MAINMENUMUSIC, 10.0)
	var is_defeat : bool = GameManager.player.get_characters().size() == 0
	var is_victory : bool = GameManager.opponent.get_characters().size() == 0
	$VictoryIcon.visible = is_victory
	$DefeatIcon.visible = !is_victory
	if is_victory and is_defeat : $VictoryIcon/Label.text = "Égalité"
	
	if is_victory :
		if win_one_shot_vfx != null : 
			var win_os_vfx : Node3D = win_one_shot_vfx.instantiate()
			add_child(win_os_vfx)
			get_tree().create_timer(win_one_shot_duration).timeout.connect(func() : win_os_vfx.queue_free())
		if win_continuous_vfx != null :
			get_tree().create_timer(win_continuous_delay).timeout.connect(func() : add_child(win_continuous_vfx.instantiate()))
	
	else :
		if lose_one_shot_vfx != null :
			var lose_os_vfx : Node3D = lose_one_shot_vfx.instantiate()
			add_child(lose_os_vfx)
			get_tree().create_timer(lose_one_shot_duration).timeout.connect(func() : lose_os_vfx.queue_free())
		if lose_continuous_vfx != null :
			get_tree().create_timer(lose_continuous_delay).timeout.connect(func() : add_child(lose_continuous_vfx.instantiate()))

	TutorialGlobal.restart()

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
	if NetworkManager.is_multiplayer :
		_handle_opponent_button.rpc(ButtonPressed.PLAY)
		player_choice = ButtonPressed.PLAY
		if opponent_choice == ButtonPressed.PLAY : 
			replay_requested.emit()
	else : 
		replay_requested.emit()
	%PlayButton.enable(false)


func _on_quit_button_pressed():
	_handle_opponent_button.rpc(ButtonPressed.QUIT)
	AudioManager.quit_wwise()
	%PlayButton.self_modulate = Color.DIM_GRAY
	%PlayButton.disabled = true
	%QuitButton.self_modulate = Color.DIM_GRAY
	%QuitButton.disabled = true
	quit_requested.emit()