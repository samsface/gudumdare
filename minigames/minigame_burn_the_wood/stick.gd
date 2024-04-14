class_name Stick
extends Area2D


signal stick_selected(stick)

var velocity := Vector2.ZERO
var rotation_velocity := 0.0

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("LMB"):
		get_parent().selected_stick = self
		%AudioPop.play()

func _process(delta: float) -> void:
	if get_parent().selected_stick == self:
		var position_previous = position
		global_position = get_global_mouse_position()
		if Input.is_action_just_released("LMB"):
			get_parent().selected_stick = null
			rotation_velocity = randf_range(-1, 1) * velocity.length() / 50.0
			%AudioThrow.play()
			
		var velocity_to = (position - position_previous) / delta
		velocity = lerp(velocity, velocity_to, 0.5)
	else:
		position += velocity * delta
		velocity = velocity.move_toward(Vector2.ZERO, delta * 1000.0)
		rotation += rotation_velocity * delta
		rotation_velocity = move_toward(rotation_velocity, 0, delta * 5.0)
		if position.x < 50:
			position.x = 50
			velocity.x *= -0.7
			GenericTween.squish(self)
			rotation_velocity = randf_range(-1, 1) * velocity.length() / 100.0
		if position.x > Game.SCREEN_SIZE.x-50:
			position.x = Game.SCREEN_SIZE.x-50
			velocity.x *= -0.7
			GenericTween.squish(self)
			rotation_velocity = randf_range(-1, 1) * velocity.length() / 100.0
		if position.y < 50:
			position.y = 50
			velocity.y *= -0.7
			GenericTween.squish(self)
			rotation_velocity = randf_range(-1, 1) * velocity.length() / 100.0
		if position.y > Game.SCREEN_SIZE.y-50:
			position.y = Game.SCREEN_SIZE.y-50
			velocity.y *= -0.7
			GenericTween.squish(self)
			rotation_velocity = randf_range(-1, 1) * velocity.length() / 100.0


func _on_mouse_entered() -> void:
	modulate = Color.LIGHT_GOLDENROD * 2.0


func _on_mouse_exited() -> void:
	modulate = Color.WHITE
