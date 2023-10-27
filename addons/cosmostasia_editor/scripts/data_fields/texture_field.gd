@tool
extends DataField

@export_dir var dir_path : String :
	set(value) :
		dir_path = value
		if _file_dialog :
			_file_dialog.root_subfolder = dir_path

@onready var _label : Label = %Label
@onready var _texture_display : TextureRect = %TextureDisplay
@onready var _file_dialog : FileDialog = %FileDialog

var _texture : Texture2D :
	set(value) :
		_texture = value
		_texture_display.texture = value

func _ready() -> void:
	_file_dialog.root_subfolder = dir_path
	_label.text = property_name.to_pascal_case()

func _on_property_name_set(value : String) -> void :
	if _label != null :
		_label.text = value.to_pascal_case()

func set_value(value : Texture2D) -> void :
	_texture = value

func get_value() -> Texture2D : 
	return _texture

func _on_select_file_button_pressed() -> void:
	_file_dialog.popup_centered()

func _on_file_selected(path: String) -> void:
	_texture = load(path)

func _on_remove_file_button_pressed() -> void:
	_texture = null
