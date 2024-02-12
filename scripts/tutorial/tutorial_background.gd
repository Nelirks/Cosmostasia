extends Control

const t_popup = preload("res://scenes/tutorial/tutorial_popup.tscn")

func init(data:tutorial_data):
	var popup = t_popup.instantiate()
	popup.init(data.text)
	add_child(popup)

