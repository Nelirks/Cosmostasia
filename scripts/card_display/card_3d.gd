extends Node3D
class_name Card3D

signal mouse_entered()
signal mouse_exited()
signal mouse_clicked()

@export var rotation_angle : float
@export var rotation_speed : float

@export var rotates_on_hover : bool = true

var hovered : bool = false

@onready var _front_side : Control = %FrontViewport.get_child(0) if %FrontViewport.get_child_count() > 0 else null

@onready var _back_side : Control = %BackViewport.get_child(0) if %BackViewport.get_child_count() > 0 else null

var tween : Tween

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

func _physics_process(delta):
	if rotation_angle < 0.0001 or rotation_speed < 0.0001 or !rotates_on_hover : return
	var current_rotation : Quaternion = Quaternion(%CardDisplay.transform.basis)
	var target_rotation : Quaternion
	if hovered :
		var rect_on_screen : Rect2 = get_rect()
		var relative_mouse_position = (get_tree().root.get_mouse_position() - rect_on_screen.get_center())
		var effective_rotation_angle = rotation_angle * relative_mouse_position.length()/(rect_on_screen.size.length()/2.0)
		target_rotation = Quaternion(Vector3(relative_mouse_position.y, relative_mouse_position.x, 0).normalized(), effective_rotation_angle)
	%CardDisplay.transform.basis = Basis(current_rotation.slerp(target_rotation, rotation_speed))

func get_rect() -> Rect2 :
	var camera = get_viewport().get_camera_3d()
	var center_pos : Vector3 = %FrontSide.global_position
	var card_size : Vector2 = %FrontSide.get_item_rect().size * %FrontSide.pixel_size * Vector2(global_transform.basis.get_scale().x, global_transform.basis.get_scale().y)
	var begin_pos : Vector2 = camera.unproject_position(center_pos - 0.5 * Vector3(card_size.x, -card_size.y, 0))
	var end_pos : Vector2 = camera.unproject_position(center_pos + 0.5 * Vector3(card_size.x, -card_size.y, 0))
	return Rect2(begin_pos, end_pos - begin_pos)

func flip(flipped : bool = true, duration : float = 0.0) -> void :
	if duration < 0.001 :
		rotation = Vector3(rotation.x, PI if flipped else 0, rotation.y)
	else :
		var rotation_tween = create_tween()
		rotation_tween.tween_property(self, "rotation", Vector3(rotation.x, PI if flipped else 0, rotation.z), duration)
