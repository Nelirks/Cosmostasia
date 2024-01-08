extends Node3D
class_name CharacterCard3D

signal mouse_entered()
signal mouse_exited()
signal mouse_clicked()

@onready var card : CharacterCard2D = %CharacterCard2D

var character : Character :
	set(value) : 
		character = value
		card.character = value
		visible = character != null

func _ready():
	character = null

func _on_mouse_entered():
	mouse_entered.emit()

func _on_mouse_exited():
	mouse_exited.emit()

func _on_input_event(camera, event, position, normal, shape_idx):
	var click_event = event as InputEventMouseButton
	if click_event != null and click_event.pressed and click_event.button_index == MOUSE_BUTTON_LEFT :
		mouse_clicked.emit()

func set_overlay(material : Material) -> void :
	card.set_overlay(material)
