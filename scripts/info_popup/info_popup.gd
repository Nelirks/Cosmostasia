extends Control
class_name InfoPopup

var infobox_scene : PackedScene = preload("res://scenes/info_popup/info_box.tscn")

func add_string(message : String) -> void :
	var developped_message : String = develop_tags(message)
	for info_box in get_children() :
		if info_box.text == developped_message :
			return
	
	visible = true
	
	var info_box : InfoBox = infobox_scene.instantiate()
	info_box.text = developped_message
	add_child(info_box)
	develop_string(message)

func develop_string(message : String) -> void :
	for keyword in extract(message, "!K!") :
		add_string(DescriptionData.keyword_descriptions.get(keyword.to_lower(), keyword + " keyword not found"))
	for status in extract(message, "!S!") : 
		add_string(DescriptionData.status_descriptions.get(status.to_lower(), status + " status not found"))

func extract(str : String, separator : String) -> PackedStringArray :
	var splitted_str : PackedStringArray = str.split(separator)
	for i in range(splitted_str.size()-1, -1, -2) : 
		splitted_str.remove_at(i)
	return splitted_str

func develop_tags(message : String) -> String :
	while message.contains("!S!") :
		print(message.split("!S!", true, 1))
		message = ("[color=" + DescriptionData.status_color.to_html() + "]").join(message.split("!S!", true, 1))
		print(message)
		message = "[/color]".join(message.split("!S!", true, 1))
	while message.contains("!K!") :
		message = ("[color=" + DescriptionData.keyword_color.to_html() + "]").join(message.split("!K!", true, 1))
		message = "[/color]".join(message.split("!K!", true, 1))
	return message

func set_target_rect(target_rect : Rect2) -> void :
	var rect : Rect2 = get_global_rect()
	var window_rect : Rect2 = Rect2(Vector2(0, 0), get_window().size)
	global_position.y = clamp(0, target_rect.position.y, window_rect.size.y - rect.size.y)
	if rect.size.x + target_rect.end.x <= window_rect.size.x or target_rect.position.x - rect.size.x < window_rect.position.x :
		global_position.x = target_rect.end.x
	else : 
		global_position.x = target_rect.position.x - rect.size.x
