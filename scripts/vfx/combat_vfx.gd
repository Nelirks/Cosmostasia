extends Node3D
class_name CombatVFX

@export var animator : AnimationPlayer
@export var animation_name : String

func _ready():
	animator.play(animation_name)

func set_context(source_position : Vector3, target_position : Vector3) :
	position = Vector3.ZERO
