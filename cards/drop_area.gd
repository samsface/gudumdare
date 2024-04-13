extends Area3D
class_name CardDropArea

@export var snap := false
@export var limit := 99999
@export var no_drop := false

func can_drop() -> bool:
	return not no_drop
