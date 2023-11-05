@tool
extends Control
class_name ResourceFileSelector

@onready var _file_selector : FileDialog = %FileSelector
@onready var _resource_picker : ResourceFilePicker = %ResourcePicker
@onready var _resource_path_label : Label = %ResourcePathLabel

@export_dir var target_folder : String

signal _resource_selected(_resource : Resource)

var _resource : Resource :
	set(value) :
		_resource = value
		_resource_selected.emit(_resource)
		if _resource_path_label != null :
			_resource_path_label.text = "" if _resource == null else _resource.resource_path
		

func _ready() -> void:
	_file_selector.root_subfolder = target_folder
	_resource_picker.target_folder = target_folder
	_resource_path_label.text = "" if _resource == null else _resource.resource_path

func _on_resource_picked(resource : Resource) -> void:
	self._resource = resource

func _on_create_button_pressed() -> void :
	_file_selector.file_selected.connect(_on_create_file_selected)
	_file_selector.popup()

func _on_create_file_selected(path : String) -> void :
	_resource = CharacterInfo.new()
	ResourceSaver.save(_resource, path)
	_resource_picker.refresh()
	_resource_picker.select_file(path.get_slice("/", path.get_slice_count("/") - 1))
	_file_selector.file_selected.disconnect(_on_create_file_selected)

func _on_refresh_button_pressed() -> void:
	_resource_picker.refresh()
	_resource = null

func _create_resource() -> Resource :
	printerr("Resource Selectors must be overriden to allow _resource creation")
	return null
