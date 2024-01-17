extends Control
class_name InfoPopup

var info_box_scene : PackedScene = preload("res://scenes/info_popup/info_box.tscn")



func set_content(messages : Array[String]) -> void :
	visible = true
	for message in messages : 
		var info_box : InfoBox = info_box_scene.instantiate()
		info_box.set_text(message)
		add_child(info_box)

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
