extends Node

var _character_deck_editor_scene : PackedScene = preload("res://scenes/deckbuilding_phase/character_deck_editor.tscn")

func _ready():
	for i in range(3) :
		$CharacterDeckEditors.get_child(i).character = GameManager.player.get_character(i)


func _on_apply():
	for editor in $CharacterDeckEditors.get_children() :
		editor.apply()
	GameManager.set_game_state(GameManager.GameState.COMBAT)
