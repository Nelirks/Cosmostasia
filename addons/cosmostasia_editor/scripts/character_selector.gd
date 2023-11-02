@tool
extends OptionButton

@export_dir var _character_folder : String
var _file_names : Array[String]

var character : CharacterInfo

signal character_selected()

func _ready() -> void:
	_refresh_options()
	select(-1)

func _refresh_options() :
	clear()
	var dir : DirAccess = DirAccess.open(_character_folder+"/")
	_file_names.append_array(dir.get_files())
	for file in _file_names :
		add_item(file.replace(".tres", "").to_pascal_case())

func _on_item_selected(index: int) -> void:
	character = load(_character_folder + "/" + _file_names[index])
	character_selected.emit()
