extends Sprite2D

@export var red = 1.0
@export var green = 0.0
@export var blue = 0.0

func animate() -> void:
	$SweepSound.play()
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(material, "shader_parameter/ttl", 0.0, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	material.set_shader_parameter("color_r", red)
	material.set_shader_parameter("color_g", green)
	material.set_shader_parameter("color_b", blue)

