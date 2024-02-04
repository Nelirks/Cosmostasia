extends Control

const t_popup = preload("res://scenes/tutorial/tutorial_popup.tscn")

func init(data:tutorial_data, pos:Vector2):
	var popup = t_popup.instantiate()
	popup.init(data.text,pos)
	add_child(popup)


func _on_button_pressed():
	self.queue_free()
