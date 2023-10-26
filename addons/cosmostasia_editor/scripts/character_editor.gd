@tool
extends Control

@onready var _character_selector = %CharacterSelector

func _on_character_selected() -> void:
	for field in %EditContainer.find_children("", "DataField", true) :
		field.set_value(_character_selector.character.get(field.property_name))

func _on_save_button_pressed() -> void:
	save()

func save() -> void :
	if _character_selector.character == null : return
	for field in %EditContainer.find_children("", "DataField", true) :
		_character_selector.character.set(field.property_name, field.get_value())
