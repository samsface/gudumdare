extends Control


func _ready() -> void:
	modulate = Color.TRANSPARENT
var t := 0.0
func _process(delta: float) -> void:
	modulate = lerp(modulate, Color.WHITE, delta * 10.0)
	t += delta * 2.0
	rotation += sin(t * 0.5) * delta * 0.2
