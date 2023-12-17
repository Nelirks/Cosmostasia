extends Node

@export var character_pool : Array[Character]
@export_range(0.0, 1.0, 0.05) var reduced_pick_chance : float

var host_choice : int = -1
var client_choice : int = -1

var cur_choices : Array[int]

var host_picks : Array[int]
var client_picks : Array[int]

func _ready():
	if NetworkManager.is_host :
		pick_character_choices()

func merge_arrays(array1 : Array[int], array2 : Array[int]) -> Array[int] :
	var result : Array[int] = []
	result.append_array(array1)
	for val in array2 :
		if result.find(val) == -1 : result.append(val)
	return result

## Gets an array containing the weight of each character to be picked
## Each value indicates the weight to draw the character at the same index in character_pool
func generate_weight_repartition(is_host : bool) -> Array[float] :
	var weights : Array[float]
	for i in range(character_pool.size()) : 
		weights.append(1.0)
	for previous_pick in host_picks if is_host else client_picks :
		weights[previous_pick] = 0.0
	for opponent_pick in client_picks if is_host else host_picks :
		if weights[opponent_pick] >= 0.01 : weights[opponent_pick] = reduced_pick_chance
	return weights

func get_random_character(excluded_chars : Array[int], reduced_chance_chars : Array[int]) -> int :
	var total_weight = 0
	for char_index in range(character_pool.size()) :
		if excluded_chars.find(char_index) != -1 : continue
		elif reduced_chance_chars.find(char_index) != -1 : total_weight += reduced_pick_chance
		else : total_weight += 1
	var random_value : float = GameManager.rng.randf_range(0.0, total_weight)
	
	for char_index in range(character_pool.size()) :
		if excluded_chars.find(char_index) != -1 : continue
		elif reduced_chance_chars.find(char_index) != -1 : random_value -= reduced_pick_chance
		else : random_value -= 1
		if random_value <= 0.0 :
			return char_index
	return 0

func pick_character_choices() -> void :
	var host_draft : Array[int]
	var client_draft : Array[int]
	
	for i in range(3) :
		host_draft.append(get_random_character(merge_arrays(host_picks, host_draft), merge_arrays(client_picks, client_draft)))
		client_draft.append(get_random_character(merge_arrays(client_picks, client_draft), merge_arrays(host_picks, host_draft)))
	
	set_choices(host_draft[0], host_draft[1], host_draft[2])
	if NetworkManager.is_multiplayer : 
		set_choices.rpc(client_draft[0], client_draft[1], client_draft[2])
	else : 
		client_choice = client_draft[GameManager.rng.randi_range(0, client_draft.size() - 1)]

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
		
		host_choice = -1
		client_choice = -1
		
		pick_character_choices()

@rpc("authority", "call_local")
func apply_choices(host_char : int, client_char : int) -> void :
	host_picks.append(host_char)
	client_picks.append(client_char)
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