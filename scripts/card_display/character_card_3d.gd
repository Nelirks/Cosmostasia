extends Card3D
class_name CharacterCard3D

var card_2d_scene = preload("res://scenes/card_display/character_card_2d.tscn")

@export var dissolve_material : ShaderMaterial
@export var dissolve_duration : float

@export var is_combat_display : bool

var character : Character : 
	set(value) : 
		if _front_side == null : _front_side = card_2d_scene.instantiate()
		_front_side.character = value
		visible = character != null
	get :
		return _front_side.character if _front_side != null else null

func play_overlay(overlay : PackedScene, source) -> void :
	_front_side.play_overlay(overlay, source)

func stop_overlay(source) -> void :
	_front_side.stop_overlay(source)


func _ready():
	visible = character != null
	_front_side.is_combat_display = is_combat_display

func dissolve() -> void :
	_front_side.material = dissolve_material
	%BackSide.visible = false
	_front_side.stop_overlay(_front_side)
	var tween = create_tween()
	tween.tween_method(func(value) : dissolve_material.set_shader_parameter("Progress", value), 0.0, 1.0, dissolve_duration)
