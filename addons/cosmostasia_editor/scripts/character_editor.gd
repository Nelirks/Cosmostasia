@tool
extends Control
class_name CharacterEditor

@export_dir var character_folder : String

var _character : CharacterInfo :
	set(value) :
		_character = value
		if _character_fields != null : _character_fields.character = _character
		if _card_editor != null : _card_editor.character = _character

@onready var _character_selector : ResourceSelector = %CharacterSelector
@onready var _character_fields : CharacterFields = %CharacterFields
@onready var _card_editor : CardEditor = %CardEditor

func _ready() -> void:
	_character_selector.target_folder = character_folder
	_character_fields.character = _character
	_card_editor.character = _character

func _on_character_selected(character : Resource) -> void:
	if character != null and not character is CharacterInfo :
		print("Cannot select non CharacterInfo resources")
	_character = character as CharacterInfo
