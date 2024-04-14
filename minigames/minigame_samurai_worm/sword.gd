extends Button

signal samurai_ready()
signal samurai_attacked()

@export var contactArea: RectangleShape2D
@export var max_x: Node2D
@export var min_x: Node2D

var mouse_is_pressed = false
var is_samurai_ready = true

func _physics_process(delta: float) -> void:
	if button_pressed:
		var mouse_pos = get_global_mouse_position()
		if (mouse_pos.x < max_x.position.x && mouse_pos.x > min_x.position.x):
			$Sprite2D.global_position.x = get_global_mouse_position().x
		elif (mouse_pos.x > max_x.position.x):
			$Sprite2D.global_position.x = max_x.position.x
		elif (mouse_pos.x < min_x.position.x):
			$Sprite2D.global_position.x = min_x.position.x

	if (is_samurai_ready):
		if ($Sprite2D.global_position.x <= min_x.position.x):
			samurai_ready.emit()
			is_samurai_ready = false

	if not is_samurai_ready and $Sprite2D.global_position.x >= max_x.position.x:
		is_samurai_ready = true
		samurai_attacked.emit()
	
