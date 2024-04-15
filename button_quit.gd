extends Button


func _on_pressed() -> void:
	Game.game.open_overworld()
	$AudioPress.play()


func _on_mouse_entered() -> void:
	$AudioHover.play()
