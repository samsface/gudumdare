class_name Stick
extends Area2D


signal stick_selected(stick)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("LMB"):
		stick_selected.emit(self)
