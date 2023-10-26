@tool
extends MenuBar

@export_dir var _character_folder : String
var _file_names : Array[String]
@onready var _popup_menu : PopupMenu = $PopupMenu

var character : CharacterInfo

signal character_selected()

func _ready() -> void:
	_refresh_options()

func _refresh_options() :
	_popup_menu.clear()
	var dir : DirAccess = DirAccess.open(_character_folder+"/")
	_file_names.append_array(dir.get_files())
	for file in _file_names :
		_popup_menu.add_item(file.replace(".tres", "").to_pascal_case())

func _on_popup_menu_id_pressed(id: int) -> void:
	character = load(_character_folder + "/" + _file_names[id])
	character_selected.emit()
