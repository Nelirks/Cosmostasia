extends CanvasLayer

const t_popup = preload("res://scenes/tutorial/tutorial_popup.tscn")

@export var stored_data:tutorial_data = null

func init(data:tutorial_data):
	stored_data = data
	var popup = t_popup.instantiate()
	popup.init(data.text)
	$Panel.add_child(popup)



func _on_panel_pressed():
	TutorialGlobal.next()
	self.queue_free()
