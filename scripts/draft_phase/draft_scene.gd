extends Node

@export var character_pool : Array[Character]

var host_choice : int = -1
var client_choice : int = -1

var cur_choices : Array[int]

func _ready():
	if NetworkManager.is_host :
		pick_character_choices()

func pick_character_choices() -> void :
	var host_choices : Array[int]
	var client_choices : Array[int]
	
	for i in range(3) :
		host_choices.append(GameManager.rng.randi_range(0, character_pool.size() - 1))
		client_choices.append(GameManager.rng.randi_range(0, character_pool.size() - 1))
	set_choices(host_choices[0], host_choices[1], host_choices[2])
	set_choices.rpc(client_choices[0], client_choices[1], client_choices[2])

@rpc("authority", "call_remote")
func set_choices(char_index_0 : int, char_index_1 : int, char_index_2 : int) -> void :
	cur_choices = [char_index_0, char_index_1, char_index_2]
	($PlayerChoices/Choice0 as Button).text = character_pool[char_index_0].character_name
	($PlayerChoices/Choice1 as Button).text = character_pool[char_index_1].character_name
	($PlayerChoices/Choice2 as Button).text = character_pool[char_index_2].character_name

@rpc("any_peer", "call_remote")
func notify_choice(char_index : int) -> void :
	if multiplayer.get_remote_sender_id() == 0 :
		host_choice = char_index
	else :
		client_choice = char_index
	if host_choice != -1 and client_choice != -1 :
		apply_choices.rpc(host_choice, client_choice)
		pick_character_choices()
		
		host_choice = -1
		client_choice = -1

@rpc("authority", "call_local")
func apply_choices(host_char : int, client_char : int) -> void :
	GameManager.get_player(true).add_character(character_pool[host_char].instantiate())
	GameManager.get_player(false).add_character(character_pool[client_char].instantiate())
	update_picks()
	if GameManager.player.get_characters().size() == 3 :
		GameManager.set_game_state(GameManager.GameState.COMBAT)

func update_picks() -> void :
	for i in range(3) :
		if i < GameManager.opponent.get_characters().size() and $OpponentDraft.get_child(i).text == "" :
			$OpponentDraft.get_child(i).text = GameManager.opponent.get_character(i).character_name
		if i < GameManager.player.get_characters().size() and $PlayerDraft.get_child(i).text == "" :
			$PlayerDraft.get_child(i).text = GameManager.player.get_character(i).character_name

func on_button_pressed(button_index : int) -> void :
	var char_index = cur_choices[button_index]
	if NetworkManager.is_host : 
		notify_choice(char_index)
	else :
		notify_choice.rpc(char_index)
