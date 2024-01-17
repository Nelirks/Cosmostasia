extends Control
class_name InfoPopup

var infobox_scene : PackedScene = preload("res://scenes/info_popup/info_box.tscn")

var info_content : Array[String]

func add_string(message : String) -> void :
	if info_content.find(message) != -1 : return
	
	visible = true
	
	var info_box : InfoBox = infobox_scene.instantiate()
	info_box.set_text(message)
	add_child(info_box)
	info_content.append(message)
	develop_infobox(get_child_count() - 1)

func develop_infobox(index : int) -> void :
	for keyword in extract(info_content[index], "!K!") :
		add_string(DescriptionContainer.keyword_descriptions.get(keyword.to_lower(), keyword + " keyword not found"))
	for status in extract(info_content[index], "!S!") : 
		add_string(DescriptionContainer.status_descriptions.get(status.to_lower(), status + " status not found"))
	remove_tags(index)

func extract(str : String, separator : String) -> PackedStringArray :
	var splitted_str : PackedStringArray = str.split(separator)
	for i in range(splitted_str.size()-1, -1, -2) : 
		splitted_str.remove_at(i)
	return splitted_str

func remove_tags(index : int) -> void :
	info_content[index] = "".join(info_content[index].split("!K!"))
	info_content[index] = "".join(info_content[index].split("!S!"))
	get_child(index).set_text(info_content[index])

func set_target_rect(target_rect : Rect2) -> void :
	var rect : Rect2 = get_global_rect()
	var window_rect : Rect2 = Rect2(Vector2(0, 0), get_window().size)
	global_position.y = clamp(0, target_rect.position.y, window_rect.size.y - rect.size.y)
	if rect.size.x + target_rect.end.x <= window_rect.size.x or target_rect.position.x - rect.size.x < window_rect.position.x :
		global_position.x = target_rect.end.x
	else : 
		global_position.x = target_rect.position.x - rect.size.x

func develop() -> void :
	if get_child_count() == 0 : return
	var index : int = 0
	while index < get_child_count() :
		develop_string(get_child(index).text, index)
		index += 1

func develop_string(str : String, position : int = 0) -> void :
	pass
