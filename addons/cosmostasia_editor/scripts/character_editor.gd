@tool
extends Control
class_name CharacterEditor

@export_dir var character_folder : String

var _character : CharacterInfo :
	set(value) :
		_character = value
		if _character_fields != null : _character_fields.update_fields(_character)

@onready var _character_selector : ResourceSelector = %CharacterSelector
@onready var _character_fields : CharacterFields = %CharacterFields

func _ready() -> void:
	_character_selector.target_folder = character_folder
	_character_fields.update_fields(_character)

func _on_character_selected(character : Resource) -> void:
	if character != null and not character is CharacterInfo :
		print("Cannot select non CharacterInfo resources")
	_character = character as CharacterInfo
	if _character_fields != null :
		_character_fields.update_fields(_character)

func _on_character_fields_query_save(data : Dictionary) -> void:
	if _character == null :
		printerr("Cannot save while character is null")
	for key in data.keys() :
		_character.set(key, data[key])
