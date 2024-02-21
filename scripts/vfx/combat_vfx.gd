extends Node3D
class_name CombatVFX

@export var animator : AnimationPlayer
@export var animation_name : String
@export var lifetime : float

func play():
	animator.play(animation_name)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func set_context(source_position : CharacterCard3D, target_position : CharacterCard3D) :
	position = Vector3.ZERO
