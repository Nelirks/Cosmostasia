extends Node

@export var character_pool : Array[Character]
@export_range(0.0, 1.0, 0.05) var reduced_pick_chance : float

var host_choice : int = -1
var client_choice : int = -1

var cur_choices : Array[int]
var selected_choice : int

var host_picks : Array[int]
var client_picks : Array[int]

@onready var player_choices : Array[CharacterCard3D] = []
@onready var opponent_picks : Array[CharacterCard3D] = []
@onready var player_picks : Array[CharacterCard3D] = []

@export var selected_character_fx : Material
@export var info_popup_scene : PackedScene
var info_popup : InfoPopup :
	set(value) :
		if info_popup != null : info_popup.queue_free()
		info_popup = value
		if info_popup != null :
			%ForegroundLayer.add_child(info_popup)

var waiting_for_opponent : bool = false

func _ready():
	player_choices.append_array(%PlayerChoices.get_children())
	opponent_picks.append_array(%OpponentDraft.get_children())
	player_picks.append_array(%PlayerDraft.get_children())
	connect_signals()
	var screen_middle:Vector2 = Vector2($BackgroundLayer/TextureRect.size.x/2,
	$BackgroundLayer/TextureRect.size.y/2)
	TutorialGlobal.trigger_tutorial("0_welcome",self,screen_middle)
	if NetworkManager.is_host :
		pick_character_choices()

func connect_signals() -> void :
	for i in range(3) :
		player_choices[i].mouse_clicked.connect(_on_choice_selected.bind(i))
	var cards : Array[CharacterCard3D] = []
	cards.append_array(player_choices)
	cards.append_array(opponent_picks)
	cards.append_array(player_picks)
	for card in cards :
		card.mouse_entered.connect(_on_card_mouse_entered.bind(card))
		card.mouse_exited.connect(_on_card_mouse_exited.bind(card))

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
	
	set_choices(host_draft)
	if NetworkManager.is_multiplayer : 
		set_choices.rpc(client_draft)
	else : 
		client_choice = client_draft[GameManager.rng.randi_range(0, client_draft.size() - 1)]

@rpc("authority", "call_remote")
func set_choices(char_indexes : Array) -> void :
	selected_choice = -1
	waiting_for_opponent = false
	cur_choices = []
	cur_choices.append_array(char_indexes)
	display_choices()

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
	display_picks()
	if GameManager.player.get_characters().size() == 3 :
		GameManager.set_game_state(GameManager.GameState.DECKBUILDING)

func display_choices() -> void :
	for i in range(cur_choices.size()) :
		player_choices[i].character = character_pool[cur_choices[i]]
		player_choices[i].set_overlay(null)
	info_popup = null

func display_picks() -> void :
	for i in range(GameManager.player.get_characters().size()) :
		player_picks[i].character = GameManager.player.get_character(i)
		opponent_picks[i].character = GameManager.opponent.get_character(i)
	info_popup = null

func _on_choice_selected(choice_index : int) -> void :
	if waiting_for_opponent : return
	selected_choice = choice_index
	%SubmitButton.disabled = false
	for i in range(player_choices.size()) :
		if i != choice_index : player_choices[i].set_overlay(null)
	player_choices[choice_index].set_overlay(selected_character_fx)

func _on_choice_submitted() -> void : 
	if selected_choice == -1 : return
	waiting_for_opponent = true
	%SubmitButton.disabled = true
	if NetworkManager.is_host : 
		notify_choice(cur_choices[selected_choice])
	else :
		notify_choice.rpc(cur_choices[selected_choice])
	selected_choice = -1

func _on_card_mouse_entered(card : CharacterCard3D) -> void :
	if card.character == null : return
	info_popup = info_popup_scene.instantiate()
	info_popup.add_string(card.character.character_quote)
	info_popup.add_string(card.character.passive.description if card.character.passive != null else "PASSIVE UNIMPLEMENTED")
	info_popup.set_target_rect(card.get_rect())

func _on_card_mouse_exited(character : CharacterCard3D) -> void :
	info_popup = null
