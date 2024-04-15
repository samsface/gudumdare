extends Node2D

func _process(delta: float) -> void:
	var mouse_off = (get_local_mouse_position() - Game.SCREEN_SIZE * 0.5)
	%Background.position = mouse_off * 0.01 + Vector2(-30, -20)
	#$Background.position = -mouse_off * 0.02 + Vector2(-30, -20)
	%Foreground.position = -mouse_off * 0.02 + Vector2(-35, -20)
	%Camera2D.position = mouse_off * 0.02 + Game.SCREEN_SIZE * 0.5

func _on_button_quit_pressed() -> void:
	Game.game.open_overworld()
