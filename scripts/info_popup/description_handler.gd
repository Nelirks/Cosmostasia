extends Node

@export_dir var status_dir_path : String

var status_descriptions : Dictionary
@export_multiline var keyword_descriptions : Dictionary

@export_color_no_alpha var status_color : Color
@export_color_no_alpha var keyword_color : Color

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
				for display_name in status.display_names :
					status_descriptions[display_name.to_lower()] = status.description
			file_name = status_dir.get_next()
	else:
		printerr("An error occurred when trying to access the path.")

func init_keyword_descriptions() -> void :
	for key in keyword_descriptions.keys() :
		if key != key.to_lower() :
			keyword_descriptions[key.to_lower()] = keyword_descriptions[key]
			keyword_descriptions.erase(key)

func develop_string(message : String) -> Array[String] :
	var results : Array[String] = []
	for keyword in extract(message, "!K!") :
		results.append(keyword_descriptions.get(keyword.to_lower(), keyword + " keyword not found"))
	for status in extract(message, "!S!") : 
		results.append(status_descriptions.get(status.to_lower(), status + " status not found"))
	return results

func extract(str : String, separator : String) -> PackedStringArray :
	var splitted_str : PackedStringArray = str.split(separator)
	for i in range(splitted_str.size()-1, -1, -2) : 
		splitted_str.remove_at(i)
	return splitted_str

func develop_tags(str : String) -> String :
	while str.contains("!S!") :
		str = ("[color=" + status_color.to_html() + "]").join(str.split("!S!", true, 1))
		str = "[/color]".join(str.split("!S!", true, 1))
	while str.contains("!K!") :
		str = ("[color=" + keyword_color.to_html() + "]").join(str.split("!K!", true, 1))
		str = "[/color]".join(str.split("!K!", true, 1))
	return str
