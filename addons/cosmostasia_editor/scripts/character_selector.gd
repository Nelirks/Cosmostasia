@tool
extends OptionButton

@export_dir var _character_folder : String
var _file_names : Array[String]

signal character_selected(character : CharacterInfo)

func _ready() -> void:
	_refresh_options()
	select(-1)

func _refresh_options() :
	_file_names = []
	clear()
	var dir : DirAccess = DirAccess.open(_character_folder+"/")
	_file_names.append_array(dir.get_files())
	for file in _file_names :
		add_item(file.replace(".tres", "").to_pascal_case())

func _on_item_selected(index: int) -> void:
	character_selected.emit(load(_character_folder + "/" + _file_names[index]))

func select_file(file_name : String) -> void :
	for i in range(_file_names.size()) :
		if _file_names[i] == file_name :
			select(i)
			return

func refresh() -> void :
	_refresh_options()
	select(-1)
