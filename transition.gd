extends CanvasLayer

signal closed

func close():
	visible = true
	var tween = create_tween()
	tween.tween_method(%TransitionCircle.material.set_shader_parameter, 0.0, 1.0, 1.0)
	await tween.finished
	closed.emit()

func open():
	var tween = create_tween()
	tween.tween_method(%TransitionCircle.material.set_shader_parameter, 1.0, 0.0, 2)
	await tween.finished
	visible = false
