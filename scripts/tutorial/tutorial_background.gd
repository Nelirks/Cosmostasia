extends CanvasLayer

const t_popup = preload("res://scenes/tutorial/tutorial_popup.tscn")

func init(data:tutorial_data):
	var popup = t_popup.instantiate()
	popup.init(data.text)
	add_child(popup)



func _on_panel_pressed():
	TutorialGlobal.next()
	queue_free()
