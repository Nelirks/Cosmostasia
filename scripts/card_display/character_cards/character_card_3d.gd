extends Node3D
class_name CharacterCard3D

signal mouse_entered()
signal mouse_exited()
signal mouse_clicked()

@onready var card_2d : CharacterCard2D = %CharacterCard2D

var hovered : bool = false

var character : Character :
	set(value) : 
		character = value
		card_2d.character = value
		visible = character != null

func _ready():
	character = null

func _on_mouse_entered():
	hovered = true
	mouse_entered.emit()

func _on_mouse_exited():
	hovered = false
	mouse_exited.emit()

func _on_input_event(camera, event, position, normal, shape_idx):
	var click_event = event as InputEventMouseButton
	if click_event != null and click_event.pressed and click_event.button_index == MOUSE_BUTTON_LEFT :
		mouse_clicked.emit()
	var motion_event = event as InputEventMouseMotion

func _physics_process(delta):
	var rect_on_screen : Rect2 = get_rect(get_tree().root.get_camera_3d())
	var relative_mouse_position = 2.0 * (get_tree().root.get_mouse_position() - get_rect(get_tree().root.get_camera_3d()).get_center()) / rect_on_screen.size
	var current_rotation : Quaternion = Quaternion(%CardDisplay.transform.basis)
	var target_rotation : Quaternion
	if hovered :
		target_rotation = Quaternion(Vector3(relative_mouse_position.y, relative_mouse_position.x, 0).normalized(), -50)
	%CardDisplay.transform.basis = Basis(current_rotation.slerp(target_rotation, 0.2))

func set_overlay(material : Material) -> void :
	card_2d.set_overlay(material)

func get_rect(camera : Camera3D) -> Rect2 :
	var center_pos : Vector3 = %FrontSide.global_position
	var card_size : Vector2 = %FrontSide.get_item_rect().size * %FrontSide.pixel_size
	var begin_pos : Vector2 = camera.unproject_position(center_pos - 0.5 * Vector3(card_size.x, -card_size.y, 0))
	var end_pos : Vector2 = camera.unproject_position(center_pos + 0.5 * Vector3(card_size.x, -card_size.y, 0))
	return Rect2(begin_pos, end_pos - begin_pos)
