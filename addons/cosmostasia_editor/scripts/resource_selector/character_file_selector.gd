@tool
extends ResourceFileSelector

func _create_resource() -> Resource :
	return CharacterInfo.new()
