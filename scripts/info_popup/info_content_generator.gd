extends Node

@export_dir var status_dir_path : String

var status_descriptions : Dictionary
@export var keyword_descriptions : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	init_status_descriptions()
	print(add_info([], "Inflige 20 dégâts, applique 2 effets de !S!Attaque Réduite!S! et un effet de !S!Étourdissement!S!"))

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

func get_card_info(card : Card) -> Array[String] :
	return []

func develop_string(message : String, separator : String, dictionary : Dictionary) -> String :
	if message.find(separator) == -1 : return ""
	var submessage = message.split(separator)[1]
	if status_descriptions.keys().find(submessage.to_lower()) != -1 :
		return status_descriptions[submessage.to_lower()]
	else :
		printerr("Cannot find status description")
		return ""

func add_info(array : Array[String], message : String) -> Array[String] :
	if array.find(message) != -1 : return array
	var insert_index = array.size()
	
	var additional_message = develop_string(message, "!K!", keyword_descriptions)
	while additional_message != "" :
		message = "".join(message.split("!K!", true, 2))
		array = add_info(array, additional_message)
		additional_message = develop_string(message, "!K!", keyword_descriptions)
	
	additional_message = develop_string(message, "!S!", status_descriptions)
	while additional_message != "" :
		message = "".join(message.split("!S!", true, 2))
		array = add_info(array, additional_message)
		additional_message = develop_string(message, "!S!", status_descriptions)
	
	array.insert(insert_index, message)
	return array
