extends Area2D

signal samurai_ready()
signal samurai_attacked()

@export var contactArea: RectangleShape2D
@export var max_x: Node2D
@export var min_x: Node2D

var mouse_is_pressed = false
var is_samurai_ready = false

func _process(delta):
	if (global_position.x >= max_x.position.x):
		is_samurai_ready = true
		samurai_ready.emit()
	
	if (is_samurai_ready):
		if (global_position.x <= min_x.position.x):
			samurai_attacked.emit()
			is_samurai_ready = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouse and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		if (mouse_pos.x < max_x.position.x && mouse_pos.x > min_x.position.x):
			global_position.x = get_global_mouse_position().x
		elif (mouse_pos.x > max_x.position.x):
			global_position.x = max_x.position.x
		elif (mouse_pos.x < min_x.position.x):
			global_position.x = min_x.position.x
