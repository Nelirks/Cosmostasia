@tool
extends OptionButton

var target_folder : String :
	set(value) :
		target_folder = value
		refresh()

var _file_names : Array[String]

signal character_selected(character : CharacterInfo)

func _ready() -> void:
	refresh()

func refresh() :
	_file_names = []
	clear()
	var dir : DirAccess = DirAccess.open(target_folder+"/")
	_file_names.append_array(dir.get_files())
	for file in _file_names :
		add_item(file.replace(".tres", "").to_pascal_case())
	select(-1)
	character_selected.emit(null)

func _on_item_selected(index: int) -> void:
	character_selected.emit(load(target_folder + "/" + _file_names[index]))

func select_file(file_name : String) -> void :
	for i in range(_file_names.size()) :
		if _file_names[i] == file_name :
			select(i)
			character_selected.emit(load(target_folder + "/" + _file_names[i]))
			return
	character_selected.emit(null)
