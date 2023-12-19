extends Node
class_name CharacterDeckEditor

var _card_amount_editor_scene : PackedScene = preload("res://scenes/deckbuilding_phase/card_amount_editor.tscn")

var character : Character :
	set(value) :
		character = value
		for i in range(5) :
			$CardAmountEditors.get_child(i).card = character.card_pool[i]
		for i in range(3) :
			$PresetSelector.get_child(i).text = character.deck_presets[i].preset_name if character.deck_presets.size() > 0 else "PLACEHOLDER"
		on_preset_selected(0)

func on_preset_selected(preset_index : int) -> void :
	if character.deck_presets.size() == 0 :
		for card_amount_editor in $CardAmountEditors.get_children() :
			card_amount_editor.amount = 2
	else :
		for card_index in range(character.card_pool.size()) :
			$CardAmountEditors.get_child(card_index).amount = character.deck_presets[preset_index].content[card_index]

func apply() -> void :
	var deck : Array[Card] = []
	for card_index in range(character.card_pool.size()) :
		for card_count in range($CardAmountEditors.get_child(card_index).amount) :
			deck.append(character.card_pool[card_index].duplicate())
	character.deck = deck
