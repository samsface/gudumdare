extends Sprite2D

func animate() -> void:
	$SweepSound.play()
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(material, "shader_parameter/ttl", 1.0, 0.2)
	tween.tween_property(material, "shader_parameter/ttl", 0.0, 0.3)

