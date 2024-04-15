@tool
extends Node2D

var tween:Tween

@export_range(0.0, 1.0) var power :
	set(v):
		power = v
		invalidate()

func invalidate() -> void:
	if get_child_count() == 0:
		return

	for c in get_children():
		c.visible = false
	
	var idx = floor(power * get_child_count())
	idx = clamp(idx, 0, get_child_count() - 1)
	
	get_child(idx).visible = true
	
	if tween:
		tween.kill()
	tween = GenericTween.squish(get_child(idx))
	
