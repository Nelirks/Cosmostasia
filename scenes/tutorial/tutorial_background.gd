extends Control

const t_popup = preload("res://scenes/tutorial/tutorial_popup.tscn")

func init(data:tutorial_data, pos:Vector2):
	var popup = t_popup.instantiate()
	popup.init(data.text,pos)
	add_child(popup)
	
	
	popup.position.x = pos.x - popup.size.x/2
	popup.position.y = pos.y - popup.size.y/2

