extends CanvasLayer

signal closed

var open_value := 0.0
var tweening := false

func set_circle_position(position):
	position /= Game.SCREEN_SIZE
	%TransitionCircle.material.set_shader_parameter("pos", position)

func close():
	%AudioSwish.play()
	visible = true
	var tween = create_tween()
	tweening = true
	tween.tween_property(self, "open_value", 0.0, 0.45).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(0.1)
	await tween.finished
	closed.emit()

func _process(delta: float) -> void:
	if tweening:
		%TransitionCircle.material.set_shader_parameter("open", open_value)

func open():
	%AudioSwoosh.play()
	set_circle_position(Game.SCREEN_SIZE * 0.5)
	var tween = create_tween()
	tween.tween_property(self, "open_value", 1.0, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	visible = false
	tweening = false
