extends OverlayVFX

@export var duration : float
@export var parameter_name : String

var elapsed_time : float = 0

func _process(delta):
	elapsed_time += delta
	if duration > 0.00001 and elapsed_time > duration :
		queue_free()
		return
	(material as ShaderMaterial).set_shader_parameter(parameter_name, elapsed_time)
