@tool
extends OptionButton
class_name ResourcePicker

var target_folder : String :
	set(value) :
		target_folder = value
		refresh()

var _file_names : Array[String]

signal resource_picked(resource : Resource)

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
	resource_picked.emit(null)

func _on_item_selected(index: int) -> void:
	resource_picked.emit(load(target_folder + "/" + _file_names[index]))

func select_file(file_name : String) -> void :
	for i in range(_file_names.size()) :
		if _file_names[i] == file_name :
			select(i)
			resource_picked.emit(load(target_folder + "/" + _file_names[i]))
			return
	resource_picked.emit(null)
