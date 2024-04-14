extends Sprite2D

func _ready() -> void:
	scale = Vector2.ZERO
func _process(delta: float) -> void:
	rotation += delta
	
	scale = scale.lerp(Vector2.ONE * 4.0, delta * 2.0)
