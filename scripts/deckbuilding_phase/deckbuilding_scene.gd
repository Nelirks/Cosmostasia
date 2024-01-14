extends Node

var host_presets : Array = []
var client_presets : Array = []


var selected_character_index : int :
	set(value) : 
		selected_character_index = value
		$CharacterDisplay.character = selected_character
		for i in range(3) : 
			%PresetSelector.get_child(i).text = selected_character.deck_presets[i].preset_name
		for i in range(5) : 
			$CardArea.get_child(i).card = selected_character.card_pool[i]
		update_card_counts()

var selected_character : Character :
	set(value) :
		printerr("Cannot directly set character")
	get :
		return GameManager.player.get_character(selected_character_index)

var selected_presets : Array[int] = [0, 0, 0]

@rpc("any_peer", "call_remote", "reliable")
func notify_preset_choice(presets : Array) -> void : 
	if multiplayer.get_remote_sender_id() == 0 :
		host_presets = presets
		if !NetworkManager.is_multiplayer :
			client_presets = [0, 0, 0]
	else :
		client_presets = presets
	if host_presets.size() > 0 and client_presets.size() > 0 :
		apply_presets.rpc(host_presets, client_presets)

@rpc("authority", "call_local", "reliable")
func apply_presets(host_presets : Array, client_presets : Array) -> void :
	var host : Player = GameManager.get_player(true)
	for char_index in host.get_characters().size() :
		host.get_character(char_index).use_preset(host_presets[char_index])
	
	var client : Player = GameManager.get_player(false)
	for char_index in client.get_characters().size() :
		client.get_character(char_index).use_preset(client_presets[char_index])
		
	GameManager.set_game_state(GameManager.GameState.COMBAT)

func _on_apply() -> void:
	if NetworkManager.is_host : 
		notify_preset_choice(selected_presets)
	else :
		notify_preset_choice.rpc(selected_presets)

func _ready():
	selected_character_index = 0
	for i in range(3) :
		%PlayerCharacterSelector.get_child(i).text = GameManager.player.get_character(i).character_name
		%OpponentCharacterSelector.get_child(i).text = GameManager.opponent.get_character(i).character_name

func on_ally_character_selected(char_index : int) -> void :
	selected_character_index = char_index

func on_preset_selected(preset_index : int) -> void :
	selected_presets[selected_character_index] = preset_index
	update_card_counts()

func update_card_counts() -> void :
	for i in range(5) : 
		%CardCounts.get_child(i).text = str(selected_character.deck_presets[selected_presets[selected_character_index]].content[i])
