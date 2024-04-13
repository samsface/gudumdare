extends CanvasLayer

signal closed

var open_value := 0.0
var tweening := false

func set_circle_position(position):
	position /= Game.SCREEN_SIZE
	%TransitionCircle.material.set_shader_parameter("pos", position)

func close():
	visible = true
	var tween = create_tween()
	tweening = true
	tween.tween_property(self, "open_value", 0.0, 0.3)
	await tween.finished
	closed.emit()

func _process(delta: float) -> void:
	if tweening:
		%TransitionCircle.material.set_shader_parameter("open", open_value)

func open():
	set_circle_position(Game.SCREEN_SIZE * 0.5)
	var tween = create_tween()
	tween.tween_property(self, "open_value", 1.0, 0.3)
	await tween.finished
	visible = false
	tweening = false
