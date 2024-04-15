extends Node2D

func set_frame(frame):
	for child in get_children():
		child.visible = false
	get_child(frame).visible = true
