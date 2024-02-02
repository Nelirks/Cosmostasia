extends Node3D

@export var dusts : Array[GPUParticles3D]

func _on_timer_timeout():
	var random_number : int = randi_range(0, dusts.size()-1)
	dusts[random_number].emitting = true
