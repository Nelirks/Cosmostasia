@tool
extends Control

var _character : CharacterInfo :
	set(value) :
		_character = value
		_update_fields()

func _ready() -> void:
	_update_fields()

func _on_character_selected(character : CharacterInfo) -> void:
	_character = character

func _update_fields() -> void :
	($EditPanel as Control).visible = _character != null
	if _character != null :
		for field in %EditContainer.find_children("", "DataField", true) :
			field.set_value(_character.get(field.property_name))

func _on_save_button_pressed() -> void:
	if _character == null : return
	for field in %EditContainer.find_children("", "DataField", true) :
		_character.set(field.property_name, field.get_value())

func _on_create_button_pressed() -> void :
	(%CreatePathSelector as FileDialog).popup()

func _on_create_path_selected(path : String) -> void :
	_character = CharacterInfo.new()
	ResourceSaver.save(_character, path)
	%CharacterSelector.select_file(path.get_slice("/", path.get_slice_count("/") - 1))
