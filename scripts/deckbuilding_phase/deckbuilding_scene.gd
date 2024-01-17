extends Node

var host_presets : Array = []
var client_presets : Array = []

var info_popup_scene : PackedScene = preload("res://scenes/info_popup/info_popup.tscn")
var info_popup : InfoPopup :
	set(value) :
		if info_popup != null :
			info_popup.queue_free()
		info_popup = value
		if info_popup != null :
			%Foreground.add_child(info_popup)

var player_character_selectors : Array[CharacterSelector]
var opponent_character_selectors : Array[CharacterSelector]
var preset_selectors : Array[Button]
var character_display : CharacterCard3D
var card_displays : Array[PlayableCard3D]
var card_amount_displays : Array[Label]

var selected_character_index : int :
	set(value) : 
		selected_character_index = value
		character_display.character = selected_character
		for i in range(3) : 
			preset_selectors[i].text = selected_character.deck_presets[i].preset_name
		for i in range(5) : 
			card_displays[i].card = selected_character.card_pool[i]
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
	player_character_selectors.append_array(%PlayerCharacterSelector.get_children())
	opponent_character_selectors.append_array(%OpponentCharacterSelector.get_children())
	preset_selectors.append_array(%PresetSelector.get_children())
	character_display = %CharacterDisplay
	card_displays.append_array(%CardArea.get_children())
	card_amount_displays.append_array(%CardCounts.get_children())
	
	selected_character_index = 0
	for i in range(3) :
		player_character_selectors[i].set_text(GameManager.player.get_character(i).character_name)
		opponent_character_selectors[i].set_text(GameManager.opponent.get_character(i).character_name)

func on_ally_character_selected(char_index : int) -> void :
	selected_character_index = char_index

func on_opponent_character_hovered(char_index : int) -> void :
	info_popup = info_popup_scene.instantiate()
	info_popup.add_string(GameManager.opponent.get_character(char_index).character_quote)
	info_popup.set_target_rect(opponent_character_selectors[char_index].get_global_rect())

func on_character_card_hovered() -> void :
	info_popup = info_popup_scene.instantiate()
	info_popup.add_string(character_display.character.character_quote)
	info_popup.set_target_rect(character_display.get_rect(%Camera3D))

func on_playable_card_hovered(card_index : int) -> void :
	info_popup = info_popup_scene.instantiate()
	info_popup.add_string(card_displays[card_index].card.card_name)
	info_popup.set_target_rect(card_displays[card_index].get_rect(%Camera3D))

func close_info_popup() -> void :
	info_popup = null

func on_preset_selected(preset_index : int) -> void :
	selected_presets[selected_character_index] = preset_index
	update_card_counts()

func update_card_counts() -> void :
	for i in range(5) : 
		card_amount_displays[i].text = str(selected_character.deck_presets[selected_presets[selected_character_index]].content[i])
