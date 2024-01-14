extends Node

var _character_deck_editor_scene : PackedScene = preload("res://scenes/deckbuilding_phase/character_deck_editor.tscn")

var host_presets : Array = []
var client_presets : Array = []

func _ready():
	for i in range(3) :
		$CharacterDeckEditors.get_child(i).character = GameManager.player.get_character(i)


func _on_apply():
	var presets : Array[int]
	for editor in $CharacterDeckEditors.get_children() :
		presets.append(editor.preset_index)
	if NetworkManager.is_host : 
		notify_preset_choice(presets)
	else :
		notify_preset_choice.rpc(presets)


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
