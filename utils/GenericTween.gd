extends Node
class_name GenericTween

static func shake(node:Node2D, cycles := 5) -> Tween:
	var tween = node.create_tween()
	for i in cycles:
		tween.tween_property(node, "position:x", - 5, 0.06).as_relative().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(node, "position:x", + 5, 0.06).as_relative().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	return tween


static func squish(node:Node2D) -> Tween:
	var tween = node.create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(node, "scale", Vector2(0.95, 1.05), 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2(1.02, 0.98), 0.1).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "scale", Vector2.ONE, 0.1).set_ease(Tween.EASE_IN_OUT)
	
	return tween

static func attack(node:Node2D, direction_to_target:Vector2) -> Tween:
	var tween = node.create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(node, "position", direction_to_target * 20.0, 0.05)
	tween.tween_property(node, "position", Vector2.ZERO, 0.2)
	
	return tween

static func flash_red(node:Node2D) -> Tween:
	var tween = node.create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(node, "modulate", Color.RED, 0.0)
	tween.tween_property(node, "modulate", Color.WHITE, 0.2)
	
	return tween
