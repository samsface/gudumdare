extends Control

signal done

func _hand_area_child_entered_tree(node: Node) -> void:
	if not node is CardEx:
		return

	%NewCardArea.visible = false
	%LocationName.text = "[jiggle amp=0.4 freq=0.5][center]Great choice![/center][/jiggle]"
	%ArrowInstruction.visible = false
	%AudioPicked.play()
	await get_tree().create_timer(1.0).timeout
	
	done.emit()
