@tool
extends ResourceSelector

func _create_resource() -> Resource :
	return CharacterInfo.new()
