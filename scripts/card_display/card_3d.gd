extends Node3D
class_name Card3D

signal mouse_entered()
signal mouse_exited()
signal mouse_clicked()

@export var rotation_angle : float
@export var rotation_speed : float

var hovered : bool = false

var _front_side : Control :
	set(value) :
		if _front_side != null : _front_side.queue_free()
		_front_side = value
		if _front_side != null : 
			%FrontViewport.add_child(value)
			_front_side.position = Vector2(0,0)
		
var _back_side : Control :
	set(value) :
		if _back_side != null : _back_side.queue_free()
		_back_side = value
		if _back_side != null : 
			%BackViewport.add_child(value)
			_back_side.position = Vector2(0,0)

func _ready():
	_front_side = null
	_back_side = null

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
	if rotation_angle < 0.0001 or rotation_speed < 0.0001 : return
	var rect_on_screen : Rect2 = get_rect(get_tree().root.get_camera_3d())
	var relative_mouse_position = (get_tree().root.get_mouse_position() - get_rect(get_tree().root.get_camera_3d()).get_center())
	var current_rotation : Quaternion = Quaternion(%CardDisplay.transform.basis)
	var target_rotation : Quaternion
	if hovered :
		target_rotation = Quaternion(Vector3(relative_mouse_position.y, relative_mouse_position.x, 0).normalized(), -rotation_angle)
	%CardDisplay.transform.basis = Basis(current_rotation.slerp(target_rotation, rotation_speed))

func get_rect(camera : Camera3D) -> Rect2 :
	var center_pos : Vector3 = %FrontSide.global_position
	var card_size : Vector2 = %FrontSide.get_item_rect().size * %FrontSide.pixel_size * Vector2(scale.x, scale.y)
	var begin_pos : Vector2 = camera.unproject_position(center_pos - 0.5 * Vector3(card_size.x, -card_size.y, 0))
	var end_pos : Vector2 = camera.unproject_position(center_pos + 0.5 * Vector3(card_size.x, -card_size.y, 0))
	return Rect2(begin_pos, end_pos - begin_pos)
