extends Control
class_name InfoPopup

var infobox_scene : PackedScene = preload("res://scenes/info_popup/info_box.tscn")

func add_string(message : String, display_initial : bool = true) -> void :
	var developped_message : String = DescriptionHandler.develop_tags(message)
	for info_box in get_children() :
		if info_box.text == developped_message :
			return
	if display_initial : 
		visible = true
		var info_box : InfoBox = infobox_scene.instantiate()
		info_box.text = developped_message
		add_child(info_box)
		
	for str in DescriptionHandler.develop_string(message) : add_string(str)

func set_target_rect(target_rect : Rect2) -> void :
	var rect : Rect2 = get_global_rect()
	var window_rect : Rect2 = Rect2(Vector2(0, 0), get_window().size)
	if rect.size.x + target_rect.end.x <= window_rect.size.x or target_rect.position.x - rect.size.x < window_rect.position.x :
		global_position.x = target_rect.end.x
	else : 
		global_position.x = target_rect.position.x - rect.size.x
	set_y_position.call_deferred(target_rect.position.y)

func set_y_position(target_y_position : int) -> void :
	var height : float = 32
	for child in get_children() : height += child.get_height()
	global_position.y = clamp(0, target_y_position, get_window().size.y - height)
