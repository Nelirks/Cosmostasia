extends Node

@export_dir var status_dir_path : String

var status_descriptions : Dictionary
@export var keyword_descriptions : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	init_status_descriptions()
	init_keyword_descriptions()

func init_status_descriptions() -> void :
	var status_dir = DirAccess.open(status_dir_path)
	if status_dir:
		status_dir.list_dir_begin()
		var file_name = status_dir.get_next()
		while file_name != "":
			if not status_dir.current_is_dir():
				var status : StatusEffect = load(status_dir_path + "/" + file_name)
				status_descriptions[status.display_name.to_lower()] = status.description
			file_name = status_dir.get_next()
	else:
		printerr("An error occurred when trying to access the path.")

func init_keyword_descriptions() -> void :
	for key in keyword_descriptions :
		if key != key.to_lower() :
			keyword_descriptions[key.to_lower()] = keyword_descriptions[key]
			keyword_descriptions.erase(key)
