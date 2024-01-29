extends Node

signal clicked()

func _on_gui_input(event) -> void :
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT :
		clicked.emit()
